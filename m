Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab2KTJWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:22:51 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36813 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2KTJWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:22:31 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] CLK: add more managed APIs
Date: Tue, 20 Nov 2012 01:22:19 -0800
Message-Id: <1353403339-11679-4-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting a driver to managed resources it is desirable to be able to
manage all resources in the same fashion. This change allows managing clocks
in the same way we manage all otehr resources.

This adds the following managed APIs:

- devm_clk_prepare()/devm_clk_unprepare();
- devm_clk_enable()/devm_clk_disable();
- devm_clk_preapre_enable()/devm_clk_diable_unprepare().

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/clk/clk-devres.c |  91 +++++++++++++++++++++++++++++++---------
 include/linux/clk.h      | 105 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 177 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index 8f57154..2703fa9 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -9,6 +9,33 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 
+static int devm_clk_match(struct device *dev, void *res, void *data)
+{
+	struct clk **c = res;
+	if (!c || !*c) {
+		WARN_ON(!c || !*c);
+		return 0;
+	}
+	return *c == data;
+}
+
+
+static int devm_clk_create_devres(struct device *dev,
+				  struct clk *clk,
+				  void (*release)(struct device *, void *))
+{
+	struct clk **ptr;
+
+	ptr = devres_alloc(release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	*ptr = clk;
+	devres_add(dev, ptr);
+
+	return 0;
+}
+
 static void devm_clk_release(struct device *dev, void *res)
 {
 	clk_put(*(struct clk **)res);
@@ -16,34 +43,22 @@ static void devm_clk_release(struct device *dev, void *res)
 
 struct clk *devm_clk_get(struct device *dev, const char *id)
 {
-	struct clk **ptr, *clk;
-
-	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return ERR_PTR(-ENOMEM);
+	struct clk *clk;
+	int error;
 
 	clk = clk_get(dev, id);
 	if (!IS_ERR(clk)) {
-		*ptr = clk;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
+		error = devm_clk_create_devres(dev, clk, devm_clk_release);
+		if (error) {
+			clk_put(clk);
+			return ERR_PTR(error);
+		}
 	}
 
 	return clk;
 }
 EXPORT_SYMBOL(devm_clk_get);
 
-static int devm_clk_match(struct device *dev, void *res, void *data)
-{
-	struct clk **c = res;
-	if (!c || !*c) {
-		WARN_ON(!c || !*c);
-		return 0;
-	}
-	return *c == data;
-}
-
 void devm_clk_put(struct device *dev, struct clk *clk)
 {
 	int ret;
@@ -53,3 +68,41 @@ void devm_clk_put(struct device *dev, struct clk *clk)
 	WARN_ON(ret);
 }
 EXPORT_SYMBOL(devm_clk_put);
+
+#define DEFINE_DEVM_CLK_OP(create_op, destroy_op)			\
+static void devm_##destroy_op##_release(struct device *devm, void *res)	\
+{									\
+	destroy_op(*(struct clk **)res);				\
+}									\
+									\
+int devm_##create_op(struct device *dev, struct clk *clk)		\
+{									\
+	int error;							\
+									\
+	error = devm_clk_create_devres(dev, clk,			\
+					devm_##destroy_op##_release);	\
+	if (error)							\
+		return error;						\
+									\
+	error = create_op(clk);						\
+	if (error) {							\
+		WARN_ON(devres_destroy(dev,				\
+					devm_##destroy_op##_release,	\
+					devm_clk_match, clk));		\
+		return error;						\
+	}								\
+									\
+	return 0;							\
+}									\
+EXPORT_SYMBOL(devm_##create_op);					\
+									\
+void devm_##destroy_op(struct device *dev, struct clk *clk)		\
+{									\
+	WARN_ON(devres_release(dev, devm_##destroy_op##_release,	\
+				devm_clk_match, clk));			\
+}									\
+EXPORT_SYMBOL(devm_##destroy_op)
+
+DEFINE_DEVM_CLK_OP(clk_prepare, clk_unprepare);
+DEFINE_DEVM_CLK_OP(clk_prepare_enable, clk_disable_unprepare);
+DEFINE_DEVM_CLK_OP(clk_enable, clk_disable);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 8bf149e..04b6300 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -133,6 +133,17 @@ struct clk *devm_clk_get(struct device *dev, const char *id);
 int clk_prepare(struct clk *clk);
 
 /**
+ * devm_clk_prepare - prepare a clock source as managed resource
+ * @dev: device owning the resource
+ * @clk: clock source
+ *
+ * This prepares the clock source for use.
+ *
+ * Must not be called from within atomic context.
+ */
+int devm_clk_prepare(struct device *dev, struct clk *clk);
+
+/**
  * clk_unprepare - undo preparation of a clock source
  * @clk: clock source
  *
@@ -144,6 +155,18 @@ int clk_prepare(struct clk *clk);
 void clk_unprepare(struct clk *clk);
 
 /**
+ * devm_clk_unprepare - undo preparation of a managed clock source.
+ * @dev: device used to prepare the clock
+ * @clk: clock source
+ *
+ * This undoes preparation of a clock previously prepared with call
+ * to devm_clk_pepare().
+ *
+ * Must not be called from within atomic context.
+ */
+void devm_clk_unprepare(struct device *dev, struct clk *clk);
+
+/**
  * clk_enable - inform the system when the clock source should be running.
  * @clk: clock source
  *
@@ -156,6 +179,19 @@ void clk_unprepare(struct clk *clk);
 int clk_enable(struct clk *clk);
 
 /**
+ * devm_clk_enable - enable the clock source as managed resource
+ * @dev: device owning the resource
+ * @clk: clock source
+ *
+ * If the clock can not be enabled/disabled, this should return success.
+ *
+ * May be not called from atomic contexts.
+ *
+ * Returns success (0) or negative errno.
+ */
+int devm_clk_enable(struct device *dev, struct clk *clk);
+
+/**
  * clk_disable - inform the system when the clock source is no longer required.
  * @clk: clock source
  *
@@ -172,6 +208,18 @@ int clk_enable(struct clk *clk);
 void clk_disable(struct clk *clk);
 
 /**
+ * devm_clk_disable - disable managed clock source resource
+ * @dev: device used to enable the clock
+ * @clk: clock source
+ *
+ * Inform the system that a clock source is no longer required by
+ * a driver and may be shut down.
+ *
+ * Must not be called from atomic contexts.
+ */
+void devm_clk_disable(struct device *dev, struct clk *clk);
+
+/**
  * clk_prepare_enable - prepare and enable a clock source
  * @clk: clock source
  *
@@ -182,6 +230,17 @@ void clk_disable(struct clk *clk);
 int clk_prepare_enable(struct clk *clk);
 
 /**
+ * devm_clk_prepare_enable - prepare and enable a managed clock source
+ * @dev: device owning the clock source
+ * @clk: clock source
+ *
+ * This prepares the clock source for use and enables it.
+ *
+ * Must not be called from within atomic context.
+ */
+int devm_clk_prepare_enable(struct device *dev, struct clk *clk);
+
+/**
  * clk_disable_unprepare - disable and undo preparation of a clock source
  * @clk: clock source
  *
@@ -192,6 +251,17 @@ int clk_prepare_enable(struct clk *clk);
 void clk_disable_unprepare(struct clk *clk);
 
 /**
+ * clk_disable_unprepare - disable and undo preparation of a managed clock source
+ * @dev: device used to prepare and enable the clock
+ * @clk: clock source
+ *
+ * This disables and undoes a previously prepared clock.
+ *
+ * Must not be called from within atomic context.
+ */
+void devm_clk_disable_unprepare(struct device *dev, struct clk *clk);
+
+/**
  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
  *		  This is only valid once the clock source has been enabled.
  * @clk: clock source
@@ -303,29 +373,64 @@ static inline int clk_prepare(struct clk *clk)
 	return 0;
 }
 
+static inline int devm_clk_prepare(struct device *dev, struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+
 static inline void clk_unprepare(struct clk *clk)
 {
 	might_sleep();
 }
 
+static inline void devm_clk_unprepare(struct device *dev, struct clk *clk)
+{
+	might_sleep();
+}
+
 static inline int clk_enable(struct clk *clk)
 {
 	return 0;
 }
 
+static inline int devm_clk_enable(struct device *dev, struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+
 static inline void clk_disable(struct clk *clk) {}
 
+static inline void devm_clk_disable(struct device *dev, struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+
 static inline int clk_prepare_enable(struct clk *clk)
 {
 	might_sleep();
 	return 0;
 }
 
+static inline int devm_clk_prepare_enable(struct device *dev, struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+
 static inline void clk_disable_unprepare(struct clk *clk)
 {
 	might_sleep();
 }
 
+static inline void devm_clk_disable_unprepare(struct device *dev,
+					      struct clk *clk)
+{
+	might_sleep();
+}
+
 static inline unsigned long clk_get_rate(struct clk *clk)
 {
 	return 0;
-- 
1.7.11.7

