Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab1KBShM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:37:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593Ab1KBSg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:36:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706948"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 03/34] msm: clock: Pass struct clk to the clk_ops
Date: Wed,  2 Nov 2011 11:36:00 -0700
Message-Id: <1320258991-22325-4-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-debug.c |    8 ++++----
 arch/arm/mach-msm/clock-pcom.c  |   31 ++++++++++++++++++++-----------
 arch/arm/mach-msm/clock-pcom.h  |    2 +-
 arch/arm/mach-msm/clock.c       |   24 ++++++++++++------------
 arch/arm/mach-msm/clock.h       |   24 ++++++++++++------------
 5 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index 4886404..bddcbc9 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -55,9 +55,9 @@ static int clock_debug_enable_set(void *data, u64 val)
 	int rc = 0;
 
 	if (val)
-		rc = clock->ops->enable(clock->id);
+		rc = clock->ops->enable(clock);
 	else
-		clock->ops->disable(clock->id);
+		clock->ops->disable(clock);
 
 	return rc;
 }
@@ -66,7 +66,7 @@ static int clock_debug_enable_get(void *data, u64 *val)
 {
 	struct clk *clock = data;
 
-	*val = clock->ops->is_enabled(clock->id);
+	*val = clock->ops->is_enabled(clock);
 
 	return 0;
 }
@@ -78,7 +78,7 @@ static int clock_debug_local_get(void *data, u64 *val)
 {
 	struct clk *clock = data;
 
-	*val = clock->ops->is_local(clock->id);
+	*val = clock->ops->is_local(clock);
 
 	return 0;
 }
diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index a52c970..ee5f7fe 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -25,8 +25,9 @@
 /*
  * glue for the proc_comm interface
  */
-static int pc_clk_enable(unsigned id)
+static int pc_clk_enable(struct clk *clk)
 {
+	unsigned id = clk->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_ENABLE, &id, NULL);
 	if (rc < 0)
 		return rc;
@@ -34,14 +35,16 @@ static int pc_clk_enable(unsigned id)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static void pc_clk_disable(unsigned id)
+static void pc_clk_disable(struct clk *clk)
 {
+	unsigned id = clk->id;
 	msm_proc_comm(PCOM_CLKCTL_RPC_DISABLE, &id, NULL);
 }
 
-int pc_clk_reset(unsigned id, enum clk_reset_action action)
+int pc_clk_reset(struct clk *clk, enum clk_reset_action action)
 {
 	int rc;
+	unsigned id = clk->id;
 
 	if (action == CLK_RESET_ASSERT)
 		rc = msm_proc_comm(PCOM_CLKCTL_RPC_RESET_ASSERT, &id, NULL);
@@ -54,12 +57,13 @@ int pc_clk_reset(unsigned id, enum clk_reset_action action)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static int pc_clk_set_rate(unsigned id, unsigned rate)
+static int pc_clk_set_rate(struct clk *clk, unsigned rate)
 {
 	/* The rate _might_ be rounded off to the nearest KHz value by the
 	 * remote function. So a return value of 0 doesn't necessarily mean
 	 * that the exact rate was set successfully.
 	 */
+	unsigned id = clk->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_RATE, &id, &rate);
 	if (rc < 0)
 		return rc;
@@ -67,8 +71,9 @@ static int pc_clk_set_rate(unsigned id, unsigned rate)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static int pc_clk_set_min_rate(unsigned id, unsigned rate)
+static int pc_clk_set_min_rate(struct clk *clk, unsigned rate)
 {
+	unsigned id = clk->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
 	if (rc < 0)
 		return rc;
@@ -76,8 +81,9 @@ static int pc_clk_set_min_rate(unsigned id, unsigned rate)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static int pc_clk_set_max_rate(unsigned id, unsigned rate)
+static int pc_clk_set_max_rate(struct clk *clk, unsigned rate)
 {
+	unsigned id = clk->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MAX_RATE, &id, &rate);
 	if (rc < 0)
 		return rc;
@@ -85,8 +91,9 @@ static int pc_clk_set_max_rate(unsigned id, unsigned rate)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static int pc_clk_set_flags(unsigned id, unsigned flags)
+static int pc_clk_set_flags(struct clk *clk, unsigned flags)
 {
+	unsigned id = clk->id;
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_FLAGS, &id, &flags);
 	if (rc < 0)
 		return rc;
@@ -94,30 +101,32 @@ static int pc_clk_set_flags(unsigned id, unsigned flags)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-static unsigned pc_clk_get_rate(unsigned id)
+static unsigned pc_clk_get_rate(struct clk *clk)
 {
+	unsigned id = clk->id;
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_RATE, &id, NULL))
 		return 0;
 	else
 		return id;
 }
 
-static unsigned pc_clk_is_enabled(unsigned id)
+static unsigned pc_clk_is_enabled(struct clk *clk)
 {
+	unsigned id = clk->id;
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_ENABLED, &id, NULL))
 		return 0;
 	else
 		return id;
 }
 
-static long pc_clk_round_rate(unsigned id, unsigned rate)
+static long pc_clk_round_rate(struct clk *clk, unsigned rate)
 {
 
 	/* Not really supported; pc_clk_set_rate() does rounding on it's own. */
 	return rate;
 }
 
-static bool pc_clk_is_local(unsigned id)
+static bool pc_clk_is_local(struct clk *clk)
 {
 	return false;
 }
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 974d003..9a695f9 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -123,7 +123,7 @@
 struct clk_ops;
 extern struct clk_ops clk_ops_pcom;
 
-int pc_clk_reset(unsigned id, enum clk_reset_action action);
+int pc_clk_reset(struct clk *clk, enum clk_reset_action action);
 
 #define CLK_PCOM(clk_name, clk_id, clk_dev, clk_flags) {	\
 	.con_id = clk_name, \
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index e23e4c2..a9dabde 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -37,7 +37,7 @@ int clk_enable(struct clk *clk)
 	spin_lock_irqsave(&clocks_lock, flags);
 	clk->count++;
 	if (clk->count == 1)
-		clk->ops->enable(clk->id);
+		clk->ops->enable(clk);
 	spin_unlock_irqrestore(&clocks_lock, flags);
 	return 0;
 }
@@ -50,20 +50,20 @@ void clk_disable(struct clk *clk)
 	BUG_ON(clk->count == 0);
 	clk->count--;
 	if (clk->count == 0)
-		clk->ops->disable(clk->id);
+		clk->ops->disable(clk);
 	spin_unlock_irqrestore(&clocks_lock, flags);
 }
 EXPORT_SYMBOL(clk_disable);
 
 int clk_reset(struct clk *clk, enum clk_reset_action action)
 {
-	return clk->ops->reset(clk->remote_id, action);
+	return clk->ops->reset(clk, action);
 }
 EXPORT_SYMBOL(clk_reset);
 
 unsigned long clk_get_rate(struct clk *clk)
 {
-	return clk->ops->get_rate(clk->id);
+	return clk->ops->get_rate(clk);
 }
 EXPORT_SYMBOL(clk_get_rate);
 
@@ -71,12 +71,12 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	int ret;
 	if (clk->flags & CLKFLAG_MAX) {
-		ret = clk->ops->set_max_rate(clk->id, rate);
+		ret = clk->ops->set_max_rate(clk, rate);
 		if (ret)
 			return ret;
 	}
 	if (clk->flags & CLKFLAG_MIN) {
-		ret = clk->ops->set_min_rate(clk->id, rate);
+		ret = clk->ops->set_min_rate(clk, rate);
 		if (ret)
 			return ret;
 	}
@@ -84,25 +84,25 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	if (clk->flags & CLKFLAG_MAX || clk->flags & CLKFLAG_MIN)
 		return ret;
 
-	return clk->ops->set_rate(clk->id, rate);
+	return clk->ops->set_rate(clk, rate);
 }
 EXPORT_SYMBOL(clk_set_rate);
 
 long clk_round_rate(struct clk *clk, unsigned long rate)
 {
-	return clk->ops->round_rate(clk->id, rate);
+	return clk->ops->round_rate(clk, rate);
 }
 EXPORT_SYMBOL(clk_round_rate);
 
 int clk_set_min_rate(struct clk *clk, unsigned long rate)
 {
-	return clk->ops->set_min_rate(clk->id, rate);
+	return clk->ops->set_min_rate(clk, rate);
 }
 EXPORT_SYMBOL(clk_set_min_rate);
 
 int clk_set_max_rate(struct clk *clk, unsigned long rate)
 {
-	return clk->ops->set_max_rate(clk->id, rate);
+	return clk->ops->set_max_rate(clk, rate);
 }
 EXPORT_SYMBOL(clk_set_max_rate);
 
@@ -122,7 +122,7 @@ int clk_set_flags(struct clk *clk, unsigned long flags)
 {
 	if (clk == NULL || IS_ERR(clk))
 		return -EINVAL;
-	return clk->ops->set_flags(clk->id, flags);
+	return clk->ops->set_flags(clk, flags);
 }
 EXPORT_SYMBOL(clk_set_flags);
 
@@ -164,7 +164,7 @@ static int __init clock_late_init(void)
 			spin_lock_irqsave(&clocks_lock, flags);
 			if (!clk->count) {
 				count++;
-				clk->ops->auto_off(clk->id);
+				clk->ops->auto_off(clk);
 			}
 			spin_unlock_irqrestore(&clocks_lock, flags);
 		}
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 32a43d4..7fe1598 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -32,18 +32,18 @@
 #define CLKFLAG_MAX			0x00000800
 
 struct clk_ops {
-	int (*enable)(unsigned id);
-	void (*disable)(unsigned id);
-	void (*auto_off)(unsigned id);
-	int (*reset)(unsigned id, enum clk_reset_action action);
-	int (*set_rate)(unsigned id, unsigned rate);
-	int (*set_min_rate)(unsigned id, unsigned rate);
-	int (*set_max_rate)(unsigned id, unsigned rate);
-	int (*set_flags)(unsigned id, unsigned flags);
-	unsigned (*get_rate)(unsigned id);
-	unsigned (*is_enabled)(unsigned id);
-	long (*round_rate)(unsigned id, unsigned rate);
-	bool (*is_local)(unsigned id);
+	int (*enable)(struct clk *clk);
+	void (*disable)(struct clk *clk);
+	void (*auto_off)(struct clk *clk);
+	int (*reset)(struct clk *clk, enum clk_reset_action action);
+	int (*set_rate)(struct clk *clk, unsigned rate);
+	int (*set_min_rate)(struct clk *clk, unsigned rate);
+	int (*set_max_rate)(struct clk *clk, unsigned rate);
+	int (*set_flags)(struct clk *clk, unsigned flags);
+	unsigned (*get_rate)(struct clk *clk);
+	unsigned (*is_enabled)(struct clk *clk);
+	long (*round_rate)(struct clk *clk, unsigned rate);
+	bool (*is_local)(struct clk *clk);
 };
 
 struct clk {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

