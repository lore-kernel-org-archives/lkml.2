Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031570Ab2CIUHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:07:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031513Ab2CITvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:51:41 -0500
Message-Id: <20120309190215.430092805@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Stigge <stigge@antcom.de>
Subject: [ 05/68] ARM: LPC32xx: serial.c: HW bug workaround
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit 2707208ee8a80dbbd5426f5aa1a934f766825bb5 upstream.

This patch fixes a HW bug by flushing RX FIFOs of the UARTs on init. It was
ported from NXP's git.lpclinux.com tree.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-lpc32xx/serial.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/arm/mach-lpc32xx/serial.c
+++ b/arch/arm/mach-lpc32xx/serial.c
@@ -88,6 +88,7 @@ struct uartinit {
 	char *uart_ck_name;
 	u32 ck_mode_mask;
 	void __iomem *pdiv_clk_reg;
+	resource_size_t mapbase;
 };
 
 static struct uartinit uartinit_data[] __initdata = {
@@ -97,6 +98,7 @@ static struct uartinit uartinit_data[] _
 		.ck_mode_mask =
 			LPC32XX_UART_CLKMODE_LOAD(LPC32XX_UART_CLKMODE_ON, 5),
 		.pdiv_clk_reg = LPC32XX_CLKPWR_UART5_CLK_CTRL,
+		.mapbase = LPC32XX_UART5_BASE,
 	},
 #endif
 #ifdef CONFIG_ARCH_LPC32XX_UART3_SELECT
@@ -105,6 +107,7 @@ static struct uartinit uartinit_data[] _
 		.ck_mode_mask =
 			LPC32XX_UART_CLKMODE_LOAD(LPC32XX_UART_CLKMODE_ON, 3),
 		.pdiv_clk_reg = LPC32XX_CLKPWR_UART3_CLK_CTRL,
+		.mapbase = LPC32XX_UART3_BASE,
 	},
 #endif
 #ifdef CONFIG_ARCH_LPC32XX_UART4_SELECT
@@ -113,6 +116,7 @@ static struct uartinit uartinit_data[] _
 		.ck_mode_mask =
 			LPC32XX_UART_CLKMODE_LOAD(LPC32XX_UART_CLKMODE_ON, 4),
 		.pdiv_clk_reg = LPC32XX_CLKPWR_UART4_CLK_CTRL,
+		.mapbase = LPC32XX_UART4_BASE,
 	},
 #endif
 #ifdef CONFIG_ARCH_LPC32XX_UART6_SELECT
@@ -121,6 +125,7 @@ static struct uartinit uartinit_data[] _
 		.ck_mode_mask =
 			LPC32XX_UART_CLKMODE_LOAD(LPC32XX_UART_CLKMODE_ON, 6),
 		.pdiv_clk_reg = LPC32XX_CLKPWR_UART6_CLK_CTRL,
+		.mapbase = LPC32XX_UART6_BASE,
 	},
 #endif
 };
@@ -165,6 +170,19 @@ void __init lpc32xx_serial_init(void)
 
 		/* pre-UART clock divider set to 1 */
 		__raw_writel(0x0101, uartinit_data[i].pdiv_clk_reg);
+
+		/*
+		 * Force a flush of the RX FIFOs to work around a
+		 * HW bug
+		 */
+		puart = uartinit_data[i].mapbase;
+		__raw_writel(0xC1, LPC32XX_UART_IIR_FCR(puart));
+		__raw_writel(0x00, LPC32XX_UART_DLL_FIFO(puart));
+		j = LPC32XX_SUART_FIFO_SIZE;
+		while (j--)
+			tmp = __raw_readl(
+				LPC32XX_UART_DLL_FIFO(puart));
+		__raw_writel(0, LPC32XX_UART_IIR_FCR(puart));
 	}
 
 	/* This needs to be done after all UART clocks are setup */


