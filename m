Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab2BTGuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:50:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5245 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2BTGrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 19 Feb 2012 22:46:12 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 08/20] pinctrl: Assume map table entries can't have a NULL name field
Date: Sun, 19 Feb 2012 23:45:48 -0700
Message-Id: <1329720360-23227-9-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl_register_mappings() already requires that every mapping table
entry have a non-NULL name field.

Logically, this makes sense too; drivers should always request a specific
named state so they know what they're getting. Relying on getting the
first mentioned state in the mapping table is error-prone, and a nasty
special case to implement, given that a given the mapping table may define
multiple states for a device.

Update a few places in the code and documentation that still allowed for
NULL name fields.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 Documentation/pinctrl.txt |    8 ++------
 drivers/pinctrl/core.c    |   25 ++++++++-----------------
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index ee3266b..bfe83b1 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -934,7 +934,7 @@ foo_probe()
 	/* Allocate a state holder named "state" etc */
 	struct pinctrl p;
 
-	p = pinctrl_get(&device, NULL);
+	p = pinctrl_get(&device, "default");
 	if IS_ERR(p)
 		return PTR_ERR(p);
 	pinctrl_enable(p);
@@ -948,10 +948,6 @@ foo_remove()
 	pinctrl_put(state->p);
 }
 
-If you want to grab a specific control mapping and not just the first one
-found for this device you can specify a specific mapping name, for example in
-the above example the second i2c0 setting: pinctrl_get(&device, "spi0-pos-B");
-
 This get/enable/disable/put sequence can just as well be handled by bus drivers
 if you don't want each and every driver to handle it and you know the
 arrangement on your bus.
@@ -1003,7 +999,7 @@ Since it may be common to request the core to hog a few always-applicable
 mux settings on the primary pin controller, there is a convenience macro for
 this:
 
-PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
+PIN_MAP_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
 
 This gives the exact same result as the above construction.
 
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index b6e3c35..5e30d91 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -488,8 +488,8 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 	int i;
 	struct pinctrl_map const *map;
 
-	/* We must have dev or ID or both */
-	if (!dev && !name)
+	/* We must have a state name */
+	if (WARN_ON(!name))
 		return ERR_PTR(-EINVAL);
 
 	if (dev)
@@ -530,23 +530,16 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		pr_debug("in map, found pctldev %s to handle function %s",
 			 dev_name(pctldev->dev), map->function);
 
-		/*
-		 * If we're looking for a specific named map, this must match,
-		 * else we loop and look for the next.
-		 */
-		if (name != NULL) {
-			if (map->name == NULL)
-				continue;
-			if (strcmp(map->name, name))
-				continue;
-		}
+		/* State name must be the one we're looking for */
+		if (strcmp(map->name, name))
+			continue;
 
 		/*
 		 * This is for the case where no device name is given, we
 		 * already know that the function name matches from above
 		 * code.
 		 */
-		if (!map->dev_name && (name != NULL))
+		if (!map->dev_name)
 			found_map = true;
 
 		/* If the mapping has a device set up it must match */
@@ -570,16 +563,14 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 	/* We should have atleast one map, right */
 	if (!num_maps) {
 		pr_err("could not find any mux maps for device %s, ID %s\n",
-		       devname ? devname : "(anonymous)",
-		       name ? name : "(undefined)");
+		       devname ? devname : "(anonymous)", name);
 		kfree(p);
 		return ERR_PTR(-EINVAL);
 	}
 
 	pr_debug("found %u mux maps for device %s, UD %s\n",
 		 num_maps,
-		 devname ? devname : "(anonymous)",
-		 name ? name : "(undefined)");
+		 devname ? devname : "(anonymous)", name);
 
 	/* Add the pinmux to the global list */
 	mutex_lock(&pinctrl_list_mutex);
-- 
1.7.5.4

