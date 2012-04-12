Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827Ab2DLBI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:08:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40139 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2DLBIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:08:55 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <arnd.bergmann@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 12/13] clk: core: copy parent_names & return error codes
Date: Wed, 11 Apr 2012 18:02:50 -0700
Message-ID: <1334192572-12499-13-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up clk_register and solves a few bugs by teaching
clk_register and __clk_init to return error codes (instead of just NULL)
to better align with the existing clk.h api.

Along with that change this patch also introduces a new behavior whereby
clk_register copies the parent_names array, thus allowing platforms to
declare their parent_names arrays as __initdata.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/clk/clk.c            |   61 +++++++++++++++++++++++++++++++++--------
 include/linux/clk-private.h  |    4 ++-
 include/linux/clk-provider.h |    3 +-
 3 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ddade87..af2bf12 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1185,34 +1185,41 @@ EXPORT_SYMBOL_GPL(clk_set_parent);
  * very large numbers of clocks that need to be statically initialized.  It is
  * a layering violation to include clk-private.h from any code which implements
  * a clock's .ops; as such any statically initialized clock data MUST be in a
- * separate C file from the logic that implements it's operations.
+ * separate C file from the logic that implements it's operations.  Returns 0
+ * on success, otherwise an error code.
  */
-void __clk_init(struct device *dev, struct clk *clk)
+int __clk_init(struct device *dev, struct clk *clk)
 {
-	int i;
+	int i, ret = 0;
 	struct clk *orphan;
 	struct hlist_node *tmp, *tmp2;
 
 	if (!clk)
-		return;
+		return -EINVAL;
 
 	mutex_lock(&prepare_lock);
 
 	/* check to see if a clock with this name is already registered */
-	if (__clk_lookup(clk->name))
+	if (__clk_lookup(clk->name)) {
+		pr_debug("%s: clk %s already initialized\n",
+				__func__, clk->name);
+		ret = -EEXIST;
 		goto out;
+	}
 
 	/* check that clk_ops are sane.  See Documentation/clk.txt */
 	if (clk->ops->set_rate &&
 			!(clk->ops->round_rate && clk->ops->recalc_rate)) {
 		pr_warning("%s: %s must implement .round_rate & .recalc_rate\n",
 				__func__, clk->name);
+		ret = -EINVAL;
 		goto out;
 	}
 
 	if (clk->ops->set_parent && !clk->ops->get_parent) {
 		pr_warning("%s: %s must implement .get_parent & .set_parent\n",
 				__func__, clk->name);
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -1308,7 +1315,7 @@ void __clk_init(struct device *dev, struct clk *clk)
 out:
 	mutex_unlock(&prepare_lock);
 
-	return;
+	return ret;
 }
 
 /**
@@ -1324,29 +1331,59 @@ out:
  * clk_register is the primary interface for populating the clock tree with new
  * clock nodes.  It returns a pointer to the newly allocated struct clk which
  * cannot be dereferenced by driver code but may be used in conjuction with the
- * rest of the clock API.
+ * rest of the clock API.  In the event of an error clk_register will return an
+ * error code; drivers must test for an error code after calling clk_register.
  */
 struct clk *clk_register(struct device *dev, const char *name,
 		const struct clk_ops *ops, struct clk_hw *hw,
 		const char **parent_names, u8 num_parents, unsigned long flags)
 {
+	int i, ret = -ENOMEM;
 	struct clk *clk;
 
 	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
-	if (!clk)
-		return NULL;
+	if (!clk) {
+		pr_err("%s: could not allocate clk\n", __func__);
+		goto fail_out;
+	}
 
 	clk->name = name;
 	clk->ops = ops;
 	clk->hw = hw;
 	clk->flags = flags;
-	clk->parent_names = parent_names;
 	clk->num_parents = num_parents;
 	hw->clk = clk;
 
-	__clk_init(dev, clk);
+	/* allocate local copy in case parent_names is __initdata */
+	clk->parent_names = kzalloc((sizeof(char*) * num_parents),
+			GFP_KERNEL);
+
+	if (!clk->parent_names) {
+		pr_err("%s: could not allocate clk->parent_names\n", __func__);
+		goto fail_parent_names;
+	}
+
+	/* copy each string name in case parent_names is __initdata */
+	for (i = 0; i < num_parents; i++) {
+		clk->parent_names[i] = kstrdup(parent_names[i], GFP_KERNEL);
+		if (!clk->parent_names[i]) {
+			pr_err("%s: could not copy parent_names\n", __func__);
+			goto fail_parent_names_copy;
+		}
+	}
+
+	ret = __clk_init(dev, clk);
+	if (!ret)
+		return clk;
 
-	return clk;
+fail_parent_names_copy:
+	while (--i >= 0)
+		kfree(clk->parent_names[i]);
+	kfree(clk->parent_names);
+fail_parent_names:
+	kfree(clk);
+fail_out:
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(clk_register);
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index e9c8b98..e7032fd 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -181,8 +181,10 @@ struct clk {
  *
  * It is not necessary to call clk_register if __clk_init is used directly with
  * statically initialized clock data.
+ *
+ * Returns 0 on success, otherwise an error code.
  */
-void __clk_init(struct device *dev, struct clk *clk);
+int __clk_init(struct device *dev, struct clk *clk);
 
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PRIVATE_H */
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 8981435..97f9fab 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -274,7 +274,8 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
  * clk_register is the primary interface for populating the clock tree with new
  * clock nodes.  It returns a pointer to the newly allocated struct clk which
  * cannot be dereferenced by driver code but may be used in conjuction with the
- * rest of the clock API.
+ * rest of the clock API.  In the event of an error clk_register will return an
+ * error code; drivers must test for an error code after calling clk_register.
  */
 struct clk *clk_register(struct device *dev, const char *name,
 		const struct clk_ops *ops, struct clk_hw *hw,
-- 
1.7.5.4

