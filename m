Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2LMNhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:37:35 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:57165 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597Ab2LMNhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:37:34 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: Add Device Tree support
Date: Thu, 13 Dec 2012 14:37:05 +0100
Message-ID: <1355405825-19400-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>

This implements pin multiplexing and pin configuration for the
Nomadik pin controller using the device tree.

Cc: Lee Jones <lee.jones@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../devicetree/bindings/pinctrl/ste,nomadik.txt    | 111 +++++++++
 drivers/pinctrl/pinctrl-nomadik.c                  | 250 +++++++++++++++++++++
 2 files changed, 361 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
new file mode 100644
index 0000000..02ff731
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
@@ -0,0 +1,111 @@
+ST Ericsson Nomadik pinmux controller
+
+Required properties:
+- compatible: "stericsson,nmk_pinctrl"
+- reg: Should contain the register physical address and length of the PRCMU.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+ST Ericsson's pin configuration nodes act as a container for an abitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin, a group, or a list of pins or groups. This configuration can include the
+mux function to select on those pin(s)/group(s), and various pin configuration
+parameters, such as inputn output, pull up, pull down...
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
+- ste,input:			no parameter, set pin in input with no pull mode.
+- ste,input_pull_up:		no parameter, set pin in input with pull up mode.
+- ste,input_pull_down:		no parameter, set pin in input with pull down mode.
+
+- ste,output:			integer, 0: output low, 1: output high, 2: output (value is not specified).
+- ste,sleep_mode:		integer, 0: sleep mode disable, 1: sleep mode enable.
+
+- ste,sleep_input:		no parameter, set pin in sleep input with no pull mode.
+- ste,sleep_input_pull_up:	no parameter, set pin in sleep input with pull up mode.
+- ste,sleep_input_pull_down:	no parameter, set pin in sleep input with pull down mode.
+
+- ste,sleep_output:		integer, 0: sleep output low, 1: sleep output high, 2: sleep output (value is not specified).
+
+- ste,sleep_wakeup:		interger, 0: disable sleep wakeup mode, 1: enable sleep wake up mode.
+- ste,sleep_gpio:		interger, 0: disable sleep gpio mode, 1: enable sleep gpio mode.
+
+- ste,sleep_pdis_mode:		integer, 0: pdis disabled, 1: pdis enable.
+
+
+Valid values for pin and group name are in Drivers/pinctrl/pinctrl-nomadik-db8500.c
+
+Example board file extract:
+
+	pinctrl {
+		compatible = "stericsson,nmk_pinctrl";
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
+					ste,input_pull_up;
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
+					ste,sleep_mode = <0>;
+					ste,sleep_input;
+					ste,sleep_wakeup_mode = <1>;
+					ste,sleep_pdis_mode = <0>;
+				};
+				uart0_sleep_cfg2 {
+					ste,pins = "GPIO1";
+					ste,sleep_mode = <0>;
+					ste,sleep_output = <1>;
+					ste,sleep_wakeup_mode = <1>;
+					ste,sleep_pdis_mode = <0>;
+				};
+				uart0_sleep_cfg3 {
+					ste,pins = "GPIO3";
+					ste,sleep_mode = <0>;
+					ste,sleep_output = <2>;
+					ste,sleep_wakeup_mode = <1>;
+					ste,sleep_pdis_mode = <0>;
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
+
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 1068faa..90b25ee 100644
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
@@ -1503,11 +1504,260 @@ static void nmk_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
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
+static const unsigned long nmk_pin_output_modes[] = {
+	PIN_OUTPUT_LOW,
+	PIN_OUTPUT_HIGH,
+	PIN_DIR_OUTPUT,
+};
+
+static const unsigned long nmk_pin_sleep_modes[] = {
+	PIN_SLEEPMODE_ENABLED,
+	PIN_SLEEPMODE_DISABLED,
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
+	NMK_CONFIG_PIN("ste,input",			PIN_INPUT_NOPULL),
+	NMK_CONFIG_PIN("ste,input_pull_up",		PIN_INPUT_PULLUP),
+	NMK_CONFIG_PIN("ste,input_pull_down",		PIN_INPUT_PULLDOWN),
+	NMK_CONFIG_PIN_ARRAY("ste,output",		nmk_pin_output_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep_mode",		nmk_pin_sleep_modes),
+	NMK_CONFIG_PIN("ste,sleep_input",		PIN_SLPM_INPUT_NOPULL),
+	NMK_CONFIG_PIN("ste,sleep_input_pull_up",	PIN_SLPM_INPUT_PULLUP),
+	NMK_CONFIG_PIN("ste,sleep_input_pull_down",	PIN_SLPM_INPUT_PULLDOWN),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep_output",	nmk_pin_sleep_output_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep_wakeup_mode",	nmk_pin_sleep_wakeup_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,gpio_mode",		nmk_pin_gpio_modes),
+	NMK_CONFIG_PIN_ARRAY("ste,sleep_pdis_mode",	nmk_pin_sleep_pdis_modes),
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
+static const char * nmk_find_pin_name(struct pinctrl_dev *pctldev, const char *pin_name)
+{
+	int i, pin_number;
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+
+	if (sscanf((char *) pin_name, "GPIO%d",&pin_number) == 1)
+		for(i = 0; i < npct->soc->npins; i++)
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
+	unsigned reserve = 1;
+	struct property *prop;
+	const char *group, *gpio_name;
+
+	ret = of_property_read_string(np, "ste,function", &function);
+	if (ret < 0)
+		reserve = 0;
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
-- 
1.7.11.3

