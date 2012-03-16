Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161880Ab2CPUzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:55:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41464 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965332Ab2CPUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:55:09 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 8/8] pinctrl: tegra: Add complete device tree support
Date: Fri, 16 Mar 2012 14:54:29 -0600
Message-Id: <1331931269-12262-8-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement pinctrl_ops dt_node_to_map() and dt_free_map(). These allow
complete specification of the desired pinmux configuration using device
tree.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/pinctrl/pinctrl-tegra.c |  180 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 180 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 9b32968..19ac661 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -23,9 +23,12 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
+#include <linux/of_iter_prop.h>
+#include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf.h>
+#include <linux/slab.h>
 
 #include <mach/pinconf-tegra.h>
 
@@ -98,11 +101,188 @@ static void tegra_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
 	seq_printf(s, " " DRIVER_NAME);
 }
 
+static int add_map(struct pinctrl_map **map, unsigned *num_maps)
+{
+	unsigned old_num = *num_maps;
+	unsigned new_num = old_num + 1;
+	struct pinctrl_map *new_map;
+
+	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	if (!new_map)
+		return -ENOMEM;
+
+	memset(new_map + old_num, 0, sizeof(*new_map));
+
+	*map = new_map;
+	*num_maps = new_num;
+
+	return 0;
+}
+
+static int add_map_mux(struct pinctrl_map **map, unsigned *num_maps,
+		       const char *group, const char *function)
+{
+	unsigned i = *num_maps;
+	int ret;
+
+	ret = add_map(map, num_maps);
+	if (ret < 0)
+		return ret;
+
+	(*map)[i].type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)[i].data.mux.group = group;
+	(*map)[i].data.mux.function = function;
+
+	return 0;
+}
+
+static int add_map_configs(struct pinctrl_map **map, unsigned *num_maps,
+			   const char *group, unsigned long *configs,
+			   unsigned num_configs)
+{
+	unsigned i = *num_maps;
+	unsigned long *dup_configs;
+	int ret;
+
+	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
+			      GFP_KERNEL);
+	if (!dup_configs)
+		return -ENOMEM;
+
+	ret = add_map(map, num_maps);
+	if (ret < 0)
+		return ret;
+
+	(*map)[i].type = PIN_MAP_TYPE_CONFIGS_GROUP;
+	(*map)[i].data.configs.group_or_pin = group;
+	(*map)[i].data.configs.configs = dup_configs;
+	(*map)[i].data.configs.num_configs = num_configs;
+
+	return 0;
+}
+
+static int add_config(unsigned long **configs, unsigned *num_configs,
+		      unsigned long config)
+{
+	unsigned old_num = *num_configs;
+	unsigned new_num = old_num + 1;
+	unsigned long *new_configs;
+
+	new_configs = krealloc(*configs, sizeof(*new_configs) * new_num,
+			       GFP_KERNEL);
+	if (!new_configs)
+		return -ENOMEM;
+
+	new_configs[old_num] = config;
+
+	*configs = new_configs;
+	*num_configs = new_num;
+
+	return 0;
+}
+
+void tegra_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
+			       struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+			kfree(map[i].data.configs.configs);
+
+	kfree(map);
+}
+
+static const struct cfg_param {
+	const char *property;
+	enum tegra_pinconf_param param;
+} cfg_params[] = {
+	{"nvidia,pull",			TEGRA_PINCONF_PARAM_PULL},
+	{"nvidia,tristate",		TEGRA_PINCONF_PARAM_TRISTATE},
+	{"nvidia,enable-input",		TEGRA_PINCONF_PARAM_ENABLE_INPUT},
+	{"nvidia,open-drain",		TEGRA_PINCONF_PARAM_OPEN_DRAIN},
+	{"nvidia,lock",			TEGRA_PINCONF_PARAM_LOCK},
+	{"nvidia,io-reset",		TEGRA_PINCONF_PARAM_IORESET},
+	{"nvidia,high-speed-mode",	TEGRA_PINCONF_PARAM_HIGH_SPEED_MODE},
+	{"nvidia,schmitt",		TEGRA_PINCONF_PARAM_SCHMITT},
+	{"nvidia,low-power-mode",	TEGRA_PINCONF_PARAM_LOW_POWER_MODE},
+	{"nvidia,pull-down-strength",	TEGRA_PINCONF_PARAM_DRIVE_DOWN_STRENGTH},
+	{"nvidia,pull-up-strength",	TEGRA_PINCONF_PARAM_DRIVE_UP_STRENGTH},
+	{"nvidia,slew-rate-falling",	TEGRA_PINCONF_PARAM_SLEW_RATE_FALLING},
+	{"nvidia,slew-rate-rising",	TEGRA_PINCONF_PARAM_SLEW_RATE_RISING},
+};
+
+int tegra_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+				 struct device_node *np_config,
+				 struct pinctrl_map **map, unsigned *num_maps)
+{
+	struct device_node *np;
+	struct of_iter_string_prop group;
+	unsigned long config;
+	unsigned long *configs = NULL;
+	unsigned num_configs = 0;
+	const char *function;
+	u32 val;
+	int ret, i;
+
+	*map = NULL;
+	*num_maps = 0;
+
+	for_each_child_of_node(np_config, np) {
+		ret = of_property_read_string(np, "nvidia,function", &function);
+		if (ret < 0)
+			function = NULL;
+
+		for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+			ret = of_property_read_u32(np, cfg_params[i].property,
+						   &val);
+			if (!ret) {
+				config = TEGRA_PINCONF_PACK(
+						cfg_params[i].param, val);
+				ret = add_config(&configs, &num_configs,
+						 config);
+				if (ret < 0)
+					goto error;
+			}
+		}
+
+		for_each_string_property_value(group, np, "nvidia,pins") {
+			if (function) {
+				ret = add_map_mux(map, num_maps, group.value,
+						  function);
+				if (ret < 0)
+					goto error;
+			}
+
+			if (num_configs) {
+				ret = add_map_configs(map, num_maps,
+					group.value, configs, num_configs);
+				if (ret < 0)
+					goto error;
+			}
+		}
+
+		kfree(configs);
+		configs = NULL;
+		num_configs = 0;
+	}
+
+	return 0;
+
+error:
+	kfree(configs);
+	tegra_pinctrl_dt_free_map(pctldev, *map, *num_maps);
+
+	return ret;
+}
+
 static struct pinctrl_ops tegra_pinctrl_ops = {
 	.list_groups = tegra_pinctrl_list_groups,
 	.get_group_name = tegra_pinctrl_get_group_name,
 	.get_group_pins = tegra_pinctrl_get_group_pins,
 	.pin_dbg_show = tegra_pinctrl_pin_dbg_show,
+	.dt_node_to_map = tegra_pinctrl_dt_node_to_map,
+	.dt_free_map = tegra_pinctrl_dt_free_map,
 };
 
 static int tegra_pinctrl_list_funcs(struct pinctrl_dev *pctldev,
-- 
1.7.0.4

