Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1LHWNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:13:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60083 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1LHWN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:13:28 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [RFC 3/3] New pinmux testing hacks
Date: Thu,  8 Dec 2011 15:13:10 -0700
Message-Id: <1323382390-14892-4-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
References: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
DO NOT MERGE this: This is a local hack I use for testing, never to be
accepted upstream. I include it only as an FYI to anyone interested in
testing this.

 arch/arm/boot/dts/tegra20.dtsi  |    8 +++++
 arch/arm/mach-tegra/pinmux.c    |    2 +
 drivers/pinctrl/pinctrl-tegra.c |   57 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 4af5cd2..557d3d1 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -108,6 +108,14 @@
 			0x70000868 0xa8 >; /* Pad control registers */
 	};
 
+	pinmux2: pinmux2@70000000 {
+		compatible = "nvidia,tegra20-pinmux-new";
+		reg = < 0x70000014 0x10    /* Tri-state registers */
+			0x70000080 0x20    /* Mux registers */
+			0x700000a0 0x14    /* Pull-up/down registers */
+			0x70000868 0xa8 >; /* Pad control registers */
+	};
+
 	serial@70006000 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
index 1d20165..453dce5 100644
--- a/arch/arm/mach-tegra/pinmux.c
+++ b/arch/arm/mach-tegra/pinmux.c
@@ -722,6 +722,7 @@ static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
 			return -ENODEV;
 		}
 
+#if 0
 		if (!devm_request_mem_region(&pdev->dev, res->start,
 					    resource_size(res),
 					    dev_name(&pdev->dev))) {
@@ -729,6 +730,7 @@ static int __devinit tegra_pinmux_probe(struct platform_device *pdev)
 				"Couldn't request MEM resource %d\n", i);
 			return -ENODEV;
 		}
+#endif
 
 		regs[i] = devm_ioremap(&pdev->dev, res->start,
 					resource_size(res));
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 988be8f..fc2aa7e 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -428,6 +428,59 @@ static struct of_device_id tegra_pinctrl_of_match[] __devinitdata = {
 	{},
 };
 
+#include <linux/pinctrl/machine.h>
+static void pmx_test_pre(void)
+{
+	static struct pinmux_map map[] = {
+		{
+			.name = "hack",
+			.ctrl_dev_name = "pinctrl.0",
+			.function = "pllm_out1",
+			.group = "cdev1",
+			.hog_on_boot = true,
+		},
+	};
+
+	pinmux_register_mappings(map, ARRAY_SIZE(map));
+}
+
+static void pmx_test_post(struct pinctrl_dev *pctl)
+{
+	unsigned long config;
+	int ret;
+
+	config = TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, 0);
+	ret = pin_config_group_get(pctl, "atc", &config);
+	if (ret)
+		printk("ATC TRISTATE: COULD NOT RETRIEVE: %d\n", ret);
+	else
+		printk("ATC TRISTATE IS %d\n", (int)TEGRA_PINCONF_UNPACK_ARG(config));
+
+	config = TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, 1);
+	ret = pin_config_group_set(pctl, "atc", config);
+	if (ret)
+		printk("ATC TRISTATE: COULD NOT SET: %d\n", ret);
+
+	config = TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, 0);
+	ret = pin_config_group_get(pctl, "atc", &config);
+	if (ret)
+		printk("ATC TRISTATE: COULD NOT RETRIEVE: %d\n", ret);
+	else
+		printk("ATC TRISTATE IS NOW %d\n", (int)TEGRA_PINCONF_UNPACK_ARG(config));
+
+	config = TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, 0);
+	ret = pin_config_group_set(pctl, "atc", config);
+	if (ret)
+		printk("ATC TRISTATE: COULD NOT SET: %d\n", ret);
+
+	config = TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, 0);
+	ret = pin_config_group_get(pctl, "atc", &config);
+	if (ret)
+		printk("ATC TRISTATE: COULD NOT RETRIEVE: %d\n", ret);
+	else
+		printk("ATC TRISTATE IS NOW %d\n", (int)TEGRA_PINCONF_UNPACK_ARG(config));
+}
+
 static int __devinit tegra_pinctrl_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
@@ -494,6 +547,8 @@ static int __devinit tegra_pinctrl_probe(struct platform_device *pdev)
 		}
 	}
 
+	pmx_test_pre();
+
 	pmx->pctl = pinctrl_register(&tegra_pinctrl_desc, &pdev->dev, pmx);
 	if (IS_ERR(pmx->pctl)) {
 		dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
@@ -502,6 +557,8 @@ static int __devinit tegra_pinctrl_probe(struct platform_device *pdev)
 
 	pinctrl_add_gpio_range(pmx->pctl, &tegra_pinctrl_gpio_range);
 
+	pmx_test_post(pmx->pctl);
+
 	platform_set_drvdata(pdev, pmx);
 
 	dev_dbg(&pdev->dev, "Probed Tegra pinctrl driver\n");
-- 
1.7.0.4

