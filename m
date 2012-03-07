Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2CGIDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:03:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:61793 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab2CGIDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:03:04 -0500
X-AuditID: cbfee61b-b7c62ae000000989-de-4f571634ca7d
Message-id: <4F57162C.2050209@samsung.com>
Date: Wed, 07 Mar 2012 17:02:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: [PATCH v2 2/2] input: add driver support for MAX8997-haptic
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX8997-haptic function can be used to control motor.
User can control the haptic driver by using force feedback framework.
This patch supports the haptic function in MAX8997.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2
- code clean and remove unnecessary code according to comment of Dmitry
Torokhov

 drivers/input/misc/Kconfig          |   12 ++
 drivers/input/misc/Makefile         |    1 +
 drivers/input/misc/max8997_haptic.c |  371
+++++++++++++++++++++++++++++++++++
 3 files changed, 384 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/max8997_haptic.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7b46781..c828c2e 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -134,6 +134,18 @@ config INPUT_MAX8925_ONKEY
 	  To compile this driver as a module, choose M here: the module
 	  will be called max8925_onkey.

+config INPUT_MAX8997_HAPTIC
+	tristate "MAXIM MAX8997 haptic controller support"
+	depends on HAVE_PWM && MFD_MAX8997
+	select INPUT_FF_MEMLESS
+	help
+	  This option enables device driver support for the haptic controller
+	  on MAXIM MAX8997 chip. This driver supports ff-memless interface
+	  from input framework.
+
+	  To compile this driver as module, choose M here: the
+	  module will be called max8997-haptic.
+
 config INPUT_MC13783_PWRBUTTON
 	tristate "MC13783 ON buttons"
 	depends on MFD_MC13783
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 46671a8..f0574a6 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
 obj-$(CONFIG_INPUT_KXTJ9)		+= kxtj9.o
 obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
 obj-$(CONFIG_INPUT_MAX8925_ONKEY)	+= max8925_onkey.o
+obj-$(CONFIG_INPUT_MAX8997_HAPTIC)	+= max8997_haptic.o
 obj-$(CONFIG_INPUT_MC13783_PWRBUTTON)	+= mc13783-pwrbutton.o
 obj-$(CONFIG_INPUT_MMA8450)		+= mma8450.o
 obj-$(CONFIG_INPUT_MPU3050)		+= mpu3050.o
diff --git a/drivers/input/misc/max8997_haptic.c
b/drivers/input/misc/max8997_haptic.c
new file mode 100644
index 0000000..ccfab2e
--- /dev/null
+++ b/drivers/input/misc/max8997_haptic.c
@@ -0,0 +1,371 @@
+/*
+ *  MAX8997-haptic controller driver
+ *
+ *  Copyright (C) 2012 Samsung Electronics
+ *  Donggeun Kim <dg77.kim@samsung.com>
+ *
+ * This program is not provided / owned by Maxim Integrated Products.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/pwm.h>
+#include <linux/input.h>
+#include <linux/mfd/max8997-private.h>
+#include <linux/mfd/max8997.h>
+#include <linux/regulator/consumer.h>
+
+/* Haptic configuration 2 register */
+#define MAX8997_MOTOR_TYPE_SHIFT	7
+#define MAX8997_ENABLE_SHIFT		6
+#define MAX8997_MODE_SHIFT		5
+
+/* Haptic driver configuration register */
+#define MAX8997_CYCLE_SHIFT		6
+#define MAX8997_SIG_PERIOD_SHIFT	4
+#define MAX8997_SIG_DUTY_SHIFT		2
+#define MAX8997_PWM_DUTY_SHIFT		0
+
+struct max8997_haptic {
+	struct device *dev;
+	struct i2c_client *client;
+	struct input_dev *input_dev;
+	struct regulator *regulator;
+
+	bool enabled;
+
+	unsigned int level;
+
+	struct pwm_device *pwm;
+	int pwm_period;
+	enum max8997_haptic_pwm_divisor pwm_divisor;
+
+	enum max8997_haptic_motor_type type;
+	enum max8997_haptic_pulse_mode mode;
+
+	int internal_mode_pattern;
+	int pattern_cycle;
+	int pattern_signal_period;
+};
+
+static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
+{
+	int duty, i;
+	int ret;
+	u8 duty_index;
+
+	if (chip->mode == MAX8997_EXTERNAL_MODE) {
+		duty = chip->pwm_period * chip->level / 100;
+		ret = pwm_config(chip->pwm, duty, chip->pwm_period);
+	} else {
+		for (i = 0; i <= 64; i++) {
+			if (chip->level <= i * 100 / 64) {
+				duty_index = i;
+				break;
+			}
+		}
+		switch (chip->internal_mode_pattern) {
+		case 0:
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_SIGPWMDC1, duty_index);
+			break;
+		case 1:
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_SIGPWMDC2, duty_index);
+			break;
+		case 2:
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_SIGPWMDC3, duty_index);
+			break;
+		case 3:
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_SIGPWMDC4, duty_index);
+			break;
+		default:
+			break;
+		}
+	}
+	return ret;
+}
+
+static void max8997_haptic_configure(struct max8997_haptic *chip)
+{
+	u8 value;
+
+	value = chip->type << MAX8997_MOTOR_TYPE_SHIFT |
+		chip->enabled << MAX8997_ENABLE_SHIFT |
+		chip->mode << MAX8997_MODE_SHIFT | chip->pwm_divisor;
+	max8997_write_reg(chip->client, MAX8997_HAPTIC_REG_CONF2, value);
+
+	if (chip->mode == MAX8997_INTERNAL_MODE && chip->enabled) {
+		value = chip->internal_mode_pattern << MAX8997_CYCLE_SHIFT |
+		      chip->internal_mode_pattern << MAX8997_SIG_PERIOD_SHIFT |
+		      chip->internal_mode_pattern << MAX8997_SIG_DUTY_SHIFT |
+		      chip->internal_mode_pattern << MAX8997_PWM_DUTY_SHIFT;
+		max8997_write_reg(chip->client,
+			MAX8997_HAPTIC_REG_DRVCONF, value);
+
+		switch (chip->internal_mode_pattern) {
+		case 0:
+			value = chip->pattern_cycle << 4;
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_CYCLECONF1, value);
+			value = chip->pattern_signal_period;
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_SIGCONF1, value);
+			break;
+		case 1:
+			value = chip->pattern_cycle;
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_CYCLECONF1, value);
+			value = chip->pattern_signal_period;
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_SIGCONF2, value);
+			break;
+		case 2:
+			value = chip->pattern_cycle << 4;
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_CYCLECONF2, value);
+			value = chip->pattern_signal_period;
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_SIGCONF3, value);
+			break;
+		case 3:
+			value = chip->pattern_cycle;
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_CYCLECONF2, value);
+			value = chip->pattern_signal_period;
+			max8997_write_reg(chip->client,
+				MAX8997_HAPTIC_REG_SIGCONF4, value);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void max8997_haptic_enable(struct max8997_haptic *chip, bool enable)
+{
+	if (chip->enabled == enable)
+		return;
+
+	chip->enabled = enable;
+
+	if (enable) {
+		regulator_enable(chip->regulator);
+		max8997_haptic_configure(chip);
+		if (chip->mode == MAX8997_EXTERNAL_MODE)
+			pwm_enable(chip->pwm);
+	} else {
+		max8997_haptic_configure(chip);
+		if (chip->mode == MAX8997_EXTERNAL_MODE)
+			pwm_disable(chip->pwm);
+		regulator_disable(chip->regulator);
+	}
+}
+
+static int max8997_haptic_play_effect(struct input_dev *dev, void *data,
+				  struct ff_effect *effect)
+{
+	struct max8997_haptic *chip = input_get_drvdata(dev);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&chip->input_dev->event_lock, flags);
+
+	chip->level = effect->u.rumble.strong_magnitude;
+	if (!chip->level)
+		chip->level = effect->u.rumble.weak_magnitude;
+
+	if (chip->level) {
+		ret = max8997_haptic_set_duty_cycle(chip);
+		if (ret) {
+			dev_err(chip->dev, "set_pwm_cycle failed\n");
+			return ret;
+		}
+		max8997_haptic_enable(chip, true);
+	} else {
+		max8997_haptic_enable(chip, false);
+	}
+
+	spin_unlock_irqrestore(&chip->input_dev->event_lock, flags);
+
+	return 0;
+}
+
+static int __devinit max8997_haptic_probe(struct platform_device *pdev)
+{
+	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max8997_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct max8997_haptic_platform_data *haptic_pdata =
+						pdata->haptic_pdata;
+	struct max8997_haptic *chip;
+	struct input_dev *input_dev;
+	int ret;
+
+	if (!haptic_pdata) {
+		dev_err(&pdev->dev, "no haptic platform data\n");
+		return -EINVAL;
+	}
+
+	chip = kzalloc(sizeof(struct max8997_haptic), GFP_KERNEL);
+	if (!chip) {
+		dev_err(&pdev->dev, "unable to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		dev_err(&pdev->dev,
+			"unable to allocate memory for input dev\n");
+		ret = -ENOMEM;
+		goto err_input_alloc;
+	}
+
+	chip->client = iodev->haptic;
+	chip->dev = &pdev->dev;
+	chip->input_dev = input_dev;
+	chip->pwm_period = haptic_pdata->pwm_period;
+	chip->type = haptic_pdata->type;
+	chip->mode = haptic_pdata->mode;
+	chip->pwm_divisor = haptic_pdata->pwm_divisor;
+	if (chip->mode == MAX8997_INTERNAL_MODE) {
+		chip->internal_mode_pattern =
+				haptic_pdata->internal_mode_pattern;
+		chip->pattern_cycle = haptic_pdata->pattern_cycle;
+		chip->pattern_signal_period =
+				haptic_pdata->pattern_signal_period;
+	}
+
+	if (chip->mode == MAX8997_EXTERNAL_MODE) {
+		chip->pwm = pwm_request(haptic_pdata->pwm_channel_id,
+					"max8997-haptic");
+		if (IS_ERR(chip->pwm)) {
+			dev_err(&pdev->dev,
+				"unable to request PWM for haptic\n");
+			ret = PTR_ERR(chip->pwm);
+			goto err_pwm;
+		}
+	}
+
+	chip->regulator = regulator_get(&pdev->dev, "inmotor");
+	if (IS_ERR(chip->regulator)) {
+		dev_err(&pdev->dev, "unable to get regulator\n");
+		ret = PTR_ERR(chip->regulator);
+		goto err_regulator;
+	}
+
+	platform_set_drvdata(pdev, chip);
+
+	input_dev->name = "max8997-haptic";
+	input_dev->id.version = 1;
+	input_dev->dev.parent = &pdev->dev;
+	input_set_drvdata(input_dev, chip);
+	input_set_capability(input_dev, EV_FF, FF_RUMBLE);
+
+	ret = input_ff_create_memless(input_dev, NULL,
+				max8997_haptic_play_effect);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"unable to create FF device(ret : %d)\n", ret);
+		goto err_ff_memless;
+	}
+
+	ret = input_register_device(input_dev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"unable to register input device(ret : %d)\n", ret);
+		goto err_input_register;
+	}
+
+	return 0;
+
+err_input_register:
+	input_ff_destroy(input_dev);
+err_ff_memless:
+	regulator_put(chip->regulator);
+err_regulator:
+	if (chip->mode == MAX8997_EXTERNAL_MODE)
+		pwm_free(chip->pwm);
+err_pwm:
+	input_free_device(input_dev);
+err_input_alloc:
+	kfree(chip);
+
+	return ret;
+}
+
+static int __devexit max8997_haptic_remove(struct platform_device *pdev)
+{
+	struct max8997_haptic *chip = platform_get_drvdata(pdev);
+
+	input_unregister_device(chip->input_dev);
+	regulator_put(chip->regulator);
+
+	if (chip->mode == MAX8997_EXTERNAL_MODE)
+		pwm_free(chip->pwm);
+
+	kfree(chip);
+
+	return 0;
+}
+
+static int max8997_haptic_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct max8997_haptic *chip = platform_get_drvdata(pdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->input_dev->event_lock, flags);
+
+	max8997_haptic_enable(chip, false);
+
+	spin_unlock_irqrestore(&chip->input_dev->event_lock, flags);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(max8997_haptic_pm_ops, max8997_haptic_suspend,
+	NULL);
+
+static const struct platform_device_id max8997_haptic_id[] = {
+	{ "max8997-haptic", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, max8997_haptic_id);
+
+static struct platform_driver max8997_haptic_driver = {
+	.driver	= {
+		.name	= "max8997-haptic",
+		.owner	= THIS_MODULE,
+		.pm	= &max8997_haptic_pm_ops,
+	},
+	.probe		= max8997_haptic_probe,
+	.remove		= __devexit_p(max8997_haptic_remove),
+	.id_table	= max8997_haptic_id,
+};
+
+module_platform_driver(max8997_haptic_driver);
+
+MODULE_ALIAS("platform:max8997-haptic");
+MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
+MODULE_DESCRIPTION("max8997_haptic driver");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4
