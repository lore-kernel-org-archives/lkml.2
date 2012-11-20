Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2KTJWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:22:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2KTJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:22:30 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] CLK: uninline clk_prepare_enable() and clk_disable_unprepare()
Date: Tue, 20 Nov 2012 01:22:18 -0800
Message-Id: <1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need to invoke clk_disable_unprepare() via a pointer in our devm_*
conversion so let's uninline the pair.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/clk/clk.c   | 23 +++++++++++++++++++++++
 include/linux/clk.h | 53 +++++++++++++++++++++++++++++++----------------------
 2 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1b642f2..69dc7ba 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -561,6 +561,29 @@ int clk_enable(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_enable);
 
+int clk_prepare_enable(struct clk *clk)
+{
+	int ret;
+
+	ret = clk_prepare(clk);
+	if (ret)
+		return ret;
+
+	ret = clk_enable(clk);
+	if (ret)
+		clk_unprepare(clk);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_prepare_enable);
+
+void clk_disable_unprepare(struct clk *clk)
+{
+	clk_disable(clk);
+	clk_unprepare(clk);
+}
+EXPORT_SYMBOL_GPL(clk_disable_unprepare);
+
 /**
  * __clk_round_rate - round the given rate for a clk
  * @clk: round the rate of this clock
diff --git a/include/linux/clk.h b/include/linux/clk.h
index f8204c3..8bf149e 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -172,6 +172,26 @@ int clk_enable(struct clk *clk);
 void clk_disable(struct clk *clk);
 
 /**
+ * clk_prepare_enable - prepare and enable a clock source
+ * @clk: clock source
+ *
+ * This prepares the clock source for use and enables it.
+ *
+ * Must not be called from within atomic context.
+ */
+int clk_prepare_enable(struct clk *clk);
+
+/**
+ * clk_disable_unprepare - disable and undo preparation of a clock source
+ * @clk: clock source
+ *
+ * This disables and undoes a previously prepared clock.
+ *
+ * Must not be called from within atomic context.
+ */
+void clk_disable_unprepare(struct clk *clk);
+
+/**
  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
  *		  This is only valid once the clock source has been enabled.
  * @clk: clock source
@@ -295,6 +315,17 @@ static inline int clk_enable(struct clk *clk)
 
 static inline void clk_disable(struct clk *clk) {}
 
+static inline int clk_prepare_enable(struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+
+static inline void clk_disable_unprepare(struct clk *clk)
+{
+	might_sleep();
+}
+
 static inline unsigned long clk_get_rate(struct clk *clk)
 {
 	return 0;
@@ -322,28 +353,6 @@ static inline struct clk *clk_get_parent(struct clk *clk)
 
 #endif
 
-/* clk_prepare_enable helps cases using clk_enable in non-atomic context. */
-static inline int clk_prepare_enable(struct clk *clk)
-{
-	int ret;
-
-	ret = clk_prepare(clk);
-	if (ret)
-		return ret;
-	ret = clk_enable(clk);
-	if (ret)
-		clk_unprepare(clk);
-
-	return ret;
-}
-
-/* clk_disable_unprepare helps cases using clk_disable in non-atomic context. */
-static inline void clk_disable_unprepare(struct clk *clk)
-{
-	clk_disable(clk);
-	clk_unprepare(clk);
-}
-
 /**
  * clk_add_alias - add a new clock alias
  * @alias: name for clock alias
-- 
1.7.11.7

