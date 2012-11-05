Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab2KEJaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:30:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46280 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab2KEJ35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:29:57 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH 4/8] pwm: pwm-tiecap: Add device-tree binding support for APWM driver
Date: Mon, 5 Nov 2012 14:42:25 +0530
Message-ID: <1352106749-9437-5-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
References: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for device-tree binding for ECAP APWM driver.
Also size of #pwm-cells set to 3 to support PWM channel number, PWM
period & polarity configuration from device tree.
Also enable clock gating in PWM subsystem common config space.
Also when here set .owner member in platform_driver structure to
THIS_MODULE.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
---
Second version
	- Combined with HWMOD changes & DT bindings.
	- Remove the custom of_xlate support.

:000000 100644 0000000... fe24cac... A	Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
:100644 100644 d6d4cf0... 7ea5bea2.. M	drivers/pwm/pwm-tiecap.c
 .../devicetree/bindings/pwm/pwm-tiecap.txt         |   22 ++++++++++++
 drivers/pwm/pwm-tiecap.c                           |   36 +++++++++++++++++++-
 2 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
new file mode 100644
index 0000000..fe24cac
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
@@ -0,0 +1,22 @@
+TI SOC ECAP based APWM controller
+
+Required properties:
+- compatible: Must be "ti,am33xx-ecap"
+- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
+  First cell specifies the per-chip index of the PWM to use, the second
+  cell is the period cycle in nanoseconds and bit 0 in the third cell is
+  used to encode the polarity of PWM output.
+- reg: physical base address and size of the registers map.
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
+	reg = <0x48300100 0x80>;
+	ti,hwmods = "ecap0";
+};
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index d6d4cf0..7ea5bea 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -25,6 +25,10 @@
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
 #include <linux/pwm.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
+
+#include "tipwmss.h"
 
 /* ECAP registers and bits definitions */
 #define CAP1			0x08
@@ -37,6 +41,10 @@
 #define ECCTL2_SYNC_SEL_DISA	(BIT(7) | BIT(6))
 #define ECCTL2_TSCTR_FREERUN	BIT(4)
 
+#define ECAPCLK_EN_SHIFT	0
+
+#define PWM_CELL_SIZE		3
+
 struct ecap_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
@@ -184,12 +192,27 @@ static const struct pwm_ops ecap_pwm_ops = {
 	.owner		= THIS_MODULE,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id ecap_of_match[] = {
+	{
+		.compatible	= "ti,am33xx-ecap",
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
+	struct pinctrl *pinctrl;
+
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&pdev->dev, "failed to configure pins from driver\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
@@ -211,6 +234,7 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ecap_pwm_ops;
+	pc->chip.of_pwm_n_cells = PWM_CELL_SIZE;
 	pc->chip.base = -1;
 	pc->chip.npwm = 1;
 
@@ -231,6 +255,10 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+	pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_EN_SHIFT, true);
+	pm_runtime_put_sync(&pdev->dev);
+
 	platform_set_drvdata(pdev, pc);
 	return 0;
 }
@@ -239,6 +267,10 @@ static int __devexit ecap_pwm_remove(struct platform_device *pdev)
 {
 	struct ecap_pwm_chip *pc = platform_get_drvdata(pdev);
 
+	pm_runtime_get_sync(&pdev->dev);
+	pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_EN_SHIFT, false);
+	pm_runtime_put_sync(&pdev->dev);
+
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return pwmchip_remove(&pc->chip);
@@ -246,7 +278,9 @@ static int __devexit ecap_pwm_remove(struct platform_device *pdev)
 
 static struct platform_driver ecap_pwm_driver = {
 	.driver = {
-		.name = "ecap",
+		.name	= "ecap",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ecap_of_match),
 	},
 	.probe = ecap_pwm_probe,
 	.remove = __devexit_p(ecap_pwm_remove),
-- 
1.7.0.4

