Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1F0Vr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:47:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1F0VqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:46:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Ralf Baechle <ralf@linux-mips.org>,
        Thomas Koeller <thomas.koeller@baslerweb.com>,
        linux-serial@vger.kernel.org
Subject: [PATCH 1/7] serial/8250: remove obsolete RM9000 port type
Date: Mon, 27 Jun 2011 23:45:14 +0200
Message-Id: <1309211120-2803-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309211120-2803-1-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:faH53VwtQQqiczOH70o2HjE8jNwYucDA2XG041CxM7s
 RN86++zdhAie4ytZqKhOIpV8zJxXnarq2AwfIi0Iijqsa846KF
 OxMpN0v08T7gJk2Z9Tarwb9lTzBbR1F6BIZUeUdY/Ze1bJLJT3
 /7yGg+QnXfYIgp0duhPr2WIQd+fgd0bgkX1YWvojFExQNuo1/Y
 ZhefSojzt8eqRPCP+bzag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was only used on the MIPS eXcite platform, which got
removed in 2009. Since no code ever sets UPIO_RM9000, none of
the code is being used any more now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Koeller <thomas.koeller@baslerweb.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org
---
 arch/mips/Kconfig           |    7 ----
 drivers/tty/serial/8250.c   |   68 +------------------------------------------
 drivers/tty/serial/Kconfig  |    9 ------
 include/linux/serial_core.h |    3 +-
 4 files changed, 2 insertions(+), 85 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 653da62..a07f7b8 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1045,10 +1045,6 @@ config PCI_GT64XXX_PCI0
 config NO_EXCEPT_FILL
 	bool
 
-config MIPS_RM9122
-	bool
-	select SERIAL_RM9000
-
 config SOC_EMMA2RH
 	bool
 	select CEVT_R4K
@@ -1094,9 +1090,6 @@ config SOC_PNX8550
 config SWAP_IO_SPACE
 	bool
 
-config SERIAL_RM9000
-	bool
-
 config SGI_HAS_INDYDOG
 	bool
 
diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index b40f7b9..cf19b26 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -273,13 +273,6 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_UUE | UART_CAP_RTOIE,
 	},
-	[PORT_RM9000] = {
-		.name		= "RM9000",
-		.fifo_size	= 16,
-		.tx_loadsz	= 16,
-		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
-		.flags		= UART_CAP_FIFO,
-	},
 	[PORT_OCTEON] = {
 		.name		= "OCTEON",
 		.fifo_size	= 64,
@@ -347,44 +340,6 @@ static inline int map_8250_out_reg(struct uart_port *p, int offset)
 	return au_io_out_map[offset];
 }
 
-#elif defined(CONFIG_SERIAL_8250_RM9K)
-
-static const u8
-	regmap_in[8] = {
-		[UART_RX]	= 0x00,
-		[UART_IER]	= 0x0c,
-		[UART_IIR]	= 0x14,
-		[UART_LCR]	= 0x1c,
-		[UART_MCR]	= 0x20,
-		[UART_LSR]	= 0x24,
-		[UART_MSR]	= 0x28,
-		[UART_SCR]	= 0x2c
-	},
-	regmap_out[8] = {
-		[UART_TX] 	= 0x04,
-		[UART_IER]	= 0x0c,
-		[UART_FCR]	= 0x18,
-		[UART_LCR]	= 0x1c,
-		[UART_MCR]	= 0x20,
-		[UART_LSR]	= 0x24,
-		[UART_MSR]	= 0x28,
-		[UART_SCR]	= 0x2c
-	};
-
-static inline int map_8250_in_reg(struct uart_port *p, int offset)
-{
-	if (p->iotype != UPIO_RM9000)
-		return offset;
-	return regmap_in[offset];
-}
-
-static inline int map_8250_out_reg(struct uart_port *p, int offset)
-{
-	if (p->iotype != UPIO_RM9000)
-		return offset;
-	return regmap_out[offset];
-}
-
 #else
 
 /* sane hardware needs no mapping */
@@ -524,7 +479,6 @@ static void set_io_from_upio(struct uart_port *p)
 		p->serial_out = mem_serial_out;
 		break;
 
-	case UPIO_RM9000:
 	case UPIO_MEM32:
 		p->serial_in = mem32_serial_in;
 		p->serial_out = mem32_serial_out;
@@ -620,24 +574,6 @@ static void serial_dl_write(struct uart_8250_port *up, int value)
 	else
 		_serial_dl_write(up, value);
 }
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
 #else
 #define serial_dl_read(up) _serial_dl_read(up)
 #define serial_dl_write(up, value) _serial_dl_write(up, value)
@@ -1394,9 +1330,7 @@ static void serial8250_start_tx(struct uart_port *port)
 			unsigned char lsr;
 			lsr = serial_in(up, UART_LSR);
 			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
-			if ((up->port.type == PORT_RM9000) ?
-				(lsr & UART_LSR_THRE) :
-				(lsr & UART_LSR_TEMT))
+			if (lsr & UART_LSR_TEMT)
 				transmit_chars(up);
 		}
 	}
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 636144c..ea12815 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -258,15 +258,6 @@ config SERIAL_8250_ACORN
 	  system, say Y to this option.  The driver can handle 1, 2, or 3 port
 	  cards.  If unsure, say N.
 
-config SERIAL_8250_RM9K
-	bool "Support for MIPS RM9xxx integrated serial port"
-	depends on SERIAL_8250 != n && SERIAL_RM9000
-	select SERIAL_8250_SHARE_IRQ
-	help
-	  Selecting this option will add support for the integrated serial
-	  port hardware found on MIPS RM9122 and similar processors.
-	  If unsure, say N.
-
 comment "Non-8250 serial port support"
 
 config SERIAL_AMBA_PL010
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index a5c3114..df295e0 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -41,7 +41,7 @@
 #define PORT_RSA	13
 #define PORT_NS16550A	14
 #define PORT_XSCALE	15
-#define PORT_RM9000	16	/* PMC-Sierra RM9xxx internal UART */
+/* #define PORT_RM9000	16 */	/* was: PMC-Sierra RM9xxx internal UART */
 #define PORT_OCTEON	17	/* Cavium OCTEON internal UART */
 #define PORT_AR7	18	/* Texas Instruments AR7 internal UART */
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
@@ -318,7 +318,6 @@ struct uart_port {
 #define UPIO_AU			(4)			/* Au1x00 type IO */
 #define UPIO_TSI		(5)			/* Tsi108/109 type IO */
 #define UPIO_DWAPB		(6)			/* DesignWare APB UART */
-#define UPIO_RM9000		(7)			/* RM9000 type IO */
 #define UPIO_DWAPB32		(8)			/* DesignWare APB UART (32 bit accesses) */
 
 	unsigned int		read_status_mask;	/* driver specific */
-- 
1.7.5.4

