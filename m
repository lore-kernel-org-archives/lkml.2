Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0LQAxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:53:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12572 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab0LQAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="66953209"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 11/22] msm: clock Add debugfs interface to measure clock rates
Date: Thu, 16 Dec 2010 16:49:55 -0800
Message-Id: <1292547006-19741-12-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

Use the SoC's ring oscillator hardware to measure the clock rate
of locally-controlled clocks. This allows for the development of
more comprehensive end-to-end clock tests.

A 'measure' debugfs node is created for each clock to perform the
measurement and retrieve the result. soc_clk_measure_rate() should
*only* be used for debug purposes since it busy-loops while the
measurement takes place (~15 ms).

Clock rates are in units of Hz. Clocks that are not locally
controlled or do not support rate measurement will return -1.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.c  |   90 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-8x60.c  |  101 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-debug.c |   15 ++++++
 arch/arm/mach-msm/clock-pcom.c  |    7 +++
 arch/arm/mach-msm/clock.h       |    1 +
 5 files changed, 214 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index 994104f..e13de24 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -89,6 +89,10 @@
 #define VPE_NS_REG		REG(0x015C)
 
 /* Registers in the base (non-shadow) region. */
+#define CLK_TEST_BASE_REG	REG_BASE(0x011C)
+#define CLK_TEST_2_BASE_REG	REG_BASE(0x0384)
+#define MISC_CLK_CTL_BASE_REG	REG_BASE(0x0110)
+#define PRPH_WEB_NS_BASE_REG	REG_BASE(0x0080)
 #define PLL0_STATUS_BASE_REG	REG_BASE(0x0318)
 #define PLL1_STATUS_BASE_REG	REG_BASE(0x0334)
 #define PLL2_STATUS_BASE_REG	REG_BASE(0x0350)
@@ -96,12 +100,15 @@
 #define PLL4_STATUS_BASE_REG	REG_BASE(0x0254)
 #define PLL5_STATUS_BASE_REG	REG_BASE(0x0258)
 #define PLL6_STATUS_BASE_REG	REG_BASE(0x04EC)
+#define RINGOSC_CNT_BASE_REG	REG_BASE(0x00FC)
 #define SH2_OWN_APPS1_BASE_REG	REG_BASE(0x040C)
 #define SH2_OWN_APPS2_BASE_REG	REG_BASE(0x0414)
 #define SH2_OWN_APPS3_BASE_REG	REG_BASE(0x0444)
 #define SH2_OWN_GLBL_BASE_REG	REG_BASE(0x0404)
 #define SH2_OWN_ROW1_BASE_REG	REG_BASE(0x041C)
 #define SH2_OWN_ROW2_BASE_REG	REG_BASE(0x0424)
+#define TCXO_CNT_BASE_REG	REG_BASE(0x00F8)
+#define TCXO_CNT_DONE_BASE_REG	REG_BASE(0x00F8)
 
 
 /* MUX source input identifiers. */
@@ -687,6 +694,88 @@ int soc_set_pwr_rail(unsigned id, int enable)
 	return 0;
 }
 
+/* Sample clock for 'tcxo4_ticks' reference clock ticks. */
+static uint32_t run_measurement(unsigned tcxo4_ticks)
+{
+	/* TCXO4_CNT_EN and RINGOSC_CNT_EN register values. */
+	uint32_t reg_val_enable = readl(MISC_CLK_CTL_BASE_REG) | 0x3;
+	uint32_t reg_val_disable = reg_val_enable & ~0x3;
+
+	/* Stop counters and set the TCXO4 counter start value. */
+	writel(reg_val_disable, MISC_CLK_CTL_BASE_REG);
+	writel(tcxo4_ticks, TCXO_CNT_BASE_REG);
+
+	/* Run measurement and wait for completion. */
+	writel(reg_val_enable, MISC_CLK_CTL_BASE_REG);
+	while (readl(TCXO_CNT_DONE_BASE_REG) == 0)
+		cpu_relax();
+
+	/* Stop counters. */
+	writel(reg_val_disable, MISC_CLK_CTL_BASE_REG);
+
+	return readl(RINGOSC_CNT_BASE_REG);
+}
+
+/* Perform a hardware rate measurement for a given clock.
+   FOR DEBUG USE ONLY: Measurements take ~15 ms! */
+signed soc_clk_measure_rate(unsigned id)
+{
+	struct clk_local *t = &soc_clk_local_tbl[id];
+	unsigned long flags;
+	uint32_t regval, prph_web_reg_old;
+	uint64_t raw_count_short, raw_count_full;
+	signed ret;
+
+	if (t->test_vector == 0)
+		return -EPERM;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+
+	/* Program test vector. */
+	if (t->test_vector <= 0xFF) {
+		/* Select CLK_TEST_2 */
+		writel(0x4D40, CLK_TEST_BASE_REG);
+		writel(t->test_vector, CLK_TEST_2_BASE_REG);
+	} else
+		writel(t->test_vector, CLK_TEST_BASE_REG);
+
+	/* Enable TCXO4 clock branch and root. */
+	prph_web_reg_old = readl(PRPH_WEB_NS_BASE_REG);
+	regval = prph_web_reg_old | B(9) | B(11);
+	local_src_enable(TCXO);
+	writel(regval, PRPH_WEB_NS_BASE_REG);
+
+	/*
+	 * The ring oscillator counter will not reset if the measured clock
+	 * is not running.  To detect this, run a short measurement before
+	 * the full measurement.  If the raw results of the two are the same
+	 * then the clock must be off.
+	 */
+
+	/* Run a short measurement. (~1 ms) */
+	raw_count_short = run_measurement(0x1000);
+	/* Run a full measurement. (~14 ms) */
+	raw_count_full = run_measurement(0x10000);
+
+	/* Disable TCXO4 clock branch and root. */
+	writel(prph_web_reg_old, PRPH_WEB_NS_BASE_REG);
+	local_src_disable(TCXO);
+
+	/* Return 0 if the clock is off. */
+	if (raw_count_full == raw_count_short)
+		ret = 0;
+	else {
+		/* Compute rate in Hz. */
+		raw_count_full = ((raw_count_full * 10) + 15) * 4800000;
+		do_div(raw_count_full, ((0x10000 * 10) + 35));
+		ret = (signed)raw_count_full;
+	}
+
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+
+	return ret;
+}
+
 /* Implementation for clk_set_flags(). */
 int soc_clk_set_flags(unsigned id, unsigned clk_flags)
 {
@@ -1072,4 +1161,5 @@ struct clk_ops soc_clk_ops_7x30 = {
 	.reset = pc_clk_reset,
 	.set_flags = soc_clk_set_flags,
 	.is_local = local_clk_is_local,
+	.measure_rate = soc_clk_measure_rate,
 };
diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index e1f3c6f..6972001 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -1621,6 +1621,106 @@ int soc_set_pwr_rail(unsigned id, int enable)
 	return 0;
 }
 
+/* Sample clock for 'ticks' reference clock ticks. */
+static uint32_t run_measurement(unsigned ticks)
+{
+	/* Stop counters and set the XO4 counter start value. */
+	writel(0x0, RINGOSC_TCXO_CTL_REG);
+	writel(ticks, RINGOSC_TCXO_CTL_REG);
+
+	/* Wait for timer to become ready. */
+	while ((readl(RINGOSC_STATUS_REG) & B(25)) != 0)
+		cpu_relax();
+
+	/* Run measurement and wait for completion. */
+	writel(B(20)|ticks, RINGOSC_TCXO_CTL_REG);
+	while ((readl(RINGOSC_STATUS_REG) & B(25)) == 0)
+		cpu_relax();
+
+	/* Stop counters. */
+	writel(0x0, RINGOSC_TCXO_CTL_REG);
+
+	/* Return measured ticks. */
+	return readl(RINGOSC_STATUS_REG) & BM(24, 0);
+}
+
+/* Perform a hardware rate measurement for a given clock.
+   FOR DEBUG USE ONLY: Measurements take ~15 ms! */
+int soc_clk_measure_rate(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	unsigned long flags;
+	uint32_t clk_sel, pdm_reg_backup, ringosc_reg_backup;
+	uint64_t raw_count_short, raw_count_full;
+	int ret;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+
+	/* Program the test vector. */
+	clk_sel = clk->test_vector & TEST_CLK_SEL_MASK;
+	switch (clk->test_vector >> TEST_TYPE_SHIFT) {
+	case TEST_TYPE_PER_LS:
+		writel(0x4030D00|BVAL(7, 0, clk_sel), CLK_TEST_REG);
+		break;
+	case TEST_TYPE_PER_HS:
+		writel(0x4020000|BVAL(16, 10, clk_sel), CLK_TEST_REG);
+		break;
+	case TEST_TYPE_MM_LS:
+		writel(0x4030D97, CLK_TEST_REG);
+		writel(BVAL(6, 1, clk_sel)|B(0), DBG_CFG_REG_LS_REG);
+		break;
+	case TEST_TYPE_MM_HS:
+		writel(0x402B800, CLK_TEST_REG);
+		writel(BVAL(6, 1, clk_sel)|B(0), DBG_CFG_REG_HS_REG);
+		break;
+	case TEST_TYPE_LPA:
+		writel(0x4030D98, CLK_TEST_REG);
+		writel(BVAL(6, 1, clk_sel)|B(0), LCC_CLK_LS_DEBUG_CFG_REG);
+		break;
+	default:
+		ret = -EPERM;
+		goto err;
+	}
+
+	/* Enable CXO/4 and RINGOSC branch and root. */
+	pdm_reg_backup = readl(PDM_CLK_NS_REG);
+	ringosc_reg_backup = readl(RINGOSC_NS_REG);
+	writel(0x2898, PDM_CLK_NS_REG);
+	writel(0xA00, RINGOSC_NS_REG);
+
+	/*
+	 * The ring oscillator counter will not reset if the measured clock
+	 * is not running.  To detect this, run a short measurement before
+	 * the full measurement.  If the raw results of the two are the same
+	 * then the clock must be off.
+	 */
+
+	/* Run a short measurement. (~1 ms) */
+	raw_count_short = run_measurement(0x1000);
+	/* Run a full measurement. (~14 ms) */
+	raw_count_full = run_measurement(0x10000);
+
+	writel(ringosc_reg_backup, RINGOSC_NS_REG);
+	writel(pdm_reg_backup, PDM_CLK_NS_REG);
+
+	/* Return 0 if the clock is off. */
+	if (raw_count_full == raw_count_short)
+		ret = 0;
+	else {
+		/* Compute rate in Hz. */
+		raw_count_full = ((raw_count_full * 10) + 15) * 4800000;
+		do_div(raw_count_full, ((0x10000 * 10) + 35));
+		ret = (int)raw_count_full;
+	}
+
+	/* Route dbg_hs_clk to PLLTEST.  300mV single-ended amplitude. */
+	writel(0x3CF8, PLLTEST_PAD_CFG_REG);
+err:
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+
+	return ret;
+}
+
 /* Implementation for clk_set_flags(). */
 int soc_clk_set_flags(unsigned id, unsigned flags)
 {
@@ -1800,4 +1900,5 @@ struct clk_ops soc_clk_ops_8x60 = {
 	.reset = soc_clk_reset,
 	.set_flags = soc_clk_set_flags,
 	.is_local = local_clk_is_local,
+	.measure_rate = soc_clk_measure_rate,
 };
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index 4886404..73ef9cc 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -49,6 +49,16 @@ static int clock_debug_rate_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(clock_rate_fops, clock_debug_rate_get,
 			clock_debug_rate_set, "%llu\n");
 
+static int clock_debug_measure_get(void *data, u64 *val)
+{
+	struct clk *clock = data;
+	*val = clock->ops->measure_rate(clock->id);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(clock_measure_fops, clock_debug_measure_get,
+			NULL, "%lld\n");
+
 static int clock_debug_enable_set(void *data, u64 val)
 {
 	struct clk *clock = data;
@@ -123,6 +133,11 @@ int __init clock_debug_add(struct clk *clock)
 	if (!debugfs_create_file("is_local", S_IRUGO, clk_dir, clock,
 				&clock_local_fops))
 		goto error;
+
+	if (!debugfs_create_file("measure", S_IRUGO, clk_dir,
+				clock, &clock_measure_fops))
+		goto error;
+
 	return 0;
 error:
 	debugfs_remove_recursive(clk_dir);
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index 63b7113..2f9d0d4 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -102,6 +102,12 @@ unsigned pc_clk_get_rate(unsigned id)
 		return id;
 }
 
+int pc_clk_measure_rate(unsigned id)
+{
+	/* Not supported. */
+	return -EPERM;
+}
+
 unsigned pc_clk_is_enabled(unsigned id)
 {
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_ENABLED, &id, NULL))
@@ -132,6 +138,7 @@ struct clk_ops clk_ops_pcom = {
 	.set_max_rate = pc_clk_set_max_rate,
 	.set_flags = pc_clk_set_flags,
 	.get_rate = pc_clk_get_rate,
+	.measure_rate = pc_clk_measure_rate,
 	.is_enabled = pc_clk_is_enabled,
 	.round_rate = pc_clk_round_rate,
 	.is_local = pc_clk_is_local,
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index b74ba3e..f09e01b 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -41,6 +41,7 @@ struct clk_ops {
 	int (*set_max_rate)(unsigned id, unsigned rate);
 	int (*set_flags)(unsigned id, unsigned flags);
 	unsigned (*get_rate)(unsigned id);
+	int (*measure_rate)(unsigned id);
 	unsigned (*is_enabled)(unsigned id);
 	long (*round_rate)(unsigned id, unsigned rate);
 	bool (*is_local)(unsigned id);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

