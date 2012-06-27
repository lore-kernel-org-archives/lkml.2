Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2F0OMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:12:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34617 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756847Ab2F0OML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:12:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/5] regulator: core: Add core support for GPIO controlled enable lines
Date: Wed, 27 Jun 2012 15:12:03 +0100
Message-Id: <1340806326-30525-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is very common for regulators to support having their enable signal
controlled by a GPIO. Since there are a bunch of fiddly things to get
right like handling the operations when the enable signal is tied to
a rail and it's just replicated code add support for this to the core.

Drivers should set ena_gpio in their config if they have a GPIO control,
using ena_gpio_flags to specify any flags (including GPIOF_OUT_INIT_ for
the initial state) and ena_gpio_invert if the GPIO is active low. The
core will then override any enable and disable operations the driver has
and instead control the specified GPIO.

This will in the future also allow us to further extend the core by
identifying when several enable signals have been tied together and
handling this properly.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c         |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/regulator/driver.h |   11 +++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 60329fe..2a3d438 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/suspend.h>
 #include <linux/delay.h>
+#include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/regmap.h>
 #include <linux/regulator/of_regulator.h>
@@ -1450,7 +1451,11 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 
 	trace_regulator_enable(rdev_get_name(rdev));
 
-	if (rdev->desc->ops->enable) {
+	if (rdev->ena_gpio) {
+		gpio_set_value_cansleep(rdev->ena_gpio,
+					!rdev->ena_gpio_invert);
+		rdev->ena_gpio_state = 1;
+	} else if (rdev->desc->ops->enable) {
 		ret = rdev->desc->ops->enable(rdev);
 		if (ret < 0)
 			return ret;
@@ -1805,6 +1810,10 @@ EXPORT_SYMBOL_GPL(regulator_disable_regmap);
 
 static int _regulator_is_enabled(struct regulator_dev *rdev)
 {
+	/* A GPIO control always takes precedence */
+	if (rdev->ena_gpio)
+		return rdev->ena_gpio_state;
+
 	/* If we don't know then assume that the regulator is always on */
 	if (!rdev->desc->ops->is_enabled)
 		return 1;
@@ -3218,6 +3227,26 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
+	if (config->ena_gpio) {
+		ret = gpio_request_one(config->ena_gpio,
+				       GPIOF_DIR_OUT | config->ena_gpio_flags,
+				       rdev_get_name(rdev));
+		if (ret != 0) {
+			rdev_err(rdev, "Failed to request enable GPIO: %d\n",
+				 ret);
+			goto clean;
+		}
+
+		rdev->ena_gpio = config->ena_gpio;
+		rdev->ena_gpio_invert = config->ena_gpio_invert;
+
+		if (config->ena_gpio_flags & GPIOF_OUT_INIT_HIGH)
+			rdev->ena_gpio_state = 1;
+
+		if (rdev->ena_gpio_invert)
+			rdev->ena_gpio_state = !rdev->ena_gpio_state;
+	}
+
 	/* set regulator constraints */
 	if (init_data)
 		constraints = &init_data->constraints;
@@ -3286,6 +3315,8 @@ unset_supplies:
 scrub:
 	if (rdev->supply)
 		regulator_put(rdev->supply);
+	if (rdev->ena_gpio)
+		gpio_free(rdev->ena_gpio);
 	kfree(rdev->constraints);
 	device_unregister(&rdev->dev);
 	/* device core frees rdev */
@@ -3319,6 +3350,8 @@ void regulator_unregister(struct regulator_dev *rdev)
 	unset_regulator_supplies(rdev);
 	list_del(&rdev->list);
 	kfree(rdev->constraints);
+	if (rdev->ena_gpio)
+		gpio_free(rdev->ena_gpio);
 	device_unregister(&rdev->dev);
 	mutex_unlock(&regulator_list_mutex);
 }
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 176bd43..b1b7b8b 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -220,6 +220,9 @@ struct regulator_desc {
  * @of_node: OpenFirmware node to parse for device tree bindings (may be
  *           NULL).
  * @regmap: regmap to use for core regmap helpers
+ * @ena_gpio: GPIO controlling regulator enable.
+ * @ena_gpio_invert: Sense for GPIO enable control.
+ * @ena_gpio_flags: Flags to use when calling gpio_request_one()
  */
 struct regulator_config {
 	struct device *dev;
@@ -227,6 +230,10 @@ struct regulator_config {
 	void *driver_data;
 	struct device_node *of_node;
 	struct regmap *regmap;
+
+	int ena_gpio;
+	unsigned int ena_gpio_invert:1;
+	unsigned int ena_gpio_flags;
 };
 
 /*
@@ -265,6 +272,10 @@ struct regulator_dev {
 	void *reg_data;		/* regulator_dev data */
 
 	struct dentry *debugfs;
+
+	int ena_gpio;
+	unsigned int ena_gpio_invert:1;
+	unsigned int ena_gpio_state:1;
 };
 
 struct regulator_dev *
-- 
1.7.10

