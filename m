Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2IUC3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:29:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1205 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab2IUC1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:27:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="237156937"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 05/10] ARM: msm: Remove custom clk_set_flags() API
Date: Thu, 20 Sep 2012 19:26:53 -0700
Message-Id: <1348194419-11486-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
In-Reply-To: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody is using this API upstream and it's just contributing
cruft. Remove it so the MSM clock API is closer to the generic
struct clock API.

Cc: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-pcom.c       | 10 ----------
 arch/arm/mach-msm/clock.c            |  8 --------
 arch/arm/mach-msm/clock.h            |  6 ------
 arch/arm/mach-msm/include/mach/clk.h |  3 ---
 4 files changed, 27 deletions(-)

diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index a52c970..bb75f8e 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -85,15 +85,6 @@ static int pc_clk_set_max_rate(unsigned id, unsigned rate)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static int pc_clk_set_flags(unsigned id, unsigned flags)
-{
-	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_FLAGS, &id, &flags);
-	if (rc < 0)
-		return rc;
-	else
-		return (int)id < 0 ? -EINVAL : 0;
-}
-
 static unsigned pc_clk_get_rate(unsigned id)
 {
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_RATE, &id, NULL))
@@ -130,7 +121,6 @@ struct clk_ops clk_ops_pcom = {
 	.set_rate = pc_clk_set_rate,
 	.set_min_rate = pc_clk_set_min_rate,
 	.set_max_rate = pc_clk_set_max_rate,
-	.set_flags = pc_clk_set_flags,
 	.get_rate = pc_clk_get_rate,
 	.is_enabled = pc_clk_is_enabled,
 	.round_rate = pc_clk_round_rate,
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index d9145df..5fac2df 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -121,14 +121,6 @@ struct clk *clk_get_parent(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_get_parent);
 
-int clk_set_flags(struct clk *clk, unsigned long flags)
-{
-	if (clk == NULL || IS_ERR(clk))
-		return -EINVAL;
-	return clk->ops->set_flags(clk->id, flags);
-}
-EXPORT_SYMBOL(clk_set_flags);
-
 /* EBI1 is the only shared clock that several clients want to vote on as of
  * this commit. If this changes in the future, then it might be better to
  * make clk_min_rate handle the voting or make ebi1_clk_set_min_rate more
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 2c007f6..a25ff58 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -21,11 +21,6 @@
 #include <linux/list.h>
 #include <mach/clk.h>
 
-#define CLKFLAG_INVERT			0x00000001
-#define CLKFLAG_NOINVERT		0x00000002
-#define CLKFLAG_NONEST			0x00000004
-#define CLKFLAG_NORESET			0x00000008
-
 #define CLK_FIRST_AVAILABLE_FLAG	0x00000100
 #define CLKFLAG_AUTO_OFF		0x00000200
 #define CLKFLAG_MIN			0x00000400
@@ -39,7 +34,6 @@ struct clk_ops {
 	int (*set_rate)(unsigned id, unsigned rate);
 	int (*set_min_rate)(unsigned id, unsigned rate);
 	int (*set_max_rate)(unsigned id, unsigned rate);
-	int (*set_flags)(unsigned id, unsigned flags);
 	unsigned (*get_rate)(unsigned id);
 	unsigned (*is_enabled)(unsigned id);
 	long (*round_rate)(unsigned id, unsigned rate);
diff --git a/arch/arm/mach-msm/include/mach/clk.h b/arch/arm/mach-msm/include/mach/clk.h
index e8d3842..5f1c37d 100644
--- a/arch/arm/mach-msm/include/mach/clk.h
+++ b/arch/arm/mach-msm/include/mach/clk.h
@@ -34,7 +34,4 @@ int clk_set_max_rate(struct clk *clk, unsigned long rate);
 /* Assert/Deassert reset to a hardware block associated with a clock */
 int clk_reset(struct clk *clk, enum clk_reset_action action);
 
-/* Set clock-specific configuration parameters */
-int clk_set_flags(struct clk *clk, unsigned long flags);
-
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

