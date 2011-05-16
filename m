Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1EPNBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:01:52 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:33021 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022Ab1EPNBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:01:49 -0400
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rmk+kernel@arm.linux.org.uk>, <linus.walleij@stericsson.com>,
        <alan@linux.intel.com>
Cc: <shreshthakumar.sahu@stericsson.com>
Subject: [PATCH 2/2] amba pl011: platform data for reg lockup and glitch
Date: Mon, 16 May 2011 18:31:19 +0530
Message-ID: <1305550879-28945-2-git-send-email-shreshthakumar.sahu@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1305550879-28945-1-git-send-email-shreshthakumar.sahu@stericsson.com>
References: <1305550879-28945-1-git-send-email-shreshthakumar.sahu@stericsson.com>
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
	of uart0. This happens in __pl011_startup() when tx fifo
	interrupt is provoked into asserting.
	Now uart0 pins are enabled (alt function) only when init
	is complete and turned back to gpio when closed.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500-pins.c |   16 +++++++--
 arch/arm/mach-ux500/board-mop500.c      |   53 +++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 4 deletions(-)

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
index 6e1907fa..e7bc61e 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -27,6 +27,7 @@
 #include <linux/leds-lp5521.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/delay.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -39,6 +40,7 @@
 #include <mach/devices.h>
 #include <mach/irqs.h>
 
+#include "pins-db8500.h"
 #include "ste-dma40-db8500.h"
 #include "devices-db8500.h"
 #include "board-mop500.h"
@@ -391,12 +393,63 @@ static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
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

