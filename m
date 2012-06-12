Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2FLOmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:42:14 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64726 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2FLOmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:42:09 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, mturquette@linaro.org,
        sboyd@codeaurora.org, skannan@codeaurora.org, shawn.guo@linaro.org,
        s.hauer@pengutronix.de, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3 2/4] clk: add DT fixed-clock binding support
Date: Tue, 12 Jun 2012 09:41:49 -0500
Message-Id: <1339512111-11172-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Add support for DT "fixed-clock" binding to the common fixed rate clock
support.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
[Rob Herring] Rework and move into common clock infrastructure
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/clk/clk-fixed-rate.c |   23 +++++++++++++++++++++++
 include/linux/clk-provider.h |    2 ++
 2 files changed, 25 insertions(+)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index cbd2462..94493f1 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/err.h>
+#include <linux/of.h>
 
 /*
  * DOC: basic fixed-rate clock that cannot gate
@@ -79,3 +80,25 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 
 	return clk;
 }
+
+#ifdef CONFIG_OF
+/**
+ * of_fixed_clk_setup() - Setup function for simple fixed rate clock
+ */
+void __init of_fixed_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	u32 rate;
+
+	if (of_property_read_u32(node, "clock-frequency", &rate))
+		return;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	clk = clk_register_fixed_rate(NULL, clk_name, NULL, CLK_IS_ROOT, rate);
+	if (clk)
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+EXPORT_SYMBOL_GPL(of_fixed_clk_setup);
+#endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index acfef45..b97f61e 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -171,6 +171,8 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate);
 
+void of_fixed_clk_setup(struct device_node *np);
+
 /**
  * struct clk_gate - gating clock
  *
-- 
1.7.9.5

