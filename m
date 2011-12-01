Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1LAXr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:47:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:33235 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab1LAXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:47:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: gregkh@suse.de, alan@linux.intel.com, galak@kernel.crashing.org,
        scottwood@freescale.com
Cc: linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] 8250: add workaround for MPC8[356]xx UART break IRQ storm
Date: Thu,  1 Dec 2011 18:47:38 -0500
Message-Id: <1322783258-20443-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
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
 arch/powerpc/kernel/legacy_serial.c |   11 +++++++++++
 drivers/tty/serial/8250.c           |   11 ++++++++++-
 include/linux/serial_8250.h         |    5 +++++
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index c7b5afe..dd232ca 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -476,6 +476,15 @@ static void __init fixup_port_mmio(int index,
 	port->membase = ioremap(port->mapbase, 0x100);
 }
 
+static void __init fixup_port_bugs(int index,
+				   struct device_node *np,
+				   struct plat_serial8250_port *port)
+{
+	DBG("fixup_port_bugs(%d)\n", index);
+
+	if (of_device_is_compatible(np, "fsl,ns16550"))
+		port->bugs = UART_BUG_FSLBK;
+}
 /*
  * This is called as an arch initcall, hopefully before the PCI bus is
  * probed and/or the 8250 driver loaded since we need to register our
@@ -512,6 +521,8 @@ static int __init serial_dev_init(void)
 			fixup_port_pio(i, np, port);
 		if ((port->iotype == UPIO_MEM) || (port->iotype == UPIO_TSI))
 			fixup_port_mmio(i, np, port);
+
+		fixup_port_bugs(i, np, port);
 	}
 
 	DBG("Registering platform serial ports\n");
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index f99f27c..32e9821 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -142,6 +142,7 @@ struct uart_8250_port {
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
 	unsigned char		cur_iotype;	/* Running I/O type */
+	unsigned char		lsr_last;	/* LSR of last IRQ event */
 
 	/*
 	 * Some bits in registers are cleared on a read, so they must
@@ -1553,7 +1554,15 @@ static void serial8250_handle_port(struct uart_8250_port *up)
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
-	status = serial_inp(up, UART_LSR);
+	/* Workaround for IRQ storm errata on break with Freescale 16550 */
+	if (UART_BUG_FSLBK & up->port.bugs && up->lsr_last & UART_LSR_BI) {
+		up->lsr_last &= ~UART_LSR_BI;
+		serial_inp(up, UART_RX);
+		spin_unlock_irqrestore(&up->port.lock, flags);
+		return;
+	}
+
+	status = up->lsr_last = serial_inp(up, UART_LSR);
 
 	DEBUG_INTR("status = %x...", status);
 
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 8c660af..b0f4042 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -18,6 +18,11 @@
 #define UART_BUG_TXEN	(1 << 1)	/* buggy TX IIR status */
 #define UART_BUG_NOMSR	(1 << 2)	/* buggy MSR status bits (Au1x00) */
 #define UART_BUG_THRE	(1 << 3)	/* buggy THRE reassertion */
+#ifdef CONFIG_PPC32
+#define UART_BUG_FSLBK	(1 << 4)	/* buggy FSL break IRQ storm */
+#else	/* help GCC optimize away IRQ handler errata code for ARCH != PPC32 */
+#define UART_BUG_FSLBK	0
+#endif
 
 /*
  * This is the platform device platform_data structure
-- 
1.7.7

