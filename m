Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2DULsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:48:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40728 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2DULsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:48:39 -0400
From: Viresh Kumar <viresh.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 01/13] clk: Add non CONFIG_HAVE_CLK routines
Date: Sat, 21 Apr 2012 17:17:28 +0530
Message-Id: <f48165b92f52e9a879cedacaddc548ac885bf73d.1335008617.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many drivers are shared between architectures that may or may not have HAVE_CLK
selected for them. To remove compilation errors for them we enclose clk_*()
calls in these drivers within #ifdef CONFIG_HAVE_CLK, #endif.

This patch removes the need of these CONFIG_HAVE_CLK statements, by introducing
dummy routines when HAVE_CLK is not selected by platforms. So, definition of
these routines will always be available. These calls will return error for
platforms that don't select HAVE_CLK.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 include/linux/clk.h |  160 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 101 insertions(+), 59 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index b025272..6e1c63e 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -84,23 +84,6 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
 #endif /* !CONFIG_COMMON_CLK */
 
 /**
- * clk_get - lookup and obtain a reference to a clock producer.
- * @dev: device for clock "consumer"
- * @id: clock comsumer ID
- *
- * Returns a struct clk corresponding to the clock producer, or
- * valid IS_ERR() condition containing errno.  The implementation
- * uses @dev and @id to determine the clock consumer, and thereby
- * the clock producer.  (IOW, @id may be identical strings, but
- * clk_get may return different clock producers depending on @dev.)
- *
- * Drivers must assume that the clock source is not enabled.
- *
- * clk_get should not be called from within interrupt context.
- */
-struct clk *clk_get(struct device *dev, const char *id);
-
-/**
  * clk_prepare - prepare a clock source
  * @clk: clock source
  *
@@ -119,6 +102,42 @@ static inline int clk_prepare(struct clk *clk)
 #endif
 
 /**
+ * clk_unprepare - undo preparation of a clock source
+ * @clk: clock source
+ *
+ * This undoes a previously prepared clock.  The caller must balance
+ * the number of prepare and unprepare calls.
+ *
+ * Must not be called from within atomic context.
+ */
+#ifdef CONFIG_HAVE_CLK_PREPARE
+void clk_unprepare(struct clk *clk);
+#else
+static inline void clk_unprepare(struct clk *clk)
+{
+	might_sleep();
+}
+#endif
+
+#ifdef CONFIG_HAVE_CLK
+/**
+ * clk_get - lookup and obtain a reference to a clock producer.
+ * @dev: device for clock "consumer"
+ * @id: clock comsumer ID
+ *
+ * Returns a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  (IOW, @id may be identical strings, but
+ * clk_get may return different clock producers depending on @dev.)
+ *
+ * Drivers must assume that the clock source is not enabled.
+ *
+ * clk_get should not be called from within interrupt context.
+ */
+struct clk *clk_get(struct device *dev, const char *id);
+
+/**
  * clk_enable - inform the system when the clock source should be running.
  * @clk: clock source
  *
@@ -146,47 +165,6 @@ int clk_enable(struct clk *clk);
  */
 void clk_disable(struct clk *clk);
 
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
  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
  *		  This is only valid once the clock source has been enabled.
@@ -206,7 +184,6 @@ unsigned long clk_get_rate(struct clk *clk);
  */
 void clk_put(struct clk *clk);
 
-
 /*
  * The remaining APIs are optional for machine class support.
  */
@@ -265,6 +242,71 @@ struct clk *clk_get_parent(struct clk *clk);
  */
 struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
+#else /* !CONFIG_HAVE_CLK */
+
+static inline struct clk *clk_get(struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static inline void clk_put(struct clk *clk) {}
+
+static inline int clk_enable(struct clk *clk)
+{
+	return -ENODEV;
+}
+
+static inline void clk_disable(struct clk *clk) {}
+
+static inline unsigned long clk_get_rate(struct clk *clk)
+{
+	return -ENODEV;
+}
+
+static inline int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	return -ENODEV;
+}
+
+static inline long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	return -ENODEV;
+}
+
+static inline int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return -ENODEV;
+}
+
+static inline struct clk *clk_get_parent(struct clk *clk)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+#endif
+
+/* clk_prepare_enable helps cases using clk_enable in non-atomic context. */
+static inline int clk_prepare_enable(struct clk *clk)
+{
+	int ret;
+
+	ret = clk_prepare(clk);
+	if (ret)
+		return ret;
+	ret = clk_enable(clk);
+	if (ret)
+		clk_unprepare(clk);
+
+	return ret;
+}
+
+/* clk_disable_unprepare helps cases using clk_disable in non-atomic context. */
+static inline void clk_disable_unprepare(struct clk *clk)
+{
+	clk_disable(clk);
+	clk_unprepare(clk);
+}
+
 /**
  * clk_add_alias - add a new clock alias
  * @alias: name for clock alias
-- 
1.7.9

