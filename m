Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab1KBSjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:39:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18118 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab1KBShG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706997"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [RFC PATCH 21/34] msm: clock: Add debugfs interface to measure clock rates
Date: Wed,  2 Nov 2011 11:36:18 -0700
Message-Id: <1320258991-22325-22-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
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

Clock rates are in units of Hz. Clocks that don't support rate
measurement will return -1.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.c  |  239 ++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-8x60.c  |  333 ++++++++++++++++++++++++++++++++++++--
 arch/arm/mach-msm/clock-debug.c |   36 ++++-
 arch/arm/mach-msm/clock.h       |    2 +-
 4 files changed, 589 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index 5b796e8..f73e76f 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -2426,6 +2426,244 @@ out:
 	return rc;
 }
 
+#ifdef CONFIG_DEBUG_FS
+
+#define CLK_TEST_2(s) (s)
+#define CLK_TEST_HS(s) (0x4000 | ((s) << 8))
+#define CLK_TEST_LS(s) (0x4D40 | (s))
+
+struct measure_sel {
+	u32 test_vector;
+	struct clk *clk;
+};
+
+static struct measure_sel measure_mux[] = {
+	{ CLK_TEST_2(0x03), &emdh_p_clk.c },
+	{ CLK_TEST_2(0x04), &pmdh_p_clk.c },
+	{ CLK_TEST_2(0x06), &mdp_p_clk.c },
+	{ CLK_TEST_2(0x07), &lpa_p_clk.c },
+	{ CLK_TEST_2(0x08), &usb_hs2_p_clk.c },
+	{ CLK_TEST_2(0x09), &spi_clk.c },
+	{ CLK_TEST_2(0x0A), &midi_clk.c },
+	{ CLK_TEST_2(0x0B), &i2c_2_clk.c },
+	{ CLK_TEST_2(0x0D), &mi2s_m_clk.c },
+	{ CLK_TEST_2(0x0E), &lpa_core_clk.c },
+	{ CLK_TEST_2(0x0F), &lpa_codec_clk.c },
+	{ CLK_TEST_2(0x10), &usb_hs3_p_clk.c },
+	{ CLK_TEST_2(0x11), &adm_p_clk.c },
+	{ CLK_TEST_2(0x13), &hdmi_clk.c },
+	{ CLK_TEST_2(0x14), &usb_hs_core_clk.c },
+	{ CLK_TEST_2(0x15), &usb_hs2_core_clk.c },
+	{ CLK_TEST_2(0x16), &usb_hs3_core_clk.c },
+	{ CLK_TEST_2(0x17), &mi2s_codec_tx_s_clk.c },
+	{ CLK_TEST_2(0x18), &spi_p_clk.c },
+	{ CLK_TEST_2(0x1A), &camif_pad_p_clk.c },
+	{ CLK_TEST_2(0x1C), &qup_i2c_clk.c },
+	{ CLK_TEST_2(0x1F), &mfc_div2_clk.c },
+	{ CLK_TEST_2(0x38), &mfc_clk.c },
+
+	{ CLK_TEST_HS(0x00), &adm_clk.c },
+	{ CLK_TEST_HS(0x01), &mdp_lcdc_pad_pclk_clk.c },
+	{ CLK_TEST_HS(0x02), &mdp_lcdc_pclk_clk.c },
+	{ CLK_TEST_HS(0x03), &axi_rotator_clk.c },
+	{ CLK_TEST_HS(0x07), &axi_li_vg_clk.c },
+	{ CLK_TEST_HS(0x09), &axi_li_apps_clk.c },
+	{ CLK_TEST_HS(0x0E), &axi_li_jpeg_clk.c },
+	{ CLK_TEST_HS(0x0F), &emdh_clk.c },
+	{ CLK_TEST_HS(0x14), &mdp_clk.c },
+	{ CLK_TEST_HS(0x15), &pmdh_clk.c },
+	{ CLK_TEST_HS(0x19), &axi_grp_2d_clk.c },
+	{ CLK_TEST_HS(0x1A), &axi_li_grp_clk.c },
+	{ CLK_TEST_HS(0x1B), &axi_li_vfe_clk.c },
+	{ CLK_TEST_HS(0x1C), &grp_2d_clk.c },
+	{ CLK_TEST_HS(0x1E), &grp_3d_clk.c },
+	{ CLK_TEST_HS(0x1F), &imem_clk.c },
+	{ CLK_TEST_HS(0x20), &jpeg_clk.c },
+	{ CLK_TEST_HS(0x24), &axi_li_adsp_a_clk.c },
+	{ CLK_TEST_HS(0x26), &rotator_imem_clk.c },
+	{ CLK_TEST_HS(0x27), &axi_vpe_clk.c },
+	{ CLK_TEST_HS(0x2A), &axi_mfc_clk.c },
+	{ CLK_TEST_HS(0x2B), &axi_mdp_clk.c },
+	{ CLK_TEST_HS(0x2C), &vpe_clk.c },
+	{ CLK_TEST_HS(0x30), &vfe_camif_clk.c },
+	{ CLK_TEST_HS(0x31), &csi0_clk.c },
+	{ CLK_TEST_HS(0x32), &csi0_vfe_clk.c },
+	{ CLK_TEST_HS(0x33), &csi0_p_clk.c },
+
+	{ CLK_TEST_LS(0x03), &ce_clk.c },
+	{ CLK_TEST_LS(0x04), &cam_m_clk.c },
+	{ CLK_TEST_LS(0x0C), &grp_2d_p_clk.c },
+	{ CLK_TEST_LS(0x0D), &i2c_clk.c },
+	{ CLK_TEST_LS(0x0E), &mi2s_codec_rx_m_clk.c },
+	{ CLK_TEST_LS(0x0F), &mi2s_codec_rx_s_clk.c },
+	{ CLK_TEST_LS(0x10), &mi2s_codec_tx_m_clk.c },
+	{ CLK_TEST_LS(0x13), &mdp_vsync_clk.c },
+	{ CLK_TEST_LS(0x15), &vfe_p_clk.c },
+	{ CLK_TEST_LS(0x16), &mdc_clk.c },
+	{ CLK_TEST_LS(0x17), &vfe_mdc_clk.c },
+	{ CLK_TEST_LS(0x18), &usb_hs_p_clk.c },
+	{ CLK_TEST_LS(0x1C), &uart1dm_p_clk.c },
+	{ CLK_TEST_LS(0x1E), &jpeg_p_clk.c },
+	{ CLK_TEST_LS(0x20), &sdac_clk.c },
+	{ CLK_TEST_LS(0x21), &sdc1_p_clk.c },
+	{ CLK_TEST_LS(0x22), &sdc1_clk.c },
+	{ CLK_TEST_LS(0x23), &sdc2_p_clk.c },
+	{ CLK_TEST_LS(0x24), &sdc2_clk.c },
+	{ CLK_TEST_LS(0x25), &tsif_p_clk.c },
+	{ CLK_TEST_LS(0x26), &sdac_m_clk.c },
+	{ CLK_TEST_LS(0x27), &grp_3d_p_clk.c },
+	{ CLK_TEST_LS(0x2A), &tsif_ref_clk.c },
+	{ CLK_TEST_LS(0x2B), &tv_enc_clk.c },
+	{ CLK_TEST_LS(0x2C), &tv_dac_clk.c },
+	{ CLK_TEST_LS(0x2D), &rotator_p_clk.c },
+	{ CLK_TEST_LS(0x2F), &uart1_clk.c },
+	{ CLK_TEST_LS(0x30), &uart1dm_clk.c },
+	{ CLK_TEST_LS(0x31), &uart2_clk.c },
+	{ CLK_TEST_LS(0x33), &usb_hs2_clk.c },
+	{ CLK_TEST_LS(0x34), &usb_hs3_clk.c },
+	{ CLK_TEST_LS(0x35), &mfc_p_clk.c },
+	{ CLK_TEST_LS(0x36), &vfe_clk.c },
+	{ CLK_TEST_LS(0x39), &sdc3_p_clk.c },
+	{ CLK_TEST_LS(0x3A), &sdc3_clk.c },
+	{ CLK_TEST_LS(0x3B), &sdc4_p_clk.c },
+	{ CLK_TEST_LS(0x3C), &sdc4_clk.c },
+	{ CLK_TEST_LS(0x3D), &uart2dm_clk.c },
+	{ CLK_TEST_LS(0x3E), &uart2dm_p_clk.c },
+	{ CLK_TEST_LS(0x3F), &usb_hs_clk.c },
+};
+
+static struct measure_sel *find_measure_sel(struct clk *clk)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(measure_mux); i++)
+		if (measure_mux[i].clk == clk)
+			return &measure_mux[i];
+	return NULL;
+}
+
+static int measure_clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	struct measure_sel *p;
+	unsigned long flags;
+
+	if (!parent)
+		return -EINVAL;
+
+	p = find_measure_sel(parent);
+	if (!p)
+		return -EINVAL;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+
+	/* Program test vector. */
+	if (p->test_vector <= 0xFF) {
+		/* Select CLK_TEST_2 */
+		writel_relaxed(0x4D40, CLK_TEST_BASE_REG);
+		writel_relaxed(p->test_vector, CLK_TEST_2_BASE_REG);
+	} else
+		writel_relaxed(p->test_vector, CLK_TEST_BASE_REG);
+
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+
+	return 0;
+}
+
+/* Sample clock for 'tcxo4_ticks' reference clock ticks. */
+static u32 run_measurement(unsigned tcxo4_ticks)
+{
+	/* TCXO4_CNT_EN and RINGOSC_CNT_EN register values. */
+	u32 reg_val_enable = readl_relaxed(MISC_CLK_CTL_BASE_REG) | 0x3;
+	u32 reg_val_disable = reg_val_enable & ~0x3;
+
+	/* Stop counters and set the TCXO4 counter start value. */
+	writel_relaxed(reg_val_disable, MISC_CLK_CTL_BASE_REG);
+	writel_relaxed(tcxo4_ticks, TCXO_CNT_BASE_REG);
+
+	/* Run measurement and wait for completion. */
+	writel_relaxed(reg_val_enable, MISC_CLK_CTL_BASE_REG);
+	while (readl_relaxed(TCXO_CNT_DONE_BASE_REG) == 0)
+		cpu_relax();
+
+	/* Stop counters. */
+	writel_relaxed(reg_val_disable, MISC_CLK_CTL_BASE_REG);
+
+	return readl_relaxed(RINGOSC_CNT_BASE_REG);
+}
+
+/* Perform a hardware rate measurement for a given clock.
+   FOR DEBUG USE ONLY: Measurements take ~15 ms! */
+static unsigned measure_clk_get_rate(struct clk *clk)
+{
+	unsigned long flags;
+	u32 regval, prph_web_reg_old;
+	u64 raw_count_short, raw_count_full;
+	unsigned ret;
+
+	clk_enable(&tcxo_clk.c);
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+
+	/* Enable TCXO4 clock branch and root. */
+	prph_web_reg_old = readl_relaxed(PRPH_WEB_NS_BASE_REG);
+	regval = prph_web_reg_old | BIT(9) | BIT(11);
+	writel_relaxed(regval, PRPH_WEB_NS_BASE_REG);
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
+	writel_relaxed(prph_web_reg_old, PRPH_WEB_NS_BASE_REG);
+
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+
+	/* Return 0 if the clock is off. */
+	if (raw_count_full == raw_count_short)
+		ret = 0;
+	else {
+		/* Compute rate in Hz. */
+		raw_count_full = ((raw_count_full * 10) + 15) * 4800000;
+		do_div(raw_count_full, ((0x10000 * 10) + 35));
+		ret = raw_count_full;
+	}
+
+	clk_disable(&tcxo_clk.c);
+
+	return ret;
+}
+#else /* !CONFIG_DEBUG_FS */
+static int measure_clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return -EINVAL;
+}
+
+static unsigned measure_clk_get_rate(struct clk *clk)
+{
+	return 0;
+}
+#endif /* CONFIG_DEBUG_FS */
+
+static struct clk_ops measure_clk_ops = {
+	.set_parent = measure_clk_set_parent,
+	.get_rate = measure_clk_get_rate,
+	.is_local = local_clk_is_local,
+};
+
+static struct clk measure_clk = {
+	.dbg_name = "measure_clk",
+	.ops = &measure_clk_ops,
+	CLK_INIT(measure_clk),
+};
+
 /* Implementation for clk_set_flags(). */
 int soc_clk_set_flags(struct clk *clk, unsigned clk_flags)
 {
@@ -2525,6 +2763,7 @@ static struct clk_local_ownership {
 	{ CLK_LOOKUP("pll1_clk",	pll1_clk.c,	"acpu") },
 	{ CLK_LOOKUP("pll2_clk",	pll2_clk.c,	"acpu") },
 	{ CLK_LOOKUP("pll3_clk",	pll3_clk.c,	"acpu") },
+	{ CLK_LOOKUP("measure",		measure_clk,	"debug") },
 
 	/* PCOM */
 	{ CLK_LOOKUP("adsp_clk",	adsp_clk.c,	NULL) },
diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 170797a..7dac975 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -809,7 +809,7 @@ static struct branch_clk ijpeg_p_clk = {
 		.halt_bit = 9,
 	},
 	.c = {
-		.dbg_name = "ijepg_p_clk",
+		.dbg_name = "ijpeg_p_clk",
 		.ops = &clk_ops_branch,
 		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ijpeg_p_clk.c),
@@ -2991,7 +2991,7 @@ static struct clk_freq_tbl clk_tbl_aif_osr[] = {
 	F_END
 };
 
-#define CLK_AIF_OSR(i, ns, md, h_r, tv) \
+#define CLK_AIF_OSR(i, ns, md, h_r) \
 	struct rcg_clk i##_clk = { \
 		.b = { \
 			.ctl_reg = ns, \
@@ -3031,7 +3031,7 @@ static struct clk_freq_tbl clk_tbl_aif_bit[] = {
 	F_END
 };
 
-#define CLK_AIF_BIT(i, ns, h_r, tv) \
+#define CLK_AIF_BIT(i, ns, h_r) \
 	struct rcg_clk i##_clk = { \
 		.b = { \
 			.ctl_reg = ns, \
@@ -3053,33 +3053,28 @@ static struct clk_freq_tbl clk_tbl_aif_bit[] = {
 	}
 
 static CLK_AIF_OSR(mi2s_osr, LCC_MI2S_NS_REG, LCC_MI2S_MD_REG,
-		LCC_MI2S_STATUS_REG, TEST_LPA(0x0A));
-static CLK_AIF_BIT(mi2s_bit, LCC_MI2S_NS_REG, LCC_MI2S_STATUS_REG,
-		TEST_LPA(0x0B));
+		LCC_MI2S_STATUS_REG);
+static CLK_AIF_BIT(mi2s_bit, LCC_MI2S_NS_REG, LCC_MI2S_STATUS_REG);
 
 static CLK_AIF_OSR(codec_i2s_mic_osr, LCC_CODEC_I2S_MIC_NS_REG,
-		LCC_CODEC_I2S_MIC_MD_REG, LCC_CODEC_I2S_MIC_STATUS_REG,
-		TEST_LPA(0x0C));
+		LCC_CODEC_I2S_MIC_MD_REG, LCC_CODEC_I2S_MIC_STATUS_REG);
 static CLK_AIF_BIT(codec_i2s_mic_bit, LCC_CODEC_I2S_MIC_NS_REG,
-		LCC_CODEC_I2S_MIC_STATUS_REG, TEST_LPA(0x0D));
+		LCC_CODEC_I2S_MIC_STATUS_REG);
 
 static CLK_AIF_OSR(spare_i2s_mic_osr, LCC_SPARE_I2S_MIC_NS_REG,
-		LCC_SPARE_I2S_MIC_MD_REG, LCC_SPARE_I2S_MIC_STATUS_REG,
-		TEST_LPA(0x10));
+		LCC_SPARE_I2S_MIC_MD_REG, LCC_SPARE_I2S_MIC_STATUS_REG);
 static CLK_AIF_BIT(spare_i2s_mic_bit, LCC_SPARE_I2S_MIC_NS_REG,
-		LCC_SPARE_I2S_MIC_STATUS_REG, TEST_LPA(0x11));
+		LCC_SPARE_I2S_MIC_STATUS_REG);
 
 static CLK_AIF_OSR(codec_i2s_spkr_osr, LCC_CODEC_I2S_SPKR_NS_REG,
-		LCC_CODEC_I2S_SPKR_MD_REG, LCC_CODEC_I2S_SPKR_STATUS_REG,
-		TEST_LPA(0x0E));
+		LCC_CODEC_I2S_SPKR_MD_REG, LCC_CODEC_I2S_SPKR_STATUS_REG);
 static CLK_AIF_BIT(codec_i2s_spkr_bit, LCC_CODEC_I2S_SPKR_NS_REG,
-		LCC_CODEC_I2S_SPKR_STATUS_REG, TEST_LPA(0x0F));
+		LCC_CODEC_I2S_SPKR_STATUS_REG);
 
 static CLK_AIF_OSR(spare_i2s_spkr_osr, LCC_SPARE_I2S_SPKR_NS_REG,
-		LCC_SPARE_I2S_SPKR_MD_REG, LCC_SPARE_I2S_SPKR_STATUS_REG,
-		TEST_LPA(0x12));
+		LCC_SPARE_I2S_SPKR_MD_REG, LCC_SPARE_I2S_SPKR_STATUS_REG);
 static CLK_AIF_BIT(spare_i2s_spkr_bit, LCC_SPARE_I2S_SPKR_NS_REG,
-		LCC_SPARE_I2S_SPKR_STATUS_REG, TEST_LPA(0x13));
+		LCC_SPARE_I2S_SPKR_STATUS_REG);
 
 #define F_PCM(f, s, d, m, n, v) \
 	{ \
@@ -3131,10 +3126,312 @@ static struct rcg_clk pcm_clk = {
 	},
 };
 
+#ifdef CONFIG_DEBUG_FS
+struct measure_sel {
+	u32 test_vector;
+	struct clk *clk;
+};
+
+static struct measure_sel measure_mux[] = {
+	{ TEST_PER_LS(0x08), &modem_ahb1_p_clk.c },
+	{ TEST_PER_LS(0x09), &modem_ahb2_p_clk.c },
+	{ TEST_PER_LS(0x12), &sdc1_p_clk.c },
+	{ TEST_PER_LS(0x13), &sdc1_clk.c },
+	{ TEST_PER_LS(0x14), &sdc2_p_clk.c },
+	{ TEST_PER_LS(0x15), &sdc2_clk.c },
+	{ TEST_PER_LS(0x16), &sdc3_p_clk.c },
+	{ TEST_PER_LS(0x17), &sdc3_clk.c },
+	{ TEST_PER_LS(0x18), &sdc4_p_clk.c },
+	{ TEST_PER_LS(0x19), &sdc4_clk.c },
+	{ TEST_PER_LS(0x1A), &sdc5_p_clk.c },
+	{ TEST_PER_LS(0x1B), &sdc5_clk.c },
+	{ TEST_PER_LS(0x26), &pmem_clk.c },
+	{ TEST_PER_LS(0x2B), &ppss_p_clk.c },
+	{ TEST_PER_LS(0x3D), &gsbi1_p_clk.c },
+	{ TEST_PER_LS(0x3E), &gsbi1_uart_clk.c },
+	{ TEST_PER_LS(0x3F), &gsbi1_qup_clk.c },
+	{ TEST_PER_LS(0x41), &gsbi2_p_clk.c },
+	{ TEST_PER_LS(0x42), &gsbi2_uart_clk.c },
+	{ TEST_PER_LS(0x44), &gsbi2_qup_clk.c },
+	{ TEST_PER_LS(0x45), &gsbi3_p_clk.c },
+	{ TEST_PER_LS(0x46), &gsbi3_uart_clk.c },
+	{ TEST_PER_LS(0x48), &gsbi3_qup_clk.c },
+	{ TEST_PER_LS(0x49), &gsbi4_p_clk.c },
+	{ TEST_PER_LS(0x4A), &gsbi4_uart_clk.c },
+	{ TEST_PER_LS(0x4C), &gsbi4_qup_clk.c },
+	{ TEST_PER_LS(0x4D), &gsbi5_p_clk.c },
+	{ TEST_PER_LS(0x4E), &gsbi5_uart_clk.c },
+	{ TEST_PER_LS(0x50), &gsbi5_qup_clk.c },
+	{ TEST_PER_LS(0x51), &gsbi6_p_clk.c },
+	{ TEST_PER_LS(0x52), &gsbi6_uart_clk.c },
+	{ TEST_PER_LS(0x54), &gsbi6_qup_clk.c },
+	{ TEST_PER_LS(0x55), &gsbi7_p_clk.c },
+	{ TEST_PER_LS(0x56), &gsbi7_uart_clk.c },
+	{ TEST_PER_LS(0x58), &gsbi7_qup_clk.c },
+	{ TEST_PER_LS(0x59), &gsbi8_p_clk.c },
+	{ TEST_PER_LS(0x5A), &gsbi8_uart_clk.c },
+	{ TEST_PER_LS(0x5C), &gsbi8_qup_clk.c },
+	{ TEST_PER_LS(0x5D), &gsbi9_p_clk.c },
+	{ TEST_PER_LS(0x5E), &gsbi9_uart_clk.c },
+	{ TEST_PER_LS(0x60), &gsbi9_qup_clk.c },
+	{ TEST_PER_LS(0x61), &gsbi10_p_clk.c },
+	{ TEST_PER_LS(0x62), &gsbi10_uart_clk.c },
+	{ TEST_PER_LS(0x64), &gsbi10_qup_clk.c },
+	{ TEST_PER_LS(0x65), &gsbi11_p_clk.c },
+	{ TEST_PER_LS(0x66), &gsbi11_uart_clk.c },
+	{ TEST_PER_LS(0x68), &gsbi11_qup_clk.c },
+	{ TEST_PER_LS(0x69), &gsbi12_p_clk.c },
+	{ TEST_PER_LS(0x6A), &gsbi12_uart_clk.c },
+	{ TEST_PER_LS(0x6C), &gsbi12_qup_clk.c },
+	{ TEST_PER_LS(0x7A), &pmic_ssbi2_clk.c },
+	{ TEST_PER_LS(0x7B), &pmic_arb0_p_clk.c },
+	{ TEST_PER_LS(0x7C), &pmic_arb1_p_clk.c },
+	{ TEST_PER_LS(0x7D), &prng_clk.c },
+	{ TEST_PER_LS(0x7F), &rpm_msg_ram_p_clk.c },
+	{ TEST_PER_LS(0x80), &adm0_p_clk.c },
+	{ TEST_PER_LS(0x81), &adm1_p_clk.c },
+	{ TEST_PER_LS(0x84), &usb_hs1_p_clk.c },
+	{ TEST_PER_LS(0x85), &usb_hs1_xcvr_clk.c },
+	{ TEST_PER_LS(0x89), &usb_fs1_p_clk.c },
+	{ TEST_PER_LS(0x8A), &usb_fs1_sys_clk.c },
+	{ TEST_PER_LS(0x8B), &usb_fs1_xcvr_clk.c },
+	{ TEST_PER_LS(0x8C), &usb_fs2_p_clk.c },
+	{ TEST_PER_LS(0x8D), &usb_fs2_sys_clk.c },
+	{ TEST_PER_LS(0x8E), &usb_fs2_xcvr_clk.c },
+	{ TEST_PER_LS(0x8F), &tsif_p_clk.c },
+	{ TEST_PER_LS(0x91), &tsif_ref_clk.c },
+	{ TEST_PER_LS(0x93), &ce2_p_clk.c },
+	{ TEST_PER_LS(0x94), &tssc_clk.c },
+
+	{ TEST_PER_HS(0x2A), &adm0_clk.c },
+	{ TEST_PER_HS(0x2B), &adm1_clk.c },
+
+	{ TEST_MM_LS(0x00), &dsi_byte_clk.c },
+	{ TEST_MM_LS(0x01), &pixel_lcdc_clk.c },
+	{ TEST_MM_LS(0x04), &pixel_mdp_clk.c },
+	{ TEST_MM_LS(0x06), &amp_p_clk.c },
+	{ TEST_MM_LS(0x07), &csi0_p_clk.c },
+	{ TEST_MM_LS(0x08), &csi1_p_clk.c },
+	{ TEST_MM_LS(0x09), &dsi_m_p_clk.c },
+	{ TEST_MM_LS(0x0A), &dsi_s_p_clk.c },
+	{ TEST_MM_LS(0x0C), &gfx2d0_p_clk.c },
+	{ TEST_MM_LS(0x0D), &gfx2d1_p_clk.c },
+	{ TEST_MM_LS(0x0E), &gfx3d_p_clk.c },
+	{ TEST_MM_LS(0x0F), &hdmi_m_p_clk.c },
+	{ TEST_MM_LS(0x10), &hdmi_s_p_clk.c },
+	{ TEST_MM_LS(0x11), &ijpeg_p_clk.c },
+	{ TEST_MM_LS(0x12), &imem_p_clk.c },
+	{ TEST_MM_LS(0x13), &jpegd_p_clk.c },
+	{ TEST_MM_LS(0x14), &mdp_p_clk.c },
+	{ TEST_MM_LS(0x16), &rot_p_clk.c },
+	{ TEST_MM_LS(0x18), &smmu_p_clk.c },
+	{ TEST_MM_LS(0x19), &tv_enc_p_clk.c },
+	{ TEST_MM_LS(0x1A), &vcodec_p_clk.c },
+	{ TEST_MM_LS(0x1B), &vfe_p_clk.c },
+	{ TEST_MM_LS(0x1C), &vpe_p_clk.c },
+	{ TEST_MM_LS(0x1D), &cam_clk.c },
+	{ TEST_MM_LS(0x1F), &hdmi_app_clk.c },
+	{ TEST_MM_LS(0x20), &mdp_vsync_clk.c },
+	{ TEST_MM_LS(0x21), &tv_dac_clk.c },
+	{ TEST_MM_LS(0x22), &tv_enc_clk.c },
+	{ TEST_MM_LS(0x23), &dsi_esc_clk.c },
+
+	{ TEST_MM_HS(0x00), &csi0_clk.c },
+	{ TEST_MM_HS(0x01), &csi1_clk.c },
+	{ TEST_MM_HS(0x03), &csi0_vfe_clk.c },
+	{ TEST_MM_HS(0x04), &csi1_vfe_clk.c },
+	{ TEST_MM_HS(0x05), &ijpeg_clk.c },
+	{ TEST_MM_HS(0x06), &vfe_clk.c },
+	{ TEST_MM_HS(0x07), &gfx2d0_clk.c },
+	{ TEST_MM_HS(0x08), &gfx2d1_clk.c },
+	{ TEST_MM_HS(0x09), &gfx3d_clk.c },
+	{ TEST_MM_HS(0x0A), &jpegd_clk.c },
+	{ TEST_MM_HS(0x0B), &vcodec_clk.c },
+	{ TEST_MM_HS(0x11), &gmem_axi_clk.c },
+	{ TEST_MM_HS(0x12), &ijpeg_axi_clk.c },
+	{ TEST_MM_HS(0x13), &imem_axi_clk.c },
+	{ TEST_MM_HS(0x14), &jpegd_axi_clk.c },
+	{ TEST_MM_HS(0x15), &mdp_axi_clk.c },
+	{ TEST_MM_HS(0x17), &vcodec_axi_clk.c },
+	{ TEST_MM_HS(0x18), &vfe_axi_clk.c },
+	{ TEST_MM_HS(0x1A), &mdp_clk.c },
+	{ TEST_MM_HS(0x1B), &rot_clk.c },
+	{ TEST_MM_HS(0x1C), &vpe_clk.c },
+	{ TEST_MM_HS(0x1E), &hdmi_tv_clk.c },
+	{ TEST_MM_HS(0x1F), &mdp_tv_clk.c },
+
+	{ TEST_LPA(0x0A), &mi2s_osr_clk.c },
+	{ TEST_LPA(0x0B), &mi2s_bit_clk.c },
+	{ TEST_LPA(0x0C), &codec_i2s_mic_osr_clk.c },
+	{ TEST_LPA(0x0D), &codec_i2s_mic_bit_clk.c },
+	{ TEST_LPA(0x0E), &codec_i2s_spkr_osr_clk.c },
+	{ TEST_LPA(0x0F), &codec_i2s_spkr_bit_clk.c },
+	{ TEST_LPA(0x10), &spare_i2s_mic_osr_clk.c },
+	{ TEST_LPA(0x11), &spare_i2s_mic_bit_clk.c },
+	{ TEST_LPA(0x12), &spare_i2s_spkr_osr_clk.c },
+	{ TEST_LPA(0x13), &spare_i2s_spkr_bit_clk.c },
+	{ TEST_LPA(0x14), &pcm_clk.c },
+};
+
+static struct measure_sel *find_measure_sel(struct clk *clk)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(measure_mux); i++)
+		if (measure_mux[i].clk == clk)
+			return &measure_mux[i];
+	return NULL;
+}
+
+static int measure_clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	int ret = 0;
+	u32 clk_sel;
+	struct measure_sel *p;
+	unsigned long flags;
+
+	if (!parent)
+		return -EINVAL;
+
+	p = find_measure_sel(parent);
+	if (!p)
+		return -EINVAL;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+
+	/* Program the test vector. */
+	clk_sel = p->test_vector & TEST_CLK_SEL_MASK;
+	switch (p->test_vector >> TEST_TYPE_SHIFT) {
+	case TEST_TYPE_PER_LS:
+		writel_relaxed(0x4030D00|BVAL(7, 0, clk_sel), CLK_TEST_REG);
+		break;
+	case TEST_TYPE_PER_HS:
+		writel_relaxed(0x4020000|BVAL(16, 10, clk_sel), CLK_TEST_REG);
+		break;
+	case TEST_TYPE_MM_LS:
+		writel_relaxed(0x4030D97, CLK_TEST_REG);
+		writel_relaxed(BVAL(6, 1, clk_sel)|BIT(0), DBG_CFG_REG_LS_REG);
+		break;
+	case TEST_TYPE_MM_HS:
+		writel_relaxed(0x402B800, CLK_TEST_REG);
+		writel_relaxed(BVAL(6, 1, clk_sel)|BIT(0), DBG_CFG_REG_HS_REG);
+		break;
+	case TEST_TYPE_LPA:
+		writel_relaxed(0x4030D98, CLK_TEST_REG);
+		writel_relaxed(BVAL(6, 1, clk_sel)|BIT(0),
+				LCC_CLK_LS_DEBUG_CFG_REG);
+		break;
+	default:
+		ret = -EPERM;
+	}
+	/* Make sure test vector is set before starting measurements. */
+	mb();
+
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+
+	return ret;
+}
+
+/* Sample clock for 'ticks' reference clock ticks. */
+static u32 run_measurement(unsigned ticks)
+{
+	/* Stop counters and set the XO4 counter start value. */
+	writel_relaxed(0x0, RINGOSC_TCXO_CTL_REG);
+	writel_relaxed(ticks, RINGOSC_TCXO_CTL_REG);
+
+	/* Wait for timer to become ready. */
+	while ((readl_relaxed(RINGOSC_STATUS_REG) & BIT(25)) != 0)
+		cpu_relax();
+
+	/* Run measurement and wait for completion. */
+	writel_relaxed(BIT(20)|ticks, RINGOSC_TCXO_CTL_REG);
+	while ((readl_relaxed(RINGOSC_STATUS_REG) & BIT(25)) == 0)
+		cpu_relax();
+
+	/* Stop counters. */
+	writel_relaxed(0x0, RINGOSC_TCXO_CTL_REG);
+
+	/* Return measured ticks. */
+	return readl_relaxed(RINGOSC_STATUS_REG) & BM(24, 0);
+}
+
+/* Perform a hardware rate measurement for a given clock.
+   FOR DEBUG USE ONLY: Measurements take ~15 ms! */
+static unsigned measure_clk_get_rate(struct clk *clk)
+{
+	unsigned long flags;
+	u32 pdm_reg_backup, ringosc_reg_backup;
+	u64 raw_count_short, raw_count_full;
+	unsigned ret;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+
+	/* Enable CXO/4 and RINGOSC branch and root. */
+	pdm_reg_backup = readl_relaxed(PDM_CLK_NS_REG);
+	ringosc_reg_backup = readl_relaxed(RINGOSC_NS_REG);
+	writel_relaxed(0x2898, PDM_CLK_NS_REG);
+	writel_relaxed(0xA00, RINGOSC_NS_REG);
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
+	writel_relaxed(ringosc_reg_backup, RINGOSC_NS_REG);
+	writel_relaxed(pdm_reg_backup, PDM_CLK_NS_REG);
+
+	/* Return 0 if the clock is off. */
+	if (raw_count_full == raw_count_short)
+		ret = 0;
+	else {
+		/* Compute rate in Hz. */
+		raw_count_full = ((raw_count_full * 10) + 15) * 4800000;
+		do_div(raw_count_full, ((0x10000 * 10) + 35));
+		ret = raw_count_full;
+	}
+
+	/* Route dbg_hs_clk to PLLTEST.  300mV single-ended amplitude. */
+	writel_relaxed(0x3CF8, PLLTEST_PAD_CFG_REG);
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+
+	return ret;
+}
+#else /* !CONFIG_DEBUG_FS */
+static int measure_clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return -EINVAL;
+}
+
+static unsigned measure_clk_get_rate(struct clk *clk)
+{
+	return 0;
+}
+#endif /* CONFIG_DEBUG_FS */
+
+static struct clk_ops measure_clk_ops = {
+	.set_parent = measure_clk_set_parent,
+	.get_rate = measure_clk_get_rate,
+	.is_local = local_clk_is_local,
+};
+
+static struct clk measure_clk = {
+	.dbg_name = "measure_clk",
+	.ops = &measure_clk_ops,
+	CLK_INIT(measure_clk),
+};
+
 struct clk_lookup msm_clocks_8x60[] = {
 	CLK_LOOKUP("cxo",		cxo_clk.c,	NULL),
 	CLK_LOOKUP("pll4",		pll4_clk.c,	NULL),
 	CLK_LOOKUP("pll4",		pll4_clk.c,	"peripheral-reset"),
+	CLK_LOOKUP("measure",		measure_clk,	"debug"),
 
 	CLK_LOOKUP("gsbi_uart_clk",	gsbi1_uart_clk.c,		NULL),
 	CLK_LOOKUP("gsbi_uart_clk",	gsbi2_uart_clk.c,		NULL),
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index 78b7b6c..1a08a9a 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2007-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -50,6 +50,23 @@ static int clock_debug_rate_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(clock_rate_fops, clock_debug_rate_get,
 			clock_debug_rate_set, "%llu\n");
 
+static struct clk *measure;
+
+static int clock_debug_measure_get(void *data, u64 *val)
+{
+	int ret;
+	struct clk *clock = data;
+
+	ret = clk_set_parent(measure, clock);
+	if (!ret)
+		*val = clk_get_rate(measure);
+
+	return ret;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(clock_measure_fops, clock_debug_measure_get,
+			NULL, "%lld\n");
+
 static int clock_debug_enable_set(void *data, u64 val)
 {
 	struct clk *clock = data;
@@ -96,10 +113,19 @@ static struct dentry *debugfs_base;
 
 int __init clock_debug_init(void)
 {
+	int ret = 0;
+
 	debugfs_base = debugfs_create_dir("clk", NULL);
 	if (!debugfs_base)
 		return -ENOMEM;
-	return 0;
+
+	measure = clk_get_sys("debug", "measure");
+	if (IS_ERR(measure)) {
+		ret = PTR_ERR(measure);
+		measure = NULL;
+	}
+
+	return ret;
 }
 
 static int list_rates_show(struct seq_file *m, void *unused)
@@ -153,6 +179,12 @@ int __init clock_debug_add(struct clk *clock)
 				&clock_local_fops))
 		goto error;
 
+	if (measure &&
+	    !clk_set_parent(measure, clock) &&
+	    !debugfs_create_file("measure", S_IRUGO, clk_dir, clock,
+				&clock_measure_fops))
+		goto error;
+
 	if (clock->ops->list_rate)
 		if (!debugfs_create_file("list_rates",
 				S_IRUGO, clk_dir, clock, &list_rates_fops))
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 26b52f2..32b164c 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -1,7 +1,7 @@
 /* arch/arm/mach-msm/clock.h
  *
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2007-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

