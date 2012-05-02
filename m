Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2EBMqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:46:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51182 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2EBMqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:46:05 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: arnd@arndb.de, swarren@wwwdotorg.org, lethal@linux-sh.org,
        gregkh@linuxfoundation.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, horms@verge.net.au, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Wed, 02 May 2012 21:46:51 +0900
Message-Id: <20120502124651.30480.88827.sendpatchset@w520>
In-Reply-To: <20120502124642.30480.41373.sendpatchset@w520>
References: <20120502124642.30480.41373.sendpatchset@w520>
Subject: [PATCH 01/06] serial8250: Add dl_read()/dl_write() callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Convert serial_dl_read() and serial_dl_write() from macro
to 8250 specific callbacks. This change makes it easier to
support 8250 hardware with non-standard DLL and DLM register
configurations such as Alchemy, RM9K and upcoming Emma Mobile
UART hardware.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/tty/serial/8250/8250.c |  117 +++++++++++++++++++++-------------------
 drivers/tty/serial/8250/8250.h |   14 ++++
 2 files changed, 78 insertions(+), 53 deletions(-)

--- 0001/drivers/tty/serial/8250/8250.c
+++ work/drivers/tty/serial/8250/8250.c	2012-05-01 22:50:38.000000000 +0900
@@ -284,6 +284,66 @@ static const struct serial8250_config ua
 	},
 };
 
+/* Uart divisor latch read */
+static int default_dl_read(struct uart_8250_port *up)
+{
+	return serial_in(up, UART_DLL) | serial_in(up, UART_DLM) << 8;
+}
+
+/* Uart divisor latch write */
+static void default_dl_write(struct uart_8250_port *up, int value)
+{
+	serial_out(up, UART_DLL, value & 0xff);
+	serial_out(up, UART_DLM, value >> 8 & 0xff);
+}
+
+#if defined(CONFIG_MIPS_ALCHEMY)
+/* Au1x00 haven't got a standard divisor latch */
+static int _serial_dl_read(struct uart_8250_port *up)
+{
+	if (up->port.iotype == UPIO_AU)
+		return __raw_readl(up->port.membase + 0x28);
+	else
+		return default_dl_read(up);
+}
+
+static void _serial_dl_write(struct uart_8250_port *up, int value)
+{
+	if (up->port.iotype == UPIO_AU)
+		__raw_writel(value, up->port.membase + 0x28);
+	else
+		default_dl_write(up, value);
+}
+#elif defined(CONFIG_SERIAL_8250_RM9K)
+static int _serial_dl_read(struct uart_8250_port *up)
+{
+	return	(up->port.iotype == UPIO_RM9000) ?
+		(((__raw_readl(up->port.membase + 0x10) << 8) |
+		(__raw_readl(up->port.membase + 0x08) & 0xff)) & 0xffff) :
+		default_dl_read(up);
+}
+
+static void _serial_dl_write(struct uart_8250_port *up, int value)
+{
+	if (up->port.iotype == UPIO_RM9000) {
+		__raw_writel(value, up->port.membase + 0x08);
+		__raw_writel(value >> 8, up->port.membase + 0x10);
+	} else {
+		default_dl_write(up, value);
+	}
+}
+#else
+static int _serial_dl_read(struct uart_8250_port *up)
+{
+	return default_dl_read(up);
+}
+
+static void _serial_dl_write(struct uart_8250_port *up, int value)
+{
+	default_dl_write(up, value);
+}
+#endif
+
 #if defined(CONFIG_MIPS_ALCHEMY)
 
 /* Au1x00 UART hardware has a weird register layout */
@@ -434,6 +494,10 @@ static void set_io_from_upio(struct uart
 {
 	struct uart_8250_port *up =
 		container_of(p, struct uart_8250_port, port);
+
+	up->dl_read = _serial_dl_read;
+	up->dl_write = _serial_dl_write;
+
 	switch (p->iotype) {
 	case UPIO_HUB6:
 		p->serial_in = hub6_serial_in;
@@ -481,59 +545,6 @@ serial_port_out_sync(struct uart_port *p
 	}
 }
 
-/* Uart divisor latch read */
-static inline int _serial_dl_read(struct uart_8250_port *up)
-{
-	return serial_in(up, UART_DLL) | serial_in(up, UART_DLM) << 8;
-}
-
-/* Uart divisor latch write */
-static inline void _serial_dl_write(struct uart_8250_port *up, int value)
-{
-	serial_out(up, UART_DLL, value & 0xff);
-	serial_out(up, UART_DLM, value >> 8 & 0xff);
-}
-
-#if defined(CONFIG_MIPS_ALCHEMY)
-/* Au1x00 haven't got a standard divisor latch */
-static int serial_dl_read(struct uart_8250_port *up)
-{
-	if (up->port.iotype == UPIO_AU)
-		return __raw_readl(up->port.membase + 0x28);
-	else
-		return _serial_dl_read(up);
-}
-
-static void serial_dl_write(struct uart_8250_port *up, int value)
-{
-	if (up->port.iotype == UPIO_AU)
-		__raw_writel(value, up->port.membase + 0x28);
-	else
-		_serial_dl_write(up, value);
-}
-#elif defined(CONFIG_SERIAL_8250_RM9K)
-static int serial_dl_read(struct uart_8250_port *up)
-{
-	return	(up->port.iotype == UPIO_RM9000) ?
-		(((__raw_readl(up->port.membase + 0x10) << 8) |
-		(__raw_readl(up->port.membase + 0x08) & 0xff)) & 0xffff) :
-		_serial_dl_read(up);
-}
-
-static void serial_dl_write(struct uart_8250_port *up, int value)
-{
-	if (up->port.iotype == UPIO_RM9000) {
-		__raw_writel(value, up->port.membase + 0x08);
-		__raw_writel(value >> 8, up->port.membase + 0x10);
-	} else {
-		_serial_dl_write(up, value);
-	}
-}
-#else
-#define serial_dl_read(up) _serial_dl_read(up)
-#define serial_dl_write(up, value) _serial_dl_write(up, value)
-#endif
-
 /*
  * For the 16C950
  */
--- 0001/drivers/tty/serial/8250/8250.h
+++ work/drivers/tty/serial/8250/8250.h	2012-05-01 22:50:38.000000000 +0900
@@ -37,6 +37,10 @@ struct uart_8250_port {
 	unsigned char		lsr_saved_flags;
 #define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
 	unsigned char		msr_saved_flags;
+
+	/* 8250 specific callbacks */
+	int			(*dl_read)(struct uart_8250_port *);
+	void			(*dl_write)(struct uart_8250_port *, int);
 };
 
 struct old_serial_port {
@@ -96,6 +100,16 @@ static inline void serial_out(struct uar
 	up->port.serial_out(&up->port, offset, value);
 }
 
+static inline int serial_dl_read(struct uart_8250_port *up)
+{
+	return up->dl_read(up);
+}
+
+static inline void serial_dl_write(struct uart_8250_port *up, int value)
+{
+	up->dl_write(up, value);
+}
+
 #if defined(__alpha__) && !defined(CONFIG_PCI)
 /*
  * Digital did something really horribly wrong with the OUT1 and OUT2
