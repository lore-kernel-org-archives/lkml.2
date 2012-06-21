Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab2FUHag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:30:36 -0400
Received: from void.printf.net ([89.145.121.20]:38034 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758670Ab2FUHaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:30:35 -0400
From: Chris Ball <cjb@laptop.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Mitch Bradley <wmb@laptop.org>, mturquette@linaro.org,
        devicetree-discuss@lists.ozlabs.org, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, skannan@codeaurora.org,
        shawn.guo@linaro.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/02] clk: Refactor of_clk_* into a new clk-of.c
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
	<87bokd15x7.fsf@octavius.laptop.org>
Date: Thu, 21 Jun 2012 03:30:26 -0400
In-Reply-To: <87bokd15x7.fsf@octavius.laptop.org> (Chris Ball's message of
	"Thu, 21 Jun 2012 03:27:00 -0400")
Message-ID: <877gv115rh.fsf_-_@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the dependency on CONFIG_COMMON_CLK, which is unnecessary
for the of_clk_* functions -- these functions are passed a struct clk,
which can either be a COMMON_CLK struct or an arch-specific one.

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/clk/Makefile         |    2 +
 drivers/clk/clk-of.c         |  167 ++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clk.c            |  139 -----------------------------------
 include/linux/clk-provider.h |   14 ----
 include/linux/clk.h          |   17 ++++-
 5 files changed, 184 insertions(+), 155 deletions(-)
 create mode 100644 drivers/clk/clk-of.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 553b30b..9584801 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -2,6 +2,8 @@
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
 				   clk-mux.o clk-divider.o clk-fixed-factor.o
+obj-$(CONFIG_OF)		+= clk-of.o
+
 # SoCs specific
 obj-$(CONFIG_ARCH_MXS)		+= mxs/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
diff --git a/drivers/clk/clk-of.c b/drivers/clk/clk-of.c
new file mode 100644
index 0000000..8b43416
--- /dev/null
+++ b/drivers/clk/clk-of.c
@@ -0,0 +1,167 @@
+/*
+ * Copyright 2011-2012 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk-private.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+
+#ifdef CONFIG_OF
+
+struct of_device_id;
+
+typedef void (*of_clk_init_cb_t)(struct device_node *);
+/**
+ * struct of_clk_provider - Clock provider registration structure
+ * @link: Entry in global list of clock providers
+ * @node: Pointer to device tree node of clock provider
+ * @get: Get clock callback.  Returns NULL or a struct clk for the
+ *       given clock specifier
+ * @data: context pointer to be passed into @get callback
+ */
+struct of_clk_provider {
+	struct list_head link;
+
+	struct device_node *node;
+	struct clk *(*get)(struct of_phandle_args *clkspec, void *data);
+	void *data;
+};
+
+static LIST_HEAD(of_clk_providers);
+static DEFINE_MUTEX(of_clk_lock);
+
+struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
+				     void *data)
+{
+	return data;
+}
+EXPORT_SYMBOL_GPL(of_clk_src_simple_get);
+
+/**
+ * of_clk_add_provider() - Register a clock provider for a node
+ * @np: Device node pointer associated with clock provider
+ * @clk_src_get: callback for decoding clock
+ * @data: context pointer for @clk_src_get callback.
+ */
+int of_clk_add_provider(struct device_node *np,
+			struct clk *(*clk_src_get)(struct of_phandle_args *clkspec,
+						   void *data),
+			void *data)
+{
+	struct of_clk_provider *cp;
+
+	cp = kzalloc(sizeof(struct of_clk_provider), GFP_KERNEL);
+	if (!cp)
+		return -ENOMEM;
+
+	cp->node = of_node_get(np);
+	cp->data = data;
+	cp->get = clk_src_get;
+
+	mutex_lock(&of_clk_lock);
+	list_add(&cp->link, &of_clk_providers);
+	mutex_unlock(&of_clk_lock);
+	pr_debug("Added clock from %s\n", np->full_name);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_clk_add_provider);
+
+/**
+ * of_clk_del_provider() - Remove a previously registered clock provider
+ * @np: Device node pointer associated with clock provider
+ */
+void of_clk_del_provider(struct device_node *np)
+{
+	struct of_clk_provider *cp;
+
+	mutex_lock(&of_clk_lock);
+	list_for_each_entry(cp, &of_clk_providers, link) {
+		if (cp->node == np) {
+			list_del(&cp->link);
+			of_node_put(cp->node);
+			kfree(cp);
+			break;
+		}
+	}
+	mutex_unlock(&of_clk_lock);
+}
+EXPORT_SYMBOL_GPL(of_clk_del_provider);
+
+struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
+{
+	struct of_clk_provider *provider;
+	struct clk *clk = NULL;
+
+	/* Check if we have such a provider in our array */
+	mutex_lock(&of_clk_lock);
+	list_for_each_entry(provider, &of_clk_providers, link) {
+		if (provider->node == clkspec->np)
+			clk = provider->get(clkspec, provider->data);
+		if (clk)
+			break;
+	}
+	mutex_unlock(&of_clk_lock);
+
+	return clk;
+}
+
+const char *of_clk_get_parent_name(struct device_node *np, int index)
+{
+	struct of_phandle_args clkspec;
+	const char *clk_name;
+	int rc;
+
+	if (index < 0)
+		return NULL;
+
+	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
+					&clkspec);
+	if (rc)
+		return NULL;
+
+	if (of_property_read_string_index(clkspec.np, "clock-output-names",
+					  clkspec.args_count ? clkspec.args[0] : 0,
+					  &clk_name) < 0)
+		clk_name = clkspec.np->name;
+
+	of_node_put(clkspec.np);
+	return clk_name;
+}
+EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
+
+/**
+ * of_clk_init() - Scan and init clock providers from the DT
+ * @matches: array of compatible values and init functions for providers.
+ *
+ * This function scans the device tree for matching clock providers and
+ * calls their initialization functions
+ */
+void __init of_clk_init(const struct of_device_id *matches)
+{
+	struct device_node *np;
+
+	for_each_matching_node(np, matches) {
+		const struct of_device_id *match = of_match_node(matches, np);
+		of_clk_init_cb_t clk_init_cb = match->data;
+		clk_init_cb(np);
+	}
+}
+#endif
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 456f5fb..c773e5a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1545,142 +1545,3 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_notifier_unregister);
-
-#ifdef CONFIG_OF
-/**
- * struct of_clk_provider - Clock provider registration structure
- * @link: Entry in global list of clock providers
- * @node: Pointer to device tree node of clock provider
- * @get: Get clock callback.  Returns NULL or a struct clk for the
- *       given clock specifier
- * @data: context pointer to be passed into @get callback
- */
-struct of_clk_provider {
-	struct list_head link;
-
-	struct device_node *node;
-	struct clk *(*get)(struct of_phandle_args *clkspec, void *data);
-	void *data;
-};
-
-static LIST_HEAD(of_clk_providers);
-static DEFINE_MUTEX(of_clk_lock);
-
-struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
-				     void *data)
-{
-	return data;
-}
-EXPORT_SYMBOL_GPL(of_clk_src_simple_get);
-
-/**
- * of_clk_add_provider() - Register a clock provider for a node
- * @np: Device node pointer associated with clock provider
- * @clk_src_get: callback for decoding clock
- * @data: context pointer for @clk_src_get callback.
- */
-int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *clkspec,
-						   void *data),
-			void *data)
-{
-	struct of_clk_provider *cp;
-
-	cp = kzalloc(sizeof(struct of_clk_provider), GFP_KERNEL);
-	if (!cp)
-		return -ENOMEM;
-
-	cp->node = of_node_get(np);
-	cp->data = data;
-	cp->get = clk_src_get;
-
-	mutex_lock(&of_clk_lock);
-	list_add(&cp->link, &of_clk_providers);
-	mutex_unlock(&of_clk_lock);
-	pr_debug("Added clock from %s\n", np->full_name);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(of_clk_add_provider);
-
-/**
- * of_clk_del_provider() - Remove a previously registered clock provider
- * @np: Device node pointer associated with clock provider
- */
-void of_clk_del_provider(struct device_node *np)
-{
-	struct of_clk_provider *cp;
-
-	mutex_lock(&of_clk_lock);
-	list_for_each_entry(cp, &of_clk_providers, link) {
-		if (cp->node == np) {
-			list_del(&cp->link);
-			of_node_put(cp->node);
-			kfree(cp);
-			break;
-		}
-	}
-	mutex_unlock(&of_clk_lock);
-}
-EXPORT_SYMBOL_GPL(of_clk_del_provider);
-
-struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
-{
-	struct of_clk_provider *provider;
-	struct clk *clk = NULL;
-
-	/* Check if we have such a provider in our array */
-	mutex_lock(&of_clk_lock);
-	list_for_each_entry(provider, &of_clk_providers, link) {
-		if (provider->node == clkspec->np)
-			clk = provider->get(clkspec, provider->data);
-		if (clk)
-			break;
-	}
-	mutex_unlock(&of_clk_lock);
-
-	return clk;
-}
-
-const char *of_clk_get_parent_name(struct device_node *np, int index)
-{
-	struct of_phandle_args clkspec;
-	const char *clk_name;
-	int rc;
-
-	if (index < 0)
-		return NULL;
-
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
-	if (rc)
-		return NULL;
-
-	if (of_property_read_string_index(clkspec.np, "clock-output-names",
-					  clkspec.args_count ? clkspec.args[0] : 0,
-					  &clk_name) < 0)
-		clk_name = clkspec.np->name;
-
-	of_node_put(clkspec.np);
-	return clk_name;
-}
-EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
-
-/**
- * of_clk_init() - Scan and init clock providers from the DT
- * @matches: array of compatible values and init functions for providers.
- *
- * This function scans the device tree for matching clock providers and
- * calls their initialization functions
- */
-void __init of_clk_init(const struct of_device_id *matches)
-{
-	struct device_node *np;
-
-	for_each_matching_node(np, matches) {
-		const struct of_device_id *match = of_match_node(matches, np);
-		of_clk_init_cb_t clk_init_cb = match->data;
-		clk_init_cb(np);
-	}
-}
-#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index b97f61e..2d5b1bf 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -336,19 +336,5 @@ void __clk_unprepare(struct clk *clk);
 void __clk_reparent(struct clk *clk, struct clk *new_parent);
 unsigned long __clk_round_rate(struct clk *clk, unsigned long rate);
 
-struct of_device_id;
-
-typedef void (*of_clk_init_cb_t)(struct device_node *);
-
-int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *args,
-						   void *data),
-			void *data);
-void of_clk_del_provider(struct device_node *np);
-struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
-				  void *data);
-const char *of_clk_get_parent_name(struct device_node *np, int index);
-void of_clk_init(const struct of_device_id *matches);
-
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PROVIDER_H */
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 8b70342..d9293e7 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -312,8 +312,21 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
 
 struct device_node;
 struct of_phandle_args;
+struct of_device_id;
 
 #ifdef CONFIG_OF
+typedef void (*of_clk_init_cb_t)(struct device_node *);
+
+int of_clk_add_provider(struct device_node *np,
+			struct clk *(*clk_src_get)(struct of_phandle_args *args,
+						   void *data),
+			void *data);
+void of_clk_del_provider(struct device_node *np);
+struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
+				  void *data);
+const char *of_clk_get_parent_name(struct device_node *np, int index);
+void of_clk_init(const struct of_device_id *matches);
+
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
@@ -327,6 +340,6 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return NULL;
 }
-#endif
+#endif /* CONFIG_OF */
 
-#endif
+#endif /* __LINUX_CLK_H */
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
