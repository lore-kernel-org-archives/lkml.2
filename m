Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab2DYQeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:34:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38552 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2DYQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:34:23 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: add error messages to pinmux_map_to_setting()
Date: Wed, 25 Apr 2012 10:34:17 -0600
Message-Id: <1335371657-24120-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

pinmux_map_to_setting() detects a number of errors, but doesn't report
any specifics to the user, making debugging those errors hard.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
John, Linus,

This is mostly just FYI in case John wants to roll this into his error
reporting patch - it's all the changes I made to any non-Tegra files when
debugging my DT map data.

 drivers/pinctrl/pinmux.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index fa0357b..68cab3d 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -329,17 +329,27 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
 		return -EINVAL;
 	}
 
-	setting->data.mux.func =
-		pinmux_func_name_to_selector(pctldev, map->data.mux.function);
-	if (setting->data.mux.func < 0)
-		return setting->data.mux.func;
+	ret = pinmux_func_name_to_selector(pctldev, map->data.mux.function);
+	if (ret < 0) {
+		dev_err(pctldev->dev, "invalid function %s in map table\n",
+			map->data.mux.function);
+		return ret;
+	}
+	setting->data.mux.func = ret;
 
 	ret = pmxops->get_function_groups(pctldev, setting->data.mux.func,
 					  &groups, &num_groups);
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(pctldev->dev, "can't query groups for function %s\n",
+			map->data.mux.function);
 		return ret;
-	if (!num_groups)
+	}
+	if (!num_groups) {
+		dev_err(pctldev->dev,
+			"function %s can't be selected on any group\n",
+			map->data.mux.function);
 		return -EINVAL;
+	}
 
 	if (map->data.mux.group) {
 		bool found = false;
@@ -350,15 +360,23 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
 				break;
 			}
 		}
-		if (!found)
+		if (!found) {
+			dev_err(pctldev->dev,
+				"function %s can't be selected on group %s\n",
+				map->data.mux.function, map->data.mux.group);
 			return -EINVAL;
+		}
 	} else {
 		group = groups[0];
 	}
 
-	setting->data.mux.group = pinctrl_get_group_selector(pctldev, group);
-	if (setting->data.mux.group < 0)
-		return setting->data.mux.group;
+	ret = pinctrl_get_group_selector(pctldev, group);
+	if (ret < 0) {
+		dev_err(pctldev->dev, "invalid group %s in map table\n",
+			map->data.mux.group);
+		return ret;
+	}
+	setting->data.mux.group = ret;
 
 	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group, &pins,
 				      &num_pins);
-- 
1.7.0.4

