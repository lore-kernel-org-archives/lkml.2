Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1LDXmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:42:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:63559 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1LDXmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:42:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: alan@linux.intel.com, gregkh@suse.de, scottwood@freescale.com,
        galak@kernel.crashing.org
Cc: linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] serial: add irq handler for Freescale 16550 errata.
Date: Sun,  4 Dec 2011 18:42:23 -0500
Message-Id: <1323042143-25330-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
 <1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending a break on the SOC UARTs found in some MPC83xx/85xx/86xx
chips seems to cause a short lived IRQ storm (/proc/interrupts
typically shows somewhere between 300 and 1500 events).  Unfortunately
this renders SysRQ over the serial console completely inoperable.

The suggested workaround in the errata is to read the Rx register,
wait one character period, and then read the Rx register again.
We achieve this by tracking the old LSR value, and on the subsequent
interrupt event after a break, we don't read LSR, instead we just
read the RBR again and return immediately.

The "fsl,ns16550" is used in the compatible field of the serial
device to mark UARTs known to have this issue.

Thanks to Scott Wood for providing the errata data which led to
a much cleaner fix.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/legacy_serial.c |    3 ++
 drivers/tty/serial/8250_fsl.c       |   63 +++++++++++++++++++++++++++++++++++
 drivers/tty/serial/Kconfig          |    5 +++
 drivers/tty/serial/Makefile         |    1 +
 include/linux/serial_8250.h         |    1 +
 5 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/serial/8250_fsl.c

diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index c7b5afe..3fea368 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -441,6 +441,9 @@ static void __init fixup_port_irq(int index,
 		return;
 
 	port->irq = virq;
+
+	if (of_device_is_compatible(np, "fsl,ns16550"))
+		port->handle_irq = fsl8250_handle_irq;
 }
 
 static void __init fixup_port_pio(int index,
diff --git a/drivers/tty/serial/8250_fsl.c b/drivers/tty/serial/8250_fsl.c
new file mode 100644
index 0000000..f4d3c47
--- /dev/null
+++ b/drivers/tty/serial/8250_fsl.c
@@ -0,0 +1,63 @@
+#include <linux/serial_reg.h>
+#include <linux/serial_8250.h>
+
+#include "8250.h"
+
+/*
+ * Freescale 16550 UART "driver", Copyright (C) 2011 Paul Gortmaker.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This isn't a full driver; it just provides an alternate IRQ
+ * handler to deal with an errata.  Everything else is just
+ * using the bog standard 8250 support.
+ *
+ * We follow code flow of serial8250_default_handle_irq() but add
+ * a check for a break and insert a dummy read on the Rx for the
+ * immediately following IRQ event.
+ *
+ * We re-use the already existing "bug handling" lsr_saved_flags
+ * field to carry the "what we just did" information from the one
+ * IRQ event to the next one.
+ */
+
+int fsl8250_handle_irq(struct uart_port *port)
+{
+	unsigned char lsr, orig_lsr;
+	unsigned long flags;
+	unsigned int iir;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	spin_lock_irqsave(&up->port.lock, flags);
+
+	iir = port->serial_in(port, UART_IIR);
+	if (iir & UART_IIR_NO_INT) {
+		spin_unlock_irqrestore(&up->port.lock, flags);
+		return 0;
+	}
+
+	/* This is the WAR; if last event was BRK, then read and return */
+	if (unlikely(up->lsr_saved_flags & UART_LSR_BI)) {
+		up->lsr_saved_flags &= ~UART_LSR_BI;
+		port->serial_in(port, UART_RX);
+		spin_unlock_irqrestore(&up->port.lock, flags);
+		return 1;
+	}
+
+	lsr = orig_lsr = up->port.serial_in(&up->port, UART_LSR);
+
+	if (lsr & (UART_LSR_DR | UART_LSR_BI))
+		lsr = serial8250_rx_chars(up, lsr);
+
+	serial8250_modem_status(up);
+
+	if (lsr & UART_LSR_THRE)
+		serial8250_tx_chars(up);
+
+	up->lsr_saved_flags = orig_lsr;
+	spin_unlock_irqrestore(&up->port.lock, flags);
+	return 1;
+}
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 925a1e5..aa46993 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -97,6 +97,11 @@ config SERIAL_8250_PNP
 	  This builds standard PNP serial support. You may be able to
 	  disable this feature if you only need legacy serial support.
 
+config SERIAL_8250_FSL
+	bool
+	depends on SERIAL_8250 && PPC
+	default PPC
+
 config SERIAL_8250_HP300
 	tristate
 	depends on SERIAL_8250 && HP300
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index e10cf5b..fb187a3 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SERIAL_8250_BOCA) += 8250_boca.o
 obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554) += 8250_exar_st16c554.o
 obj-$(CONFIG_SERIAL_8250_HUB6) += 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_MCA) += 8250_mca.o
+obj-$(CONFIG_SERIAL_8250_FSL) += 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW) += 8250_dw.o
 obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index b44034e..8f012f8 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -82,6 +82,7 @@ extern void serial8250_do_set_termios(struct uart_port *port,
 		struct ktermios *termios, struct ktermios *old);
 extern void serial8250_do_pm(struct uart_port *port, unsigned int state,
 			     unsigned int oldstate);
+extern int fsl8250_handle_irq(struct uart_port *port);
 int serial8250_handle_irq(struct uart_port *port, unsigned int iir);
 unsigned char serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr);
 void serial8250_tx_chars(struct uart_8250_port *up);
-- 
1.7.7

