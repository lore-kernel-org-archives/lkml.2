Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab1K3Mdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:33:32 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:39689 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757905Ab1K3Md3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:33:29 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl: make it possible to add multiple maps
Date: Wed, 30 Nov 2011 13:33:01 +0100
Message-ID: <1322656381-6496-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Since we now anyway make a copy of the platform-supplied pinmux
map, we can just as well make it possible to call the function
adding maps several times, so as to simplify cases (as PXA) where
several sets of disparate mappings need to be added depending on
target platform.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinmux.c |   58 ++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 680f690..54fc27b 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -351,48 +351,30 @@ EXPORT_SYMBOL_GPL(pinmux_gpio_direction_output);
 int __init pinmux_register_mappings(struct pinmux_map const *maps,
 				    unsigned num_maps)
 {
-	int ret = 0;
+	void *tmp_maps;
 	int i;
 
-	if (pinmux_maps_num != 0) {
-		pr_err("pinmux mappings already registered, you can only "
-		       "register one set of maps\n");
-		return -EINVAL;
-	}
-
 	pr_debug("add %d pinmux maps\n", num_maps);
 
-	/*
-	 * Make a copy of the map array - string pointers will end up in the
-	 * kernel const section anyway so these do not need to be deep copied.
-	 */
-	pinmux_maps = kmemdup(maps, sizeof(struct pinmux_map) * num_maps,
-			      GFP_KERNEL);
-	if (!pinmux_maps)
-		return -ENOMEM;
-
+	/* First sanity check the new mapping */
 	for (i = 0; i < num_maps; i++) {
-		/* Sanity check the mapping while copying it */
 		if (!maps[i].name) {
 			pr_err("failed to register map %d: "
 			       "no map name given\n", i);
-			ret = -EINVAL;
-			goto err_out_free;
+			return -EINVAL;
 		}
 
 		if (!maps[i].ctrl_dev && !maps[i].ctrl_dev_name) {
 			pr_err("failed to register map %s (%d): "
 			       "no pin control device given\n",
 			       maps[i].name, i);
-			ret = -EINVAL;
-			goto err_out_free;
+			return -EINVAL;
 		}
 
 		if (!maps[i].function) {
 			pr_err("failed to register map %s (%d): "
 			       "no function ID given\n", maps[i].name, i);
-			ret = -EINVAL;
-			goto err_out_free;
+			return -EINVAL;
 		}
 
 		if (!maps[i].dev && !maps[i].dev_name)
@@ -403,17 +385,33 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 			pr_debug("register map %s, function %s\n",
 				 maps[i].name,
 				 maps[i].function);
+	}
 
-		pinmux_maps_num++;
+	/*
+	 * Make a copy of the map array - string pointers will end up in the
+	 * kernel const section anyway so these do not need to be deep copied.
+	 */
+	if (!pinmux_maps_num) {
+		/* On first call, just copy them */
+		tmp_maps = kmemdup(maps,
+				   sizeof(struct pinmux_map) * num_maps,
+				   GFP_KERNEL);
+		if (!tmp_maps)
+			return -ENOMEM;
+	} else {
+		/* Subsequent calls, reallocate array to new size */
+		size_t oldsize = sizeof(struct pinmux_map) * pinmux_maps_num;
+		size_t newsize = sizeof(struct pinmux_map) * num_maps;
+
+		tmp_maps = krealloc(pinmux_maps, oldsize + newsize, GFP_KERNEL);
+		if (!tmp_maps)
+			return -ENOMEM;
+		memcpy((tmp_maps + oldsize), maps, newsize);
 	}
 
+	pinmux_maps = tmp_maps;
+	pinmux_maps_num += num_maps;
 	return 0;
-
-err_out_free:
-	kfree(pinmux_maps);
-	pinmux_maps = NULL;
-	pinmux_maps_num = 0;
-	return ret;
 }
 
 /**
-- 
1.7.3.2

