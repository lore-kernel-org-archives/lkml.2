Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712Ab1KBSok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:44:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731Ab1KBSg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:36:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706950"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 05/34] msm: clock-pcom: Introduce a struct pcom_clk
Date: Wed,  2 Nov 2011 11:36:02 -0700
Message-Id: <1320258991-22325-6-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Move the unsigned id member out of struct clk since its only
really useful for proc_comm clocks. This means we have to define
all the struct clk's before hand, but we actually want to do this
so we can point voter clocks at the struct clk directly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.h      |   12 --
 arch/arm/mach-msm/clock-pcom.c      |   18 ++--
 arch/arm/mach-msm/clock-pcom.h      |   32 ++++--
 arch/arm/mach-msm/clock.h           |    2 +-
 arch/arm/mach-msm/devices-msm7x00.c |  124 ++++++++++++++-------
 arch/arm/mach-msm/devices-msm7x30.c |  213 +++++++++++++++++++++++------------
 arch/arm/mach-msm/devices-qsd8x50.c |  154 +++++++++++++++++---------
 7 files changed, 360 insertions(+), 195 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.h b/arch/arm/mach-msm/clock-7x30.h
index 1410445..3eaaee1 100644
--- a/arch/arm/mach-msm/clock-7x30.h
+++ b/arch/arm/mach-msm/clock-7x30.h
@@ -140,16 +140,4 @@ extern int internal_pwr_rail_ctl_auto(unsigned rail_id, bool enable);
 	}, \
 	}
 
-#define CLK_7X30S(clk_name, l_id, r_id, clk_dev, clk_flags) {	\
-	.con_id = clk_name, \
-	.dev_id = clk_dev, \
-	.clk = &(struct clk){ \
-		.id = L_7X30_##l_id, \
-		.remote_id = P_##r_id, \
-		.flags = clk_flags, \
-		.dbg_name = #l_id, \
-		.ops = &clk_ops_pcom, \
-	}, \
-	}
-
 #endif
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index ee5f7fe..24ddfd8 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -27,7 +27,7 @@
  */
 static int pc_clk_enable(struct clk *clk)
 {
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_ENABLE, &id, NULL);
 	if (rc < 0)
 		return rc;
@@ -37,14 +37,14 @@ static int pc_clk_enable(struct clk *clk)
 
 static void pc_clk_disable(struct clk *clk)
 {
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 	msm_proc_comm(PCOM_CLKCTL_RPC_DISABLE, &id, NULL);
 }
 
 int pc_clk_reset(struct clk *clk, enum clk_reset_action action)
 {
 	int rc;
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 
 	if (action == CLK_RESET_ASSERT)
 		rc = msm_proc_comm(PCOM_CLKCTL_RPC_RESET_ASSERT, &id, NULL);
@@ -63,7 +63,7 @@ static int pc_clk_set_rate(struct clk *clk, unsigned rate)
 	 * remote function. So a return value of 0 doesn't necessarily mean
 	 * that the exact rate was set successfully.
 	 */
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
 	if (rc < 0)
 		return rc;
@@ -73,7 +73,7 @@ static int pc_clk_set_rate(struct clk *clk, unsigned rate)
 
 static int pc_clk_set_min_rate(struct clk *clk, unsigned rate)
 {
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
 	if (rc < 0)
 		return rc;
@@ -83,7 +83,7 @@ static int pc_clk_set_min_rate(struct clk *clk, unsigned rate)
 
 static int pc_clk_set_max_rate(struct clk *clk, unsigned rate)
 {
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MAX_RATE, &id, &rate);
 	if (rc < 0)
 		return rc;
@@ -93,7 +93,7 @@ static int pc_clk_set_max_rate(struct clk *clk, unsigned rate)
 
 static int pc_clk_set_flags(struct clk *clk, unsigned flags)
 {
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_FLAGS, &id, &flags);
 	if (rc < 0)
 		return rc;
@@ -103,7 +103,7 @@ static int pc_clk_set_flags(struct clk *clk, unsigned flags)
 
 static unsigned pc_clk_get_rate(struct clk *clk)
 {
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_RATE, &id, NULL))
 		return 0;
 	else
@@ -112,7 +112,7 @@ static unsigned pc_clk_get_rate(struct clk *clk)
 
 static unsigned pc_clk_is_enabled(struct clk *clk)
 {
-	unsigned id = clk->id;
+	unsigned id = to_pcom_clk(clk)->id;
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_ENABLED, &id, NULL))
 		return 0;
 	else
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 9a695f9..955c917 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -123,18 +123,30 @@
 struct clk_ops;
 extern struct clk_ops clk_ops_pcom;
 
-int pc_clk_reset(struct clk *clk, enum clk_reset_action action);
+/**
+ * struct pcom_clk - proc_comm controlled clock
+ * @id: proc_comm identifier
+ * @c: clk
+ */
+struct pcom_clk {
+	unsigned id;
+	struct clk c;
+};
+
+static inline struct pcom_clk *to_pcom_clk(struct clk *clk)
+{
+	return container_of(clk, struct pcom_clk, c);
+}
 
-#define CLK_PCOM(clk_name, clk_id, clk_dev, clk_flags) {	\
-	.con_id = clk_name, \
-	.dev_id = clk_dev, \
-	.clk = &(struct clk){ \
+#define DEFINE_CLK_PCOM(clk_name, clk_id, clk_flags) \
+	struct pcom_clk clk_name = { \
 		.id = P_##clk_id, \
-		.remote_id = P_##clk_id, \
-		.ops = &clk_ops_pcom, \
-		.flags = clk_flags, \
-		.dbg_name = #clk_id, \
-	}, \
+		.c = { \
+			.ops = &clk_ops_pcom, \
+			.flags = clk_flags, \
+			.dbg_name = #clk_id, \
+			.lock = __SPIN_LOCK_UNLOCKED(clk_name.c), \
+		}, \
 	}
 
 #endif
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 89506a8..ab14f15 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -48,7 +48,6 @@ struct clk_ops {
 };
 
 struct clk {
-	uint32_t id;
 	uint32_t remote_id;
 	uint32_t count;
 	uint32_t flags;
@@ -70,4 +69,5 @@ static inline int __init clock_debug_init(void) { return 0; }
 static inline int __init clock_debug_add(struct clk *clock) { return 0; }
 #endif
 
+#define CLK_LOOKUP(con, c, dev) { .con_id = con, .clk = &c, .dev_id = dev }
 #endif
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index 993780f..1cef1e2 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -394,48 +394,90 @@ struct platform_device msm_device_mdp = {
 	.resource = resources_mdp,
 };
 
+static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,	0);
+static DEFINE_CLK_PCOM(adsp_clk,	ADSP_CLK,	0);
+static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,	0);
+static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	0);
+static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	0);
+static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	OFF);
+static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		0);
+static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,	OFF);
+static DEFINE_CLK_PCOM(i2c_clk,		I2C_CLK,	0);
+static DEFINE_CLK_PCOM(icodec_rx_clk,	ICODEC_RX_CLK,	0);
+static DEFINE_CLK_PCOM(icodec_tx_clk,	ICODEC_TX_CLK,	0);
+static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,	OFF);
+static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	0);
+static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	OFF);
+static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,	0);
+static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	0);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	OFF | CLK_MINMAX);
+static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc2_clk,	SDC2_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc2_p_clk,	SDC2_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc3_clk,	SDC3_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc3_p_clk,	SDC3_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc4_clk,	SDC4_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc4_p_clk,	SDC4_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(tsif_clk,	TSIF_CLK,	0);
+static DEFINE_CLK_PCOM(tsif_ref_clk,	TSIF_REF_CLK,	0);
+static DEFINE_CLK_PCOM(tv_dac_clk,	TV_DAC_CLK,	0);
+static DEFINE_CLK_PCOM(tv_enc_clk,	TV_ENC_CLK,	0);
+static DEFINE_CLK_PCOM(uart1_clk,	UART1_CLK,	OFF);
+static DEFINE_CLK_PCOM(uart2_clk,	UART2_CLK,	0);
+static DEFINE_CLK_PCOM(uart3_clk,	UART3_CLK,	OFF);
+static DEFINE_CLK_PCOM(uart1dm_clk,	UART1DM_CLK,	OFF);
+static DEFINE_CLK_PCOM(uart2dm_clk,	UART2DM_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	0);
+static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	OFF);
+static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	OFF);
+static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	OFF);
+
 struct clk_lookup msm_clocks_7x01a[] = {
-	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
-	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
-	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, 0),
-	CLK_PCOM("ebi2_clk",	EBI2_CLK,	NULL, 0),
-	CLK_PCOM("ecodec_clk",	ECODEC_CLK,	NULL, 0),
-	CLK_PCOM("emdh_clk",	EMDH_CLK,	NULL, OFF),
-	CLK_PCOM("gp_clk",		GP_CLK,		NULL, 0),
-	CLK_PCOM("grp_clk",	GRP_3D_CLK,	NULL, OFF),
-	CLK_PCOM("i2c_clk",	I2C_CLK,	"msm_i2c.0", 0),
-	CLK_PCOM("icodec_rx_clk",	ICODEC_RX_CLK,	NULL, 0),
-	CLK_PCOM("icodec_tx_clk",	ICODEC_TX_CLK,	NULL, 0),
-	CLK_PCOM("imem_clk",	IMEM_CLK,	NULL, OFF),
-	CLK_PCOM("mdc_clk",	MDC_CLK,	NULL, 0),
-	CLK_PCOM("mdp_clk",	MDP_CLK,	NULL, OFF),
-	CLK_PCOM("pbus_clk",	PBUS_CLK,	NULL, 0),
-	CLK_PCOM("pcm_clk",	PCM_CLK,	NULL, 0),
-	CLK_PCOM("mddi_clk",	PMDH_CLK,	NULL, OFF | CLK_MINMAX),
-	CLK_PCOM("sdac_clk",	SDAC_CLK,	NULL, OFF),
-	CLK_PCOM("sdc_clk",	SDC1_CLK,	"msm_sdcc.1", OFF),
-	CLK_PCOM("sdc_pclk",	SDC1_P_CLK,	"msm_sdcc.1", OFF),
-	CLK_PCOM("sdc_clk",	SDC2_CLK,	"msm_sdcc.2", OFF),
-	CLK_PCOM("sdc_pclk",	SDC2_P_CLK,	"msm_sdcc.2", OFF),
-	CLK_PCOM("sdc_clk",	SDC3_CLK,	"msm_sdcc.3", OFF),
-	CLK_PCOM("sdc_pclk",	SDC3_P_CLK,	"msm_sdcc.3", OFF),
-	CLK_PCOM("sdc_clk",	SDC4_CLK,	"msm_sdcc.4", OFF),
-	CLK_PCOM("sdc_pclk",	SDC4_P_CLK,	"msm_sdcc.4", OFF),
-	CLK_PCOM("tsif_clk",	TSIF_CLK,	NULL, 0),
-	CLK_PCOM("tsif_ref_clk",	TSIF_REF_CLK,	NULL, 0),
-	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
-	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART1_CLK,	"msm_serial.0", OFF),
-	CLK_PCOM("uart_clk",	UART2_CLK,	"msm_serial.1", 0),
-	CLK_PCOM("uart_clk",	UART3_CLK,	"msm_serial.2", OFF),
-	CLK_PCOM("uart1dm_clk",	UART1DM_CLK,	NULL, OFF),
-	CLK_PCOM("uart2dm_clk",	UART2DM_CLK,	NULL, 0),
-	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	"msm_hsusb", OFF),
-	CLK_PCOM("usb_hs_pclk",	USB_HS_P_CLK,	"msm_hsusb", OFF),
-	CLK_PCOM("usb_otg_clk",	USB_OTG_CLK,	NULL, 0),
-	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF ),
-	CLK_PCOM("vfe_clk",	VFE_CLK,	NULL, OFF),
-	CLK_PCOM("vfe_mdc_clk",	VFE_MDC_CLK,	NULL, OFF),
+	CLK_LOOKUP("adm_clk",		adm_clk.c,	"msm_dmov"),
+	CLK_LOOKUP("adsp_clk",		adsp_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_clk.c,	NULL),
+	CLK_LOOKUP("ebi2_clk",		ebi2_clk.c,	NULL),
+	CLK_LOOKUP("ecodec_clk",	ecodec_clk.c,	NULL),
+	CLK_LOOKUP("emdh_clk",		emdh_clk.c,	NULL),
+	CLK_LOOKUP("gp_clk",		gp_clk.c,	NULL),
+	CLK_LOOKUP("grp_clk",		grp_3d_clk.c,	NULL),
+	CLK_LOOKUP("i2c_clk",		i2c_clk.c,	"msm_i2c.0"),
+	CLK_LOOKUP("icodec_rx_clk",	icodec_rx_clk.c,	NULL),
+	CLK_LOOKUP("icodec_tx_clk",	icodec_tx_clk.c,	NULL),
+	CLK_LOOKUP("imem_clk",		imem_clk.c,	NULL),
+	CLK_LOOKUP("mdc_clk",		mdc_clk.c,	NULL),
+	CLK_LOOKUP("mdp_clk",		mdp_clk.c,	NULL),
+	CLK_LOOKUP("pbus_clk",		pbus_clk.c,	NULL),
+	CLK_LOOKUP("pcm_clk",		pcm_clk.c,	NULL),
+	CLK_LOOKUP("mddi_clk",		pmdh_clk.c,	NULL),
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
+	CLK_LOOKUP("uart1dm_clk",	uart1dm_clk.c,	NULL),
+	CLK_LOOKUP("uart2dm_clk",	uart2dm_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs_clk",	usb_hs_clk.c,	"msm_hsusb"),
+	CLK_LOOKUP("usb_hs_pclk",	usb_hs_p_clk.c,	"msm_hsusb"),
+	CLK_LOOKUP("usb_otg_clk",	usb_otg_clk.c,	NULL),
+	CLK_LOOKUP("vdc_clk",		vdc_clk.c,	NULL),
+	CLK_LOOKUP("vfe_clk",		vfe_clk.c,	NULL),
+	CLK_LOOKUP("vfe_mdc_clk",	vfe_mdc_clk.c,	NULL),
 };
 
 unsigned msm_num_clocks_7x01a = ARRAY_SIZE(msm_clocks_7x01a);
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 09b4f14..1ebb22d 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -130,80 +130,151 @@ struct platform_device msm_device_hsusb_host = {
 	},
 };
 
+static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,		0);
+static DEFINE_CLK_PCOM(adsp_clk,	ADSP_CLK,		0);
+static DEFINE_CLK_PCOM(cam_m_clk,	CAM_M_CLK,		0);
+static DEFINE_CLK_PCOM(camif_pad_p_clk,	CAMIF_PAD_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(ce_clk,		CE_CLK,			0);
+static DEFINE_CLK_PCOM(codec_ssbi_clk,	CODEC_SSBI_CLK,		0);
+static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,		CLK_MIN);
+static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,		0);
+static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	OFF | CLK_MINMAX);
+static DEFINE_CLK_PCOM(emdh_p_clk,	EMDH_P_CLK,		OFF);
+static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,			0);
+static DEFINE_CLK_PCOM(grp_2d_clk,	GRP_2D_CLK,		0);
+static DEFINE_CLK_PCOM(grp_2d_p_clk,	GRP_2D_P_CLK,		0);
+static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,		0);
+static DEFINE_CLK_PCOM(grp_3d_p_clk,	GRP_3D_P_CLK,		0);
+static DEFINE_CLK_PCOM(hdmi_clk,	HDMI_CLK,		0);
+static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,		OFF);
+static DEFINE_CLK_PCOM(jpeg_clk,	JPEG_CLK,		OFF);
+static DEFINE_CLK_PCOM(jpeg_p_clk,	JPEG_P_CLK,		OFF);
+static DEFINE_CLK_PCOM(lpa_codec_clk,	LPA_CODEC_CLK,		0);
+static DEFINE_CLK_PCOM(lpa_core_clk,	LPA_CORE_CLK,		0);
+static DEFINE_CLK_PCOM(lpa_p_clk,	LPA_P_CLK,		0);
+static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,		0);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	OFF | CLK_MINMAX);
+static DEFINE_CLK_PCOM(pmdh_p_clk,	PMDH_P_CLK,		0);
+static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,		OFF);
+static DEFINE_CLK_PCOM(mdp_p_clk,	MDP_P_CLK,		0);
+static DEFINE_CLK_PCOM(mdp_lcdc_pclk_clk, MDP_LCDC_PCLK_CLK,	0);
+static DEFINE_CLK_PCOM(mdp_lcdc_pad_pclk_clk, MDP_LCDC_PAD_PCLK_CLK, 0);
+static DEFINE_CLK_PCOM(mdp_vsync_clk,	MDP_VSYNC_CLK,		0);
+static DEFINE_CLK_PCOM(mfc_clk,		MFC_CLK,		0);
+static DEFINE_CLK_PCOM(mfc_div2_clk,	MFC_DIV2_CLK,		0);
+static DEFINE_CLK_PCOM(mfc_p_clk,	MFC_P_CLK,		0);
+static DEFINE_CLK_PCOM(mi2s_m_clk,	MI2S_M_CLK,  		0);
+static DEFINE_CLK_PCOM(mi2s_s_clk,	MI2S_S_CLK,  		0);
+static DEFINE_CLK_PCOM(mi2s_codec_rx_m_clk,	MI2S_CODEC_RX_M_CLK,  0);
+static DEFINE_CLK_PCOM(mi2s_codec_rx_s_clk,	MI2S_CODEC_RX_S_CLK,  0);
+static DEFINE_CLK_PCOM(mi2s_codec_tx_m_clk,	MI2S_CODEC_TX_M_CLK,  0);
+static DEFINE_CLK_PCOM(mi2s_codec_tx_s_clk,	MI2S_CODEC_TX_S_CLK,  0);
+static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,		CLK_MIN);
+static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,		0);
+static DEFINE_CLK_PCOM(axi_rotator_clk,	AXI_ROTATOR_CLK,	0);
+static DEFINE_CLK_PCOM(rotator_imem_clk, ROTATOR_IMEM_CLK,	OFF);
+static DEFINE_CLK_PCOM(rotator_p_clk,	ROTATOR_P_CLK,		OFF);
+static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,		OFF);
+static DEFINE_CLK_PCOM(spi_clk,		SPI_CLK,		0);
+static DEFINE_CLK_PCOM(spi_p_clk,	SPI_P_CLK,		0);
+static DEFINE_CLK_PCOM(tv_dac_clk,	TV_DAC_CLK,		0);
+static DEFINE_CLK_PCOM(tv_enc_clk,	TV_ENC_CLK,		0);
+static DEFINE_CLK_PCOM(uart2_clk,	UART2_CLK,		0);
+static DEFINE_CLK_PCOM(usb_phy_clk,	USB_PHY_CLK,		0);
+static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,		OFF);
+static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,		OFF);
+static DEFINE_CLK_PCOM(usb_hs_core_clk,	USB_HS_CORE_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_hs2_clk,	USB_HS2_CLK,		OFF);
+static DEFINE_CLK_PCOM(usb_hs2_p_clk,	USB_HS2_P_CLK,		OFF);
+static DEFINE_CLK_PCOM(usb_hs2_core_clk,USB_HS2_CORE_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_hs3_clk,	USB_HS3_CLK,		OFF);
+static DEFINE_CLK_PCOM(usb_hs3_p_clk,	USB_HS3_P_CLK,		OFF);
+static DEFINE_CLK_PCOM(usb_hs3_core_clk,USB_HS3_CORE_CLK,	OFF);
+static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,		OFF | CLK_MIN);
+static DEFINE_CLK_PCOM(vfe_camif_clk,	VFE_CAMIF_CLK, 		0);
+static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,		0);
+static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,		0);
+static DEFINE_CLK_PCOM(vfe_p_clk,	VFE_P_CLK,		OFF);
+static DEFINE_CLK_PCOM(vpe_clk,		VPE_CLK,		0);
+
+static DEFINE_CLK_PCOM(csi0_clk,	CSI0_CLK,		0);
+static DEFINE_CLK_PCOM(csi0_p_clk,	CSI0_P_CLK,		0);
+static DEFINE_CLK_PCOM(csi0_vfe_clk,	CSI0_VFE_CLK,		0);
+
 struct clk_lookup msm_clocks_7x30[] = {
-	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
-	CLK_PCOM("adsp_clk",	ADSP_CLK,	NULL, 0),
-	CLK_PCOM("cam_m_clk",	CAM_M_CLK,	NULL, 0),
-	CLK_PCOM("camif_pad_pclk",	CAMIF_PAD_P_CLK,	NULL, OFF),
-	CLK_PCOM("ce_clk",	CE_CLK,	NULL, 0),
-	CLK_PCOM("codec_ssbi_clk",	CODEC_SSBI_CLK,	NULL, 0),
-	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
-	CLK_PCOM("ecodec_clk",	ECODEC_CLK,	NULL, 0),
-	CLK_PCOM("emdh_clk",	EMDH_CLK,	NULL, OFF | CLK_MINMAX),
-	CLK_PCOM("emdh_pclk",	EMDH_P_CLK,	NULL, OFF),
-	CLK_PCOM("gp_clk",	GP_CLK,		NULL, 0),
-	CLK_PCOM("grp_2d_clk",	GRP_2D_CLK,	NULL, 0),
-	CLK_PCOM("grp_2d_pclk",	GRP_2D_P_CLK,	NULL, 0),
-	CLK_PCOM("grp_clk",	GRP_3D_CLK,	NULL, 0),
-	CLK_PCOM("grp_pclk",	GRP_3D_P_CLK,	NULL, 0),
-	CLK_7X30S("grp_src_clk", GRP_3D_SRC_CLK, GRP_3D_CLK,	NULL, 0),
-	CLK_PCOM("hdmi_clk",	HDMI_CLK,	NULL, 0),
-	CLK_PCOM("imem_clk",	IMEM_CLK,	NULL, OFF),
-	CLK_PCOM("jpeg_clk",	JPEG_CLK,	NULL, OFF),
-	CLK_PCOM("jpeg_pclk",	JPEG_P_CLK,	NULL, OFF),
-	CLK_PCOM("lpa_codec_clk",	LPA_CODEC_CLK,		NULL, 0),
-	CLK_PCOM("lpa_core_clk",	LPA_CORE_CLK,		NULL, 0),
-	CLK_PCOM("lpa_pclk",		LPA_P_CLK,		NULL, 0),
-	CLK_PCOM("mdc_clk",	MDC_CLK,	NULL, 0),
-	CLK_PCOM("mddi_clk",	PMDH_CLK,	NULL, OFF | CLK_MINMAX),
-	CLK_PCOM("mddi_pclk",	PMDH_P_CLK,	NULL, 0),
-	CLK_PCOM("mdp_clk",	MDP_CLK,	NULL, OFF),
-	CLK_PCOM("mdp_pclk",	MDP_P_CLK,	NULL, 0),
-	CLK_PCOM("mdp_lcdc_pclk_clk", MDP_LCDC_PCLK_CLK, NULL, 0),
-	CLK_PCOM("mdp_lcdc_pad_pclk_clk", MDP_LCDC_PAD_PCLK_CLK, NULL, 0),
-	CLK_PCOM("mdp_vsync_clk",	MDP_VSYNC_CLK,  NULL, 0),
-	CLK_PCOM("mfc_clk",		MFC_CLK,		NULL, 0),
-	CLK_PCOM("mfc_div2_clk",	MFC_DIV2_CLK,		NULL, 0),
-	CLK_PCOM("mfc_pclk",		MFC_P_CLK,		NULL, 0),
-	CLK_PCOM("mi2s_m_clk",		MI2S_M_CLK,  		NULL, 0),
-	CLK_PCOM("mi2s_s_clk",		MI2S_S_CLK,  		NULL, 0),
-	CLK_PCOM("mi2s_codec_rx_m_clk",	MI2S_CODEC_RX_M_CLK,  NULL, 0),
-	CLK_PCOM("mi2s_codec_rx_s_clk",	MI2S_CODEC_RX_S_CLK,  NULL, 0),
-	CLK_PCOM("mi2s_codec_tx_m_clk",	MI2S_CODEC_TX_M_CLK,  NULL, 0),
-	CLK_PCOM("mi2s_codec_tx_s_clk",	MI2S_CODEC_TX_S_CLK,  NULL, 0),
-	CLK_PCOM("pbus_clk",	PBUS_CLK,	NULL, CLK_MIN),
-	CLK_PCOM("pcm_clk",	PCM_CLK,	NULL, 0),
-	CLK_PCOM("rotator_clk",	AXI_ROTATOR_CLK,		NULL, 0),
-	CLK_PCOM("rotator_imem_clk",	ROTATOR_IMEM_CLK,	NULL, OFF),
-	CLK_PCOM("rotator_pclk",	ROTATOR_P_CLK,		NULL, OFF),
-	CLK_PCOM("sdac_clk",	SDAC_CLK,	NULL, OFF),
-	CLK_PCOM("spi_clk",	SPI_CLK,	NULL, 0),
-	CLK_PCOM("spi_pclk",	SPI_P_CLK,	NULL, 0),
-	CLK_7X30S("tv_src_clk",	TV_CLK, 	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
-	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART2_CLK,	"msm_serial.1", 0),
-	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
-	CLK_PCOM("usb_hs_clk",		USB_HS_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs_pclk",		USB_HS_P_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs_core_clk",	USB_HS_CORE_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs2_clk",		USB_HS2_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs2_pclk",	USB_HS2_P_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs2_core_clk",	USB_HS2_CORE_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs3_clk",		USB_HS3_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs3_pclk",	USB_HS3_P_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs3_core_clk",	USB_HS3_CORE_CLK,	NULL, OFF),
-	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF | CLK_MIN),
-	CLK_PCOM("vfe_camif_clk",	VFE_CAMIF_CLK, 	NULL, 0),
-	CLK_PCOM("vfe_clk",	VFE_CLK,	NULL, 0),
-	CLK_PCOM("vfe_mdc_clk",	VFE_MDC_CLK,	NULL, 0),
-	CLK_PCOM("vfe_pclk",	VFE_P_CLK,	NULL, OFF),
-	CLK_PCOM("vpe_clk",	VPE_CLK,	NULL, 0),
+	CLK_LOOKUP("adm_clk",			adm_clk.c,	"msm_dmov"),
+	CLK_LOOKUP("adsp_clk",			adsp_clk.c,	NULL),
+	CLK_LOOKUP("cam_m_clk",			cam_m_clk.c,	NULL),
+	CLK_LOOKUP("camif_pad_pclk",		camif_pad_p_clk.c,	NULL),
+	CLK_LOOKUP("ce_clk",			ce_clk.c,	NULL),
+	CLK_LOOKUP("codec_ssbi_clk",		codec_ssbi_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",			ebi1_clk.c,	NULL),
+	CLK_LOOKUP("ecodec_clk",		ecodec_clk.c,	NULL),
+	CLK_LOOKUP("emdh_clk",			emdh_clk.c,	NULL),
+	CLK_LOOKUP("emdh_pclk",			emdh_p_clk.c,	NULL),
+	CLK_LOOKUP("gp_clk",			gp_clk.c,	NULL),
+	CLK_LOOKUP("grp_2d_clk",		grp_2d_clk.c,	NULL),
+	CLK_LOOKUP("grp_2d_pclk",		grp_2d_p_clk.c,	NULL),
+	CLK_LOOKUP("grp_clk",			grp_3d_clk.c,	NULL),
+	CLK_LOOKUP("grp_pclk",			grp_3d_p_clk.c,	NULL),
+	CLK_LOOKUP("grp_src_clk",		grp_3d_clk.c,	NULL),
+	CLK_LOOKUP("hdmi_clk",			hdmi_clk.c,	NULL),
+	CLK_LOOKUP("imem_clk",			imem_clk.c,	NULL),
+	CLK_LOOKUP("jpeg_clk",			jpeg_clk.c,	NULL),
+	CLK_LOOKUP("jpeg_pclk",			jpeg_p_clk.c,	NULL),
+	CLK_LOOKUP("lpa_codec_clk",		lpa_codec_clk.c,	NULL),
+	CLK_LOOKUP("lpa_core_clk",		lpa_core_clk.c,	NULL),
+	CLK_LOOKUP("lpa_pclk",			lpa_p_clk.c,	NULL),
+	CLK_LOOKUP("mdc_clk",			mdc_clk.c,	NULL),
+	CLK_LOOKUP("mddi_clk",			pmdh_clk.c,	NULL),
+	CLK_LOOKUP("mddi_pclk",			pmdh_p_clk.c,	NULL),
+	CLK_LOOKUP("mdp_clk",			mdp_clk.c,	NULL),
+	CLK_LOOKUP("mdp_pclk",			mdp_p_clk.c,	NULL),
+	CLK_LOOKUP("mdp_lcdc_pclk_clk",		mdp_lcdc_pclk_clk.c,	NULL),
+	CLK_LOOKUP("mdp_lcdc_pad_pclk_clk",	mdp_lcdc_pad_pclk_clk.c, NULL),
+	CLK_LOOKUP("mdp_vsync_clk",		mdp_vsync_clk.c,	NULL),
+	CLK_LOOKUP("mfc_clk",			mfc_clk.c,		NULL),
+	CLK_LOOKUP("mfc_div2_clk",		mfc_div2_clk.c,		NULL),
+	CLK_LOOKUP("mfc_pclk",			mfc_p_clk.c,		NULL),
+	CLK_LOOKUP("mi2s_m_clk",		mi2s_m_clk.c,		NULL),
+	CLK_LOOKUP("mi2s_s_clk",		mi2s_s_clk.c,		NULL),
+	CLK_LOOKUP("mi2s_codec_rx_m_clk",	mi2s_codec_rx_m_clk.c,	NULL),
+	CLK_LOOKUP("mi2s_codec_rx_s_clk",	mi2s_codec_rx_s_clk.c,	NULL),
+	CLK_LOOKUP("mi2s_codec_tx_m_clk",	mi2s_codec_tx_m_clk.c,	NULL),
+	CLK_LOOKUP("mi2s_codec_tx_s_clk",	mi2s_codec_tx_s_clk.c,	NULL),
+	CLK_LOOKUP("pbus_clk",			pbus_clk.c,		NULL),
+	CLK_LOOKUP("pcm_clk",			pcm_clk.c,		NULL),
+	CLK_LOOKUP("rotator_clk",		axi_rotator_clk.c,	NULL),
+	CLK_LOOKUP("rotator_imem_clk",		rotator_imem_clk.c,	NULL),
+	CLK_LOOKUP("rotator_pclk",		rotator_p_clk.c,	NULL),
+	CLK_LOOKUP("sdac_clk",			sdac_clk.c,	NULL),
+	CLK_LOOKUP("spi_clk",			spi_clk.c,	NULL),
+	CLK_LOOKUP("spi_pclk",			spi_p_clk.c,	NULL),
+	CLK_LOOKUP("tv_src_clk",		tv_enc_clk.c,	NULL),
+	CLK_LOOKUP("tv_dac_clk",		tv_dac_clk.c,	NULL),
+	CLK_LOOKUP("tv_enc_clk",		tv_enc_clk.c,	NULL),
+	CLK_LOOKUP("uart_clk",			uart2_clk.c,	"msm_serial.1"),
+	CLK_LOOKUP("usb_phy_clk",		usb_phy_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs_clk",		usb_hs_clk.c,		NULL),
+	CLK_LOOKUP("usb_hs_pclk",		usb_hs_p_clk.c,		NULL),
+	CLK_LOOKUP("usb_hs_core_clk",		usb_hs_core_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs2_clk",		usb_hs2_clk.c,		NULL),
+	CLK_LOOKUP("usb_hs2_pclk",		usb_hs2_p_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs2_core_clk",		usb_hs2_core_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs3_clk",		usb_hs3_clk.c,		NULL),
+	CLK_LOOKUP("usb_hs3_pclk",		usb_hs3_p_clk.c,	NULL),
+	CLK_LOOKUP("usb_hs3_core_clk",		usb_hs3_core_clk.c,	NULL),
+	CLK_LOOKUP("vdc_clk",			vdc_clk.c,		NULL),
+	CLK_LOOKUP("vfe_camif_clk",		vfe_camif_clk.c,	NULL),
+	CLK_LOOKUP("vfe_clk",			vfe_clk.c,	NULL),
+	CLK_LOOKUP("vfe_mdc_clk",		vfe_mdc_clk.c,	NULL),
+	CLK_LOOKUP("vfe_pclk",			vfe_p_clk.c,	NULL),
+	CLK_LOOKUP("vpe_clk",			vpe_clk.c,	NULL),
 
 	/* 7x30 v2 hardware only. */
-	CLK_PCOM("csi_clk",	CSI0_CLK,	NULL, 0),
-	CLK_PCOM("csi_pclk",	CSI0_P_CLK,	NULL, 0),
-	CLK_PCOM("csi_vfe_clk",	CSI0_VFE_CLK,	NULL, 0),
+	CLK_LOOKUP("csi_clk",			csi0_clk.c,	NULL),
+	CLK_LOOKUP("csi_pclk",			csi0_p_clk.c,	NULL),
+	CLK_LOOKUP("csi_vfe_clk",		csi0_vfe_clk.c,	NULL),
 };
 
 unsigned msm_num_clocks_7x30 = ARRAY_SIZE(msm_clocks_7x30);
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 131633b..cc93ce8 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -291,58 +291,110 @@ int __init msm_add_sdcc(unsigned int controller,
 	return platform_device_register(pdev);
 }
 
+static DEFINE_CLK_PCOM(adm_clk,		ADM_CLK,	0);
+static DEFINE_CLK_PCOM(ce_clk,		CE_CLK,		0);
+static DEFINE_CLK_PCOM(ebi1_clk,	EBI1_CLK,	CLK_MIN);
+static DEFINE_CLK_PCOM(ebi2_clk,	EBI2_CLK,	0);
+static DEFINE_CLK_PCOM(ecodec_clk,	ECODEC_CLK,	0);
+static DEFINE_CLK_PCOM(emdh_clk,	EMDH_CLK,	OFF | CLK_MINMAX);
+static DEFINE_CLK_PCOM(gp_clk,		GP_CLK,		0);
+static DEFINE_CLK_PCOM(grp_3d_clk,	GRP_3D_CLK,	0);
+static DEFINE_CLK_PCOM(i2c_clk,		I2C_CLK,	0);
+static DEFINE_CLK_PCOM(icodec_rx_clk,	ICODEC_RX_CLK,	0);
+static DEFINE_CLK_PCOM(icodec_tx_clk,	ICODEC_TX_CLK,	0);
+static DEFINE_CLK_PCOM(imem_clk,	IMEM_CLK,	OFF);
+static DEFINE_CLK_PCOM(mdc_clk,		MDC_CLK,	0);
+static DEFINE_CLK_PCOM(pmdh_clk,	PMDH_CLK,	OFF | CLK_MINMAX);
+static DEFINE_CLK_PCOM(mdp_clk,		MDP_CLK,	OFF);
+static DEFINE_CLK_PCOM(mdp_lcdc_pclk_clk,	MDP_LCDC_PCLK_CLK, 0);
+static DEFINE_CLK_PCOM(mdp_lcdc_pad_pclk_clk,	MDP_LCDC_PAD_PCLK_CLK, 0);
+static DEFINE_CLK_PCOM(mdp_vsync_clk,	MDP_VSYNC_CLK,	0);
+static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,	CLK_MIN);
+static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,	0);
+static DEFINE_CLK_PCOM(sdac_clk,	SDAC_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc1_clk,	SDC1_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc1_p_clk,	SDC1_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc2_clk,	SDC2_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc2_p_clk,	SDC2_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc3_clk,	SDC3_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc3_p_clk,	SDC3_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc4_clk,	SDC4_CLK,	OFF);
+static DEFINE_CLK_PCOM(sdc4_p_clk,	SDC4_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(spi_clk,		SPI_CLK,	0);
+static DEFINE_CLK_PCOM(tsif_clk,	TSIF_CLK,	0);
+static DEFINE_CLK_PCOM(tsif_ref_clk,	TSIF_REF_CLK,	0);
+static DEFINE_CLK_PCOM(tv_dac_clk,	TV_DAC_CLK,	0);
+static DEFINE_CLK_PCOM(tv_enc_clk,	TV_ENC_CLK,	0);
+static DEFINE_CLK_PCOM(uart1_clk,	UART1_CLK,	OFF);
+static DEFINE_CLK_PCOM(uart2_clk,	UART2_CLK,	0);
+static DEFINE_CLK_PCOM(uart3_clk,	UART3_CLK,	OFF);
+static DEFINE_CLK_PCOM(uart1dm_clk,	UART1DM_CLK,	OFF);
+static DEFINE_CLK_PCOM(uart2dm_clk,	UART2DM_CLK,	0);
+static DEFINE_CLK_PCOM(usb_hs_clk,	USB_HS_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_hs_p_clk,	USB_HS_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_otg_clk,	USB_OTG_CLK,	0);
+static DEFINE_CLK_PCOM(vdc_clk,		VDC_CLK,	OFF | CLK_MIN);
+static DEFINE_CLK_PCOM(vfe_clk,		VFE_CLK,	OFF);
+static DEFINE_CLK_PCOM(vfe_mdc_clk,	VFE_MDC_CLK,	OFF);
+static DEFINE_CLK_PCOM(vfe_axi_clk,	VFE_AXI_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_hs2_clk,	USB_HS2_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_hs2_p_clk,	USB_HS2_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_hs3_clk,	USB_HS3_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_hs3_p_clk,	USB_HS3_P_CLK,	OFF);
+static DEFINE_CLK_PCOM(usb_phy_clk,	USB_PHY_CLK,	0);
+
 struct clk_lookup msm_clocks_8x50[] = {
-	CLK_PCOM("adm_clk",	ADM_CLK,	NULL, 0),
-	CLK_PCOM("ce_clk",	CE_CLK,		NULL, 0),
-	CLK_PCOM("ebi1_clk",	EBI1_CLK,	NULL, CLK_MIN),
-	CLK_PCOM("ebi2_clk",	EBI2_CLK,	NULL, 0),
-	CLK_PCOM("ecodec_clk",	ECODEC_CLK,	NULL, 0),
-	CLK_PCOM("emdh_clk",	EMDH_CLK,	NULL, OFF | CLK_MINMAX),
-	CLK_PCOM("gp_clk",	GP_CLK,		NULL, 0),
-	CLK_PCOM("grp_clk",	GRP_3D_CLK,	NULL, 0),
-	CLK_PCOM("i2c_clk",	I2C_CLK,	NULL, 0),
-	CLK_PCOM("icodec_rx_clk",	ICODEC_RX_CLK,	NULL, 0),
-	CLK_PCOM("icodec_tx_clk",	ICODEC_TX_CLK,	NULL, 0),
-	CLK_PCOM("imem_clk",	IMEM_CLK,	NULL, OFF),
-	CLK_PCOM("mdc_clk",	MDC_CLK,	NULL, 0),
-	CLK_PCOM("mddi_clk",	PMDH_CLK,	NULL, OFF | CLK_MINMAX),
-	CLK_PCOM("mdp_clk",	MDP_CLK,	NULL, OFF),
-	CLK_PCOM("mdp_lcdc_pclk_clk", MDP_LCDC_PCLK_CLK, NULL, 0),
-	CLK_PCOM("mdp_lcdc_pad_pclk_clk", MDP_LCDC_PAD_PCLK_CLK, NULL, 0),
-	CLK_PCOM("mdp_vsync_clk",	MDP_VSYNC_CLK,	NULL, 0),
-	CLK_PCOM("pbus_clk",	PBUS_CLK,	NULL, CLK_MIN),
-	CLK_PCOM("pcm_clk",	PCM_CLK,	NULL, 0),
-	CLK_PCOM("sdac_clk",	SDAC_CLK,	NULL, OFF),
-	CLK_PCOM("sdc_clk",	SDC1_CLK,	"msm_sdcc.1", OFF),
-	CLK_PCOM("sdc_pclk",	SDC1_P_CLK,	"msm_sdcc.1", OFF),
-	CLK_PCOM("sdc_clk",	SDC2_CLK,	"msm_sdcc.2", OFF),
-	CLK_PCOM("sdc_pclk",	SDC2_P_CLK,	"msm_sdcc.2", OFF),
-	CLK_PCOM("sdc_clk",	SDC3_CLK,	"msm_sdcc.3", OFF),
-	CLK_PCOM("sdc_pclk",	SDC3_P_CLK,	"msm_sdcc.3", OFF),
-	CLK_PCOM("sdc_clk",	SDC4_CLK,	"msm_sdcc.4", OFF),
-	CLK_PCOM("sdc_pclk",	SDC4_P_CLK,	"msm_sdcc.4", OFF),
-	CLK_PCOM("spi_clk",	SPI_CLK,	NULL, 0),
-	CLK_PCOM("tsif_clk",	TSIF_CLK,	NULL, 0),
-	CLK_PCOM("tsif_ref_clk",	TSIF_REF_CLK,	NULL, 0),
-	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
-	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART1_CLK,	NULL, OFF),
-	CLK_PCOM("uart_clk",	UART2_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART3_CLK,	"msm_serial.2", OFF),
-	CLK_PCOM("uartdm_clk",	UART1DM_CLK,	NULL, OFF),
-	CLK_PCOM("uartdm_clk",	UART2DM_CLK,	NULL, 0),
-	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs_pclk",	USB_HS_P_CLK,	NULL, OFF),
-	CLK_PCOM("usb_otg_clk",	USB_OTG_CLK,	NULL, 0),
-	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF | CLK_MIN),
-	CLK_PCOM("vfe_clk",	VFE_CLK,	NULL, OFF),
-	CLK_PCOM("vfe_mdc_clk",	VFE_MDC_CLK,	NULL, OFF),
-	CLK_PCOM("vfe_axi_clk",	VFE_AXI_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs2_clk",	USB_HS2_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs2_pclk",	USB_HS2_P_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs3_clk",	USB_HS3_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs3_pclk",	USB_HS3_P_CLK,	NULL, OFF),
-	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
+	CLK_LOOKUP("adm_clk",		adm_clk.c,	"msm_dmov"),
+	CLK_LOOKUP("ce_clk",		ce_clk.c,		NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_clk.c,	NULL),
+	CLK_LOOKUP("ebi2_clk",		ebi2_clk.c,	NULL),
+	CLK_LOOKUP("ecodec_clk",	ecodec_clk.c,	NULL),
+	CLK_LOOKUP("emdh_clk",		emdh_clk.c,	NULL),
+	CLK_LOOKUP("gp_clk",		gp_clk.c,		NULL),
+	CLK_LOOKUP("grp_clk",		grp_3d_clk.c,	NULL),
+	CLK_LOOKUP("i2c_clk",		i2c_clk.c,	NULL),
+	CLK_LOOKUP("icodec_rx_clk",	icodec_rx_clk.c,	NULL),
+	CLK_LOOKUP("icodec_tx_clk",	icodec_tx_clk.c,	NULL),
+	CLK_LOOKUP("imem_clk",		imem_clk.c,	NULL),
+	CLK_LOOKUP("mdc_clk",		mdc_clk.c,	NULL),
+	CLK_LOOKUP("mddi_clk",		pmdh_clk.c,	NULL),
+	CLK_LOOKUP("mdp_clk",		mdp_clk.c,	NULL),
+	CLK_LOOKUP("mdp_lcdc_pclk_clk",	mdp_lcdc_pclk_clk.c, NULL),
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
+	CLK_LOOKUP("tsif_clk",		tsif_clk.c,	NULL),
+	CLK_LOOKUP("tsif_ref_clk",	tsif_ref_clk.c,	NULL),
+	CLK_LOOKUP("tv_dac_clk",	tv_dac_clk.c,	NULL),
+	CLK_LOOKUP("tv_enc_clk",	tv_enc_clk.c,	NULL),
+	CLK_LOOKUP("uart_clk",		uart1_clk.c,	NULL),
+	CLK_LOOKUP("uart_clk",		uart2_clk.c,	NULL),
+	CLK_LOOKUP("uart_clk",		uart3_clk.c,	"msm_serial.2"),
+	CLK_LOOKUP("uartdm_clk",	uart1dm_clk.c,	NULL),
+	CLK_LOOKUP("uartdm_clk",	uart2dm_clk.c,	NULL),
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
 };
 
 unsigned msm_num_clocks_8x50 = ARRAY_SIZE(msm_clocks_8x50);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

