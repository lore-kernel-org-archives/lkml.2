Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1HOU3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:29:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54894 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1HOU3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:29:14 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH v2 11/13] arm/tegra: Add device tree support to pinmux driver
Date: Mon, 15 Aug 2011 14:28:18 -0600
Message-Id: <1313440100-17131-12-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/pinmux.c |  249 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 249 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
index ed316f9..5dfe6c1 100644
--- a/arch/arm/mach-tegra/pinmux.c
+++ b/arch/arm/mach-tegra/pinmux.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 
 #include <mach/iomap.h>
@@ -124,6 +125,21 @@ static const char *pingroup_name(enum tegra_pingroup pg)
 	return pingroups[pg].name;
 }
 
+#ifdef CONFIG_OF
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
+#endif
+
 static const char *func_name(enum tegra_mux_func func)
 {
 	if (func == TEGRA_MUX_RSVD1)
@@ -147,6 +163,41 @@ static const char *func_name(enum tegra_mux_func func)
 	return tegra_mux_names[func];
 }
 
+#ifdef CONFIG_OF
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
+#endif
 
 static const char *tri_name(unsigned long val)
 {
@@ -329,6 +380,22 @@ static const char *drive_pinmux_name(enum tegra_drive_pingroup pg)
 	return drive_pingroups[pg].name;
 }
 
+#ifdef CONFIG_OF
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
+#endif
+
 static const char *enable_name(unsigned long val)
 {
 	return val ? "ENABLE" : "DISABLE";
@@ -666,15 +733,197 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
 	}
 }
 
+#ifdef CONFIG_OF
+static void __init tegra_pinmux_parse_mux_groups(
+			struct platform_device *pdev,
+			struct device_node *mux_node)
+{
+	struct device_node *node;
+
+	for_each_child_of_node(mux_node, node) {
+		struct tegra_pingroup_config config;
+		int ret;
+		const char *func;
+
+		ret = pingroup_enum(node->name, &config.pingroup);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(mux) %s: Invalid pingroup name\n",
+				node->name);
+			continue;
+		}
+
+		ret = of_property_read_string(node, "nvidia,function",
+					      &func);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(mux) %s: Missing property nvidia,function\n",
+				node->name);
+			continue;
+		}
+		ret = func_enum(func, &config.func);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(mux) %s: Invalid nvidia,function value %s\n",
+				node->name, func);
+			continue;
+		}
+
+		if (of_find_property(node, "nvidia,pull-up", NULL))
+			config.pupd = TEGRA_PUPD_PULL_UP;
+		else if (of_find_property(node, "nvidia,pull-down", NULL))
+			config.pupd = TEGRA_PUPD_PULL_DOWN;
+		else
+			config.pupd = TEGRA_PUPD_NORMAL;
+
+		if (of_find_property(node, "nvidia,tristate", NULL))
+			config.tristate = TEGRA_TRI_TRISTATE;
+		else
+			config.tristate = TEGRA_TRI_NORMAL;
+
+		dev_dbg(&pdev->dev, "(mux) %s: func %d (%s) pull %d tri %d\n",
+			node->name, config.func, func, config.pupd,
+			config.tristate);
+
+		tegra_pinmux_config_pingroup(&config);
+	}
+}
+
+static void __init tegra_pinmux_parse_drive_groups(
+			struct platform_device *pdev,
+			struct device_node *drive_node)
+{
+	struct device_node *node;
+
+	for_each_child_of_node(drive_node, node) {
+		enum tegra_drive_pingroup pg;
+		enum tegra_hsm hsm;
+		enum tegra_schmitt schmitt;
+		enum tegra_drive drive;
+		enum tegra_pull_strength pull_down;
+		enum tegra_pull_strength pull_up;
+		enum tegra_slew slew_rising;
+		enum tegra_slew slew_falling;
+		int ret;
+
+		ret = drive_pinmux_enum(node->name, &pg);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(drive) %s: Invalid pingroup name\n",
+				node->name);
+			continue;
+		}
+
+		if (of_find_property(node, "nvidia,high-speed-mode", NULL))
+			hsm = TEGRA_HSM_ENABLE;
+		else
+			hsm = TEGRA_HSM_DISABLE;
+
+		if (of_find_property(node, "nvidia,schmitt", NULL))
+			schmitt = TEGRA_SCHMITT_ENABLE;
+		else
+			schmitt = TEGRA_SCHMITT_DISABLE;
+
+		ret = of_property_read_u32(node, "nvidia,drive-power", &drive);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(drive) %s: Missing property "
+				"nvidia,drive-power\n",
+				node->name);
+			continue;
+		}
+
+		ret = of_property_read_u32(node, "nvidia,pull-down-strength",
+					   &pull_down);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(drive) %s: Missing property "
+				"nvidia,pull-down-strength\n",
+				node->name);
+			continue;
+		}
+
+		ret = of_property_read_u32(node, "nvidia,pull-up-strength",
+					   &pull_up);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(drive) %s: Missing property "
+				"nvidia,pull-up-strength\n",
+				node->name);
+			continue;
+		}
+
+		ret = of_property_read_u32(node, "nvidia,slew-rate-rising",
+					   &slew_rising);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(drive) %s: Missing property "
+				"nvidia,slew_rate-rising\n",
+				node->name);
+			continue;
+		}
+
+		ret = of_property_read_u32(node, "nvidia,slew-rate-falling",
+					   &slew_rising);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"(drive) %s: Missing property "
+				"nvidia,slew_rate-falling\n",
+				node->name);
+			continue;
+		}
+
+		dev_dbg(&pdev->dev,
+			"(drive) %s: hsm %d schmitt %d drive %d "
+			"pull_down %d pull_up %d slew_r %d slew_f %d\n",
+			node->name,
+			hsm, schmitt, drive,
+			pull_down, pull_up,
+			slew_rising, slew_falling);
+
+		tegra_drive_pinmux_config_pingroup(pg, hsm, schmitt, drive,
+						   pull_down, pull_up,
+						   slew_rising, slew_falling);
+	}
+}
+
+static void __init tegra_pinmux_probe_dt(struct platform_device *pdev)
+{
+	struct device_node *node;
+
+	for_each_child_of_node(pdev->dev.of_node, node) {
+		if (!strcmp(node->name, "nvidia,mux-groups"))
+			tegra_pinmux_parse_mux_groups(pdev, node);
+		else if (!strcmp(node->name, "nvidia,drive-groups"))
+			tegra_pinmux_parse_drive_groups(pdev, node);
+		else
+			dev_err(&pdev->dev, "%s: Unknown child node\n",
+				node->name);
+	}
+}
+#else
+static inline void __init tegra_pinmux_probe_dt(struct platform_device *pdev)
+{
+}
+#endif
+
 static int __init tegra_pinmux_probe(struct platform_device *pdev)
 {
+	tegra_pinmux_probe_dt(pdev);
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

