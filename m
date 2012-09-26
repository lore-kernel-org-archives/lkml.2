Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2IZLqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:46:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37554 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab2IZLql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:46:41 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support for APWM driver
Date: Wed, 26 Sep 2012 16:57:42 +0530
Message-ID: <1348658863-29428-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for device-tree binding and of_xlate for ECAP APWM driver.
of_xlate provides ECAP APWM polarity configuration from client driver
device-tree.
Also size of pwm-cells set to 3 to support pwm channel number, pwm
period & polarity configuration from device tree.

Add platform data with has_configspace as member. Set has_configspace as
true for platforms which has common config space for enabling clock
gating.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:000000 100644 0000000... e93745d... A	Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
:100644 100644 081471f... 776b7ca... M	drivers/pwm/pwm-tiecap.c
:000000 100644 0000000... 0c19dcb... A	include/linux/platform_data/ti-pwmss.h
 .../devicetree/bindings/pwm/pwm-tiecap.txt         |   26 +++++
 drivers/pwm/pwm-tiecap.c                           |  105 ++++++++++++++++++++
 include/linux/platform_data/ti-pwmss.h             |   23 +++++
 3 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
new file mode 100644
index 0000000..e93745d
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
@@ -0,0 +1,26 @@
+TI SOC ECAP based APWM controller
+
+Required properties:
+- compatible: Must be "ti,am33xx-ecap"
+- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
+  First cell specifies the per-chip index of the PWM to use, the second
+  cell is the period cycle in nanoseconds and the third cell is the polarity
+  of PWM output. Polarity 0 gives normal polarity and 1 gives inversed
+  polarity (inverse duty cycle)
+- reg: physical base address and size of the registers map. For am33xx,
+  2 register maps are present (ECAP register space & PWM subsystem common
+  config space). Order should be maintained with ECAP register map as first
+  entry & PWM subsystem common config space as second entry.
+
+Optional properties:
+- ti,hwmods: Name of the hwmod associated to the ECAP:
+  "ecap<x>", <x> being the 0-based instance number from the HW spec
+
+Example:
+
+ecap0: ecap@0 {
+	compatible = "ti,am33xx-ecap";
+	#pwm-cells = <3>;
+	reg = <0x48300100 0x80 0x48300000 0x10>;
+	ti,hwmods = "ecap0";
+};
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 081471f..776b7ca 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -25,6 +25,9 @@
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
 #include <linux/pwm.h>
+#include <linux/of_device.h>
+#include <linux/platform_data/ti-pwmss.h>
+#include <linux/pinctrl/consumer.h>
 
 /* ECAP registers and bits definitions */
 #define CAP1			0x08
@@ -37,10 +40,16 @@
 #define ECCTL2_SYNC_SEL_DISA	(BIT(7) | BIT(6))
 #define ECCTL2_TSCTR_FREERUN	BIT(4)
 
+#define PWMSS_CLKCONFIG		8
+#define PWMSS_ECAP_CLK_EN	BIT(0)
+
+#define PWM_CELL_SIZE		3
+
 struct ecap_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
 	void __iomem	*mmio_base;
+	void __iomem	*config_base;
 };
 
 static inline struct ecap_pwm_chip *to_ecap_pwm_chip(struct pwm_chip *chip)
@@ -184,12 +193,60 @@ static const struct pwm_ops ecap_pwm_ops = {
 	.owner		= THIS_MODULE,
 };
 
+static struct pwm_device *of_ecap_xlate(struct pwm_chip *chip,
+		const struct of_phandle_args *args)
+{
+	struct pwm_device *pwm;
+
+	if (chip->of_pwm_n_cells < PWM_CELL_SIZE)
+		return ERR_PTR(-EINVAL);
+
+	if (args->args[0] >= chip->npwm)
+		return ERR_PTR(-EINVAL);
+
+	pwm = pwm_request_from_chip(chip, args->args[0], NULL);
+	if (IS_ERR(pwm))
+		return pwm;
+
+	pwm_set_period(pwm, args->args[1]);
+	pwm_set_polarity(pwm, args->args[2]);
+	return pwm;
+}
+
+static struct pwmss_platform_data am33xx_data = {
+	.has_configspace	= true,
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id ecap_of_match[] = {
+	{
+		.compatible	= "ti,am33xx-ecap",
+		.data		= &am33xx_data,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ecap_of_match);
+#endif
+
 static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct resource *r;
 	struct clk *clk;
 	struct ecap_pwm_chip *pc;
+	struct pwmss_platform_data *pdata = pdev->dev.platform_data;
+	const struct of_device_id *match;
+	u16 regval;
+	struct pinctrl *pinctrl;
+
+	match = of_match_device(of_match_ptr(ecap_of_match), &pdev->dev);
+
+	if (match)
+		pdata = (struct pwmss_platform_data *)match->data;
+
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&pdev->dev, "failed to configure pins from driver\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
@@ -211,6 +268,8 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ecap_pwm_ops;
+	pc->chip.of_xlate = of_ecap_xlate;
+	pc->chip.of_pwm_n_cells = PWM_CELL_SIZE;
 	pc->chip.base = -1;
 	pc->chip.npwm = 1;
 
@@ -231,13 +290,56 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(&pdev->dev);
+
+	/*
+	 * Some platform has extra PWM-subsystem common config space
+	 * and requires special handling of clock gating.
+	 */
+	if (pdata && pdata->has_configspace) {
+		r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!r) {
+			dev_err(&pdev->dev, "no memory resource defined\n");
+			ret = -ENODEV;
+			goto err_disable_clock;
+		}
+
+		pc->config_base = devm_ioremap(&pdev->dev, r->start,
+				resource_size(r));
+		if (!pc->config_base) {
+			dev_err(&pdev->dev, "failed to ioremap() registers\n");
+			ret = -EADDRNOTAVAIL;
+			goto err_disable_clock;
+		}
+
+		/* Enable ECAP clock gating at PWM-subsystem common config */
+		pm_runtime_get_sync(&pdev->dev);
+		regval = readw(pc->config_base + PWMSS_CLKCONFIG);
+		regval |= PWMSS_ECAP_CLK_EN;
+		writew(regval, pc->config_base + PWMSS_CLKCONFIG);
+		pm_runtime_put_sync(&pdev->dev);
+	}
+
 	platform_set_drvdata(pdev, pc);
 	return 0;
+
+err_disable_clock:
+	pm_runtime_disable(&pdev->dev);
+	return ret;
 }
 
 static int __devexit ecap_pwm_remove(struct platform_device *pdev)
 {
 	struct ecap_pwm_chip *pc = platform_get_drvdata(pdev);
+	u16 regval;
+
+	if (pc->config_base) {
+		/* Disable ECAP clock gating at PWM-subsystem common config */
+		pm_runtime_get_sync(&pdev->dev);
+		regval = readw(pc->config_base + PWMSS_CLKCONFIG);
+		regval &= ~PWMSS_ECAP_CLK_EN;
+		writew(regval, pc->config_base + PWMSS_CLKCONFIG);
+		pm_runtime_put_sync(&pdev->dev);
+	}
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -247,6 +349,9 @@ static int __devexit ecap_pwm_remove(struct platform_device *pdev)
 static struct platform_driver ecap_pwm_driver = {
 	.driver = {
 		.name = "ecap",
+#ifdef CONFIG_OF
+		.of_match_table = of_match_ptr(ecap_of_match),
+#endif
 	},
 	.probe = ecap_pwm_probe,
 	.remove = __devexit_p(ecap_pwm_remove),
diff --git a/include/linux/platform_data/ti-pwmss.h b/include/linux/platform_data/ti-pwmss.h
new file mode 100644
index 0000000..0c19dcb
--- /dev/null
+++ b/include/linux/platform_data/ti-pwmss.h
@@ -0,0 +1,23 @@
+/*
+ * TI PWM subsystem
+ *
+ * Copyright (C) {2012} Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _TI_PWMSS_H
+#define _TI_PWMSS_H
+
+struct pwmss_platform_data {
+	bool has_configspace; /* set true for platforms has config space */
+};
+
+#endif
-- 
1.7.0.4

