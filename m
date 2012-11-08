Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab2KHH6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:58:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40192 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab2KHH6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:58:16 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 04/10] pwm: pwm-tiecap: Add device-tree binding support for APWM driver
Date: Thu, 8 Nov 2012 13:23:11 +0530
Message-ID: <1352361197-27442-5-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch
1. Add support for device-tree binding for ECAP APWM driver.
2. Set size of pwm-cells set to 3 to support PWM channel number, PWM
   period & polarity configuration from device tree.
3. Add enable/disable clock gating in PWM subsystem common config space.
4. When here set .owner member in platform_driver structure to
   THIS_MODULE.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
Cc:	Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
---
Changes since v1:
	- Add separate patch for pinctrl support
	- Add conditional check for PWM subsystem clock enable.
	- Combined with HWMOD changes & DT bindings.
	- Remove the custom of xlate support.

:000000 100644 0000000... fe24cac... A	Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
:100644 100644 d6d4cf0... 0d43266... M	drivers/pwm/pwm-tiecap.c
 .../devicetree/bindings/pwm/pwm-tiecap.txt         |   22 +++++++++
 drivers/pwm/pwm-tiecap.c                           |   48 +++++++++++++++++++-
 2 files changed, 69 insertions(+), 1 deletions(-)

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
index d6d4cf0..0d43266 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -25,6 +25,9 @@
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
 #include <linux/pwm.h>
+#include <linux/of_device.h>
+
+#include "tipwmss.h"
 
 /* ECAP registers and bits definitions */
 #define CAP1			0x08
@@ -37,6 +40,13 @@
 #define ECCTL2_SYNC_SEL_DISA	(BIT(7) | BIT(6))
 #define ECCTL2_TSCTR_FREERUN	BIT(4)
 
+#define ECAPCLK_EN			BIT(0)
+#define ECAPCLK_STOP_REQ	BIT(1)
+
+#define ECAPCLK_EN_ACK		BIT(0)
+
+#define PWM_CELL_SIZE		3
+
 struct ecap_pwm_chip {
 	struct pwm_chip	chip;
 	unsigned int	clk_rate;
@@ -184,6 +194,16 @@ static const struct pwm_ops ecap_pwm_ops = {
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
@@ -211,6 +231,7 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ecap_pwm_ops;
+	pc->chip.of_pwm_n_cells = PWM_CELL_SIZE;
 	pc->chip.base = -1;
 	pc->chip.npwm = 1;
 
@@ -231,14 +252,37 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+	if (!(pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_EN) &
+				ECAPCLK_EN_ACK)) {
+		dev_err(&pdev->dev, "PWMSS config space clock enable failure\n");
+		ret = -EINVAL;
+		goto pwmss_clk_failure;
+	}
+	pm_runtime_put_sync(&pdev->dev);
+
 	platform_set_drvdata(pdev, pc);
 	return 0;
+
+pwmss_clk_failure:
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	pwmchip_remove(&pc->chip);
+	return ret;
 }
 
 static int __devexit ecap_pwm_remove(struct platform_device *pdev)
 {
 	struct ecap_pwm_chip *pc = platform_get_drvdata(pdev);
 
+	pm_runtime_get_sync(&pdev->dev);
+	/*
+	 * Due to hardware misbehaviour, acknowledge of the stop_req
+	 * is missing. Hence checking of the status bit skipped.
+	 */
+	pwmss_submodule_state_change(pdev->dev.parent, ECAPCLK_STOP_REQ);
+	pm_runtime_put_sync(&pdev->dev);
+
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return pwmchip_remove(&pc->chip);
@@ -246,7 +290,9 @@ static int __devexit ecap_pwm_remove(struct platform_device *pdev)
 
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

