Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2CGKa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:30:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13355 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2CGKa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:30:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 07 Mar 2012 02:30:57 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewanagn@nvidia.com, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] regulator: fixed: Support for open drain gpio pin
Date: Wed,  7 Mar 2012 15:58:33 +0530
Message-Id: <1331116113-22565-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding flag on fixed regulator board configuration structure
to specify whether gpio is open drain type or not.
Passing this information to gpio library when requesting
gpio so that gpio driver can set the pin state accordingly,
for open drain type:
- Pin can be set HIGH as setting as input, PULL UP on
  pin make this as HIGH.
- Pin can be set LOW as setting it as output and drive to LOW.

The non-open drain pin can be  set HIGH/LOW by setting it to
output and driving it to HIGH/LOW.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This is the continuation of effort on supporting open drain gpio
which was discussed in patch V1.
[PATCH V1] regulator: fixed: Support for open-drain gpio
The changes from V1:
The open drain support is added in gpo library and hence in place
of handling open drain condition in the fixed regulator, passing
appropriate flag to gpio driver library to handle this condition
in gpio driver.

 drivers/regulator/fixed.c       |   24 +++++++++++-------------
 include/linux/regulator/fixed.h |    7 +++++++
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 40f3803..13a3d2c 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -201,6 +201,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->startup_delay = config->startup_delay;
 
 	if (gpio_is_valid(config->gpio)) {
+		int gpio_flag;
 		drvdata->enable_high = config->enable_high;
 
 		/* FIXME: Remove below print warning
@@ -218,29 +219,26 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 			dev_warn(&pdev->dev,
 				"using GPIO 0 for regulator enable control\n");
 
-		ret = gpio_request(config->gpio, config->supply_name);
-		if (ret) {
-			dev_err(&pdev->dev,
-			   "Could not obtain regulator enable GPIO %d: %d\n",
-							config->gpio, ret);
-			goto err_name;
-		}
-
-		/* set output direction without changing state
+		/*
+		 * set output direction without changing state
 		 * to prevent glitch
 		 */
 		drvdata->is_enabled = config->enabled_at_boot;
 		ret = drvdata->is_enabled ?
 				config->enable_high : !config->enable_high;
+		gpio_flag = ret ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+
+		if (config->gpio_is_open_drain)
+			gpio_flag |= GPIOF_OPEN_DRAIN;
 
-		ret = gpio_direction_output(config->gpio, ret);
+		ret = gpio_request_one(config->gpio, gpio_flag,
+						config->supply_name);
 		if (ret) {
 			dev_err(&pdev->dev,
-			   "Could not configure regulator enable GPIO %d direction: %d\n",
+			   "Could not obtain regulator enable GPIO %d: %d\n",
 							config->gpio, ret);
-			goto err_gpio;
+			goto err_name;
 		}
-
 	} else {
 		/* Regulator without GPIO control is considered
 		 * always enabled
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index 936a7d8..f83f744 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -26,6 +26,12 @@ struct regulator_init_data;
  * @gpio:		GPIO to use for enable control
  * 			set to -EINVAL if not used
  * @startup_delay:	Start-up time in microseconds
+ * @gpio_is_open_drain: Gpio pin is open drain or normal type.
+ *			If it is open drain type then HIGH will be set
+ *			through PULL-UP with setting gpio as input
+ *			and low will be set as gpio-output with driven
+ *			to low. For non-open-drain case, the gpio will
+ *			will be in output and drive to low/high accordingly.
  * @enable_high:	Polarity of enable GPIO
  *			1 = Active high, 0 = Active low
  * @enabled_at_boot:	Whether regulator has been enabled at
@@ -43,6 +49,7 @@ struct fixed_voltage_config {
 	int microvolts;
 	int gpio;
 	unsigned startup_delay;
+	unsigned gpio_is_open_drain:1;
 	unsigned enable_high:1;
 	unsigned enabled_at_boot:1;
 	struct regulator_init_data *init_data;
-- 
1.7.1.1

