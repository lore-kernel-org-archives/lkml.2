Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2AMPWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:22:14 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:52969 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758299Ab2AMPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:15 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/8] mfd/db8500-prcmu: remove U8400 legacy
Date: Fri, 13 Jan 2012 16:20:03 +0100
Message-ID: <1326468003-11683-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Willerud <daniel.willerud@stericsson.com>

This removes the U8400 legacy from PRCMU and cpufreq drivers.
This platform has no current in-kernel users.

Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/cpufreq/db8500-cpufreq.c |   13 +++++--------
 drivers/mfd/db8500-prcmu.c       |   26 ++------------------------
 include/linux/mfd/db8500-prcmu.h |    6 ------
 3 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index f500201..a22ffa5 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -22,11 +22,11 @@ static struct cpufreq_frequency_table freq_table[] = {
 	},
 	[1] = {
 		.index = 1,
-		.frequency = 300000,
+		.frequency = 400000,
 	},
 	[2] = {
 		.index = 2,
-		.frequency = 600000,
+		.frequency = 800000,
 	},
 	[3] = {
 		/* Used for MAX_OPP, if available */
@@ -113,12 +113,9 @@ static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 
 	BUILD_BUG_ON(ARRAY_SIZE(idx2opp) + 1 != ARRAY_SIZE(freq_table));
 
-	if (!prcmu_is_u8400()) {
-		freq_table[1].frequency = 400000;
-		freq_table[2].frequency = 800000;
-		if (prcmu_has_arm_maxopp())
-			freq_table[3].frequency = 1000000;
-	}
+	if (prcmu_has_arm_maxopp())
+		freq_table[3].frequency = 1000000;
+
 	pr_info("db8500-cpufreq : Available frequencies:\n");
 	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
 		pr_info("  %d Mhz\n", freq_table[i].frequency/1000);
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index af8e0ef..b911963 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -503,9 +503,6 @@ static const char *hwacc_ret_regulator_name[NUM_HW_ACC] = {
 /* PLLDIV=12, PLLSW=4 (PLLDDR) */
 #define PRCMU_DSI_CLOCK_SETTING		0x0000008C
 
-/* PLLDIV=8, PLLSW=4 (PLLDDR) */
-#define PRCMU_DSI_CLOCK_SETTING_U8400	0x00000088
-
 /* DPI 50000000 Hz */
 #define PRCMU_DPI_CLOCK_SETTING		((1 << PRCMU_CLK_PLL_SW_SHIFT) | \
 					  (16 << PRCMU_CLK_PLL_DIV_SHIFT))
@@ -514,9 +511,6 @@ static const char *hwacc_ret_regulator_name[NUM_HW_ACC] = {
 /* D=101, N=1, R=4, SELDIV2=0 */
 #define PRCMU_PLLDSI_FREQ_SETTING	0x00040165
 
-/* D=70, N=1, R=3, SELDIV2=0 */
-#define PRCMU_PLLDSI_FREQ_SETTING_U8400	0x00030146
-
 #define PRCMU_ENABLE_PLLDSI		0x00000001
 #define PRCMU_DISABLE_PLLDSI		0x00000000
 #define PRCMU_RELEASE_RESET_DSS		0x0000400C
@@ -539,19 +533,14 @@ static struct {
 int db8500_prcmu_enable_dsipll(void)
 {
 	int i;
-	unsigned int plldsifreq;
 
 	/* Clear DSIPLL_RESETN */
 	writel(PRCMU_RESET_DSIPLL, PRCM_APE_RESETN_CLR);
 	/* Unclamp DSIPLL in/out */
 	writel(PRCMU_UNCLAMP_DSIPLL, PRCM_MMIP_LS_CLAMP_CLR);
 
-	if (prcmu_is_u8400())
-		plldsifreq = PRCMU_PLLDSI_FREQ_SETTING_U8400;
-	else
-		plldsifreq = PRCMU_PLLDSI_FREQ_SETTING;
 	/* Set DSI PLL FREQ */
-	writel(plldsifreq, PRCM_PLLDSI_FREQ);
+	writel(PRCMU_PLLDSI_FREQ_SETTING, PRCM_PLLDSI_FREQ);
 	writel(PRCMU_DSI_PLLOUT_SEL_SETTING, PRCM_DSI_PLLOUT_SEL);
 	/* Enable Escape clocks */
 	writel(PRCMU_ENABLE_ESCAPE_CLOCK_DIV, PRCM_DSITVCLK_DIV);
@@ -583,12 +572,6 @@ int db8500_prcmu_disable_dsipll(void)
 int db8500_prcmu_set_display_clocks(void)
 {
 	unsigned long flags;
-	unsigned int dsiclk;
-
-	if (prcmu_is_u8400())
-		dsiclk = PRCMU_DSI_CLOCK_SETTING_U8400;
-	else
-		dsiclk = PRCMU_DSI_CLOCK_SETTING;
 
 	spin_lock_irqsave(&clk_mgt_lock, flags);
 
@@ -596,7 +579,7 @@ int db8500_prcmu_set_display_clocks(void)
 	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
 		cpu_relax();
 
-	writel(dsiclk, PRCM_HDMICLK_MGT);
+	writel(PRCMU_DSI_CLOCK_SETTING, PRCM_HDMICLK_MGT);
 	writel(PRCMU_DSI_LP_CLOCK_SETTING, PRCM_TVCLK_MGT);
 	writel(PRCMU_DPI_CLOCK_SETTING, PRCM_LCDCLK_MGT);
 
@@ -642,11 +625,6 @@ bool prcmu_has_arm_maxopp(void)
 		PRCM_AVS_ISMODEENABLE_MASK) == PRCM_AVS_ISMODEENABLE_MASK;
 }
 
-bool prcmu_is_u8400(void)
-{
-	return prcmu_version.project_number == PRCMU_PROJECT_ID_8400V2_0;
-}
-
 /**
  * prcmu_get_boot_status - PRCMU boot status checking
  * Returns: the current PRCMU boot status
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index 60d27f7..0dc9017 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -500,7 +500,6 @@ int prcmu_set_rc_a2p(enum romcode_write);
 enum romcode_read prcmu_get_rc_p2a(void);
 enum ap_pwrst prcmu_get_xp70_current_state(void);
 bool prcmu_has_arm_maxopp(void);
-bool prcmu_is_u8400(void);
 int prcmu_set_ape_opp(u8 opp);
 int prcmu_get_ape_opp(void);
 int prcmu_request_ape_opp_100_voltage(bool enable);
@@ -574,11 +573,6 @@ static inline bool prcmu_has_arm_maxopp(void)
 	return false;
 }
 
-static inline bool prcmu_is_u8400(void)
-{
-	return false;
-}
-
 static inline int prcmu_set_ape_opp(u8 opp)
 {
 	return 0;
-- 
1.7.8

