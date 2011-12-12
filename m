Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1LLWCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:02:25 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39072 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1LLWCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:21 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC v2 5/9] dt/clock: Add handling for fixed clocks and a clock node setup iterator
Date: Mon, 12 Dec 2011 15:02:05 -0700
Message-Id: <1323727329-4989-5-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/clock.c     |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_clk.h |    4 ++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/of/clock.c b/drivers/of/clock.c
index 6519e96..1c189b4 100644
--- a/drivers/of/clock.c
+++ b/drivers/of/clock.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/clkdev.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -163,3 +164,45 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 
 	return clk;
 }
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
+
+static struct clk *of_fixed_clk_get(struct of_phandle_args *a, void *data)
+{
+	return data;
+}
+
+/**
+ * of_fixed_clk_setup() - Setup function for simple fixed rate clock
+ */
+void __init of_fixed_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	u32 rate;
+
+	if (of_property_read_u32(node, "clock-frequency", &rate))
+		return;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		return;
+	clk->rate = rate;
+
+	of_clk_add_provider(node, of_fixed_clk_get, clk);
+}
diff --git a/include/linux/of_clk.h b/include/linux/of_clk.h
index dcbd27b..02ecc98 100644
--- a/include/linux/of_clk.h
+++ b/include/linux/of_clk.h
@@ -10,6 +10,7 @@ struct clk;
 #ifdef CONFIG_OF_CLOCK
 
 struct device_node;
+typedef void (*of_clk_init_cb_t)(struct device_node *);
 
 int of_clk_add_provider(struct device_node *np,
 			struct clk *(*clk_src_get)(struct of_phandle_args *args,
@@ -21,6 +22,9 @@ void of_clk_del_provider(struct device_node *np);
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 
+void of_clk_init(const struct of_device_id *matches);
+extern void of_fixed_clk_setup(struct device_node *np);
+
 #else
 static struct clk *of_clk_get(struct device_node *np, int index)
 {
-- 
1.7.5.4

