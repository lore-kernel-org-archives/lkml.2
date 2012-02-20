Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2BTGrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:47:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19504 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2BTGr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:47:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 19 Feb 2012 22:46:21 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: B29396@freescale.com, s.hauer@pengutronix.de, dongas86@gmail.com,
        shawn.guo@linaro.org, thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 19/20] pinctrl: API changes to support multiple states per device
Date: Sun, 19 Feb 2012 23:45:59 -0700
Message-Id: <1329720360-23227-20-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API model is changed from:

p = pinctrl_get(dev, "state1");
pinctrl_enable(p);
...
pinctrl_disable(p);
pinctrl_put(p);
p = pinctrl_get(dev, "state2");
pinctrl_enable(p);
...
pinctrl_disable(p);
pinctrl_put(p);

to this:

p = pinctrl_get(dev);
s1 = pinctrl_lookup_state(p, "state1");
s2 = pinctrl_lookup_state(p, "state2");
pinctrl_select_state(p, s1);
...
pinctrl_select_state(p, s2);
...
pinctrl_put(p);

This allows devices to directly transition between states without
disabling the pin controller programming and put()/get()ing the
configuration data each time. This model will also better suit pinconf
programming, which doesn't have a concept of "disable".

The special-case hogging feature of pin controllers is re-written to use
the regular APIs instead of special-case code. Hence, the pinmux-hogs
debugfs file is removed; see the top-level pinctrl-handles files for
equivalent data.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 Documentation/pinctrl.txt         |  153 ++++++++-----
 arch/arm/mach-u300/core.c         |   28 +--
 drivers/pinctrl/core.c            |  491 +++++++++++++++++--------------------
 drivers/pinctrl/core.h            |   24 ++-
 drivers/tty/serial/sirfsoc_uart.c |   12 +-
 include/linux/pinctrl/consumer.h  |   55 ++++-
 include/linux/pinctrl/machine.h   |   21 +-
 7 files changed, 408 insertions(+), 376 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 12b35db..cacd857 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -781,19 +781,22 @@ spi on the second function mapping:
 
 static const struct pinctrl_map __initdata mapping[] = {
 	{
+		.dev_name = "foo-spi.0",
+		.name = "default",
 		.ctrl_dev_name = "pinctrl-foo",
 		.function = "spi0",
-		.dev_name = "foo-spi.0",
 	},
 	{
+		.dev_name = "foo-i2c.0",
+		.name = "default",
 		.ctrl_dev_name = "pinctrl-foo",
 		.function = "i2c0",
-		.dev_name = "foo-i2c.0",
 	},
 	{
+		.dev_name = "foo-mmc.0",
+		.name = "default",
 		.ctrl_dev_name = "pinctrl-foo",
 		.function = "mmc0",
-		.dev_name = "foo-mmc.0",
 	},
 };
 
@@ -814,7 +817,7 @@ it even more compact which assumes you want to use pinctrl-foo and position
 0 for mapping, for example:
 
 static struct pinctrl_map __initdata mapping[] = {
-       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
+       PIN_MAP("default", "pinctrl-foo", "i2c0", "foo-i2c.0"),
 };
 
 
@@ -826,81 +829,88 @@ As it is possible to map a function to different groups of pins an optional
 
 ...
 {
+	.dev_name = "foo-spi.0",
 	.name = "spi0-pos-A",
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "spi0",
 	.group = "spi0_0_grp",
-	.dev_name = "foo-spi.0",
 },
 {
+	.dev_name = "foo-spi.0",
 	.name = "spi0-pos-B",
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "spi0",
 	.group = "spi0_1_grp",
-	.dev_name = "foo-spi.0",
 },
 ...
 
 This example mapping is used to switch between two positions for spi0 at
 runtime, as described further below under the heading "Runtime pinmuxing".
 
-Further it is possible to match several groups of pins to the same function
-for a single device, say for example in the mmc0 example above, where you can
+Further it is possible for one named state to affect the muxing of several
+groups of pins, say for example in the mmc0 example above, where you can
 additively expand the mmc0 bus from 2 to 4 to 8 pins. If we want to use all
 three groups for a total of 2+2+4 = 8 pins (for an 8-bit MMC bus as is the
 case), we define a mapping like this:
 
 ...
 {
+	.dev_name = "foo-mmc.0",
 	.name = "2bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
-	.dev_name = "foo-mmc.0",
 },
 {
+	.dev_name = "foo-mmc.0",
 	.name = "4bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
-	.dev_name = "foo-mmc.0",
 },
 {
+	.dev_name = "foo-mmc.0",
 	.name = "4bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_2_grp",
-	.dev_name = "foo-mmc.0",
 },
 {
+	.dev_name = "foo-mmc.0",
 	.name = "8bit"
 	.ctrl_dev_name = "pinctrl-foo",
+	.function = "mmc0",
 	.group = "mmc0_1_grp",
-	.dev_name = "foo-mmc.0",
 },
 {
+	.dev_name = "foo-mmc.0",
 	.name = "8bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_2_grp",
-	.dev_name = "foo-mmc.0",
 },
 {
+	.dev_name = "foo-mmc.0",
 	.name = "8bit"
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_3_grp",
-	.dev_name = "foo-mmc.0",
 },
 ...
 
 The result of grabbing this mapping from the device with something like
 this (see next paragraph):
 
-	p = pinctrl_get(&device, "8bit");
+	p = pinctrl_get(dev);
+	s = pinctrl_lookup_state(p, "8bit");
+	ret = pinctrl_select_state(p, s);
+
+or more simply:
+
+	p = pinctrl_get_select(dev, "8bit");
 
 Will be that you activate all the three bottom records in the mapping at
-once. Since they share the same name, pin controller device, funcion and
+once. Since they share the same name, pin controller device, function and
 device, and since we allow multiple groups to match to a single device, they
 all get selected, and they all get enabled and disable simultaneously by the
 pinmux core.
@@ -922,45 +932,63 @@ default state like this:
 
 struct foo_state {
        struct pinctrl *p;
+       struct pinctrl_state *s;
        ...
 };
 
 foo_probe()
 {
-	/* Allocate a state holder named "state" etc */
-	struct pinctrl p;
+	/* Allocate a state holder named "foo" etc */
+	struct foo_state *foo = ...;
 
-	p = pinctrl_get(&device, "default");
-	if IS_ERR(p)
-		return PTR_ERR(p);
-	pinctrl_enable(p);
+	foo->p = pinctrl_get(&device);
+	if (IS_ERR(foo->p)) {
+		/* FIXME: clean up "foo" here */
+		return PTR_ERR(foo->p);
+	}
+
+	foo->s = pinctrl_lookup_state(foo->p, "default");
+	if (IS_ERR(foo->s)) {
+		pinctrl_put(foo->p);
+		/* FIXME: clean up "foo" here */
+		return PTR_ERR(s);
+	}
 
-	state->p = p;
+	ret = pinctrl_select_state(s);
+	if (ret < 0) {
+		pinctrl_put(foo->p);
+		/* FIXME: clean up "foo" here */
+		return ret;
+	}
 }
 
 foo_remove()
 {
-	pinctrl_disable(state->p);
 	pinctrl_put(state->p);
 }
 
-This get/enable/disable/put sequence can just as well be handled by bus drivers
+This get/lookup/select/put sequence can just as well be handled by bus drivers
 if you don't want each and every driver to handle it and you know the
 arrangement on your bus.
 
-The semantics of the get/enable respective disable/put is as follows:
+The semantics of the pinctrl APIs are:
+
+- pinctrl_get() is called in process context to obtain a handle to all pinctrl
+  information for a given client device. It will allocate a struct from the
+  kernel memory to hold the pinmux state. All mapping table parsing or similar
+  slow operations take place within this API.
 
-- pinctrl_get() is called in process context to reserve the pins affected with
-  a certain mapping and set up the pinmux core and the driver. It will allocate
-  a struct from the kernel memory to hold the pinmux state.
+- pinctrl_lookup_state() is called in process context to obtain a handle to a
+  specific state for a the client device. This operation may be slow too.
 
-- pinctrl_enable()/pinctrl_disable() is quick and can be called from fastpath
-  (irq context) when you quickly want to set up/tear down the hardware muxing
-  when running a device driver. Usually it will just poke some values into a
-  register.
+- pinctrl_select_state() programs pin controller hardware according to the
+  definition of the state as given by the mapping table. In theory this is a
+  fast-path operation, since it only involved blasting some register settings
+  into hardware. However, note that some pin controllers may have their
+  registers on a slow/IRQ-based bus, so client devices should not assume they
+  can call pinctrl_select_state() from non-blocking contexts.
 
-- pinctrl_disable() is called in process context to tear down the pin requests
-  and release the state holder struct for the mux setting etc.
+- pinctrl_put() frees all information associated with a pinctrl handle.
 
 Usually the pin control core handled the get/put pair and call out to the
 device drivers bookkeeping operations, like checking available functions and
@@ -976,25 +1004,25 @@ System pin control hogging
 ==========================
 
 Pin control map entries can be hogged by the core when the pin controller
-is registered. This means that the core will attempt to call pinctrl_get() and
-pinctrl_enable() on it immediately after the pin control device has been
-registered.
+is registered. This means that the core will attempt to call pinctrl_get(),
+lookup_state() and select_state() on it immediately after the pin control
+device has been registered.
 
-This is enabled by simply setting the .dev_name field in the map to the name
-of the pin controller itself, like this:
+This occurs for mapping table entries where the client device name is equal
+to the pin controller device name, and the state name is "active".
 
 {
-	.name = "POWERMAP"
+	.dev_name = "pinctrl-foo",
+	.name = "active",
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "power_func",
-	.dev_name = "pinctrl-foo",
 },
 
 Since it may be common to request the core to hog a few always-applicable
 mux settings on the primary pin controller, there is a convenience macro for
 this:
 
-PIN_MAP_SYS_HOG("POWERMAP", "pinctrl-foo", "power_func")
+PIN_MAP_SYS_HOG("active", "pinctrl-foo", "power_func")
 
 This gives the exact same result as the above construction.
 
@@ -1006,8 +1034,8 @@ It is possible to mux a certain function in and out at runtime, say to move
 an SPI port from one set of pins to another set of pins. Say for example for
 spi0 in the example above, we expose two different groups of pins for the same
 function, but with different named in the mapping as described under
-"Advanced mapping" above. So we have two mappings named "spi0-pos-A" and
-"spi0-pos-B".
+"Advanced mapping" above. So that for an SPI device, we have two states named
+"pos-A" and "pos-B".
 
 This snippet first muxes the function in the pins defined by group A, enables
 it, disables and releases it, and muxes it in on the pins defined by group B:
@@ -1017,23 +1045,36 @@ it, disables and releases it, and muxes it in on the pins defined by group B:
 foo_switch()
 {
 	struct pinctrl *p;
+	struct pinctrl_state *s1, *s2;
+
+	/* Setup */
+	p = pinctrl_get(&device);
+	if (IS_ERR(p))
+		...
+
+	s1 = pinctrl_lookup_state(foo->p, "pos-A");
+	if (IS_ERR(s1))
+		...
+
+	s2 = pinctrl_lookup_state(foo->p, "pos-B");
+	if (IS_ERR(s2))
+		...
 
 	/* Enable on position A */
-	p = pinctrl_get(&device, "spi0-pos-A");
-	if IS_ERR(p)
-		return PTR_ERR(p);
-	pinctrl_enable(p);
+	ret = pinctrl_select_state(s);
+	if (ret < 0)
+	    ...
 
-	/* This releases the pins again */
-	pinctrl_disable(p);
-	pinctrl_put(p);
+	...
 
 	/* Enable on position B */
-	p = pinctrl_get(&device, "spi0-pos-B");
-	if IS_ERR(p)
-		return PTR_ERR(p);
-	pinctrl_enable(p);
+	ret = pinctrl_select_state(s);
+	if (ret < 0)
+	    ...
+
 	...
+
+	pinctrl_put(p);
 }
 
 The above has to be done from process context.
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index d66bc97..eb79a49 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1554,32 +1554,28 @@ static struct platform_device pinmux_device = {
 /* Pinmux settings */
 static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
-	PIN_MAP_SYS_HOG("POWER", "pinmux-u300", "power"),
-	PIN_MAP_SYS_HOG("EMIF0", "pinmux-u300", "emif0"),
-	PIN_MAP_SYS_HOG("EMIF1", "pinmux-u300", "emif1"),
+	PIN_MAP_SYS_HOG("default", "pinmux-u300", "power"),
+	PIN_MAP_SYS_HOG("default", "pinmux-u300", "emif0"),
+	PIN_MAP_SYS_HOG("default", "pinmux-u300", "emif1"),
 	/* per-device maps for MMC/SD, SPI and UART */
-	PIN_MAP("MMCSD", "pinmux-u300", "mmc0", "mmci"),
-	PIN_MAP("SPI", "pinmux-u300", "spi0", "pl022"),
-	PIN_MAP("UART0", "pinmux-u300", "uart0", "uart0"),
+	PIN_MAP("default", "pinmux-u300", "mmc0", "mmci"),
+	PIN_MAP("default", "pinmux-u300", "spi0", "pl022"),
+	PIN_MAP("default", "pinmux-u300", "uart0", "uart0"),
 };
 
 struct u300_mux_hog {
-	const char *name;
 	struct device *dev;
 	struct pinctrl *p;
 };
 
 static struct u300_mux_hog u300_mux_hogs[] = {
 	{
-		.name = "uart0",
 		.dev = &uart0_device.dev,
 	},
 	{
-		.name = "spi0",
 		.dev = &pl022_device.dev,
 	},
 	{
-		.name = "mmc0",
 		.dev = &mmcsd_device.dev,
 	},
 };
@@ -1592,16 +1588,10 @@ static int __init u300_pinctrl_fetch(void)
 		struct pinctrl *p;
 		int ret;
 
-		p = pinctrl_get(u300_mux_hogs[i].dev, NULL);
+		p = pinctrl_get_select_default(u300_mux_hogs[i].dev);
 		if (IS_ERR(p)) {
-			pr_err("u300: could not get pinmux hog %s\n",
-			       u300_mux_hogs[i].name);
-			continue;
-		}
-		ret = pinctrl_enable(p);
-		if (ret) {
-			pr_err("u300: could enable pinmux hog %s\n",
-			       u300_mux_hogs[i].name);
+			pr_err("u300: could not get pinmux hog for dev %s\n",
+			       dev_name(u300_mux_hogs[i].dev));
 			continue;
 		}
 		u300_mux_hogs[i].p = p;
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 2066aee..bab1a69 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -41,18 +41,6 @@ struct pinctrl_maps {
 	unsigned num_maps;
 };
 
-/**
- * struct pinctrl_hog - a list item to stash control hogs
- * @node: pin control hog list node
- * @map: map entry responsible for this hogging
- * @pmx: the pin control hogged by this item
- */
-struct pinctrl_hog {
-	struct list_head node;
-	struct pinctrl_map const *map;
-	struct pinctrl *p;
-};
-
 /* Mutex taken by all entry points */
 DEFINE_MUTEX(pinctrl_mutex);
 
@@ -470,25 +458,98 @@ int pinctrl_gpio_direction_output(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
 
-static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
+static struct pinctrl_state *find_state(struct pinctrl *p,
+					const char *name)
 {
-	struct pinctrl_dev *pctldev;
-	const char *devname;
-	struct pinctrl *p;
-	unsigned num_maps = 0;
-	int ret;
-	struct pinctrl_maps *maps_node;
-	int i;
-	struct pinctrl_map const *map;
+	struct pinctrl_state *state;
+
+	list_for_each_entry(state, &p->states, node)
+		if (!strcmp(state->name, name))
+			return state;
+
+	return NULL;
+}
+
+static struct pinctrl_state *create_state(struct pinctrl *p,
+					  const char *name)
+{
+	struct pinctrl_state *state;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state == NULL) {
+		dev_err(p->dev,
+			"failed to alloc struct pinctrl_state\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	state->name = name;
+	INIT_LIST_HEAD(&state->settings);
+
+	list_add_tail(&state->node, &p->states);
+
+	return state;
+}
+
+static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
+{
+	struct pinctrl_state *state;
 	struct pinctrl_setting *setting;
+	int ret;
 
-	/* We must have both dev and state name */
-	if (WARN_ON(!dev || !name))
-		return ERR_PTR(-EINVAL);
+	state = find_state(p, map->name);
+	if (!state)
+		state = create_state(p, map->name);
+	if (IS_ERR(state))
+		return PTR_ERR(state);
 
-	devname = dev_name(dev);
+	setting = kzalloc(sizeof(*setting), GFP_KERNEL);
+	if (setting == NULL) {
+		dev_err(p->dev,
+			"failed to alloc struct pinctrl_setting\n");
+		return -ENOMEM;
+	}
+
+	setting->pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
+	if (setting->pctldev == NULL) {
+		dev_err(p->dev, "unknown pinctrl device %s in map entry",
+			map->ctrl_dev_name);
+		kfree(setting);
+		/* Eventually, this should trigger deferred probe */
+		return -ENODEV;
+	}
+
+	ret = pinmux_map_to_setting(map, setting);
+	if (ret < 0) {
+		kfree(setting);
+		return ret;
+	}
+
+	list_add_tail(&setting->node, &state->settings);
+
+	return 0;
+}
+
+static struct pinctrl *find_pinctrl(struct device *dev)
+{
+	struct pinctrl *p;
 
-	dev_dbg(dev, "pinctrl_get() for state %s\n", name);
+	list_for_each_entry(p, &pinctrldev_list, node)
+		if (p->dev == dev)
+			return p;
+
+	return NULL;
+}
+
+static void pinctrl_put_locked(struct pinctrl *p, bool inlist);
+
+static struct pinctrl *create_pinctrl(struct device *dev)
+{
+	struct pinctrl *p;
+	const char *devname;
+	struct pinctrl_maps *maps_node;
+	int i;
+	struct pinctrl_map const *map;
+	int ret;
 
 	/*
 	 * create the state cookie holder struct pinctrl for each
@@ -501,8 +562,9 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		return ERR_PTR(-ENOMEM);
 	}
 	p->dev = dev;
-	p->state = name;
-	INIT_LIST_HEAD(&p->settings);
+	INIT_LIST_HEAD(&p->states);
+
+	devname = dev_name(dev);
 
 	/* Iterate over the pin control maps to locate the right ones */
 	for_each_maps(maps_node, i, map) {
@@ -510,181 +572,183 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
 		if (strcmp(map->dev_name, devname))
 			continue;
 
-		/* State name must be the one we're looking for */
-		if (strcmp(map->name, name))
-			continue;
-
-		/*
-		 * First, try to find the pctldev given in the map
-		 */
-		pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
-		if (!pctldev) {
-			dev_err(dev, "unknown pinctrl device %s in map entry",
-				map->ctrl_dev_name);
-			/* Eventually, this should trigger deferred probe */
-			ret = -ENODEV;
-			goto error;
-		}
-
-		dev_dbg(dev, "in map, found pctldev %s to handle function %s",
-			dev_name(pctldev->dev), map->function);
-
-		setting = kzalloc(sizeof(*setting), GFP_KERNEL);
-		if (setting == NULL) {
-			dev_err(dev,
-				"failed to alloc struct pinctrl_setting\n");
-			ret = -ENOMEM;
-			goto error;
+		ret = add_setting(p, map);
+		if (ret < 0) {
+			pinctrl_put_locked(p, false);
+			return ERR_PTR(ret);
 		}
-
-		setting->pctldev = pctldev;
-		ret = pinmux_map_to_setting(map, setting);
-		if (ret < 0)
-			goto error;
-
-		list_add_tail(&setting->node, &p->settings);
-		num_maps++;
 	}
 
-	/*
-	 * This may be perfectly legitimate. An IP block may get re-used
-	 * across SoCs. Not all of those SoCs may need pinmux settings for the
-	 * IP block, e.g. if one SoC dedicates pins to that function but
-	 * another doesn't. The driver won't know this, and will always
-	 * attempt to set up the pinmux. The mapping table defines whether any
-	 * HW programming is actually needed.
-	 */
-	if (!num_maps)
-		dev_info(dev, "zero maps found for state %s\n", name);
-
-	dev_dbg(dev, "found %u maps for state %s\n", num_maps, name);
-
 	/* Add the pinmux to the global list */
 	list_add_tail(&p->node, &pinctrl_list);
 
 	return p;
+}
+
+static struct pinctrl *pinctrl_get_locked(struct device *dev)
+{
+	struct pinctrl *p;
 
-error:
-	list_for_each_entry(setting, &p->settings, node)
-		pinmux_free_setting(setting);
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
 
-	kfree(p);
+	p = find_pinctrl(dev);
+	if (p == NULL)
+		p = create_pinctrl(dev);
+	if (IS_ERR(p))
+		return p;
+
+	p->usecount++;
 
-	return ERR_PTR(ret);
+	return p;
 }
 
 /**
- * pinctrl_get() - retrieves the pin controller handle for a certain device
- * @dev: the device to get the pin controller handle for
- * @name: an optional specific control mapping name or NULL, the name is only
- *	needed if you want to have more than one mapping per device, or if you
- *	need an anonymous pin control (not tied to any specific device)
+ * pinctrl_get() - retrieves the pinctrl handle for a device
+ * @dev: the device to obtain the handle for
  */
-struct pinctrl *pinctrl_get(struct device *dev, const char *name)
+struct pinctrl *pinctrl_get(struct device *dev)
 {
 	struct pinctrl *p;
 
 	mutex_lock(&pinctrl_mutex);
-	p = pinctrl_get_locked(dev, name);
+	p = pinctrl_get_locked(dev);
 	mutex_unlock(&pinctrl_mutex);
 
 	return p;
 }
 EXPORT_SYMBOL_GPL(pinctrl_get);
 
-static void pinctrl_put_locked(struct pinctrl *p)
+static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
 {
-	struct pinctrl_setting *setting, *n;
+	struct pinctrl_state *state, *n1;
+	struct pinctrl_setting *setting, *n2;
 
-	if (p == NULL)
+	p->usecount--;
+	if (p->usecount)
 		return;
 
-	if (p->usecount)
-		pr_warn("releasing pin control handle with active users!\n");
-	list_for_each_entry_safe(setting, n, &p->settings, node) {
-		pinmux_free_setting(setting);
-		list_del(&setting->node);
-		kfree(setting);
+	list_for_each_entry_safe(state, n1, &p->states, node) {
+		list_for_each_entry_safe(setting, n2, &state->settings, node) {
+			if (state == p->state)
+				pinmux_disable_setting(setting);
+			pinmux_free_setting(setting);
+			list_del(&setting->node);
+			kfree(setting);
+		}
+		list_del(&state->node);
+		kfree(state);
 	}
 
-	/* Remove from list */
-	list_del(&p->node);
-
+	if (inlist)
+		list_del(&p->node);
 	kfree(p);
 }
 
 /**
- * pinctrl_put() - release a previously claimed pin control handle
- * @p: a pin control handle previously claimed by pinctrl_get()
+ * pinctrl_put() - release a previously claimed pinctrl handle
+ * @p: the pinctrl handle to release
  */
 void pinctrl_put(struct pinctrl *p)
 {
 	mutex_lock(&pinctrl_mutex);
-	pinctrl_put(p);
+	pinctrl_put_locked(p, true);
 	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_put);
 
-static int pinctrl_enable_locked(struct pinctrl *p)
+static struct pinctrl_state *pinctrl_lookup_state_locked(struct pinctrl *p,
+							 const char *name)
 {
-	struct pinctrl_setting *setting;
-	int ret;
+	struct pinctrl_state *state;
 
-	if (p == NULL)
-		return -EINVAL;
+	state = find_state(p, name);
+	if (!state)
+		return ERR_PTR(-ENODEV);
 
-	if (p->usecount++ == 0) {
-		list_for_each_entry(setting, &p->settings, node) {
-			ret = pinmux_enable_setting(setting);
-			if (ret < 0) {
-				/* FIXME: Difficult to return to prev state */
-				p->usecount--;
-				return ret;
-			}
-		}
-	}
-
-	return 0;
+	return state;
 }
 
 /**
- * pinctrl_enable() - enable a certain pin controller setting
- * @p: the pin control handle to enable, previously claimed by pinctrl_get()
+ * pinctrl_lookup_state() - retrieves a state handle from a pinctrl handle
+ * @p: the pinctrl handle to retrieve the state from
+ * @name: the state name to retrieve
  */
-int pinctrl_enable(struct pinctrl *p)
+struct pinctrl_state *pinctrl_lookup_state(struct pinctrl *p, const char *name)
 {
-	int ret;
+	struct pinctrl_state *s;
+
 	mutex_lock(&pinctrl_mutex);
-	ret = pinctrl_enable_locked(p);
+	s = pinctrl_lookup_state_locked(p, name);
 	mutex_unlock(&pinctrl_mutex);
-	return ret;
+
+	return s;
 }
-EXPORT_SYMBOL_GPL(pinctrl_enable);
+EXPORT_SYMBOL_GPL(pinctrl_lookup_state);
 
-static void pinctrl_disable_locked(struct pinctrl *p)
+static int pinctrl_select_state_locked(struct pinctrl *p,
+				       struct pinctrl_state *state)
 {
-	struct pinctrl_setting *setting;
+	struct pinctrl_setting *setting, *setting2;
+	int ret;
 
-	if (p == NULL)
-		return;
+	if (p->state == state)
+		return 0;
+
+	if (p->state) {
+		/*
+		 * The set of groups with a mux configuration in the old state
+		 * may not be identical to the set of groups with a mux setting
+		 * in the new state. While this might be unusual, it's entirely
+		 * possible for the "user"-supplied mapping table to be written
+		 * that way. For each group that was configured in the old state
+		 * but not in the new state, this code puts that group into a
+		 * safe/disabled state.
+		 */
+		list_for_each_entry(setting, &p->state->settings, node) {
+			bool found = false;
+			list_for_each_entry(setting2, &state->settings, node) {
+				if (setting2->group_selector ==
+						setting->group_selector) {
+					found = true;
+					break;
+				}
+			}
+			if (!found)
+				pinmux_disable_setting(setting);
+		}
+	}
+
+	p->state = state;
 
-	if (--p->usecount == 0) {
-		list_for_each_entry(setting, &p->settings, node)
-			pinmux_disable_setting(setting);
+	/* Apply all the settings for the new state */
+	list_for_each_entry(setting, &state->settings, node) {
+		ret = pinmux_enable_setting(setting);
+		if (ret < 0) {
+			/* FIXME: Difficult to return to prev state */
+			return ret;
+		}
 	}
+
+	return 0;
 }
 
 /**
- * pinctrl_disable() - disable a certain pin control setting
- * @p: the pin control handle to disable, previously claimed by pinctrl_get()
+ * pinctrl_select() - select/activate/program a pinctrl state to HW
+ * @p: the pinctrl handle for the device that requests configuratio
+ * @state: the state handle to select/activate/program
  */
-void pinctrl_disable(struct pinctrl *p)
+int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 {
+	int ret;
+
 	mutex_lock(&pinctrl_mutex);
-	pinctrl_disable_locked(p);
+	ret = pinctrl_select_state_locked(p, state);
 	mutex_unlock(&pinctrl_mutex);
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(pinctrl_disable);
+EXPORT_SYMBOL_GPL(pinctrl_select_state);
 
 /**
  * pinctrl_register_mappings() - register a set of pin controller mappings
@@ -749,99 +813,6 @@ int pinctrl_register_mappings(struct pinctrl_map const *maps,
 	return 0;
 }
 
-/* Hog a single map entry and add to the hoglist */
-static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
-			   struct pinctrl_map const *map)
-{
-	struct pinctrl_hog *hog;
-	struct pinctrl *p;
-	int ret;
-
-	hog = kzalloc(sizeof(*hog), GFP_KERNEL);
-	if (!hog) {
-		dev_err(pctldev->dev, "failed to alloc struct pinctrl_hog\n");
-		return -ENOMEM;
-	}
-
-	p = pinctrl_get_locked(pctldev->dev, map->name);
-	if (IS_ERR(p)) {
-		kfree(hog);
-		dev_err(pctldev->dev,
-			"could not get the %s pin control mapping for hogging\n",
-			map->name);
-		return PTR_ERR(p);
-	}
-
-	ret = pinctrl_enable_locked(p);
-	if (ret) {
-		pinctrl_put_locked(p);
-		kfree(hog);
-		dev_err(pctldev->dev,
-			"could not enable the %s pin control mapping for hogging\n",
-			map->name);
-		return ret;
-	}
-
-	hog->map = map;
-	hog->p = p;
-
-	dev_info(pctldev->dev, "hogged map %s, function %s\n", map->name,
-		 map->function);
-	list_add_tail(&hog->node, &pctldev->pinctrl_hogs);
-
-	return 0;
-}
-
-/**
- * pinctrl_hog_maps() - hog specific map entries on controller device
- * @pctldev: the pin control device to hog entries on
- *
- * When the pin controllers are registered, there may be some specific pinmux
- * map entries that need to be hogged, i.e. get+enabled until the system shuts
- * down.
- */
-static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
-{
-	struct device *dev = pctldev->dev;
-	const char *devname = dev_name(dev);
-	int ret;
-	struct pinctrl_maps *maps_node;
-	int i;
-	struct pinctrl_map const *map;
-
-	INIT_LIST_HEAD(&pctldev->pinctrl_hogs);
-
-	for_each_maps(maps_node, i, map) {
-		if (!strcmp(map->ctrl_dev_name, devname) &&
-		    !strcmp(map->dev_name, devname)) {
-			/* OK time to hog! */
-			ret = pinctrl_hog_map(pctldev, map);
-			if (ret)
-				return ret;
-		}
-	}
-
-	return 0;
-}
-
-/**
- * pinctrl_unhog_maps() - unhog specific map entries on controller device
- * @pctldev: the pin control device to unhog entries on
- */
-static void pinctrl_unhog_maps(struct pinctrl_dev *pctldev)
-{
-	struct list_head *node, *tmp;
-
-	list_for_each_safe(node, tmp, &pctldev->pinctrl_hogs) {
-		struct pinctrl_hog *hog =
-			list_entry(node, struct pinctrl_hog, node);
-		pinctrl_disable_locked(hog->p);
-		pinctrl_put_locked(hog->p);
-		list_del(node);
-		kfree(hog);
-	}
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 static int pinctrl_pins_show(struct seq_file *s, void *what)
@@ -965,23 +936,6 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 	return 0;
 }
 
-static int pinmux_hogs_show(struct seq_file *s, void *what)
-{
-	struct pinctrl_dev *pctldev = s->private;
-	struct pinctrl_hog *hog;
-
-	seq_puts(s, "Pin control map hogs held by device\n");
-
-	mutex_lock(&pinctrl_mutex);
-
-	list_for_each_entry(hog, &pctldev->pinctrl_hogs, node)
-		seq_printf(s, "%s\n", hog->map->name);
-
-	mutex_unlock(&pinctrl_mutex);
-
-	return 0;
-}
-
 static int pinctrl_devices_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_dev *pctldev;
@@ -1011,6 +965,7 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 static int pinctrl_show(struct seq_file *s, void *what)
 {
 	struct pinctrl *p;
+	struct pinctrl_state *state;
 	struct pinctrl_setting *setting;
 
 	seq_puts(s, "Requested pin control handlers their pinmux maps:\n");
@@ -1018,12 +973,17 @@ static int pinctrl_show(struct seq_file *s, void *what)
 	mutex_lock(&pinctrl_mutex);
 
 	list_for_each_entry(p, &pinctrl_list, node) {
-		seq_printf(s, "device: %s state: %s users: %u\n",
-			   dev_name(p->dev), p->state, p->usecount);
+		seq_printf(s, "device: %s current state: %s users: %u\n",
+			   dev_name(p->dev),
+			   p->state ? p->state->name : "none", p->usecount);
+
+		list_for_each_entry(state, &p->states, node) {
+			seq_printf(s, "  state: %s\n", state->name);
 
-		list_for_each_entry(setting, &p->settings, node) {
-			seq_printf(s, "  ");
-			pinmux_dbg_show(s, setting);
+			list_for_each_entry(setting, &state->settings, node) {
+				seq_printf(s, "    ");
+				pinmux_dbg_show(s, setting);
+			}
 		}
 	}
 
@@ -1052,11 +1012,6 @@ static int pinctrl_maps_open(struct inode *inode, struct file *file)
 	return single_open(file, pinctrl_maps_show, inode->i_private);
 }
 
-static int pinmux_hogs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinmux_hogs_show, inode->i_private);
-}
-
 static int pinctrl_devices_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, pinctrl_devices_show, NULL);
@@ -1095,13 +1050,6 @@ static const struct file_operations pinctrl_maps_ops = {
 	.release	= single_release,
 };
 
-static const struct file_operations pinmux_hogs_ops = {
-	.open		= pinmux_hogs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static const struct file_operations pinctrl_devices_ops = {
 	.open		= pinctrl_devices_open,
 	.read		= seq_read,
@@ -1139,8 +1087,6 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 			    device_root, pctldev, &pinctrl_gpioranges_ops);
 	debugfs_create_file("pinctrl-maps", S_IFREG | S_IRUGO,
 			    device_root, pctldev, &pinctrl_maps_ops);
-	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
-			    device_root, pctldev, &pinmux_hogs_ops);
 	pinmux_init_device_debugfs(device_root, pctldev);
 	pinconf_init_device_debugfs(device_root, pctldev);
 }
@@ -1248,7 +1194,14 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	mutex_lock(&pinctrl_mutex);
 
 	list_add_tail(&pctldev->node, &pinctrldev_list);
-	pinctrl_hog_maps(pctldev);
+
+	pctldev->p = pinctrl_get_locked(pctldev->dev);
+	if (!IS_ERR(pctldev->p)) {
+		struct pinctrl_state *s =
+			pinctrl_lookup_state_locked(pctldev->p, "active");
+		if (!IS_ERR(s))
+			pinctrl_select_state_locked(pctldev->p, s);
+	}
 
 	mutex_unlock(&pinctrl_mutex);
 
@@ -1275,7 +1228,9 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 
 	mutex_lock(&pinctrl_mutex);
 
-	pinctrl_unhog_maps(pctldev);
+	if (!IS_ERR(pctldev->p))
+		pinctrl_put_locked(pctldev->p, true);
+
 	/* TODO: check that no pinmuxes are still active? */
 	list_del(&pctldev->node);
 	/* Destroy descriptor tree */
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 64ae1b8..d5bc9ea 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -28,7 +28,7 @@ struct pinctrl_gpio_range;
  * @owner: module providing the pin controller, used for refcounting
  * @driver_data: driver data for drivers registering to the pin controller
  *	subsystem
- * @pinctrl_hogs: list of pin control maps hogged by this device
+ * @p: result of pinctrl_get() for this device
  * @device_root: debugfs root for this device
  */
 struct pinctrl_dev {
@@ -39,7 +39,7 @@ struct pinctrl_dev {
 	struct device *dev;
 	struct module *owner;
 	void *driver_data;
-	struct list_head pinctrl_hogs;
+	struct pinctrl *p;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
 #endif
@@ -49,22 +49,34 @@ struct pinctrl_dev {
  * struct pinctrl - per-device pin control state holder
  * @node: global list node
  * @dev: the device using this pin control handle
- * @state: the state name passed to pinctrl_get()
  * @usecount: the number of active users of this pin controller setting, used
  *	to keep track of nested use cases
- * @settings: a list of settings for this device/state
+ * @states: a list of states for this device
+ * @state: the current state
  */
 struct pinctrl {
 	struct list_head node;
 	struct device *dev;
-	const char *state;
 	unsigned usecount;
+	struct list_head states;
+	struct pinctrl_state *state;
+};
+
+/**
+ * struct pinctrl_state - a pinctrl state for a device
+ * @node: list not for struct pinctrl's @states field
+ * @name: the name of this state
+ * @settings: a list of settings for this state
+ */
+struct pinctrl_state {
+	struct list_head node;
+	const char *name;
 	struct list_head settings;
 };
 
 /**
  * struct pinctrl_setting - an individual mux setting
- * @node: list node for struct pinctrl's @settings field
+ * @node: list node for struct pinctrl_settings's @settings field
  * @pctldev: pin control device handling to be programmed
  * @group_selector: the group selector to program
  * @func_selector: the function selector to program
diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index c1a871e..5b3eda2 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -673,12 +673,10 @@ int sirfsoc_uart_probe(struct platform_device *pdev)
 	port->irq = res->start;
 
 	if (sirfport->hw_flow_ctrl) {
-		sirfport->p = pinctrl_get(&pdev->dev, NULL);
+		sirfport->p = pinctrl_get_select_default(&pdev->dev);
 		ret = IS_ERR(sirfport->p);
 		if (ret)
 			goto pin_err;
-
-		pinctrl_enable(sirfport->p);
 	}
 
 	port->ops = &sirfsoc_uart_ops;
@@ -695,10 +693,8 @@ int sirfsoc_uart_probe(struct platform_device *pdev)
 
 port_err:
 	platform_set_drvdata(pdev, NULL);
-	if (sirfport->hw_flow_ctrl) {
-		pinctrl_disable(sirfport->p);
+	if (sirfport->hw_flow_ctrl)
 		pinctrl_put(sirfport->p);
-	}
 pin_err:
 irq_err:
 	devm_iounmap(&pdev->dev, port->membase);
@@ -711,10 +707,8 @@ static int sirfsoc_uart_remove(struct platform_device *pdev)
 	struct sirfsoc_uart_port *sirfport = platform_get_drvdata(pdev);
 	struct uart_port *port = &sirfport->port;
 	platform_set_drvdata(pdev, NULL);
-	if (sirfport->hw_flow_ctrl) {
-		pinctrl_disable(sirfport->p);
+	if (sirfport->hw_flow_ctrl)
 		pinctrl_put(sirfport->p);
-	}
 	devm_iounmap(&pdev->dev, port->membase);
 	uart_remove_one_port(&sirfsoc_uart_drv, port);
 	return 0;
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 3086594..a520c46 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -12,12 +12,14 @@
 #ifndef __LINUX_PINCTRL_CONSUMER_H
 #define __LINUX_PINCTRL_CONSUMER_H
 
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/seq_file.h>
 #include "pinctrl.h"
 
 /* This struct is private to the core and should be regarded as a cookie */
 struct pinctrl;
+struct pinctrl_state;
 
 #ifdef CONFIG_PINCTRL
 
@@ -26,10 +28,13 @@ extern int pinctrl_request_gpio(unsigned gpio);
 extern void pinctrl_free_gpio(unsigned gpio);
 extern int pinctrl_gpio_direction_input(unsigned gpio);
 extern int pinctrl_gpio_direction_output(unsigned gpio);
-extern struct pinctrl * __must_check pinctrl_get(struct device *dev, const char *name);
+
+extern struct pinctrl * __must_check pinctrl_get(struct device *dev);
 extern void pinctrl_put(struct pinctrl *p);
-extern int pinctrl_enable(struct pinctrl *p);
-extern void pinctrl_disable(struct pinctrl *p);
+extern struct pinctrl_state * __must_check pinctrl_lookup_state(
+							struct pinctrl *p,
+							const char *name);
+extern int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *s);
 
 #else /* !CONFIG_PINCTRL */
 
@@ -52,7 +57,7 @@ static inline int pinctrl_gpio_direction_output(unsigned gpio)
 	return 0;
 }
 
-static inline struct pinctrl * __must_check pinctrl_get(struct device *dev, const char *name)
+static inline struct pinctrl * __must_check pinctrl_get(struct device *dev)
 {
 	return NULL;
 }
@@ -61,17 +66,53 @@ static inline void pinctrl_put(struct pinctrl *p)
 {
 }
 
-static inline int pinctrl_enable(struct pinctrl *p)
+static inline struct pinctrl_state * __must_check pinctrl_lookup_state(
+							struct pinctrl *p,
+							const char *name)
 {
-	return 0;
+	return NULL;
 }
 
-static inline void pinctrl_disable(struct pinctrl *p)
+static inline int pinctrl_select_state(struct pinctrl *p,
+				       struct pinctrl_state *s)
 {
+	return 0;
 }
 
 #endif /* CONFIG_PINCTRL */
 
+static inline struct pinctrl * __must_check pinctrl_get_select(
+					struct device *dev, const char *name)
+{
+	struct pinctrl *p;
+	struct pinctrl_state *s;
+	int ret;
+
+	p = pinctrl_get(dev);
+	if (IS_ERR(p))
+		return p;
+
+	s = pinctrl_lookup_state(p, name);
+	if (IS_ERR(s)) {
+		pinctrl_put(p);
+		return ERR_PTR(PTR_ERR(s));
+	}
+
+	ret = pinctrl_select_state(p, s);
+	if (ret < 0) {
+		pinctrl_put(p);
+		return ERR_PTR(ret);
+	}
+
+	return p;
+}
+
+static inline struct pinctrl * __must_check pinctrl_get_select_default(
+					struct device *dev)
+{
+	return pinctrl_get_select(dev, "default");
+}
+
 #ifdef CONFIG_PINCONF
 
 extern int pin_config_get(const char *dev_name, const char *name,
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index 400f192..e7246dc 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -14,28 +14,27 @@
 
 /**
  * struct pinctrl_map - boards/machines shall provide this map for devices
+ * @dev_name: the name of the device using this specific mapping, the name
+ *	must be the same as in your struct device*. If this name is set to the
+ *	same name as the pin controllers own dev_name(), the map entry will be
+ *	hogged by the driver itself upon registration
  * @name: the name of this specific map entry for the particular machine.
- *	This is the second parameter passed to pinmux_get() when you want
- *	to have several mappings to the same device
+ *	This is the parameter passed to pinmux_lookup_state()
  * @ctrl_dev_name: the name of the device controlling this specific mapping,
  *	the name must be the same as in your struct device*
- * @function: a function in the driver to use for this mapping, the driver
- *	will lookup the function referenced by this ID on the specified
- *	pin control device
  * @group: sometimes a function can map to different pin groups, so this
  *	selects a certain specific pin group to activate for the function, if
  *	left as NULL, the first applicable group will be used
- * @dev_name: the name of the device using this specific mapping, the name
- *	must be the same as in your struct device*. If this name is set to the
- *	same name as the pin controllers own dev_name(), the map entry will be
- *	hogged by the driver itself upon registration
+ * @function: a function in the driver to use for this mapping, the driver
+ *	will lookup the function referenced by this ID on the specified
+ *	pin control device
  */
 struct pinctrl_map {
+	const char *dev_name;
 	const char *name;
 	const char *ctrl_dev_name;
-	const char *function;
 	const char *group;
-	const char *dev_name;
+	const char *function;
 };
 
 /*
-- 
1.7.5.4

