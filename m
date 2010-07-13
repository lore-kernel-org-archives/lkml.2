Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab0GMRSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:18:06 -0400
Received: from smtp-out-220.synserver.de ([212.40.180.220]:1051 "HELO
	smtp-out-219.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1757101Ab0GMRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:18:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 29750
From: Lars-Peter Clausen <lars@metafoo.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] input: Add pwm beeper driver
Date: Tue, 13 Jul 2010 19:17:39 +0200
Message-Id: <1279041459-5585-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a simple driver which allows to use pwm based beepers (for
example piezo elements) as a pcspkr-like device.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/input/misc/Kconfig      |   11 ++
 drivers/input/misc/Makefile     |    2 +-
 drivers/input/misc/pwm-beeper.c |  197 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 209 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/pwm-beeper.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index ede6d52..068f250 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -427,4 +427,15 @@ config INPUT_ADXL34X_SPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called adxl34x-spi.
 
+config INPUT_PWM_BEEPER
+	tristate "PWM beeper support"
+	depends on HAVE_PWM
+	help
+	  Say Y here to get support for PWM based beeper devices.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called pwm-beeper
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 97b5dc3..1df6c55 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
 obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
 obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
+obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
@@ -40,4 +41,3 @@ obj-$(CONFIG_INPUT_WINBOND_CIR)		+= winbond-cir.o
 obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
-
diff --git a/drivers/input/misc/pwm-beeper.c b/drivers/input/misc/pwm-beeper.c
new file mode 100644
index 0000000..8f5321f
--- /dev/null
+++ b/drivers/input/misc/pwm-beeper.c
@@ -0,0 +1,197 @@
+/*
+ *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
+ *  PWM beeper driver
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+
+struct pwm_beeper {
+	struct input_dev *input;
+	struct pwm_device *pwm;
+	unsigned long period;
+};
+
+#define HZ_TO_NANOSECONDS(x) (1000000000UL/(x))
+
+static int pwm_beeper_event(struct input_dev *input, unsigned int type,
+	unsigned int code, int value)
+{
+	int ret = 0;
+	struct pwm_beeper *beeper = input_get_drvdata(input);
+	unsigned long period;
+
+	if (type != EV_SND || value < 0)
+		return -EINVAL;
+
+	switch (code) {
+	case SND_BELL:
+		value = value ? 1000 : 0;
+		break;
+	case SND_TONE:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (value == 0) {
+		pwm_config(beeper->pwm, 0, 0);
+		pwm_disable(beeper->pwm);
+	} else {
+		period = HZ_TO_NANOSECONDS(value);
+		ret = pwm_config(beeper->pwm, period / 2, period);
+		if (ret)
+			return ret;
+		ret = pwm_enable(beeper->pwm);
+		if (ret)
+			return ret;
+		beeper->period = period;
+	}
+
+	return 0;
+}
+
+static int __devinit pwm_beeper_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct pwm_beeper *beeper;
+	unsigned long pwm_id = (unsigned long)pdev->dev.platform_data;
+
+	beeper = kzalloc(sizeof(*beeper), GFP_KERNEL);
+	if (!beeper)
+		return -ENOMEM;
+
+	beeper->pwm = pwm_request(pwm_id, "pwm beeper");
+
+	if (IS_ERR(beeper->pwm)) {
+		ret = PTR_ERR(beeper->pwm);
+		dev_err(&pdev->dev, "Failed to request pwm device: %d\n", ret);
+		goto err_free;
+	}
+
+	beeper->input = input_allocate_device();
+	if (!beeper->input) {
+		dev_err(&pdev->dev, "Failed to allocate input device\n");
+		ret = -ENOMEM;
+		goto err_pwm_free;
+	}
+	beeper->input->dev.parent = &pdev->dev;
+
+	beeper->input->name = "pwm-beeper";
+	beeper->input->phys = "pwm/input0";
+	beeper->input->id.bustype = BUS_HOST;
+	beeper->input->id.vendor = 0x001f;
+	beeper->input->id.product = 0x0001;
+	beeper->input->id.version = 0x0100;
+
+	beeper->input->evbit[0] = BIT(EV_SND);
+	beeper->input->sndbit[0] = BIT(SND_TONE) | BIT(SND_BELL);
+
+	beeper->input->event = pwm_beeper_event;
+
+	input_set_drvdata(beeper->input, beeper);
+	ret = input_register_device(beeper->input);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register input device: %d\n", ret);
+		goto err_input_free;
+	}
+
+	platform_set_drvdata(pdev, beeper);
+
+	return 0;
+
+err_input_free:
+	input_free_device(beeper->input);
+err_pwm_free:
+	pwm_free(beeper->pwm);
+err_free:
+	kfree(beeper);
+
+	return ret;
+}
+
+static int __devexit pwm_beeper_remove(struct platform_device *pdev)
+{
+	struct pwm_beeper *beeper = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	input_unregister_device(beeper->input);
+
+	pwm_disable(beeper->pwm);
+	pwm_free(beeper->pwm);
+
+	kfree(beeper);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int pwm_beeper_suspend(struct device *dev)
+{
+	struct pwm_beeper *beeper = dev_get_drvdata(dev);
+	if (beeper->period)
+		pwm_disable(beeper->pwm);
+
+	return 0;
+}
+
+static int pwm_beeper_resume(struct device *dev)
+{
+	struct pwm_beeper *beeper = dev_get_drvdata(dev);
+
+	if (beeper->period) {
+		pwm_config(beeper->pwm, beeper->period / 2, beeper->period);
+		pwm_enable(beeper->pwm);
+	}
+
+	return 0;
+}
+
+static const SIMPLE_DEV_PM_OPS(pwm_beeper_pm_ops,
+				pwm_beeper_suspend, pwm_beeper_resume);
+
+#define PWM_BEEPER_PM_OPS (&pwm_beeper_pm_ops)
+#else
+#define PWM_BEEPER_PM_OPS NULL
+#endif
+
+static struct platform_driver pwm_beeper_driver = {
+	.probe	= pwm_beeper_probe,
+	.remove = __devexit_p(pwm_beeper_remove),
+	.driver = {
+		.name	= "pwm-beeper",
+		.owner	= THIS_MODULE,
+		.pm		= PWM_BEEPER_PM_OPS,
+	},
+};
+
+static int __init pwm_beeper_init(void)
+{
+	return platform_driver_register(&pwm_beeper_driver);
+}
+module_init(pwm_beeper_init);
+
+static void __exit pwm_beeper_exit(void)
+{
+	platform_driver_unregister(&pwm_beeper_driver);
+}
+module_exit(pwm_beeper_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("PWM beeper driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pwm-beeper");
-- 
1.5.6.5

