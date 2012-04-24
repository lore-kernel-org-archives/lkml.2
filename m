Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2DXLeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:34:20 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:58462 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503Ab2DXLeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:34:13 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>, <sshtylyov@mvista.com>, <jgarzik@redhat.com>,
        <linux@arm.linux.org.uk>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V3 01/12] clk: Add non CONFIG_HAVE_CLK routines
Date: Tue, 24 Apr 2012 16:51:23 +0530
Message-ID: <0a44db2d07eb6ddc7c920bdb2a0a50c224a6035a.1335266056.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335266056.git.viresh.kumar@st.com>
References: <cover.1335266056.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
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
 include/linux/clk.h |  168 +++++++++++++++++++++++++++++++++------------------
 1 files changed, 109 insertions(+), 59 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 70cf722..9f84b68 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -84,6 +84,43 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
 #endif /* !CONFIG_COMMON_CLK */
 
 /**
+ * clk_prepare - prepare a clock source
+ * @clk: clock source
+ *
+ * This prepares the clock source for use.
+ *
+ * Must not be called from within atomic context.
+ */
+#ifdef CONFIG_HAVE_CLK_PREPARE
+int clk_prepare(struct clk *clk);
+#else
+static inline int clk_prepare(struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+#endif
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
  * clk_get - lookup and obtain a reference to a clock producer.
  * @dev: device for clock "consumer"
  * @id: clock comsumer ID
@@ -121,24 +158,6 @@ struct clk *clk_get(struct device *dev, const char *id);
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
 /**
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
  * clk_enable - inform the system when the clock source should be running.
  * @clk: clock source
  *
@@ -166,47 +185,6 @@ int clk_enable(struct clk *clk);
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
@@ -297,6 +275,78 @@ struct clk *clk_get_parent(struct clk *clk);
  */
 struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
+#else /* !CONFIG_HAVE_CLK */
+
+static inline struct clk *clk_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline struct clk *devm_clk_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline void clk_put(struct clk *clk) {}
+
+static inline void devm_clk_put(struct device *dev, struct clk *clk) {}
+
+static inline int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+
+static inline void clk_disable(struct clk *clk) {}
+
+static inline unsigned long clk_get_rate(struct clk *clk)
+{
+	return 0;
+}
+
+static inline int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	return 0;
+}
+
+static inline long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	return 0;
+}
+
+static inline int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return 0;
+}
+
+static inline struct clk *clk_get_parent(struct clk *clk)
+{
+	return NULL;
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

