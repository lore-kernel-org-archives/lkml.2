Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab2BITLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:11:51 -0500
Received: from mail.df.lth.se ([194.47.250.12]:38267 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286Ab2BITLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:11:20 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3] pinctrl: move generic functions to the pinctrl_ namespace
Date: Thu,  9 Feb 2012 20:01:25 +0100
Message-Id: <1328814085-22784-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we want to use the former pinmux handles and mapping tables for
generic control involving both muxing and configuration we begin
refactoring by renaming them from pinmux_* to pinctrl_*.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt        |  118 +++++++-------
 arch/arm/mach-u300/core.c        |   22 ++--
 drivers/pinctrl/core.c           |    4 +-
 drivers/pinctrl/core.h           |    8 +-
 drivers/pinctrl/pinctrl-coh901.c |    4 +-
 drivers/pinctrl/pinmux.c         |  351 +++++++++++++++++++-------------------
 drivers/pinctrl/pinmux.h         |    8 +-
 include/linux/pinctrl/consumer.h |   34 ++--
 include/linux/pinctrl/machine.h  |    8 +-
 9 files changed, 279 insertions(+), 278 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index b268832..2e71323 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -728,19 +728,19 @@ same time.
 All the above functions are mandatory to implement for a pinmux driver.
 
 
-Pinmux interaction with the GPIO subsystem
-==========================================
+Pin control interaction with the GPIO subsystem
+===============================================
 
-The public pinmux API contains two functions named pinmux_request_gpio()
-and pinmux_free_gpio(). These two functions shall *ONLY* be called from
+The public pinmux API contains two functions named pinctrl_request_gpio()
+and pinctrl_free_gpio(). These two functions shall *ONLY* be called from
 gpiolib-based drivers as part of their gpio_request() and
-gpio_free() semantics. Likewise the pinmux_gpio_direction_[input|output]
+gpio_free() semantics. Likewise the pinctrl_gpio_direction_[input|output]
 shall only be called from within respective gpio_direction_[input|output]
 gpiolib implementation.
 
 NOTE that platforms and individual drivers shall *NOT* request GPIO pins to be
-muxed in. Instead, implement a proper gpiolib driver and have that driver
-request proper muxing for its pins.
+controlled e.g. muxed in. Instead, implement a proper gpiolib driver and have
+that driver request proper muxing and other control for its pins.
 
 The function list could become long, especially if you can convert every
 individual pin into a GPIO pin independent of any other pins, and then try
@@ -749,7 +749,7 @@ the approach to define every pin as a function.
 In this case, the function array would become 64 entries for each GPIO
 setting and then the device functions.
 
-For this reason there are two functions a pinmux driver can implement
+For this reason there are two functions a pin control driver can implement
 to enable only GPIO on an individual pin: .gpio_request_enable() and
 .gpio_disable_free().
 
@@ -764,7 +764,7 @@ gpiolib driver and the affected GPIO range, pin offset and desired direction
 will be passed along to this function.
 
 Alternatively to using these special functions, it is fully allowed to use
-named functions for each GPIO pin, the pinmux_request_gpio() will attempt to
+named functions for each GPIO pin, the pinctrl_request_gpio() will attempt to
 obtain the function "gpioN" where "N" is the global GPIO pin number if no
 special GPIO-handler is registered.
 
@@ -783,7 +783,7 @@ spi on the second function mapping:
 
 #include <linux/pinctrl/machine.h>
 
-static const struct pinmux_map __initdata pmx_mapping[] = {
+static const struct pinctrl_map __initdata mapping[] = {
 	{
 		.ctrl_dev_name = "pinctrl-foo",
 		.function = "spi0",
@@ -811,14 +811,14 @@ to map.
 
 You register this pinmux mapping to the pinmux subsystem by simply:
 
-       ret = pinmux_register_mappings(pmx_mapping, ARRAY_SIZE(pmx_mapping));
+       ret = pinctrl_register_mappings(mapping, ARRAY_SIZE(mapping));
 
 Since the above construct is pretty common there is a helper macro to make
 it even more compact which assumes you want to use pinctrl-foo and position
 0 for mapping, for example:
 
-static struct pinmux_map __initdata pmx_mapping[] = {
-       PINMUX_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
+static struct pinctrl_map __initdata mapping[] = {
+       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
 };
 
 
@@ -901,7 +901,7 @@ case), we define a mapping like this:
 The result of grabbing this mapping from the device with something like
 this (see next paragraph):
 
-	pmx = pinmux_get(&device, "8bit");
+	p = pinctrl_get(&device, "8bit");
 
 Will be that you activate all the three bottom records in the mapping at
 once. Since they share the same name, pin controller device, funcion and
@@ -913,44 +913,44 @@ pinmux core.
 Pinmux requests from drivers
 ============================
 
-Generally it is discouraged to let individual drivers get and enable pinmuxes.
-So if possible, handle the pinmuxes in platform code or some other place where
-you have access to all the affected struct device * pointers. In some cases
-where a driver needs to switch between different mux mappings at runtime
-this is not possible.
+Generally it is discouraged to let individual drivers get and enable pin
+control. So if possible, handle the pin control in platform code or some other
+place where you have access to all the affected struct device * pointers. In
+some cases where a driver needs to e.g. switch between different mux mappings
+at runtime this is not possible.
 
-A driver may request a certain mux to be activated, usually just the default
-mux like this:
+A driver may request a certain control state to be activated, usually just the
+default state like this:
 
 #include <linux/pinctrl/consumer.h>
 
 struct foo_state {
-       struct pinmux *pmx;
+       struct pinctrl *p;
        ...
 };
 
 foo_probe()
 {
 	/* Allocate a state holder named "state" etc */
-	struct pinmux pmx;
+	struct pinctrl p;
 
-	pmx = pinmux_get(&device, NULL);
-	if IS_ERR(pmx)
-		return PTR_ERR(pmx);
-	pinmux_enable(pmx);
+	p = pinctrl_get(&device, NULL);
+	if IS_ERR(p)
+		return PTR_ERR(p);
+	pinctrl_enable(p);
 
-	state->pmx = pmx;
+	state->p = p;
 }
 
 foo_remove()
 {
-	pinmux_disable(state->pmx);
-	pinmux_put(state->pmx);
+	pinctrl_disable(state->p);
+	pinctrl_put(state->p);
 }
 
-If you want to grab a specific mux mapping and not just the first one found for
-this device you can specify a specific mapping name, for example in the above
-example the second i2c0 setting: pinmux_get(&device, "spi0-pos-B");
+If you want to grab a specific control mapping and not just the first one
+found for this device you can specify a specific mapping name, for example in
+the above example the second i2c0 setting: pinctrl_get(&device, "spi0-pos-B");
 
 This get/enable/disable/put sequence can just as well be handled by bus drivers
 if you don't want each and every driver to handle it and you know the
@@ -958,35 +958,35 @@ arrangement on your bus.
 
 The semantics of the get/enable respective disable/put is as follows:
 
-- pinmux_get() is called in process context to reserve the pins affected with
+- pinctrl_get() is called in process context to reserve the pins affected with
   a certain mapping and set up the pinmux core and the driver. It will allocate
   a struct from the kernel memory to hold the pinmux state.
 
-- pinmux_enable()/pinmux_disable() is quick and can be called from fastpath
+- pinctrl_enable()/pinctrl_disable() is quick and can be called from fastpath
   (irq context) when you quickly want to set up/tear down the hardware muxing
   when running a device driver. Usually it will just poke some values into a
   register.
 
-- pinmux_disable() is called in process context to tear down the pin requests
-  and release the state holder struct for the mux setting.
+- pinctrl_disable() is called in process context to tear down the pin requests
+  and release the state holder struct for the mux setting etc.
 
-Usually the pinmux core handled the get/put pair and call out to the device
-drivers bookkeeping operations, like checking available functions and the
-associated pins, whereas the enable/disable pass on to the pin controller
+Usually the pin control core handled the get/put pair and call out to the
+device drivers bookkeeping operations, like checking available functions and
+the associated pins, whereas the enable/disable pass on to the pin controller
 driver which takes care of activating and/or deactivating the mux setting by
 quickly poking some registers.
 
-The pins are allocated for your device when you issue the pinmux_get() call,
+The pins are allocated for your device when you issue the pinctrl_get() call,
 after this you should be able to see this in the debugfs listing of all pins.
 
 
-System pinmux hogging
-=====================
+System pin control hogging
+==========================
 
-A system pinmux map entry, i.e. a pinmux setting that does not have a device
-associated with it, can be hogged by the core when the pin controller is
-registered. This means that the core will attempt to call pinmux_get() and
-pinmux_enable() on it immediately after the pin control device has been
+A system pin control map entry, i.e. a pin control setting that does not have
+a device associated with it, can be hogged by the core when the pin controller
+is registered. This means that the core will attempt to call pinctrl_get() and
+pinctrl_enable() on it immediately after the pin control device has been
 registered.
 
 This is enabled by simply setting the .hog_on_boot field in the map to true,
@@ -1003,7 +1003,7 @@ Since it may be common to request the core to hog a few always-applicable
 mux settings on the primary pin controller, there is a convenience macro for
 this:
 
-PINMUX_MAP_PRIMARY_SYS_HOG("POWERMAP", "power_func")
+PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "power_func")
 
 This gives the exact same result as the above construction.
 
@@ -1025,23 +1025,23 @@ it, disables and releases it, and muxes it in on the pins defined by group B:
 
 foo_switch()
 {
-	struct pinmux *pmx;
+	struct pinctrl *p;
 
 	/* Enable on position A */
-	pmx = pinmux_get(&device, "spi0-pos-A");
-	if IS_ERR(pmx)
-		return PTR_ERR(pmx);
-	pinmux_enable(pmx);
+	p = pinctrl_get(&device, "spi0-pos-A");
+	if IS_ERR(p)
+		return PTR_ERR(p);
+	pinctrl_enable(p);
 
 	/* This releases the pins again */
-	pinmux_disable(pmx);
-	pinmux_put(pmx);
+	pinctrl_disable(p);
+	pinctrl_put(p);
 
 	/* Enable on position B */
-	pmx = pinmux_get(&device, "spi0-pos-B");
-	if IS_ERR(pmx)
-		return PTR_ERR(pmx);
-	pinmux_enable(pmx);
+	p = pinctrl_get(&device, "spi0-pos-B");
+	if IS_ERR(p)
+		return PTR_ERR(p);
+	pinctrl_enable(p);
 	...
 }
 
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 1429e52..1f6e56e 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1605,7 +1605,7 @@ static struct platform_device pinmux_device = {
 };
 
 /* Pinmux settings */
-static struct pinmux_map __initdata u300_pinmux_map[] = {
+static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
 	PINMUX_MAP_SYS_HOG("POWER", "pinmux-u300", "power"),
 	PINMUX_MAP_SYS_HOG("EMIF0", "pinmux-u300", "emif0"),
@@ -1619,7 +1619,7 @@ static struct pinmux_map __initdata u300_pinmux_map[] = {
 struct u300_mux_hog {
 	const char *name;
 	struct device *dev;
-	struct pinmux *pmx;
+	struct pinctrl *p;
 };
 
 static struct u300_mux_hog u300_mux_hogs[] = {
@@ -1637,31 +1637,31 @@ static struct u300_mux_hog u300_mux_hogs[] = {
 	},
 };
 
-static int __init u300_pinmux_fetch(void)
+static int __init u300_pinctrl_fetch(void)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(u300_mux_hogs); i++) {
-		struct pinmux *pmx;
+		struct pinctrl *p;
 		int ret;
 
-		pmx = pinmux_get(u300_mux_hogs[i].dev, NULL);
-		if (IS_ERR(pmx)) {
+		p = pinctrl_get(u300_mux_hogs[i].dev, NULL);
+		if (IS_ERR(p)) {
 			pr_err("u300: could not get pinmux hog %s\n",
 			       u300_mux_hogs[i].name);
 			continue;
 		}
-		ret = pinmux_enable(pmx);
+		ret = pinctrl_enable(p);
 		if (ret) {
 			pr_err("u300: could enable pinmux hog %s\n",
 			       u300_mux_hogs[i].name);
 			continue;
 		}
-		u300_mux_hogs[i].pmx = pmx;
+		u300_mux_hogs[i].p = p;
 	}
 	return 0;
 }
-subsys_initcall(u300_pinmux_fetch);
+subsys_initcall(u300_pinctrl_fetch);
 
 /*
  * Notice that AMBA devices are initialized before platform devices.
@@ -1861,8 +1861,8 @@ void __init u300_init_devices(void)
 	u300_assign_physmem();
 
 	/* Initialize pinmuxing */
-	pinmux_register_mappings(u300_pinmux_map,
-				 ARRAY_SIZE(u300_pinmux_map));
+	pinctrl_register_mappings(u300_pinmux_map,
+				  ARRAY_SIZE(u300_pinmux_map));
 
 	/* Register subdevices on the I2C buses */
 	u300_i2c_register_board_devices();
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4f10476..75c6a6b 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -624,7 +624,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	mutex_lock(&pinctrldev_list_mutex);
 	list_add(&pctldev->node, &pinctrldev_list);
 	mutex_unlock(&pinctrldev_list_mutex);
-	pinmux_hog_maps(pctldev);
+	pinctrl_hog_maps(pctldev);
 	return pctldev;
 
 out_err:
@@ -645,7 +645,7 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 		return;
 
 	pinctrl_remove_device_debugfs(pctldev);
-	pinmux_unhog_maps(pctldev);
+	pinctrl_unhog_maps(pctldev);
 	/* TODO: check that no pinmuxes are still active? */
 	mutex_lock(&pinctrldev_list_mutex);
 	list_del(&pctldev->node);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 8a8b02e..7a89888 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -28,8 +28,8 @@ struct pinctrl_gpio_range;
  * @owner: module providing the pin controller, used for refcounting
  * @driver_data: driver data for drivers registering to the pin controller
  *	subsystem
- * @pinmux_hogs_lock: lock for the pinmux hog list
- * @pinmux_hogs: list of pinmux maps hogged by this device
+ * @pinctrl_hogs_lock: lock for the pin control hog list
+ * @pinctrl_hogs: list of pin control maps hogged by this device
  */
 struct pinctrl_dev {
 	struct list_head node;
@@ -45,8 +45,8 @@ struct pinctrl_dev {
 	struct dentry *device_root;
 #endif
 #ifdef CONFIG_PINMUX
-	struct mutex pinmux_hogs_lock;
-	struct list_head pinmux_hogs;
+	struct mutex pinctrl_hogs_lock;
+	struct list_head pinctrl_hogs;
 #endif
 };
 
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 8bac3f0..eba232a 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -360,14 +360,14 @@ static int u300_gpio_request(struct gpio_chip *chip, unsigned offset)
 	 */
 	int gpio = chip->base + offset;
 
-	return pinmux_request_gpio(gpio);
+	return pinctrl_request_gpio(gpio);
 }
 
 static void u300_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
 	int gpio = chip->base + offset;
 
-	pinmux_free_gpio(gpio);
+	pinctrl_free_gpio(gpio);
 }
 
 static int u300_gpio_get(struct gpio_chip *chip, unsigned offset)
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 1311f1d..773835d 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -1,7 +1,7 @@
 /*
  * Core driver for the pin muxing portions of the pin control subsystem
  *
- * Copyright (C) 2011 ST-Ericsson SA
+ * Copyright (C) 2011-2012 ST-Ericsson SA
  * Written on behalf of Linaro for ST-Ericsson
  * Based on bits of regulator core, gpio core and clk core
  *
@@ -29,13 +29,13 @@
 #include <linux/pinctrl/pinmux.h>
 #include "core.h"
 
-/* List of pinmuxes */
-static DEFINE_MUTEX(pinmux_list_mutex);
-static LIST_HEAD(pinmux_list);
+/* List of pin controller handles */
+static DEFINE_MUTEX(pinctrl_list_mutex);
+static LIST_HEAD(pinctrl_list);
 
-/* Global pinmux maps */
-static struct pinmux_map *pinmux_maps;
-static unsigned pinmux_maps_num;
+/* Global pinctrl maps */
+static struct pinctrl_map *pinctrl_maps;
+static unsigned pinctrl_maps_num;
 
 /**
  * struct pinmux_group - group list item for pinmux groups
@@ -48,12 +48,12 @@ struct pinmux_group {
 };
 
 /**
- * struct pinmux - per-device pinmux state holder
+ * struct pinctrl - per-device pin control state holder
  * @node: global list node
- * @dev: the device using this pinmux
- * @usecount: the number of active users of this mux setting, used to keep
- *	track of nested use cases
- * @pctldev: pin control device handling this pinmux
+ * @dev: the device using this pin control handle
+ * @usecount: the number of active users of this pin controller setting, used
+ *	to keep track of nested use cases
+ * @pctldev: pin control device handling this pin control handle
  * @func_selector: the function selector for the pinmux device handling
  *	this pinmux
  * @groups: the group selectors for the pinmux device and
@@ -62,7 +62,7 @@ struct pinmux_group {
  *	get/put/enable/disable
  * @mutex: a lock for the pinmux state holder
  */
-struct pinmux {
+struct pinctrl {
 	struct list_head node;
 	struct device *dev;
 	unsigned usecount;
@@ -73,15 +73,15 @@ struct pinmux {
 };
 
 /**
- * struct pinmux_hog - a list item to stash mux hogs
- * @node: pinmux hog list node
+ * struct pinctrl_hog - a list item to stash control hogs
+ * @node: pin control hog list node
  * @map: map entry responsible for this hogging
- * @pmx: the pinmux hogged by this item
+ * @pmx: the pin control hogged by this item
  */
-struct pinmux_hog {
+struct pinctrl_hog {
 	struct list_head node;
-	struct pinmux_map const *map;
-	struct pinmux *pmx;
+	struct pinctrl_map const *map;
+	struct pinctrl *p;
 };
 
 /**
@@ -207,14 +207,14 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 }
 
 /**
- * pinmux_request_gpio() - request a single pin to be muxed in as GPIO
+ * pinctrl_request_gpio() - request a single pin to be used in as GPIO
  * @gpio: the GPIO pin number from the GPIO subsystem number space
  *
  * This function should *ONLY* be used from gpiolib-based GPIO drivers,
  * as part of their gpio_request() semantics, platforms and individual drivers
  * shall *NOT* request GPIO pins to be muxed in.
  */
-int pinmux_request_gpio(unsigned gpio)
+int pinctrl_request_gpio(unsigned gpio)
 {
 	char gpiostr[16];
 	const char *function;
@@ -243,17 +243,17 @@ int pinmux_request_gpio(unsigned gpio)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pinmux_request_gpio);
+EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
 
 /**
- * pinmux_free_gpio() - free a single pin, currently used as GPIO
+ * pinctrl_free_gpio() - free control on a single pin, currently used as GPIO
  * @gpio: the GPIO pin number from the GPIO subsystem number space
  *
  * This function should *ONLY* be used from gpiolib-based GPIO drivers,
  * as part of their gpio_free() semantics, platforms and individual drivers
  * shall *NOT* request GPIO pins to be muxed out.
  */
-void pinmux_free_gpio(unsigned gpio)
+void pinctrl_free_gpio(unsigned gpio)
 {
 	struct pinctrl_dev *pctldev;
 	struct pinctrl_gpio_range *range;
@@ -271,9 +271,9 @@ void pinmux_free_gpio(unsigned gpio)
 	func = pin_free(pctldev, pin, range);
 	kfree(func);
 }
-EXPORT_SYMBOL_GPL(pinmux_free_gpio);
+EXPORT_SYMBOL_GPL(pinctrl_free_gpio);
 
-static int pinmux_gpio_direction(unsigned gpio, bool input)
+static int pinctrl_gpio_direction(unsigned gpio, bool input)
 {
 	struct pinctrl_dev *pctldev;
 	struct pinctrl_gpio_range *range;
@@ -299,36 +299,36 @@ static int pinmux_gpio_direction(unsigned gpio, bool input)
 }
 
 /**
- * pinmux_gpio_direction_input() - request a GPIO pin to go into input mode
+ * pinctrl_gpio_direction_input() - request a GPIO pin to go into input mode
  * @gpio: the GPIO pin number from the GPIO subsystem number space
  *
  * This function should *ONLY* be used from gpiolib-based GPIO drivers,
  * as part of their gpio_direction_input() semantics, platforms and individual
- * drivers shall *NOT* touch pinmux GPIO calls.
+ * drivers shall *NOT* touch pin control GPIO calls.
  */
-int pinmux_gpio_direction_input(unsigned gpio)
+int pinctrl_gpio_direction_input(unsigned gpio)
 {
-	return pinmux_gpio_direction(gpio, true);
+	return pinctrl_gpio_direction(gpio, true);
 }
-EXPORT_SYMBOL_GPL(pinmux_gpio_direction_input);
+EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_input);
 
 /**
- * pinmux_gpio_direction_output() - request a GPIO pin to go into output mode
+ * pinctrl_gpio_direction_output() - request a GPIO pin to go into output mode
  * @gpio: the GPIO pin number from the GPIO subsystem number space
  *
  * This function should *ONLY* be used from gpiolib-based GPIO drivers,
  * as part of their gpio_direction_output() semantics, platforms and individual
- * drivers shall *NOT* touch pinmux GPIO calls.
+ * drivers shall *NOT* touch pin control GPIO calls.
  */
-int pinmux_gpio_direction_output(unsigned gpio)
+int pinctrl_gpio_direction_output(unsigned gpio)
 {
-	return pinmux_gpio_direction(gpio, false);
+	return pinctrl_gpio_direction(gpio, false);
 }
-EXPORT_SYMBOL_GPL(pinmux_gpio_direction_output);
+EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
 
 /**
- * pinmux_register_mappings() - register a set of pinmux mappings
- * @maps: the pinmux mappings table to register, this should be marked with
+ * pinctrl_register_mappings() - register a set of pin controller mappings
+ * @maps: the pincontrol mappings table to register, this should be marked with
  *	__initdata so it can be discarded after boot, this function will
  *	perform a shallow copy for the mapping entries.
  * @num_maps: the number of maps in the mapping table
@@ -338,8 +338,8 @@ EXPORT_SYMBOL_GPL(pinmux_gpio_direction_output);
  * passed into this function will be owned by the pinmux core and cannot be
  * freed.
  */
-int __init pinmux_register_mappings(struct pinmux_map const *maps,
-				    unsigned num_maps)
+int __init pinctrl_register_mappings(struct pinctrl_map const *maps,
+				     unsigned num_maps)
 {
 	void *tmp_maps;
 	int i;
@@ -380,26 +380,27 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 	 * Make a copy of the map array - string pointers will end up in the
 	 * kernel const section anyway so these do not need to be deep copied.
 	 */
-	if (!pinmux_maps_num) {
+	if (!pinctrl_maps_num) {
 		/* On first call, just copy them */
 		tmp_maps = kmemdup(maps,
-				   sizeof(struct pinmux_map) * num_maps,
+				   sizeof(struct pinctrl_map) * num_maps,
 				   GFP_KERNEL);
 		if (!tmp_maps)
 			return -ENOMEM;
 	} else {
 		/* Subsequent calls, reallocate array to new size */
-		size_t oldsize = sizeof(struct pinmux_map) * pinmux_maps_num;
-		size_t newsize = sizeof(struct pinmux_map) * num_maps;
+		size_t oldsize = sizeof(struct pinctrl_map) * pinctrl_maps_num;
+		size_t newsize = sizeof(struct pinctrl_map) * num_maps;
 
-		tmp_maps = krealloc(pinmux_maps, oldsize + newsize, GFP_KERNEL);
+		tmp_maps = krealloc(pinctrl_maps,
+				    oldsize + newsize, GFP_KERNEL);
 		if (!tmp_maps)
 			return -ENOMEM;
 		memcpy((tmp_maps + oldsize), maps, newsize);
 	}
 
-	pinmux_maps = tmp_maps;
-	pinmux_maps_num += num_maps;
+	pinctrl_maps = tmp_maps;
+	pinctrl_maps_num += num_maps;
 	return 0;
 }
 
@@ -560,7 +561,7 @@ static int pinmux_check_pin_group(struct pinctrl_dev *pctldev,
  * negative otherwise
  */
 static int pinmux_search_function(struct pinctrl_dev *pctldev,
-				  struct pinmux_map const *map,
+				  struct pinctrl_map const *map,
 				  unsigned *func_selector,
 				  unsigned *group_selector)
 {
@@ -598,10 +599,10 @@ static int pinmux_search_function(struct pinctrl_dev *pctldev,
  * pinmux_enable_muxmap() - enable a map entry for a certain pinmux
  */
 static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
-				struct pinmux *pmx,
+				struct pinctrl *p,
 				struct device *dev,
 				const char *devname,
-				struct pinmux_map const *map)
+				struct pinctrl_map const *map)
 {
 	unsigned func_selector;
 	unsigned group_selector;
@@ -615,14 +616,14 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 	 * by anyone else.
 	 */
 
-	if (pmx->pctldev && pmx->pctldev != pctldev) {
+	if (p->pctldev && p->pctldev != pctldev) {
 		dev_err(pctldev->dev,
 			"different pin control devices given for device %s, function %s\n",
 			devname, map->function);
 		return -EINVAL;
 	}
-	pmx->dev = dev;
-	pmx->pctldev = pctldev;
+	p->dev = dev;
+	p->pctldev = pctldev;
 
 	/* Now go into the driver and try to match a function and group */
 	ret = pinmux_search_function(pctldev, map, &func_selector,
@@ -635,14 +636,14 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 	 * we support several groups with one function but not several
 	 * functions with one or several groups in the same pinmux.
 	 */
-	if (pmx->func_selector != UINT_MAX &&
-	    pmx->func_selector != func_selector) {
+	if (p->func_selector != UINT_MAX &&
+	    p->func_selector != func_selector) {
 		dev_err(pctldev->dev,
 			"dual function defines in the map for device %s\n",
 		       devname);
 		return -EINVAL;
 	}
-	pmx->func_selector = func_selector;
+	p->func_selector = func_selector;
 
 	/* Now add this group selector, we may have many of them */
 	grp = kmalloc(sizeof(struct pinmux_group), GFP_KERNEL);
@@ -654,38 +655,38 @@ static int pinmux_enable_muxmap(struct pinctrl_dev *pctldev,
 		kfree(grp);
 		return ret;
 	}
-	list_add(&grp->node, &pmx->groups);
+	list_add(&grp->node, &p->groups);
 
 	return 0;
 }
 
-static void pinmux_free_groups(struct pinmux *pmx)
+static void pinmux_free_groups(struct pinctrl *p)
 {
 	struct list_head *node, *tmp;
 
-	list_for_each_safe(node, tmp, &pmx->groups) {
+	list_for_each_safe(node, tmp, &p->groups) {
 		struct pinmux_group *grp =
 			list_entry(node, struct pinmux_group, node);
 		/* Release all pins taken by this group */
-		release_pins(pmx->pctldev, grp->group_selector);
+		release_pins(p->pctldev, grp->group_selector);
 		list_del(node);
 		kfree(grp);
 	}
 }
 
 /**
- * pinmux_get() - retrieves the pinmux for a certain device
- * @dev: the device to get the pinmux for
- * @name: an optional specific mux mapping name or NULL, the name is only
+ * pinctrl_get() - retrieves the pin controller handle for a certain device
+ * @dev: the device to get the pin controller handle for
+ * @name: an optional specific control mapping name or NULL, the name is only
  *	needed if you want to have more than one mapping per device, or if you
- *	need an anonymous pinmux (not tied to any specific device)
+ *	need an anonymous pin control (not tied to any specific device)
  */
-struct pinmux *pinmux_get(struct device *dev, const char *name)
+struct pinctrl *pinctrl_get(struct device *dev, const char *name)
 {
-	struct pinmux_map const *map = NULL;
+	struct pinctrl_map const *map = NULL;
 	struct pinctrl_dev *pctldev = NULL;
 	const char *devname = NULL;
-	struct pinmux *pmx;
+	struct pinctrl *p;
 	bool found_map;
 	unsigned num_maps = 0;
 	int ret = -ENODEV;
@@ -706,16 +707,16 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 	 * mapping, this is what consumers will get when requesting
 	 * a pinmux handle with pinmux_get()
 	 */
-	pmx = kzalloc(sizeof(struct pinmux), GFP_KERNEL);
-	if (pmx == NULL)
+	p = kzalloc(sizeof(struct pinctrl), GFP_KERNEL);
+	if (p == NULL)
 		return ERR_PTR(-ENOMEM);
-	mutex_init(&pmx->mutex);
-	pmx->func_selector = UINT_MAX;
-	INIT_LIST_HEAD(&pmx->groups);
+	mutex_init(&p->mutex);
+	p->func_selector = UINT_MAX;
+	INIT_LIST_HEAD(&p->groups);
 
-	/* Iterate over the pinmux maps to locate the right ones */
-	for (i = 0; i < pinmux_maps_num; i++) {
-		map = &pinmux_maps[i];
+	/* Iterate over the pin control maps to locate the right ones */
+	for (i = 0; i < pinctrl_maps_num; i++) {
+		map = &pinctrl_maps[i];
 		found_map = false;
 
 		/*
@@ -763,11 +764,11 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 
 		/* If this map is applicable, then apply it */
 		if (found_map) {
-			ret = pinmux_enable_muxmap(pctldev, pmx, dev,
+			ret = pinmux_enable_muxmap(pctldev, p, dev,
 						   devname, map);
 			if (ret) {
-				pinmux_free_groups(pmx);
-				kfree(pmx);
+				pinmux_free_groups(p);
+				kfree(p);
 				return ERR_PTR(ret);
 			}
 			num_maps++;
@@ -780,7 +781,7 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 		pr_err("could not find any mux maps for device %s, ID %s\n",
 		       devname ? devname : "(anonymous)",
 		       name ? name : "(undefined)");
-		kfree(pmx);
+		kfree(p);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -790,96 +791,96 @@ struct pinmux *pinmux_get(struct device *dev, const char *name)
 		 name ? name : "(undefined)");
 
 	/* Add the pinmux to the global list */
-	mutex_lock(&pinmux_list_mutex);
-	list_add(&pmx->node, &pinmux_list);
-	mutex_unlock(&pinmux_list_mutex);
+	mutex_lock(&pinctrl_list_mutex);
+	list_add(&p->node, &pinctrl_list);
+	mutex_unlock(&pinctrl_list_mutex);
 
-	return pmx;
+	return p;
 }
-EXPORT_SYMBOL_GPL(pinmux_get);
+EXPORT_SYMBOL_GPL(pinctrl_get);
 
 /**
- * pinmux_put() - release a previously claimed pinmux
- * @pmx: a pinmux previously claimed by pinmux_get()
+ * pinctrl_put() - release a previously claimed pin control handle
+ * @p: a pin control handle previously claimed by pinctrl_get()
  */
-void pinmux_put(struct pinmux *pmx)
+void pinctrl_put(struct pinctrl *p)
 {
-	if (pmx == NULL)
+	if (p == NULL)
 		return;
 
-	mutex_lock(&pmx->mutex);
-	if (pmx->usecount)
-		pr_warn("releasing pinmux with active users!\n");
+	mutex_lock(&p->mutex);
+	if (p->usecount)
+		pr_warn("releasing pin control handle with active users!\n");
 	/* Free the groups and all acquired pins */
-	pinmux_free_groups(pmx);
-	mutex_unlock(&pmx->mutex);
+	pinmux_free_groups(p);
+	mutex_unlock(&p->mutex);
 
 	/* Remove from list */
-	mutex_lock(&pinmux_list_mutex);
-	list_del(&pmx->node);
-	mutex_unlock(&pinmux_list_mutex);
+	mutex_lock(&pinctrl_list_mutex);
+	list_del(&p->node);
+	mutex_unlock(&pinctrl_list_mutex);
 
-	kfree(pmx);
+	kfree(p);
 }
-EXPORT_SYMBOL_GPL(pinmux_put);
+EXPORT_SYMBOL_GPL(pinctrl_put);
 
 /**
- * pinmux_enable() - enable a certain pinmux setting
- * @pmx: the pinmux to enable, previously claimed by pinmux_get()
+ * pinctrl_enable() - enable a certain pin controller setting
+ * @p: the pin control handle to enable, previously claimed by pinctrl_get()
  */
-int pinmux_enable(struct pinmux *pmx)
+int pinctrl_enable(struct pinctrl *p)
 {
 	int ret = 0;
 
-	if (pmx == NULL)
+	if (p == NULL)
 		return -EINVAL;
-	mutex_lock(&pmx->mutex);
-	if (pmx->usecount++ == 0) {
-		struct pinctrl_dev *pctldev = pmx->pctldev;
+	mutex_lock(&p->mutex);
+	if (p->usecount++ == 0) {
+		struct pinctrl_dev *pctldev = p->pctldev;
 		const struct pinmux_ops *ops = pctldev->desc->pmxops;
 		struct pinmux_group *grp;
 
-		list_for_each_entry(grp, &pmx->groups, node) {
-			ret = ops->enable(pctldev, pmx->func_selector,
+		list_for_each_entry(grp, &p->groups, node) {
+			ret = ops->enable(pctldev, p->func_selector,
 					  grp->group_selector);
 			if (ret) {
 				/*
 				 * TODO: call disable() on all groups we called
 				 * enable() on to this point?
 				 */
-				pmx->usecount--;
+				p->usecount--;
 				break;
 			}
 		}
 	}
-	mutex_unlock(&pmx->mutex);
+	mutex_unlock(&p->mutex);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pinmux_enable);
+EXPORT_SYMBOL_GPL(pinctrl_enable);
 
 /**
- * pinmux_disable() - disable a certain pinmux setting
- * @pmx: the pinmux to disable, previously claimed by pinmux_get()
+ * pinctrl_disable() - disable a certain pin control setting
+ * @p: the pin control handle to disable, previously claimed by pinctrl_get()
  */
-void pinmux_disable(struct pinmux *pmx)
+void pinctrl_disable(struct pinctrl *p)
 {
-	if (pmx == NULL)
+	if (p == NULL)
 		return;
 
-	mutex_lock(&pmx->mutex);
-	if (--pmx->usecount == 0) {
-		struct pinctrl_dev *pctldev = pmx->pctldev;
+	mutex_lock(&p->mutex);
+	if (--p->usecount == 0) {
+		struct pinctrl_dev *pctldev = p->pctldev;
 		const struct pinmux_ops *ops = pctldev->desc->pmxops;
 		struct pinmux_group *grp;
 
-		list_for_each_entry(grp, &pmx->groups, node) {
-			ops->disable(pctldev, pmx->func_selector,
+		list_for_each_entry(grp, &p->groups, node) {
+			ops->disable(pctldev, p->func_selector,
 				     grp->group_selector);
 		}
 	}
-	mutex_unlock(&pmx->mutex);
+	mutex_unlock(&p->mutex);
 }
-EXPORT_SYMBOL_GPL(pinmux_disable);
+EXPORT_SYMBOL_GPL(pinctrl_disable);
 
 int pinmux_check_ops(struct pinctrl_dev *pctldev)
 {
@@ -910,11 +911,11 @@ int pinmux_check_ops(struct pinctrl_dev *pctldev)
 }
 
 /* Hog a single map entry and add to the hoglist */
-static int pinmux_hog_map(struct pinctrl_dev *pctldev,
-			  struct pinmux_map const *map)
+static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
+			   struct pinctrl_map const *map)
 {
-	struct pinmux_hog *hog;
-	struct pinmux *pmx;
+	struct pinctrl_hog *hog;
+	struct pinctrl *p;
 	int ret;
 
 	if (map->dev_name) {
@@ -929,61 +930,61 @@ static int pinmux_hog_map(struct pinctrl_dev *pctldev,
 		return -EINVAL;
 	}
 
-	hog = kzalloc(sizeof(struct pinmux_hog), GFP_KERNEL);
+	hog = kzalloc(sizeof(struct pinctrl_hog), GFP_KERNEL);
 	if (!hog)
 		return -ENOMEM;
 
-	pmx = pinmux_get(NULL, map->name);
-	if (IS_ERR(pmx)) {
+	p = pinctrl_get(NULL, map->name);
+	if (IS_ERR(p)) {
 		kfree(hog);
 		dev_err(pctldev->dev,
-			"could not get the %s pinmux mapping for hogging\n",
+			"could not get the %s pin control mapping for hogging\n",
 			map->name);
-		return PTR_ERR(pmx);
+		return PTR_ERR(p);
 	}
 
-	ret = pinmux_enable(pmx);
+	ret = pinctrl_enable(p);
 	if (ret) {
-		pinmux_put(pmx);
+		pinctrl_put(p);
 		kfree(hog);
 		dev_err(pctldev->dev,
-			"could not enable the %s pinmux mapping for hogging\n",
+			"could not enable the %s pin control mapping for hogging\n",
 			map->name);
 		return ret;
 	}
 
 	hog->map = map;
-	hog->pmx = pmx;
+	hog->p = p;
 
 	dev_info(pctldev->dev, "hogged map %s, function %s\n", map->name,
 		 map->function);
-	mutex_lock(&pctldev->pinmux_hogs_lock);
-	list_add(&hog->node, &pctldev->pinmux_hogs);
-	mutex_unlock(&pctldev->pinmux_hogs_lock);
+	mutex_lock(&pctldev->pinctrl_hogs_lock);
+	list_add(&hog->node, &pctldev->pinctrl_hogs);
+	mutex_unlock(&pctldev->pinctrl_hogs_lock);
 
 	return 0;
 }
 
 /**
- * pinmux_hog_maps() - hog specific map entries on controller device
+ * pinctrl_hog_maps() - hog specific map entries on controller device
  * @pctldev: the pin control device to hog entries on
  *
  * When the pin controllers are registered, there may be some specific pinmux
  * map entries that need to be hogged, i.e. get+enabled until the system shuts
  * down.
  */
-int pinmux_hog_maps(struct pinctrl_dev *pctldev)
+int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
 {
 	struct device *dev = pctldev->dev;
 	const char *devname = dev_name(dev);
 	int ret;
 	int i;
 
-	INIT_LIST_HEAD(&pctldev->pinmux_hogs);
-	mutex_init(&pctldev->pinmux_hogs_lock);
+	INIT_LIST_HEAD(&pctldev->pinctrl_hogs);
+	mutex_init(&pctldev->pinctrl_hogs_lock);
 
-	for (i = 0; i < pinmux_maps_num; i++) {
-		struct pinmux_map const *map = &pinmux_maps[i];
+	for (i = 0; i < pinctrl_maps_num; i++) {
+		struct pinctrl_map const *map = &pinctrl_maps[i];
 
 		if (!map->hog_on_boot)
 			continue;
@@ -991,7 +992,7 @@ int pinmux_hog_maps(struct pinctrl_dev *pctldev)
 		if (map->ctrl_dev_name &&
 		    !strcmp(map->ctrl_dev_name, devname)) {
 			/* OK time to hog! */
-			ret = pinmux_hog_map(pctldev, map);
+			ret = pinctrl_hog_map(pctldev, map);
 			if (ret)
 				return ret;
 		}
@@ -1000,23 +1001,23 @@ int pinmux_hog_maps(struct pinctrl_dev *pctldev)
 }
 
 /**
- * pinmux_unhog_maps() - unhog specific map entries on controller device
+ * pinctrl_unhog_maps() - unhog specific map entries on controller device
  * @pctldev: the pin control device to unhog entries on
  */
-void pinmux_unhog_maps(struct pinctrl_dev *pctldev)
+void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
 {
 	struct list_head *node, *tmp;
 
-	mutex_lock(&pctldev->pinmux_hogs_lock);
-	list_for_each_safe(node, tmp, &pctldev->pinmux_hogs) {
-		struct pinmux_hog *hog =
-			list_entry(node, struct pinmux_hog, node);
-		pinmux_disable(hog->pmx);
-		pinmux_put(hog->pmx);
+	mutex_lock(&pctldev->pinctrl_hogs_lock);
+	list_for_each_safe(node, tmp, &pctldev->pinctrl_hogs) {
+		struct pinctrl_hog *hog =
+			list_entry(node, struct pinctrl_hog, node);
+		pinctrl_disable(hog->p);
+		pinctrl_put(hog->p);
 		list_del(node);
 		kfree(hog);
 	}
-	mutex_unlock(&pctldev->pinmux_hogs_lock);
+	mutex_unlock(&pctldev->pinctrl_hogs_lock);
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -1085,11 +1086,11 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 static int pinmux_hogs_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev = s->private;
-	struct pinmux_hog *hog;
+	struct pinctrl_hog *hog;
 
-	seq_puts(s, "Pinmux map hogs held by device\n");
+	seq_puts(s, "Pin control map hogs held by device\n");
 
-	list_for_each_entry(hog, &pctldev->pinmux_hogs, node)
+	list_for_each_entry(hog, &pctldev->pinctrl_hogs, node)
 		seq_printf(s, "%s\n", hog->map->name);
 
 	return 0;
@@ -1097,11 +1098,11 @@ static int pinmux_hogs_show(struct seq_file *s, void *what)
 
 static int pinmux_show(struct seq_file *s, void *what)
 {
-	struct pinmux *pmx;
+	struct pinctrl *p;
 
 	seq_puts(s, "Requested pinmuxes and their maps:\n");
-	list_for_each_entry(pmx, &pinmux_list, node) {
-		struct pinctrl_dev *pctldev = pmx->pctldev;
+	list_for_each_entry(p, &pinctrl_list, node) {
+		struct pinctrl_dev *pctldev = p->pctldev;
 		const struct pinmux_ops *pmxops;
 		const struct pinctrl_ops *pctlops;
 		struct pinmux_group *grp;
@@ -1115,13 +1116,13 @@ static int pinmux_show(struct seq_file *s, void *what)
 		pctlops = pctldev->desc->pctlops;
 
 		seq_printf(s, "device: %s function: %s (%u),",
-			   pinctrl_dev_get_name(pmx->pctldev),
+			   pinctrl_dev_get_name(p->pctldev),
 			   pmxops->get_function_name(pctldev,
-				   pmx->func_selector),
-			   pmx->func_selector);
+				   p->func_selector),
+			   p->func_selector);
 
 		seq_printf(s, " groups: [");
-		list_for_each_entry(grp, &pmx->groups, node) {
+		list_for_each_entry(grp, &p->groups, node) {
 			seq_printf(s, " %s (%u)",
 				   pctlops->get_group_name(pctldev,
 					   grp->group_selector),
@@ -1130,21 +1131,21 @@ static int pinmux_show(struct seq_file *s, void *what)
 		seq_printf(s, " ]");
 
 		seq_printf(s, " users: %u map-> %s\n",
-			   pmx->usecount,
-			   pmx->dev ? dev_name(pmx->dev) : "(system)");
+			   p->usecount,
+			   p->dev ? dev_name(p->dev) : "(system)");
 	}
 
 	return 0;
 }
 
-static int pinmux_maps_show(struct seq_file *s, void *what)
+static int pinctrl_maps_show(struct seq_file *s, void *what)
 {
 	int i;
 
-	seq_puts(s, "Pinmux maps:\n");
+	seq_puts(s, "Pinctrl maps:\n");
 
-	for (i = 0; i < pinmux_maps_num; i++) {
-		struct pinmux_map const *map = &pinmux_maps[i];
+	for (i = 0; i < pinctrl_maps_num; i++) {
+		struct pinctrl_map const *map = &pinctrl_maps[i];
 
 		seq_printf(s, "%s:\n", map->name);
 		if (map->dev_name)
@@ -1181,9 +1182,9 @@ static int pinmux_open(struct inode *inode, struct file *file)
 	return single_open(file, pinmux_show, NULL);
 }
 
-static int pinmux_maps_open(struct inode *inode, struct file *file)
+static int pinctrl_maps_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, pinmux_maps_show, NULL);
+	return single_open(file, pinctrl_maps_show, NULL);
 }
 
 static const struct file_operations pinmux_functions_ops = {
@@ -1214,8 +1215,8 @@ static const struct file_operations pinmux_ops = {
 	.release	= single_release,
 };
 
-static const struct file_operations pinmux_maps_ops = {
-	.open		= pinmux_maps_open,
+static const struct file_operations pinctrl_maps_ops = {
+	.open		= pinctrl_maps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
@@ -1236,8 +1237,8 @@ void pinmux_init_debugfs(struct dentry *subsys_root)
 {
 	debugfs_create_file("pinmuxes", S_IFREG | S_IRUGO,
 			    subsys_root, NULL, &pinmux_ops);
-	debugfs_create_file("pinmux-maps", S_IFREG | S_IRUGO,
-			    subsys_root, NULL, &pinmux_maps_ops);
+	debugfs_create_file("pinctrl-maps", S_IFREG | S_IRUGO,
+			    subsys_root, NULL, &pinctrl_maps_ops);
 }
 
 #endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index 97f5222..dfe8172 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -16,8 +16,8 @@ int pinmux_check_ops(struct pinctrl_dev *pctldev);
 void pinmux_init_device_debugfs(struct dentry *devroot,
 				struct pinctrl_dev *pctldev);
 void pinmux_init_debugfs(struct dentry *subsys_root);
-int pinmux_hog_maps(struct pinctrl_dev *pctldev);
-void pinmux_unhog_maps(struct pinctrl_dev *pctldev);
+int pinctrl_hog_maps(struct pinctrl_dev *pctldev);
+void pinctrl_unhog_maps(struct pinctrl_dev *pctldev);
 
 #else
 
@@ -35,12 +35,12 @@ static inline void pinmux_init_debugfs(struct dentry *subsys_root)
 {
 }
 
-static inline int pinmux_hog_maps(struct pinctrl_dev *pctldev)
+static inline int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
 {
 	return 0;
 }
 
-static inline void pinmux_unhog_maps(struct pinctrl_dev *pctldev)
+static inline void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
 {
 }
 
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 9c8513d..c7d0617 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -17,56 +17,56 @@
 #include "pinctrl.h"
 
 /* This struct is private to the core and should be regarded as a cookie */
-struct pinmux;
+struct pinctrl;
 
 #ifdef CONFIG_PINMUX
 
 /* External interface to pinmux */
-extern int pinmux_request_gpio(unsigned gpio);
-extern void pinmux_free_gpio(unsigned gpio);
-extern int pinmux_gpio_direction_input(unsigned gpio);
-extern int pinmux_gpio_direction_output(unsigned gpio);
-extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *name);
-extern void pinmux_put(struct pinmux *pmx);
-extern int pinmux_enable(struct pinmux *pmx);
-extern void pinmux_disable(struct pinmux *pmx);
+extern int pinctrl_request_gpio(unsigned gpio);
+extern void pinctrl_free_gpio(unsigned gpio);
+extern int pinctrl_gpio_direction_input(unsigned gpio);
+extern int pinctrl_gpio_direction_output(unsigned gpio);
+extern struct pinctrl * __must_check pinctrl_get(struct device *dev, const char *name);
+extern void pinctrl_put(struct pinctrl *p);
+extern int pinctrl_enable(struct pinctrl *p);
+extern void pinctrl_disable(struct pinctrl *p);
 
 #else /* !CONFIG_PINMUX */
 
-static inline int pinmux_request_gpio(unsigned gpio)
+static inline int pinctrl_request_gpio(unsigned gpio)
 {
 	return 0;
 }
 
-static inline void pinmux_free_gpio(unsigned gpio)
+static inline void pinctrl_free_gpio(unsigned gpio)
 {
 }
 
-static inline int pinmux_gpio_direction_input(unsigned gpio)
+static inline int pinctrl_gpio_direction_input(unsigned gpio)
 {
 	return 0;
 }
 
-static inline int pinmux_gpio_direction_output(unsigned gpio)
+static inline int pinctrl_gpio_direction_output(unsigned gpio)
 {
 	return 0;
 }
 
-static inline struct pinmux * __must_check pinmux_get(struct device *dev, const char *name)
+static inline struct pinctrl * __must_check pinctrl_get(struct device *dev, const char *name)
 {
 	return NULL;
 }
 
-static inline void pinmux_put(struct pinmux *pmx)
+static inline void pinctrl_put(struct pinctrl *p)
 {
 }
 
-static inline int pinmux_enable(struct pinmux *pmx)
+static inline int pinctrl_enable(struct pinctrl *p)
 {
 	return 0;
 }
 
-static inline void pinmux_disable(struct pinmux *pmx)
+static inline void pinctrl_disable(struct pinctrl *p)
 {
 }
 
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index f8593fd..3ca919d 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -13,7 +13,7 @@
 #define __LINUX_PINMUX_MACHINE_H
 
 /**
- * struct pinmux_map - boards/machines shall provide this map for devices
+ * struct pinctrl_map - boards/machines shall provide this map for devices
  * @name: the name of this specific map entry for the particular machine.
  *	This is the second parameter passed to pinmux_get() when you want
  *	to have several mappings to the same device
@@ -34,7 +34,7 @@
  *	a pinmux device supporting it is registered. These maps will not be
  *	disabled and put until the system shuts down.
  */
-struct pinmux_map {
+struct pinctrl_map {
 	const char *name;
 	const char *ctrl_dev_name;
 	const char *function;
@@ -76,12 +76,12 @@ struct pinmux_map {
 
 #ifdef CONFIG_PINMUX
 
-extern int pinmux_register_mappings(struct pinmux_map const *map,
+extern int pinctrl_register_mappings(struct pinctrl_map const *map,
 				unsigned num_maps);
 
 #else
 
-static inline int pinmux_register_mappings(struct pinmux_map const *map,
+static inline int pinctrl_register_mappings(struct pinctrl_map const *map,
 					   unsigned num_maps)
 {
 	return 0;
-- 
1.7.7.6

