Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab1KBSmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:42:03 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272Ab1KBShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706985"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 16/34] msm: clock-pcom: Expose pc_clk_reset
Date: Wed,  2 Nov 2011 11:36:13 -0700
Message-Id: <1320258991-22325-17-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The 7x30 clock driver needs to perform clock resets and the only
way that is possible is through proc_comm. Expose the reset
functionality as a new function callable from the 7x30 clock
driver.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-pcom.c |   13 +++++++++----
 arch/arm/mach-msm/clock-pcom.h |    2 ++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index e11ef57..f441247 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -41,10 +41,9 @@ static void pc_clk_disable(struct clk *clk)
 	msm_proc_comm(PCOM_CLKCTL_RPC_DISABLE, &id, NULL);
 }
 
-int pc_clk_reset(struct clk *clk, enum clk_reset_action action)
+int pc_clk_reset(unsigned id, enum clk_reset_action action)
 {
 	int rc;
-	unsigned id = to_pcom_clk(clk)->id;
 
 	if (action == CLK_RESET_ASSERT)
 		rc = msm_proc_comm(PCOM_CLKCTL_RPC_RESET_ASSERT, &id, NULL);
@@ -57,6 +56,12 @@ int pc_clk_reset(struct clk *clk, enum clk_reset_action action)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
+static int pc_reset(struct clk *clk, enum clk_reset_action action)
+{
+	unsigned id = to_pcom_clk(clk)->id;
+	return pc_clk_reset(id, action);
+}
+
 static int pc_clk_set_rate(struct clk *clk, unsigned rate)
 {
 	/* The rate _might_ be rounded off to the nearest KHz value by the
@@ -135,7 +140,7 @@ struct clk_ops clk_ops_pcom = {
 	.enable = pc_clk_enable,
 	.disable = pc_clk_disable,
 	.auto_off = pc_clk_disable,
-	.reset = pc_clk_reset,
+	.reset = pc_reset,
 	.set_rate = pc_clk_set_rate,
 	.set_min_rate = pc_clk_set_min_rate,
 	.set_max_rate = pc_clk_set_max_rate,
@@ -165,7 +170,7 @@ struct clk_ops clk_ops_pcom_div2 = {
 	.enable = pc_clk_enable,
 	.disable = pc_clk_disable,
 	.auto_off = pc_clk_disable,
-	.reset = pc_clk_reset,
+	.reset = pc_reset,
 	.set_rate = pc_clk_set_rate2,
 	.set_min_rate = pc_clk_set_min_rate2,
 	.set_flags = pc_clk_set_flags,
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 23807ff..c3beb47 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -120,6 +120,8 @@
 
 #define P_NR_CLKS		102
 
+extern int pc_clk_reset(unsigned id, enum clk_reset_action action);
+
 struct clk_ops;
 extern struct clk_ops clk_ops_pcom;
 extern struct clk_ops clk_ops_pcom_div2;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

