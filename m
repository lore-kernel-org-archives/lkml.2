Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0K2WsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:48:08 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45352 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab0K2WsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:48:07 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h691h668h67dh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <amit.kucheria@canonical.com>, <eric@eukrea.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH] ARM: imx: Add mx53 changes to crm_regs
Date: Mon, 29 Nov 2010 16:54:25 -0600
Message-ID: <1291071265-4238-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

MXC_xx are bit defines and maps that are shared between mx51 and mx53.
MX51_xx and MX53_xx are specific defines for those SoCs. For CSCDR1,
CSCDR2, CSCMR1, and CSCMR2, all the defines are prefixed with MX51 or MX53.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/clock-mx51-mx53.c |   82 +++++---
 arch/arm/mach-mx5/crm_regs.h        |  394 ++++++++++++++++++++++++-----------
 2 files changed, 328 insertions(+), 148 deletions(-)

diff --git a/arch/arm/mach-mx5/clock-mx51-mx53.c b/arch/arm/mach-mx5/clock-mx51-mx53.c
index 344ee8e..4672aca 100644
--- a/arch/arm/mach-mx5/clock-mx51-mx53.c
+++ b/arch/arm/mach-mx5/clock-mx51-mx53.c
@@ -354,9 +354,15 @@ static int _clk_pll2_sw_set_parent(struct clk *clk, struct clk *parent)
 static int _clk_lp_apm_set_parent(struct clk *clk, struct clk *parent)
 {
 	u32 reg;
+	u32 ccsr_lp_apm;
+
+	if (cpu_is_mx51())
+		ccsr_lp_apm = MX51_CCM_CCSR_LP_APM_SEL;
+	else /*mx53 */
+		ccsr_lp_apm = MX53_CCM_CCSR_LP_APM_SEL;
 
 	if (parent == &osc_clk)
-		reg = __raw_readl(MXC_CCM_CCSR) & ~MXC_CCM_CCSR_LP_APM_SEL;
+		reg = __raw_readl(MXC_CCM_CCSR) & ~ccsr_lp_apm;
 	else
 		return -EINVAL;
 
@@ -875,12 +881,24 @@ static struct clk emi_slow_clk = {
 static unsigned long clk_##name##_get_rate(struct clk *clk)		\
 {									\
 	u32 reg, pred, podf;						\
+	u32 clk_pred_mask = 0, clk_pred_offset = 0;\
+	u32 clk_podf_mask = 0, clk_podf_offset = 0;	\
 									\
 	reg = __raw_readl(MXC_CCM_CSCDR##nr);				\
-	pred = (reg & MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_MASK)	\
-		>> MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_OFFSET;	\
-	podf = (reg & MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_MASK)	\
-		>> MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_OFFSET;	\
+									\
+	if (cpu_is_mx51()) {	\
+		clk_pred_mask = MX51_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_MASK;\
+		clk_pred_offset = MX51_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_OFFSET;\
+		clk_podf_mask = MX51_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_MASK;\
+		clk_podf_offset = MX51_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_OFFSET;\
+	} else {\
+		clk_pred_mask = MX53_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_MASK;\
+		clk_pred_offset = MX53_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_OFFSET;\
+		clk_podf_mask = MX53_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_MASK;\
+		clk_podf_offset = MX53_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_OFFSET;\
+	} \
+	pred = (reg & clk_pred_mask) >> clk_pred_offset;	\
+	podf = (reg & clk_podf_mask) >> clk_podf_offset;	\
 									\
 	return DIV_ROUND_CLOSEST(clk_get_rate(clk->parent),		\
 			(pred + 1) * (podf + 1));			\
@@ -890,12 +908,19 @@ static unsigned long clk_##name##_get_rate(struct clk *clk)		\
 static int clk_##name##_set_parent(struct clk *clk, struct clk *parent)	\
 {									\
 	u32 reg, mux;							\
+	u32 clk_sel_mask = 0, clk_sel_offset = 0;\
 									\
+	if (cpu_is_mx51()) {	\
+		clk_sel_mask = MX51_CCM_CSCMR##nr##_##bitsname##_CLK_SEL_MASK;\
+		clk_sel_offset = MX51_CCM_CSCMR##nr##_##bitsname##_CLK_SEL_OFFSET;\
+	} else {\
+		clk_sel_mask = MX53_CCM_CSCMR##nr##_##bitsname##_CLK_SEL_MASK;\
+		clk_sel_offset = MX53_CCM_CSCMR##nr##_##bitsname##_CLK_SEL_OFFSET;\
+	} \
 	mux = _get_mux(parent, &pll1_sw_clk, &pll2_sw_clk,		\
 			&pll3_sw_clk, &lp_apm_clk);			\
-	reg = __raw_readl(MXC_CCM_CSCMR##nr) &				\
-		~MXC_CCM_CSCMR##nr##_##bitsname##_CLK_SEL_MASK;		\
-	reg |= mux << MXC_CCM_CSCMR##nr##_##bitsname##_CLK_SEL_OFFSET;	\
+	reg = __raw_readl(MXC_CCM_CSCMR##nr) & ~clk_sel_mask;		\
+	reg |= mux << clk_sel_offset;	\
 	__raw_writel(reg, MXC_CCM_CSCMR##nr);				\
 									\
 	return 0;							\
@@ -906,6 +931,8 @@ static int clk_##name##_set_rate(struct clk *clk, unsigned long rate)	\
 {									\
 	u32 reg, div, parent_rate;					\
 	u32 pre = 0, post = 0;						\
+	u32 clk_pred_mask = 0, clk_pred_offset = 0;\
+	u32 clk_podf_mask = 0, clk_podf_offset = 0;\
 									\
 	parent_rate = clk_get_rate(clk->parent);			\
 	div = parent_rate / rate;					\
@@ -913,20 +940,25 @@ static int clk_##name##_set_rate(struct clk *clk, unsigned long rate)	\
 	if ((parent_rate / div) != rate)				\
 		return -EINVAL;						\
 									\
+	if (cpu_is_mx51()) {	\
+		clk_pred_mask = MX51_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_MASK;\
+		clk_pred_offset = MX51_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_OFFSET;\
+		clk_podf_mask = MX51_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_MASK;\
+		clk_podf_offset = MX51_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_OFFSET;\
+	} else {\
+		clk_pred_mask = MX53_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_MASK;\
+		clk_pred_offset = MX53_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_OFFSET;\
+		clk_podf_mask = MX53_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_MASK;\
+		clk_podf_offset = MX53_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_OFFSET;\
+	} \
 	__calc_pre_post_dividers(div, &pre, &post,			\
-		(MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_MASK >>	\
-		MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_OFFSET) + 1,	\
-		(MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_MASK >>	\
-		MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_OFFSET) + 1);\
+		(clk_pred_mask >> clk_pred_offset) + 1, \
+		(clk_podf_mask >> clk_podf_offset) + 1);\
 									\
 	/* Set sdhc1 clock divider */					\
-	reg = __raw_readl(MXC_CCM_CSCDR##nr) &				\
-		~(MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_MASK	\
-		| MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_MASK);	\
-	reg |= (post - 1) <<						\
-		MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PODF_OFFSET;	\
-	reg |= (pre - 1) <<						\
-		MXC_CCM_CSCDR##nr##_##bitsname##_CLK_PRED_OFFSET;	\
+	reg = __raw_readl(MXC_CCM_CSCDR##nr) & ~(clk_pred_mask | clk_podf_mask);	\
+	reg |= (post - 1) << clk_podf_offset;\
+	reg |= (pre - 1) << clk_pred_offset;\
 	__raw_writel(reg, MXC_CCM_CSCDR##nr);				\
 									\
 	return 0;							\
@@ -963,13 +995,13 @@ static struct clk ecspi_main_clk = {
 };
 
 /* eSDHC */
-CLK_GET_RATE(esdhc1, 1, ESDHC1_MSHC1)
-CLK_SET_PARENT(esdhc1, 1, ESDHC1_MSHC1)
-CLK_SET_RATE(esdhc1, 1, ESDHC1_MSHC1)
+CLK_GET_RATE(esdhc1, 1, ESDHC1_MSHC2)
+CLK_SET_PARENT(esdhc1, 1, ESDHC1_MSHC2)
+CLK_SET_RATE(esdhc1, 1, ESDHC1_MSHC2)
 
-CLK_GET_RATE(esdhc2, 1, ESDHC2_MSHC2)
-CLK_SET_PARENT(esdhc2, 1, ESDHC2_MSHC2)
-CLK_SET_RATE(esdhc2, 1, ESDHC2_MSHC2)
+CLK_GET_RATE(esdhc2, 1, ESDHC2_3_MSHC2)
+CLK_SET_PARENT(esdhc2, 1, ESDHC2_3_MSHC2)
+CLK_SET_RATE(esdhc2, 1, ESDHC2_3_MSHC2)
 
 #define DEFINE_CLOCK_FULL(name, i, er, es, gr, sr, e, d, p, s)		\
 	static struct clk name = {					\
diff --git a/arch/arm/mach-mx5/crm_regs.h b/arch/arm/mach-mx5/crm_regs.h
index 51ff9bb..6d099a1 100644
--- a/arch/arm/mach-mx5/crm_regs.h
+++ b/arch/arm/mach-mx5/crm_regs.h
@@ -19,7 +19,13 @@
 #define MX51_GPC_BASE		MX51_IO_ADDRESS(MX51_GPC_BASE_ADDR)
 
 /*MX53*/
-#define MX53_DPLL4_BASE		MX53_IO_ADDRESS(MX53_PLL3_BASE_ADDR)
+#define MX53_CCM_BASE		MX53_IO_ADDRESS(MX53_CCM_BASE_ADDR)
+#define MX53_DPLL1_BASE	MX53_IO_ADDRESS(MX53_PLL1_BASE_ADDR)
+#define MX53_DPLL2_BASE	MX53_IO_ADDRESS(MX53_PLL2_BASE_ADDR)
+#define MX53_DPLL3_BASE	MX53_IO_ADDRESS(MX53_PLL3_BASE_ADDR)
+#define MX53_DPLL4_BASE	MX53_IO_ADDRESS(MX53_PLL4_BASE_ADDR)
+#define MX53_CORTEXA8_BASE	MX53_IO_ADDRESS(MX53_ARM_BASE_ADDR)
+#define MX53_GPC_BASE		MX53_IO_ADDRESS(MX53_GPC_BASE_ADDR)
 
 /* PLL Register Offsets */
 #define MXC_PLL_DP_CTL			0x00
@@ -110,7 +116,9 @@
 #define MXC_CCM_CCGR4		(MX51_CCM_BASE + 0x78)
 #define MXC_CCM_CCGR5		(MX51_CCM_BASE + 0x7C)
 #define MXC_CCM_CCGR6		(MX51_CCM_BASE + 0x80)
-#define MXC_CCM_CMEOR		(MX51_CCM_BASE + 0x84)
+#define MX51_CCM_CMEOR		(MX51_CCM_BASE + 0x84)
+#define MX53_CCM_CCGR7		(MX51_CCM_BASE + 0x84)
+#define MX53_CCM_CMEOR		(MX51_CCM_BASE + 0x88)
 
 /* Define the bits in register CCR */
 #define MXC_CCM_CCR_COSC_EN		(1 << 12)
@@ -123,8 +131,13 @@
 
 /* Define the bits in register CCDR */
 #define MXC_CCM_CCDR_HSC_HS_MASK	(0x1 << 18)
-#define MXC_CCM_CCDR_IPU_HS_MASK	(0x1 << 17)
 #define MXC_CCM_CCDR_EMI_HS_MASK	(0x1 << 16)
+#define MX51_CCM_CCDR_IPU_HS_MASK	(0x1 << 17)
+#define MX53_CCM_CCDR_IPU_HS_MASK	(0x1 << 21)
+#define MX53_CCM_CCDR_EMI_HS_INT2_MASK	(0x1 << 20)
+#define MX53_CCM_CCDR_EMI_HS_INT1_MASK	(0x1 << 19)
+#define MX53_CCM_CCDR_EMI_HS_SLOW_MASK	(0x1 << 18)
+#define MX53_CCM_CCDR_EMI_HS_FAST_MASK	(0x1 << 17)
 
 /* Define the bits in register CSR */
 #define MXC_CCM_CSR_COSR_READY	(1 << 5)
@@ -133,9 +146,9 @@
 #define MXC_CCM_CSR_CAMP1_READY	(1 << 2)
 #define MXC_CCM_CSR_FPM_READY	(1 << 1)
 #define MXC_CCM_CSR_REF_EN_B	(1 << 0)
+#define MX53_CCM_CSR_TEMP_MON_ALARM	(1 << 1)
 
 /* Define the bits in register CCSR */
-#define MXC_CCM_CCSR_LP_APM_SEL		(0x1 << 9)
 #define MXC_CCM_CCSR_STEP_SEL_OFFSET	(7)
 #define MXC_CCM_CCSR_STEP_SEL_MASK	(0x3 << 7)
 #define MXC_CCM_CCSR_STEP_SEL_LP_APM	   0
@@ -150,6 +163,9 @@
 						    1: step_clk */
 #define MXC_CCM_CCSR_PLL2_SW_CLK_SEL	(1 << 1)
 #define MXC_CCM_CCSR_PLL3_SW_CLK_SEL	(1 << 0)
+#define MX51_CCM_CCSR_LP_APM_SEL	(0x1 << 9)
+#define MX53_CCM_CCSR_LP_APM_SEL	(0x1 << 10)
+#define MX53_CCM_CCSR_PLL4_SW_CLK_SEL	(1 << 9)
 
 /* Define the bits in register CACRR */
 #define MXC_CCM_CACRR_ARM_PODF_OFFSET	(0)
@@ -198,89 +214,169 @@
 #define MXC_CCM_CBCMR_GPU2D_CLK_SEL_MASK	(0x3 << 14)
 #define MXC_CCM_CBCMR_PERCLK_LP_APM_CLK_SEL	(0x1 << 1)
 #define MXC_CCM_CBCMR_PERCLK_IPG_CLK_SEL	(0x1 << 0)
+#define MX53_CCM_CBCMR_GPU2D_CLK_SEL_OFFSET	(16)
+#define MX53_CCM_CBCMR_GPU2D_CLK_SEL_MASK		(0x3 << 16)
 
 /* Define the bits in register CSCMR1 */
-#define MXC_CCM_CSCMR1_SSI_EXT2_CLK_SEL_OFFSET		(30)
-#define MXC_CCM_CSCMR1_SSI_EXT2_CLK_SEL_MASK		(0x3 << 30)
-#define MXC_CCM_CSCMR1_SSI_EXT1_CLK_SEL_OFFSET		(28)
-#define MXC_CCM_CSCMR1_SSI_EXT1_CLK_SEL_MASK		(0x3 << 28)
-#define MXC_CCM_CSCMR1_USB_PHY_CLK_SEL_OFFSET		(26)
-#define MXC_CCM_CSCMR1_USB_PHY_CLK_SEL			(0x1 << 26)
-#define MXC_CCM_CSCMR1_UART_CLK_SEL_OFFSET		(24)
-#define MXC_CCM_CSCMR1_UART_CLK_SEL_MASK		(0x3 << 24)
-#define MXC_CCM_CSCMR1_USBOH3_CLK_SEL_OFFSET		(22)
-#define MXC_CCM_CSCMR1_USBOH3_CLK_SEL_MASK		(0x3 << 22)
-#define MXC_CCM_CSCMR1_ESDHC1_MSHC1_CLK_SEL_OFFSET	(20)
-#define MXC_CCM_CSCMR1_ESDHC1_MSHC1_CLK_SEL_MASK	(0x3 << 20)
-#define MXC_CCM_CSCMR1_ESDHC3_CLK_SEL			(0x1 << 19)
-#define MXC_CCM_CSCMR1_ESDHC4_CLK_SEL			(0x1 << 18)
-#define MXC_CCM_CSCMR1_ESDHC2_MSHC2_CLK_SEL_OFFSET	(16)
-#define MXC_CCM_CSCMR1_ESDHC2_MSHC2_CLK_SEL_MASK	(0x3 << 16)
-#define MXC_CCM_CSCMR1_SSI1_CLK_SEL_OFFSET		(14)
-#define MXC_CCM_CSCMR1_SSI1_CLK_SEL_MASK		(0x3 << 14)
-#define MXC_CCM_CSCMR1_SSI2_CLK_SEL_OFFSET		(12)
-#define MXC_CCM_CSCMR1_SSI2_CLK_SEL_MASK		(0x3 << 12)
-#define MXC_CCM_CSCMR1_SSI3_CLK_SEL			(0x1 << 11)
-#define MXC_CCM_CSCMR1_VPU_RCLK_SEL			(0x1 << 10)
-#define MXC_CCM_CSCMR1_SSI_APM_CLK_SEL_OFFSET		(8)
-#define MXC_CCM_CSCMR1_SSI_APM_CLK_SEL_MASK		(0x3 << 8)
-#define MXC_CCM_CSCMR1_TVE_CLK_SEL			(0x1 << 7)
-#define MXC_CCM_CSCMR1_TVE_EXT_CLK_SEL			(0x1 << 6)
-#define MXC_CCM_CSCMR1_CSPI_CLK_SEL_OFFSET		(4)
-#define MXC_CCM_CSCMR1_CSPI_CLK_SEL_MASK		(0x3 << 4)
-#define MXC_CCM_CSCMR1_SPDIF_CLK_SEL_OFFSET		(2)
-#define MXC_CCM_CSCMR1_SPDIF_CLK_SEL_MASK		(0x3 << 2)
-#define MXC_CCM_CSCMR1_SSI_EXT2_COM_CLK_SEL		(0x1 << 1)
-#define MXC_CCM_CSCMR1_SSI_EXT1_COM_CLK_SEL		(0x1)
+#define MX51_CCM_CSCMR1_SSI_EXT2_CLK_SEL_OFFSET		(30)
+#define MX51_CCM_CSCMR1_SSI_EXT2_CLK_SEL_MASK		(0x3 << 30)
+#define MX51_CCM_CSCMR1_SSI_EXT1_CLK_SEL_OFFSET		(28)
+#define MX51_CCM_CSCMR1_SSI_EXT1_CLK_SEL_MASK		(0x3 << 28)
+#define MX51_CCM_CSCMR1_USB_PHY_CLK_SEL_OFFSET		(26)
+#define MX51_CCM_CSCMR1_USB_PHY_CLK_SEL			(0x1 << 26)
+#define MX51_CCM_CSCMR1_UART_CLK_SEL_OFFSET		(24)
+#define MX51_CCM_CSCMR1_UART_CLK_SEL_MASK		(0x3 << 24)
+#define MX51_CCM_CSCMR1_USBOH3_CLK_SEL_OFFSET		(22)
+#define MX51_CCM_CSCMR1_USBOH3_CLK_SEL_MASK		(0x3 << 22)
+#define MX51_CCM_CSCMR1_ESDHC1_MSHC2_CLK_SEL_OFFSET	(20)
+#define MX51_CCM_CSCMR1_ESDHC1_MSHC2_CLK_SEL_MASK	(0x3 << 20)
+#define MX51_CCM_CSCMR1_ESDHC3_CLK_SEL		(0x1 << 19)
+#define MX51_CCM_CSCMR1_ESDHC4_CLK_SEL			(0x1 << 18)
+#define MX51_CCM_CSCMR1_ESDHC2_3_MSHC2_CLK_SEL_OFFSET	(16)
+#define MX51_CCM_CSCMR1_ESDHC2_3_MSHC2_CLK_SEL_MASK	(0x3 << 16)
+#define MX51_CCM_CSCMR1_SSI1_CLK_SEL_OFFSET		(14)
+#define MX51_CCM_CSCMR1_SSI1_CLK_SEL_MASK		(0x3 << 14)
+#define MX51_CCM_CSCMR1_SSI2_CLK_SEL_OFFSET		(12)
+#define MX51_CCM_CSCMR1_SSI2_CLK_SEL_MASK		(0x3 << 12)
+#define MX51_CCM_CSCMR1_SSI3_CLK_SEL			(0x1 << 11)
+#define MX51_CCM_CSCMR1_VPU_RCLK_SEL			(0x1 << 10)
+#define MX51_CCM_CSCMR1_SSI_APM_CLK_SEL_OFFSET		(8)
+#define MX51_CCM_CSCMR1_SSI_APM_CLK_SEL_MASK		(0x3 << 8)
+#define MX51_CCM_CSCMR1_TVE_CLK_SEL			(0x1 << 7)
+#define MX51_CCM_CSCMR1_TVE_EXT_CLK_SEL			(0x1 << 6)
+#define MX51_CCM_CSCMR1_CSPI_CLK_SEL_OFFSET		(4)
+#define MX51_CCM_CSCMR1_CSPI_CLK_SEL_MASK		(0x3 << 4)
+#define MX51_CCM_CSCMR1_SPDIF_CLK_SEL_OFFSET		(2)
+#define MX51_CCM_CSCMR1_SPDIF_CLK_SEL_MASK		(0x3 << 2)
+#define MX51_CCM_CSCMR1_SSI_EXT2_COM_CLK_SEL		(0x1 << 1)
+#define MX51_CCM_CSCMR1_SSI_EXT1_COM_CLK_SEL		(0x1)
+
+#define MX53_CCM_CSCMR1_SSI_EXT2_CLK_SEL_OFFSET		(30)
+#define MX53_CCM_CSCMR1_SSI_EXT2_CLK_SEL_MASK		(0x3 << 30)
+#define MX53_CCM_CSCMR1_SSI_EXT1_CLK_SEL_OFFSET		(28)
+#define MX53_CCM_CSCMR1_SSI_EXT1_CLK_SEL_MASK		(0x3 << 28)
+#define MX53_CCM_CSCMR1_USB_PHY_CLK_SEL_OFFSET		(26)
+#define MX53_CCM_CSCMR1_USB_PHY_CLK_SEL			(0x1 << 26)
+#define MX53_CCM_CSCMR1_UART_CLK_SEL_OFFSET		(24)
+#define MX53_CCM_CSCMR1_UART_CLK_SEL_MASK		(0x3 << 24)
+#define MX53_CCM_CSCMR1_USBOH3_CLK_SEL_OFFSET		(22)
+#define MX53_CCM_CSCMR1_USBOH3_CLK_SEL_MASK		(0x3 << 22)
+#define MX53_CCM_CSCMR1_ESDHC1_MSHC2_CLK_SEL_OFFSET	(20)
+#define MX53_CCM_CSCMR1_ESDHC1_MSHC2_CLK_SEL_MASK	(0x3 << 20)
+#define MX53_CCM_CSCMR1_ESDHC2_CLK_SEL		(0x1 << 19)
+#define MX53_CCM_CSCMR1_ESDHC4_CLK_SEL			(0x1 << 18)
+#define MX53_CCM_CSCMR1_ESDHC2_3_MSHC2_CLK_SEL_OFFSET	(16)
+#define MX53_CCM_CSCMR1_ESDHC2_3_MSHC2_CLK_SEL_MASK	(0x3 << 16)
+#define MX53_CCM_CSCMR1_SSI1_CLK_SEL_OFFSET		(14)
+#define MX53_CCM_CSCMR1_SSI1_CLK_SEL_MASK		(0x3 << 14)
+#define MX53_CCM_CSCMR1_SSI2_CLK_SEL_OFFSET		(12)
+#define MX53_CCM_CSCMR1_SSI2_CLK_SEL_MASK		(0x3 << 12)
+#define MX53_CCM_CSCMR1_SSI3_CLK_SEL			(0x1 << 11)
+#define MX53_CCM_CSCMR1_VPU_RCLK_SEL			(0x1 << 10)
+#define MX53_CCM_CSCMR1_SSI_APM_CLK_SEL_OFFSET		(8)
+#define MX53_CCM_CSCMR1_SSI_APM_CLK_SEL_MASK		(0x3 << 8)
+#define MX53_CCM_CSCMR1_TVE_CLK_SEL			(0x1 << 7)
+#define MX53_CCM_CSCMR1_TVE_EXT_CLK_SEL			(0x1 << 6)
+#define MX53_CCM_CSCMR1_CSPI_CLK_SEL_OFFSET		(4)
+#define MX53_CCM_CSCMR1_CSPI_CLK_SEL_MASK		(0x3 << 4)
+#define MX53_CCM_CSCMR1_SPDIF_CLK_SEL_OFFSET		(2)
+#define MX53_CCM_CSCMR1_SPDIF_CLK_SEL_MASK		(0x3 << 2)
+#define MX53_CCM_CSCMR1_SSI_EXT2_COM_CLK_SEL		(0x1 << 1)
+#define MX53_CCM_CSCMR1_SSI_EXT1_COM_CLK_SEL		(0x1)
+
 
 /* Define the bits in register CSCMR2 */
-#define MXC_CCM_CSCMR2_DI_CLK_SEL_OFFSET(n)		(26+n*3)
-#define MXC_CCM_CSCMR2_DI_CLK_SEL_MASK(n)		(0x7 << (26+n*3))
-#define MXC_CCM_CSCMR2_CSI_MCLK2_CLK_SEL_OFFSET		(24)
-#define MXC_CCM_CSCMR2_CSI_MCLK2_CLK_SEL_MASK		(0x3 << 24)
-#define MXC_CCM_CSCMR2_CSI_MCLK1_CLK_SEL_OFFSET		(22)
-#define MXC_CCM_CSCMR2_CSI_MCLK1_CLK_SEL_MASK		(0x3 << 22)
-#define MXC_CCM_CSCMR2_ESC_CLK_SEL_OFFSET		(20)
-#define MXC_CCM_CSCMR2_ESC_CLK_SEL_MASK			(0x3 << 20)
-#define MXC_CCM_CSCMR2_HSC2_CLK_SEL_OFFSET		(18)
-#define MXC_CCM_CSCMR2_HSC2_CLK_SEL_MASK		(0x3 << 18)
-#define MXC_CCM_CSCMR2_HSC1_CLK_SEL_OFFSET		(16)
-#define MXC_CCM_CSCMR2_HSC1_CLK_SEL_MASK		(0x3 << 16)
-#define MXC_CCM_CSCMR2_HSI2C_CLK_SEL_OFFSET		(14)
-#define MXC_CCM_CSCMR2_HSI2C_CLK_SEL_MASK		(0x3 << 14)
-#define MXC_CCM_CSCMR2_FIRI_CLK_SEL_OFFSET		(12)
-#define MXC_CCM_CSCMR2_FIRI_CLK_SEL_MASK		(0x3 << 12)
-#define MXC_CCM_CSCMR2_SIM_CLK_SEL_OFFSET		(10)
-#define MXC_CCM_CSCMR2_SIM_CLK_SEL_MASK			(0x3 << 10)
-#define MXC_CCM_CSCMR2_SLIMBUS_COM			(0x1 << 9)
-#define MXC_CCM_CSCMR2_SLIMBUS_CLK_SEL_OFFSET		(6)
-#define MXC_CCM_CSCMR2_SLIMBUS_CLK_SEL_MASK		(0x7 << 6)
-#define MXC_CCM_CSCMR2_SPDIF1_COM			(1 << 5)
-#define MXC_CCM_CSCMR2_SPDIF0_COM			(1 << 4)
-#define MXC_CCM_CSCMR2_SPDIF1_CLK_SEL_OFFSET		(2)
-#define MXC_CCM_CSCMR2_SPDIF1_CLK_SEL_MASK		(0x3 << 2)
-#define MXC_CCM_CSCMR2_SPDIF0_CLK_SEL_OFFSET		(0)
-#define MXC_CCM_CSCMR2_SPDIF0_CLK_SEL_MASK		(0x3)
+#define MX51_CCM_CSCMR2_DI_CLK_SEL_OFFSET(n)		(26+n*3)
+#define MX51_CCM_CSCMR2_DI_CLK_SEL_MASK(n)		(0x7 << (26+n*3))
+#define MX51_CCM_CSCMR2_CSI_MCLK2_CLK_SEL_OFFSET		(24)
+#define MX51_CCM_CSCMR2_CSI_MCLK2_CLK_SEL_MASK		(0x3 << 24)
+#define MX51_CCM_CSCMR2_CSI_MCLK1_CLK_SEL_OFFSET		(22)
+#define MX51_CCM_CSCMR2_CSI_MCLK1_CLK_SEL_MASK		(0x3 << 22)
+#define MX51_CCM_CSCMR2_ESC_CLK_SEL_OFFSET		(20)
+#define MX51_CCM_CSCMR2_ESC_CLK_SEL_MASK			(0x3 << 20)
+#define MX51_CCM_CSCMR2_HSC2_CLK_SEL_OFFSET		(18)
+#define MX51_CCM_CSCMR2_HSC2_CLK_SEL_MASK		(0x3 << 18)
+#define MX51_CCM_CSCMR2_HSC1_CLK_SEL_OFFSET		(16)
+#define MX51_CCM_CSCMR2_HSC1_CLK_SEL_MASK		(0x3 << 16)
+#define MX51_CCM_CSCMR2_HSI2C_CLK_SEL_OFFSET		(14)
+#define MX51_CCM_CSCMR2_HSI2C_CLK_SEL_MASK		(0x3 << 14)
+#define MX51_CCM_CSCMR2_FIRI_CLK_SEL_OFFSET		(12)
+#define MX51_CCM_CSCMR2_FIRI_CLK_SEL_MASK		(0x3 << 12)
+#define MX51_CCM_CSCMR2_SIM_CLK_SEL_OFFSET		(10)
+#define MX51_CCM_CSCMR2_SIM_CLK_SEL_MASK			(0x3 << 10)
+#define MX51_CCM_CSCMR2_SLIMBUS_COM			(0x1 << 9)
+#define MX51_CCM_CSCMR2_SLIMBUS_CLK_SEL_OFFSET		(6)
+#define MX51_CCM_CSCMR2_SLIMBUS_CLK_SEL_MASK		(0x7 << 6)
+#define MX51_CCM_CSCMR2_SPDIF1_COM			(1 << 5)
+#define MX51_CCM_CSCMR2_SPDIF0_COM			(1 << 4)
+#define MX51_CCM_CSCMR2_SPDIF1_CLK_SEL_OFFSET		(2)
+#define MX51_CCM_CSCMR2_SPDIF1_CLK_SEL_MASK		(0x3 << 2)
+#define MX51_CCM_CSCMR2_SPDIF0_CLK_SEL_OFFSET		(0)
+#define MX51_CCM_CSCMR2_SPDIF0_CLK_SEL_MASK		(0x3)
+
+#define MX53_CCM_CSCMR2_DI_CLK_SEL_OFFSET(n)		(26+n*3)
+#define MX53_CCM_CSCMR2_DI_CLK_SEL_MASK(n)		(0x7 << (26+n*3))
+#define MX53_CCM_CSCMR2_CSI_MCLK2_CLK_SEL_OFFSET		(24)
+#define MX53_CCM_CSCMR2_CSI_MCLK2_CLK_SEL_MASK		(0x3 << 24)
+#define MX53_CCM_CSCMR2_CSI_MCLK1_CLK_SEL_OFFSET		(22)
+#define MX53_CCM_CSCMR2_CSI_MCLK1_CLK_SEL_MASK		(0x3 << 22)
+#define MX53_CCM_CSCMR2_ASRC_CLK_SEL			(1<<21)
+#define MX53_CCM_CSCMR2_ESAI_PRE_SEL_OFFSET		(19)
+#define MX53_CCM_CSCMR2_ESAI_PRE_SEL_MASK		(0x3 << 19)
+#define MX53_CCM_CSCMR2_ESAI_POST_SEL_OFFSET	(16)
+#define MX53_CCM_CSCMR2_ESAI_POST_SEL_MASK		(0x7 << 16)
+#define MX53_CCM_CSCMR2_IEEE_CLK_SEL_OFFSET		(14)
+#define MX53_CCM_CSCMR2_IEEE_CLK_SEL_MASK		(0x3 << 14)
+#define MX53_CCM_CSCMR2_FIRI_CLK_SEL_OFFSET		(12)
+#define MX53_CCM_CSCMR2_FIRI_CLK_SEL_MASK		(0x3 << 12)
+#define MX53_CCM_CSCMR2_LBD_DI1_IPU_DIV		(0x1 << 11)
+#define MX53_CCM_CSCMR2_LBD_DI0_IPU_DIV		(0x1 << 10)
+#define MX53_CCM_CSCMR2_LBD_DI1_CLK_SEL		(0x1 << 9)
+#define MX53_CCM_CSCMR2_LBD_DI0_CLK_SEL		(0x1 << 8)
+#define MX53_CCM_CSCMR2_CAN_CLK_SEL_OFFSET		(6)
+#define MX53_CCM_CSCMR2_CAN_CLK_SEL_MASK		(0x3 << 6)
+#define MX53_CCM_CSCMR2_SPDIF0_COM			(1 << 4)
+#define MX53_CCM_CSCMR2_SPDIF0_CLK_SEL_OFFSET	(0)
+#define MX53_CCM_CSCMR2_SPDIF0_CLK_SEL_MASK	(0x3)
 
 /* Define the bits in register CSCDR1 */
-#define MXC_CCM_CSCDR1_ESDHC2_MSHC2_CLK_PRED_OFFSET	(22)
-#define MXC_CCM_CSCDR1_ESDHC2_MSHC2_CLK_PRED_MASK	(0x7 << 22)
-#define MXC_CCM_CSCDR1_ESDHC2_MSHC2_CLK_PODF_OFFSET	(19)
-#define MXC_CCM_CSCDR1_ESDHC2_MSHC2_CLK_PODF_MASK	(0x7 << 19)
-#define MXC_CCM_CSCDR1_ESDHC1_MSHC1_CLK_PRED_OFFSET	(16)
-#define MXC_CCM_CSCDR1_ESDHC1_MSHC1_CLK_PRED_MASK	(0x7 << 16)
-#define MXC_CCM_CSCDR1_PGC_CLK_PODF_OFFSET		(14)
-#define MXC_CCM_CSCDR1_PGC_CLK_PODF_MASK		(0x3 << 14)
-#define MXC_CCM_CSCDR1_ESDHC1_MSHC1_CLK_PODF_OFFSET	(11)
-#define MXC_CCM_CSCDR1_ESDHC1_MSHC1_CLK_PODF_MASK	(0x7 << 11)
-#define MXC_CCM_CSCDR1_USBOH3_CLK_PRED_OFFSET		(8)
-#define MXC_CCM_CSCDR1_USBOH3_CLK_PRED_MASK		(0x7 << 8)
-#define MXC_CCM_CSCDR1_USBOH3_CLK_PODF_OFFSET		(6)
-#define MXC_CCM_CSCDR1_USBOH3_CLK_PODF_MASK		(0x3 << 6)
-#define MXC_CCM_CSCDR1_UART_CLK_PRED_OFFSET		(3)
-#define MXC_CCM_CSCDR1_UART_CLK_PRED_MASK		(0x7 << 3)
-#define MXC_CCM_CSCDR1_UART_CLK_PODF_OFFSET		(0)
-#define MXC_CCM_CSCDR1_UART_CLK_PODF_MASK		(0x7)
+#define MX51_CCM_CSCDR1_ESDHC2_3_MSHC2_CLK_PRED_OFFSET	(22)
+#define MX51_CCM_CSCDR1_ESDHC2_3_MSHC2_CLK_PRED_MASK	(0x7 << 22)
+#define MX51_CCM_CSCDR1_ESDHC2_3_MSHC2_CLK_PODF_OFFSET	(19)
+#define MX51_CCM_CSCDR1_ESDHC2_3_MSHC2_CLK_PODF_MASK	(0x7 << 19)
+#define MX51_CCM_CSCDR1_ESDHC1_MSHC2_CLK_PRED_OFFSET	(16)
+#define MX51_CCM_CSCDR1_ESDHC1_MSHC2_CLK_PRED_MASK	(0x7 << 16)
+#define MX51_CCM_CSCDR1_PGC_CLK_PODF_OFFSET		(14)
+#define MX51_CCM_CSCDR1_PGC_CLK_PODF_MASK		(0x3 << 14)
+#define MX51_CCM_CSCDR1_ESDHC1_MSHC2_CLK_PODF_OFFSET	(11)
+#define MX51_CCM_CSCDR1_ESDHC1_MSHC2_CLK_PODF_MASK	(0x7 << 11)
+#define MX51_CCM_CSCDR1_USBOH3_CLK_PRED_OFFSET		(8)
+#define MX51_CCM_CSCDR1_USBOH3_CLK_PRED_MASK		(0x7 << 8)
+#define MX51_CCM_CSCDR1_USBOH3_CLK_PODF_OFFSET		(6)
+#define MX51_CCM_CSCDR1_USBOH3_CLK_PODF_MASK		(0x3 << 6)
+#define MX51_CCM_CSCDR1_UART_CLK_PRED_OFFSET		(3)
+#define MX51_CCM_CSCDR1_UART_CLK_PRED_MASK		(0x7 << 3)
+#define MX51_CCM_CSCDR1_UART_CLK_PODF_OFFSET		(0)
+#define MX51_CCM_CSCDR1_UART_CLK_PODF_MASK		(0x7)
+
+#define MX53_CCM_CSCDR1_ESDHC2_3_MSHC2_CLK_PRED_OFFSET	(22)
+#define MX53_CCM_CSCDR1_ESDHC2_3_MSHC2_CLK_PRED_MASK	(0x7 << 22)
+#define MX53_CCM_CSCDR1_ESDHC2_3_MSHC2_CLK_PODF_OFFSET	(19)
+#define MX53_CCM_CSCDR1_ESDHC2_3_MSHC2_CLK_PODF_MASK	(0x7 << 19)
+#define MX53_CCM_CSCDR1_ESDHC1_MSHC2_CLK_PRED_OFFSET	(16)
+#define MX53_CCM_CSCDR1_ESDHC1_MSHC2_CLK_PRED_MASK	(0x7 << 16)
+#define MX53_CCM_CSCDR1_PGC_CLK_PODF_OFFSET		(14)
+#define MX53_CCM_CSCDR1_PGC_CLK_PODF_MASK		(0x3 << 14)
+#define MX53_CCM_CSCDR1_ESDHC1_MSHC2_CLK_PODF_OFFSET	(11)
+#define MX53_CCM_CSCDR1_ESDHC1_MSHC2_CLK_PODF_MASK	(0x7 << 11)
+#define MX53_CCM_CSCDR1_USBOH3_CLK_PRED_OFFSET		(8)
+#define MX53_CCM_CSCDR1_USBOH3_CLK_PRED_MASK		(0x7 << 8)
+#define MX53_CCM_CSCDR1_USBOH3_CLK_PODF_OFFSET		(6)
+#define MX53_CCM_CSCDR1_USBOH3_CLK_PODF_MASK		(0x3 << 6)
+#define MX53_CCM_CSCDR1_UART_CLK_PRED_OFFSET		(3)
+#define MX53_CCM_CSCDR1_UART_CLK_PRED_MASK		(0x7 << 3)
+#define MX53_CCM_CSCDR1_UART_CLK_PODF_OFFSET		(0)
+#define MX53_CCM_CSCDR1_UART_CLK_PODF_MASK		(0x7)
 
 /* Define the bits in register CS1CDR and CS2CDR */
 #define MXC_CCM_CS1CDR_SSI_EXT1_CLK_PRED_OFFSET		(22)
@@ -291,6 +387,10 @@
 #define MXC_CCM_CS1CDR_SSI1_CLK_PRED_MASK		(0x7 << 6)
 #define MXC_CCM_CS1CDR_SSI1_CLK_PODF_OFFSET		(0)
 #define MXC_CCM_CS1CDR_SSI1_CLK_PODF_MASK		(0x3F)
+#define MX53_CCM_CS1CDR_ESAI_CLK_PODF_OFFSET		(25)
+#define MX53_CCM_CS1CDR_ESAI_CLK_PODF_MASK			(0x3F << 25)
+#define MX53_CCM_CS1CDR_ESAI_CLK_PRED_OFFSET		(9)
+#define MX53_CCM_CS1CDR_ESAI_CLK_PRED_MASK			(0x7 << 9)
 
 #define MXC_CCM_CS2CDR_SSI_EXT2_CLK_PRED_OFFSET		(22)
 #define MXC_CCM_CS2CDR_SSI_EXT2_CLK_PRED_MASK		(0x7 << 22)
@@ -308,50 +408,73 @@
 #define MXC_CCM_CDCDR_SPDIF0_CLK_PRED_MASK		(0x7 << 25)
 #define MXC_CCM_CDCDR_SPDIF0_CLK_PODF_OFFSET		(19)
 #define MXC_CCM_CDCDR_SPDIF0_CLK_PODF_MASK		(0x3F << 19)
-#define MXC_CCM_CDCDR_SPDIF1_CLK_PRED_OFFSET		(16)
-#define MXC_CCM_CDCDR_SPDIF1_CLK_PRED_MASK		(0x7 << 16)
 #define MXC_CCM_CDCDR_SPDIF1_CLK_PODF_OFFSET		(9)
 #define MXC_CCM_CDCDR_SPDIF1_CLK_PODF_MASK		(0x3F << 9)
-#define MXC_CCM_CDCDR_DI_CLK_PRED_OFFSET		(6)
-#define MXC_CCM_CDCDR_DI_CLK_PRED_MASK			(0x7 << 6)
+#define MXC_CCM_CDCDR_DI1_CLK_PRED_OFFSET		(6)
+#define MXC_CCM_CDCDR_DI1_CLK_PRED_MASK			(0x7 << 6)
 #define MXC_CCM_CDCDR_USB_PHY_PRED_OFFSET		(3)
 #define MXC_CCM_CDCDR_USB_PHY_PRED_MASK			(0x7 << 3)
 #define MXC_CCM_CDCDR_USB_PHY_PODF_OFFSET		(0)
 #define MXC_CCM_CDCDR_USB_PHY_PODF_MASK			(0x7)
+#define MX51_CCM_CDCDR_SPDIF1_CLK_PRED_OFFSET		(16)
+#define MX51_CCM_CDCDR_SPDIF1_CLK_PRED_MASK		(0x7 << 16)
+#define MX53_CCM_CDCDR_DI_PLL4_PODF_OFFSET		(16)
+#define MX53_CCM_CDCDR_DI_PLL4_PODF_MASK		(0x7 << 16)
 
 /* Define the bits in register CHSCCDR */
-#define MXC_CCM_CHSCCDR_ESC_CLK_PRED_OFFSET		(12)
-#define MXC_CCM_CHSCCDR_ESC_CLK_PRED_MASK		(0x7 << 12)
-#define MXC_CCM_CHSCCDR_ESC_CLK_PODF_OFFSET		(6)
-#define MXC_CCM_CHSCCDR_ESC_CLK_PODF_MASK		(0x3F << 6)
-#define MXC_CCM_CHSCCDR_HSC2_CLK_PODF_OFFSET		(3)
-#define MXC_CCM_CHSCCDR_HSC2_CLK_PODF_MASK		(0x7 << 3)
-#define MXC_CCM_CHSCCDR_HSC1_CLK_PODF_OFFSET		(0)
-#define MXC_CCM_CHSCCDR_HSC1_CLK_PODF_MASK		(0x7)
+#define MX51_CCM_CHSCCDR_ESC_CLK_PRED_OFFSET		(12)
+#define MX51_CCM_CHSCCDR_ESC_CLK_PRED_MASK		(0x7 << 12)
+#define MX51_CCM_CHSCCDR_ESC_CLK_PODF_OFFSET		(6)
+#define MX51_CCM_CHSCCDR_ESC_CLK_PODF_MASK		(0x3F << 6)
+#define MX51_CCM_CHSCCDR_HSC2_CLK_PODF_OFFSET		(3)
+#define MX51_CCM_CHSCCDR_HSC2_CLK_PODF_MASK		(0x7 << 3)
+#define MX51_CCM_CHSCCDR_HSC1_CLK_PODF_OFFSET		(0)
+#define MX51_CCM_CHSCCDR_HSC1_CLK_PODF_MASK		(0x7)
+#define MX53_CCM_CHSCCDR_ESAI_HCKT_SEL_OFFSET		(6)
+#define MX53_CCM_CHSCCDR_ESAI_HCKT_SEL_MASK		(0x3 << 6)
+#define MX53_CCM_CHSCCDR_ESAI_HCKR_SEL_OFFSET		(4)
+#define MX53_CCM_CHSCCDR_ESAI_HCKR_SEL_MASK		(0x3 << 4)
+#define MX53_CCM_CHSCCDR_SSI2_MLB_SPDIF_SRC_OFFSET	(2)
+#define MX53_CCM_CHSCCDR_SSI2_MLB_SPDIF_SRC_MASK		(0x3 << 2)
+#define MX53_CCM_CHSCCDR_SSI1_MLB_SPDIF_SRC_OFFSET	(0)
+#define MX53_CCM_CHSCCDR_SSI1_MLB_SPDIF_SRC_MASK		(0x3)
 
 /* Define the bits in register CSCDR2 */
-#define MXC_CCM_CSCDR2_CSPI_CLK_PRED_OFFSET		(25)
-#define MXC_CCM_CSCDR2_CSPI_CLK_PRED_MASK		(0x7 << 25)
-#define MXC_CCM_CSCDR2_CSPI_CLK_PODF_OFFSET		(19)
-#define MXC_CCM_CSCDR2_CSPI_CLK_PODF_MASK		(0x3F << 19)
-#define MXC_CCM_CSCDR2_SIM_CLK_PRED_OFFSET		(16)
-#define MXC_CCM_CSCDR2_SIM_CLK_PRED_MASK		(0x7 << 16)
-#define MXC_CCM_CSCDR2_SIM_CLK_PODF_OFFSET		(9)
-#define MXC_CCM_CSCDR2_SIM_CLK_PODF_MASK		(0x3F << 9)
-#define MXC_CCM_CSCDR2_SLIMBUS_CLK_PRED_OFFSET		(6)
-#define MXC_CCM_CSCDR2_SLIMBUS_PRED_MASK		(0x7 << 6)
-#define MXC_CCM_CSCDR2_SLIMBUS_PODF_OFFSET		(0)
-#define MXC_CCM_CSCDR2_SLIMBUS_PODF_MASK		(0x3F)
+#define MX51_CCM_CSCDR2_CSPI_CLK_PRED_OFFSET		(25)
+#define MX51_CCM_CSCDR2_CSPI_CLK_PRED_MASK		(0x7 << 25)
+#define MX51_CCM_CSCDR2_CSPI_CLK_PODF_OFFSET		(19)
+#define MX51_CCM_CSCDR2_CSPI_CLK_PODF_MASK		(0x3F << 19)
+#define MX51_CCM_CSCDR2_SIM_CLK_PRED_OFFSET		(16)
+#define MX51_CCM_CSCDR2_SIM_CLK_PRED_MASK		(0x7 << 16)
+#define MX51_CCM_CSCDR2_SIM_CLK_PODF_OFFSET		(9)
+#define MX51_CCM_CSCDR2_SIM_CLK_PODF_MASK		(0x3F << 9)
+#define MX51_CCM_CSCDR2_SLIMBUS_CLK_PRED_OFFSET		(6)
+#define MX51_CCM_CSCDR2_SLIMBUS_PRED_MASK		(0x7 << 6)
+#define MX51_CCM_CSCDR2_SLIMBUS_PODF_OFFSET		(0)
+#define MX51_CCM_CSCDR2_SLIMBUS_PODF_MASK		(0x3F)
+
+#define MX53_CCM_CSCDR2_ASRC_CLK_PRED_OFFSET	(28)
+#define MX53_CCM_CSCDR2_ASRC_CLK_PRED_MASK		(0x7 << 28)
+#define MX53_CCM_CSCDR2_CSPI_CLK_PRED_OFFSET		(25)
+#define MX53_CCM_CSCDR2_CSPI_CLK_PRED_MASK		(0x7 << 25)
+#define MX53_CCM_CSCDR2_CSPI_CLK_PODF_OFFSET		(19)
+#define MX53_CCM_CSCDR2_CSPI_CLK_PODF_MASK		(0x3F << 19)
+#define MX53_CCM_CSCDR2_ASRC_CLK_PODF_OFFSET	(9)
+#define MX53_CCM_CSCDR2_ASRC_CLK_PODF_MASK		(0x3F << 9)
+#define MX53_CCM_CSCDR2_IEEE_CLK_PRED_OFFSET	(6)
+#define MX53_CCM_CSCDR2_IEEE_CLK_PRED_MASK		(0x7 << 6)
+#define MX53_CCM_CSCDR2_IEEE_CLK_PODF_OFFSET	(0)
+#define MX53_CCM_CSCDR2_IEEE_CLK_PODF_MASK		(0x3F)
 
 /* Define the bits in register CSCDR3 */
-#define MXC_CCM_CSCDR3_HSI2C_CLK_PRED_OFFSET		(16)
-#define MXC_CCM_CSCDR3_HSI2C_CLK_PRED_MASK		(0x7 << 16)
-#define MXC_CCM_CSCDR3_HSI2C_CLK_PODF_OFFSET		(9)
-#define MXC_CCM_CSCDR3_HSI2C_CLK_PODF_MASK		(0x3F << 9)
 #define MXC_CCM_CSCDR3_FIRI_CLK_PRED_OFFSET		(6)
 #define MXC_CCM_CSCDR3_FIRI_CLK_PRED_MASK		(0x7 << 6)
 #define MXC_CCM_CSCDR3_FIRI_CLK_PODF_OFFSET		(0)
 #define MXC_CCM_CSCDR3_FIRI_CLK_PODF_MASK		(0x3F)
+#define MX51_CCM_CSCDR3_HSI2C_CLK_PRED_OFFSET		(16)
+#define MX51_CCM_CSCDR3_HSI2C_CLK_PRED_MASK		(0x7 << 16)
+#define MX51_CCM_CSCDR3_HSI2C_CLK_PODF_OFFSET		(9)
+#define MX51_CCM_CSCDR3_HSI2C_CLK_PODF_MASK		(0x3F << 9)
 
 /* Define the bits in register CSCDR4 */
 #define MXC_CCM_CSCDR4_CSI_MCLK2_CLK_PRED_OFFSET	(16)
@@ -365,8 +488,6 @@
 
 /* Define the bits in register CDHIPR */
 #define MXC_CCM_CDHIPR_ARM_PODF_BUSY			(1 << 16)
-#define MXC_CCM_CDHIPR_DDR_HF_CLK_SEL_BUSY		(1 << 8)
-#define MXC_CCM_CDHIPR_DDR_PODF_BUSY			(1 << 7)
 #define MXC_CCM_CDHIPR_EMI_CLK_SEL_BUSY			(1 << 6)
 #define MXC_CCM_CDHIPR_PERIPH_CLK_SEL_BUSY		(1 << 5)
 #define MXC_CCM_CDHIPR_NFC_IPG_INT_MEM_PODF_BUSY	(1 << 4)
@@ -374,6 +495,8 @@
 #define MXC_CCM_CDHIPR_EMI_PODF_BUSY			(1 << 2)
 #define MXC_CCM_CDHIPR_AXI_B_PODF_BUSY			(1 << 1)
 #define MXC_CCM_CDHIPR_AXI_A_PODF_BUSY			(1 << 0)
+#define MX51_CCM_CDHIPR_DDR_HF_CLK_SEL_BUSY		(1 << 8)
+#define MX51_CCM_CDHIPR_DDR_PODF_BUSY			(1 << 7)
 
 /* Define the bits in register CDCR */
 #define MXC_CCM_CDCR_ARM_FREQ_SHIFT_DIVIDER		(0x1 << 2)
@@ -381,11 +504,6 @@
 #define MXC_CCM_CDCR_PERIPH_CLK_DVFS_PODF_MASK		(0x3)
 
 /* Define the bits in register CLPCR */
-#define MXC_CCM_CLPCR_BYPASS_HSC_LPM_HS		(0x1 << 23)
-#define MXC_CCM_CLPCR_BYPASS_SCC_LPM_HS		(0x1 << 22)
-#define MX51_CCM_CLPCR_BYPASS_MAX_LPM_HS		(0x1 << 21)
-#define MX53_CCM_CLPCR_BYPASS_MAX_LPM_HS		(0x1 << 25)
-#define MXC_CCM_CLPCR_BYPASS_SDMA_LPM_HS	(0x1 << 20)
 #define MXC_CCM_CLPCR_BYPASS_EMI_LPM_HS		(0x1 << 19)
 #define MXC_CCM_CLPCR_BYPASS_IPU_LPM_HS		(0x1 << 18)
 #define MXC_CCM_CLPCR_BYPASS_RTIC_LPM_HS	(0x1 << 17)
@@ -401,9 +519,21 @@
 #define MXC_CCM_CLPCR_LPSR_CLK_SEL_MASK		(0x3 << 3)
 #define MXC_CCM_CLPCR_LPM_OFFSET		(0)
 #define MXC_CCM_CLPCR_LPM_MASK			(0x3)
+#define MX51_CCM_CLPCR_BYPASS_HSC_LPM_HS		(0x1 << 23)
+#define MX51_CCM_CLPCR_BYPASS_SCC_LPM_HS		(0x1 << 22)
+#define MX51_CCM_CLPCR_BYPASS_MAX_LPM_HS		(0x1 << 21)
+#define MX51_CCM_CLPCR_BYPASS_SDMA_LPM_HS		(0x1 << 20)
+#define MX53_CCM_CLPCR_BYPASS_CAN2_LPM_HS	(0x1 << 28)
+#define MX53_CCM_CLPCR_BYPASS_CAN1_LPM_HS	(0x1 << 27)
+#define MX53_CCM_CLPCR_BYPASS_SCC_LPM_HS	(0x1 << 26)
+#define MX53_CCM_CLPCR_BYPASS_MAX_LPM_HS	(0x1 << 25)
+#define MX53_CCM_CLPCR_BYPASS_SDMA_LPM_HS	(0x1 << 24)
+#define MX53_CCM_CLPCR_BYPASS_EMI_INT2_LPM_HS	(0x1 << 23)
+#define MX53_CCM_CLPCR_BYPASS_EMI_INT1_LPM_HS	(0x1 << 22)
+#define MX53_CCM_CLPCR_BYPASS_EMI_SLOW_LPM_HS	(0x1 << 21)
+#define MX53_CCM_CLPCR_BYPASS_EMI_FAST_LPM_HS	(0x1 << 20)
 
 /* Define the bits in register CISR */
-#define MXC_CCM_CISR_ARM_PODF_LOADED			(0x1 << 25)
 #define MXC_CCM_CISR_NFC_IPG_INT_MEM_PODF_LOADED	(0x1 << 21)
 #define MXC_CCM_CISR_AHB_PODF_LOADED			(0x1 << 20)
 #define MXC_CCM_CISR_EMI_PODF_LOADED			(0x1 << 19)
@@ -417,21 +547,35 @@
 #define MXC_CCM_CISR_LRF_PLL3				(0x1 << 2)
 #define MXC_CCM_CISR_LRF_PLL2				(0x1 << 1)
 #define MXC_CCM_CISR_LRF_PLL1				(0x1)
+#define MX51_CCM_CISR_ARM_PODF_LOADED		(0x1 << 25)
+#define MX53_CCM_CISR_ARM_PODF_LOADED		(0x1 << 26)
+#define MX53_CCM_CISR_TEMP_MON_ALARM		(0x1 << 25)
+#define MX53_CCM_CISR_EMI_CLK_SEL_LOADED	(0x1 << 23)
+#define MX53_CCM_CISR_PER_CLK_SEL_LOADED	(0x1 << 22)
 
 /* Define the bits in register CIMR */
-#define MXC_CCM_CIMR_MASK_ARM_PODF_LOADED		(0x1 << 25)
 #define MXC_CCM_CIMR_MASK_NFC_IPG_INT_MEM_PODF_LOADED	(0x1 << 21)
-#define MXC_CCM_CIMR_MASK_EMI_PODF_LOADED		(0x1 << 20)
-#define MXC_CCM_CIMR_MASK_AXI_C_PODF_LOADED		(0x1 << 19)
 #define MXC_CCM_CIMR_MASK_AXI_B_PODF_LOADED		(0x1 << 18)
 #define MXC_CCM_CIMR_MASK_AXI_A_PODF_LOADED		(0x1 << 17)
 #define MXC_CCM_CIMR_MASK_DIVIDER_LOADED		(0x1 << 16)
-#define MXC_CCM_CIMR_MASK_COSC_READY			(0x1 << 5)
-#define MXC_CCM_CIMR_MASK_CKIH_READY			(0x1 << 4)
-#define MXC_CCM_CIMR_MASK_FPM_READY			(0x1 << 3)
 #define MXC_CCM_CIMR_MASK_LRF_PLL3			(0x1 << 2)
 #define MXC_CCM_CIMR_MASK_LRF_PLL2			(0x1 << 1)
 #define MXC_CCM_CIMR_MASK_LRF_PLL1			(0x1)
+#define MX51_CCM_CIMR_MASK_ARM_PODF_LOADED		(0x1 << 25)
+#define MX51_CCM_CIMR_MASK_EMI_PODF_LOADED		(0x1 << 20)
+#define MX51_CCM_CIMR_MASK_AXI_C_PODF_LOADED		(0x1 << 19)
+#define MX51_CCM_CIMR_MASK_COSC_READY		(0x1 << 5)
+#define MX51_CCM_CIMR_MASK_CKIH_READY		(0x1 << 4)
+#define MX51_CCM_CIMR_MASK_FPM_READY		(0x1 << 3)
+#define MX53_CCM_CIMR_MASK_ARM_PODF_LOADED	(0x1 << 26)
+#define MX53_CCM_CIMR_MASK_TEMP_MON_ALARM		(0x1 << 25)
+#define MX53_CCM_CIMR_MASK_EMI_CLK_SEL_LOADED	(0x1 << 23)
+#define MX53_CCM_CIMR_MASK_PER_CLK_SEL_LOADED	(0x1 << 22)
+#define MX53_CCM_CIMR_MASK_AHB_PODF_LOADED	(0x1 << 20)
+#define MX53_CCM_CIMR_MASK_EMI_SLOW_PODF_LOADED	(0x1 << 19)
+#define MX53_CCM_CIMR_MASK_CAMP2_READY		(0x1 << 5)
+#define MX53_CCM_CIMR_MASK_CAMP1_READY		(0x1 << 4)
+#define MX53_CCM_CIMR_MASK_LRF_PLL4			(0x1 << 3)
 
 /* Define the bits in register CCOSR */
 #define MXC_CCM_CCOSR_CKO2_EN_OFFSET			(0x1 << 24)
@@ -450,6 +594,8 @@
 #define MXC_CCM_CGPR_FPM_SEL				(0x1 << 3)
 #define MXC_CCM_CGPR_VL_L2BIST_CLKDIV_OFFSET		(0)
 #define MXC_CCM_CGPR_VL_L2BIST_CLKDIV_MASK		(0x7)
+#define MX53_CCM_CGPR_ARM_CLK_INPUT_SEL		(0x1 << 24)
+#define MX53_CCM_CGPR_ARM_ASYNC_REF_EN		(0x1 << 23)
 
 /* Define the bits in registers CCGRx */
 #define MXC_CCM_CCGRx_CG_MASK				0x3
@@ -465,6 +611,8 @@
 #define MXC_CCM_CCGRx_CG10_MASK				(0x3 << 20)
 #define MXC_CCM_CCGRx_CG9_MASK				(0x3 << 18)
 #define MXC_CCM_CCGRx_CG8_MASK				(0x3 << 16)
+#define MXC_CCM_CCGRx_CG7_MASK				(0x3 << 14)
+#define MXC_CCM_CCGRx_CG6_MASK				(0x3 << 12)
 #define MXC_CCM_CCGRx_CG5_MASK				(0x3 << 10)
 #define MXC_CCM_CCGRx_CG4_MASK				(0x3 << 8)
 #define MXC_CCM_CCGRx_CG3_MASK				(0x3 << 6)
-- 
1.6.0.4


