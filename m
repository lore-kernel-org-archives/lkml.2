Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1HLWz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:55:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36182 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1HLWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:55:26 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 10/12] arm/tegra: Add device tree support to pinmux driver
Date: Fri, 12 Aug 2011 16:54:55 -0600
Message-Id: <1313189697-21287-11-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/pinmux.c |  115 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
index 05fa1a3..33246c2 100644
--- a/arch/arm/mach-tegra/pinmux.c
+++ b/arch/arm/mach-tegra/pinmux.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 
 #include <mach/iomap.h>
@@ -147,6 +148,41 @@ static const char *func_name(enum tegra_mux_func func)
 	return tegra_mux_names[func];
 }
 
+#ifdef CONFIG_OF
+static int func_enum(const char *name, enum tegra_mux_func *func_out)
+{
+	int func;
+
+	if (!strcmp(name, "RSVD1")) {
+		*func_out = TEGRA_MUX_RSVD1;
+		return 0;
+	}
+	if (!strcmp(name, "RSVD2")) {
+		*func_out = TEGRA_MUX_RSVD2;
+		return 0;
+	}
+	if (!strcmp(name, "RSVD3")) {
+		*func_out = TEGRA_MUX_RSVD3;
+		return 0;
+	}
+	if (!strcmp(name, "RSVD4")) {
+		*func_out = TEGRA_MUX_RSVD4;
+		return 0;
+	}
+	if (!strcmp(name, "NONE")) {
+		*func_out = TEGRA_MUX_NONE;
+		return 0;
+	}
+
+	for (func = 0; func < TEGRA_MAX_MUX; func++)
+		if (!strcmp(name, tegra_mux_names[func])) {
+			*func_out = func;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+#endif
 
 static const char *tri_name(unsigned long val)
 {
@@ -666,15 +702,94 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
 	}
 }
 
+#ifdef CONFIG_OF
+static void __init tegra_pinmux_probe_dt(struct platform_device *pdev)
+{
+	int pg;
+
+	for (pg = 0; pg < TEGRA_MAX_PINGROUP; pg++) {
+		const char *pg_name = pingroup_name(pg);
+		struct tegra_pingroup_config config;
+		struct device_node *pg_node;
+		int ret;
+		const char *s;
+
+		pg_node = of_find_child_node_by_name(pdev->dev.of_node,
+						     pg_name);
+		if (pg_node == NULL)
+			continue;
+
+		config.pingroup = pg;
+
+		ret = of_property_read_string(pg_node, "nvidia,function", &s);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"%s: Missing property nvidia,function\n",
+				pg_name);
+			continue;
+		}
+		ret = func_enum(s, &config.func);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"%s: Invalid nvidia,function value %s\n",
+				pg_name, s);
+			continue;
+		}
+
+		ret = of_property_read_string(pg_node, "nvidia,pull", &s);
+		if (ret >= 0) {
+			if (!strcmp(s, "up"))
+				config.pupd = TEGRA_PUPD_PULL_UP;
+			else if (!strcmp(s, "down"))
+				config.pupd = TEGRA_PUPD_PULL_DOWN;
+			else if (!strcmp(s, "normal"))
+				config.pupd = TEGRA_PUPD_NORMAL;
+			else {
+				dev_err(&pdev->dev,
+					"%s: Invalid nvidia,pull value %s\n",
+					pg_name, s);
+				continue;
+			}
+		} else
+			config.pupd = TEGRA_PUPD_NORMAL;
+
+		if (of_find_property(pg_node, "nvidia,tristate", NULL))
+			config.tristate = TEGRA_TRI_TRISTATE;
+		else
+			config.tristate = TEGRA_TRI_NORMAL;
+
+		dev_err(&pdev->dev, "%s: func %d (%s) pull %d tri %d\n",
+			pg_name, config.func, func_name(config.func),
+			config.pupd, config.tristate);
+
+		tegra_pinmux_config_pingroup(&config);
+
+		of_node_put(pg_node);
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

