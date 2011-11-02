Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab1KBSjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:39:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18118 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933505Ab1KBShJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706999"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 22/34] msm: clock-8x60: Support measurement of CPU and L2 clocks
Date: Wed,  2 Nov 2011 11:36:19 -0700
Message-Id: <1320258991-22325-23-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

Users of these debug facilities should keep in mind that these
clocks can gate automatically when the CPU or L2 is idle,
resulting in a lower-than-expected or 0 Hz measurement in those
cases.

Also, because the test points used to measure these clocks are
after a hard-wired divide-by-two, the rates of these clocks
are multiplied again by two in software to get the actual CPU
and L2 rates. When observing these clocks on an oscilloscope,
however, the half-rate clocks are what is seen.

CRs-Fixed: 273908
Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-8x60.c  |   51 ++++++++++++++++++++++++++++++--------
 arch/arm/mach-msm/clock-local.c |    4 +++
 arch/arm/mach-msm/clock-local.h |   29 ++++++++++++++++++++++
 3 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 7dac975..71e014d 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -219,6 +219,7 @@
 #define TEST_TYPE_MM_LS		3
 #define TEST_TYPE_MM_HS		4
 #define TEST_TYPE_LPA		5
+#define TEST_TYPE_SC		6
 #define TEST_TYPE_SHIFT		24
 #define TEST_CLK_SEL_MASK	BM(23, 0)
 #define TEST_VECTOR(s, t)	(((t) << TEST_TYPE_SHIFT) | BVAL(23, 0, (s)))
@@ -227,6 +228,7 @@
 #define TEST_MM_LS(s)		TEST_VECTOR((s), TEST_TYPE_MM_LS)
 #define TEST_MM_HS(s)		TEST_VECTOR((s), TEST_TYPE_MM_HS)
 #define TEST_LPA(s)		TEST_VECTOR((s), TEST_TYPE_LPA)
+#define TEST_SC(s)		TEST_VECTOR((s), TEST_TYPE_SC)
 
 struct pll_rate {
 	const uint32_t	l_val;
@@ -3126,6 +3128,10 @@ static struct rcg_clk pcm_clk = {
 	},
 };
 
+static DEFINE_CLK_MEASURE(sc0_m_clk);
+static DEFINE_CLK_MEASURE(sc1_m_clk);
+static DEFINE_CLK_MEASURE(l2_m_clk);
+
 #ifdef CONFIG_DEBUG_FS
 struct measure_sel {
 	u32 test_vector;
@@ -3271,6 +3277,10 @@ static struct measure_sel measure_mux[] = {
 	{ TEST_LPA(0x12), &spare_i2s_spkr_osr_clk.c },
 	{ TEST_LPA(0x13), &spare_i2s_spkr_bit_clk.c },
 	{ TEST_LPA(0x14), &pcm_clk.c },
+
+	{ TEST_SC(0x40), &sc0_m_clk },
+	{ TEST_SC(0x41), &sc1_m_clk },
+	{ TEST_SC(0x42), &l2_m_clk },
 };
 
 static struct measure_sel *find_measure_sel(struct clk *clk)
@@ -3283,11 +3293,12 @@ static struct measure_sel *find_measure_sel(struct clk *clk)
 	return NULL;
 }
 
-static int measure_clk_set_parent(struct clk *clk, struct clk *parent)
+static int measure_clk_set_parent(struct clk *c, struct clk *parent)
 {
 	int ret = 0;
 	u32 clk_sel;
 	struct measure_sel *p;
+	struct measure_clk *clk = to_measure_clk(c);
 	unsigned long flags;
 
 	if (!parent)
@@ -3299,8 +3310,13 @@ static int measure_clk_set_parent(struct clk *clk, struct clk *parent)
 
 	spin_lock_irqsave(&local_clock_reg_lock, flags);
 
-	/* Program the test vector. */
+	/*
+	 * Program the test vector, measurement period (sample_ticks)
+	 * and scaling factor (multiplier).
+	 */
 	clk_sel = p->test_vector & TEST_CLK_SEL_MASK;
+	clk->sample_ticks = 0x10000;
+	clk->multiplier = 1;
 	switch (p->test_vector >> TEST_TYPE_SHIFT) {
 	case TEST_TYPE_PER_LS:
 		writel_relaxed(0x4030D00|BVAL(7, 0, clk_sel), CLK_TEST_REG);
@@ -3321,6 +3337,11 @@ static int measure_clk_set_parent(struct clk *clk, struct clk *parent)
 		writel_relaxed(BVAL(6, 1, clk_sel)|BIT(0),
 				LCC_CLK_LS_DEBUG_CFG_REG);
 		break;
+	case TEST_TYPE_SC:
+		writel_relaxed(0x5020000|BVAL(16, 10, clk_sel), CLK_TEST_REG);
+		clk->sample_ticks = 0x4000;
+		clk->multiplier = 2;
+		break;
 	default:
 		ret = -EPERM;
 	}
@@ -3357,11 +3378,12 @@ static u32 run_measurement(unsigned ticks)
 
 /* Perform a hardware rate measurement for a given clock.
    FOR DEBUG USE ONLY: Measurements take ~15 ms! */
-static unsigned measure_clk_get_rate(struct clk *clk)
+static unsigned measure_clk_get_rate(struct clk *c)
 {
 	unsigned long flags;
 	u32 pdm_reg_backup, ringosc_reg_backup;
 	u64 raw_count_short, raw_count_full;
+	struct measure_clk *clk = to_measure_clk(c);
 	unsigned ret;
 
 	spin_lock_irqsave(&local_clock_reg_lock, flags);
@@ -3382,7 +3404,7 @@ static unsigned measure_clk_get_rate(struct clk *clk)
 	/* Run a short measurement. (~1 ms) */
 	raw_count_short = run_measurement(0x1000);
 	/* Run a full measurement. (~14 ms) */
-	raw_count_full = run_measurement(0x10000);
+	raw_count_full = run_measurement(clk->sample_ticks);
 
 	writel_relaxed(ringosc_reg_backup, RINGOSC_NS_REG);
 	writel_relaxed(pdm_reg_backup, PDM_CLK_NS_REG);
@@ -3393,8 +3415,8 @@ static unsigned measure_clk_get_rate(struct clk *clk)
 	else {
 		/* Compute rate in Hz. */
 		raw_count_full = ((raw_count_full * 10) + 15) * 4800000;
-		do_div(raw_count_full, ((0x10000 * 10) + 35));
-		ret = raw_count_full;
+		do_div(raw_count_full, ((clk->sample_ticks * 10) + 35));
+		ret = (raw_count_full * clk->multiplier);
 	}
 
 	/* Route dbg_hs_clk to PLLTEST.  300mV single-ended amplitude. */
@@ -3421,17 +3443,20 @@ static struct clk_ops measure_clk_ops = {
 	.is_local = local_clk_is_local,
 };
 
-static struct clk measure_clk = {
-	.dbg_name = "measure_clk",
-	.ops = &measure_clk_ops,
-	CLK_INIT(measure_clk),
+static struct measure_clk measure_clk = {
+	.c = {
+		.dbg_name = "measure_clk",
+		.ops = &measure_clk_ops,
+		CLK_INIT(measure_clk.c),
+	},
+	.multiplier = 1,
 };
 
 struct clk_lookup msm_clocks_8x60[] = {
 	CLK_LOOKUP("cxo",		cxo_clk.c,	NULL),
 	CLK_LOOKUP("pll4",		pll4_clk.c,	NULL),
 	CLK_LOOKUP("pll4",		pll4_clk.c,	"peripheral-reset"),
-	CLK_LOOKUP("measure",		measure_clk,	"debug"),
+	CLK_LOOKUP("measure",		measure_clk.c,	"debug"),
 
 	CLK_LOOKUP("gsbi_uart_clk",	gsbi1_uart_clk.c,		NULL),
 	CLK_LOOKUP("gsbi_uart_clk",	gsbi2_uart_clk.c,		NULL),
@@ -3592,6 +3617,10 @@ struct clk_lookup msm_clocks_8x60[] = {
 	CLK_LOOKUP("iommu_clk",		gfx3d_clk.c, "msm_iommu.9"),
 	CLK_LOOKUP("iommu_clk",		gfx2d0_clk.c, "msm_iommu.10"),
 	CLK_LOOKUP("iommu_clk",		gfx2d1_clk.c, "msm_iommu.11"),
+
+	CLK_LOOKUP("sc0_mclk",		sc0_m_clk, NULL),
+	CLK_LOOKUP("sc1_mclk",		sc1_m_clk, NULL),
+	CLK_LOOKUP("l2_mclk",		l2_m_clk,  NULL),
 };
 unsigned msm_num_clocks_8x60 = ARRAY_SIZE(msm_clocks_8x60);
 
diff --git a/arch/arm/mach-msm/clock-local.c b/arch/arm/mach-msm/clock-local.c
index c79895c..e2dab7a 100644
--- a/arch/arm/mach-msm/clock-local.c
+++ b/arch/arm/mach-msm/clock-local.c
@@ -861,6 +861,10 @@ struct fixed_clk gnd_clk = {
 	},
 };
 
+struct clk_ops clk_ops_measure = {
+	.is_local = local_clk_is_local,
+};
+
 int branch_clk_enable(struct clk *clk)
 {
 	int rc;
diff --git a/arch/arm/mach-msm/clock-local.h b/arch/arm/mach-msm/clock-local.h
index e004490..6d48e61 100644
--- a/arch/arm/mach-msm/clock-local.h
+++ b/arch/arm/mach-msm/clock-local.h
@@ -33,6 +33,16 @@
 #define DELAY		5	/* No bit to check, just delay */
 
 /*
+ * Clock Definition Macros
+ */
+#define DEFINE_CLK_MEASURE(name) \
+	struct clk name = { \
+		.ops = &clk_ops_measure, \
+		.dbg_name = #name, \
+		CLK_INIT(name), \
+	}; \
+
+/*
  * Generic frequency-definition structs and macros
  */
 struct clk_freq_tbl {
@@ -255,6 +265,25 @@ unsigned branch_clk_is_enabled(struct clk *clk);
 void branch_clk_auto_off(struct clk *clk);
 int branch_clk_reset(struct clk *c, enum clk_reset_action action);
 
+/**
+ * struct measure_clk - for rate measurement debug use
+ * @sample_ticks: sample period in reference clock ticks
+ * @multiplier: measurement scale-up factor
+ * @c: clk
+*/
+struct measure_clk {
+	u64 sample_ticks;
+	u32 multiplier;
+	struct clk c;
+};
+
+extern struct clk_ops clk_ops_measure;
+
+static inline struct measure_clk *to_measure_clk(struct clk *clk)
+{
+	return container_of(clk, struct measure_clk, c);
+}
+
 /*
  * Variables from clock-local driver
  */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

