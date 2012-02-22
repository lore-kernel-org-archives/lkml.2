Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2BVV1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:27:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6242 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab2BVV1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:27:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 22 Feb 2012 13:26:09 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 4/4] pinctrl: Remove pin and hogs locks from struct pinctrl_dev
Date: Wed, 22 Feb 2012 14:26:01 -0700
Message-Id: <1329945961-29547-5-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329945961-29547-1-git-send-email-swarren@nvidia.com>
References: <1329945961-29547-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct pinctrl_dev's pin_desc_tree_lock and pinctrl_hogs_lock aren't
useful; the data they protect is read-only except when registering or
unregistering a pinctrl_dev, and at those times, it doesn't make sense to
protect one part of the structure independently from the rest.

Move pinctrl_init_device_debugfs() to the end of pinctrl_register() so
that debugfs can't access the struct pinctrl_dev until it's fully
initialized, i.e. after the hogs are set up.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Extracted from previous lock rework patch.

 drivers/pinctrl/core.c |   25 ++-----------------------
 drivers/pinctrl/core.h |   11 ++++++-----
 2 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 2cc8f72..633b97e 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -115,18 +115,6 @@ struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *devname)
 	return found ? pctldev : NULL;
 }
 
-struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin)
-{
-	struct pin_desc *pindesc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pctldev->pin_desc_tree_lock, flags);
-	pindesc = radix_tree_lookup(&pctldev->pin_desc_tree, pin);
-	spin_unlock_irqrestore(&pctldev->pin_desc_tree_lock, flags);
-
-	return pindesc;
-}
-
 /**
  * pin_get_from_name() - look up a pin number from a name
  * @pctldev: the pin control device to lookup the pin on
@@ -182,7 +170,6 @@ static void pinctrl_free_pindescs(struct pinctrl_dev *pctldev,
 {
 	int i;
 
-	spin_lock(&pctldev->pin_desc_tree_lock);
 	for (i = 0; i < num_pins; i++) {
 		struct pin_desc *pindesc;
 
@@ -196,7 +183,6 @@ static void pinctrl_free_pindescs(struct pinctrl_dev *pctldev,
 		}
 		kfree(pindesc);
 	}
-	spin_unlock(&pctldev->pin_desc_tree_lock);
 }
 
 static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
@@ -232,9 +218,7 @@ static int pinctrl_register_one_pin(struct pinctrl_dev *pctldev,
 		pindesc->dynamic_name = true;
 	}
 
-	spin_lock(&pctldev->pin_desc_tree_lock);
 	radix_tree_insert(&pctldev->pin_desc_tree, number, pindesc);
-	spin_unlock(&pctldev->pin_desc_tree_lock);
 	pr_debug("registered pin %d (%s) on %s\n",
 		 number, pindesc->name, pctldev->desc->name);
 	return 0;
@@ -756,9 +740,7 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
 
 	dev_info(pctldev->dev, "hogged map %s, function %s\n", map->name,
 		 map->function);
-	mutex_lock(&pctldev->pinctrl_hogs_lock);
 	list_add_tail(&hog->node, &pctldev->pinctrl_hogs);
-	mutex_unlock(&pctldev->pinctrl_hogs_lock);
 
 	return 0;
 }
@@ -781,7 +763,6 @@ static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
 	struct pinctrl_map const *map;
 
 	INIT_LIST_HEAD(&pctldev->pinctrl_hogs);
-	mutex_init(&pctldev->pinctrl_hogs_lock);
 
 	mutex_lock(&pinctrl_maps_mutex);
 	for_each_maps(maps_node, i, map) {
@@ -808,7 +789,6 @@ static void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
 {
 	struct list_head *node, *tmp;
 
-	mutex_lock(&pctldev->pinctrl_hogs_lock);
 	list_for_each_safe(node, tmp, &pctldev->pinctrl_hogs) {
 		struct pinctrl_hog *hog =
 			list_entry(node, struct pinctrl_hog, node);
@@ -817,7 +797,6 @@ static void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
 		list_del(node);
 		kfree(hog);
 	}
-	mutex_unlock(&pctldev->pinctrl_hogs_lock);
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -1171,7 +1150,6 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	pctldev->desc = pctldesc;
 	pctldev->driver_data = driver_data;
 	INIT_RADIX_TREE(&pctldev->pin_desc_tree, GFP_KERNEL);
-	spin_lock_init(&pctldev->pin_desc_tree_lock);
 	INIT_LIST_HEAD(&pctldev->gpio_ranges);
 	mutex_init(&pctldev->gpio_ranges_lock);
 	pctldev->dev = dev;
@@ -1207,11 +1185,12 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		goto out_err;
 	}
 
-	pinctrl_init_device_debugfs(pctldev);
 	mutex_lock(&pinctrldev_list_mutex);
 	list_add_tail(&pctldev->node, &pinctrldev_list);
 	mutex_unlock(&pinctrldev_list_mutex);
 	pinctrl_hog_maps(pctldev);
+	pinctrl_init_device_debugfs(pctldev);
+
 	return pctldev;
 
 out_err:
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 061c57d..7551611 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -20,7 +20,6 @@ struct pinctrl_gpio_range;
  *	controller
  * @pin_desc_tree: each pin descriptor for this pin controller is stored in
  *	this radix tree
- * @pin_desc_tree_lock: lock for the descriptor tree
  * @gpio_ranges: a list of GPIO ranges that is handled by this pin controller,
  *	ranges are added to this list at runtime
  * @gpio_ranges_lock: lock for the GPIO ranges list
@@ -28,7 +27,6 @@ struct pinctrl_gpio_range;
  * @owner: module providing the pin controller, used for refcounting
  * @driver_data: driver data for drivers registering to the pin controller
  *	subsystem
- * @pinctrl_hogs_lock: lock for the pin control hog list
  * @pinctrl_hogs: list of pin control maps hogged by this device
  * @device_root: debugfs root for this device
  */
@@ -36,13 +34,11 @@ struct pinctrl_dev {
 	struct list_head node;
 	struct pinctrl_desc *desc;
 	struct radix_tree_root pin_desc_tree;
-	spinlock_t pin_desc_tree_lock;
 	struct list_head gpio_ranges;
 	struct mutex gpio_ranges_lock;
 	struct device *dev;
 	struct module *owner;
 	void *driver_data;
-	struct mutex pinctrl_hogs_lock;
 	struct list_head pinctrl_hogs;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
@@ -99,7 +95,12 @@ struct pin_desc {
 };
 
 struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *dev_name);
-struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin);
 int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name);
 int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 			       const char *pin_group);
+
+static inline struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev,
+					    unsigned int pin)
+{
+	return radix_tree_lookup(&pctldev->pin_desc_tree, pin);
+}
-- 
1.7.0.4

