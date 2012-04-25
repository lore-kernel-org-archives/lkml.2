Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab2DYUDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:03:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60608 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab2DYUDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:03:36 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: tegra: error reporting cleanup
Date: Wed, 25 Apr 2012 14:03:29 -0600
Message-Id: <1335384209-23065-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Print an explicit error message in various failure cases to allow
easier diagnosis.

WARN_ON() some internal failures that users/clients shouldn't be able to
trigger.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Linus, I intend to take this through the Tegra tree; it most likely depends
on other stuff in the Tegra repo's gpio-pinmux branch.

 drivers/pinctrl/pinctrl-tegra.c |   81 ++++++++++++++++++++++++++------------
 1 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index df52d75..b693486 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -92,8 +92,9 @@ static void tegra_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
 }
 #endif
 
-static int reserve_map(struct pinctrl_map **map, unsigned *reserved_maps,
-		       unsigned *num_maps, unsigned reserve)
+static int reserve_map(struct device *dev, struct pinctrl_map **map,
+		       unsigned *reserved_maps, unsigned *num_maps,
+		       unsigned reserve)
 {
 	unsigned old_num = *reserved_maps;
 	unsigned new_num = *num_maps + reserve;
@@ -103,8 +104,10 @@ static int reserve_map(struct pinctrl_map **map, unsigned *reserved_maps,
 		return 0;
 
 	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
-	if (!new_map)
+	if (!new_map) {
+		dev_err(dev, "krealloc(map) failed\n");
 		return -ENOMEM;
+	}
 
 	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
 
@@ -118,7 +121,7 @@ static int add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
 		       unsigned *num_maps, const char *group,
 		       const char *function)
 {
-	if (*num_maps == *reserved_maps)
+	if (WARN_ON(*num_maps == *reserved_maps))
 		return -ENOSPC;
 
 	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
@@ -129,19 +132,22 @@ static int add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
 	return 0;
 }
 
-static int add_map_configs(struct pinctrl_map **map, unsigned *reserved_maps,
-			   unsigned *num_maps, const char *group,
-			   unsigned long *configs, unsigned num_configs)
+static int add_map_configs(struct device *dev, struct pinctrl_map **map,
+			   unsigned *reserved_maps, unsigned *num_maps,
+			   const char *group, unsigned long *configs,
+			   unsigned num_configs)
 {
 	unsigned long *dup_configs;
 
-	if (*num_maps == *reserved_maps)
+	if (WARN_ON(*num_maps == *reserved_maps))
 		return -ENOSPC;
 
 	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
 			      GFP_KERNEL);
-	if (!dup_configs)
+	if (!dup_configs) {
+		dev_err(dev, "kmemdup(configs) failed\n");
 		return -ENOMEM;
+	}
 
 	(*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
 	(*map)[*num_maps].data.configs.group_or_pin = group;
@@ -152,8 +158,8 @@ static int add_map_configs(struct pinctrl_map **map, unsigned *reserved_maps,
 	return 0;
 }
 
-static int add_config(unsigned long **configs, unsigned *num_configs,
-		      unsigned long config)
+static int add_config(struct device *dev, unsigned long **configs,
+		      unsigned *num_configs, unsigned long config)
 {
 	unsigned old_num = *num_configs;
 	unsigned new_num = old_num + 1;
@@ -161,8 +167,10 @@ static int add_config(unsigned long **configs, unsigned *num_configs,
 
 	new_configs = krealloc(*configs, sizeof(*new_configs) * new_num,
 			       GFP_KERNEL);
-	if (!new_configs)
+	if (!new_configs) {
+		dev_err(dev, "krealloc(configs) failed\n");
 		return -ENOMEM;
+	}
 
 	new_configs[old_num] = config;
 
@@ -203,7 +211,8 @@ static const struct cfg_param {
 	{"nvidia,slew-rate-rising",	TEGRA_PINCONF_PARAM_SLEW_RATE_RISING},
 };
 
-int tegra_pinctrl_dt_subnode_to_map(struct device_node *np,
+int tegra_pinctrl_dt_subnode_to_map(struct device *dev,
+				    struct device_node *np,
 				    struct pinctrl_map **map,
 				    unsigned *reserved_maps,
 				    unsigned *num_maps)
@@ -219,16 +228,25 @@ int tegra_pinctrl_dt_subnode_to_map(struct device_node *np,
 	const char *group;
 
 	ret = of_property_read_string(np, "nvidia,function", &function);
-	if (ret < 0)
+	if (ret < 0) {
+		/* EINVAL=missing, which is fine since it's optional */
+		if (ret != -EINVAL)
+			dev_err(dev,
+				"could not parse property nvidia,function\n");
 		function = NULL;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
 		ret = of_property_read_u32(np, cfg_params[i].property, &val);
 		if (!ret) {
 			config = TEGRA_PINCONF_PACK(cfg_params[i].param, val);
-			ret = add_config(&configs, &num_configs, config);
+			ret = add_config(dev, &configs, &num_configs, config);
 			if (ret < 0)
 				goto exit;
+		/* EINVAL=missing, which is fine since it's optional */
+		} else if (ret != -EINVAL) {
+			dev_err(dev, "could not parse property %s\n",
+				cfg_params[i].property);
 		}
 	}
 
@@ -238,11 +256,13 @@ int tegra_pinctrl_dt_subnode_to_map(struct device_node *np,
 	if (num_configs)
 		reserve++;
 	ret = of_property_count_strings(np, "nvidia,pins");
-	if (ret < 0)
+	if (ret < 0) {
+		dev_err(dev, "could not parse property nvidia,pins\n");
 		goto exit;
+	}
 	reserve *= ret;
 
-	ret = reserve_map(map, reserved_maps, num_maps, reserve);
+	ret = reserve_map(dev, map, reserved_maps, num_maps, reserve);
 	if (ret < 0)
 		goto exit;
 
@@ -255,8 +275,9 @@ int tegra_pinctrl_dt_subnode_to_map(struct device_node *np,
 		}
 
 		if (num_configs) {
-			ret = add_map_configs(map, reserved_maps, num_maps,
-					      group, configs, num_configs);
+			ret = add_map_configs(dev, map, reserved_maps,
+					      num_maps, group, configs,
+					      num_configs);
 			if (ret < 0)
 				goto exit;
 		}
@@ -282,8 +303,8 @@ int tegra_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
 	*num_maps = 0;
 
 	for_each_child_of_node(np_config, np) {
-		ret = tegra_pinctrl_dt_subnode_to_map(np, map, &reserved_maps,
-						      num_maps);
+		ret = tegra_pinctrl_dt_subnode_to_map(pctldev->dev, np, map,
+						      &reserved_maps, num_maps);
 		if (ret < 0) {
 			tegra_pinctrl_dt_free_map(pctldev, *map, *num_maps);
 			return ret;
@@ -342,14 +363,14 @@ static int tegra_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
 
 	g = &pmx->soc->groups[group];
 
-	if (g->mux_reg < 0)
+	if (WARN_ON(g->mux_reg < 0))
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(g->funcs); i++) {
 		if (g->funcs[i] == function)
 			break;
 	}
-	if (i == ARRAY_SIZE(g->funcs))
+	if (WARN_ON(i == ARRAY_SIZE(g->funcs)))
 		return -EINVAL;
 
 	val = pmx_readl(pmx, g->mux_bank, g->mux_reg);
@@ -369,7 +390,7 @@ static void tegra_pinctrl_disable(struct pinctrl_dev *pctldev,
 
 	g = &pmx->soc->groups[group];
 
-	if (g->mux_reg < 0)
+	if (WARN_ON(g->mux_reg < 0))
 		return;
 
 	val = pmx_readl(pmx, g->mux_bank, g->mux_reg);
@@ -490,12 +511,14 @@ static int tegra_pinconf_reg(struct tegra_pmx *pmx,
 static int tegra_pinconf_get(struct pinctrl_dev *pctldev,
 			     unsigned pin, unsigned long *config)
 {
+	dev_err(pctldev->dev, "pin_config_get op not supported\n");
 	return -ENOTSUPP;
 }
 
 static int tegra_pinconf_set(struct pinctrl_dev *pctldev,
 			     unsigned pin, unsigned long config)
 {
+	dev_err(pctldev->dev, "pin_config_set op not supported\n");
 	return -ENOTSUPP;
 }
 
@@ -550,8 +573,10 @@ static int tegra_pinconf_group_set(struct pinctrl_dev *pctldev,
 
 	/* LOCK can't be cleared */
 	if (param == TEGRA_PINCONF_PARAM_LOCK) {
-		if ((val & BIT(bit)) && !arg)
+		if ((val & BIT(bit)) && !arg) {
+			dev_err(pctldev->dev, "LOCK bit cannot be cleared\n");
 			return -EINVAL;
+		}
 	}
 
 	/* Special-case Boolean values; allow any non-zero as true */
@@ -560,8 +585,12 @@ static int tegra_pinconf_group_set(struct pinctrl_dev *pctldev,
 
 	/* Range-check user-supplied value */
 	mask = (1 << width) - 1;
-	if (arg & ~mask)
+	if (arg & ~mask) {
+		dev_err(pctldev->dev,
+			"config %lx: %x too big for %d bit register\n",
+			config, arg, width);
 		return -EINVAL;
+	}
 
 	/* Update register */
 	val &= ~(mask << bit);
-- 
1.7.0.4

