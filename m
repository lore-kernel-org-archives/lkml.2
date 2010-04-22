Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab0DVUau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:30:50 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:62560 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab0DVUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:30:27 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Amit Kucheria <amit.kucheria@canonical.com>,
       Russell King <linux@arm.linux.org.uk>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] arm: mxc: utilise usecount field in clock operations
Date: Thu, 22 Apr 2010 23:30:20 +0300
Message-Id: <d501dcf8dbe98ed7f5aa9e7b34e68f0e1076ac84.1271968118.git.amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@canonical.com>

This patch fixes the clock refcounting when reparenting is used.

Sascha just pointed out a good explanation of refcounting here:
http://www.spinics.net/lists/arm-kernel/msg85879.html

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/clock.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/arm/plat-mxc/clock.c b/arch/arm/plat-mxc/clock.c
index 323ff8c..14781cc 100644
--- a/arch/arm/plat-mxc/clock.c
+++ b/arch/arm/plat-mxc/clock.c
@@ -50,15 +50,16 @@ static DEFINE_MUTEX(clocks_mutex);
 
 static void __clk_disable(struct clk *clk)
 {
-	if (clk == NULL || IS_ERR(clk))
+	WARN_ON(!clk->usecount);
+	if (clk == NULL || IS_ERR(clk) || !clk->usecount)
 		return;
 
-	__clk_disable(clk->parent);
-	__clk_disable(clk->secondary);
-
-	WARN_ON(!clk->usecount);
-	if (!(--clk->usecount) && clk->disable)
-		clk->disable(clk);
+	if (!(--clk->usecount)) {
+		if (clk->disable)
+			clk->disable(clk);
+		__clk_disable(clk->parent);
+		__clk_disable(clk->secondary);
+	}
 }
 
 static int __clk_enable(struct clk *clk)
@@ -66,12 +67,13 @@ static int __clk_enable(struct clk *clk)
 	if (clk == NULL || IS_ERR(clk))
 		return -EINVAL;
 
-	__clk_enable(clk->parent);
-	__clk_enable(clk->secondary);
-
-	if (clk->usecount++ == 0 && clk->enable)
-		clk->enable(clk);
+	if (clk->usecount++ == 0) {
+		__clk_enable(clk->parent);
+		__clk_enable(clk->secondary);
 
+		if (clk->enable)
+			clk->enable(clk);
+	}
 	return 0;
 }
 
@@ -160,17 +162,25 @@ EXPORT_SYMBOL(clk_set_rate);
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	int ret = -EINVAL;
+	struct clk *prev_parent = clk->parent;
 
 	if (clk == NULL || IS_ERR(clk) || parent == NULL ||
 	    IS_ERR(parent) || clk->set_parent == NULL)
 		return ret;
 
+	if (clk->usecount != 0)
+		clk_enable(parent);
+
 	mutex_lock(&clocks_mutex);
 	ret = clk->set_parent(clk, parent);
 	if (ret == 0)
 		clk->parent = parent;
+
 	mutex_unlock(&clocks_mutex);
 
+	if (clk->usecount != 0)
+		clk_disable(prev_parent);
+
 	return ret;
 }
 EXPORT_SYMBOL(clk_set_parent);
-- 
1.7.0.4

