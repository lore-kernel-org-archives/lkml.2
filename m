Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2KTJWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:22:32 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58332 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:22:28 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Date: Tue, 20 Nov 2012 01:22:17 -0800
Message-Id: <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need to invoke clk_unprepare() via a pointer in our devm_*
conversion so let's uninline the pair.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/clk/clk.c   |  4 ++++
 include/linux/clk.h | 68 +++++++++++++++++++++++++----------------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 56e4495e..1b642f2 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -374,6 +374,7 @@ struct clk *__clk_lookup(const char *name)
 
 void __clk_unprepare(struct clk *clk)
 {
+#ifdef CONFIG_HAVE_CLK_PREPARE
 	if (!clk)
 		return;
 
@@ -389,6 +390,7 @@ void __clk_unprepare(struct clk *clk)
 		clk->ops->unprepare(clk->hw);
 
 	__clk_unprepare(clk->parent);
+#endif
 }
 
 /**
@@ -412,6 +414,7 @@ EXPORT_SYMBOL_GPL(clk_unprepare);
 
 int __clk_prepare(struct clk *clk)
 {
+#ifdef CONFIG_HAVE_CLK_PREPARE
 	int ret = 0;
 
 	if (!clk)
@@ -432,6 +435,7 @@ int __clk_prepare(struct clk *clk)
 	}
 
 	clk->prepare_count++;
+#endif
 
 	return 0;
 }
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b3ac22d..f8204c3 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -84,42 +84,6 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
 
 #endif
 
-/**
- * clk_prepare - prepare a clock source
- * @clk: clock source
- *
- * This prepares the clock source for use.
- *
- * Must not be called from within atomic context.
- */
-#ifdef CONFIG_HAVE_CLK_PREPARE
-int clk_prepare(struct clk *clk);
-#else
-static inline int clk_prepare(struct clk *clk)
-{
-	might_sleep();
-	return 0;
-}
-#endif
-
-/**
- * clk_unprepare - undo preparation of a clock source
- * @clk: clock source
- *
- * This undoes a previously prepared clock.  The caller must balance
- * the number of prepare and unprepare calls.
- *
- * Must not be called from within atomic context.
- */
-#ifdef CONFIG_HAVE_CLK_PREPARE
-void clk_unprepare(struct clk *clk);
-#else
-static inline void clk_unprepare(struct clk *clk)
-{
-	might_sleep();
-}
-#endif
-
 #ifdef CONFIG_HAVE_CLK
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
@@ -159,6 +123,27 @@ struct clk *clk_get(struct device *dev, const char *id);
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
 /**
+ * clk_prepare - prepare a clock source
+ * @clk: clock source
+ *
+ * This prepares the clock source for use.
+ *
+ * Must not be called from within atomic context.
+ */
+int clk_prepare(struct clk *clk);
+
+/**
+ * clk_unprepare - undo preparation of a clock source
+ * @clk: clock source
+ *
+ * This undoes a previously prepared clock.  The caller must balance
+ * the number of prepare and unprepare calls.
+ *
+ * Must not be called from within atomic context.
+ */
+void clk_unprepare(struct clk *clk);
+
+/**
  * clk_enable - inform the system when the clock source should be running.
  * @clk: clock source
  *
@@ -292,6 +277,17 @@ static inline void clk_put(struct clk *clk) {}
 
 static inline void devm_clk_put(struct device *dev, struct clk *clk) {}
 
+static inline int clk_prepare(struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+
+static inline void clk_unprepare(struct clk *clk)
+{
+	might_sleep();
+}
+
 static inline int clk_enable(struct clk *clk)
 {
 	return 0;
-- 
1.7.11.7

