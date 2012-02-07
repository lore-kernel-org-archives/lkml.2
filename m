Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2BGKsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:48:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12166 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2BGKsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:48:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 07 Feb 2012 02:48:09 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V1] regulator: fixed: Support for open-drain gpio
Date: Tue,  7 Feb 2012 16:16:36 +0530
Message-Id: <1328611596-13279-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The open drain pins act as bidirectional and it should
not be driven to high as it can cause power to ground
shorting in some cases. And hence gpio which is controlling
this pin should not drive output to high.
To make the pin to high/low for enabling/disabling the switches,
the pins will have the pull-up connected and the high/low can be
set using following methods:
LOW: gpio_direction_output(gpio, 0) ... this drives the signal
	and overrides the pullup.
HIGH: gpio_direction_input(gpio) ... this turns off the output,
	so the pullup (or some other device) controls the signal.

Implementing a mechanism to properly handle the open-drain gpio
to control the regulator switches.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
-Adding the flag in platform data to tell whether gpio is
 open-drain or not.
- Based on flag, setting the pins state. If it is non-open-drain
  then driver output to high/low. if it is open drain then only
  driver low or set to input for making the pin to high through
  pullups.


 drivers/regulator/fixed.c       |   42 ++++++++++++++++++++++++++++++++++++--
 include/linux/regulator/fixed.h |    7 ++++++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index e24e3a1..d47d684 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -40,6 +40,7 @@ struct fixed_voltage_data {
 	unsigned startup_delay;
 	bool enable_high;
 	bool is_enabled;
+	bool gpio_is_open_drain;
 };
 
 
@@ -94,6 +95,20 @@ of_get_fixed_voltage_config(struct device *dev)
 	return config;
 }
 
+static int set_open_drain_gpio(struct device *dev, int gpio, bool is_high)
+{
+	int ret;
+	if (is_high)
+		ret = gpio_direction_input(gpio);
+	else
+		ret = gpio_direction_output(gpio, 0);
+	if (ret < 0)
+		dev_err(dev,
+		    "Could not configure open drain GPIO %d direction: %d\n",
+				gpio, ret);
+	return ret;
+}
+
 static int fixed_voltage_is_enabled(struct regulator_dev *dev)
 {
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
@@ -106,7 +121,15 @@ static int fixed_voltage_enable(struct regulator_dev *dev)
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
 
 	if (gpio_is_valid(data->gpio)) {
-		gpio_set_value_cansleep(data->gpio, data->enable_high);
+		if (data->gpio_is_open_drain) {
+			struct device *parent_dev = rdev_get_dev(dev);
+			int ret;
+			ret = set_open_drain_gpio(parent_dev, data->gpio,
+					data->enable_high);
+			if (ret < 0)
+				return ret;
+		} else
+			gpio_set_value_cansleep(data->gpio, data->enable_high);
 		data->is_enabled = true;
 	}
 
@@ -118,7 +141,15 @@ static int fixed_voltage_disable(struct regulator_dev *dev)
 	struct fixed_voltage_data *data = rdev_get_drvdata(dev);
 
 	if (gpio_is_valid(data->gpio)) {
-		gpio_set_value_cansleep(data->gpio, !data->enable_high);
+		if (data->gpio_is_open_drain) {
+			struct device *parent_dev = rdev_get_dev(dev);
+			int ret;
+			ret = set_open_drain_gpio(parent_dev, data->gpio,
+					!data->enable_high);
+			if (ret < 0)
+				return ret;
+		} else
+			gpio_set_value_cansleep(data->gpio, !data->enable_high);
 		data->is_enabled = false;
 	}
 
@@ -200,6 +231,7 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	if (gpio_is_valid(config->gpio)) {
 		drvdata->enable_high = config->enable_high;
+		drvdata->gpio_is_open_drain = config->gpio_is_open_drain;
 
 		/* FIXME: Remove below print warning
 		 *
@@ -231,7 +263,11 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 		ret = drvdata->is_enabled ?
 				config->enable_high : !config->enable_high;
 
-		ret = gpio_direction_output(config->gpio, ret);
+		if (drvdata->gpio_is_open_drain)
+			ret = set_open_drain_gpio(&pdev->dev, config->gpio,
+							ret);
+		else
+			ret = gpio_direction_output(config->gpio, ret);
 		if (ret) {
 			dev_err(&pdev->dev,
 			   "Could not configure regulator enable GPIO %d direction: %d\n",
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index ffd7d50..9dcd135 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -26,6 +26,12 @@ struct regulator_init_data;
  * @gpio:		GPIO to use for enable control
  * 			set to -EINVAL if not used
  * @startup_delay:	Start-up time in microseconds
+ * @gpio_is_open_drain: Gpio is normal or open-drain.
+ *			if it is open drain then HIGH will be set
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

