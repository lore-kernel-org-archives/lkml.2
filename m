Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2EBMq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:46:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51600 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2EBMqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:46:24 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: arnd@arndb.de, swarren@wwwdotorg.org, lethal@linux-sh.org,
        gregkh@linuxfoundation.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, horms@verge.net.au, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Wed, 02 May 2012 21:47:09 +0900
Message-Id: <20120502124709.30480.98463.sendpatchset@w520>
In-Reply-To: <20120502124642.30480.41373.sendpatchset@w520>
References: <20120502124642.30480.41373.sendpatchset@w520>
Subject: [PATCH 03/06] serial8250: Use dl_read()/dl_write() on RM9K
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Convert the 8250 RM9K support code to make
use of the new dl_read()/dl_write() callbacks.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/tty/serial/8250/8250.c |   62 ++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

--- 0006/drivers/tty/serial/8250/8250.c
+++ work/drivers/tty/serial/8250/8250.c	2012-05-01 22:51:42.000000000 +0900
@@ -297,25 +297,6 @@ static void default_dl_write(struct uart
 	serial_out(up, UART_DLM, value >> 8 & 0xff);
 }
 
-#if defined(CONFIG_SERIAL_8250_RM9K)
-static int _serial_dl_read(struct uart_8250_port *up)
-{
-	return	(up->port.iotype == UPIO_RM9000) ?
-		(((__raw_readl(up->port.membase + 0x10) << 8) |
-		(__raw_readl(up->port.membase + 0x08) & 0xff)) & 0xffff) :
-		default_dl_read(up);
-}
-
-static void _serial_dl_write(struct uart_8250_port *up, int value)
-{
-	if (up->port.iotype == UPIO_RM9000) {
-		__raw_writel(value, up->port.membase + 0x08);
-		__raw_writel(value >> 8, up->port.membase + 0x10);
-	} else {
-		default_dl_write(up, value);
-	}
-}
-#else
 static int _serial_dl_read(struct uart_8250_port *up)
 {
 	return default_dl_read(up);
@@ -325,7 +306,6 @@ static void _serial_dl_write(struct uart
 {
 	default_dl_write(up, value);
 }
-#endif
 
 #ifdef CONFIG_MIPS_ALCHEMY
 
@@ -373,7 +353,7 @@ static void au_serial_dl_write(struct ua
 
 #endif
 
-#if defined(CONFIG_SERIAL_8250_RM9K)
+#ifdef CONFIG_SERIAL_8250_RM9K
 
 static const u8
 	regmap_in[8] = {
@@ -397,28 +377,36 @@ static const u8
 		[UART_SCR]	= 0x2c
 	};
 
-static inline int map_8250_in_reg(struct uart_port *p, int offset)
+static unsigned int rm9k_serial_in(struct uart_port *p, int offset)
+{
+	offset = regmap_in[offset] << p->regshift;
+	return readl(p->membase + offset);
+}
+
+static void rm9k_serial_out(struct uart_port *p, int offset, int value)
 {
-	if (p->iotype != UPIO_RM9000)
-		return offset;
-	return regmap_in[offset];
+	offset = regmap_out[offset] << p->regshift;
+	writel(value, p->membase + offset);
+}
+
+static int rm9k_serial_dl_read(struct uart_8250_port *up)
+{
+	return ((__raw_readl(up->port.membase + 0x10) << 8) |
+		(__raw_readl(up->port.membase + 0x08) & 0xff)) & 0xffff;
 }
 
-static inline int map_8250_out_reg(struct uart_port *p, int offset)
+static void rm9k_serial_dl_write(struct uart_8250_port *up, int value)
 {
-	if (p->iotype != UPIO_RM9000)
-		return offset;
-	return regmap_out[offset];
+	__raw_writel(value, up->port.membase + 0x08);
+	__raw_writel(value >> 8, up->port.membase + 0x10);
 }
 
-#else
+#endif
 
 /* sane hardware needs no mapping */
 #define map_8250_in_reg(up, offset) (offset)
 #define map_8250_out_reg(up, offset) (offset)
 
-#endif
-
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -490,12 +478,20 @@ static void set_io_from_upio(struct uart
 		p->serial_out = mem_serial_out;
 		break;
 
-	case UPIO_RM9000:
 	case UPIO_MEM32:
 		p->serial_in = mem32_serial_in;
 		p->serial_out = mem32_serial_out;
 		break;
 
+#ifdef CONFIG_SERIAL_8250_RM9K
+	case UPIO_RM9000:
+		p->serial_in = rm9k_serial_in;
+		p->serial_out = rm9k_serial_out;
+		up->dl_read = rm9k_serial_dl_read;
+		up->dl_write = rm9k_serial_dl_write;
+		break;
+#endif
+
 #ifdef CONFIG_MIPS_ALCHEMY
 	case UPIO_AU:
 		p->serial_in = au_serial_in;
