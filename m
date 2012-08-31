Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2HaMWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:22:15 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:60193 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab2HaMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:22:11 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 1/4] clk: Provide option for clk_get_rate to issue hw for new rate
Date: Fri, 31 Aug 2012 14:21:28 +0200
Message-ID: <1346415691-13371-2-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

By using CLK_GET_RATE_NOCACHE flag, we tell the clk_get_rate API to
issue the hw for an updated clock rate. This can be used for a clock
which rate may be updated without a client necessary modifying it.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/clk/clk.c            |   43 +++++++++++++++++++++++-------------------
 include/linux/clk-provider.h |    1 +
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index efdfd00..d9cbae0 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -558,25 +558,6 @@ int clk_enable(struct clk *clk)
 EXPORT_SYMBOL_GPL(clk_enable);
 
 /**
- * clk_get_rate - return the rate of clk
- * @clk: the clk whose rate is being returned
- *
- * Simply returns the cached rate of the clk.  Does not query the hardware.  If
- * clk is NULL then returns 0.
- */
-unsigned long clk_get_rate(struct clk *clk)
-{
-	unsigned long rate;
-
-	mutex_lock(&prepare_lock);
-	rate = __clk_get_rate(clk);
-	mutex_unlock(&prepare_lock);
-
-	return rate;
-}
-EXPORT_SYMBOL_GPL(clk_get_rate);
-
-/**
  * __clk_round_rate - round the given rate for a clk
  * @clk: round the rate of this clock
  *
@@ -702,6 +683,30 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
 }
 
 /**
+ * clk_get_rate - return the rate of clk
+ * @clk: the clk whose rate is being returned
+ *
+ * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
+ * is set, which means a recalc_rate will be issued.
+ * If clk is NULL then returns 0.
+ */
+unsigned long clk_get_rate(struct clk *clk)
+{
+	unsigned long rate;
+
+	mutex_lock(&prepare_lock);
+
+	if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
+		__clk_recalc_rates(clk, 0);
+
+	rate = __clk_get_rate(clk);
+	mutex_unlock(&prepare_lock);
+
+	return rate;
+}
+EXPORT_SYMBOL_GPL(clk_get_rate);
+
+/**
  * __clk_speculate_rates
  * @clk: first clk in the subtree
  * @parent_rate: the "future" rate of clk's parent
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 77335fa..1b15307 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -26,6 +26,7 @@
 #define CLK_IGNORE_UNUSED	BIT(3) /* do not gate even if unused */
 #define CLK_IS_ROOT		BIT(4) /* root clk, has no parent */
 #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
+#define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
 
 struct clk_hw;
 
-- 
1.7.10

