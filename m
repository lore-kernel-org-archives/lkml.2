Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2LQVCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:02:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17738 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2LQVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:02:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,304,1355126400"; 
   d="scan'208";a="14662749"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/4] clk: Add of_init_clk_data() to parse common clock bindings
Date: Mon, 17 Dec 2012 13:02:12 -0800
Message-Id: <1355778135-32458-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.1.rc1
In-Reply-To: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate DT parsing for the common bits of a clock binding in
one place to simplify clock drivers. This also has the added
benefit of standardizing how the clock names used by the common
clock framework are generated from the DT bindings. We always use
the first clock-output-names string if it exists, otherwise we
fall back to the node name.

To be slightly more efficient and make the caller's life easier,
we introduce a shallow copy flag so that the clock core knows to
just copy the pointers to the strings and not the string
contents. Otherwise the callers of this function would have to
free the strings allocated here which could be cumbersome.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 drivers/clk/clk.c            | 58 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/clk-provider.h |  2 ++
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 251e45d..95380a9 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1383,6 +1383,10 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 {
 	int i, ret;
 
+	hw->clk = clk;
+	if (hw->init->flags & CLK_SHALLOW_COPY)
+		return PTR_RET(__clk_register(dev, hw));
+
 	clk->name = kstrdup(hw->init->name, GFP_KERNEL);
 	if (!clk->name) {
 		pr_err("%s: could not allocate clk->name\n", __func__);
@@ -1393,7 +1397,6 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 	clk->hw = hw;
 	clk->flags = hw->init->flags;
 	clk->num_parents = hw->init->num_parents;
-	hw->clk = clk;
 
 	/* allocate local copy in case parent_names is __initdata */
 	clk->parent_names = kzalloc((sizeof(char*) * clk->num_parents),
@@ -1797,4 +1800,57 @@ void __init of_clk_init(const struct of_device_id *matches)
 		clk_init_cb(np);
 	}
 }
+
+/**
+ * of_init_clk_data() - Initialize a clk_init_data struct from a DT node
+ * @np: node to initialize struct from
+ * @init: struct to initialize
+ *
+ * Populates the clk_init_data struct by parsing the device node for
+ * properties matching the common clock binding. Returns 0 on success
+ * and a negative error code on failure.
+ */
+int of_init_clk_data(struct device_node *np, struct clk_init_data *init)
+{
+	struct of_phandle_args s;
+	const char **names = NULL, **p;
+	const char *name;
+	int i;
+
+	if (of_property_read_string(np, "clock-output-names", &name) < 0)
+		name = np->name;
+	init->name = kstrdup(name, GFP_KERNEL);
+	if (!init->name)
+		return -ENOMEM;
+
+	for (i = 0; of_parse_phandle_with_args(np, "clocks", "#clock-cells",
+				i, &s) == 0; i++) {
+		p = krealloc(names, sizeof(*names) * (i + 1), GFP_KERNEL);
+		if (!p)
+			goto err;
+		names = p;
+
+		if (of_property_read_string(s.np, "clock-output-names",
+					&name) < 0)
+			name = s.np->name;
+		names[i] = kstrdup(name, GFP_KERNEL);
+		if (!names[i])
+			goto err;
+		of_node_put(s.np);
+	}
+
+	init->parent_names = names;
+	init->num_parents = i;
+	init->flags = CLK_SHALLOW_COPY;
+
+	return 0;
+err:
+	of_node_put(s.np);
+	while (--i >= 0)
+		kfree(names[i]);
+	kfree(names);
+	kfree(init->name);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(of_init_clk_data);
 #endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 4989b8a..9d3db2b 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -27,6 +27,7 @@
 #define CLK_IS_ROOT		BIT(4) /* root clk, has no parent */
 #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
+#define CLK_SHALLOW_COPY	BIT(7) /* don't copy the initdata strings */
 
 struct clk_hw;
 
@@ -380,6 +381,7 @@ struct clk_onecell_data {
 struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
 void of_clk_init(const struct of_device_id *matches);
+int of_init_clk_data(struct device_node *np, struct clk_init_data *init);
 
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PROVIDER_H */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

