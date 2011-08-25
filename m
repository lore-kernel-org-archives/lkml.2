Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1HYXo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:44:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44702 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1HYXoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:44:24 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v3 12/13] arm/tegra: Add device tree support to pinmux driver
Date: Thu, 25 Aug 2011 17:43:43 -0600
Message-Id: <1314315824-9687-13-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
[j.iles: converted to generic of_pinmux_parse()]
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
[swarren: Added support for pins property]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/pinmux.c |  260 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 260 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
index ed316f9..7526f7c 100644
--- a/arch/arm/mach-tegra/pinmux.c
+++ b/arch/arm/mach-tegra/pinmux.c
@@ -20,6 +20,9 @@
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_iter_prop.h>
+#include <linux/of_pinmux.h>
 #include <linux/platform_device.h>
 
 #include <mach/iomap.h>
@@ -124,6 +127,19 @@ static const char *pingroup_name(enum tegra_pingroup pg)
 	return pingroups[pg].name;
 }
 
+static int pingroup_enum(const char *name, enum tegra_pingroup *pg_out)
+{
+	int pg;
+
+	for (pg = 0; pg < TEGRA_MAX_PINGROUP; pg++)
+		if (!strcasecmp(name, tegra_soc_pingroups[pg].name)) {
+			*pg_out = pg;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
 static const char *func_name(enum tegra_mux_func func)
 {
 	if (func == TEGRA_MUX_RSVD1)
@@ -147,6 +163,39 @@ static const char *func_name(enum tegra_mux_func func)
 	return tegra_mux_names[func];
 }
 
+static int func_enum(const char *name, enum tegra_mux_func *func_out)
+{
+	int func;
+
+	if (!strcasecmp(name, "RSVD1")) {
+		*func_out = TEGRA_MUX_RSVD1;
+		return 0;
+	}
+	if (!strcasecmp(name, "RSVD2")) {
+		*func_out = TEGRA_MUX_RSVD2;
+		return 0;
+	}
+	if (!strcasecmp(name, "RSVD3")) {
+		*func_out = TEGRA_MUX_RSVD3;
+		return 0;
+	}
+	if (!strcasecmp(name, "RSVD4")) {
+		*func_out = TEGRA_MUX_RSVD4;
+		return 0;
+	}
+	if (!strcasecmp(name, "NONE")) {
+		*func_out = TEGRA_MUX_NONE;
+		return 0;
+	}
+
+	for (func = 0; func < TEGRA_MAX_MUX; func++)
+		if (!strcasecmp(name, tegra_mux_names[func])) {
+			*func_out = func;
+			return 0;
+		}
+
+	return -EINVAL;
+}
 
 static const char *tri_name(unsigned long val)
 {
@@ -329,6 +378,20 @@ static const char *drive_pinmux_name(enum tegra_drive_pingroup pg)
 	return drive_pingroups[pg].name;
 }
 
+static int drive_pinmux_enum(const char *name,
+			     enum tegra_drive_pingroup *pg_out)
+{
+	int pg;
+
+	for (pg = 0; pg < TEGRA_MAX_DRIVE_PINGROUP; pg++)
+		if (!strcasecmp(name, drive_pingroups[pg].name)) {
+			*pg_out = pg;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
 static const char *enable_name(unsigned long val)
 {
 	return val ? "ENABLE" : "DISABLE";
@@ -666,15 +729,212 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
 	}
 }
 
+struct tegra_pinmux_configs {
+	struct tegra_pingroup_config tcfg;
+	struct of_pinmux_cfg ocfg;
+};
+
+static int __init tegra_pinmux_dt_parse(const struct of_pinmux_ctrl *ctrl,
+					struct of_pinmux_cfg *cfg)
+{
+	struct tegra_pinmux_configs *cfgs =
+		container_of(cfg, struct tegra_pinmux_configs, ocfg);
+	struct tegra_pingroup_config *tcfg = &cfgs->tcfg;
+	struct of_pinmux_cfg *ocfg = &cfgs->ocfg;
+	int ret;
+
+	ret = func_enum(ocfg->function, &tcfg->func);
+	if (ret < 0) {
+		dev_err(ctrl->dev, "invalid function %s in node %s\n",
+			ocfg->function, ocfg->node->name);
+		return ret;
+	}
+
+	if (ocfg->flags & OF_PINMUX_PULL_UP)
+		tcfg->pupd = TEGRA_PUPD_PULL_UP;
+	else if (ocfg->flags & OF_PINMUX_PULL_DOWN)
+		tcfg->pupd = TEGRA_PUPD_PULL_DOWN;
+	else
+		tcfg->pupd = TEGRA_PUPD_NORMAL;
+
+	tcfg->tristate = (ocfg->flags & OF_PINMUX_TRISTATE) ?
+		TEGRA_TRI_TRISTATE : TEGRA_TRI_NORMAL;
+
+	return 0;
+}
+
+static int __init tegra_pinmux_dt_configure(const struct of_pinmux_ctrl *ctrl,
+					    const struct of_pinmux_cfg *cfg)
+{
+	struct tegra_pinmux_configs *cfgs =
+		container_of(cfg, struct tegra_pinmux_configs, ocfg);
+	struct tegra_pingroup_config *tcfg = &cfgs->tcfg;
+	struct of_pinmux_cfg *ocfg = &cfgs->ocfg;
+	int ret;
+
+	ret = pingroup_enum(ocfg->pin, &tcfg->pingroup);
+	if (ret < 0) {
+		dev_err(ctrl->dev, "invalid pingroup %s in node %s\n",
+			ocfg->pin, ocfg->node->name);
+		return ret;
+	}
+
+	tegra_pinmux_config_pingroup(tcfg);
+
+	return 0;
+}
+
+static void __init tegra_pinmux_parse_mux_groups(
+			struct platform_device *pdev,
+			struct device_node *mux_node)
+{
+	struct of_pinmux_ctrl tegra_pinmux_ctrl = {
+		.dev = &pdev->dev,
+		.node = mux_node,
+		.parse = tegra_pinmux_dt_parse,
+		.configure = tegra_pinmux_dt_configure,
+	};
+	struct tegra_pinmux_configs cfgs;
+
+	if (of_pinmux_parse(&tegra_pinmux_ctrl, &cfgs.ocfg))
+		pr_err("failed to parse pinmux configuration\n");
+}
+
+static void __init tegra_pinmux_parse_drive_groups(
+			struct platform_device *pdev,
+			struct device_node *drive_node)
+{
+	struct device_node *np;
+
+	for_each_child_of_node(drive_node, np) {
+		enum tegra_hsm hsm;
+		enum tegra_schmitt schmitt;
+		enum tegra_drive drive;
+		enum tegra_pull_strength pull_down;
+		enum tegra_pull_strength pull_up;
+		enum tegra_slew slew_rising;
+		enum tegra_slew slew_falling;
+		int ret;
+		bool hadpins = 0;
+		struct of_iter_string_prop iter;
+
+		if (of_find_property(np, "nvidia,high-speed-mode", NULL))
+			hsm = TEGRA_HSM_ENABLE;
+		else
+			hsm = TEGRA_HSM_DISABLE;
+
+		if (of_find_property(np, "nvidia,schmitt", NULL))
+			schmitt = TEGRA_SCHMITT_ENABLE;
+		else
+			schmitt = TEGRA_SCHMITT_DISABLE;
+
+		ret = of_property_read_u32(np, "nvidia,drive-power", &drive);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"no nvidia,drive-power for node %s\n",
+				np->name);
+			continue;
+		}
+
+		ret = of_property_read_u32(np, "nvidia,pull-down-strength",
+					   &pull_down);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"no nvidia,pull-down-strength for node %s\n",
+				np->name);
+			continue;
+		}
+
+		ret = of_property_read_u32(np, "nvidia,pull-up-strength",
+					   &pull_up);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"no nvidia,pull-up-strength for node %s\n",
+				np->name);
+			continue;
+		}
+
+		ret = of_property_read_u32(np, "nvidia,slew-rate-rising",
+					   &slew_rising);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"no nvidia,slew_rate-rising for node %s\n",
+				np->name);
+			continue;
+		}
+
+		ret = of_property_read_u32(np, "nvidia,slew-rate-falling",
+					   &slew_rising);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"no nvidia,slew_rate-falling for node %s\n",
+				np->name);
+			continue;
+		}
+
+		for_each_string_property_value(iter, np, "pins") {
+			enum tegra_drive_pingroup pg;
+
+			hadpins = 1;
+
+			ret = drive_pinmux_enum(iter.value, &pg);
+			if (ret < 0) {
+				dev_err(&pdev->dev,
+					"invalid pingroup %s in node %s\n",
+					iter.value, np->name);
+				continue;
+			}
+
+			dev_dbg(&pdev->dev,
+				"configure pin %s hsm %d schmitt %d drive %d "
+				"pull_down %d pull_up %d slew_r %d slew_f %d\n",
+				iter.value,
+				hsm, schmitt, drive,
+				pull_down, pull_up,
+				slew_rising, slew_falling);
+
+			tegra_drive_pinmux_config_pingroup(pg, hsm, schmitt,
+							   drive, pull_down,
+							   pull_up,
+							   slew_rising,
+							   slew_falling);
+		}
+
+		if (!hadpins)
+			dev_warn(&pdev->dev, "no pins for node %s\n",
+				 np->name);
+	}
+}
+
 static int __init tegra_pinmux_probe(struct platform_device *pdev)
 {
+	if (pdev->dev.of_node != NULL) {
+		struct device_node *node;
+
+		for_each_child_of_node(pdev->dev.of_node, node) {
+			if (!strcmp(node->name, "nvidia,mux-groups"))
+				tegra_pinmux_parse_mux_groups(pdev, node);
+			else if (!strcmp(node->name, "nvidia,drive-groups"))
+				tegra_pinmux_parse_drive_groups(pdev, node);
+			else
+				dev_err(&pdev->dev, "%s: Unknown child node\n",
+					node->name);
+		}
+	}
+
 	return 0;
 }
 
+static struct of_device_id tegra_pinmux_of_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra20-pinmux", },
+	{ },
+};
+
 static struct platform_driver tegra_pinmux_driver = {
 	.driver		= {
 		.name	= "tegra-pinmux",
 		.owner	= THIS_MODULE,
+		.of_match_table = tegra_pinmux_of_match,
 	},
 	.probe		= tegra_pinmux_probe,
 };
-- 
1.7.0.4

