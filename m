Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2BMGcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 01:32:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9575 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2BMGcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 01:32:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 12 Feb 2012 22:32:03 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        dunlap@xenotime.net, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 3/3] regulator: fixed: Support for open-drain gpio
Date: Mon, 13 Feb 2012 11:59:48 +0530
Message-Id: <1329114588-15430-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of regulator switches like bidirectional load switches
connected through the open drain gpios. As open drain gpios
should not be driven to output with value of 1, it needs to
handle differently to set the pin state to HIGH.
Adding the flag to find out if gpio is open drain and pass
this information to gpio library for handling open-drain gpio
configuration accordingly.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/fixed.c       |   29 +++++++++++++----------------
 include/linux/regulator/fixed.h |    7 +++++++
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index e24e3a1..d6c8d66 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -199,7 +199,9 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->startup_delay = config->startup_delay;
 
 	if (gpio_is_valid(config->gpio)) {
+		int gpio_flag;
 		drvdata->enable_high = config->enable_high;
+		drvdata->is_enabled = config->enabled_at_boot;
 
 		/* FIXME: Remove below print warning
 		 *
@@ -216,29 +218,24 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
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
-		drvdata->is_enabled = config->enabled_at_boot;
-		ret = drvdata->is_enabled ?
-				config->enable_high : !config->enable_high;
+		gpio_flag = drvdata->is_enabled ?
+				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+
+		if (config->gpio_is_open_drain)
+			gpio_flag |= GPIOF_OD;
 
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
index ffd7d50..350edb5 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -26,6 +26,12 @@ struct regulator_init_data;
  * @gpio:		GPIO to use for enable control
  * 			set to -EINVAL if not used
  * @startup_delay:	Start-up time in microseconds
+ * @gpio_is_open_drain: Gpio pin is open drain or normal type.
+ *			If it is open drain then HIGH will be set
+ *			through PULL-UP and gpio will be set as input
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

