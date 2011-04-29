Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab1D2W2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:28:19 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49372 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1D2W2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:28:15 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, linux-serial@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: [RFC 3/5] serial: add support for Technologic Systems TS-5500 RS-485 serial port
Date: Fri, 29 Apr 2011 18:21:50 -0400
Message-Id: <1304115712-5299-4-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                         |    1 +
 drivers/tty/serial/8250.c           |   30 +++++++++++++++++++++++
 drivers/tty/serial/Kconfig          |   19 ++++++++++++++
 drivers/tty/serial/Makefile         |    1 +
 drivers/tty/serial/ts5500-auto485.c |   45 +++++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/serial/ts5500-auto485.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 32c2c57..da3b6d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6060,6 +6060,7 @@ F:	drivers/platform/x86/ts5xxx-sbcinfo.c
 F:	include/linux/ts5xxx-sbcinfo.h
 F:	drivers/gpio/ts5500-gpio.c
 F:	include/linux/ts5500-gpio.h
+F:	drivers/tty/serial/ts5500-auto485.c
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 6611535..3ed7fee 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -109,6 +109,13 @@ static unsigned int skip_txen_test; /* force skip of txen test at init time */
 #define CONFIG_HUB6 1
 
 #include <asm/serial.h>
+
+/* TS-5500 related stuff */
+#ifdef CONFIG_SERIAL_8250_TS5500_485_TIMER
+#define TS5500_TIMER2_SPEED_ADDR	0x42
+#define TS5500_485_SERIAL_PORT		0x02
+#endif
+
 /*
  * SERIAL_PORT_DFNS tells us about built-in ports that have no
  * standard enumeration mechanism.   Platforms that can find all
@@ -437,6 +444,25 @@ static void au_serial_out(struct uart_port *p, int offset, int value)
 	__raw_writel(value, p->membase + offset);
 }
 
+#ifdef CONFIG_SERIAL_8250_TS5500_485_TIMER
+void serial8250_ts5500_set_termios(struct uart_port *port,
+				   struct ktermios *new,
+				   struct ktermios *old)
+{
+	u16 speed;
+
+	if (new->c_ospeed >= 9600 && port->line == TS5500_485_SERIAL_PORT) {
+		speed = ((115200 * 2) / new->c_ospeed);
+
+		/* This should be written by low byte followed by high byte */
+		spin_lock_irq(&port->lock);
+		outb((speed & 0x0F), TS5500_TIMER2_SPEED_ADDR);
+		outb((speed >> 8), TS5500_TIMER2_SPEED_ADDR);
+		spin_unlock_irq(&port->lock);
+	}
+}
+#endif
+
 static unsigned int tsi_serial_in(struct uart_port *p, int offset)
 {
 	unsigned int tmp;
@@ -2464,6 +2490,10 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* Don't rewrite B0 */
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
+
+#ifdef CONFIG_SERIAL_8250_TS5500_485_TIMER
+	serial8250_ts5500_set_termios(port, termios, old);
+#endif
 }
 EXPORT_SYMBOL(serial8250_do_set_termios);
 
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 80484af..cbd88c0 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -241,6 +241,25 @@ config SERIAL_8250_RSA
 	help
 	  ::: To be written :::
 
+config SERIAL_8250_TS5500_485_TIMER
+	bool "Support RS-485 mode on TS-5500"
+	depends on TS5500_SBC
+	depends on SERIAL_8250_EXTENDED
+	help
+	  Say Y here to enable RS-485 timer programming for the COM3 serial
+	  port on Technologic Systems TS-5500 SBCs.
+	  Note: this does not affect the RS-232 behaviour on the COM3 port.
+
+config SERIAL_8250_TS5500_AUTO485
+	tristate "Support Auto485 feature on TS-5500"
+	depends on SERIAL_8250_TS5500_485_TIMER
+	help
+	  Say Y or M here to enable the Auto485 feature on Technologic Systems
+	  TS-5500 SBCs.
+	  Warning: When loaded, the Auto485 feature is enabled
+	  as long as the module is loaded, so you won't be able to disable it
+	  if the module is statically linked in.
+
 config SERIAL_8250_MCA
 	tristate "Support 8250-type ports on MCA buses"
 	depends on SERIAL_8250 != n && MCA
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index fee0690..3fbcbbf 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -94,3 +94,4 @@ obj-$(CONFIG_SERIAL_IFX6X60)  	+= ifx6x60.o
 obj-$(CONFIG_SERIAL_PCH_UART)	+= pch_uart.o
 obj-$(CONFIG_SERIAL_MSM_SMD)	+= msm_smd_tty.o
 obj-$(CONFIG_SERIAL_MXS_AUART) += mxs-auart.o
+obj-$(CONFIG_SERIAL_8250_TS5500_AUTO485) += ts5500-auto485.o
diff --git a/drivers/tty/serial/ts5500-auto485.c b/drivers/tty/serial/ts5500-auto485.c
new file mode 100644
index 0000000..fd01aa0
--- /dev/null
+++ b/drivers/tty/serial/ts5500-auto485.c
@@ -0,0 +1,45 @@
+/*
+ * ts5500-auto485.c - support for the TS-5500 auto485 feature
+ *
+ * Copyright (c) 2010 Savoir-faire Linux Inc.
+ *      Arthur Gautier <arthur.gautier@savoirfairelinux.com>
+ */
+
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/ts5xxx-sbcinfo.h>
+
+#define TS5500_485_CONTROLER_ADDR	0x75	/* controler register address */
+#define TS5500_485_BITS			0xC0	/* RTS485 and Auto485 bits */
+
+static int __init serial8250_init_ts5500_485(void)
+{
+	struct ts5xxx_sbcinfo sbcinfo;
+	u8 reg;
+
+	/* Validate platform and auto485 feature */
+	ts5xxx_sbcinfo_set(&sbcinfo);
+
+	if (!sbcinfo.auto485) {
+		printk(KERN_ERR ": Auto485 not available on this platform\n");
+		return -ENODEV;
+	}
+
+	/* Enable RS-485 mode */
+	reg = inb(TS5500_485_CONTROLER_ADDR) | TS5500_485_BITS;
+	outb(reg, TS5500_485_CONTROLER_ADDR);
+
+	return 0;
+}
+module_init(serial8250_init_ts5500_485);
+
+static void __exit serial8250_ts5500_485(void)
+{
+	u8 reg = inb(TS5500_485_CONTROLER_ADDR) & ~TS5500_485_BITS;
+	outb(reg, TS5500_485_CONTROLER_ADDR);
+}
+module_exit(serial8250_ts5500_485);
+
+MODULE_DESCRIPTION("Technologic Systems TS-5500, auto485 driver");
+MODULE_AUTHOR("Arthur Gautier <arthur.gautier@savoirfairelinux.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.1

