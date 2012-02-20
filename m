Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2BTGto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:49:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19405 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2BTGrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 19 Feb 2012 22:46:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 12/20] pinctrl: Use dev_*() instead of pr_*(), add some msgs, minor cleanups
Date: Sun, 19 Feb 2012 23:45:52 -0700
Message-Id: <1329720360-23227-13-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e.g. dev_err instead of pr_err prints messages in a slightly more
standardized format.

Also, add a few more error messages to track down errors.

Also, some small cleanups of messages.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |   38 ++++++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 54e24f7..ce6016d 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -212,8 +212,10 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 	}
 
 	pindesc = kzalloc(sizeof(*pindesc), GFP_KERNEL);
-	if (pindesc == NULL)
+	if (pindesc == NULL) {
+		dev_err(pctldev->dev, "failed to alloc struct pin_desc\n");
 		return -ENOMEM;
+	}
 
 	spin_lock_init(&pindesc->lock);
 
@@ -493,7 +495,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 
 	devname = dev_name(dev);
 
-	pr_debug("get pin control handle device %s state %s\n", devname, name);
+	dev_dbg(dev, "pinctrl_get() for state %s\n", name);
 
 	/*
 	 * create the state cookie holder struct pinctrl for each
@@ -501,8 +503,10 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 	 * a pin control handle with pinctrl_get()
 	 */
 	p = kzalloc(sizeof(struct pinctrl), GFP_KERNEL);
-	if (p == NULL)
+	if (p == NULL) {
+		dev_err(dev, "failed to alloc struct pinctrl\n");
 		return ERR_PTR(-ENOMEM);
+	}
 	mutex_init(&p->mutex);
 	pinmux_init_pinctrl_handle(p);
 
@@ -513,17 +517,15 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		 */
 		pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
 		if (!pctldev) {
-			pr_warning("could not find a pinctrl device for pinmux function %s, fishy, they shall all have one\n",
-				   map->function);
-			pr_warning("given pinctrl device name: %s",
-				   map->ctrl_dev_name);
+			dev_warn(dev, "unknown pinctrl device %s in map entry",
+				 map->ctrl_dev_name);
 
 			/* Continue to check the other mappings anyway... */
 			continue;
 		}
 
-		pr_debug("in map, found pctldev %s to handle function %s",
-			 dev_name(pctldev->dev), map->function);
+		dev_dbg(dev, "in map, found pctldev %s to handle function %s",
+			dev_name(pctldev->dev), map->function);
 
 		/* Map must be for this device */
 		if (strcmp(map->dev_name, devname))
@@ -553,8 +555,7 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 	if (!num_maps)
 		dev_info(dev, "zero maps found for state %s\n", name);
 
-	pr_debug("found %u mux maps for device %s, UD %s\n",
-		 num_maps, devname, name);
+	dev_dbg(dev, "found %u maps for state %s\n", num_maps, name);
 
 	/* Add the pinmux to the global list */
 	mutex_lock(&pinctrl_list_mutex);
@@ -665,7 +666,7 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
 	for (i = 0; i < num_maps; i++) {
 		if (!maps[i].name) {
 			pr_err("failed to register map %d: no map name given\n",
-					i);
+			       i);
 			return -EINVAL;
 		}
 
@@ -677,13 +678,13 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
 
 		if (!maps[i].function) {
 			pr_err("failed to register map %s (%d): no function ID given\n",
-					maps[i].name, i);
+			       maps[i].name, i);
 			return -EINVAL;
 		}
 
 		if (!maps[i].dev_name) {
 			pr_err("failed to register map %s (%d): no device given\n",
-					maps[i].name, i);
+			       maps[i].name, i);
 			return -EINVAL;
 		}
 	}
@@ -697,6 +698,7 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
 	maps_node->num_maps = num_maps;
 	maps_node->maps = kmemdup(maps, sizeof(*maps) * num_maps, GFP_KERNEL);
 	if (!maps_node->maps) {
+		pr_err("failed to duplicate mapping table\n");
 		kfree(maps_node);
 		return -ENOMEM;
 	}
@@ -717,8 +719,10 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
 	int ret;
 
 	hog = kzalloc(sizeof(struct pinctrl_hog), GFP_KERNEL);
-	if (!hog)
+	if (!hog) {
+		dev_err(pctldev->dev, "failed to alloc struct pinctrl_hog\n");
 		return -ENOMEM;
+	}
 
 	p = pinctrl_get_locked(pctldev->dev, map->name);
 	if (IS_ERR(p)) {
@@ -1149,8 +1153,10 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		return NULL;
 
 	pctldev = kzalloc(sizeof(struct pinctrl_dev), GFP_KERNEL);
-	if (pctldev == NULL)
+	if (pctldev == NULL) {
+		dev_err(dev, "failed to alloc struct pinctrl_dev\n");
 		return NULL;
+	}
 
 	/* Initialize pin control device struct */
 	pctldev->owner = pctldesc->owner;
-- 
1.7.5.4

