Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab2K0IvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:51:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45410 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758487Ab2K0IvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:51:09 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v5 08/12] pwm: tiehrpwm: Add device-tree binding
Date: Tue, 27 Nov 2012 14:18:13 +0530
Message-ID: <1354006097-25895-9-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1354006097-25895-1-git-send-email-avinashphilip@ti.com>
References: <1354006097-25895-1-git-send-email-avinashphilip@ti.com>
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
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
---
Changes since v4:
        - Made dt match property in single line for consistency
	- Corrected commit subject for consistency.

Changes since v3:
	- Replace pwmss.h with pwm-tipwmss.h

Changes since v2:
	- Add of_pwm_xlate_with_flags function support

Changes since v1:
	- Add separate patch for pinctrl support
	- Add conditional check for PWM subsystem clock enable.
	- Combined with HWMOD changes & DT bindings.
	- Remove the custom of_xlate support.

 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   23 +++++++++++
 drivers/pwm/pwm-tiehrpwm.c                         |   42 +++++++++++++++++++-
 2 files changed, 64 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt

diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
new file mode 100644
index 0000000..4fc7079
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
@@ -0,0 +1,23 @@
+TI SOC EHRPWM based PWM controller
+
+Required properties:
+- compatible : Must be "ti,am33xx-ehrpwm"
+- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
+  First cell specifies the per-chip index of the PWM to use, the second
+  cell is the period in nanoseconds and bit 0 in the third cell is used to
+  encode the polarity of PWM output. Set bit 0 of the third in PWM specifier
+  to 1 for inverse polarity & set to 0 for normal polarity.
+- reg: physical base address and size of the registers map.
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
+	reg = <0x48300200 0x100>;
+	ti,hwmods = "ehrpwm0";
+};
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 56a1325..d3194c0 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -25,6 +25,9 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
+#include <linux/of_device.h>
+
+#include "pwm-tipwmss.h"
 
 /* EHRPWM registers and bits definitions */
 
@@ -399,12 +402,19 @@ static const struct pwm_ops ehrpwm_pwm_ops = {
 	.owner		= THIS_MODULE,
 };
 
+static const struct of_device_id ehrpwm_of_match[] = {
+	{ .compatible	= "ti,am33xx-ehrpwm" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ehrpwm_of_match);
+
 static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct resource *r;
 	struct clk *clk;
 	struct ehrpwm_pwm_chip *pc;
+	u16 status;
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
@@ -426,6 +436,8 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &ehrpwm_pwm_ops;
+	pc->chip.of_xlate = of_pwm_xlate_with_flags;
+	pc->chip.of_pwm_n_cells = 3;
 	pc->chip.base = -1;
 	pc->chip.npwm = NUM_PWM_CHANNEL;
 
@@ -454,14 +466,40 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
+	status = pwmss_submodule_state_change(pdev->dev.parent,
+			PWMSS_EPWMCLK_EN);
+	if (!(status & PWMSS_EPWMCLK_EN_ACK)) {
+		dev_err(&pdev->dev, "PWMSS config space clock enable failed\n");
+		ret = -EINVAL;
+		goto pwmss_clk_failure;
+	}
+
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
+	pwmss_submodule_state_change(pdev->dev.parent, PWMSS_EPWMCLK_STOP_REQ);
+	pm_runtime_put_sync(&pdev->dev);
+
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return pwmchip_remove(&pc->chip);
@@ -469,7 +507,9 @@ static int __devexit ehrpwm_pwm_remove(struct platform_device *pdev)
 
 static struct platform_driver ehrpwm_pwm_driver = {
 	.driver = {
-		.name = "ehrpwm",
+		.name	= "ehrpwm",
+		.owner	= THIS_MODULE,
+		.of_match_table = ehrpwm_of_match,
 	},
 	.probe = ehrpwm_pwm_probe,
 	.remove = __devexit_p(ehrpwm_pwm_remove),
-- 
1.7.0.4

