Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030446Ab2B1U2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:28:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17481 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030312Ab2B1U23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:28:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 28 Feb 2012 12:27:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 5/6] pinctrl: Enhance mapping table to support pin config operations
Date: Tue, 28 Feb 2012 13:27:31 -0700
Message-ID: <1330460852-23486-6-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pinctrl mapping table can now contain entries to:
* Set the mux function of a pin group
* Apply a set of pin config options to a pin or a group

This allows pinctrl_select_state() to apply pin configs settings as well
as mux settings.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Added numerous extra PIN_MAP_*() special-case macros. Fixed kerneldoc
typo. Delete pinctrl_get_pin_id() and replace it with pin_get_from_name().
Various minor fixes. Updates due to rebase.

 Documentation/pinctrl.txt       |   76 +++++++++++++++---
 arch/arm/mach-u300/core.c       |   12 ++--
 drivers/pinctrl/core.c          |  152 ++++++++++++++++++++++++++++++------
 drivers/pinctrl/core.h          |   35 +++++++-
 drivers/pinctrl/pinconf.c       |  165 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinconf.h       |   40 ++++++++++
 drivers/pinctrl/pinmux.c        |   69 ++++++++++------
 drivers/pinctrl/pinmux.h        |   23 +++++-
 include/linux/pinctrl/machine.h |  145 +++++++++++++++++++++++++++-------
 9 files changed, 610 insertions(+), 107 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 23426c7..bba7c97 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -206,14 +206,21 @@ using a certain resistor value - pull up and pull down - so that the pin has a
 stable value when nothing is driving the rail it is connected to, or when it's
 unconnected.
 
-For example, a platform may do this:
+Pin configuration can be programmed either using the explicit APIs described
+immediately below, or by adding configuration entries into the mapping table;
+see section "Board/machine configuration" below.
+
+For example, a platform may do the following to pull up a pin to VDD:
 
 #include <linux/pinctrl/consumer.h>
 
 ret = pin_config_set("foo-dev", "FOO_GPIO_PIN", PLATFORM_X_PULL_UP);
 
-To pull up a pin to VDD. The pin configuration driver implements callbacks for
-changing pin configuration in the pin controller ops like this:
+The format and meaning of the configuration parameter, PLATFORM_X_PULL_UP
+above, is entirely defined by the pin controller driver.
+
+The pin configuration driver implements callbacks for changing pin
+configuration in the pin controller ops like this:
 
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinconf.h>
@@ -765,7 +772,7 @@ obtain the function "gpioN" where "N" is the global GPIO pin number if no
 special GPIO-handler is registered.
 
 
-Pinmux board/machine configuration
+Board/machine configuration
 ==================================
 
 Boards and machines define how a certain complete running system is put
@@ -773,9 +780,9 @@ together, including how GPIOs and devices are muxed, how regulators are
 constrained and how the clock tree looks. Of course pinmux settings are also
 part of this.
 
-A pinmux config for a machine looks pretty much like a simple regulator
-configuration, so for the example array above we want to enable i2c and
-spi on the second function mapping:
+A pin controller configuration for a machine looks pretty much like a simple
+regulator configuration, so for the example array above we want to enable i2c
+and spi on the second function mapping:
 
 #include <linux/pinctrl/machine.h>
 
@@ -783,20 +790,23 @@ static const struct pinctrl_map __initdata mapping[] = {
 	{
 		.dev_name = "foo-spi.0",
 		.name = PINCTRL_STATE_DEFAULT,
+		.type = PIN_MAP_TYPE_MUX_GROUP,
 		.ctrl_dev_name = "pinctrl-foo",
-		.function = "spi0",
+		.data.mux.function = "spi0",
 	},
 	{
 		.dev_name = "foo-i2c.0",
 		.name = PINCTRL_STATE_DEFAULT,
+		.type = PIN_MAP_TYPE_MUX_GROUP,
 		.ctrl_dev_name = "pinctrl-foo",
-		.function = "i2c0",
+		.data.mux.function = "i2c0",
 	},
 	{
 		.dev_name = "foo-mmc.0",
 		.name = PINCTRL_STATE_DEFAULT,
+		.type = PIN_MAP_TYPE_MUX_GROUP,
 		.ctrl_dev_name = "pinctrl-foo",
-		.function = "mmc0",
+		.data.mux.function = "mmc0",
 	},
 };
 
@@ -817,7 +827,40 @@ it even more compact which assumes you want to use pinctrl-foo and position
 0 for mapping, for example:
 
 static struct pinctrl_map __initdata mapping[] = {
-	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
+	PIN_MAP_MUX_GROUP("foo-i2c.o", PINCTRL_STATE_DEFAULT, "pinctrl-foo", NULL, "i2c0"),
+};
+
+The mapping table may also contain pin configuration entries. It's common for
+each pin/group to have a number of configuration entries that affect it, so
+the table entries for configuration reference an array of config parameters
+and values. An example using the convenience macros is shown below:
+
+static unsigned long i2c_grp_configs[] = {
+	FOO_PIN_DRIVEN,
+	FOO_PIN_PULLUP,
+};
+
+static unsigned long i2c_pin_configs[] = {
+	FOO_OPEN_COLLECTOR,
+	FOO_SLEW_RATE_SLOW,
+};
+
+static struct pinctrl_map __initdata mapping[] = {
+	PIN_MAP_MUX_GROUP("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "i2c0"),
+	PIN_MAP_MUX_CONFIGS_GROUP("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", i2c_grp_configs),
+	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0scl", i2c_pin_configs),
+	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0sda", i2c_pin_configs),
+};
+
+Finally, some devices expect the mapping table to contain certain specific
+named states. When running on hardware that doesn't need any pin controller
+configuration, the mapping table must still contain those named states, in
+order to explicitly indicate that the states were provided and intended to
+be empty. Table entry macro PIN_MAP_DUMMY_STATE serves the purpose of defining
+a named state without causing any pin controller to be programmed:
+
+static struct pinctrl_map __initdata mapping[] = {
+	PIN_MAP_DUMMY_STATE("foo-i2c.0", PINCTRL_STATE_DEFAULT),
 };
 
 
@@ -831,6 +874,7 @@ As it is possible to map a function to different groups of pins an optional
 {
 	.dev_name = "foo-spi.0",
 	.name = "spi0-pos-A",
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "spi0",
 	.group = "spi0_0_grp",
@@ -838,6 +882,7 @@ As it is possible to map a function to different groups of pins an optional
 {
 	.dev_name = "foo-spi.0",
 	.name = "spi0-pos-B",
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "spi0",
 	.group = "spi0_1_grp",
@@ -857,6 +902,7 @@ case), we define a mapping like this:
 {
 	.dev_name = "foo-mmc.0",
 	.name = "2bit"
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
@@ -864,6 +910,7 @@ case), we define a mapping like this:
 {
 	.dev_name = "foo-mmc.0",
 	.name = "4bit"
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
@@ -871,6 +918,7 @@ case), we define a mapping like this:
 {
 	.dev_name = "foo-mmc.0",
 	.name = "4bit"
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_2_grp",
@@ -878,6 +926,7 @@ case), we define a mapping like this:
 {
 	.dev_name = "foo-mmc.0",
 	.name = "8bit"
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_1_grp",
@@ -885,6 +934,7 @@ case), we define a mapping like this:
 {
 	.dev_name = "foo-mmc.0",
 	.name = "8bit"
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_2_grp",
@@ -892,6 +942,7 @@ case), we define a mapping like this:
 {
 	.dev_name = "foo-mmc.0",
 	.name = "8bit"
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "mmc0",
 	.group = "mmc0_3_grp",
@@ -1014,6 +1065,7 @@ to the pin controller device name, and the state name is PINCTRL_STATE_DEFAULT.
 {
 	.dev_name = "pinctrl-foo",
 	.name = PINCTRL_STATE_DEFAULT,
+	.type = PIN_MAP_TYPE_MUX_GROUP,
 	.ctrl_dev_name = "pinctrl-foo",
 	.function = "power_func",
 },
@@ -1022,7 +1074,7 @@ Since it may be common to request the core to hog a few always-applicable
 mux settings on the primary pin controller, there is a convenience macro for
 this:
 
-PIN_MAP_SYS_HOG("pinctrl-foo", "power_func")
+PIN_MAP_MUX_GROUP_HOG("pinctrl-foo", NULL /* group */, "power_func")
 
 This gives the exact same result as the above construction.
 
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 18973ca..c965bb5 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -1569,13 +1569,13 @@ static struct platform_device dma_device = {
 /* Pinmux settings */
 static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
-	PIN_MAP_SYS_HOG("pinctrl-u300", "power"),
-	PIN_MAP_SYS_HOG("pinctrl-u300", "emif0"),
-	PIN_MAP_SYS_HOG("pinctrl-u300", "emif1"),
+	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "power"),
+	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "emif0"),
+	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "emif1"),
 	/* per-device maps for MMC/SD, SPI and UART */
-	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "mmc0", "mmci"),
-	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "spi0", "pl022"),
-	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "uart0", "uart0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("mmci",  "pinctrl-u300", NULL, "mmc0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("pl022", "pinctrl-u300", NULL, "spi0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-u300", NULL, "uart0"),
 };
 
 struct u300_mux_hog {
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c6f3ca3..4eae7e5 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -502,6 +502,9 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
 	if (IS_ERR(state))
 		return PTR_ERR(state);
 
+	if (map->type == PIN_MAP_TYPE_DUMMY_STATE)
+		return 0;
+
 	setting = kzalloc(sizeof(*setting), GFP_KERNEL);
 	if (setting == NULL) {
 		dev_err(p->dev,
@@ -509,6 +512,8 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
 		return -ENOMEM;
 	}
 
+	setting->type = map->type;
+
 	setting->pctldev = get_pinctrl_dev_from_devname(map->ctrl_dev_name);
 	if (setting->pctldev == NULL) {
 		dev_err(p->dev, "unknown pinctrl device %s in map entry",
@@ -518,7 +523,18 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
 		return -ENODEV;
 	}
 
-	ret = pinmux_map_to_setting(map, setting);
+	switch (map->type) {
+	case PIN_MAP_TYPE_MUX_GROUP:
+		ret = pinmux_map_to_setting(map, setting);
+		break;
+	case PIN_MAP_TYPE_CONFIGS_PIN:
+	case PIN_MAP_TYPE_CONFIGS_GROUP:
+		ret = pinconf_map_to_setting(map, setting);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
 	if (ret < 0) {
 		kfree(setting);
 		return ret;
@@ -626,9 +642,19 @@ static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
 
 	list_for_each_entry_safe(state, n1, &p->states, node) {
 		list_for_each_entry_safe(setting, n2, &state->settings, node) {
-			if (state == p->state)
-				pinmux_disable_setting(setting);
-			pinmux_free_setting(setting);
+			switch (setting->type) {
+			case PIN_MAP_TYPE_MUX_GROUP:
+				if (state == p->state)
+					pinmux_disable_setting(setting);
+				pinmux_free_setting(setting);
+				break;
+			case PIN_MAP_TYPE_CONFIGS_PIN:
+			case PIN_MAP_TYPE_CONFIGS_GROUP:
+				pinconf_free_setting(setting);
+				break;
+			default:
+				break;
+			}
 			list_del(&setting->node);
 			kfree(setting);
 		}
@@ -703,9 +729,13 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 		 */
 		list_for_each_entry(setting, &p->state->settings, node) {
 			bool found = false;
+			if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
+				continue;
 			list_for_each_entry(setting2, &state->settings, node) {
-				if (setting2->group_selector ==
-						setting->group_selector) {
+				if (setting2->type != PIN_MAP_TYPE_MUX_GROUP)
+					continue;
+				if (setting2->data.mux.group ==
+						setting->data.mux.group) {
 					found = true;
 					break;
 				}
@@ -719,7 +749,18 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 
 	/* Apply all the settings for the new state */
 	list_for_each_entry(setting, &state->settings, node) {
-		ret = pinmux_enable_setting(setting);
+		switch (setting->type) {
+		case PIN_MAP_TYPE_MUX_GROUP:
+			ret = pinmux_enable_setting(setting);
+			break;
+		case PIN_MAP_TYPE_CONFIGS_PIN:
+		case PIN_MAP_TYPE_CONFIGS_GROUP:
+			ret = pinconf_apply_setting(setting);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
 		if (ret < 0) {
 			/* FIXME: Difficult to return to prev state */
 			return ret;
@@ -756,33 +797,48 @@ EXPORT_SYMBOL_GPL(pinctrl_select_state);
 int pinctrl_register_mappings(struct pinctrl_map const *maps,
 			      unsigned num_maps)
 {
-	int i;
+	int i, ret;
 	struct pinctrl_maps *maps_node;
 
 	pr_debug("add %d pinmux maps\n", num_maps);
 
 	/* First sanity check the new mapping */
 	for (i = 0; i < num_maps; i++) {
+		if (!maps[i].dev_name) {
+			pr_err("failed to register map %s (%d): no device given\n",
+			       maps[i].name, i);
+			return -EINVAL;
+		}
+
 		if (!maps[i].name) {
 			pr_err("failed to register map %d: no map name given\n",
 			       i);
 			return -EINVAL;
 		}
 
-		if (!maps[i].ctrl_dev_name) {
+		if (maps[i].type != PIN_MAP_TYPE_DUMMY_STATE &&
+				!maps[i].ctrl_dev_name) {
 			pr_err("failed to register map %s (%d): no pin control device given\n",
 			       maps[i].name, i);
 			return -EINVAL;
 		}
 
-		if (!maps[i].function) {
-			pr_err("failed to register map %s (%d): no function ID given\n",
-			       maps[i].name, i);
-			return -EINVAL;
-		}
-
-		if (!maps[i].dev_name) {
-			pr_err("failed to register map %s (%d): no device given\n",
+		switch (maps[i].type) {
+		case PIN_MAP_TYPE_DUMMY_STATE:
+			break;
+		case PIN_MAP_TYPE_MUX_GROUP:
+			ret = pinmux_validate_map(&maps[i], i);
+			if (ret < 0)
+				return 0;
+			break;
+		case PIN_MAP_TYPE_CONFIGS_PIN:
+		case PIN_MAP_TYPE_CONFIGS_GROUP:
+			ret = pinconf_validate_map(&maps[i], i);
+			if (ret < 0)
+				return 0;
+			break;
+		default:
+			pr_err("failed to register map %s (%d): invalid type given\n",
 			       maps[i].name, i);
 			return -EINVAL;
 		}
@@ -934,6 +990,22 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 	return 0;
 }
 
+static inline const char *map_type(enum pinctrl_map_type type)
+{
+	static const char * const names[] = {
+		"INVALID",
+		"DUMMY_STATE",
+		"MUX_GROUP",
+		"CONFIGS_PIN",
+		"CONFIGS_GROUP",
+	};
+
+	if (type >= ARRAY_SIZE(names))
+		return "UNKNOWN";
+
+	return names[type];
+}
+
 static int pinctrl_maps_show(struct seq_file *s, void *what)
 {
 	struct pinctrl_maps *maps_node;
@@ -945,12 +1017,27 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 	mutex_lock(&pinctrl_mutex);
 
 	for_each_maps(maps_node, i, map) {
-		seq_printf(s, "%s:\n", map->name);
-		seq_printf(s, "  device: %s\n", map->dev_name);
-		seq_printf(s, "  controlling device %s\n", map->ctrl_dev_name);
-		seq_printf(s, "  function: %s\n", map->function);
-		seq_printf(s, "  group: %s\n", map->group ? map->group :
-			   "(default)");
+		seq_printf(s, "device %s\nstate %s\ntype %s (%d)\n",
+			   map->dev_name, map->name, map_type(map->type),
+			   map->type);
+
+		if (map->type != PIN_MAP_TYPE_DUMMY_STATE)
+			seq_printf(s, "controlling device %s\n",
+				   map->ctrl_dev_name);
+
+		switch (map->type) {
+		case PIN_MAP_TYPE_MUX_GROUP:
+			pinmux_show_map(s, map);
+			break;
+		case PIN_MAP_TYPE_CONFIGS_PIN:
+		case PIN_MAP_TYPE_CONFIGS_GROUP:
+			pinconf_show_map(s, map);
+			break;
+		default:
+			break;
+		}
+
+		seq_printf(s, "\n");
 	}
 
 	mutex_unlock(&pinctrl_mutex);
@@ -977,8 +1064,23 @@ static int pinctrl_show(struct seq_file *s, void *what)
 			seq_printf(s, "  state: %s\n", state->name);
 
 			list_for_each_entry(setting, &state->settings, node) {
-				seq_printf(s, "    ");
-				pinmux_dbg_show(s, setting);
+				struct pinctrl_dev *pctldev = setting->pctldev;
+
+				seq_printf(s, "    type: %s controller %s ",
+					   map_type(setting->type),
+					   pinctrl_dev_get_name(pctldev));
+
+				switch (setting->type) {
+				case PIN_MAP_TYPE_MUX_GROUP:
+					pinmux_show_setting(s, setting);
+					break;
+				case PIN_MAP_TYPE_CONFIGS_PIN:
+				case PIN_MAP_TYPE_CONFIGS_GROUP:
+					pinconf_show_setting(s, setting);
+					break;
+				default:
+					break;
+				}
 			}
 		}
 	}
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 5691d31..1cae372 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -72,17 +72,44 @@ struct pinctrl_state {
 };
 
 /**
+ * struct pinctrl_setting_mux - setting data for MAP_TYPE_MUX_GROUP
+ * @group: the group selector to program
+ * @func: the function selector to program
+ */
+struct pinctrl_setting_mux {
+	unsigned group;
+	unsigned func;
+};
+
+/**
+ * struct pinctrl_setting_configs - setting data for MAP_TYPE_CONFIGS_*
+ * @group_or_pin: the group selector or pin ID to program
+ * @configs: a pointer to an array of config parameters/values to program into
+ *	hardware. Each individual pin controller defines the format and meaning
+ *	of config parameters.
+ * @num_configs: the number of entries in array @configs
+ */
+struct pinctrl_setting_configs {
+	unsigned group_or_pin;
+	unsigned long *configs;
+	unsigned num_configs;
+};
+
+/**
  * struct pinctrl_setting - an individual mux setting
  * @node: list node for struct pinctrl_settings's @settings field
+ * @type: the type of setting
  * @pctldev: pin control device handling to be programmed
- * @group_selector: the group selector to program
- * @func_selector: the function selector to program
+ * @data: Data specific to the setting type
  */
 struct pinctrl_setting {
 	struct list_head node;
+	enum pinctrl_map_type type;
 	struct pinctrl_dev *pctldev;
-	unsigned group_selector;
-	unsigned func_selector;
+	union {
+		struct pinctrl_setting_mux mux;
+		struct pinctrl_setting_configs configs;
+	} data;
 };
 
 /**
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index e0a4537..84869f2 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -36,6 +36,24 @@ int pinconf_check_ops(struct pinctrl_dev *pctldev)
 	return 0;
 }
 
+int pinconf_validate_map(struct pinctrl_map const *map, int i)
+{
+	if (!map->data.configs.group_or_pin) {
+		pr_err("failed to register map %s (%d): no group/pin given\n",
+		       map->name, i);
+		return -EINVAL;
+	}
+
+	if (map->data.configs.num_configs &&
+			!map->data.configs.configs) {
+		pr_err("failed to register map %s (%d): no configs ptr given\n",
+		       map->name, i);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 			   unsigned long *config)
 {
@@ -260,8 +278,155 @@ unlock:
 }
 EXPORT_SYMBOL(pin_config_group_set);
 
+int pinconf_map_to_setting(struct pinctrl_map const *map,
+			  struct pinctrl_setting *setting)
+{
+	struct pinctrl_dev *pctldev = setting->pctldev;
+
+	switch (setting->type) {
+	case PIN_MAP_TYPE_CONFIGS_PIN:
+		setting->data.configs.group_or_pin =
+			pin_get_from_name(pctldev,
+					  map->data.configs.group_or_pin);
+		if (setting->data.configs.group_or_pin < 0)
+			return setting->data.configs.group_or_pin;
+		break;
+	case PIN_MAP_TYPE_CONFIGS_GROUP:
+		setting->data.configs.group_or_pin =
+			pinctrl_get_group_selector(pctldev,
+					map->data.configs.group_or_pin);
+		if (setting->data.configs.group_or_pin < 0)
+			return setting->data.configs.group_or_pin;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	setting->data.configs.num_configs = map->data.configs.num_configs;
+	setting->data.configs.configs = map->data.configs.configs;
+
+	return 0;
+}
+
+void pinconf_free_setting(struct pinctrl_setting const *setting)
+{
+}
+
+int pinconf_apply_setting(struct pinctrl_setting const *setting)
+{
+	struct pinctrl_dev *pctldev = setting->pctldev;
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+	int i, ret;
+
+	if (!ops) {
+		dev_err(pctldev->dev, "missing confops\n");
+		return -EINVAL;
+	}
+
+	switch (setting->type) {
+	case PIN_MAP_TYPE_CONFIGS_PIN:
+		if (!ops->pin_config_set) {
+			dev_err(pctldev->dev, "missing pin_config_set op\n");
+			return -EINVAL;
+		}
+		for (i = 0; i < setting->data.configs.num_configs; i++) {
+			ret = ops->pin_config_set(pctldev,
+					setting->data.configs.group_or_pin,
+					setting->data.configs.configs[i]);
+			if (ret < 0) {
+				dev_err(pctldev->dev,
+					"pin_config_set op failed for pin %d config %08lx\n",
+					setting->data.configs.group_or_pin,
+					setting->data.configs.configs[i]);
+				return ret;
+			}
+		}
+		break;
+	case PIN_MAP_TYPE_CONFIGS_GROUP:
+		if (!ops->pin_config_group_set) {
+			dev_err(pctldev->dev,
+				"missing pin_config_group_set op\n");
+			return -EINVAL;
+		}
+		for (i = 0; i < setting->data.configs.num_configs; i++) {
+			ret = ops->pin_config_group_set(pctldev,
+					setting->data.configs.group_or_pin,
+					setting->data.configs.configs[i]);
+			if (ret < 0) {
+				dev_err(pctldev->dev,
+					"pin_config_group_set op failed for group %d config %08lx\n",
+					setting->data.configs.group_or_pin,
+					setting->data.configs.configs[i]);
+				return ret;
+			}
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_FS
 
+void pinconf_show_map(struct seq_file *s, struct pinctrl_map const *map)
+{
+	int i;
+
+	switch (map->type) {
+	case PIN_MAP_TYPE_CONFIGS_PIN:
+		seq_printf(s, "pin ");
+		break;
+	case PIN_MAP_TYPE_CONFIGS_GROUP:
+		seq_printf(s, "group ");
+		break;
+	default:
+		break;
+	}
+
+	seq_printf(s, "%s\n", map->data.configs.group_or_pin);
+
+	for (i = 0; i < map->data.configs.num_configs; i++)
+		seq_printf(s, "config %08lx\n", map->data.configs.configs[i]);
+}
+
+void pinconf_show_setting(struct seq_file *s,
+			  struct pinctrl_setting const *setting)
+{
+	struct pinctrl_dev *pctldev = setting->pctldev;
+	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
+	struct pin_desc *desc;
+	int i;
+
+	switch (setting->type) {
+	case PIN_MAP_TYPE_CONFIGS_PIN:
+		desc = pin_desc_get(setting->pctldev,
+				    setting->data.configs.group_or_pin);
+		seq_printf(s, "pin %s (%d)",
+			   desc->name ? desc->name : "unnamed",
+			   setting->data.configs.group_or_pin);
+		break;
+	case PIN_MAP_TYPE_CONFIGS_GROUP:
+		seq_printf(s, "group %s (%d)",
+			   pctlops->get_group_name(pctldev,
+					setting->data.configs.group_or_pin),
+			   setting->data.configs.group_or_pin);
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * FIXME: We should really get the pin controler to dump the config
+	 * values, so they can be decoded to something meaningful.
+	 */
+	for (i = 0; i < setting->data.configs.num_configs; i++)
+		seq_printf(s, " %08lx", setting->data.configs.configs[i]);
+
+	seq_printf(s, "\n");
+}
+
 static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
 			     struct seq_file *s, int pin)
 {
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index 1d6ea9d..0ded227 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -15,6 +15,16 @@
 
 int pinconf_check_ops(struct pinctrl_dev *pctldev);
 
+int pinconf_validate_map(struct pinctrl_map const *map, int i);
+
+int pinconf_map_to_setting(struct pinctrl_map const *map,
+			  struct pinctrl_setting *setting);
+void pinconf_free_setting(struct pinctrl_setting const *setting);
+int pinconf_apply_setting(struct pinctrl_setting const *setting);
+
+void pinconf_show_map(struct seq_file *s, struct pinctrl_map const *map);
+void pinconf_show_setting(struct seq_file *s,
+			  struct pinctrl_setting const *setting);
 void pinconf_init_device_debugfs(struct dentry *devroot,
 				 struct pinctrl_dev *pctldev);
 
@@ -25,6 +35,36 @@ static inline int pinconf_check_ops(struct pinctrl_dev *pctldev)
 	return 0;
 }
 
+static inline int pinconf_validate_map(struct pinctrl_map const *map, int i)
+{
+	return 0;
+}
+
+static inline int pinconf_map_to_setting(struct pinctrl_map const *map,
+			  struct pinctrl_setting *setting)
+{
+	return 0;
+}
+
+static inline void pinconf_free_setting(struct pinctrl_setting const *setting)
+{
+}
+
+static inline int pinconf_apply_setting(struct pinctrl_setting const *setting)
+{
+	return 0;
+}
+
+static inline void pinconf_show_map(struct seq_file *s,
+				    struct pinctrl_map const *map)
+{
+}
+
+static inline void pinconf_show_setting(struct seq_file *s,
+			  struct pinctrl_setting const *setting)
+{
+}
+
 static inline void pinconf_init_device_debugfs(struct dentry *devroot,
 					       struct pinctrl_dev *pctldev)
 {
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 2d1aaf8..949512e 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -58,6 +58,17 @@ int pinmux_check_ops(struct pinctrl_dev *pctldev)
 	return 0;
 }
 
+int pinmux_validate_map(struct pinctrl_map const *map, int i)
+{
+	if (!map->data.mux.function) {
+		pr_err("failed to register map %s (%d): no function given\n",
+		       map->name, i);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * pin_request() - request a single pin to be muxed in, typically for GPIO
  * @pin: the pin number in the global pin space
@@ -284,21 +295,21 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
 	const unsigned *pins;
 	unsigned num_pins;
 
-	setting->func_selector =
-		pinmux_func_name_to_selector(pctldev, map->function);
-	if (setting->func_selector < 0)
-		return setting->func_selector;
+	setting->data.mux.func =
+		pinmux_func_name_to_selector(pctldev, map->data.mux.function);
+	if (setting->data.mux.func < 0)
+		return setting->data.mux.func;
 
-	ret = pmxops->get_function_groups(pctldev, setting->func_selector,
+	ret = pmxops->get_function_groups(pctldev, setting->data.mux.func,
 					  &groups, &num_groups);
 	if (ret < 0)
 		return ret;
 	if (!num_groups)
 		return -EINVAL;
 
-	if (map->group) {
+	if (map->data.mux.group) {
 		bool found = false;
-		group = map->group;
+		group = map->data.mux.group;
 		for (i = 0; i < num_groups; i++) {
 			if (!strcmp(group, groups[i])) {
 				found = true;
@@ -311,17 +322,16 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
 		group = groups[0];
 	}
 
-	setting->group_selector =
-		pinctrl_get_group_selector(pctldev, group);
-	if (setting->group_selector < 0)
-		return setting->group_selector;
+	setting->data.mux.group = pinctrl_get_group_selector(pctldev, group);
+	if (setting->data.mux.group < 0)
+		return setting->data.mux.group;
 
-	ret = pctlops->get_group_pins(pctldev, setting->group_selector,
-				      &pins, &num_pins);
+	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group, &pins,
+				      &num_pins);
 	if (ret) {
 		dev_err(pctldev->dev,
 			"could not get pins for device %s group selector %d\n",
-			pinctrl_dev_get_name(pctldev), setting->group_selector);
+			pinctrl_dev_get_name(pctldev), setting->data.mux.group);
 			return -ENODEV;
 	}
 
@@ -352,12 +362,12 @@ void pinmux_free_setting(struct pinctrl_setting const *setting)
 	int ret;
 	int i;
 
-	ret = pctlops->get_group_pins(pctldev, setting->group_selector,
+	ret = pctlops->get_group_pins(pctldev, setting->data.mux.group,
 				      &pins, &num_pins);
 	if (ret) {
 		dev_err(pctldev->dev,
 			"could not get pins for device %s group selector %d\n",
-			pinctrl_dev_get_name(pctldev), setting->group_selector);
+			pinctrl_dev_get_name(pctldev), setting->data.mux.group);
 		return;
 	}
 
@@ -370,8 +380,8 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
 	struct pinctrl_dev *pctldev = setting->pctldev;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 
-	return ops->enable(pctldev, setting->func_selector,
-			   setting->group_selector);
+	return ops->enable(pctldev, setting->data.mux.func,
+			   setting->data.mux.group);
 }
 
 void pinmux_disable_setting(struct pinctrl_setting const *setting)
@@ -379,7 +389,7 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
 	struct pinctrl_dev *pctldev = setting->pctldev;
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 
-	ops->disable(pctldev, setting->func_selector, setting->group_selector);
+	ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -458,18 +468,25 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	return 0;
 }
 
-void pinmux_dbg_show(struct seq_file *s, struct pinctrl_setting const *setting)
+void pinmux_show_map(struct seq_file *s, struct pinctrl_map const *map)
+{
+	seq_printf(s, "group %s\nfunction %s\n",
+		map->data.mux.group ? map->data.mux.group : "(default)",
+		map->data.mux.function);
+}
+
+void pinmux_show_setting(struct seq_file *s,
+			 struct pinctrl_setting const *setting)
 {
 	struct pinctrl_dev *pctldev = setting->pctldev;
 	const struct pinmux_ops *pmxops = pctldev->desc->pmxops;
 	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
 
-	seq_printf(s, "controller: %s group: %s (%u) function: %s (%u)\n",
-		   pinctrl_dev_get_name(pctldev),
-		   pctlops->get_group_name(pctldev, setting->group_selector),
-		   setting->group_selector,
-		   pmxops->get_function_name(pctldev, setting->func_selector),
-		   setting->func_selector);
+	seq_printf(s, "group: %s (%u) function: %s (%u)\n",
+		   pctlops->get_group_name(pctldev, setting->data.mux.group),
+		   setting->data.mux.group,
+		   pmxops->get_function_name(pctldev, setting->data.mux.func),
+		   setting->data.mux.func);
 }
 
 static int pinmux_functions_open(struct inode *inode, struct file *file)
diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index 1500ae8..6fc4700 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -14,6 +14,8 @@
 
 int pinmux_check_ops(struct pinctrl_dev *pctldev);
 
+int pinmux_validate_map(struct pinctrl_map const *map, int i);
+
 int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 			struct pinctrl_gpio_range *range,
 			unsigned pin, unsigned gpio);
@@ -29,7 +31,9 @@ void pinmux_free_setting(struct pinctrl_setting const *setting);
 int pinmux_enable_setting(struct pinctrl_setting const *setting);
 void pinmux_disable_setting(struct pinctrl_setting const *setting);
 
-void pinmux_dbg_show(struct seq_file *s, struct pinctrl_setting const *setting);
+void pinmux_show_map(struct seq_file *s, struct pinctrl_map const *map);
+void pinmux_show_setting(struct seq_file *s,
+			 struct pinctrl_setting const *setting);
 void pinmux_init_device_debugfs(struct dentry *devroot,
 				struct pinctrl_dev *pctldev);
 
@@ -40,6 +44,11 @@ static inline int pinmux_check_ops(struct pinctrl_dev *pctldev)
 	return 0;
 }
 
+static inline int pinmux_validate_map(struct pinctrl_map const *map, int i)
+{
+	return 0;
+}
+
 static inline int pinmux_request_gpio(struct pinctrl_dev *pctldev,
 			struct pinctrl_gpio_range *range,
 			unsigned pin, unsigned gpio)
@@ -80,12 +89,18 @@ static inline void pinmux_disable_setting(
 {
 }
 
-static inline void pinmux_init_device_debugfs(struct dentry *devroot,
-					      struct pinctrl_dev *pctldev)
+static inline void pinmux_show_map(struct seq_file *s,
+				   struct pinctrl_map const *map)
+{
+}
+
+static inline void pinmux_show_setting(struct seq_file *s,
+				       struct pinctrl_setting const *setting)
 {
 }
 
-static inline void pinmux_dbg_show(struct seq_file *s, struct pinctrl *p)
+static inline void pinmux_init_device_debugfs(struct dentry *devroot,
+					      struct pinctrl_dev *pctldev)
 {
 }
 
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index 05d25c8..b572153 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -14,6 +14,41 @@
 
 #include "pinctrl.h"
 
+enum pinctrl_map_type {
+	PIN_MAP_TYPE_INVALID,
+	PIN_MAP_TYPE_DUMMY_STATE,
+	PIN_MAP_TYPE_MUX_GROUP,
+	PIN_MAP_TYPE_CONFIGS_PIN,
+	PIN_MAP_TYPE_CONFIGS_GROUP,
+};
+
+/**
+ * struct pinctrl_map_mux - mapping table content for MAP_TYPE_MUX_GROUP
+ * @group: the name of the group whose mux function is to be configured. This
+ *	field may be left NULL, and the first applicable group for the function
+ *	will be used.
+ * @function: the mux function to select for the group
+ */
+struct pinctrl_map_mux {
+	const char *group;
+	const char *function;
+};
+
+/**
+ * struct pinctrl_map_configs - mapping table content for MAP_TYPE_CONFIGS_*
+ * @group_or_pin: the name of the pin or group whose configuration parameters
+ *	are to be configured.
+ * @configs: a pointer to an array of config parameters/values to program into
+ *	hardware. Each individual pin controller defines the format and meaning
+ *	of config parameters.
+ * @num_configs: the number of entries in array @configs
+ */
+struct pinctrl_map_configs {
+	const char *group_or_pin;
+	unsigned long *configs;
+	unsigned num_configs;
+};
+
 /**
  * struct pinctrl_map - boards/machines shall provide this map for devices
  * @dev_name: the name of the device using this specific mapping, the name
@@ -22,46 +57,96 @@
  *	hogged by the driver itself upon registration
  * @name: the name of this specific map entry for the particular machine.
  *	This is the parameter passed to pinmux_lookup_state()
+ * @type: the type of mapping table entry
  * @ctrl_dev_name: the name of the device controlling this specific mapping,
- *	the name must be the same as in your struct device*
- * @group: sometimes a function can map to different pin groups, so this
- *	selects a certain specific pin group to activate for the function, if
- *	left as NULL, the first applicable group will be used
- * @function: a function in the driver to use for this mapping, the driver
- *	will lookup the function referenced by this ID on the specified
- *	pin control device
+ *	the name must be the same as in your struct device*. This field is not
+ *	used for PIN_MAP_TYPE_DUMMY_STATE
+ * @data: Data specific to the mapping type
  */
 struct pinctrl_map {
 	const char *dev_name;
 	const char *name;
+	enum pinctrl_map_type type;
 	const char *ctrl_dev_name;
-	const char *group;
-	const char *function;
+	union {
+		struct pinctrl_map_mux mux;
+		struct pinctrl_map_configs configs;
+	} data;
 };
 
-/*
- * Convenience macro to set a simple map from a certain pin controller and a
- * certain function to a named device
- */
-#define PIN_MAP(a, b, c, d) \
-	{ .name = a, .ctrl_dev_name = b, .function = c, .dev_name = d }
+/* Convenience macros to create mapping table entries */
 
-/*
- * Convenience macro to map a system function onto a certain pinctrl device,
- * to be hogged by the pin control core until the system shuts down.
- */
-#define PIN_MAP_SYS_HOG(a, b) \
-	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
-	  .function = b, }
+#define PIN_MAP_DUMMY_STATE(dev, state) \
+	{								\
+		.dev_name = dev,					\
+		.name = state,						\
+		.type = PIN_MAP_TYPE_DUMMY_STATE,			\
+	}
 
-/*
- * Convenience macro to map a system function onto a certain pinctrl device
- * using a specified group, to be hogged by the pin control core until the
- * system shuts down.
- */
-#define PIN_MAP_SYS_HOG_GROUP(a, b, c) \
-	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
-	  .function = b, .group = c, }
+#define PIN_MAP_MUX_GROUP(dev, state, pinctrl, grp, func)		\
+	{								\
+		.dev_name = dev,					\
+		.name = state,						\
+		.type = PIN_MAP_TYPE_MUX_GROUP,				\
+		.ctrl_dev_name = pinctrl,				\
+		.data.mux = {						\
+			.group = grp,					\
+			.function = func,				\
+		},							\
+	}
+
+#define PIN_MAP_MUX_GROUP_DEFAULT(dev, pinctrl, grp, func)		\
+	PIN_MAP_MUX_GROUP(dev, PINCTRL_STATE_DEFAULT, pinctrl, grp, func)
+
+#define PIN_MAP_MUX_GROUP_HOG(dev, state, grp, func)			\
+	PIN_MAP_MUX_GROUP(dev, state, dev, grp, func)
+
+#define PIN_MAP_MUX_GROUP_HOG_DEFAULT(dev, grp, func)			\
+	PIN_MAP_MUX_GROUP(dev, PINCTRL_STATE_DEFAULT, dev, grp, func)
+
+#define PIN_MAP_MUX_CONFIGS_PIN(dev, state, pinctrl, pin, cfgs)		\
+	{								\
+		.dev_name = dev,					\
+		.name = state,						\
+		.type = PIN_MAP_TYPE_CONFIGS_PIN,			\
+		.ctrl_dev_name = pinctrl,				\
+		.data.configs = {					\
+			.group_or_pin = pin,				\
+			.configs = cfgs,				\
+			.num_configs = ARRAY_SIZE(cfgs),		\
+		},							\
+	}
+
+#define PIN_MAP_MUX_CONFIGS_PIN_DEFAULT(dev, pinctrl, pin, cfgs)	\
+	PIN_MAP_MUX_CONFIGS_PIN(dev, PINCTRL_STATE_DEFAULT, pinctrl, pin, cfgs)
+
+#define PIN_MAP_MUX_CONFIGS_PIN_HOG(dev, state, pin, cfgs)		\
+	PIN_MAP_MUX_CONFIGS_PIN(dev, state, dev, pin, cfgs)
+
+#define PIN_MAP_MUX_CONFIGS_PIN_HOG_DEFAULT(dev, pin, cfgs)		\
+	PIN_MAP_MUX_CONFIGS_PIN(dev, PINCTRL_STATE_DEFAULT, dev, pin, cfgs)
+
+#define PIN_MAP_MUX_CONFIGS_GROUP(dev, state, pinctrl, grp, cfgs)	\
+	{								\
+		.dev_name = dev,					\
+		.name = state,						\
+		.type = PIN_MAP_TYPE_CONFIGS_GROUP,			\
+		.ctrl_dev_name = pinctrl,				\
+		.data.configs = {					\
+			.group_or_pin = grp,				\
+			.configs = cfgs,				\
+			.num_configs = ARRAY_SIZE(cfgs),		\
+		},							\
+	}
+
+#define PIN_MAP_MUX_CONFIGS_GROUP_DEFAULT(dev, pinctrl, grp, cfgs)	\
+	PIN_MAP_MUX_CONFIGS_GROUP(dev, PINCTRL_STATE_DEFAULT, pinctrl, grp, cfgs)
+
+#define PIN_MAP_MUX_CONFIGS_GROUP_HOG(dev, state, grp, cfgs)		\
+	PIN_MAP_MUX_CONFIGS_GROUP(dev, state, dev, grp, cfgs)
+
+#define PIN_MAP_MUX_CONFIGS_GROUP_HOG_DEFAULT(dev, grp, cfgs)		\
+	PIN_MAP_MUX_CONFIGS_GROUP(dev, PINCTRL_STATE_DEFAULT, dev, grp, cfgs)
 
 #ifdef CONFIG_PINMUX
 
-- 
1.7.0.4

