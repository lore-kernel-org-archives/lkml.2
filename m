Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2KHH6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:58:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34860 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab2KHH6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:58:41 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 06/10] pwm: pwm-tiehrpwm: Add device-tree binding support for EHRPWM driver
Date: Thu, 8 Nov 2012 13:23:13 +0530
Message-ID: <1352361197-27442-7-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch
1. Add support for device-tree binding for EHRWPM driver.
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

:000000 100644 0000000... aa2ed0a... A	Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
:100644 100644 d3c1dff... fba7f9b... M	drivers/pwm/pwm-tiehrpwm.c
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   25 ++++++++++
 drivers/pwm/pwm-tiehrpwm.c                         |   49 +++++++++++++++++++-
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
new file mode 100644
index 0000000..aa2ed0a
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
@@ -0,0 +1,25 @@
+TI SOC EHRPWM based PWM controller
+
+Required properties:
+- compatible : Must be "ti,am33xx-ehrpwm"
+- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
+  First cell specifies the per-chip index of the PWM to use, the second
+  cell is the period cycle in nanoseconds and bit 0 in the third cell is
+  used to encode the polarity of PWM output.
+- reg: physical base address and size of the registers map.
+
+Optional properties:
+- ti,hwmods: Name of the hwmod associated to the EHRPWM:
+  "ehrpwm<x>", <x> being the 0-based instance number from the HW spec
+- tbclkgating: platforms require tbclk gating from control module
+  should populate
+
+Example:
+
+ehrpwm0: ehrpwm@0 {
+	compatible = "ti,am33xx-ehrpwm";
+	#pwm-cells = <3>;
+	reg = <0x48300200 0x100>;
+	ti,hwmods = "ehrpwm0";
+	tbclkgating;
+};
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index d3c1dff..fba7f9b 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -25,6 +25,9 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
+#include <linux/of_device.h>
+
+#include "tipwmss.h"
 
 /* EHRPWM registers and bits definitions */
 
@@ -107,6 +110,13 @@
 #define AQCSFRC_CSFA_FRCHIGH	BIT(1)
 #define AQCSFRC_CSFA_DISSWFRC	(BIT(1) | BIT(0))
 
+#define EPWMCLK_EN			BIT(8)
+#define EPWMCLK_STOP_REQ	BIT(9)
+
+#define EPWMCLK_EN_ACK		BIT(8)
+
+#define PWM_CELL_SIZE		3
+
 #define NUM_PWM_CHANNEL		2	/* EHRPWM channels */
 
 struct ehrpwm_pwm_chip {
@@ -392,6 +402,16 @@ static const struct pwm_ops ehrpwm_pwm_ops = {
 	.owner		= THIS_MODULE,
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id ehrpwm_of_match[] = {
+	{
+		.compatible	= "ti,am33xx-ehrpwm",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ehrpwm_of_match);
+#endif
+
 static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -419,6 +439,7 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ehrpwm_pwm_ops;
+	pc->chip.of_pwm_n_cells = PWM_CELL_SIZE;
 	pc->chip.base = -1;
 	pc->chip.npwm = NUM_PWM_CHANNEL;
 
@@ -437,16 +458,38 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
 		return ret;
 	}
-
 	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+	if (!(pwmss_submodule_state_change(pdev->dev.parent, EPWMCLK_EN) &
+				EPWMCLK_EN_ACK)) {
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
 
 static int __devexit ehrpwm_pwm_remove(struct platform_device *pdev)
 {
 	struct ehrpwm_pwm_chip *pc = platform_get_drvdata(pdev);
 
+	pm_runtime_get_sync(&pdev->dev);
+	/*
+	 * Due to hardware misbehaviour, acknowledge of the stop_req
+	 * is missing. Hence checking of the status bit skipped.
+	 */
+	pwmss_submodule_state_change(pdev->dev.parent, EPWMCLK_STOP_REQ);
+	pm_runtime_put_sync(&pdev->dev);
+
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return pwmchip_remove(&pc->chip);
@@ -454,7 +497,9 @@ static int __devexit ehrpwm_pwm_remove(struct platform_device *pdev)
 
 static struct platform_driver ehrpwm_pwm_driver = {
 	.driver = {
-		.name = "ehrpwm",
+		.name	= "ehrpwm",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ehrpwm_of_match),
 	},
 	.probe = ehrpwm_pwm_probe,
 	.remove = __devexit_p(ehrpwm_pwm_remove),
-- 
1.7.0.4

