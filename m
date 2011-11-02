Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab1KBSik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:38:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab1KBShK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707010"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 28/34] msm: clock: Invert CLKFLAG_AUTO_OFF
Date: Wed,  2 Nov 2011 11:36:25 -0700
Message-Id: <1320258991-22325-29-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

All locally controlled clocks can participate in the auto off
operations. Make the auto off flag default (and 0) to save lines
in struct clk definitions. We make the auto_off ops optional to
avoid marking PLLs and XOs explicitly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.c        |  210 ++++++++----------
 arch/arm/mach-msm/clock-8960.c        |  116 ----------
 arch/arm/mach-msm/clock-8x60.c        |  104 ---------
 arch/arm/mach-msm/clock-pcom-lookup.c |  381 +++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-voter.h       |    1 +
 arch/arm/mach-msm/clock.c             |   11 +-
 arch/arm/mach-msm/clock.h             |    3 +-
 arch/arm/mach-msm/devices-msm7x00.c   |   82 ++++----
 arch/arm/mach-msm/devices-qsd8x50.c   |  100 +++++-----
 9 files changed, 573 insertions(+), 435 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-pcom-lookup.c

diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index f73e76f..ce0e73c 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -553,7 +553,6 @@ static struct branch_clk camif_pad_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "camif_pad_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(camif_pad_p_clk.c),
 	},
@@ -588,7 +587,6 @@ static struct branch_clk emdh_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "emdh_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(emdh_p_clk.c),
 	},
@@ -640,7 +638,6 @@ static struct branch_clk jpeg_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "jpeg_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(jpeg_p_clk.c),
 	},
@@ -726,7 +723,6 @@ static struct branch_clk rotator_imem_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "rotator_imem_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(rotator_imem_clk.c),
 	},
@@ -744,7 +740,6 @@ static struct branch_clk rotator_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "rotator_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(rotator_p_clk.c),
 	},
@@ -762,7 +757,6 @@ static struct branch_clk sdc1_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "sdc1_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(sdc1_p_clk.c),
 	},
@@ -780,7 +774,6 @@ static struct branch_clk sdc2_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "sdc2_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(sdc2_p_clk.c),
 	},
@@ -798,7 +791,6 @@ static struct branch_clk sdc3_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "sdc3_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(sdc3_p_clk.c),
 	},
@@ -816,7 +808,6 @@ static struct branch_clk sdc4_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "sdc4_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(sdc4_p_clk.c),
 	},
@@ -900,7 +891,6 @@ static struct branch_clk usb_hs2_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "usb_hs2_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs2_p_clk.c),
 	},
@@ -918,7 +908,6 @@ static struct branch_clk usb_hs3_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "usb_hs3_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs3_p_clk.c),
 	},
@@ -936,7 +925,6 @@ static struct branch_clk usb_hs_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "usb_hs_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs_p_clk.c),
 	},
@@ -954,7 +942,6 @@ static struct branch_clk vfe_p_clk = {
 	.parent = &glbl_root_clk.c,
 	.c = {
 		.dbg_name = "vfe_p_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(vfe_p_clk.c),
 	},
@@ -1066,7 +1053,6 @@ static struct rcg_clk uart1_clk = {
 	.current_freq = &local_dummy_freq,
 	.c = {
 		.dbg_name = "uart1_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(uart1_clk.c),
 	},
@@ -1124,7 +1110,6 @@ static struct rcg_clk uart1dm_clk = {
 	.set_rate = set_rate_mnd,
 	.c = {
 		.dbg_name = "uart1dm_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(uart1dm_clk.c),
 	},
@@ -1180,7 +1165,7 @@ static struct rcg_clk emdh_clk = {
 	.current_freq = &local_dummy_freq,
 	.c = {
 		.dbg_name = "emdh_clk",
-		.flags = CLKFLAG_AUTO_OFF | CLKFLAG_MIN | CLKFLAG_MAX,
+		.flags = CLKFLAG_MIN | CLKFLAG_MAX,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(emdh_clk.c),
 	},
@@ -1201,7 +1186,7 @@ static struct rcg_clk pmdh_clk = {
 	.current_freq = &local_dummy_freq,
 	.c = {
 		.dbg_name = "pmdh_clk",
-		.flags = CLKFLAG_AUTO_OFF | CLKFLAG_MIN | CLKFLAG_MAX,
+		.flags = CLKFLAG_MIN | CLKFLAG_MAX,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(pmdh_clk.c),
 	},
@@ -1297,7 +1282,6 @@ static struct branch_clk imem_clk = {
 	.parent = &grp_3d_src_clk.c,
 	.c = {
 		.dbg_name = "imem_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(imem_clk.c),
 	},
@@ -1332,7 +1316,6 @@ static struct rcg_clk sdc1_clk = {
 	.set_rate = set_rate_mnd,
 	.c = {
 		.dbg_name = "sdc1_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(sdc1_clk.c),
 	},
@@ -1355,7 +1338,6 @@ static struct rcg_clk sdc3_clk = {
 	.set_rate = set_rate_mnd,
 	.c = {
 		.dbg_name = "sdc3_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(sdc3_clk.c),
 	},
@@ -1390,7 +1372,6 @@ static struct rcg_clk sdc2_clk = {
 	.set_rate = set_rate_mnd,
 	.c = {
 		.dbg_name = "sdc2_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(sdc2_clk.c),
 	},
@@ -1413,7 +1394,6 @@ static struct rcg_clk sdc4_clk = {
 	.set_rate = set_rate_mnd,
 	.c = {
 		.dbg_name = "sdc4_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(sdc4_clk.c),
 	},
@@ -1449,7 +1429,6 @@ static struct rcg_clk mdp_clk = {
 	.current_freq = &local_dummy_freq,
 	.c = {
 		.dbg_name = "mdp_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(mdp_clk.c),
 	},
@@ -1524,7 +1503,6 @@ static struct rcg_clk mdp_vsync_clk = {
 	.current_freq = &local_dummy_freq,
 	.c = {
 		.dbg_name = "mdp_vsync_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(mdp_vsync_clk.c),
 	},
@@ -1724,7 +1702,6 @@ static struct rcg_clk sdac_clk = {
 	.current_freq = &local_dummy_freq,
 	.c = {
 		.dbg_name = "sdac_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(sdac_clk.c),
 	},
@@ -1741,7 +1718,6 @@ static struct branch_clk sdac_m_clk = {
 	.parent = &sdac_clk.c,
 	.c = {
 		.dbg_name = "sdac_m_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(sdac_m_clk.c),
 	},
@@ -1874,7 +1850,6 @@ static struct branch_clk usb_hs_clk = {
 	},
 	.c = {
 		.dbg_name = "usb_hs_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs_clk.c),
 	},
@@ -1891,7 +1866,6 @@ static struct branch_clk usb_hs_core_clk = {
 	.parent = &usb_hs_src_clk.c,
 	.c = {
 		.dbg_name = "usb_hs_core_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs_core_clk.c),
 	},
@@ -1908,7 +1882,6 @@ static struct branch_clk usb_hs2_clk = {
 	.parent = &usb_hs_src_clk.c,
 	.c = {
 		.dbg_name = "usb_hs2_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs2_clk.c),
 	},
@@ -1925,7 +1898,6 @@ static struct branch_clk usb_hs2_core_clk = {
 	.parent = &usb_hs_src_clk.c,
 	.c = {
 		.dbg_name = "usb_hs2_core_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs2_core_clk.c),
 	},
@@ -1942,7 +1914,6 @@ static struct branch_clk usb_hs3_clk = {
 	.parent = &usb_hs_src_clk.c,
 	.c = {
 		.dbg_name = "usb_hs3_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs3_clk.c),
 	},
@@ -1959,7 +1930,6 @@ static struct branch_clk usb_hs3_core_clk = {
 	.parent = &usb_hs_src_clk.c,
 	.c = {
 		.dbg_name = "usb_hs3_core_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &clk_ops_branch,
 		CLK_INIT(usb_hs3_core_clk.c),
 	},
@@ -2000,7 +1970,6 @@ static struct rcg_clk jpeg_clk = {
 	.current_freq = &local_dummy_freq,
 	.c = {
 		.dbg_name = "jpeg_clk",
-		.flags = CLKFLAG_AUTO_OFF,
 		.ops = &soc_clk_ops_7x30,
 		CLK_INIT(jpeg_clk.c),
 	},
@@ -2294,93 +2263,98 @@ static struct branch_clk lpa_core_clk = {
 	},
 };
 
-static DEFINE_CLK_PCOM(adsp_clk, ADSP_CLK, 0);
-static DEFINE_CLK_PCOM(codec_ssbi_clk,	CODEC_SSBI_CLK, 0);
+static DEFINE_CLK_PCOM(adsp_clk, ADSP_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(codec_ssbi_clk,	CODEC_SSBI_CLK, CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(ebi1_clk, EBI1_CLK, CLK_MIN);
-static DEFINE_CLK_PCOM(ecodec_clk, ECODEC_CLK, 0);
-static DEFINE_CLK_PCOM(gp_clk, GP_CLK, 0);
-static DEFINE_CLK_PCOM(uart3_clk, UART3_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(usb_phy_clk, USB_PHY_CLK, CLKFLAG_AUTO_OFF | CLK_MIN);
+static DEFINE_CLK_PCOM(ecodec_clk, ECODEC_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(gp_clk, GP_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(uart3_clk, UART3_CLK, 0);
+static DEFINE_CLK_PCOM(usb_phy_clk, USB_PHY_CLK, CLK_MIN);
 
-static DEFINE_CLK_PCOM(p_grp_2d_clk, GRP_2D_CLK, 0);
-static DEFINE_CLK_PCOM(p_grp_2d_p_clk, GRP_2D_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_hdmi_clk, HDMI_CLK, 0);
-static DEFINE_CLK_PCOM(p_jpeg_clk, JPEG_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_jpeg_p_clk, JPEG_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_lpa_codec_clk, LPA_CODEC_CLK, 0);
-static DEFINE_CLK_PCOM(p_lpa_core_clk, LPA_CORE_CLK, 0);
-static DEFINE_CLK_PCOM(p_lpa_p_clk, LPA_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_mi2s_m_clk, MI2S_M_CLK, 0);
-static DEFINE_CLK_PCOM(p_mi2s_s_clk, MI2S_S_CLK, 0);
-static DEFINE_CLK_PCOM(p_mi2s_codec_rx_m_clk, MI2S_CODEC_RX_M_CLK, 0);
-static DEFINE_CLK_PCOM(p_mi2s_codec_rx_s_clk, MI2S_CODEC_RX_S_CLK, 0);
-static DEFINE_CLK_PCOM(p_mi2s_codec_tx_m_clk, MI2S_CODEC_TX_M_CLK, 0);
-static DEFINE_CLK_PCOM(p_mi2s_codec_tx_s_clk, MI2S_CODEC_TX_S_CLK, 0);
-static DEFINE_CLK_PCOM(p_sdac_clk, SDAC_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_sdac_m_clk, SDAC_M_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_vfe_clk, VFE_CLK, 0);
-static DEFINE_CLK_PCOM(p_vfe_camif_clk, VFE_CAMIF_CLK, 0);
-static DEFINE_CLK_PCOM(p_vfe_mdc_clk, VFE_MDC_CLK, 0);
-static DEFINE_CLK_PCOM(p_vfe_p_clk, VFE_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_grp_3d_clk, GRP_3D_CLK, 0);
-static DEFINE_CLK_PCOM(p_grp_3d_p_clk, GRP_3D_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_imem_clk, IMEM_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_mdp_lcdc_pad_pclk_clk, MDP_LCDC_PAD_PCLK_CLK, 0);
-static DEFINE_CLK_PCOM(p_mdp_lcdc_pclk_clk, MDP_LCDC_PCLK_CLK, 0);
-static DEFINE_CLK_PCOM(p_mdp_p_clk, MDP_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_mdp_vsync_clk, MDP_VSYNC_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_tsif_ref_clk, TSIF_REF_CLK, 0);
-static DEFINE_CLK_PCOM(p_tsif_p_clk, TSIF_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_tv_dac_clk, TV_DAC_CLK, 0);
-static DEFINE_CLK_PCOM(p_tv_enc_clk, TV_ENC_CLK, 0);
-static DEFINE_CLK_PCOM(p_emdh_clk, EMDH_CLK,
-		CLKFLAG_AUTO_OFF | CLKFLAG_MIN | CLKFLAG_MAX);
-static DEFINE_CLK_PCOM(p_emdh_p_clk, EMDH_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_i2c_clk, I2C_CLK, 0);
-static DEFINE_CLK_PCOM(p_i2c_2_clk, I2C_2_CLK, 0);
-static DEFINE_CLK_PCOM(p_mdc_clk, MDC_CLK, 0);
-static DEFINE_CLK_PCOM(p_pmdh_clk, PMDH_CLK,
-		CLKFLAG_AUTO_OFF | CLKFLAG_MIN | CLKFLAG_MAX);
-static DEFINE_CLK_PCOM(p_pmdh_p_clk, PMDH_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_sdc1_clk, SDC1_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_sdc1_p_clk, SDC1_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_sdc2_clk, SDC2_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_sdc2_p_clk, SDC2_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_sdc3_clk, SDC3_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_sdc3_p_clk, SDC3_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_sdc4_clk, SDC4_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_sdc4_p_clk, SDC4_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_uart2_clk, UART2_CLK, 0);
-static DEFINE_CLK_PCOM(p_usb_hs2_clk, USB_HS2_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_usb_hs2_core_clk, USB_HS2_CORE_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_usb_hs2_p_clk, USB_HS2_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_usb_hs3_clk, USB_HS3_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_usb_hs3_core_clk, USB_HS3_CORE_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_usb_hs3_p_clk, USB_HS3_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_qup_i2c_clk, QUP_I2C_CLK, 0);
-static DEFINE_CLK_PCOM(p_spi_clk, SPI_CLK, 0);
-static DEFINE_CLK_PCOM(p_spi_p_clk, SPI_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_uart1_clk, UART1_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_uart1dm_clk, UART1DM_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_uart2dm_clk, UART2DM_CLK, 0);
-static DEFINE_CLK_PCOM(p_usb_hs_clk, USB_HS_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_usb_hs_core_clk, USB_HS_CORE_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_usb_hs_p_clk, USB_HS_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_cam_m_clk, CAM_M_CLK, 0);
-static DEFINE_CLK_PCOM(p_camif_pad_p_clk, CAMIF_PAD_P_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_csi0_clk, CSI0_CLK, 0);
-static DEFINE_CLK_PCOM(p_csi0_vfe_clk, CSI0_VFE_CLK, 0);
-static DEFINE_CLK_PCOM(p_csi0_p_clk, CSI0_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_mdp_clk, MDP_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_mfc_clk, MFC_CLK, 0);
-static DEFINE_CLK_PCOM(p_mfc_div2_clk, MFC_DIV2_CLK, 0);
-static DEFINE_CLK_PCOM(p_mfc_p_clk, MFC_P_CLK, 0);
-static DEFINE_CLK_PCOM(p_vpe_clk, VPE_CLK, 0);
-static DEFINE_CLK_PCOM(p_adm_clk, ADM_CLK, 0);
-static DEFINE_CLK_PCOM(p_ce_clk, CE_CLK, 0);
-static DEFINE_CLK_PCOM(p_axi_rotator_clk, AXI_ROTATOR_CLK, 0);
-static DEFINE_CLK_PCOM(p_rotator_imem_clk, ROTATOR_IMEM_CLK, CLKFLAG_AUTO_OFF);
-static DEFINE_CLK_PCOM(p_rotator_p_clk, ROTATOR_P_CLK, CLKFLAG_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_grp_2d_clk, GRP_2D_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_grp_2d_p_clk, GRP_2D_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_hdmi_clk, HDMI_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_jpeg_clk, JPEG_CLK, 0);
+static DEFINE_CLK_PCOM(p_jpeg_p_clk, JPEG_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_lpa_codec_clk, LPA_CODEC_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_lpa_core_clk, LPA_CORE_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_lpa_p_clk, LPA_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mi2s_m_clk, MI2S_M_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mi2s_s_clk, MI2S_S_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mi2s_codec_rx_m_clk, MI2S_CODEC_RX_M_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mi2s_codec_rx_s_clk, MI2S_CODEC_RX_S_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mi2s_codec_tx_m_clk, MI2S_CODEC_TX_M_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mi2s_codec_tx_s_clk, MI2S_CODEC_TX_S_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_sdac_clk, SDAC_CLK, 0);
+static DEFINE_CLK_PCOM(p_sdac_m_clk, SDAC_M_CLK, 0);
+static DEFINE_CLK_PCOM(p_vfe_clk, VFE_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_vfe_camif_clk, VFE_CAMIF_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_vfe_mdc_clk, VFE_MDC_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_vfe_p_clk, VFE_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_grp_3d_clk, GRP_3D_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_grp_3d_p_clk, GRP_3D_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_imem_clk, IMEM_CLK, 0);
+static DEFINE_CLK_PCOM(p_mdp_lcdc_pad_pclk_clk, MDP_LCDC_PAD_PCLK_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mdp_lcdc_pclk_clk, MDP_LCDC_PCLK_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mdp_p_clk, MDP_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mdp_vsync_clk, MDP_VSYNC_CLK, 0);
+static DEFINE_CLK_PCOM(p_tsif_ref_clk, TSIF_REF_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_tsif_p_clk, TSIF_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_tv_dac_clk, TV_DAC_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_tv_enc_clk, TV_ENC_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_emdh_clk, EMDH_CLK, CLKFLAG_MIN | CLKFLAG_MAX);
+static DEFINE_CLK_PCOM(p_emdh_p_clk, EMDH_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_i2c_clk, I2C_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_i2c_2_clk, I2C_2_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mdc_clk, MDC_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_pmdh_clk, PMDH_CLK, CLKFLAG_MIN | CLKFLAG_MAX);
+static DEFINE_CLK_PCOM(p_pmdh_p_clk, PMDH_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_sdc1_clk, SDC1_CLK, 0);
+static DEFINE_CLK_PCOM(p_sdc1_p_clk, SDC1_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_sdc2_clk, SDC2_CLK, 0);
+static DEFINE_CLK_PCOM(p_sdc2_p_clk, SDC2_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_sdc3_clk, SDC3_CLK, 0);
+static DEFINE_CLK_PCOM(p_sdc3_p_clk, SDC3_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_sdc4_clk, SDC4_CLK, 0);
+static DEFINE_CLK_PCOM(p_sdc4_p_clk, SDC4_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_uart2_clk, UART2_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_usb_hs2_clk, USB_HS2_CLK, 0);
+static DEFINE_CLK_PCOM(p_usb_hs2_core_clk, USB_HS2_CORE_CLK, 0);
+static DEFINE_CLK_PCOM(p_usb_hs2_p_clk, USB_HS2_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_usb_hs3_clk, USB_HS3_CLK, 0);
+static DEFINE_CLK_PCOM(p_usb_hs3_core_clk, USB_HS3_CORE_CLK, 0);
+static DEFINE_CLK_PCOM(p_usb_hs3_p_clk, USB_HS3_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_qup_i2c_clk, QUP_I2C_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_spi_clk, SPI_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_spi_p_clk, SPI_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_uart1_clk, UART1_CLK, 0);
+static DEFINE_CLK_PCOM(p_uart1dm_clk, UART1DM_CLK, 0);
+static DEFINE_CLK_PCOM(p_uart2dm_clk, UART2DM_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_usb_hs_clk, USB_HS_CLK, 0);
+static DEFINE_CLK_PCOM(p_usb_hs_core_clk, USB_HS_CORE_CLK, 0);
+static DEFINE_CLK_PCOM(p_usb_hs_p_clk, USB_HS_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_cam_m_clk, CAM_M_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_camif_pad_p_clk, CAMIF_PAD_P_CLK, 0);
+static DEFINE_CLK_PCOM(p_csi0_clk, CSI0_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_csi0_vfe_clk, CSI0_VFE_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_csi0_p_clk, CSI0_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mdp_clk, MDP_CLK, 0);
+static DEFINE_CLK_PCOM(p_mfc_clk, MFC_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mfc_div2_clk, MFC_DIV2_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_mfc_p_clk, MFC_P_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_vpe_clk, VPE_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_adm_clk, ADM_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_ce_clk, CE_CLK, CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_axi_rotator_clk, AXI_ROTATOR_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(p_rotator_imem_clk, ROTATOR_IMEM_CLK, 0);
+static DEFINE_CLK_PCOM(p_rotator_p_clk, ROTATOR_P_CLK, 0);
 
 static struct pcom_clk pbus_clk = {
 	.id = P_PBUS_CLK,
diff --git a/arch/arm/mach-msm/clock-8960.c b/arch/arm/mach-msm/clock-8960.c
index 6ecc5d5..d885644 100644
--- a/arch/arm/mach-msm/clock-8960.c
+++ b/arch/arm/mach-msm/clock-8960.c
@@ -438,7 +438,6 @@ static struct branch_clk gmem_axi_clk = {
 	.c = {
 		.dbg_name = "gmem_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gmem_axi_clk.c),
 	},
 };
@@ -455,7 +454,6 @@ static struct branch_clk ijpeg_axi_clk = {
 	.c = {
 		.dbg_name = "ijpeg_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ijpeg_axi_clk.c),
 	},
 };
@@ -472,7 +470,6 @@ static struct branch_clk imem_axi_clk = {
 	.c = {
 		.dbg_name = "imem_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(imem_axi_clk.c),
 	},
 };
@@ -487,7 +484,6 @@ static struct branch_clk jpegd_axi_clk = {
 	.c = {
 		.dbg_name = "jpegd_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(jpegd_axi_clk.c),
 	},
 };
@@ -502,7 +498,6 @@ static struct branch_clk vcodec_axi_b_clk = {
 	.c = {
 		.dbg_name = "vcodec_axi_b_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vcodec_axi_b_clk.c),
 	},
 };
@@ -518,7 +513,6 @@ static struct branch_clk vcodec_axi_a_clk = {
 	.c = {
 		.dbg_name = "vcodec_axi_a_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vcodec_axi_a_clk.c),
 	},
 };
@@ -536,7 +530,6 @@ static struct branch_clk vcodec_axi_clk = {
 	.c = {
 		.dbg_name = "vcodec_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vcodec_axi_clk.c),
 	},
 };
@@ -553,7 +546,6 @@ static struct branch_clk vfe_axi_clk = {
 	.c = {
 		.dbg_name = "vfe_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vfe_axi_clk.c),
 	},
 };
@@ -620,7 +612,6 @@ static struct branch_clk amp_p_clk = {
 	.c = {
 		.dbg_name = "amp_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(amp_p_clk.c),
 	},
 };
@@ -637,7 +628,6 @@ static struct branch_clk csi0_p_clk = {
 	.c = {
 		.dbg_name = "csi0_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0_p_clk.c),
 	},
 };
@@ -654,7 +644,6 @@ static struct branch_clk dsi1_m_p_clk = {
 	.c = {
 		.dbg_name = "dsi1_m_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi1_m_p_clk.c),
 	},
 };
@@ -671,7 +660,6 @@ static struct branch_clk dsi1_s_p_clk = {
 	.c = {
 		.dbg_name = "dsi1_s_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi1_s_p_clk.c),
 	},
 };
@@ -688,7 +676,6 @@ static struct branch_clk dsi2_m_p_clk = {
 	.c = {
 		.dbg_name = "dsi2_m_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi2_m_p_clk.c),
 	},
 };
@@ -705,7 +692,6 @@ static struct branch_clk dsi2_s_p_clk = {
 	.c = {
 		.dbg_name = "dsi2_s_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi2_s_p_clk.c),
 	},
 };
@@ -722,7 +708,6 @@ static struct branch_clk gfx2d0_p_clk = {
 	.c = {
 		.dbg_name = "gfx2d0_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx2d0_p_clk.c),
 	},
 };
@@ -739,7 +724,6 @@ static struct branch_clk gfx2d1_p_clk = {
 	.c = {
 		.dbg_name = "gfx2d1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx2d1_p_clk.c),
 	},
 };
@@ -756,7 +740,6 @@ static struct branch_clk gfx3d_p_clk = {
 	.c = {
 		.dbg_name = "gfx3d_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx3d_p_clk.c),
 	},
 };
@@ -773,7 +756,6 @@ static struct branch_clk hdmi_m_p_clk = {
 	.c = {
 		.dbg_name = "hdmi_m_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(hdmi_m_p_clk.c),
 	},
 };
@@ -790,7 +772,6 @@ static struct branch_clk hdmi_s_p_clk = {
 	.c = {
 		.dbg_name = "hdmi_s_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(hdmi_s_p_clk.c),
 	},
 };
@@ -807,7 +788,6 @@ static struct branch_clk ijpeg_p_clk = {
 	.c = {
 		.dbg_name = "ijpeg_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ijpeg_p_clk.c),
 	},
 };
@@ -824,7 +804,6 @@ static struct branch_clk imem_p_clk = {
 	.c = {
 		.dbg_name = "imem_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(imem_p_clk.c),
 	},
 };
@@ -841,7 +820,6 @@ static struct branch_clk jpegd_p_clk = {
 	.c = {
 		.dbg_name = "jpegd_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(jpegd_p_clk.c),
 	},
 };
@@ -858,7 +836,6 @@ static struct branch_clk mdp_p_clk = {
 	.c = {
 		.dbg_name = "mdp_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_p_clk.c),
 	},
 };
@@ -875,7 +852,6 @@ static struct branch_clk rot_p_clk = {
 	.c = {
 		.dbg_name = "rot_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(rot_p_clk.c),
 	},
 };
@@ -890,7 +866,6 @@ static struct branch_clk smmu_p_clk = {
 	.c = {
 		.dbg_name = "smmu_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(smmu_p_clk.c),
 	},
 };
@@ -907,7 +882,6 @@ static struct branch_clk tv_enc_p_clk = {
 	.c = {
 		.dbg_name = "tv_enc_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tv_enc_p_clk.c),
 	},
 };
@@ -924,7 +898,6 @@ static struct branch_clk vcodec_p_clk = {
 	.c = {
 		.dbg_name = "vcodec_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vcodec_p_clk.c),
 	},
 };
@@ -941,7 +914,6 @@ static struct branch_clk vfe_p_clk = {
 	.c = {
 		.dbg_name = "vfe_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vfe_p_clk.c),
 	},
 };
@@ -958,7 +930,6 @@ static struct branch_clk vpe_p_clk = {
 	.c = {
 		.dbg_name = "vpe_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vpe_p_clk.c),
 	},
 };
@@ -986,7 +957,6 @@ static struct branch_clk vpe_p_clk = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -1051,7 +1021,6 @@ static CLK_GSBI_UART(gsbi12_uart, 12, CLK_HALT_CFPB_STATEC_REG, 13);
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -1122,7 +1091,6 @@ static struct rcg_clk pdm_clk = {
 	.c = {
 		.dbg_name = "pdm_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pdm_clk.c),
 	},
 };
@@ -1137,7 +1105,6 @@ static struct branch_clk pmem_clk = {
 	.c = {
 		.dbg_name = "pmem_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pmem_clk.c),
 	},
 };
@@ -1167,7 +1134,6 @@ static struct rcg_clk prng_clk = {
 	.c = {
 		.dbg_name = "prng_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(prng_clk.c),
 	},
 };
@@ -1193,7 +1159,6 @@ static struct rcg_clk prng_clk = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -1259,7 +1224,6 @@ static struct rcg_clk tsif_ref_clk = {
 	.c = {
 		.dbg_name = "tsif_ref_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tsif_ref_clk.c),
 	},
 };
@@ -1292,7 +1256,6 @@ static struct rcg_clk tssc_clk = {
 	.c = {
 		.dbg_name = "tssc_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tssc_clk.c),
 	},
 };
@@ -1331,7 +1294,6 @@ static struct rcg_clk usb_hs1_xcvr_clk = {
 	.c = {
 		.dbg_name = "usb_hs1_xcvr_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_hs1_xcvr_clk.c),
 	},
 };
@@ -1364,7 +1326,6 @@ static struct branch_clk usb_phy0_clk = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -1383,7 +1344,6 @@ static struct branch_clk usb_fs1_xcvr_clk = {
 	.c = {
 		.dbg_name = "usb_fs1_xcvr_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs1_xcvr_clk.c),
 	},
 };
@@ -1401,7 +1361,6 @@ static struct branch_clk usb_fs1_sys_clk = {
 	.c = {
 		.dbg_name = "usb_fs1_sys_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs1_sys_clk.c),
 	},
 };
@@ -1420,7 +1379,6 @@ static struct branch_clk usb_fs2_xcvr_clk = {
 	.c = {
 		.dbg_name = "usb_fs2_xcvr_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs2_xcvr_clk.c),
 	},
 };
@@ -1438,7 +1396,6 @@ static struct branch_clk usb_fs2_sys_clk = {
 	.c = {
 		.dbg_name = "usb_fs2_sys_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs2_sys_clk.c),
 	},
 };
@@ -1454,7 +1411,6 @@ static struct branch_clk ce1_core_clk = {
 	.c = {
 		.dbg_name = "ce1_core_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ce1_core_clk.c),
 	},
 };
@@ -1468,7 +1424,6 @@ static struct branch_clk ce1_p_clk = {
 	.c = {
 		.dbg_name = "ce1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ce1_p_clk.c),
 	},
 };
@@ -1483,7 +1438,6 @@ static struct branch_clk dma_bam_p_clk = {
 	.c = {
 		.dbg_name = "dma_bam_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dma_bam_p_clk.c),
 	},
 };
@@ -1498,7 +1452,6 @@ static struct branch_clk gsbi1_p_clk = {
 	.c = {
 		.dbg_name = "gsbi1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi1_p_clk.c),
 	},
 };
@@ -1513,7 +1466,6 @@ static struct branch_clk gsbi2_p_clk = {
 	.c = {
 		.dbg_name = "gsbi2_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi2_p_clk.c),
 	},
 };
@@ -1528,7 +1480,6 @@ static struct branch_clk gsbi3_p_clk = {
 	.c = {
 		.dbg_name = "gsbi3_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi3_p_clk.c),
 	},
 };
@@ -1543,7 +1494,6 @@ static struct branch_clk gsbi4_p_clk = {
 	.c = {
 		.dbg_name = "gsbi4_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi4_p_clk.c),
 	},
 };
@@ -1558,7 +1508,6 @@ static struct branch_clk gsbi5_p_clk = {
 	.c = {
 		.dbg_name = "gsbi5_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi5_p_clk.c),
 	},
 };
@@ -1573,7 +1522,6 @@ static struct branch_clk gsbi6_p_clk = {
 	.c = {
 		.dbg_name = "gsbi6_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi6_p_clk.c),
 	},
 };
@@ -1588,7 +1536,6 @@ static struct branch_clk gsbi7_p_clk = {
 	.c = {
 		.dbg_name = "gsbi7_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi7_p_clk.c),
 	},
 };
@@ -1603,7 +1550,6 @@ static struct branch_clk gsbi8_p_clk = {
 	.c = {
 		.dbg_name = "gsbi8_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi8_p_clk.c),
 	},
 };
@@ -1618,7 +1564,6 @@ static struct branch_clk gsbi9_p_clk = {
 	.c = {
 		.dbg_name = "gsbi9_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi9_p_clk.c),
 	},
 };
@@ -1633,7 +1578,6 @@ static struct branch_clk gsbi10_p_clk = {
 	.c = {
 		.dbg_name = "gsbi10_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi10_p_clk.c),
 	},
 };
@@ -1648,7 +1592,6 @@ static struct branch_clk gsbi11_p_clk = {
 	.c = {
 		.dbg_name = "gsbi11_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi11_p_clk.c),
 	},
 };
@@ -1663,7 +1606,6 @@ static struct branch_clk gsbi12_p_clk = {
 	.c = {
 		.dbg_name = "gsbi12_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi12_p_clk.c),
 	},
 };
@@ -1678,7 +1620,6 @@ static struct branch_clk tsif_p_clk = {
 	.c = {
 		.dbg_name = "tsif_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tsif_p_clk.c),
 	},
 };
@@ -1693,7 +1634,6 @@ static struct branch_clk usb_fs1_p_clk = {
 	.c = {
 		.dbg_name = "usb_fs1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs1_p_clk.c),
 	},
 };
@@ -1708,7 +1648,6 @@ static struct branch_clk usb_fs2_p_clk = {
 	.c = {
 		.dbg_name = "usb_fs2_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs2_p_clk.c),
 	},
 };
@@ -1723,7 +1662,6 @@ static struct branch_clk usb_hs1_p_clk = {
 	.c = {
 		.dbg_name = "usb_hs1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_hs1_p_clk.c),
 	},
 };
@@ -1738,7 +1676,6 @@ static struct branch_clk sdc1_p_clk = {
 	.c = {
 		.dbg_name = "sdc1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc1_p_clk.c),
 	},
 };
@@ -1753,7 +1690,6 @@ static struct branch_clk sdc2_p_clk = {
 	.c = {
 		.dbg_name = "sdc2_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc2_p_clk.c),
 	},
 };
@@ -1768,7 +1704,6 @@ static struct branch_clk sdc3_p_clk = {
 	.c = {
 		.dbg_name = "sdc3_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc3_p_clk.c),
 	},
 };
@@ -1783,7 +1718,6 @@ static struct branch_clk sdc4_p_clk = {
 	.c = {
 		.dbg_name = "sdc4_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc4_p_clk.c),
 	},
 };
@@ -1798,7 +1732,6 @@ static struct branch_clk sdc5_p_clk = {
 	.c = {
 		.dbg_name = "sdc5_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc5_p_clk.c),
 	},
 };
@@ -1815,7 +1748,6 @@ static struct branch_clk adm0_clk = {
 	.c = {
 		.dbg_name = "adm0_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(adm0_clk.c),
 	},
 };
@@ -1831,7 +1763,6 @@ static struct branch_clk adm0_p_clk = {
 	.c = {
 		.dbg_name = "adm0_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(adm0_p_clk.c),
 	},
 };
@@ -1847,7 +1778,6 @@ static struct branch_clk pmic_arb0_p_clk = {
 	.c = {
 		.dbg_name = "pmic_arb0_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pmic_arb0_p_clk.c),
 	},
 };
@@ -1863,7 +1793,6 @@ static struct branch_clk pmic_arb1_p_clk = {
 	.c = {
 		.dbg_name = "pmic_arb1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pmic_arb1_p_clk.c),
 	},
 };
@@ -1879,7 +1808,6 @@ static struct branch_clk pmic_ssbi2_clk = {
 	.c = {
 		.dbg_name = "pmic_ssbi2_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pmic_ssbi2_clk.c),
 	},
 };
@@ -1895,7 +1823,6 @@ static struct branch_clk rpm_msg_ram_p_clk = {
 	.c = {
 		.dbg_name = "rpm_msg_ram_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(rpm_msg_ram_p_clk.c),
 	},
 };
@@ -1935,7 +1862,6 @@ static struct branch_clk amp_clk = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -2001,7 +1927,6 @@ static struct rcg_clk csi0_src_clk = {
 	.c = {
 		.dbg_name = "csi0_src_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0_src_clk.c),
 	},
 };
@@ -2019,7 +1944,6 @@ static struct branch_clk csi0_clk = {
 	.c = {
 		.dbg_name = "csi0_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0_clk.c),
 	},
 };
@@ -2037,7 +1961,6 @@ static struct branch_clk csi0_phy_clk = {
 	.c = {
 		.dbg_name = "csi0_phy_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0_phy_clk.c),
 	},
 };
@@ -2058,7 +1981,6 @@ static struct rcg_clk csi1_src_clk = {
 	.c = {
 		.dbg_name = "csi1_src_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi1_src_clk.c),
 	},
 };
@@ -2076,7 +1998,6 @@ static struct branch_clk csi1_clk = {
 	.c = {
 		.dbg_name = "csi1_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi1_clk.c),
 	},
 };
@@ -2094,7 +2015,6 @@ static struct branch_clk csi1_phy_clk = {
 	.c = {
 		.dbg_name = "csi1_phy_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi1_phy_clk.c),
 	},
 };
@@ -2139,7 +2059,6 @@ static struct rcg_clk csi_pix_clk = {
 	.c = {
 		.dbg_name = "csi_pix_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi_pix_clk.c),
 	},
 };
@@ -2160,7 +2079,6 @@ static struct rcg_clk csi_rdi_clk = {
 	.c = {
 		.dbg_name = "csi_rdi_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi_rdi_clk.c),
 	},
 };
@@ -2198,7 +2116,6 @@ static struct rcg_clk csiphy_timer_src_clk = {
 	.c = {
 		.dbg_name = "csiphy_timer_src_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csiphy_timer_src_clk.c),
 	},
 };
@@ -2214,7 +2131,6 @@ static struct branch_clk csi0phy_timer_clk = {
 	.c = {
 		.dbg_name = "csi0phy_timer_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0phy_timer_clk.c),
 	},
 };
@@ -2230,7 +2146,6 @@ static struct branch_clk csi1phy_timer_clk = {
 	.c = {
 		.dbg_name = "csi1phy_timer_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi1phy_timer_clk.c),
 	},
 };
@@ -2271,7 +2186,6 @@ static struct rcg_clk dsi1_byte_clk = {
 	.c = {
 		.dbg_name = "dsi1_byte_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi1_byte_clk.c),
 	},
 };
@@ -2294,7 +2208,6 @@ static struct rcg_clk dsi2_byte_clk = {
 	.c = {
 		.dbg_name = "dsi2_byte_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi2_byte_clk.c),
 	},
 };
@@ -2316,7 +2229,6 @@ static struct rcg_clk dsi1_esc_clk = {
 	.c = {
 		.dbg_name = "dsi1_esc_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi1_esc_clk.c),
 	},
 };
@@ -2337,7 +2249,6 @@ static struct rcg_clk dsi2_esc_clk = {
 	.c = {
 		.dbg_name = "dsi2_esc_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi2_esc_clk.c),
 	},
 };
@@ -2405,7 +2316,6 @@ static struct rcg_clk gfx2d0_clk = {
 	.c = {
 		.dbg_name = "gfx2d0_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx2d0_clk.c),
 	},
 };
@@ -2446,7 +2356,6 @@ static struct rcg_clk gfx2d1_clk = {
 	.c = {
 		.dbg_name = "gfx2d1_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx2d1_clk.c),
 	},
 };
@@ -2517,7 +2426,6 @@ static struct rcg_clk gfx3d_clk = {
 	.c = {
 		.dbg_name = "gfx3d_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx3d_clk.c),
 	},
 };
@@ -2567,7 +2475,6 @@ static struct rcg_clk ijpeg_clk = {
 	.c = {
 		.dbg_name = "ijpeg_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ijpeg_clk.c),
 	},
 };
@@ -2608,7 +2515,6 @@ static struct rcg_clk jpegd_clk = {
 	.c = {
 		.dbg_name = "jpegd_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(jpegd_clk.c),
 	},
 };
@@ -2679,7 +2585,6 @@ static struct rcg_clk mdp_clk = {
 	.c = {
 		.dbg_name = "mdp_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_clk.c),
 	},
 };
@@ -2695,7 +2600,6 @@ static struct branch_clk lut_mdp_clk = {
 	.c = {
 		.dbg_name = "lut_mdp_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(lut_mdp_clk.c),
 	},
 };
@@ -2729,7 +2633,6 @@ static struct rcg_clk mdp_vsync_clk = {
 	.c = {
 		.dbg_name = "mdp_vsync_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_vsync_clk.c),
 	},
 };
@@ -2789,7 +2692,6 @@ static struct rcg_clk rot_clk = {
 	.c = {
 		.dbg_name = "rot_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(rot_clk.c),
 	},
 };
@@ -2827,7 +2729,6 @@ static struct rcg_clk tv_src_clk = {
 	.c = {
 		.dbg_name = "tv_src_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tv_src_clk.c),
 	},
 };
@@ -2845,7 +2746,6 @@ static struct branch_clk tv_enc_clk = {
 	.c = {
 		.dbg_name = "tv_enc_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tv_enc_clk.c),
 	},
 };
@@ -2861,7 +2761,6 @@ static struct branch_clk tv_dac_clk = {
 	.c = {
 		.dbg_name = "tv_dac_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tv_dac_clk.c),
 	},
 };
@@ -2879,7 +2778,6 @@ static struct branch_clk mdp_tv_clk = {
 	.c = {
 		.dbg_name = "mdp_tv_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_tv_clk.c),
 	},
 };
@@ -2897,7 +2795,6 @@ static struct branch_clk hdmi_tv_clk = {
 	.c = {
 		.dbg_name = "hdmi_tv_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(hdmi_tv_clk.c),
 	},
 };
@@ -2914,7 +2811,6 @@ static struct branch_clk hdmi_app_clk = {
 	.c = {
 		.dbg_name = "hdmi_app_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(hdmi_app_clk.c),
 	},
 };
@@ -2978,7 +2874,6 @@ static struct rcg_clk vcodec_clk = {
 	.c = {
 		.dbg_name = "vcodec_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vcodec_clk.c),
 	},
 };
@@ -3022,7 +2917,6 @@ static struct rcg_clk vpe_clk = {
 	.c = {
 		.dbg_name = "vpe_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vpe_clk.c),
 	},
 };
@@ -3080,7 +2974,6 @@ static struct rcg_clk vfe_clk = {
 	.c = {
 		.dbg_name = "vfe_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vfe_clk.c),
 	},
 };
@@ -3098,7 +2991,6 @@ static struct branch_clk csi0_vfe_clk = {
 	.c = {
 		.dbg_name = "csi0_vfe_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0_vfe_clk.c),
 	},
 };
@@ -3151,7 +3043,6 @@ static struct clk_freq_tbl clk_tbl_aif_osr[] = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -3176,7 +3067,6 @@ static struct clk_freq_tbl clk_tbl_aif_osr[] = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -3211,7 +3101,6 @@ static struct clk_freq_tbl clk_tbl_aif_bit[] = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -3248,7 +3137,6 @@ static struct clk_freq_tbl clk_tbl_aif_bit_div[] = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8960, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -3322,7 +3210,6 @@ static struct rcg_clk pcm_clk = {
 	.c = {
 		.dbg_name = "pcm_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pcm_clk.c),
 	},
 };
@@ -3347,7 +3234,6 @@ static struct rcg_clk audio_slimbus_clk = {
 	.c = {
 		.dbg_name = "audio_slimbus_clk",
 		.ops = &soc_clk_ops_8960,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(audio_slimbus_clk.c),
 	},
 };
@@ -3364,7 +3250,6 @@ static struct branch_clk sps_slimbus_clk = {
 	.c = {
 		.dbg_name = "sps_slimbus_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sps_slimbus_clk.c),
 	},
 };
@@ -3381,7 +3266,6 @@ static struct branch_clk slimbus_xo_src_clk = {
 	.c = {
 		.dbg_name = "slimbus_xo_src_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(slimbus_xo_src_clk.c),
 	},
 };
diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 71e014d..4f999d2 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -503,7 +503,6 @@ static struct branch_clk gmem_axi_clk = {
 	.c = {
 		.dbg_name = "gmem_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gmem_axi_clk.c),
 	},
 };
@@ -520,7 +519,6 @@ static struct branch_clk ijpeg_axi_clk = {
 	.c = {
 		.dbg_name = "ijpeg_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ijpeg_axi_clk.c),
 	},
 };
@@ -537,7 +535,6 @@ static struct branch_clk imem_axi_clk = {
 	.c = {
 		.dbg_name = "imem_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(imem_axi_clk.c),
 	},
 };
@@ -552,7 +549,6 @@ static struct branch_clk jpegd_axi_clk = {
 	.c = {
 		.dbg_name = "jpegd_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(jpegd_axi_clk.c),
 	},
 };
@@ -569,7 +565,6 @@ static struct branch_clk mdp_axi_clk = {
 	.c = {
 		.dbg_name = "mdp_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_axi_clk.c),
 	},
 };
@@ -586,7 +581,6 @@ static struct branch_clk vcodec_axi_clk = {
 	.c = {
 		.dbg_name = "vcodec_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vcodec_axi_clk.c),
 	},
 };
@@ -603,7 +597,6 @@ static struct branch_clk vfe_axi_clk = {
 	.c = {
 		.dbg_name = "vfe_axi_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vfe_axi_clk.c),
 	},
 };
@@ -643,7 +636,6 @@ static struct branch_clk amp_p_clk = {
 	.c = {
 		.dbg_name = "amp_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(amp_p_clk.c),
 	},
 };
@@ -660,7 +652,6 @@ static struct branch_clk csi0_p_clk = {
 	.c = {
 		.dbg_name = "csi0_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0_p_clk.c),
 	},
 };
@@ -677,7 +668,6 @@ static struct branch_clk csi1_p_clk = {
 	.c = {
 		.dbg_name = "csi1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi1_p_clk.c),
 	},
 };
@@ -694,7 +684,6 @@ static struct branch_clk dsi_m_p_clk = {
 	.c = {
 		.dbg_name = "dsi_m_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi_m_p_clk.c),
 	},
 };
@@ -711,7 +700,6 @@ static struct branch_clk dsi_s_p_clk = {
 	.c = {
 		.dbg_name = "dsi_s_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi_s_p_clk.c),
 	},
 };
@@ -728,7 +716,6 @@ static struct branch_clk gfx2d0_p_clk = {
 	.c = {
 		.dbg_name = "gfx2d0_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx2d0_p_clk.c),
 	},
 };
@@ -745,7 +732,6 @@ static struct branch_clk gfx2d1_p_clk = {
 	.c = {
 		.dbg_name = "gfx2d1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx2d1_p_clk.c),
 	},
 };
@@ -762,7 +748,6 @@ static struct branch_clk gfx3d_p_clk = {
 	.c = {
 		.dbg_name = "gfx3d_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx3d_p_clk.c),
 	},
 };
@@ -779,7 +764,6 @@ static struct branch_clk hdmi_m_p_clk = {
 	.c = {
 		.dbg_name = "hdmi_m_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(hdmi_m_p_clk.c),
 	},
 };
@@ -796,7 +780,6 @@ static struct branch_clk hdmi_s_p_clk = {
 	.c = {
 		.dbg_name = "hdmi_s_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(hdmi_s_p_clk.c),
 	},
 };
@@ -813,7 +796,6 @@ static struct branch_clk ijpeg_p_clk = {
 	.c = {
 		.dbg_name = "ijpeg_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ijpeg_p_clk.c),
 	},
 };
@@ -830,7 +812,6 @@ static struct branch_clk imem_p_clk = {
 	.c = {
 		.dbg_name = "imem_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(imem_p_clk.c),
 	},
 };
@@ -847,7 +828,6 @@ static struct branch_clk jpegd_p_clk = {
 	.c = {
 		.dbg_name = "jpegd_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(jpegd_p_clk.c),
 	},
 };
@@ -864,7 +844,6 @@ static struct branch_clk mdp_p_clk = {
 	.c = {
 		.dbg_name = "mdp_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_p_clk.c),
 	},
 };
@@ -881,7 +860,6 @@ static struct branch_clk rot_p_clk = {
 	.c = {
 		.dbg_name = "rot_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(rot_p_clk.c),
 	},
 };
@@ -896,7 +874,6 @@ static struct branch_clk smmu_p_clk = {
 	.c = {
 		.dbg_name = "smmu_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(smmu_p_clk.c),
 	},
 };
@@ -913,7 +890,6 @@ static struct branch_clk tv_enc_p_clk = {
 	.c = {
 		.dbg_name = "tv_enc_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tv_enc_p_clk.c),
 	},
 };
@@ -930,7 +906,6 @@ static struct branch_clk vcodec_p_clk = {
 	.c = {
 		.dbg_name = "vcodec_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vcodec_p_clk.c),
 	},
 };
@@ -947,7 +922,6 @@ static struct branch_clk vfe_p_clk = {
 	.c = {
 		.dbg_name = "vfe_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vfe_p_clk.c),
 	},
 };
@@ -964,7 +938,6 @@ static struct branch_clk vpe_p_clk = {
 	.c = {
 		.dbg_name = "vpe_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vpe_p_clk.c),
 	},
 };
@@ -992,7 +965,6 @@ static struct branch_clk vpe_p_clk = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8x60, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -1057,7 +1029,6 @@ static CLK_GSBI_UART(gsbi12_uart, 12, CLK_HALT_CFPB_STATEC_REG, 13);
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8x60, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -1128,7 +1099,6 @@ static struct rcg_clk pdm_clk = {
 	.c = {
 		.dbg_name = "pdm_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pdm_clk.c),
 	},
 };
@@ -1143,7 +1113,6 @@ static struct branch_clk pmem_clk = {
 	.c = {
 		.dbg_name = "pmem_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pmem_clk.c),
 	},
 };
@@ -1173,7 +1142,6 @@ static struct rcg_clk prng_clk = {
 	.c = {
 		.dbg_name = "prng_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(prng_clk.c),
 	},
 };
@@ -1198,7 +1166,6 @@ static struct rcg_clk prng_clk = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8x60, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -1261,7 +1228,6 @@ static struct rcg_clk tsif_ref_clk = {
 	.c = {
 		.dbg_name = "tsif_ref_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tsif_ref_clk.c),
 	},
 };
@@ -1294,7 +1260,6 @@ static struct rcg_clk tssc_clk = {
 	.c = {
 		.dbg_name = "tssc_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tssc_clk.c),
 	},
 };
@@ -1333,7 +1298,6 @@ static struct rcg_clk usb_hs1_xcvr_clk = {
 	.c = {
 		.dbg_name = "usb_hs1_xcvr_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_hs1_xcvr_clk.c),
 	},
 };
@@ -1366,7 +1330,6 @@ static struct branch_clk usb_phy0_clk = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8x60, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -1385,7 +1348,6 @@ static struct branch_clk usb_fs1_xcvr_clk = {
 	.c = {
 		.dbg_name = "usb_fs1_xcvr_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs1_xcvr_clk.c),
 	},
 };
@@ -1403,7 +1365,6 @@ static struct branch_clk usb_fs1_sys_clk = {
 	.c = {
 		.dbg_name = "usb_fs1_sys_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs1_sys_clk.c),
 	},
 };
@@ -1422,7 +1383,6 @@ static struct branch_clk usb_fs2_xcvr_clk = {
 	.c = {
 		.dbg_name = "usb_fs2_xcvr_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs2_xcvr_clk.c),
 	},
 };
@@ -1440,7 +1400,6 @@ static struct branch_clk usb_fs2_sys_clk = {
 	.c = {
 		.dbg_name = "usb_fs2_sys_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs2_sys_clk.c),
 	},
 };
@@ -1457,7 +1416,6 @@ static struct branch_clk ce2_p_clk = {
 	.c = {
 		.dbg_name = "ce2_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ce2_p_clk.c),
 	},
 };
@@ -1472,7 +1430,6 @@ static struct branch_clk gsbi1_p_clk = {
 	.c = {
 		.dbg_name = "gsbi1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi1_p_clk.c),
 	},
 };
@@ -1487,7 +1444,6 @@ static struct branch_clk gsbi2_p_clk = {
 	.c = {
 		.dbg_name = "gsbi2_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi2_p_clk.c),
 	},
 };
@@ -1502,7 +1458,6 @@ static struct branch_clk gsbi3_p_clk = {
 	.c = {
 		.dbg_name = "gsbi3_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi3_p_clk.c),
 	},
 };
@@ -1517,7 +1472,6 @@ static struct branch_clk gsbi4_p_clk = {
 	.c = {
 		.dbg_name = "gsbi4_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi4_p_clk.c),
 	},
 };
@@ -1532,7 +1486,6 @@ static struct branch_clk gsbi5_p_clk = {
 	.c = {
 		.dbg_name = "gsbi5_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi5_p_clk.c),
 	},
 };
@@ -1547,7 +1500,6 @@ static struct branch_clk gsbi6_p_clk = {
 	.c = {
 		.dbg_name = "gsbi6_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi6_p_clk.c),
 	},
 };
@@ -1562,7 +1514,6 @@ static struct branch_clk gsbi7_p_clk = {
 	.c = {
 		.dbg_name = "gsbi7_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi7_p_clk.c),
 	},
 };
@@ -1577,7 +1528,6 @@ static struct branch_clk gsbi8_p_clk = {
 	.c = {
 		.dbg_name = "gsbi8_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi8_p_clk.c),
 	},
 };
@@ -1592,7 +1542,6 @@ static struct branch_clk gsbi9_p_clk = {
 	.c = {
 		.dbg_name = "gsbi9_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi9_p_clk.c),
 	},
 };
@@ -1607,7 +1556,6 @@ static struct branch_clk gsbi10_p_clk = {
 	.c = {
 		.dbg_name = "gsbi10_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi10_p_clk.c),
 	},
 };
@@ -1622,7 +1570,6 @@ static struct branch_clk gsbi11_p_clk = {
 	.c = {
 		.dbg_name = "gsbi11_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi11_p_clk.c),
 	},
 };
@@ -1637,7 +1584,6 @@ static struct branch_clk gsbi12_p_clk = {
 	.c = {
 		.dbg_name = "gsbi12_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gsbi12_p_clk.c),
 	},
 };
@@ -1652,7 +1598,6 @@ static struct branch_clk ppss_p_clk = {
 	.c = {
 		.dbg_name = "ppss_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ppss_p_clk.c),
 	},
 };
@@ -1667,7 +1612,6 @@ static struct branch_clk tsif_p_clk = {
 	.c = {
 		.dbg_name = "tsif_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tsif_p_clk.c),
 	},
 };
@@ -1682,7 +1626,6 @@ static struct branch_clk usb_fs1_p_clk = {
 	.c = {
 		.dbg_name = "usb_fs1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs1_p_clk.c),
 	},
 };
@@ -1697,7 +1640,6 @@ static struct branch_clk usb_fs2_p_clk = {
 	.c = {
 		.dbg_name = "usb_fs2_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_fs2_p_clk.c),
 	},
 };
@@ -1712,7 +1654,6 @@ static struct branch_clk usb_hs1_p_clk = {
 	.c = {
 		.dbg_name = "usb_hs1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(usb_hs1_p_clk.c),
 	},
 };
@@ -1727,7 +1668,6 @@ static struct branch_clk sdc1_p_clk = {
 	.c = {
 		.dbg_name = "sdc1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc1_p_clk.c),
 	},
 };
@@ -1742,7 +1682,6 @@ static struct branch_clk sdc2_p_clk = {
 	.c = {
 		.dbg_name = "sdc2_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc2_p_clk.c),
 	},
 };
@@ -1757,7 +1696,6 @@ static struct branch_clk sdc3_p_clk = {
 	.c = {
 		.dbg_name = "sdc3_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc3_p_clk.c),
 	},
 };
@@ -1772,7 +1710,6 @@ static struct branch_clk sdc4_p_clk = {
 	.c = {
 		.dbg_name = "sdc4_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc4_p_clk.c),
 	},
 };
@@ -1787,7 +1724,6 @@ static struct branch_clk sdc5_p_clk = {
 	.c = {
 		.dbg_name = "sdc5_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(sdc5_p_clk.c),
 	},
 };
@@ -1805,7 +1741,6 @@ static struct branch_clk adm0_clk = {
 	.c = {
 		.dbg_name = "adm0_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(adm0_clk.c),
 	},
 };
@@ -1821,7 +1756,6 @@ static struct branch_clk adm0_p_clk = {
 	.c = {
 		.dbg_name = "adm0_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(adm0_p_clk.c),
 	},
 };
@@ -1838,7 +1772,6 @@ static struct branch_clk adm1_clk = {
 	.c = {
 		.dbg_name = "adm1_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(adm1_clk.c),
 	},
 };
@@ -1854,7 +1787,6 @@ static struct branch_clk adm1_p_clk = {
 	.c = {
 		.dbg_name = "adm1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(adm1_p_clk.c),
 	},
 };
@@ -1870,7 +1802,6 @@ static struct branch_clk modem_ahb1_p_clk = {
 	.c = {
 		.dbg_name = "modem_ahb1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(modem_ahb1_p_clk.c),
 	},
 };
@@ -1886,7 +1817,6 @@ static struct branch_clk modem_ahb2_p_clk = {
 	.c = {
 		.dbg_name = "modem_ahb2_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(modem_ahb2_p_clk.c),
 	},
 };
@@ -1902,7 +1832,6 @@ static struct branch_clk pmic_arb0_p_clk = {
 	.c = {
 		.dbg_name = "pmic_arb0_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pmic_arb0_p_clk.c),
 	},
 };
@@ -1918,7 +1847,6 @@ static struct branch_clk pmic_arb1_p_clk = {
 	.c = {
 		.dbg_name = "pmic_arb1_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pmic_arb1_p_clk.c),
 	},
 };
@@ -1934,7 +1862,6 @@ static struct branch_clk pmic_ssbi2_clk = {
 	.c = {
 		.dbg_name = "pmic_ssbi2_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pmic_ssbi2_clk.c),
 	},
 };
@@ -1950,7 +1877,6 @@ static struct branch_clk rpm_msg_ram_p_clk = {
 	.c = {
 		.dbg_name = "rpm_msg_ram_p_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(rpm_msg_ram_p_clk.c),
 	},
 };
@@ -2014,7 +1940,6 @@ static struct rcg_clk cam_clk = {
 	.c = {
 		.dbg_name = "cam_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(cam_clk.c),
 	},
 };
@@ -2047,7 +1972,6 @@ static struct rcg_clk csi_src_clk = {
 	.c = {
 		.dbg_name = "csi_src_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi_src_clk.c),
 	},
 };
@@ -2065,7 +1989,6 @@ static struct branch_clk csi0_clk = {
 	.c = {
 		.dbg_name = "csi0_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0_clk.c),
 	},
 };
@@ -2083,7 +2006,6 @@ static struct branch_clk csi1_clk = {
 	.c = {
 		.dbg_name = "csi1_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi1_clk.c),
 	},
 };
@@ -2121,7 +2043,6 @@ static struct rcg_clk dsi_byte_clk = {
 	.c = {
 		.dbg_name = "dsi_byte_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi_byte_clk.c),
 	},
 };
@@ -2136,7 +2057,6 @@ static struct branch_clk dsi_esc_clk = {
 	.c = {
 		.dbg_name = "dsi_esc_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(dsi_esc_clk.c),
 	},
 };
@@ -2204,7 +2124,6 @@ static struct rcg_clk gfx2d0_clk = {
 	.c = {
 		.dbg_name = "gfx2d0_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx2d0_clk.c),
 	},
 };
@@ -2245,7 +2164,6 @@ static struct rcg_clk gfx2d1_clk = {
 	.c = {
 		.dbg_name = "gfx2d1_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx2d1_clk.c),
 	},
 };
@@ -2316,7 +2234,6 @@ static struct rcg_clk gfx3d_clk = {
 	.c = {
 		.dbg_name = "gfx3d_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(gfx3d_clk.c),
 	},
 };
@@ -2366,7 +2283,6 @@ static struct rcg_clk ijpeg_clk = {
 	.c = {
 		.dbg_name = "ijpeg_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(ijpeg_clk.c),
 	},
 };
@@ -2407,7 +2323,6 @@ static struct rcg_clk jpegd_clk = {
 	.c = {
 		.dbg_name = "jpegd_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(jpegd_clk.c),
 	},
 };
@@ -2478,7 +2393,6 @@ static struct rcg_clk mdp_clk = {
 	.c = {
 		.dbg_name = "mdp_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_clk.c),
 	},
 };
@@ -2512,7 +2426,6 @@ static struct rcg_clk mdp_vsync_clk = {
 	.c = {
 		.dbg_name = "mdp_vsync_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_vsync_clk.c),
 	},
 };
@@ -2563,7 +2476,6 @@ static struct rcg_clk pixel_mdp_clk = {
 	.c = {
 		.dbg_name = "pixel_mdp_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pixel_mdp_clk.c),
 	},
 };
@@ -2579,7 +2491,6 @@ static struct branch_clk pixel_lcdc_clk = {
 	.c = {
 		.dbg_name = "pixel_lcdc_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pixel_lcdc_clk.c),
 	},
 };
@@ -2638,7 +2549,6 @@ static struct rcg_clk rot_clk = {
 	.c = {
 		.dbg_name = "rot_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(rot_clk.c),
 	},
 };
@@ -2688,7 +2598,6 @@ static struct rcg_clk tv_src_clk = {
 	.c = {
 		.dbg_name = "tv_src_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tv_src_clk.c),
 	},
 };
@@ -2706,7 +2615,6 @@ static struct branch_clk tv_enc_clk = {
 	.c = {
 		.dbg_name = "tv_enc_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tv_enc_clk.c),
 	},
 };
@@ -2722,7 +2630,6 @@ static struct branch_clk tv_dac_clk = {
 	.c = {
 		.dbg_name = "tv_dac_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(tv_dac_clk.c),
 	},
 };
@@ -2740,7 +2647,6 @@ static struct branch_clk mdp_tv_clk = {
 	.c = {
 		.dbg_name = "mdp_tv_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(mdp_tv_clk.c),
 	},
 };
@@ -2758,7 +2664,6 @@ static struct branch_clk hdmi_tv_clk = {
 	.c = {
 		.dbg_name = "hdmi_tv_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(hdmi_tv_clk.c),
 	},
 };
@@ -2775,7 +2680,6 @@ static struct branch_clk hdmi_app_clk = {
 	.c = {
 		.dbg_name = "hdmi_app_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(hdmi_app_clk.c),
 	},
 };
@@ -2824,7 +2728,6 @@ static struct rcg_clk vcodec_clk = {
 	.c = {
 		.dbg_name = "vcodec_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vcodec_clk.c),
 	},
 };
@@ -2868,7 +2771,6 @@ static struct rcg_clk vpe_clk = {
 	.c = {
 		.dbg_name = "vpe_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vpe_clk.c),
 	},
 };
@@ -2925,7 +2827,6 @@ static struct rcg_clk vfe_clk = {
 	.c = {
 		.dbg_name = "vfe_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(vfe_clk.c),
 	},
 };
@@ -2943,7 +2844,6 @@ static struct branch_clk csi0_vfe_clk = {
 	.c = {
 		.dbg_name = "csi0_vfe_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi0_vfe_clk.c),
 	},
 };
@@ -2961,7 +2861,6 @@ static struct branch_clk csi1_vfe_clk = {
 	.c = {
 		.dbg_name = "csi1_vfe_clk",
 		.ops = &clk_ops_branch,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(csi1_vfe_clk.c),
 	},
 };
@@ -3014,7 +2913,6 @@ static struct clk_freq_tbl clk_tbl_aif_osr[] = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8x60, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -3049,7 +2947,6 @@ static struct clk_freq_tbl clk_tbl_aif_bit[] = {
 		.c = { \
 			.dbg_name = #i "_clk", \
 			.ops = &soc_clk_ops_8x60, \
-			.flags = CLKFLAG_AUTO_OFF, \
 			CLK_INIT(i##_clk.c), \
 		}, \
 	}
@@ -3123,7 +3020,6 @@ static struct rcg_clk pcm_clk = {
 	.c = {
 		.dbg_name = "pcm_clk",
 		.ops = &soc_clk_ops_8x60,
-		.flags = CLKFLAG_AUTO_OFF,
 		CLK_INIT(pcm_clk.c),
 	},
 };
diff --git a/arch/arm/mach-msm/clock-pcom-lookup.c b/arch/arm/mach-msm/clock-pcom-lookup.c
new file mode 100644
index 0000000..22f8145
--- /dev/null
+++ b/arch/arm/mach-msm/clock-pcom-lookup.c
@@ -0,0 +1,381 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "clock.h"
+#include "clock-pcom.h"
+#include "clock-voter.h"
+
+static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(adsp_clk,	ADSP_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(ahb_m_clk,	AHB_M_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(ahb_s_clk,	AHB_S_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(cam_m_clk,	CAM_M_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(axi_rotator_clk,	AXI_ROTATOR_CLK, 0);
+static DEFINE_CLK_PCOM(ce_clk,		CE_CLK,		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(csi0_clk,	CSI0_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(csi0_p_clk,	CSI0_P_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(csi0_vfe_clk,	CSI0_VFE_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(csi1_clk,	CSI1_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(csi1_p_clk,	CSI1_P_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(csi1_vfe_clk,	CSI1_VFE_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+
+static struct pcom_clk dsi_byte_clk = {
+	.id = P_DSI_BYTE_CLK,
+	.c = {
+		.ops = &clk_ops_pcom_ext_config,
+		.dbg_name = "dsi_byte_clk",
+		CLK_INIT(dsi_byte_clk.c),
+	},
+};
+
+static struct pcom_clk dsi_clk = {
+	.id = P_DSI_CLK,
+	.c = {
+		.ops = &clk_ops_pcom_ext_config,
+		.dbg_name = "dsi_clk",
+		CLK_INIT(dsi_clk.c),
+	},
+};
+
+static struct pcom_clk dsi_esc_clk = {
+	.id = P_DSI_ESC_CLK,
+	.c = {
+		.ops = &clk_ops_pcom_ext_config,
+		.dbg_name = "dsi_esc_clk",
+		CLK_INIT(dsi_esc_clk.c),
+	},
+};
+
+static struct pcom_clk dsi_pixel_clk = {
+	.id = P_DSI_PIXEL_CLK,
+	.c = {
+		.ops = &clk_ops_pcom_ext_config,
+		.dbg_name = "dsi_pixel_clk",
+		CLK_INIT(dsi_pixel_clk.c),
+	},
+};
+
+static DEFINE_CLK_PCOM(dsi_ref_clk,	DSI_REF_CLK,	0);
+static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,
+		CLKFLAG_SKIP_AUTO_OFF | CLK_MIN);
+static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(grp_2d_clk,	GRP_2D_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(grp_2d_p_clk,	GRP_2D_P_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,	0);
+static DEFINE_CLK_PCOM(grp_3d_p_clk,	GRP_3D_P_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(gsbi1_qup_clk,	GSBI1_QUP_CLK,	0);
+static DEFINE_CLK_PCOM(gsbi1_qup_p_clk,	GSBI1_QUP_P_CLK, 0);
+static DEFINE_CLK_PCOM(gsbi2_qup_clk,	GSBI2_QUP_CLK,	0);
+static DEFINE_CLK_PCOM(gsbi2_qup_p_clk,	GSBI2_QUP_P_CLK, 0);
+static DEFINE_CLK_PCOM(gsbi_clk,	GSBI_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(gsbi_p_clk,	GSBI_P_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(hdmi_clk,	HDMI_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(i2c_clk,		I2C_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(icodec_rx_clk,	ICODEC_RX_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(icodec_tx_clk,	ICODEC_TX_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,	0);
+static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	0);
+static DEFINE_CLK_PCOM(mdp_lcdc_pad_pclk_clk, MDP_LCDC_PAD_PCLK_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(mdp_lcdc_pclk_clk, MDP_LCDC_PCLK_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(mdp_vsync_clk,	MDP_VSYNC_CLK,	0);
+static DEFINE_CLK_PCOM(mdp_dsi_p_clk,	MDP_DSI_P_CLK,	0);
+static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,
+		CLKFLAG_SKIP_AUTO_OFF | CLK_MIN);
+static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	0);
+static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	0);
+static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc2_clk,	SDC2_CLK,	0);
+static DEFINE_CLK_PCOM(sdc2_p_clk,	SDC2_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc3_clk,	SDC3_CLK,	0);
+static DEFINE_CLK_PCOM(sdc3_p_clk,	SDC3_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc4_clk,	SDC4_CLK,	0);
+static DEFINE_CLK_PCOM(sdc4_p_clk,	SDC4_P_CLK,	0);
+static DEFINE_CLK_PCOM(spi_clk,		SPI_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tsif_clk,	TSIF_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tsif_p_clk,	TSIF_P_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tsif_ref_clk,	TSIF_REF_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tv_dac_clk,	TV_DAC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tv_enc_clk,	TV_ENC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(uart1_clk,	UART1_CLK,	0);
+static DEFINE_CLK_PCOM(uart1dm_clk,	UART1DM_CLK,	0);
+static DEFINE_CLK_PCOM(uart2_clk,	UART2_CLK,	0);
+static DEFINE_CLK_PCOM(uart2dm_clk,	UART2DM_CLK,	0);
+static DEFINE_CLK_PCOM(uart3_clk,	UART3_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs2_clk,	USB_HS2_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs2_p_clk,	USB_HS2_P_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs3_clk,	USB_HS3_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs3_p_clk,	USB_HS3_P_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs_core_clk,	USB_HS_CORE_CLK, 0);
+static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	0);
+static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(usb_phy_clk,	USB_PHY_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	CLK_MIN);
+static DEFINE_CLK_PCOM(vfe_axi_clk,	VFE_AXI_CLK,	0);
+static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	0);
+static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	0);
+
+static DEFINE_CLK_VOTER(ebi_acpu_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi_kgsl_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi_lcdc_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi_mddi_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi_tv_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi_usb_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi_vfe_clk,	&ebi1_clk.c);
+
+struct clk_lookup msm_clocks_7x01a[] = {
+	CLK_LOOKUP("adm_clk",		adm_clk.c,	NULL),
+	CLK_LOOKUP("adsp_clk",		adsp_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_clk.c,	NULL),
+	CLK_LOOKUP("ebi2_clk",		ebi2_clk.c,	NULL),
+	CLK_LOOKUP("ecodec_clk",	ecodec_clk.c,	NULL),
+	CLK_LOOKUP("emdh_clk",		emdh_clk.c,	NULL),
+	CLK_LOOKUP("gp_clk",		gp_clk.c,		NULL),
+	CLK_LOOKUP("grp_clk",		grp_3d_clk.c,	NULL),
+	CLK_LOOKUP("i2c_clk",		i2c_clk.c,	"msm_i2c.0"),
+	CLK_LOOKUP("icodec_rx_clk",	icodec_rx_clk.c,	NULL),
+	CLK_LOOKUP("icodec_tx_clk",	icodec_tx_clk.c,	NULL),
+	CLK_LOOKUP("imem_clk",		imem_clk.c,	NULL),
+	CLK_LOOKUP("mdc_clk",		mdc_clk.c,	NULL),
+	CLK_LOOKUP("mddi_clk",		pmdh_clk.c,	NULL),
+	CLK_LOOKUP("mdp_clk",		mdp_clk.c,	NULL),
+	CLK_LOOKUP("pbus_clk",		pbus_clk.c,	NULL),
+	CLK_LOOKUP("pcm_clk",		pcm_clk.c,	NULL),
+	CLK_LOOKUP("sdac_clk",		sdac_clk.c,	NULL),
+	CLK_LOOKUP("sdc_clk",		sdc1_clk.c,	"msm_sdcc.1"),
+	CLK_LOOKUP("sdc_pclk",		sdc1_p_clk.c,	"msm_sdcc.1"),
+	CLK_LOOKUP("sdc_clk",		sdc2_clk.c,	"msm_sdcc.2"),
+	CLK_LOOKUP("sdc_pclk",		sdc2_p_clk.c,	"msm_sdcc.2"),
+	CLK_LOOKUP("sdc_clk",		sdc3_clk.c,	"msm_sdcc.3"),
+	CLK_LOOKUP("sdc_pclk",		sdc3_p_clk.c,	"msm_sdcc.3"),
+	CLK_LOOKUP("sdc_clk",		sdc4_clk.c,	"msm_sdcc.4"),
+	CLK_LOOKUP("sdc_pclk",		sdc4_p_clk.c,	"msm_sdcc.4"),
+	CLK_LOOKUP("tsif_clk",		tsif_clk.c,	NULL),
+	CLK_LOOKUP("tsif_ref_clk",	tsif_ref_clk.c,	NULL),
+	CLK_LOOKUP("tv_dac_clk",	tv_dac_clk.c,	NULL),
+	CLK_LOOKUP("tv_enc_clk",	tv_enc_clk.c,	NULL),
+	CLK_LOOKUP("uart_clk",		uart1_clk.c,	"msm_serial.0"),
+	CLK_LOOKUP("uart_clk",		uart2_clk.c,	"msm_serial.1"),
+	CLK_LOOKUP("uart_clk",		uart3_clk.c,	"msm_serial.2"),
+	CLK_LOOKUP("uartdm_clk",	uart1dm_clk.c,	"msm_serial_hs.0"),
+	CLK_LOOKUP("uartdm_clk",	uart2dm_clk.c,	"msm_serial_hs.1"),
+	CLK_LOOKUP("usb_hs_clk",	usb_hs_clk.c,	"msm_otg"),
+	CLK_LOOKUP("usb_hs_pclk",	usb_hs_p_clk.c,	"msm_otg"),
+	CLK_LOOKUP("usb_otg_clk",	usb_otg_clk.c,	NULL),
+	CLK_LOOKUP("vdc_clk",		vdc_clk.c,	NULL),
+	CLK_LOOKUP("vfe_clk",		vfe_clk.c,	NULL),
+	CLK_LOOKUP("vfe_mdc_clk",	vfe_mdc_clk.c,	NULL),
+};
+unsigned msm_num_clocks_7x01a = ARRAY_SIZE(msm_clocks_7x01a);
+
+struct clk_lookup msm_clocks_7x27[] = {
+	CLK_LOOKUP("adm_clk",		adm_clk.c,	NULL),
+	CLK_LOOKUP("adsp_clk",		adsp_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_clk.c,	NULL),
+	CLK_LOOKUP("ebi2_clk",		ebi2_clk.c,	NULL),
+	CLK_LOOKUP("ecodec_clk",	ecodec_clk.c,	NULL),
+	CLK_LOOKUP("gp_clk",		gp_clk.c,		NULL),
+	CLK_LOOKUP("grp_clk",		grp_3d_clk.c,	NULL),
+	CLK_LOOKUP("grp_pclk",		grp_3d_p_clk.c,	NULL),
+	CLK_LOOKUP("i2c_clk",		i2c_clk.c,	"msm_i2c.0"),
+	CLK_LOOKUP("icodec_rx_clk",	icodec_rx_clk.c,	NULL),
+	CLK_LOOKUP("icodec_tx_clk",	icodec_tx_clk.c,	NULL),
+	CLK_LOOKUP("imem_clk",		imem_clk.c,	NULL),
+	CLK_LOOKUP("mdc_clk",		mdc_clk.c,	NULL),
+	CLK_LOOKUP("mddi_clk",		pmdh_clk.c,	NULL),
+	CLK_LOOKUP("mdp_clk",		mdp_clk.c,	NULL),
+	CLK_LOOKUP("mdp_lcdc_pclk_clk", mdp_lcdc_pclk_clk.c, NULL),
+	CLK_LOOKUP("mdp_lcdc_pad_pclk_clk", mdp_lcdc_pad_pclk_clk.c, NULL),
+	CLK_LOOKUP("mdp_vsync_clk",	mdp_vsync_clk.c,  NULL),
+	CLK_LOOKUP("pbus_clk",		pbus_clk.c,	NULL),
+	CLK_LOOKUP("pcm_clk",		pcm_clk.c,	NULL),
+	CLK_LOOKUP("sdac_clk",		sdac_clk.c,	NULL),
+	CLK_LOOKUP("sdc_clk",		sdc1_clk.c,	"msm_sdcc.1"),
+	CLK_LOOKUP("sdc_pclk",		sdc1_p_clk.c,	"msm_sdcc.1"),
+	CLK_LOOKUP("sdc_clk",		sdc2_clk.c,	"msm_sdcc.2"),
+	CLK_LOOKUP("sdc_pclk",		sdc2_p_clk.c,	"msm_sdcc.2"),
+	CLK_LOOKUP("sdc_clk",		sdc3_clk.c,	"msm_sdcc.3"),
+	CLK_LOOKUP("sdc_pclk",		sdc3_p_clk.c,	"msm_sdcc.3"),
+	CLK_LOOKUP("sdc_clk",		sdc4_clk.c,	"msm_sdcc.4"),
+	CLK_LOOKUP("sdc_pclk",		sdc4_p_clk.c,	"msm_sdcc.4"),
+	CLK_LOOKUP("tsif_clk",		tsif_clk.c,	NULL),
+	CLK_LOOKUP("tsif_ref_clk",	tsif_ref_clk.c,	NULL),
+	CLK_LOOKUP("tsif_pclk",		tsif_p_clk.c,	NULL),
+	CLK_LOOKUP("uart_clk",		uart1_clk.c,	"msm_serial.0"),
+	CLK_LOOKUP("uart_clk",		uart2_clk.c,	"msm_serial.1"),
+	CLK_LOOKUP("uartdm_clk",	uart1dm_clk.c,	"msm_serial_hs.0"),
+	CLK_LOOKUP("uartdm_clk",	uart2dm_clk.c,	"msm_serial_hs.1"),
+	CLK_LOOKUP("usb_hs_clk",	usb_hs_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs_pclk",	usb_hs_p_clk.c,	NULL),
+	CLK_LOOKUP("usb_otg_clk",	usb_otg_clk.c,	NULL),
+	CLK_LOOKUP("usb_phy_clk",	usb_phy_clk.c,	NULL),
+	CLK_LOOKUP("vdc_clk",		vdc_clk.c,	NULL),
+	CLK_LOOKUP("vfe_clk",		vfe_clk.c,	NULL),
+	CLK_LOOKUP("vfe_mdc_clk",	vfe_mdc_clk.c,	NULL),
+
+	CLK_LOOKUP("ebi1_acpu_clk",	ebi_acpu_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_kgsl_clk",	ebi_kgsl_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_lcdc_clk",	ebi_lcdc_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_mddi_clk",	ebi_mddi_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_usb_clk",	ebi_usb_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_vfe_clk",	ebi_vfe_clk.c,	NULL),
+};
+unsigned msm_num_clocks_7x27 = ARRAY_SIZE(msm_clocks_7x27);
+
+struct clk_lookup msm_clocks_7x27a[] = {
+	CLK_LOOKUP("adm_clk",		adm_clk.c,	NULL),
+	CLK_LOOKUP("adsp_clk",		adsp_clk.c,	NULL),
+	CLK_LOOKUP("ahb_m_clk",		ahb_m_clk.c,	NULL),
+	CLK_LOOKUP("ahb_s_clk",		ahb_s_clk.c,	NULL),
+	CLK_LOOKUP("cam_m_clk",		cam_m_clk.c,	NULL),
+	CLK_LOOKUP("csi_clk",		csi0_clk.c,	NULL),
+	CLK_LOOKUP("csi_pclk",		csi0_p_clk.c,	NULL),
+	CLK_LOOKUP("csi_vfe_clk",	csi0_vfe_clk.c,	NULL),
+	CLK_LOOKUP("csi_clk",		csi1_clk.c,	NULL),
+	CLK_LOOKUP("csi_pclk",		csi1_p_clk.c,	NULL),
+	CLK_LOOKUP("csi_vfe_clk",	csi1_vfe_clk.c,	NULL),
+	CLK_LOOKUP("dsi_byte_clk",	dsi_byte_clk.c,	NULL),
+	CLK_LOOKUP("dsi_clk",		dsi_clk.c,	NULL),
+	CLK_LOOKUP("dsi_esc_clk",	dsi_esc_clk.c,	NULL),
+	CLK_LOOKUP("dsi_pixel_clk",	dsi_pixel_clk.c, NULL),
+	CLK_LOOKUP("dsi_ref_clk",	dsi_ref_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_clk.c,	NULL),
+	CLK_LOOKUP("ebi2_clk",		ebi2_clk.c,	NULL),
+	CLK_LOOKUP("ecodec_clk",	ecodec_clk.c,	NULL),
+	CLK_LOOKUP("gp_clk",		gp_clk.c,	NULL),
+	CLK_LOOKUP("grp_clk",		grp_3d_clk.c,	NULL),
+	CLK_LOOKUP("grp_pclk",		grp_3d_p_clk.c,	NULL),
+	CLK_LOOKUP("gsbi_qup_clk",	gsbi1_qup_clk.c, "qup_i2c.0"),
+	CLK_LOOKUP("gsbi_qup_clk",	gsbi2_qup_clk.c, "qup_i2c.1"),
+	CLK_LOOKUP("gsbi_qup_pclk",	gsbi1_qup_p_clk.c, "qup_i2c.0"),
+	CLK_LOOKUP("gsbi_qup_pclk",	gsbi2_qup_p_clk.c, "qup_i2c.1"),
+	CLK_LOOKUP("icodec_rx_clk",	icodec_rx_clk.c, NULL),
+	CLK_LOOKUP("icodec_tx_clk",	icodec_tx_clk.c, NULL),
+	CLK_LOOKUP("imem_clk",		imem_clk.c,	NULL),
+	CLK_LOOKUP("mddi_clk",		pmdh_clk.c,	NULL),
+	CLK_LOOKUP("mdp_clk",		mdp_clk.c,	NULL),
+	CLK_LOOKUP("mdp_lcdc_pclk_clk",	mdp_lcdc_pclk_clk.c, NULL),
+	CLK_LOOKUP("mdp_lcdc_pad_pclk_clk", mdp_lcdc_pad_pclk_clk.c, NULL),
+	CLK_LOOKUP("mdp_vsync_clk",	mdp_vsync_clk.c,	NULL),
+	CLK_LOOKUP("mdp_dsi_pclk",	mdp_dsi_p_clk.c,	NULL),
+	CLK_LOOKUP("pbus_clk",		pbus_clk.c,	NULL),
+	CLK_LOOKUP("pcm_clk",		pcm_clk.c,	NULL),
+	CLK_LOOKUP("sdac_clk",		sdac_clk.c,	NULL),
+	CLK_LOOKUP("sdc_clk",		sdc1_clk.c,	"msm_sdcc.1"),
+	CLK_LOOKUP("sdc_pclk",		sdc1_p_clk.c,	"msm_sdcc.1"),
+	CLK_LOOKUP("sdc_clk",		sdc2_clk.c,	"msm_sdcc.2"),
+	CLK_LOOKUP("sdc_pclk",		sdc2_p_clk.c,	"msm_sdcc.2"),
+	CLK_LOOKUP("sdc_clk",		sdc3_clk.c,	"msm_sdcc.3"),
+	CLK_LOOKUP("sdc_pclk",		sdc3_p_clk.c,	"msm_sdcc.3"),
+	CLK_LOOKUP("sdc_clk",		sdc4_clk.c,	"msm_sdcc.4"),
+	CLK_LOOKUP("sdc_pclk",		sdc4_p_clk.c,	"msm_sdcc.4"),
+	CLK_LOOKUP("tsif_ref_clk",	tsif_ref_clk.c,	NULL),
+	CLK_LOOKUP("tsif_pclk",		tsif_p_clk.c,	NULL),
+	CLK_LOOKUP("uart_clk",		uart1_clk.c,	"msm_serial.0"),
+	CLK_LOOKUP("uart_clk",		uart2_clk.c,	"msm_serial.1"),
+	CLK_LOOKUP("uartdm_clk",	uart1dm_clk.c,	"msm_serial_hs.0"),
+	CLK_LOOKUP("uartdm_clk",	uart2dm_clk.c,	"msm_serial_hsl.0"),
+	CLK_LOOKUP("usb_hs_core_clk",	usb_hs_core_clk.c, NULL),
+	CLK_LOOKUP("usb_hs2_clk",	usb_hs2_clk.c, NULL),
+	CLK_LOOKUP("usb_hs_clk",	usb_hs_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs_pclk",	usb_hs_p_clk.c,	NULL),
+	CLK_LOOKUP("usb_phy_clk",	usb_phy_clk.c,	NULL),
+	CLK_LOOKUP("vdc_clk",		vdc_clk.c,	NULL),
+	CLK_LOOKUP("vfe_clk",		vfe_clk.c,	NULL),
+	CLK_LOOKUP("vfe_mdc_clk",	vfe_mdc_clk.c,	NULL),
+
+	CLK_LOOKUP("ebi1_acpu_clk",	ebi_acpu_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_kgsl_clk",	ebi_kgsl_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_lcdc_clk",	ebi_lcdc_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_mddi_clk",	ebi_mddi_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_usb_clk",	ebi_usb_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_vfe_clk",	ebi_vfe_clk.c,	NULL),
+};
+unsigned msm_num_clocks_7x27a = ARRAY_SIZE(msm_clocks_7x27a);
+
+struct clk_lookup msm_clocks_8x50[] = {
+	CLK_LOOKUP("adm_clk",		adm_clk.c,	NULL),
+	CLK_LOOKUP("ce_clk",		ce_clk.c,		NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_clk.c,	NULL),
+	CLK_LOOKUP("ebi2_clk",		ebi2_clk.c,	NULL),
+	CLK_LOOKUP("ecodec_clk",	ecodec_clk.c,	NULL),
+	CLK_LOOKUP("emdh_clk",		emdh_clk.c,	NULL),
+	CLK_LOOKUP("gp_clk",		gp_clk.c,		NULL),
+	CLK_LOOKUP("grp_clk",		grp_3d_clk.c,	NULL),
+	CLK_LOOKUP("i2c_clk",		i2c_clk.c,	"msm_i2c.0"),
+	CLK_LOOKUP("icodec_rx_clk",	icodec_rx_clk.c,	NULL),
+	CLK_LOOKUP("icodec_tx_clk",	icodec_tx_clk.c,	NULL),
+	CLK_LOOKUP("imem_clk",		imem_clk.c,	NULL),
+	CLK_LOOKUP("mdc_clk",		mdc_clk.c,	NULL),
+	CLK_LOOKUP("mddi_clk",		pmdh_clk.c,	NULL),
+	CLK_LOOKUP("mdp_clk",		mdp_clk.c,	NULL),
+	CLK_LOOKUP("mdp_lcdc_pclk_clk", mdp_lcdc_pclk_clk.c, NULL),
+	CLK_LOOKUP("mdp_lcdc_pad_pclk_clk", mdp_lcdc_pad_pclk_clk.c, NULL),
+	CLK_LOOKUP("mdp_vsync_clk",	mdp_vsync_clk.c,	NULL),
+	CLK_LOOKUP("pbus_clk",		pbus_clk.c,	NULL),
+	CLK_LOOKUP("pcm_clk",		pcm_clk.c,	NULL),
+	CLK_LOOKUP("sdac_clk",		sdac_clk.c,	NULL),
+	CLK_LOOKUP("sdc_clk",		sdc1_clk.c,	"msm_sdcc.1"),
+	CLK_LOOKUP("sdc_pclk",		sdc1_p_clk.c,	"msm_sdcc.1"),
+	CLK_LOOKUP("sdc_clk",		sdc2_clk.c,	"msm_sdcc.2"),
+	CLK_LOOKUP("sdc_pclk",		sdc2_p_clk.c,	"msm_sdcc.2"),
+	CLK_LOOKUP("sdc_clk",		sdc3_clk.c,	"msm_sdcc.3"),
+	CLK_LOOKUP("sdc_pclk",		sdc3_p_clk.c,	"msm_sdcc.3"),
+	CLK_LOOKUP("sdc_clk",		sdc4_clk.c,	"msm_sdcc.4"),
+	CLK_LOOKUP("sdc_pclk",		sdc4_p_clk.c,	"msm_sdcc.4"),
+	CLK_LOOKUP("spi_clk",		spi_clk.c,	NULL),
+	CLK_DUMMY("spi_pclk",		SPI_P_CLK,	"spi_qsd.0", 0),
+	CLK_LOOKUP("tsif_clk",		tsif_clk.c,	NULL),
+	CLK_LOOKUP("tsif_ref_clk",	tsif_ref_clk.c,	NULL),
+	CLK_LOOKUP("tv_dac_clk",	tv_dac_clk.c,	NULL),
+	CLK_LOOKUP("tv_enc_clk",	tv_enc_clk.c,	NULL),
+	CLK_LOOKUP("uart_clk",		uart1_clk.c,	"msm_serial.0"),
+	CLK_LOOKUP("uart_clk",		uart2_clk.c,	"msm_serial.1"),
+	CLK_LOOKUP("uart_clk",		uart3_clk.c,	"msm_serial.2"),
+	CLK_LOOKUP("uartdm_clk",	uart1dm_clk.c,	"msm_serial_hs.0"),
+	CLK_LOOKUP("uartdm_clk",	uart2dm_clk.c,	"msm_serial_hs.1"),
+	CLK_LOOKUP("usb_hs_clk",	usb_hs_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs_pclk",	usb_hs_p_clk.c,	NULL),
+	CLK_LOOKUP("usb_otg_clk",	usb_otg_clk.c,	NULL),
+	CLK_LOOKUP("vdc_clk",		vdc_clk.c,	NULL),
+	CLK_LOOKUP("vfe_clk",		vfe_clk.c,	NULL),
+	CLK_LOOKUP("vfe_mdc_clk",	vfe_mdc_clk.c,	NULL),
+	CLK_LOOKUP("vfe_axi_clk",	vfe_axi_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs2_clk",	usb_hs2_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs2_pclk",	usb_hs2_p_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs3_clk",	usb_hs3_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs3_pclk",	usb_hs3_p_clk.c,	NULL),
+	CLK_LOOKUP("usb_phy_clk",	usb_phy_clk.c,	NULL),
+
+	CLK_LOOKUP("ebi1_acpu_clk",	ebi_acpu_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_kgsl_clk",	ebi_kgsl_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_lcdc_clk",	ebi_lcdc_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_mddi_clk",	ebi_mddi_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_tv_clk",	ebi_tv_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_usb_clk",	ebi_usb_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_vfe_clk",	ebi_vfe_clk.c,	NULL),
+
+	CLK_LOOKUP("grp_pclk",		grp_3d_p_clk.c,	NULL),
+	CLK_LOOKUP("grp_2d_clk",	grp_2d_clk.c,	NULL),
+	CLK_LOOKUP("grp_2d_pclk",	grp_2d_p_clk.c,	NULL),
+	CLK_LOOKUP("qup_clk",		gsbi_clk.c,	"qup_i2c.4"),
+	CLK_LOOKUP("qup_pclk",		gsbi_p_clk.c,	"qup_i2c.4"),
+};
+unsigned msm_num_clocks_8x50 = ARRAY_SIZE(msm_clocks_8x50);
diff --git a/arch/arm/mach-msm/clock-voter.h b/arch/arm/mach-msm/clock-voter.h
index 170ba67..8370c11 100644
--- a/arch/arm/mach-msm/clock-voter.h
+++ b/arch/arm/mach-msm/clock-voter.h
@@ -34,6 +34,7 @@ static inline struct clk_voter *to_clk_voter(struct clk *clk)
 		.c = { \
 			.dbg_name = #clk_name, \
 			.ops = &clk_ops_voter, \
+			.flags = CLKFLAG_SKIP_AUTO_OFF, \
 			CLK_INIT(clk_name.c), \
 		}, \
 	}
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 2781ccf..7daadb1 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -201,9 +201,10 @@ void __init msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks)
 	msm_num_clocks = num_clocks;
 }
 
-/* The bootloader and/or AMSS may have left various clocks enabled.
- * Disable any clocks that belong to us (CLKFLAG_AUTO_OFF) but have
- * not been explicitly enabled by a clk_enable() call.
+/*
+ * The bootloader and/or AMSS may have left various clocks enabled.
+ * Disable any clocks that have not been explicitly enabled by a
+ * clk_enable() call and don't have the CLKFLAG_SKIP_AUTO_OFF flag.
  */
 static int __init clock_late_init(void)
 {
@@ -215,9 +216,9 @@ static int __init clock_late_init(void)
 		struct clk *clk = msm_clocks[i].clk;
 
 		clock_debug_add(clk);
-		if (clk->flags & CLKFLAG_AUTO_OFF) {
+		if (!(clk->flags & CLKFLAG_SKIP_AUTO_OFF)) {
 			spin_lock_irqsave(&clk->lock, flags);
-			if (!clk->count) {
+			if (!clk->count && clk->ops->auto_off) {
 				count++;
 				clk->ops->auto_off(clk);
 			}
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 1d0c94b..09afadd 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -28,7 +28,7 @@
 #define CLKFLAG_NORESET			0x00000008
 
 #define CLK_FIRST_AVAILABLE_FLAG	0x00000100
-#define CLKFLAG_AUTO_OFF		0x00000200
+#define CLKFLAG_SKIP_AUTO_OFF			0x00000200
 #define CLKFLAG_MIN			0x00000400
 #define CLKFLAG_MAX			0x00000800
 
@@ -68,7 +68,6 @@ struct clk {
 	.children = LIST_HEAD_INIT((name).children), \
 	.siblings = LIST_HEAD_INIT((name).siblings)
 
-#define OFF CLKFLAG_AUTO_OFF
 #define CLK_MIN CLKFLAG_MIN
 #define CLK_MAX CLKFLAG_MAX
 #define CLK_MINMAX (CLK_MIN | CLK_MAX)
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index 1cef1e2..a7764bd 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -394,47 +394,47 @@ struct platform_device msm_device_mdp = {
 	.resource = resources_mdp,
 };
 
-static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,	0);
-static DEFINE_CLK_PCOM(adsp_clk,	ADSP_CLK,	0);
-static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,	0);
-static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	0);
-static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	0);
-static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	OFF);
-static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		0);
-static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,	OFF);
-static DEFINE_CLK_PCOM(i2c_clk,		I2C_CLK,	0);
-static DEFINE_CLK_PCOM(icodec_rx_clk,	ICODEC_RX_CLK,	0);
-static DEFINE_CLK_PCOM(icodec_tx_clk,	ICODEC_TX_CLK,	0);
-static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,	OFF);
-static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	0);
-static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	OFF);
-static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,	0);
-static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	0);
-static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	OFF | CLK_MINMAX);
-static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc2_clk,	SDC2_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc2_p_clk,	SDC2_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc3_clk,	SDC3_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc3_p_clk,	SDC3_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc4_clk,	SDC4_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc4_p_clk,	SDC4_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(tsif_clk,	TSIF_CLK,	0);
-static DEFINE_CLK_PCOM(tsif_ref_clk,	TSIF_REF_CLK,	0);
-static DEFINE_CLK_PCOM(tv_dac_clk,	TV_DAC_CLK,	0);
-static DEFINE_CLK_PCOM(tv_enc_clk,	TV_ENC_CLK,	0);
-static DEFINE_CLK_PCOM(uart1_clk,	UART1_CLK,	OFF);
-static DEFINE_CLK_PCOM(uart2_clk,	UART2_CLK,	0);
-static DEFINE_CLK_PCOM(uart3_clk,	UART3_CLK,	OFF);
-static DEFINE_CLK_PCOM(uart1dm_clk,	UART1DM_CLK,	OFF);
-static DEFINE_CLK_PCOM(uart2dm_clk,	UART2DM_CLK,	0);
-static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	0);
-static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	OFF);
-static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	OFF);
-static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	OFF);
+static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(adsp_clk,	ADSP_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	0);
+static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,	0);
+static DEFINE_CLK_PCOM(i2c_clk,		I2C_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(icodec_rx_clk,	ICODEC_RX_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(icodec_tx_clk,	ICODEC_TX_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,	0);
+static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	0);
+static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	0);
+static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	0);
+static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc2_clk,	SDC2_CLK,	0);
+static DEFINE_CLK_PCOM(sdc2_p_clk,	SDC2_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc3_clk,	SDC3_CLK,	0);
+static DEFINE_CLK_PCOM(sdc3_p_clk,	SDC3_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc4_clk,	SDC4_CLK,	0);
+static DEFINE_CLK_PCOM(sdc4_p_clk,	SDC4_P_CLK,	0);
+static DEFINE_CLK_PCOM(tsif_clk,	TSIF_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tsif_ref_clk,	TSIF_REF_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tv_dac_clk,	TV_DAC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tv_enc_clk,	TV_ENC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(uart1_clk,	UART1_CLK,	0);
+static DEFINE_CLK_PCOM(uart2_clk,	UART2_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(uart3_clk,	UART3_CLK,	0);
+static DEFINE_CLK_PCOM(uart1dm_clk,	UART1DM_CLK,	0);
+static DEFINE_CLK_PCOM(uart2dm_clk,	UART2DM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	0);
+static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	0);
+static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	0);
+static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	0);
 
 struct clk_lookup msm_clocks_7x01a[] = {
 	CLK_LOOKUP("adm_clk",		adm_clk.c,	"msm_dmov"),
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 21a1f3a..f4e65f0 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -292,57 +292,59 @@ int __init msm_add_sdcc(unsigned int controller,
 	return platform_device_register(pdev);
 }
 
-static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,	0);
-static DEFINE_CLK_PCOM(ce_clk,		CE_CLK,		0);
+static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(ce_clk,		CE_CLK,		CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,	CLK_MIN);
-static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	0);
-static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	0);
-static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	OFF | CLK_MINMAX);
-static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		0);
-static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,	0);
-static DEFINE_CLK_PCOM(i2c_clk,		I2C_CLK,	0);
-static DEFINE_CLK_PCOM(icodec_rx_clk,	ICODEC_RX_CLK,	0);
-static DEFINE_CLK_PCOM(icodec_tx_clk,	ICODEC_TX_CLK,	0);
-static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,	OFF);
-static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	0);
-static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	OFF | CLK_MINMAX);
-static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	OFF);
-static DEFINE_CLK_PCOM(mdp_lcdc_pclk_clk,	MDP_LCDC_PCLK_CLK, 0);
-static DEFINE_CLK_PCOM(mdp_lcdc_pad_pclk_clk,	MDP_LCDC_PAD_PCLK_CLK, 0);
-static DEFINE_CLK_PCOM(mdp_vsync_clk,	MDP_VSYNC_CLK,	0);
+static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(i2c_clk,		I2C_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(icodec_rx_clk,	ICODEC_RX_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(icodec_tx_clk,	ICODEC_TX_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,	0);
+static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	CLK_MINMAX);
+static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	0);
+static DEFINE_CLK_PCOM(mdp_lcdc_pclk_clk,	MDP_LCDC_PCLK_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(mdp_lcdc_pad_pclk_clk,	MDP_LCDC_PAD_PCLK_CLK,
+		CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(mdp_vsync_clk,	MDP_VSYNC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,	CLK_MIN);
-static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	0);
-static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc2_clk,	SDC2_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc2_p_clk,	SDC2_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc3_clk,	SDC3_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc3_p_clk,	SDC3_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc4_clk,	SDC4_CLK,	OFF);
-static DEFINE_CLK_PCOM(sdc4_p_clk,	SDC4_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(spi_clk,		SPI_CLK,	0);
-static DEFINE_CLK_PCOM(tsif_clk,	TSIF_CLK,	0);
-static DEFINE_CLK_PCOM(tsif_ref_clk,	TSIF_REF_CLK,	0);
-static DEFINE_CLK_PCOM(tv_dac_clk,	TV_DAC_CLK,	0);
-static DEFINE_CLK_PCOM(tv_enc_clk,	TV_ENC_CLK,	0);
-static DEFINE_CLK_PCOM(uart1_clk,	UART1_CLK,	OFF);
-static DEFINE_CLK_PCOM(uart2_clk,	UART2_CLK,	0);
-static DEFINE_CLK_PCOM(uart3_clk,	UART3_CLK,	OFF);
-static DEFINE_CLK_PCOM(uart1dm_clk,	UART1DM_CLK,	OFF);
-static DEFINE_CLK_PCOM(uart2dm_clk,	UART2DM_CLK,	0);
-static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	0);
-static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	OFF | CLK_MIN);
-static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	OFF);
-static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	OFF);
-static DEFINE_CLK_PCOM(vfe_axi_clk,	VFE_AXI_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_hs2_clk,	USB_HS2_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_hs2_p_clk,	USB_HS2_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_hs3_clk,	USB_HS3_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_hs3_p_clk,	USB_HS3_P_CLK,	OFF);
-static DEFINE_CLK_PCOM(usb_phy_clk,	USB_PHY_CLK,	0);
+static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	0);
+static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	0);
+static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc2_clk,	SDC2_CLK,	0);
+static DEFINE_CLK_PCOM(sdc2_p_clk,	SDC2_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc3_clk,	SDC3_CLK,	0);
+static DEFINE_CLK_PCOM(sdc3_p_clk,	SDC3_P_CLK,	0);
+static DEFINE_CLK_PCOM(sdc4_clk,	SDC4_CLK,	0);
+static DEFINE_CLK_PCOM(sdc4_p_clk,	SDC4_P_CLK,	0);
+static DEFINE_CLK_PCOM(spi_clk,		SPI_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tsif_clk,	TSIF_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tsif_ref_clk,	TSIF_REF_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tv_dac_clk,	TV_DAC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(tv_enc_clk,	TV_ENC_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(uart1_clk,	UART1_CLK,	0);
+static DEFINE_CLK_PCOM(uart2_clk,	UART2_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(uart3_clk,	UART3_CLK,	0);
+static DEFINE_CLK_PCOM(uart1dm_clk,	UART1DM_CLK,	0);
+static DEFINE_CLK_PCOM(uart2dm_clk,	UART2DM_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	0);
+static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	CLKFLAG_SKIP_AUTO_OFF);
+static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	CLK_MIN);
+static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	0);
+static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	0);
+static DEFINE_CLK_PCOM(vfe_axi_clk,	VFE_AXI_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs2_clk,	USB_HS2_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs2_p_clk,	USB_HS2_P_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs3_clk,	USB_HS3_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs3_p_clk,	USB_HS3_P_CLK,	0);
+static DEFINE_CLK_PCOM(usb_phy_clk,	USB_PHY_CLK,	CLKFLAG_SKIP_AUTO_OFF);
 
 static DEFINE_CLK_VOTER(ebi1_acpu_clk,	&ebi1_clk.c);
 static DEFINE_CLK_VOTER(ebi1_kgsl_clk,	&ebi1_clk.c);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

