Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3ACOzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:55:40 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:39606 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604Ab3ACOze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:55:34 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3] pinctrl/nomadik: add device tree support
Date: Thu, 3 Jan 2013 15:55:12 +0100
Message-ID: <1357224912-22226-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>

This implements pin multiplexing and pin configuration for
the Nomadik pin controller using the device tree.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Philippe Langlais <philippe.langlais@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Replace nmk_pinctrl with nmk-pinctrl to conform to common design
  pattern everywhere.
- Fix spelling mistakes.
- Fix DTS compatible strings.
- Remove surplus blank line.
- Invert if() clause from (ret < 0) to (ret >= 0).
---
 .../devicetree/bindings/pinctrl/ste,nomadik.txt    | 127 ++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/mach-ux500/cpu-db8500.c                   |   2 +-
 drivers/pinctrl/pinctrl-nomadik.c                  | 261 ++++++++++++++++++++-
 4 files changed, 389 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
new file mode 100644
index 0000000..8639234
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
@@ -0,0 +1,127 @@
+ST Ericsson Nomadik pinmux controller
+
+Required properties:
+- compatible: "stericsson,nmk-pinctrl", "stericsson,nmk-pinctrl-db8540",
+              "stericsson,nmk-pinctrl-stn8815"
+- reg: Should contain the register physical address and length of the PRCMU.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+ST Ericsson's pin configuration nodes act as a container for an arbitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin, a group, or a list of pins or groups. This configuration can include the
+mux function to select on those pin(s)/group(s), and various pin configuration
+parameters, such as input, output, pull up, pull down...
+
+The name of each subnode is not important; all subnodes should be enumerated
+and processed purely based on their content.
+
+Required subnode-properties:
+- ste,pins : An array of strings. Each string contains the name of a pin or
+    group.
+
+Optional subnode-properties:
+- ste,function: A string containing the name of the function to mux to the
+  pin or group.
+
+- ste,input : <0/1/2/3>
+	0: input with no pull
+	1: input with pull up,
+	2: input with pull down,
+	3: input and keep last input configuration (no pull, pull up or pull down).
+
+- ste,output: <0/1/2>
+	0: output low,
+	1: output high,
+	2: output (value is not specified).
+
+- ste,sleep: <0/1>
+	0: sleep mode disable,
+	1: sleep mode enable.
+
+- ste,sleep-input: <0/1/2>
+	0: sleep input with no pull,
+	1: sleep input with pull up,
+	2: sleep input with pull down.
+
+- ste,sleep-output: <0/1/2>
+	0: sleep output low,
+	1: sleep output high,
+	2: sleep output (value is not specified).
+
+- ste,sleep-gpio: <0/1>
+	0: disable sleep gpio mode,
+	1: enable sleep gpio mode.
+
+- ste,sleep-wakeup: <0/1>
+	0: wake-up detection enabled,
+	1: wake-up detection disabled.
+
+- ste,sleep-pull-disable: <0/1>
+	0: GPIO pull-up or pull-down resistor is enabled, when pin is an input,
+	1: GPIO pull-up and pull-down resistor are disabled.
+
+Example board file extract:
+
+	pinctrl@80157000 {
+		compatible = "stericsson,nmk-pinctrl";
+		reg = <0x80157000 0x2000>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&uart0_default_mode>;
+
+		uart0 {
+			uart0_default_mux: uart0_mux {
+				u0_default_mux {
+					ste,function = "u0";
+					ste,pins = "u0_a_1";
+					};
+			};
+			uart0_default_mode: uart0_default {
+				uart0_default_cfg1 {
+					ste,pins = "GPIO0", "GPIO2";
+					ste,input = <1>;
+				};
+
+				uart0_default_cfg2 {
+					ste,pins = "GPIO1", "GPIO3";
+					ste,output = <1>;
+				};
+			};
+			uart0_sleep_mode: uart0_sleep {
+				uart0_sleep_cfg1 {
+					ste,pins = "GPIO0", "GPIO2";
+					ste,sleep = <0>;
+					ste,sleep-input = <0>;
+					ste,sleep-wakeup = <1>;
+					ste,sleep-pull-disable = <0>;
+				};
+				uart0_sleep_cfg2 {
+					ste,pins = "GPIO1";
+					ste,sleep = <0>;
+					ste,sleep-output = <1>;
+					ste,sleep-wakeup = <1>;
+					ste,sleep-pull-disable = <0>;
+				};
+				uart0_sleep_cfg3 {
+					ste,pins = "GPIO3";
+					ste,sleep = <0>;
+					ste,sleep-output = <2>;
+					ste,sleep-wakeup = <1>;
+					ste,sleep-pull-disable = <0>;
+				};
+			};
+		};
+	};
+
+	uart@80120000 {
+		compatible = "arm,pl011", "arm,primecell";
+		reg = <0x80120000 0x1000>;
+		interrupts = <0 11 0x4>;
+
+		pinctrl-names = "default","sleep";
+		pinctrl-0 = <&uart0_default_mux>, <&uart0_default_mode>;
+		pinctrl-1 = <&uart0_sleep_mode>;
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 902b1b1..1532137 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -50,6 +50,7 @@ simtek
 sirf	SiRF Technology, Inc.
 snps 	Synopsys, Inc.
 st	STMicroelectronics
+ste	ST-Ericsson
 stericsson	ST-Ericsson
 ti	Texas Instruments
 via	VIA Technologies, Inc.
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 5b286e0..b80ad96 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -285,7 +285,7 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80110000, "nmk-i2c.3", NULL),
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x8012a000, "nmk-i2c.4", NULL),
 	/* Requires device name bindings. */
-	OF_DEV_AUXDATA("stericsson,nmk_pinctrl", U8500_PRCMU_BASE,
+	OF_DEV_AUXDATA("stericsson,nmk-pinctrl", U8500_PRCMU_BASE,
 		"pinctrl-db8500", NULL),
 	/* Requires clock name and DMA bindings. */
 	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 78ab91e..b508bd7 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -25,6 +25,7 @@
 #include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/of_device.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf.h>
@@ -1509,11 +1510,269 @@ static void nmk_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 	nmk_gpio_dbg_show_one(s, pctldev, chip, offset - chip->base, offset);
 }
 
+static void nmk_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
+		struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
+			kfree(map[i].data.configs.configs);
+	kfree(map);
+}
+
+static int nmk_dt_reserve_map(struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, unsigned reserve)
+{
+	unsigned old_num = *reserved_maps;
+	unsigned new_num = *num_maps + reserve;
+	struct pinctrl_map *new_map;
+
+	if (old_num >= new_num)
+		return 0;
+
+	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	if (!new_map)
+		return -ENOMEM;
+
+	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
+
+	*map = new_map;
+	*reserved_maps = new_num;
+
+	return 0;
+}
+
+static int nmk_dt_add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		const char *function)
+{
+	if (*num_maps == *reserved_maps)
+		return -ENOSPC;
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)[*num_maps].data.mux.group = group;
+	(*map)[*num_maps].data.mux.function = function;
+	(*num_maps)++;
+
+	return 0;
+}
+
+static int nmk_dt_add_map_configs(struct pinctrl_map **map,
+		unsigned *reserved_maps,
+		unsigned *num_maps, const char *group,
+		unsigned long *configs, unsigned num_configs)
+{
+	unsigned long *dup_configs;
+
+	if (*num_maps == *reserved_maps)
+		return -ENOSPC;
+
+	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
+			      GFP_KERNEL);
+	if (!dup_configs)
+		return -ENOMEM;
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_PIN;
+
+	(*map)[*num_maps].data.configs.group_or_pin = group;
+	(*map)[*num_maps].data.configs.configs = dup_configs;
+	(*map)[*num_maps].data.configs.num_configs = num_configs;
+	(*num_maps)++;
+
+	return 0;
+}
+
+#define NMK_CONFIG_PIN(x,y) { .property = x, .config = y, }
+#define NMK_CONFIG_PIN_ARRAY(x,y) { .property = x, .choice = y, \
+	.size = ARRAY_SIZE(y), }
+
+static const unsigned long nmk_pin_input_modes[] = {
+	PIN_INPUT_NOPULL,
+	PIN_INPUT_PULLUP,
+	PIN_INPUT_PULLDOWN,
+};
+
+static const unsigned long nmk_pin_output_modes[] = {
+	PIN_OUTPUT_LOW,
+	PIN_OUTPUT_HIGH,
+	PIN_DIR_OUTPUT,
+};
+
+static const unsigned long nmk_pin_sleep_modes[] = {
+	PIN_SLEEPMODE_DISABLED,
+	PIN_SLEEPMODE_ENABLED,
+};
+
+static const unsigned long nmk_pin_sleep_input_modes[] = {
+	PIN_SLPM_INPUT_NOPULL,
+	PIN_SLPM_INPUT_PULLUP,
+	PIN_SLPM_INPUT_PULLDOWN,
+	PIN_SLPM_DIR_INPUT,
+};
+
+static const unsigned long nmk_pin_sleep_output_modes[] = {
+	PIN_SLPM_OUTPUT_LOW,
+	PIN_SLPM_OUTPUT_HIGH,
+	PIN_SLPM_DIR_OUTPUT,
+};
+
+static const unsigned long nmk_pin_sleep_wakeup_modes[] = {
+	PIN_SLPM_WAKEUP_DISABLE,
+	PIN_SLPM_WAKEUP_ENABLE,
+};
+
+static const unsigned long nmk_pin_gpio_modes[] = {
+	PIN_GPIOMODE_DISABLED,
+	PIN_GPIOMODE_ENABLED,
+};
+
+static const unsigned long nmk_pin_sleep_pdis_modes[] = {
+	PIN_SLPM_PDIS_DISABLED,
+	PIN_SLPM_PDIS_ENABLED,
+};
+
+struct nmk_cfg_param {
+	const char *property;
+	unsigned long config;
+	const unsigned long *choice;
+	int size;
+};
+
+static const struct nmk_cfg_param nmk_cfg_params[] = {
+	NMK_CONFIG_PIN_ARRAY("ste,input",		nmk_pin_input_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,output",		nmk_pin_output_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep",		nmk_pin_sleep_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep-input",		nmk_pin_sleep_input_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep-output",	nmk_pin_sleep_output_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep-wakeup",	nmk_pin_sleep_wakeup_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,gpio",		nmk_pin_gpio_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep-pull-disable",	nmk_pin_sleep_pdis_modes),
+};
+
+static int nmk_dt_pin_config(int index, int val, unsigned long *config)
+{
+	int ret = 0;
+
+	if (nmk_cfg_params[index].choice == NULL)
+		*config = nmk_cfg_params[index].config;
+	else {
+		/* test if out of range */
+		if  (val < nmk_cfg_params[index].size) {
+			*config = nmk_cfg_params[index].config |
+				nmk_cfg_params[index].choice[val];
+		}
+	}
+	return ret;
+}
+
+static const char *nmk_find_pin_name(struct pinctrl_dev *pctldev, const char *pin_name)
+{
+	int i, pin_number;
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+
+	if (sscanf((char *)pin_name, "GPIO%d", &pin_number) == 1)
+		for (i = 0; i < npct->soc->npins; i++)
+			if (npct->soc->pins[i].number == pin_number)
+				return npct->soc->pins[i].name;
+	return NULL;
+}
+
+int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
+		struct device_node *np,
+		struct pinctrl_map **map,
+		unsigned *reserved_maps,
+		unsigned *num_maps)
+{
+	int ret, i;
+	const char *function = NULL;
+	unsigned long configs = 0;
+	bool has_config = 0;
+	unsigned reserve = 0;
+	struct property *prop;
+	const char *group, *gpio_name;
+
+	ret = of_property_read_string(np, "ste,function", &function);
+	if (ret >= 0)
+		reserve = 1;
+
+	for (i = 0; i < ARRAY_SIZE(nmk_cfg_params); i++) {
+		unsigned long cfg = 0;
+		int val;
+
+		ret = of_property_read_u32(np, nmk_cfg_params[i].property, &val);
+		if (ret != -EINVAL) {
+			if (nmk_dt_pin_config(i, val, &cfg) == 0) {
+				configs |= cfg;
+				has_config = 1;
+			}
+		}
+	}
+	ret = of_property_count_strings(np, "ste,pins");
+	if (ret < 0)
+		goto exit;
+
+	if (has_config)
+		reserve++;
+
+	reserve *= ret;
+
+	ret = nmk_dt_reserve_map(map, reserved_maps, num_maps, reserve);
+	if (ret < 0)
+		goto exit;
+
+	of_property_for_each_string(np, "ste,pins", prop, group) {
+		if (function) {
+			ret = nmk_dt_add_map_mux(map, reserved_maps, num_maps,
+					  group, function);
+			if (ret < 0)
+				goto exit;
+		}
+		if (has_config) {
+			gpio_name = nmk_find_pin_name(pctldev, group);
+
+			ret = nmk_dt_add_map_configs(map, reserved_maps, num_maps,
+					      gpio_name, &configs, 1);
+			if (ret < 0)
+				goto exit;
+		}
+
+	}
+exit:
+	return ret;
+}
+
+int nmk_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+				 struct device_node *np_config,
+				 struct pinctrl_map **map, unsigned *num_maps)
+{
+	unsigned reserved_maps;
+	struct device_node *np;
+	int ret;
+
+	reserved_maps = 0;
+	*map = NULL;
+	*num_maps = 0;
+
+	for_each_child_of_node(np_config, np) {
+		ret = nmk_pinctrl_dt_subnode_to_map(pctldev, np, map,
+				&reserved_maps, num_maps);
+		if (ret < 0) {
+			nmk_pinctrl_dt_free_map(pctldev, *map, *num_maps);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static struct pinctrl_ops nmk_pinctrl_ops = {
 	.get_groups_count = nmk_get_groups_cnt,
 	.get_group_name = nmk_get_group_name,
 	.get_group_pins = nmk_get_group_pins,
 	.pin_dbg_show = nmk_pin_dbg_show,
+	.dt_node_to_map = nmk_pinctrl_dt_node_to_map,
+	.dt_free_map = nmk_pinctrl_dt_free_map,
 };
 
 static int nmk_pmx_get_funcs_cnt(struct pinctrl_dev *pctldev)
@@ -1847,7 +2106,7 @@ static struct pinctrl_desc nmk_pinctrl_desc = {
 
 static const struct of_device_id nmk_pinctrl_match[] = {
 	{
-		.compatible = "stericsson,nmk_pinctrl",
+		.compatible = "stericsson,nmk-pinctrl",
 		.data = (void *)PINCTRL_NMK_DB8500,
 	},
 	{},
-- 
1.7.11.3

