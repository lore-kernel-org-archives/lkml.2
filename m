Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1F0VrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:47:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57031 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1F0VqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:46:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-serial@vger.kernel.org
Subject: [PATCH 2/7] serial/8250: move alchemy I/O handler to platform code
Date: Mon, 27 Jun 2011 23:45:15 +0200
Message-Id: <1309211120-2803-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309211120-2803-1-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:XNemfpUs4Gb/QMlpu95j56y9k7bSU2m7j89pn/Y3VFr
 Lh/3gzUOUZKLG3XMCmy1b6wNV8YK+OtFtSh3yMuEC15QMXUsl1
 LaHH9/fBITSFhfLkSh3rktSWDVX56gxpxGmNzBUaic+VETDhg+
 CG9q+mBjS5VT5uk4FDbQyfmXx+cnR926IB2bYA3VO4tKFuxtbR
 hgeTge2xXX64rfGxTckKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one platform ever sets the UPIO_AU iotype, so it's
cleaner to define the handlers in the code that actually
requires it, rather than building the same logic into
every 8250 driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org
---
 arch/mips/alchemy/common/platform.c |   50 ++++++++++++++++++++++++++++++
 drivers/tty/serial/8250.c           |   58 -----------------------------------
 2 files changed, 50 insertions(+), 58 deletions(-)

diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
index 3b2c18b..750441f 100644
--- a/arch/mips/alchemy/common/platform.c
+++ b/arch/mips/alchemy/common/platform.c
@@ -45,6 +45,54 @@ static void alchemy_8250_pm(struct uart_port *port, unsigned int state,
 #endif
 }
 
+/* Au1x00 UART hardware has a weird register layout */
+static const u8 au_io_in_map[] = {
+	[UART_RX]  = 0,
+	[UART_IER] = 2,
+	[UART_IIR] = 3,
+	[UART_LCR] = 5,
+	[UART_MCR] = 6,
+	[UART_LSR] = 7,
+	[UART_MSR] = 8,
+};
+
+static const u8 au_io_out_map[] = {
+	[UART_TX]  = 1,
+	[UART_IER] = 2,
+	[UART_FCR] = 4,
+	[UART_LCR] = 5,
+	[UART_MCR] = 6,
+};
+
+/* sane hardware needs no mapping */
+static inline int map_8250_in_reg(struct uart_port *p, int offset)
+{
+	if (p->iotype != UPIO_AU)
+		return offset;
+	return au_io_in_map[offset];
+}
+
+static inline int map_8250_out_reg(struct uart_port *p, int offset)
+{
+	if (p->iotype != UPIO_AU)
+		return offset;
+	return au_io_out_map[offset];
+}
+
+/* sane hardware needs no mapping */
+static unsigned int au_serial_in(struct uart_port *p, int offset)
+{
+	offset = map_8250_in_reg(p, offset) << p->regshift;
+	return __raw_readl(p->membase + offset);
+}
+
+static void au_serial_out(struct uart_port *p, int offset, int value)
+{
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	__raw_writel(value, p->membase + offset);
+}
+
+
 #define PORT(_base, _irq)					\
 	{							\
 		.mapbase	= _base,			\
@@ -55,6 +103,8 @@ static void alchemy_8250_pm(struct uart_port *port, unsigned int state,
 				  UPF_FIXED_TYPE,		\
 		.type		= PORT_16550A,			\
 		.pm		= alchemy_8250_pm,		\
+		.serial_in	= au_serial_in,			\
+		.serial_out	= au_serial_out			\
 	}
 
 static struct plat_serial8250_port au1x00_uart_data[][4] __initdata = {
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index cf19b26..c8f107e 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -304,50 +304,9 @@ static const struct serial8250_config uart_config[] = {
 	},
 };
 
-#if defined(CONFIG_MIPS_ALCHEMY)
-
-/* Au1x00 UART hardware has a weird register layout */
-static const u8 au_io_in_map[] = {
-	[UART_RX]  = 0,
-	[UART_IER] = 2,
-	[UART_IIR] = 3,
-	[UART_LCR] = 5,
-	[UART_MCR] = 6,
-	[UART_LSR] = 7,
-	[UART_MSR] = 8,
-};
-
-static const u8 au_io_out_map[] = {
-	[UART_TX]  = 1,
-	[UART_IER] = 2,
-	[UART_FCR] = 4,
-	[UART_LCR] = 5,
-	[UART_MCR] = 6,
-};
-
-/* sane hardware needs no mapping */
-static inline int map_8250_in_reg(struct uart_port *p, int offset)
-{
-	if (p->iotype != UPIO_AU)
-		return offset;
-	return au_io_in_map[offset];
-}
-
-static inline int map_8250_out_reg(struct uart_port *p, int offset)
-{
-	if (p->iotype != UPIO_AU)
-		return offset;
-	return au_io_out_map[offset];
-}
-
-#else
-
-/* sane hardware needs no mapping */
 #define map_8250_in_reg(up, offset) (offset)
 #define map_8250_out_reg(up, offset) (offset)
 
-#endif
-
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
 	offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -386,18 +345,6 @@ static unsigned int mem32_serial_in(struct uart_port *p, int offset)
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
 static unsigned int tsi_serial_in(struct uart_port *p, int offset)
 {
 	unsigned int tmp;
@@ -484,11 +431,6 @@ static void set_io_from_upio(struct uart_port *p)
 		p->serial_out = mem32_serial_out;
 		break;
 
-	case UPIO_AU:
-		p->serial_in = au_serial_in;
-		p->serial_out = au_serial_out;
-		break;
-
 	case UPIO_TSI:
 		p->serial_in = tsi_serial_in;
 		p->serial_out = tsi_serial_out;
-- 
1.7.5.4

