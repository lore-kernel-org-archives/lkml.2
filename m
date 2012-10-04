Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965548Ab2JDGja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:39:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50792 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965493Ab2JDGjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:39:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6854"; a="245504057"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] clk: Don't return negative numbers for unsigned values with !clk
Date: Wed,  3 Oct 2012 23:38:55 -0700
Message-Id: <1349332735-20096-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349332735-20096-1-git-send-email-sboyd@codeaurora.org>
References: <1349332735-20096-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the helper functions return negative error codes if
passed a NULL clock. This can lead to confusing behavior when the
expected return value is unsigned. Fix up these accessors so that
they return unsigned values (or bool in the case of is_enabled).
This way we can't interpret NULL clocks as having valid and
interesting values.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 20 ++++++++++----------
 include/linux/clk-provider.h |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 6852809..2847a66 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -262,7 +262,7 @@ inline struct clk_hw *__clk_get_hw(struct clk *clk)
 
 inline u8 __clk_get_num_parents(struct clk *clk)
 {
-	return !clk ? -EINVAL : clk->num_parents;
+	return !clk ? 0 : clk->num_parents;
 }
 
 inline struct clk *__clk_get_parent(struct clk *clk)
@@ -270,14 +270,14 @@ inline struct clk *__clk_get_parent(struct clk *clk)
 	return !clk ? NULL : clk->parent;
 }
 
-inline int __clk_get_enable_count(struct clk *clk)
+inline unsigned int __clk_get_enable_count(struct clk *clk)
 {
-	return !clk ? -EINVAL : clk->enable_count;
+	return !clk ? 0 : clk->enable_count;
 }
 
-inline int __clk_get_prepare_count(struct clk *clk)
+inline unsigned int __clk_get_prepare_count(struct clk *clk)
 {
-	return !clk ? -EINVAL : clk->prepare_count;
+	return !clk ? 0 : clk->prepare_count;
 }
 
 unsigned long __clk_get_rate(struct clk *clk)
@@ -303,15 +303,15 @@ out:
 
 inline unsigned long __clk_get_flags(struct clk *clk)
 {
-	return !clk ? -EINVAL : clk->flags;
+	return !clk ? 0 : clk->flags;
 }
 
-int __clk_is_enabled(struct clk *clk)
+bool __clk_is_enabled(struct clk *clk)
 {
 	int ret;
 
 	if (!clk)
-		return -EINVAL;
+		return false;
 
 	/*
 	 * .is_enabled is only mandatory for clocks that gate
@@ -324,7 +324,7 @@ int __clk_is_enabled(struct clk *clk)
 
 	ret = clk->ops->is_enabled(clk->hw);
 out:
-	return ret;
+	return !!ret;
 }
 
 static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
@@ -569,7 +569,7 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 	unsigned long parent_rate = 0;
 
 	if (!clk)
-		return -EINVAL;
+		return 0;
 
 	if (!clk->ops->round_rate) {
 		if (clk->flags & CLK_SET_RATE_PARENT)
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 0571261..3593a3c 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -341,11 +341,11 @@ const char *__clk_get_name(struct clk *clk);
 struct clk_hw *__clk_get_hw(struct clk *clk);
 u8 __clk_get_num_parents(struct clk *clk);
 struct clk *__clk_get_parent(struct clk *clk);
-inline int __clk_get_enable_count(struct clk *clk);
-inline int __clk_get_prepare_count(struct clk *clk);
+inline unsigned int __clk_get_enable_count(struct clk *clk);
+inline unsigned int __clk_get_prepare_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
-int __clk_is_enabled(struct clk *clk);
+bool __clk_is_enabled(struct clk *clk);
 struct clk *__clk_lookup(const char *name);
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

