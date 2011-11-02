Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab1KBSny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:43:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921Ab1KBShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706966"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 10/34] msm: clock-pcom: Add pbus specific clock ops
Date: Wed,  2 Nov 2011 11:36:07 -0700
Message-Id: <1320258991-22325-11-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The pbus clock always runs at half the ebi1 clock frequency.
Since ebi1 clock votes are dropped when the application processor
is power collapsed, the ebi1 clock is reserved for the acpuclock
driver. Other drivers which have ebi1 clock requirements that are
independent of application processor power status use the pbus.
To keep this change transparent across drivers and SoCs, add new
ops that divides the rate by 2 before sending the request to the
modem.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-pcom.c      |   29 +++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-pcom.h      |    1 +
 arch/arm/mach-msm/devices-msm7x30.c |   11 ++++++++++-
 3 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index 24ddfd8..e11ef57 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -145,3 +145,32 @@ struct clk_ops clk_ops_pcom = {
 	.round_rate = pc_clk_round_rate,
 	.is_local = pc_clk_is_local,
 };
+
+int pc_clk_set_rate2(struct clk *clk, unsigned rate)
+{
+	return pc_clk_set_rate(clk, rate / 2);
+}
+
+int pc_clk_set_min_rate2(struct clk *clk, unsigned rate)
+{
+	return pc_clk_set_min_rate(clk, rate / 2);
+}
+
+unsigned pc_clk_get_rate2(struct clk *clk)
+{
+	return pc_clk_get_rate(clk) * 2;
+}
+
+struct clk_ops clk_ops_pcom_div2 = {
+	.enable = pc_clk_enable,
+	.disable = pc_clk_disable,
+	.auto_off = pc_clk_disable,
+	.reset = pc_clk_reset,
+	.set_rate = pc_clk_set_rate2,
+	.set_min_rate = pc_clk_set_min_rate2,
+	.set_flags = pc_clk_set_flags,
+	.get_rate = pc_clk_get_rate2,
+	.is_enabled = pc_clk_is_enabled,
+	.round_rate = pc_clk_round_rate,
+	.is_local = pc_clk_is_local,
+};
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index a5ac74d..23807ff 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -122,6 +122,7 @@
 
 struct clk_ops;
 extern struct clk_ops clk_ops_pcom;
+extern struct clk_ops clk_ops_pcom_div2;
 
 /**
  * struct pcom_clk - proc_comm controlled clock
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 1ebb22d..7a548a2 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -169,7 +169,6 @@ static DEFINE_CLK_PCOM(mi2s_codec_rx_m_clk,	MI2S_CODEC_RX_M_CLK,  0);
 static DEFINE_CLK_PCOM(mi2s_codec_rx_s_clk,	MI2S_CODEC_RX_S_CLK,  0);
 static DEFINE_CLK_PCOM(mi2s_codec_tx_m_clk,	MI2S_CODEC_TX_M_CLK,  0);
 static DEFINE_CLK_PCOM(mi2s_codec_tx_s_clk,	MI2S_CODEC_TX_S_CLK,  0);
-static DEFINE_CLK_PCOM(pbus_clk,	PBUS_CLK,		CLK_MIN);
 static DEFINE_CLK_PCOM(pcm_clk,		PCM_CLK,		0);
 static DEFINE_CLK_PCOM(axi_rotator_clk,	AXI_ROTATOR_CLK,	0);
 static DEFINE_CLK_PCOM(rotator_imem_clk, ROTATOR_IMEM_CLK,	OFF);
@@ -201,6 +200,16 @@ static DEFINE_CLK_PCOM(csi0_clk,	CSI0_CLK,		0);
 static DEFINE_CLK_PCOM(csi0_p_clk,	CSI0_P_CLK,		0);
 static DEFINE_CLK_PCOM(csi0_vfe_clk,	CSI0_VFE_CLK,		0);
 
+static struct pcom_clk pbus_clk = {
+	.id = P_PBUS_CLK,
+	.c = {
+		.dbg_name = "pbus_clk",
+		.ops = &clk_ops_pcom_div2,
+		.flags = CLK_MIN,
+		CLK_INIT(pbus_clk.c),
+	},
+};
+
 struct clk_lookup msm_clocks_7x30[] = {
 	CLK_LOOKUP("adm_clk",			adm_clk.c,	"msm_dmov"),
 	CLK_LOOKUP("adsp_clk",			adsp_clk.c,	NULL),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

