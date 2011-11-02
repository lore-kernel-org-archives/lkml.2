Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895Ab1KBSl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:41:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab1KBShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706977"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 12/34] msm: clock: Make most clk_*() operations optional
Date: Wed,  2 Nov 2011 11:36:09 -0700
Message-Id: <1320258991-22325-13-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Not all clock drivers want to implement support for all the
clk_*() operations. Since only clk_enable(), clk_disable(), and
clk_set_rate() are mandatory, allow the other clk_*() functions
to be optionally implemented by subdrivers. Also make
clk_enable() and clk_disable() optional so that clocks with no
on/off support don't have to define empty clk_enable/disable ops.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index ad55eaa..b571a95 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -1,7 +1,7 @@
 /* arch/arm/mach-msm/clock.c
  *
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2007-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2007-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -45,7 +45,8 @@ int clk_enable(struct clk *clk)
 		if (ret)
 			goto out;
 
-		ret = clk->ops->enable(clk);
+		if (clk->ops->enable)
+			ret = clk->ops->enable(clk);
 		if (ret) {
 			clk_disable(parent);
 			goto out;
@@ -70,7 +71,8 @@ void clk_disable(struct clk *clk)
 	BUG_ON(clk->count == 0);
 	clk->count--;
 	if (clk->count == 0) {
-		clk->ops->disable(clk);
+		if (clk->ops->disable)
+			clk->ops->disable(clk);
 		parent = clk_get_parent(clk);
 		clk_disable(parent);
 	}
@@ -80,12 +82,18 @@ EXPORT_SYMBOL(clk_disable);
 
 int clk_reset(struct clk *clk, enum clk_reset_action action)
 {
+	if (!clk->ops->reset)
+		return -ENOSYS;
+
 	return clk->ops->reset(clk, action);
 }
 EXPORT_SYMBOL(clk_reset);
 
 unsigned long clk_get_rate(struct clk *clk)
 {
+	if (!clk->ops->get_rate)
+		return 0;
+
 	return clk->ops->get_rate(clk);
 }
 EXPORT_SYMBOL(clk_get_rate);
@@ -93,6 +101,10 @@ EXPORT_SYMBOL(clk_get_rate);
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	int ret;
+
+	if (!clk->ops->set_rate)
+		return -ENOSYS;
+
 	if (clk->flags & CLKFLAG_MAX) {
 		ret = clk->ops->set_max_rate(clk, rate);
 		if (ret)
@@ -113,36 +125,46 @@ EXPORT_SYMBOL(clk_set_rate);
 
 long clk_round_rate(struct clk *clk, unsigned long rate)
 {
+	if (!clk->ops->round_rate)
+		return -ENOSYS;
+
 	return clk->ops->round_rate(clk, rate);
 }
 EXPORT_SYMBOL(clk_round_rate);
 
 int clk_set_min_rate(struct clk *clk, unsigned long rate)
 {
+	if (!clk->ops->set_min_rate)
+		return -ENOSYS;
+
 	return clk->ops->set_min_rate(clk, rate);
 }
 EXPORT_SYMBOL(clk_set_min_rate);
 
 int clk_set_max_rate(struct clk *clk, unsigned long rate)
 {
+	if (!clk->ops->set_max_rate)
+		return -ENOSYS;
+
 	return clk->ops->set_max_rate(clk, rate);
 }
 EXPORT_SYMBOL(clk_set_max_rate);
 
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
-	if (clk->ops->set_parent)
-		return clk->ops->set_parent(clk, parent);
-	return -ENOSYS;
+	if (!clk->ops->set_parent)
+		return 0;
+
+	return clk->ops->set_parent(clk, parent);
 }
 EXPORT_SYMBOL(clk_set_parent);
 
 struct clk *clk_get_parent(struct clk *clk)
 {
-	if (clk->ops->get_parent)
-		return clk->ops->get_parent(clk);
+	if (!clk->ops->get_parent)
+		return NULL;
 
-	return NULL;
+	return clk->ops->get_parent(clk);
 }
 EXPORT_SYMBOL(clk_get_parent);
 
@@ -150,6 +172,9 @@ int clk_set_flags(struct clk *clk, unsigned long flags)
 {
 	if (clk == NULL || IS_ERR(clk))
 		return -EINVAL;
+	if (!clk->ops->set_flags)
+		return -ENOSYS;
+
 	return clk->ops->set_flags(clk, flags);
 }
 EXPORT_SYMBOL(clk_set_flags);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

