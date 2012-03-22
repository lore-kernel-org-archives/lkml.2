Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2CVIUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 04:20:37 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64829 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab2CVIUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 04:20:31 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mxs: enforce semantics of clk_prepare()/clk_unprepare() and clk_enable()/clk_disable()
Date: Thu, 22 Mar 2012 09:18:17 +0100
Message-Id: <1332404298-18891-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
To: Shawn Guo <shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After introducing clk_prepare()/clk_unprepare() there may still be
drivers out there that don't use the new functions.
This patch warns about drivers calling clk_enable() without a
preceding clk_prepare() and various other invalid sequences of calls
to clk_enable()/clk_disable() and clk_prepare()/clk_unprepare().

To not make a system unusable due to excessive warning messages the
warnings are limited to 1 per clk by a flag in the 'flags' member of
struct clk.


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 arch/arm/mach-mxs/clock.c              |   98 ++++++++++++++++++++++++++++----
 arch/arm/mach-mxs/include/mach/clock.h |    6 ++
 2 files changed, 93 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-mxs/clock.c b/arch/arm/mach-mxs/clock.c
index 97a6f4a..4c23351 100644
--- a/arch/arm/mach-mxs/clock.c
+++ b/arch/arm/mach-mxs/clock.c
@@ -56,24 +56,61 @@ static void __clk_disable(struct clk *clk)
 	if (!(--clk->usecount)) {
 		if (clk->disable)
 			clk->disable(clk);
-		__clk_disable(clk->parent);
 	}
 }
 
 static int __clk_enable(struct clk *clk)
 {
-	if (clk == NULL || IS_ERR(clk))
-		return -EINVAL;
+	if (clk == NULL)
+		return 0;
 
-	if (clk->usecount++ == 0) {
-		__clk_enable(clk->parent);
+	if (IS_ERR(clk))
+		return -EINVAL;
 
-		if (clk->enable)
-			clk->enable(clk);
+	if (clk->usecount == 0) {
+		if (clk->enable) {
+			int ret = clk->enable(clk);
+			if (ret)
+				return ret;
+		}
 	}
+	clk->usecount++;
+
 	return 0;
 }
 
+static void __clk_unprepare(struct clk *clk)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return;
+
+	if (clk->parent)
+		__clk_unprepare(clk->parent);
+
+	__clk_disable(clk);
+}
+
+static int __clk_prepare(struct clk *clk)
+{
+	int ret;
+
+	if (clk == NULL)
+		return 0;
+
+	if (IS_ERR(clk))
+		return -EINVAL;
+
+	ret = __clk_prepare(clk->parent);
+	if (ret)
+		return ret;
+
+	ret = __clk_enable(clk);
+	if (ret)
+		__clk_unprepare(clk->parent);
+
+	return ret;
+}
+
 /*
  * The clk_enable/clk_disable could be called by drivers in atomic context,
  * so they should not really hold mutex.  Instead, clk_prepare/clk_unprepare
@@ -86,11 +123,18 @@ int clk_prepare(struct clk *clk)
 {
 	int ret = 0;
 
-	if (clk == NULL || IS_ERR(clk))
+	if (clk == NULL)
+		return 0;
+
+	if (IS_ERR(clk))
 		return -EINVAL;
 
 	mutex_lock(&clocks_mutex);
-	ret = __clk_enable(clk);
+	if (clk->prepared++ == 0) {
+		ret = __clk_prepare(clk);
+		if (ret)
+			clk->prepared--;
+	}
 	mutex_unlock(&clocks_mutex);
 
 	return ret;
@@ -103,20 +147,52 @@ void clk_unprepare(struct clk *clk)
 		return;
 
 	mutex_lock(&clocks_mutex);
-	__clk_disable(clk);
+	if (WARN_ON(!clk->prepared && !(clk->flags & CLK_WARNED))) {
+		pr_err("clk_unprepare() called without clk_prepare()\n");
+		clk->flags |= CLK_WARNED;
+	}
+	if (WARN_ON(clk->prepared == 1 && clk->usecount > 1)) {
+		pr_err("unbalanced calls (%d) to clk_enable()/clk_disable() before clk_unprepare()\n",
+			clk->usecount);
+		clk->flags |= CLK_WARNED;
+	}
+	if (!(--clk->prepared))
+		__clk_unprepare(clk);
 	mutex_unlock(&clocks_mutex);
 }
 EXPORT_SYMBOL(clk_unprepare);
 
 int clk_enable(struct clk *clk)
 {
+	if (clk == NULL)
+		return 0;
+
+	if (IS_ERR(clk))
+		return -EINVAL;
+
+	if (WARN_ON(!clk->prepared && !(clk->flags & CLK_WARNED))) {
+		pr_err("clk_enable() called without clk_prepare()\n");
+		clk->flags |= CLK_WARNED;
+	}
+	clk->usecount++;
 	return 0;
 }
 EXPORT_SYMBOL(clk_enable);
 
 void clk_disable(struct clk *clk)
 {
-	/* nothing to do */
+	if (clk == NULL || IS_ERR(clk))
+		return;
+
+	if (WARN_ON(!clk->prepared && !(clk->flags & CLK_WARNED))) {
+		pr_err("clk_disable() called without clk_prepare()\n");
+		clk->flags |= CLK_WARNED;
+	}
+	if (WARN_ON(clk->usecount <= 1 && !(clk->flags & CLK_WARNED))) {
+		pr_err("unbalanced clk_disable()\n");
+		clk->flags |= CLK_WARNED;
+	}
+	clk->usecount--;
 }
 EXPORT_SYMBOL(clk_disable);
 
diff --git a/arch/arm/mach-mxs/include/mach/clock.h b/arch/arm/mach-mxs/include/mach/clock.h
index 592c9ab..285ca6b 100644
--- a/arch/arm/mach-mxs/include/mach/clock.h
+++ b/arch/arm/mach-mxs/include/mach/clock.h
@@ -25,12 +25,18 @@
 
 struct module;
 
+enum clk_flags {
+	CLK_WARNED = 0x01,
+};
+
 struct clk {
 	int id;
 	/* Source clock this clk depends on */
 	struct clk *parent;
 	/* Reference count of clock enable/disable */
 	__s8 usecount;
+	/* Reference count of clock prepare/unprepare */
+	__s8 prepared;
 	/* Register bit position for clock's enable/disable control. */
 	u8 enable_shift;
 	/* Register address for clock's enable/disable control. */
-- 
1.7.2.5

