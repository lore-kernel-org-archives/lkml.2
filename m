Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2IZLrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:47:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53236 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab2IZLri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:47:38 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 2/2] pwm: pwm-tiehrpwm: Add device-tree binding support for EHRPWM driver
Date: Wed, 26 Sep 2012 16:57:43 +0530
Message-ID: <1348658863-29428-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for device-tree binding and of_xlate for EHRWPM driver.
of_xlate provides EHRPWM polarity configuration from client driver
device-tree.
Also size of pwm-cells set to 3 to support pwm channel number, pwm
period & polarity configuration from device tree.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:000000 100644 0000000... 05d9d63... A	Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
:100644 100644 caf00fe... ae23c2b... M	drivers/pwm/pwm-tiehrpwm.c
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   26 +++++
 drivers/pwm/pwm-tiehrpwm.c                         |  107 ++++++++++++++++++++
 2 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
new file mode 100644
index 0000000..05d9d63
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
@@ -0,0 +1,26 @@
+TI SOC EHRPWM based PWM controller
+
+Required properties:
+- compatible : Must be "ti,am33xx-ehrpwm"
+- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
+  First cell specifies the per-chip index of the PWM to use, the second
+  cell is the period cycle in nanoseconds and the third cell is the
+  polarity of PWM output. Polarity 0 gives normal polarity and 1 gives
+  inversed polarity (inverse duty cycle)
+- reg: physical base address and size of the registers map. For am33xx,
+  2 register maps are present (EHRPWM register space & PWM subsystem common
+  config space). Order should be maintained with EHRPWM register map as first
+  entry & PWM subsystem common config space as second entry.
+
+Optional properties:
+- ti,hwmods: Name of the hwmod associated to the EHRPWM:
+  "ehrpwm<x>", <x> being the 0-based instance number from the HW spec
+
+Example:
+
+ehrpwm0: ehrpwm@0 {
+	compatible = "ti,am33xx-ehrpwm";
+	#pwm-cells = <3>;
+	reg = <0x48300200 0x100 0x48300000 0x10>;
+	ti,hwmods = "ehrpwm0";
+};
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index caf00fe..ae23c2b 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -25,6 +25,9 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
+#include <linux/of_device.h>
+#include <linux/platform_data/ti-pwmss.h>
+#include <linux/pinctrl/consumer.h>
 
 /* EHRPWM registers and bits definitions */
 
@@ -107,12 +110,18 @@
 #define AQCSFRC_CSFA_FRCHIGH	BIT(1)
 #define AQCSFRC_CSFA_DISSWFRC	(BIT(1) | BIT(0))
 
+#define PWMSS_CLKCONFIG		0x8
+#define PWMSS_EHRPWM_CLK_EN	BIT(8)
+
+#define PWM_CELL_SIZE		3
+
 #define NUM_PWM_CHANNEL		2	/* EHRPWM channels */
 
 struct ehrpwm_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
 	void __iomem	*mmio_base;
+	void __iomem	*config_base;
 	unsigned long period_cycles[NUM_PWM_CHANNEL];
 	enum pwm_polarity polarity[NUM_PWM_CHANNEL];
 };
@@ -392,12 +401,60 @@ static const struct pwm_ops ehrpwm_pwm_ops = {
 	.owner		= THIS_MODULE,
 };
 
+static struct pwm_device *of_ehrpwm_xlate(struct pwm_chip *chip,
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
+static const struct of_device_id ehrpwm_of_match[] = {
+	{
+		.compatible	= "ti,am33xx-ehrpwm",
+		.data		= &am33xx_data,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ehrpwm_of_match);
+#endif
+
 static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct resource *r;
 	struct clk *clk;
 	struct ehrpwm_pwm_chip *pc;
+	struct pwmss_platform_data *pdata = pdev->dev.platform_data;
+	const struct of_device_id *match;
+	u16 regval;
+	struct pinctrl *pinctrl;
+
+	match = of_match_device(of_match_ptr(ehrpwm_of_match), &pdev->dev);
+
+	if (match)
+		pdata = (struct pwmss_platform_data *)match->data;
+
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&pdev->dev, "failed to configure pins from driver\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
@@ -419,6 +476,8 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ehrpwm_pwm_ops;
+	pc->chip.of_xlate = of_ehrpwm_xlate;
+	pc->chip.of_pwm_n_cells = PWM_CELL_SIZE;
 	pc->chip.base = -1;
 	pc->chip.npwm = NUM_PWM_CHANNEL;
 
@@ -439,13 +498,58 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(&pdev->dev);
+
+	/*
+	 * Few platform has extra PWM-subsystem common config space
+	 * and requires special handling of clock gating.
+	 */
+
+	if (pdata && pdata->has_configspace) {
+
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
+		/* Enable EHRPWM clock gating at PWM-subsystem common config */
+		pm_runtime_get_sync(&pdev->dev);
+		regval = readw(pc->config_base + PWMSS_CLKCONFIG);
+		regval |= PWMSS_EHRPWM_CLK_EN;
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
 
 static int __devexit ehrpwm_pwm_remove(struct platform_device *pdev)
 {
 	struct ehrpwm_pwm_chip *pc = platform_get_drvdata(pdev);
+	u16 regval;
+
+	if (pc->config_base) {
+		/* Disable EHRPWM clock gating at PWM-subsystem common config */
+		pm_runtime_get_sync(&pdev->dev);
+		regval = readw(pc->config_base + PWMSS_CLKCONFIG);
+		regval &= ~PWMSS_EHRPWM_CLK_EN;
+		writew(regval, pc->config_base + PWMSS_CLKCONFIG);
+		pm_runtime_put_sync(&pdev->dev);
+	}
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -455,6 +559,9 @@ static int __devexit ehrpwm_pwm_remove(struct platform_device *pdev)
 static struct platform_driver ehrpwm_pwm_driver = {
 	.driver = {
 		.name = "ehrpwm",
+#ifdef CONFIG_OF
+		.of_match_table = of_match_ptr(ehrpwm_of_match),
+#endif
 	},
 	.probe = ehrpwm_pwm_probe,
 	.remove = __devexit_p(ehrpwm_pwm_remove),
-- 
1.7.0.4

