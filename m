Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2EBMqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:46:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38576 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2EBMqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:46:15 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-serial@vger.kernel.org
Cc: horms@verge.net.au, arnd@arndb.de, linux-sh@vger.kernel.org,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>, dan.j.williams@intel.com,
        alan@linux.intel.com
Date: Wed, 02 May 2012 21:47:00 +0900
Message-Id: <20120502124700.30480.63274.sendpatchset@w520>
In-Reply-To: <20120502124642.30480.41373.sendpatchset@w520>
References: <20120502124642.30480.41373.sendpatchset@w520>
Subject: [PATCH 02/06] serial8250: Use dl_read()/dl_write() on Alchemy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Convert the 8250 Alchemy support code to make
use of the new dl_read()/dl_write() callbacks.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/tty/serial/8250/8250.c |   67 +++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

--- 0005/drivers/tty/serial/8250/8250.c
+++ work/drivers/tty/serial/8250/8250.c	2012-05-01 22:51:07.000000000 +0900
@@ -297,24 +297,7 @@ static void default_dl_write(struct uart
 	serial_out(up, UART_DLM, value >> 8 & 0xff);
 }
 
-#if defined(CONFIG_MIPS_ALCHEMY)
-/* Au1x00 haven't got a standard divisor latch */
-static int _serial_dl_read(struct uart_8250_port *up)
-{
-	if (up->port.iotype == UPIO_AU)
-		return __raw_readl(up->port.membase + 0x28);
-	else
-		return default_dl_read(up);
-}
-
-static void _serial_dl_write(struct uart_8250_port *up, int value)
-{
-	if (up->port.iotype == UPIO_AU)
-		__raw_writel(value, up->port.membase + 0x28);
-	else
-		default_dl_write(up, value);
-}
-#elif defined(CONFIG_SERIAL_8250_RM9K)
+#if defined(CONFIG_SERIAL_8250_RM9K)
 static int _serial_dl_read(struct uart_8250_port *up)
 {
 	return	(up->port.iotype == UPIO_RM9000) ?
@@ -344,7 +327,7 @@ static void _serial_dl_write(struct uart
 }
 #endif
 
-#if defined(CONFIG_MIPS_ALCHEMY)
+#ifdef CONFIG_MIPS_ALCHEMY
 
 /* Au1x00 UART hardware has a weird register layout */
 static const u8 au_io_in_map[] = {
@@ -365,22 +348,32 @@ static const u8 au_io_out_map[] = {
 	[UART_MCR] = 6,
 };
 
-/* sane hardware needs no mapping */
-static inline int map_8250_in_reg(struct uart_port *p, int offset)
+static unsigned int au_serial_in(struct uart_port *p, int offset)
 {
-	if (p->iotype != UPIO_AU)
-		return offset;
-	return au_io_in_map[offset];
+	offset = au_io_in_map[offset] << p->regshift;
+	return __raw_readl(p->membase + offset);
 }
 
-static inline int map_8250_out_reg(struct uart_port *p, int offset)
+static void au_serial_out(struct uart_port *p, int offset, int value)
 {
-	if (p->iotype != UPIO_AU)
-		return offset;
-	return au_io_out_map[offset];
+	offset = au_io_out_map[offset] << p->regshift;
+	__raw_writel(value, p->membase + offset);
+}
+
+/* Au1x00 haven't got a standard divisor latch */
+static int au_serial_dl_read(struct uart_8250_port *up)
+{
+	return __raw_readl(up->port.membase + 0x28);
+}
+
+static void au_serial_dl_write(struct uart_8250_port *up, int value)
+{
+	__raw_writel(value, up->port.membase + 0x28);
 }
 
-#elif defined(CONFIG_SERIAL_8250_RM9K)
+#endif
+
+#if defined(CONFIG_SERIAL_8250_RM9K)
 
 static const u8
 	regmap_in[8] = {
@@ -464,18 +457,6 @@ static unsigned int mem32_serial_in(stru
 	return readl(p->membase + offset);
 }
 
-static unsigned int au_serial_in(struct uart_port *p, int offset)
-{
-	offset = map_8250_in_reg(p, offset) << p->regshift;
-	return __raw_readl(p->membase + offset);
-}
-
-static void au_serial_out(struct uart_port *p, int offset, int value)
-{
-	offset = map_8250_out_reg(p, offset) << p->regshift;
-	__raw_writel(value, p->membase + offset);
-}
-
 static unsigned int io_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -515,10 +496,14 @@ static void set_io_from_upio(struct uart
 		p->serial_out = mem32_serial_out;
 		break;
 
+#ifdef CONFIG_MIPS_ALCHEMY
 	case UPIO_AU:
 		p->serial_in = au_serial_in;
 		p->serial_out = au_serial_out;
+		up->dl_read = au_serial_dl_read;
+		up->dl_write = au_serial_dl_write;
 		break;
+#endif
 
 	default:
 		p->serial_in = io_serial_in;
