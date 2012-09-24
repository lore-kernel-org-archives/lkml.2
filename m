Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2IXUii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:38:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5959 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab2IXUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:38:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6845"; a="238278925"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 2/3] clk: Add devm_clk_{register,unregister}()
Date: Mon, 24 Sep 2012 13:38:04 -0700
Message-Id: <1348519085-5888-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
In-Reply-To: <1348519085-5888-1-git-send-email-sboyd@codeaurora.org>
References: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org>
 <1348519085-5888-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some clock drivers can be simplified if devres takes care of
unregistering any registered clocks along error paths. Introduce
devm_clk_register() so that clock drivers get unregistration for
free along with simplified error paths.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

v2: Use devres_release()

 drivers/clk/clk.c            | 111 +++++++++++++++++++++++++++++++++++--------
 include/linux/clk-provider.h |   2 +
 2 files changed, 92 insertions(+), 21 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 56e4495e..6852809 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/device.h>
 
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
@@ -1361,28 +1362,9 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 }
 EXPORT_SYMBOL_GPL(__clk_register);
 
-/**
- * clk_register - allocate a new clock, register it and return an opaque cookie
- * @dev: device that is registering this clock
- * @hw: link to hardware-specific clock data
- *
- * clk_register is the primary interface for populating the clock tree with new
- * clock nodes.  It returns a pointer to the newly allocated struct clk which
- * cannot be dereferenced by driver code but may be used in conjuction with the
- * rest of the clock API.  In the event of an error clk_register will return an
- * error code; drivers must test for an error code after calling clk_register.
- */
-struct clk *clk_register(struct device *dev, struct clk_hw *hw)
+static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 {
 	int i, ret;
-	struct clk *clk;
-
-	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
-	if (!clk) {
-		pr_err("%s: could not allocate clk\n", __func__);
-		ret = -ENOMEM;
-		goto fail_out;
-	}
 
 	clk->name = kstrdup(hw->init->name, GFP_KERNEL);
 	if (!clk->name) {
@@ -1420,7 +1402,7 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 
 	ret = __clk_init(dev, clk);
 	if (!ret)
-		return clk;
+		return 0;
 
 fail_parent_names_copy:
 	while (--i >= 0)
@@ -1429,6 +1411,36 @@ fail_parent_names_copy:
 fail_parent_names:
 	kfree(clk->name);
 fail_name:
+	return ret;
+}
+
+/**
+ * clk_register - allocate a new clock, register it and return an opaque cookie
+ * @dev: device that is registering this clock
+ * @hw: link to hardware-specific clock data
+ *
+ * clk_register is the primary interface for populating the clock tree with new
+ * clock nodes.  It returns a pointer to the newly allocated struct clk which
+ * cannot be dereferenced by driver code but may be used in conjuction with the
+ * rest of the clock API.  In the event of an error clk_register will return an
+ * error code; drivers must test for an error code after calling clk_register.
+ */
+struct clk *clk_register(struct device *dev, struct clk_hw *hw)
+{
+	int ret;
+	struct clk *clk;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk) {
+		pr_err("%s: could not allocate clk\n", __func__);
+		ret = -ENOMEM;
+		goto fail_out;
+	}
+
+	ret = _clk_register(dev, hw, clk);
+	if (!ret)
+		return clk;
+
 	kfree(clk);
 fail_out:
 	return ERR_PTR(ret);
@@ -1444,6 +1456,63 @@ EXPORT_SYMBOL_GPL(clk_register);
 void clk_unregister(struct clk *clk) {}
 EXPORT_SYMBOL_GPL(clk_unregister);
 
+static void devm_clk_release(struct device *dev, void *res)
+{
+	clk_unregister(res);
+}
+
+/**
+ * devm_clk_register - resource managed clk_register()
+ * @dev: device that is registering this clock
+ * @hw: link to hardware-specific clock data
+ *
+ * Managed clk_register(). Clocks returned from this function are
+ * automatically clk_unregister()ed on driver detach. See clk_register() for
+ * more information.
+ */
+struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw)
+{
+	struct clk *clk;
+	int ret;
+
+	clk = devres_alloc(devm_clk_release, sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		return ERR_PTR(-ENOMEM);
+
+	ret = _clk_register(dev, hw, clk);
+	if (!ret) {
+		devres_add(dev, clk);
+	} else {
+		devres_free(clk);
+		clk = ERR_PTR(ret);
+	}
+
+	return clk;
+}
+EXPORT_SYMBOL_GPL(devm_clk_register);
+
+static int devm_clk_match(struct device *dev, void *res, void *data)
+{
+	struct clk *c = res;
+	if (WARN_ON(!c))
+		return 0;
+	return c == data;
+}
+
+/**
+ * devm_clk_unregister - resource managed clk_unregister()
+ * @clk: clock to unregister
+ *
+ * Deallocate a clock allocated with devm_clk_register(). Normally
+ * this function will not need to be called and the resource management
+ * code will ensure that the resource is freed.
+ */
+void devm_clk_unregister(struct device *dev, struct clk *clk)
+{
+	WARN_ON(devres_release(dev, devm_clk_release, devm_clk_match, clk));
+}
+EXPORT_SYMBOL_GPL(devm_clk_unregister);
+
 /***        clk rate change notifiers        ***/
 
 /**
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index c127315..710c6cb 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -327,8 +327,10 @@ struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
  * error code; drivers must test for an error code after calling clk_register.
  */
 struct clk *clk_register(struct device *dev, struct clk_hw *hw);
+struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw);
 
 void clk_unregister(struct clk *clk);
+void devm_clk_unregister(struct device *dev, struct clk *clk);
 
 /* helper functions */
 const char *__clk_get_name(struct clk *clk);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

