Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2LQVDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:03:11 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51778 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2LQVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:02:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,304,1355126400"; 
   d="scan'208";a="14773299"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3/4] clk: vt8500: Use of_init_clk_data()
Date: Mon, 17 Dec 2012 13:02:14 -0800
Message-Id: <1355778135-32458-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.1.rc1
In-Reply-To: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce lines of code and simplify this driver by using the
generic clock binding parsing function.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/clk/clk-vt8500.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index fe25570..454efa7 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -200,8 +200,6 @@ static __init void vtwm_device_clk_init(struct device_node *node)
 	u32 en_reg, div_reg;
 	struct clk *clk;
 	struct clk_device *dev_clk;
-	const char *clk_name = node->name;
-	const char *parent_name;
 	struct clk_init_data init;
 	int rc;
 	int clk_init_flags = 0;
@@ -237,8 +235,6 @@ static __init void vtwm_device_clk_init(struct device_node *node)
 		clk_init_flags |= CLK_INIT_DIVISOR;
 	}
 
-	of_property_read_string(node, "clock-output-names", &clk_name);
-
 	switch (clk_init_flags) {
 	case CLK_INIT_GATED:
 		init.ops = &vt8500_gated_clk_ops;
@@ -256,11 +252,11 @@ static __init void vtwm_device_clk_init(struct device_node *node)
 		return;
 	}
 
-	init.name = clk_name;
-	init.flags = 0;
-	parent_name = of_clk_get_parent_name(node, 0);
-	init.parent_names = &parent_name;
-	init.num_parents = 1;
+	rc = of_init_clk_data(node, &init);
+	if (WARN_ON(rc)) {
+		kfree(dev_clk);
+		return;
+	}
 
 	dev_clk->hw.init = &init;
 
@@ -270,7 +266,7 @@ static __init void vtwm_device_clk_init(struct device_node *node)
 		return;
 	}
 	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
-	clk_register_clkdev(clk, clk_name, NULL);
+	clk_register_clkdev(clk, init.name, NULL);
 }
 
 
@@ -458,8 +454,6 @@ static __init void vtwm_pll_clk_init(struct device_node *node, int pll_type)
 	u32 reg;
 	struct clk *clk;
 	struct clk_pll *pll_clk;
-	const char *clk_name = node->name;
-	const char *parent_name;
 	struct clk_init_data init;
 	int rc;
 
@@ -475,24 +469,21 @@ static __init void vtwm_pll_clk_init(struct device_node *node, int pll_type)
 	pll_clk->lock = &_lock;
 	pll_clk->type = pll_type;
 
-	of_property_read_string(node, "clock-output-names", &clk_name);
-
-	init.name = clk_name;
 	init.ops = &vtwm_pll_ops;
-	init.flags = 0;
-	parent_name = of_clk_get_parent_name(node, 0);
-	init.parent_names = &parent_name;
-	init.num_parents = 1;
+	rc = of_init_clk_data(node, &init);
+	if (WARN_ON(rc))
+		goto err;
 
 	pll_clk->hw.init = &init;
 
 	clk = clk_register(NULL, &pll_clk->hw);
-	if (WARN_ON(IS_ERR(clk))) {
-		kfree(pll_clk);
-		return;
-	}
+	if (WARN_ON(IS_ERR(clk)))
+		goto err;
 	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
-	clk_register_clkdev(clk, clk_name, NULL);
+	clk_register_clkdev(clk, init.name, NULL);
+	return;
+err:
+	kfree(pll_clk);
 }
 
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

