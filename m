Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380Ab2DKWr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:47:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39833 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366Ab2DKWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:47:25 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: tegra: debugfs enhancements
Date: Wed, 11 Apr 2012 16:47:19 -0600
Message-Id: <1334184439-16428-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

* Only provide debugfs-relates ops when CONFIG_DEBUG_FS is enabled.
* Implement pin_config_group_dbg_show op.
* Implement pin_config_config_dbg_show op.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Linus, this too would be best to take through the Tegra tree. It depends
on the other two patches I just posted, but to satisfy that, I'll just
base my branch off of pinctrl once you've applied those branches and its
stable.

 drivers/pinctrl/pinctrl-tegra.c |   75 +++++++++++++++++++++++++++++++++++---
 1 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 3ac8ad3..df52d75 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -83,12 +83,14 @@ static int tegra_pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_FS
 static void tegra_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
 				       struct seq_file *s,
 				       unsigned offset)
 {
 	seq_printf(s, " %s", dev_name(pctldev->dev));
 }
+#endif
 
 static int reserve_map(struct pinctrl_map **map, unsigned *reserved_maps,
 		       unsigned *num_maps, unsigned reserve)
@@ -295,7 +297,9 @@ static struct pinctrl_ops tegra_pinctrl_ops = {
 	.get_groups_count = tegra_pinctrl_get_groups_count,
 	.get_group_name = tegra_pinctrl_get_group_name,
 	.get_group_pins = tegra_pinctrl_get_group_pins,
+#ifdef CONFIG_DEBUG_FS
 	.pin_dbg_show = tegra_pinctrl_pin_dbg_show,
+#endif
 	.dt_node_to_map = tegra_pinctrl_dt_node_to_map,
 	.dt_free_map = tegra_pinctrl_dt_free_map,
 };
@@ -385,6 +389,7 @@ static struct pinmux_ops tegra_pinmux_ops = {
 static int tegra_pinconf_reg(struct tegra_pmx *pmx,
 			     const struct tegra_pingroup *g,
 			     enum tegra_pinconf_param param,
+			     bool report_err,
 			     s8 *bank, s16 *reg, s8 *bit, s8 *width)
 {
 	switch (param) {
@@ -472,9 +477,10 @@ static int tegra_pinconf_reg(struct tegra_pmx *pmx,
 	}
 
 	if (*reg < 0) {
-		dev_err(pmx->dev,
-			"Config param %04x not supported on group %s\n",
-			param, g->name);
+		if (report_err)
+			dev_err(pmx->dev,
+				"Config param %04x not supported on group %s\n",
+				param, g->name);
 		return -ENOTSUPP;
 	}
 
@@ -507,7 +513,8 @@ static int tegra_pinconf_group_get(struct pinctrl_dev *pctldev,
 
 	g = &pmx->soc->groups[group];
 
-	ret = tegra_pinconf_reg(pmx, g, param, &bank, &reg, &bit, &width);
+	ret = tegra_pinconf_reg(pmx, g, param, true, &bank, &reg, &bit,
+				&width);
 	if (ret < 0)
 		return ret;
 
@@ -534,7 +541,8 @@ static int tegra_pinconf_group_set(struct pinctrl_dev *pctldev,
 
 	g = &pmx->soc->groups[group];
 
-	ret = tegra_pinconf_reg(pmx, g, param, &bank, &reg, &bit, &width);
+	ret = tegra_pinconf_reg(pmx, g, param, true, &bank, &reg, &bit,
+				&width);
 	if (ret < 0)
 		return ret;
 
@@ -563,23 +571,78 @@ static int tegra_pinconf_group_set(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_FS
 static void tegra_pinconf_dbg_show(struct pinctrl_dev *pctldev,
 				   struct seq_file *s, unsigned offset)
 {
 }
 
+static const char *strip_prefix(const char *s)
+{
+	const char *comma = strchr(s, ',');
+	if (!comma)
+		return s;
+
+	return comma + 1;
+}
+
 static void tegra_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
-					 struct seq_file *s, unsigned selector)
+					 struct seq_file *s, unsigned group)
+{
+	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tegra_pingroup *g;
+	int i, ret;
+	s8 bank, bit, width;
+	s16 reg;
+	u32 val;
+
+	g = &pmx->soc->groups[group];
+
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		ret = tegra_pinconf_reg(pmx, g, cfg_params[i].param, false,
+					&bank, &reg, &bit, &width);
+		if (ret < 0)
+			continue;
+
+		val = pmx_readl(pmx, bank, reg);
+		val >>= bit;
+		val &= (1 << width) - 1;
+
+		seq_printf(s, "\n\t%s=%u",
+			   strip_prefix(cfg_params[i].property), val);
+	}
+}
+
+static void tegra_pinconf_config_dbg_show(struct pinctrl_dev *pctldev,
+					  struct seq_file *s,
+					  unsigned long config)
 {
+	enum tegra_pinconf_param param = TEGRA_PINCONF_UNPACK_PARAM(config);
+	u16 arg = TEGRA_PINCONF_UNPACK_ARG(config);
+	const char *pname = "unknown";
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		if (cfg_params[i].param == param) {
+			pname = cfg_params[i].property;
+			break;
+		}
+	}
+
+	seq_printf(s, "%s=%d", strip_prefix(pname), arg);
 }
+#endif
 
 struct pinconf_ops tegra_pinconf_ops = {
 	.pin_config_get = tegra_pinconf_get,
 	.pin_config_set = tegra_pinconf_set,
 	.pin_config_group_get = tegra_pinconf_group_get,
 	.pin_config_group_set = tegra_pinconf_group_set,
+#ifdef CONFIG_DEBUG_FS
 	.pin_config_dbg_show = tegra_pinconf_dbg_show,
 	.pin_config_group_dbg_show = tegra_pinconf_group_dbg_show,
+	.pin_config_config_dbg_show = tegra_pinconf_config_dbg_show,
+#endif
 };
 
 static struct pinctrl_gpio_range tegra_pinctrl_gpio_range = {
-- 
1.7.0.4

