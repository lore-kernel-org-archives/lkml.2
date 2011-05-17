Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1EQFX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 01:23:27 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:46563 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab1EQFXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 01:23:24 -0400
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rmk+kernel@arm.linux.org.uk>, <linus.walleij@stericsson.com>,
        <alan@linux.intel.com>
Cc: <shreshthakumar.sahu@stericsson.com>
Subject: [PATCHv2 2/2] amba pl011: platform data for reg lockup and glitch
Date: Tue, 17 May 2011 10:53:07 +0530
Message-ID: <1305609787-17433-1-git-send-email-shreshthakumar.sahu@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <20110516141532.GA22311@bnru02.bnr.st.com>
References: <20110516141532.GA22311@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

This patch provides platform data for following
 - uart reset function to assist uart register lockup workaround

 - init/exit function to fix glitch in the tx pin in tty_open
	when tty port0 is opened a glitch is seen in the tx line
	of uart0. This happens in pl011_startup() when tx fifo
	interrupt is provoked into asserting.
	Now uart0 pins are enabled (alt function) only when init
	is complete and turned back to gpio when closed.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
---
changes in v2:
  corrected function name in commit message
  added missing header file include

 arch/arm/mach-ux500/board-mop500-pins.c |   16 +++++++--
 arch/arm/mach-ux500/board-mop500.c      |   54 +++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index fd4cf1c..ceab640 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -110,10 +110,18 @@ static pin_cfg_t mop500_pins_common[] = {
 	GPIO168_KP_O0,
 
 	/* UART */
-	GPIO0_U0_CTSn	| PIN_INPUT_PULLUP,
-	GPIO1_U0_RTSn	| PIN_OUTPUT_HIGH,
-	GPIO2_U0_RXD	| PIN_INPUT_PULLUP,
-	GPIO3_U0_TXD	| PIN_OUTPUT_HIGH,
+	/* uart-0 pins gpio configuration should be
+	 * kept intact to prevent glitch in tx line
+	 * when tty dev is opened. Later these pins
+	 * are configured to uart mop500_pins_uart0
+	 *
+	 * It will be replaced with uart configuration
+	 * once the issue is solved.
+	 */
+	GPIO0_GPIO	| PIN_INPUT_PULLUP,
+	GPIO1_GPIO	| PIN_OUTPUT_HIGH,
+	GPIO2_GPIO	| PIN_INPUT_PULLUP,
+	GPIO3_GPIO	| PIN_OUTPUT_LOW,
 
 	GPIO29_U2_RXD	| PIN_INPUT_PULLUP,
 	GPIO30_U2_TXD	| PIN_OUTPUT_HIGH,
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 6e1907fa..97b2577 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -27,18 +27,21 @@
 #include <linux/leds-lp5521.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/delay.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <plat/i2c.h>
 #include <plat/ste_dma40.h>
+#include <plat/pincfg.h>
 
 #include <mach/hardware.h>
 #include <mach/setup.h>
 #include <mach/devices.h>
 #include <mach/irqs.h>
 
+#include "pins-db8500.h"
 #include "ste-dma40-db8500.h"
 #include "devices-db8500.h"
 #include "board-mop500.h"
@@ -391,12 +394,63 @@ static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
 };
 #endif
 
+
+static pin_cfg_t mop500_pins_uart0[] = {
+	GPIO0_U0_CTSn   | PIN_INPUT_PULLUP,
+	GPIO1_U0_RTSn   | PIN_OUTPUT_HIGH,
+	GPIO2_U0_RXD    | PIN_INPUT_PULLUP,
+	GPIO3_U0_TXD    | PIN_OUTPUT_HIGH,
+};
+
+#define PRCC_K_SOFTRST_SET      0x18
+#define PRCC_K_SOFTRST_CLEAR    0x1C
+static void ux500_uart0_reset(void)
+{
+	void __iomem *prcc_rst_set, *prcc_rst_clr;
+
+	prcc_rst_set = (void __iomem *)IO_ADDRESS(U8500_CLKRST1_BASE +
+			PRCC_K_SOFTRST_SET);
+	prcc_rst_clr = (void __iomem *)IO_ADDRESS(U8500_CLKRST1_BASE +
+			PRCC_K_SOFTRST_CLEAR);
+
+	/* Activate soft reset PRCC_K_SOFTRST_CLEAR */
+	writel((readl(prcc_rst_clr) | 0x1), prcc_rst_clr);
+	udelay(1);
+
+	/* Release soft reset PRCC_K_SOFTRST_SET */
+	writel((readl(prcc_rst_set) | 0x1), prcc_rst_set);
+	udelay(1);
+}
+
+static void ux500_uart0_init(void)
+{
+	int ret;
+
+	ret = nmk_config_pins(mop500_pins_uart0,
+			ARRAY_SIZE(mop500_pins_uart0));
+	if (ret < 0)
+		pr_err("pl011: uart pins_enable failed\n");
+}
+
+static void ux500_uart0_exit(void)
+{
+	int ret;
+
+	ret = nmk_config_pins_sleep(mop500_pins_uart0,
+			ARRAY_SIZE(mop500_pins_uart0));
+	if (ret < 0)
+		pr_err("pl011: uart pins_disable failed\n");
+}
+
 static struct amba_pl011_data uart0_plat = {
 #ifdef CONFIG_STE_DMA40
 	.dma_filter = stedma40_filter,
 	.dma_rx_param = &uart0_dma_cfg_rx,
 	.dma_tx_param = &uart0_dma_cfg_tx,
 #endif
+	.init = ux500_uart0_init,
+	.exit = ux500_uart0_exit,
+	.reset = ux500_uart0_reset,
 };
 
 static struct amba_pl011_data uart1_plat = {
-- 
1.7.2.dirty

