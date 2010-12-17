Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab0LQAwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:52:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29788 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab0LQAuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160033"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 13/22] msm: clock: Push down clock count and locking into sub drivers
Date: Thu, 16 Dec 2010 16:49:57 -0800
Message-Id: <1292547006-19741-14-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock voting code will need to call clk_set_rate() from
within a spinlock so we must push down the refcount and lock into
each sub driver to avoid recursive locking.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-local.c |    3 +-
 arch/arm/mach-msm/clock-pcom.c  |   59 ++++++++++++++++++++++++++++++++++----
 arch/arm/mach-msm/clock.c       |   32 ++------------------
 arch/arm/mach-msm/clock.h       |    1 -
 4 files changed, 58 insertions(+), 37 deletions(-)

diff --git a/arch/arm/mach-msm/clock-local.c b/arch/arm/mach-msm/clock-local.c
index f80efa6..86b5a9d 100644
--- a/arch/arm/mach-msm/clock-local.c
+++ b/arch/arm/mach-msm/clock-local.c
@@ -501,7 +501,8 @@ void local_clk_auto_off(unsigned id)
 		return;
 
 	spin_lock_irqsave(&local_clock_reg_lock, flags);
-	local_clk_disable_reg(id);
+	if (clk->count == 0)
+		local_clk_disable_reg(id);
 	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
 }
 
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index 2f9d0d4..358e065 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -16,27 +16,72 @@
 #include <linux/err.h>
 #include <linux/ctype.h>
 #include <linux/stddef.h>
+#include <linux/spinlock.h>
+
 #include <mach/clk.h>
 
 #include "proc_comm.h"
 #include "clock.h"
 #include "clock-pcom.h"
 
+struct clk_pcom {
+	unsigned count;
+};
+
+static struct clk_pcom pcom_clocks[P_NR_CLKS];
+
+static DEFINE_SPINLOCK(pc_clk_lock);
+
 /*
  * glue for the proc_comm interface
  */
 int pc_clk_enable(unsigned id)
 {
-	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_ENABLE, &id, NULL);
-	if (rc < 0)
-		return rc;
-	else
-		return (int)id < 0 ? -EINVAL : 0;
+	int rc;
+	unsigned long flags;
+	struct clk_pcom *clk = &pcom_clocks[id];
+
+	spin_lock_irqsave(&pc_clk_lock, flags);
+	if (clk->count == 0) {
+		rc = msm_proc_comm(PCOM_CLKCTL_RPC_ENABLE, &id, NULL);
+		if (rc < 0)
+			goto unlock;
+		else if ((int)id < 0) {
+			rc = -EINVAL;
+			goto unlock;
+		} else
+			rc = 0;
+	}
+	clk->count++;
+unlock:
+	spin_unlock_irqrestore(&pc_clk_lock, flags);
+	return rc;
 }
 
 void pc_clk_disable(unsigned id)
 {
-	msm_proc_comm(PCOM_CLKCTL_RPC_DISABLE, &id, NULL);
+	unsigned long flags;
+	struct clk_pcom *clk = &pcom_clocks[id];
+
+	spin_lock_irqsave(&pc_clk_lock, flags);
+	if (WARN_ON(clk->count == 0))
+		goto out;
+	clk->count--;
+	if (clk->count == 0)
+		msm_proc_comm(PCOM_CLKCTL_RPC_DISABLE, &id, NULL);
+out:
+	spin_unlock_irqrestore(&pc_clk_lock, flags);
+}
+
+void pc_clk_auto_off(unsigned id)
+{
+	unsigned long flags;
+	struct clk_pcom *clk = &pcom_clocks[id];
+
+	spin_lock_irqsave(&pc_clk_lock, flags);
+	if (clk->count == 0)
+		msm_proc_comm(PCOM_CLKCTL_RPC_DISABLE, &id, NULL);
+	spin_unlock_irqrestore(&pc_clk_lock, flags);
 }
 
 int pc_clk_reset(unsigned id, enum clk_reset_action action)
@@ -131,7 +176,7 @@ static bool pc_clk_is_local(unsigned id)
 struct clk_ops clk_ops_pcom = {
 	.enable = pc_clk_enable,
 	.disable = pc_clk_disable,
-	.auto_off = pc_clk_disable,
+	.auto_off = pc_clk_auto_off,
 	.reset = pc_clk_reset,
 	.set_rate = pc_clk_set_rate,
 	.set_min_rate = pc_clk_set_min_rate,
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 06cd313..80e1d64 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -23,7 +23,6 @@
 #include "clock.h"
 
 static DEFINE_MUTEX(clocks_mutex);
-static DEFINE_SPINLOCK(clocks_lock);
 static LIST_HEAD(clocks);
 
 /*
@@ -57,25 +56,13 @@ EXPORT_SYMBOL(clk_put);
 
 int clk_enable(struct clk *clk)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&clocks_lock, flags);
-	clk->count++;
-	if (clk->count == 1)
-		clk->ops->enable(clk->id);
-	spin_unlock_irqrestore(&clocks_lock, flags);
-	return 0;
+	return clk->ops->enable(clk->id);
 }
 EXPORT_SYMBOL(clk_enable);
 
 void clk_disable(struct clk *clk)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&clocks_lock, flags);
-	BUG_ON(clk->count == 0);
-	clk->count--;
-	if (clk->count == 0)
-		clk->ops->disable(clk->id);
-	spin_unlock_irqrestore(&clocks_lock, flags);
+	clk->ops->disable(clk->id);
 }
 EXPORT_SYMBOL(clk_disable);
 
@@ -182,27 +169,16 @@ void __init msm_clock_init(struct clk *clock_tbl, unsigned num_clocks)
  */
 static int __init clock_late_init(void)
 {
-	unsigned long flags;
 	struct clk *clk;
-	unsigned count = 0;
 
 	clock_debug_init();
 	mutex_lock(&clocks_mutex);
 	list_for_each_entry(clk, &clocks, list) {
 		clock_debug_add(clk);
-		if (clk->flags & CLKFLAG_AUTO_OFF) {
-			spin_lock_irqsave(&clocks_lock, flags);
-			if (!clk->count) {
-				count++;
-				clk->ops->auto_off(clk->id);
-			}
-			spin_unlock_irqrestore(&clocks_lock, flags);
-		}
+		if (clk->flags & CLKFLAG_AUTO_OFF)
+			clk->ops->auto_off(clk->id);
 	}
 	mutex_unlock(&clocks_mutex);
-	pr_info("clock_late_init() disabled %d unused clocks\n", count);
 	return 0;
 }
-
 late_initcall(clock_late_init);
-
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 67f9d9e..4dc8853 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -51,7 +51,6 @@ struct clk_ops {
 struct clk {
 	uint32_t id;
 	uint32_t remote_id;
-	uint32_t count;
 	uint32_t flags;
 	const char *name;
 	struct clk_ops *ops;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

