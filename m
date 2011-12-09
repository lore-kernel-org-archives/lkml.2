Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1LIX7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:59:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39338 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1LIX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:59:17 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/3] pinctrl: Don't create a device for each pin controller
Date: Fri,  9 Dec 2011 16:59:05 -0700
Message-Id: <1323475145-26430-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323475145-26430-1-git-send-email-swarren@nvidia.com>
References: <1323475145-26430-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pin controllers should already be instantiated as a device, so there's
no need for the pinctrl core to create a new struct device for each
controller.

This allows the controller's real name to be used in the mux mapping
table, rather than e.g. "pinctrl.0", "pinctrl.1", etc.

This necessitates removal of the PINMUX_MAP_PRIMARY*() macros, since
their sole purpose was to hard-code the .ctrl_dev_name field to be
"pinctrl.0".

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 Documentation/pinctrl.txt       |   26 +++++++++++-----------
 drivers/pinctrl/core.c          |   42 +++++++++--------------------------
 drivers/pinctrl/core.h          |    2 +-
 drivers/pinctrl/pinconf.c       |   16 ++++++------
 drivers/pinctrl/pinmux.c        |   46 +++++++++++++++++++-------------------
 include/linux/pinctrl/machine.h |   25 ---------------------
 6 files changed, 56 insertions(+), 101 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index ae5ace2..822d6ba 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -783,17 +783,17 @@ spi on the second function mapping:
 
 static struct pinmux_map __initdata pmx_mapping[] = {
 	{
-		.ctrl_dev_name = "pinctrl.0",
+		.ctrl_dev_name = "pinctrl-foo",
 		.function = "spi0",
 		.dev_name = "foo-spi.0",
 	},
 	{
-		.ctrl_dev_name = "pinctrl.0",
+		.ctrl_dev_name = "pinctrl-foo",
 		.function = "i2c0",
 		.dev_name = "foo-i2c.0",
 	},
 	{
-		.ctrl_dev_name = "pinctrl.0",
+		.ctrl_dev_name = "pinctrl-foo",
 		.function = "mmc0",
 		.dev_name = "foo-mmc.0",
 	},
@@ -815,7 +815,7 @@ You register this pinmux mapping to the pinmux subsystem by simply:
        ret = pinmux_register_mappings(&pmx_mapping, ARRAY_SIZE(pmx_mapping));
 
 Since the above construct is pretty common there is a helper macro to make
-it even more compact which assumes you want to use pinctrl.0 and position
+it even more compact which assumes you want to use pinctrl-foo and position
 0 for mapping, for example:
 
 static struct pinmux_map __initdata pmx_mapping[] = {
@@ -832,14 +832,14 @@ As it is possible to map a function to different groups of pins an optional
 ...
 {
 	.name = "spi0-pos-A",
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "spi0",
 	.group = "spi0_0_grp",
 	.dev_name = "foo-spi.0",
 },
 {
 	.name = "spi0-pos-B",
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "spi0",
 	.group = "spi0_1_grp",
 	.dev_name = "foo-spi.0",
@@ -858,42 +858,42 @@ case), we define a mapping like this:
 ...
 {
 	.name "2bit"
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "4bit"
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "4bit"
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_2_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "8bit"
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "8bit"
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_2_grp",
 	.dev_name = "foo-mmc.0",
 },
 {
 	.name "8bit"
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_3_grp",
 	.dev_name = "foo-mmc.0",
@@ -996,7 +996,7 @@ like this:
 
 {
 	.name "POWERMAP"
-	.ctrl_dev_name = "pinctrl.0",
+	.ctrl_dev_name = "pinctrl-foo",
 	.function = "power_func",
 	.hog_on_boot = true,
 },
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4ede903..3be8458 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -34,12 +34,6 @@
 static DEFINE_MUTEX(pinctrldev_list_mutex);
 static LIST_HEAD(pinctrldev_list);
 
-static void pinctrl_dev_release(struct device *dev)
-{
-	struct pinctrl_dev *pctldev = dev_get_drvdata(dev);
-	kfree(pctldev);
-}
-
 const char *pinctrl_dev_get_name(struct pinctrl_dev *pctldev)
 {
 	/* We're not allowed to register devices without name */
@@ -71,14 +65,14 @@ struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
 
 	mutex_lock(&pinctrldev_list_mutex);
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
-		if (dev &&  &pctldev->dev == dev) {
+		if (dev && pctldev->dev == dev) {
 			/* Matched on device pointer */
 			found = true;
 			break;
 		}
 
 		if (devname &&
-		    !strcmp(dev_name(&pctldev->dev), devname)) {
+		    !strcmp(dev_name(pctldev->dev), devname)) {
 			/* Matched on device name */
 			found = true;
 			break;
@@ -301,7 +295,7 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 		const char *gname = pctlops->get_group_name(pctldev,
 							    group_selector);
 		if (!strcmp(gname, pin_group)) {
-			dev_dbg(&pctldev->dev,
+			dev_dbg(pctldev->dev,
 				"found group selector %u for %s\n",
 				group_selector,
 				pin_group);
@@ -311,7 +305,7 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 		group_selector++;
 	}
 
-	dev_err(&pctldev->dev, "does not have pin group %s\n",
+	dev_err(pctldev->dev, "does not have pin group %s\n",
 		pin_group);
 
 	return -EINVAL;
@@ -480,11 +474,11 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 {
 	static struct dentry *device_root;
 
-	device_root = debugfs_create_dir(dev_name(&pctldev->dev),
+	device_root = debugfs_create_dir(dev_name(pctldev->dev),
 					 debugfs_root);
 	if (IS_ERR(device_root) || !device_root) {
 		pr_warn("failed to create debugfs directory for %s\n",
-			dev_name(&pctldev->dev));
+			dev_name(pctldev->dev));
 		return;
 	}
 	debugfs_create_file("pins", S_IFREG | S_IRUGO,
@@ -532,7 +526,6 @@ static void pinctrl_init_debugfs(void)
 struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 				    struct device *dev, void *driver_data)
 {
-	static atomic_t pinmux_no = ATOMIC_INIT(0);
 	struct pinctrl_dev *pctldev;
 	int ret;
 
@@ -573,18 +566,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	spin_lock_init(&pctldev->pin_desc_tree_lock);
 	INIT_LIST_HEAD(&pctldev->gpio_ranges);
 	mutex_init(&pctldev->gpio_ranges_lock);
-
-	/* Register device */
-	pctldev->dev.parent = dev;
-	dev_set_name(&pctldev->dev, "pinctrl.%d",
-		     atomic_inc_return(&pinmux_no) - 1);
-	pctldev->dev.release = pinctrl_dev_release;
-	ret = device_register(&pctldev->dev);
-	if (ret != 0) {
-		pr_err("error in device registration\n");
-		goto out_reg_dev_err;
-	}
-	dev_set_drvdata(&pctldev->dev, pctldev);
+	pctldev->dev = dev;
 
 	/* Register all the pins */
 	pr_debug("try to register %d pins on %s...\n",
@@ -594,7 +576,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		pr_err("error during pin registration\n");
 		pinctrl_free_pindescs(pctldev, pctldesc->pins,
 				      pctldesc->npins);
-		goto out_reg_pins_err;
+		goto out_err;
 	}
 
 	pinctrl_init_device_debugfs(pctldev);
@@ -604,10 +586,8 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	pinmux_hog_maps(pctldev);
 	return pctldev;
 
-out_reg_pins_err:
-	device_del(&pctldev->dev);
-out_reg_dev_err:
-	put_device(&pctldev->dev);
+out_err:
+	kfree(pctldev);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(pinctrl_register);
@@ -631,7 +611,7 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 	/* Destroy descriptor tree */
 	pinctrl_free_pindescs(pctldev, pctldev->desc->pins,
 			      pctldev->desc->npins);
-	device_unregister(&pctldev->dev);
+	kfree(pctldev);
 }
 EXPORT_SYMBOL_GPL(pinctrl_unregister);
 
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 855e0fb..cea6cf5 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -38,7 +38,7 @@ struct pinctrl_dev {
 	spinlock_t pin_desc_tree_lock;
 	struct list_head gpio_ranges;
 	struct mutex gpio_ranges_lock;
-	struct device dev;
+	struct device *dev;
 	struct module *owner;
 	void *driver_data;
 #ifdef CONFIG_PINMUX
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index aefd684..dcd85db 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -37,13 +37,13 @@ int pin_config_get(struct pinctrl_dev *pctldev, int pin,
 	const struct pinconf_ops *ops = pctldev->desc->confops;
 
 	if (!pin_is_valid(pctldev, pin)) {
-		dev_err(&pctldev->dev, "tried to get config for unregistered "
+		dev_err(pctldev->dev, "tried to get config for unregistered "
 			"pin %d\n", pin);
 		return -EINVAL;
 	}
 
 	if (!ops || !ops->pin_config_get) {
-		dev_err(&pctldev->dev, "cannot get pin configuration, missing "
+		dev_err(pctldev->dev, "cannot get pin configuration, missing "
 			"pin_config_get() function in driver\n");
 		return -EINVAL;
 	}
@@ -67,20 +67,20 @@ int pin_config_set(struct pinctrl_dev *pctldev, int pin,
 	int ret;
 
 	if (!pin_is_valid(pctldev, pin)) {
-		dev_err(&pctldev->dev, "tried to configure unregistered "
+		dev_err(pctldev->dev, "tried to configure unregistered "
 			"pin %d\n", pin);
 		return -EINVAL;
 	}
 
 	if (!ops || !ops->pin_config_set) {
-		dev_err(&pctldev->dev, "cannot configure pin, missing "
+		dev_err(pctldev->dev, "cannot configure pin, missing "
 			"config function in driver\n");
 		return -EINVAL;
 	}
 
 	ret = ops->pin_config_set(pctldev, pin, config);
 	if (ret) {
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"unable to set pin configuration on pin %d\n", pin);
 		return ret;
 	}
@@ -96,7 +96,7 @@ int pin_config_group_get(struct pinctrl_dev *pctldev, const char *pin_group,
 	int selector;
 
 	if (!ops || !ops->pin_config_group_get) {
-		dev_err(&pctldev->dev, "cannot get configuration for pin "
+		dev_err(pctldev->dev, "cannot get configuration for pin "
 			"group, missing group config get function in "
 			"driver\n");
 		return -EINVAL;
@@ -123,7 +123,7 @@ int pin_config_group_set(struct pinctrl_dev *pctldev, const char *pin_group,
 	int i;
 
 	if (!ops || (!ops->pin_config_group_set && !ops->pin_config_set)) {
-		dev_err(&pctldev->dev, "cannot configure pin group, missing "
+		dev_err(pctldev->dev, "cannot configure pin group, missing "
 			"config function in driver\n");
 		return -EINVAL;
 	}
@@ -134,7 +134,7 @@ int pin_config_group_set(struct pinctrl_dev *pctldev, const char *pin_group,
 
 	ret = pctlops->get_group_pins(pctldev, selector, &pins, &num_pins);
 	if (ret) {
-		dev_err(&pctldev->dev, "cannot configure pin group, error "
+		dev_err(pctldev->dev, "cannot configure pin group, error "
 			"getting pins\n");
 		return ret;
 	}
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 30cdfca..432feb6 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -106,24 +106,24 @@ static int pin_request(struct pinctrl_dev *pctldev,
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 	int status = -EINVAL;
 
-	dev_dbg(&pctldev->dev, "request pin %d for %s\n", pin, function);
+	dev_dbg(pctldev->dev, "request pin %d for %s\n", pin, function);
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"pin is not registered so it cannot be requested\n");
 		goto out;
 	}
 
 	if (!function) {
-		dev_err(&pctldev->dev, "no function name given\n");
+		dev_err(pctldev->dev, "no function name given\n");
 		return -EINVAL;
 	}
 
 	spin_lock(&desc->lock);
 	if (desc->mux_function) {
 		spin_unlock(&desc->lock);
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"pin already requested\n");
 		goto out;
 	}
@@ -132,7 +132,7 @@ static int pin_request(struct pinctrl_dev *pctldev,
 
 	/* Let each pin increase references to this module */
 	if (!try_module_get(pctldev->owner)) {
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"could not increase module refcount for pin %d\n",
 			pin);
 		status = -EINVAL;
@@ -152,7 +152,7 @@ static int pin_request(struct pinctrl_dev *pctldev,
 		status = 0;
 
 	if (status)
-		dev_err(&pctldev->dev, "->request on device %s failed "
+		dev_err(pctldev->dev, "->request on device %s failed "
 		       "for pin %d\n",
 		       pctldev->desc->name, pin);
 out_free_pin:
@@ -163,7 +163,7 @@ out_free_pin:
 	}
 out:
 	if (status)
-		dev_err(&pctldev->dev, "pin-%d (%s) status %d\n",
+		dev_err(pctldev->dev, "pin-%d (%s) status %d\n",
 		       pin, function ? : "?", status);
 
 	return status;
@@ -189,7 +189,7 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 
 	desc = pin_desc_get(pctldev, pin);
 	if (desc == NULL) {
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"pin is not registered so it cannot be freed\n");
 		return NULL;
 	}
@@ -434,14 +434,14 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 	if (ret)
 		return ret;
 
-	dev_dbg(&pctldev->dev, "requesting the %u pins from group %u\n",
+	dev_dbg(pctldev->dev, "requesting the %u pins from group %u\n",
 		num_pins, group_selector);
 
 	/* Try to allocate all pins in this group, one by one */
 	for (i = 0; i < num_pins; i++) {
 		ret = pin_request(pctldev, pins[i], func, NULL);
 		if (ret) {
-			dev_err(&pctldev->dev,
+			dev_err(pctldev->dev,
 				"could not get pin %d for function %s "
 				"on device %s - conflicting mux mappings?\n",
 				pins[i], func ? : "(undefined)",
@@ -473,7 +473,7 @@ static void release_pins(struct pinctrl_dev *pctldev,
 	ret = pctlops->get_group_pins(pctldev, group_selector,
 				      &pins, &num_pins);
 	if (ret) {
-		dev_err(&pctldev->dev, "could not get pins to release for "
+		dev_err(pctldev->dev, "could not get pins to release for "
 			"group selector %d\n",
 			group_selector);
 		return;
@@ -525,7 +525,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 			return -EINVAL;
 		ret = pinctrl_get_group_selector(pctldev, groups[0]);
 		if (ret < 0) {
-			dev_err(&pctldev->dev,
+			dev_err(pctldev->dev,
 				"function %s wants group %s but the pin "
 				"controller does not seem to have that group\n",
 				pmxops->get_function_name(pctldev, func_selector),
@@ -534,7 +534,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 		}
 
 		if (num_groups > 1)
-			dev_dbg(&pctldev->dev,
+			dev_dbg(pctldev->dev,
 				"function %s support more than one group, "
 				"default-selecting first group %s (%d)\n",
 				pmxops->get_function_name(pctldev, func_selector),
@@ -544,13 +544,13 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
 		return ret;
 	}
 
-	dev_dbg(&pctldev->dev,
+	dev_dbg(pctldev->dev,
 		"check if we have pin group %s on controller %s\n",
 		pin_group, pinctrl_dev_get_name(pctldev));
 
 	ret = pinctrl_get_group_selector(pctldev, pin_group);
 	if (ret < 0) {
-		dev_dbg(&pctldev->dev,
+		dev_dbg(pctldev->dev,
 			"%s does not support pin group %s with function %s\n",
 			pinctrl_dev_get_name(pctldev),
 			pin_group,
@@ -627,7 +627,7 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 	 */
 
 	if (pmx->pctldev && pmx->pctldev != pctldev) {
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"different pin control devices given for device %s, "
 			"function %s\n",
 			devname,
@@ -650,7 +650,7 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 	 */
 	if (pmx->func_selector != UINT_MAX &&
 	    pmx->func_selector != func_selector) {
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"dual function defines in the map for device %s\n",
 		       devname);
 		return -EINVAL;
@@ -756,7 +756,7 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 		}
 
 		pr_debug("in map, found pctldev %s to handle function %s",
-			 dev_name(&pctldev->dev), map->function);
+			 dev_name(pctldev->dev), map->function);
 
 
 		/*
@@ -932,7 +932,7 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
 		 * without any problems, so then we can hog pinmuxes for
 		 * all devices that just want a static pin mux at this point.
 		 */
-		dev_err(&pctldev->dev, "map %s wants to hog a non-system "
+		dev_err(pctldev->dev, "map %s wants to hog a non-system "
 			"pinmux, this is not going to work\n", map->name);
 		return -EINVAL;
 	}
@@ -944,7 +944,7 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
 	pmx = pinmux_get(NULL, map->name);
 	if (IS_ERR(pmx)) {
 		kfree(hog);
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"could not get the %s pinmux mapping for hogging\n",
 			map->name);
 		return PTR_ERR(pmx);
@@ -954,7 +954,7 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
 	if (ret) {
 		pinmux_put(pmx);
 		kfree(hog);
-		dev_err(&pctldev->dev,
+		dev_err(pctldev->dev,
 			"could not enable the %s pinmux mapping for hogging\n",
 			map->name);
 		return ret;
@@ -963,7 +963,7 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
 	hog->map = map;
 	hog->pmx = pmx;
 
-	dev_info(&pctldev->dev, "hogged map %s, function %s\n", map->name,
+	dev_info(pctldev->dev, "hogged map %s, function %s\n", map->name,
 		 map->function);
 	mutex_lock(&pctldev->pinmux_hogs_lock);
 	list_add(&hog->node, &pctldev->pinmux_hogs);
@@ -982,7 +982,7 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
  */
 int pinmux_hog_maps(struct pinctrl_dev *pctldev)
 {
-	struct device *dev = &pctldev->dev;
+	struct device *dev = pctldev->dev;
 	const char *devname = dev_name(dev);
 	int ret;
 	int i;
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index 0ca32eb..ad430e0 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -73,31 +73,6 @@ struct pinmux_map {
 	{ .name = a, .ctrl_dev_name = b, .function = c, \
 	  .hog_on_boot = true }
 
-/*
- * Convenience macro to map a function onto the primary device pinctrl device
- * this is especially helpful on systems that have only one pin controller
- * or need to set up a lot of mappings on the primary controller.
- */
-#define PINMUX_MAP_PRIMARY(a, b, c) \
-	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b, \
-	  .dev_name = c }
-
-/*
- * Convenience macro to map a system function onto the primary pinctrl device.
- * System functions are not assigned to a particular device.
- */
-#define PINMUX_MAP_PRIMARY_SYS(a, b) \
-	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b }
-
-/*
- * Convenience macro to map a system function onto the primary pinctrl device,
- * to be hogged by the pinmux core until the system shuts down.
- */
-#define PINMUX_MAP_PRIMARY_SYS_HOG(a, b) \
-	{ .name = a, .ctrl_dev_name = "pinctrl.0", .function = b, \
-	  .hog_on_boot = true }
-
-
 #ifdef CONFIG_PINMUX
 
 extern int pinmux_register_mappings(struct pinmux_map const *map,
-- 
1.7.0.4

