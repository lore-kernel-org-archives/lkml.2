Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1GKDnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:43:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49487 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757042Ab1GKDms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:42:48 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] clk: Support multiple instances of the same clock provider
Date: Mon, 11 Jul 2011 11:53:56 +0900
Message-Id: <1310352837-4277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the generic clk API identifies clocks internally using the name
of the clock. This is OK for on-SoC clocks where we have enough control to
disambiguate but doesn't work well for clocks provided on external chips
where a system design may include more than one instance of the same chip
(the Wolfson Speyside system is an example of this) or may have namespace
collisions.

Address this by allowing the clock provider to supply a struct device for
the clock for use in disambiguation. As a first pass if it is provided we
prefix the clock name with the dev_name() of the device. With a device
tree binding for clocks it should be possible to remove this mangling and
instead use the struct device to provide access to the binding information.

In order to avoid needless noise in names and memory usage it is strongly
recommended that on-SoC clocks do not provide a struct device until the
implementation is improved.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/clk/clk.c   |   36 ++++++++++++++++++++++++++++++++----
 include/linux/clk.h |   14 ++++++++++----
 2 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1df6e23..f36f637 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/device.h>
 
 struct clk {
 	const char		*name;
@@ -252,20 +253,44 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 }
 EXPORT_SYMBOL_GPL(clk_set_parent);
 
-struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
-		const char *name)
+struct clk *clk_register(struct device *dev, const struct clk_hw_ops *ops,
+			 struct clk_hw *hw, const char *name)
 {
 	struct clk *clk;
+	char *new_name;
+	size_t name_len;
 
 	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
 	if (!clk)
 		return NULL;
 
-	clk->name = name;
 	clk->ops = ops;
 	clk->hw = hw;
 	hw->clk = clk;
 
+	/* Since we currently match clock providers on a purely string
+	 * based method add a prefix based on the device name if a
+	 * device is provided.  When we have support for device tree
+	 * based clock matching it should be possible to avoid this
+	 * mangling and instead use the struct device to hook into
+	 * the bindings.
+	 *
+	 * As we don't currently support unregistering clocks we don't
+	 * need to worry about cleanup as yet.
+	 */
+	if (dev) {
+		name_len = strlen(name) + strlen(dev_name(dev)) + 2;
+		new_name = kzalloc(name_len, GFP_KERNEL);
+		if (!new_name)
+			goto err;
+
+		snprintf(new_name, name_len, "%s-%s", dev_name(dev), name);
+
+		clk->name = new_name;
+	} else {
+		clk->name = name;
+	}
+
 	/* Query the hardware for parent and initial rate. We may alter
 	 * the clock topology, making this clock available from the parent's
 	 * children list. So, we need to protect against concurrent
@@ -285,7 +310,10 @@ struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
 
 	mutex_unlock(&prepare_lock);
 
-
 	return clk;
+
+err:
+	kfree(clk);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(clk_register);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e435..cb1879b 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -139,15 +139,21 @@ extern struct clk_hw_ops clk_gate_ops;
 /**
  * clk_register - register and initialize a new clock
  *
+ * @dev: device providing the clock or NULL
  * @ops: ops for the new clock
  * @hw: struct clk_hw to be passed to the ops of the new clock
  * @name: name to use for the new clock
  *
- * Register a new clock with the clk subsytem.  Returns either a
- * struct clk for the new clock or a NULL pointer.
+ * Register a new clock with the clk subsytem.  If dev is provided
+ * then it will be used to disambiguate between multiple instances of
+ * the same device in the system, typically this should only be done
+ * for devices that are not part of the core SoC unless device tree is
+ * in use.
+ *
+ * Returns either a struct clk for the new clock or a NULL pointer.
  */
-struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
-			 const char *name);
+struct clk *clk_register(struct device *dev, const struct clk_hw_ops *ops,
+			 struct clk_hw *hw, const char *name);
 
 /**
  * clk_unregister - remove a clock
-- 
1.7.5.4

