Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0LQAwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:52:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29783 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab0LQAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160037"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 15/22] msm: clock-pcom: Add pbus specific clock ops
Date: Thu, 16 Dec 2010 16:49:59 -0800
Message-Id: <1292547006-19741-16-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pbus clock always runs at half the ebi1 clock frequency.
Since ebi1 clock votes are dropped when the application processor
is power collapsed, the ebi1 clock is reserved for the acpuclock
driver. Other drivers which have ebi1 clock requirements that are
independent of application processor power status use the pbus.
To keep this change transparent across drivers and SoCs, add new
ops that divides the rate by 2 before sending the request to the
modem.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-pcom.c      |   29 +++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-pcom.h      |    1 +
 arch/arm/mach-msm/devices-msm7x30.c |    9 ++++++++-
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index 358e065..4616bbc 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -188,3 +188,32 @@ struct clk_ops clk_ops_pcom = {
 	.round_rate = pc_clk_round_rate,
 	.is_local = pc_clk_is_local,
 };
+
+int pc_clk_set_rate2(unsigned id, unsigned rate)
+{
+	return pc_clk_set_rate(id, rate / 2);
+}
+
+int pc_clk_set_min_rate2(unsigned id, unsigned rate)
+{
+	return pc_clk_set_min_rate(id, rate / 2);
+}
+
+unsigned pc_clk_get_rate2(unsigned id)
+{
+	return pc_clk_get_rate(id) * 2;
+}
+
+struct clk_ops clk_ops_pcom_div2 = {
+	.enable = pc_clk_enable,
+	.disable = pc_clk_disable,
+	.reset = pc_clk_reset,
+	.set_rate = pc_clk_set_rate2,
+	.set_min_rate = pc_clk_set_min_rate2,
+	.set_flags = pc_clk_set_flags,
+	.get_rate = pc_clk_get_rate2,
+	.measure_rate = pc_clk_measure_rate,
+	.is_enabled = pc_clk_is_enabled,
+	.round_rate = pc_clk_round_rate,
+	.is_local = pc_clk_is_local,
+};
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 2c813f1..e2bca82 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -139,6 +139,7 @@
 
 struct clk_ops;
 extern struct clk_ops clk_ops_pcom;
+extern struct clk_ops clk_ops_pcom_div2;
 
 int pc_clk_reset(unsigned id, enum clk_reset_action action);
 
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 55382c4..72da7cc 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -68,7 +68,14 @@ struct clk msm_clocks_7x30[] = {
 	CLK_PCOM("uart_clk",	UART3_CLK,	NULL, OFF),
 	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
 	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF | CLK_MIN),
-	CLK_PCOM("pbus_clk",	PBUS_CLK,	NULL, CLK_MIN),
+	{
+		.name = "pbus_clk",
+		.id = P_PBUS_CLK,
+		.remote_id = P_PBUS_CLK,
+		.ops = &clk_ops_pcom_div2,
+		.flags = CLK_MIN,
+		.dbg_name = "pbus_clk",
+	},
 
 	CLK_7X30("adm_clk",	ADM_CLK,	NULL, 0),
 	CLK_7X30L("adm_pclk",   ADM_P_CLK,       NULL, 0),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

