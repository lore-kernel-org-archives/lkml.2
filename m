Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1HBGli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 02:41:38 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53510 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1HBGlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 02:41:31 -0400
Date: Mon, 1 Aug 2011 23:41:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anirudh Ghayal <aghayal@codeaurora.org>
Cc: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Amy Maloche <amaloche@codeaurora.org>
Subject: Re: [PATCH] input: misc: Add support for pm8xxx based vibrator driver
Message-ID: <20110802064124.GA21319@core.coreip.homeip.net>
References: <1312258397-11039-1-git-send-email-aghayal@codeaurora.org>
 <CAM=Q2cvzsZO4dc6Ot_aYJyLW27TErgySdXRcHr1UDb5ua1uHAg@mail.gmail.com>
 <4E3798C1.3080800@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3798C1.3080800@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 11:57:13AM +0530, Anirudh Ghayal wrote:
 
> Yes should have been dev_err.
> 
> Dmitry, would you like me to submit another patch for this? I can
> make the @work change as well. Or would you make this minor change
> as well. Thank you.
> 

Anirudh, I made this plus a few more cosmetic changes, if you could try
the patch below and let me know if it still works I will commit it for
the next merge window.

Thanks.

-- 
Dmitry


Input: misc - Add support for pm8xxx based vibrator driver

From: Amy Maloche <amaloche@codeaurora.org>

Add support for pm8xx based vibrator to facilitate haptics.
This module uses the ff-memless framework.

Signed-off-by: Amy Maloche <amaloche@codeaurora.org>
Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/Kconfig           |   34 +++-
 drivers/input/misc/Makefile          |    3 
 drivers/input/misc/pm8xxx-vibrator.c |  296 ++++++++++++++++++++++++++++++++++
 3 files changed, 321 insertions(+), 12 deletions(-)
 create mode 100644 drivers/input/misc/pm8xxx-vibrator.c


diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7ec4a20..bc53df5 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -74,6 +74,29 @@ config INPUT_PCSPKR
 	  To compile this driver as a module, choose M here: the
 	  module will be called pcspkr.
 
+config INPUT_PM8XXX_VIBRATOR
+	tristate "Qualcomm PM8XXX vibrator support"
+	depends on MFD_PM8XXX
+	select INPUT_FF_MEMLESS
+	help
+	  This option enables device driver support for the vibrator
+	  on Qualcomm PM8xxx chip. This driver supports ff-memless interface
+	  from input framework.
+
+	  To compile this driver as module, choose M here: the
+	  module will be called pm8xxx-vibrator.
+
+config INPUT_PMIC8XXX_PWRKEY
+	tristate "PMIC8XXX power key support"
+	depends on MFD_PM8XXX
+	help
+	  Say Y here if you want support for the PMIC8XXX power key.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pmic8xxx-pwrkey.
+
 config INPUT_SPARCSPKR
 	tristate "SPARC Speaker support"
 	depends on PCI && SPARC64
@@ -368,17 +391,6 @@ config INPUT_PWM_BEEPER
 	  To compile this driver as a module, choose M here: the module will be
 	  called pwm-beeper.
 
-config INPUT_PMIC8XXX_PWRKEY
-	tristate "PMIC8XXX power key support"
-	depends on MFD_PM8XXX
-	help
-	  Say Y here if you want support for the PMIC8XXX power key.
-
-	  If unsure, say N.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called pmic8xxx-pwrkey.
-
 config INPUT_GPIO_ROTARY_ENCODER
 	tristate "Rotary encoders connected to GPIO pins"
 	depends on GPIOLIB && GENERIC_GPIO
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index b56b9bf..3dc2a5f 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -34,9 +34,10 @@ obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
 obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
 obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
 obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
+obj-$(CONFIG_INPUT_PM8XXX_VIBRATOR)	+= pm8xxx-vibrator.o
+obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
 obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
-obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
new file mode 100644
index 0000000..58c72c5
--- /dev/null
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -0,0 +1,296 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/mfd/pm8xxx/core.h>
+
+#define VIB_DRV			0x4A
+
+#define VIB_DRV_SEL_MASK	0xf8
+#define VIB_DRV_SEL_SHIFT	0x03
+#define VIB_DRV_EN_MANUAL_MASK	0xfc
+
+#define VIB_MAX_LEVEL_mV	(3100)
+#define VIB_MIN_LEVEL_mV	(1200)
+#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
+
+#define MAX_FF_SPEED		0xff
+
+/**
+ * struct pm8xxx_vib - structure to hold vibrator data
+ * @vib_input_dev: input device supporting force feedback
+ * @work: work structure to set the vibration parameters
+ * @dev: device supporting force feedback
+ * @speed: speed of vibration set from userland
+ * @active: state of vibrator
+ * @level: level of vibration to set in the chip
+ * @reg_vib_drv: VIB_DRV register value
+ */
+struct pm8xxx_vib {
+	struct input_dev *vib_input_dev;
+	struct work_struct work;
+	struct device *dev;
+	int speed;
+	int level;
+	bool active;
+	u8  reg_vib_drv;
+};
+
+/**
+ * pm8xxx_vib_read_u8 - helper to read a byte from pmic chip
+ * @vib: pointer to vibrator structure
+ * @data: placeholder for data to be read
+ * @reg: register address
+ */
+static int pm8xxx_vib_read_u8(struct pm8xxx_vib *vib,
+				 u8 *data, u16 reg)
+{
+	int rc;
+
+	rc = pm8xxx_readb(vib->dev->parent, reg, data);
+	if (rc < 0)
+		dev_warn(vib->dev, "Error reading pm8xxx reg 0x%x(0x%x)\n",
+				reg, rc);
+	return rc;
+}
+
+/**
+ * pm8xxx_vib_write_u8 - helper to write a byte to pmic chip
+ * @vib: pointer to vibrator structure
+ * @data: data to write
+ * @reg: register address
+ */
+static int pm8xxx_vib_write_u8(struct pm8xxx_vib *vib,
+				 u8 data, u16 reg)
+{
+	int rc;
+
+	rc = pm8xxx_writeb(vib->dev->parent, reg, data);
+	if (rc < 0)
+		dev_warn(vib->dev, "Error writing pm8xxx reg 0x%x(0x%x)\n",
+				reg, rc);
+	return rc;
+}
+
+/**
+ * pm8xxx_vib_set - handler to start/stop vibration
+ * @vib: pointer to vibrator structure
+ * @on: state to set
+ */
+static int pm8xxx_vib_set(struct pm8xxx_vib *vib, bool on)
+{
+	int rc;
+	u8 val = vib->reg_vib_drv;
+
+	if (on)
+		val |= ((vib->level << VIB_DRV_SEL_SHIFT) & VIB_DRV_SEL_MASK);
+	else
+		val &= ~VIB_DRV_SEL_MASK;
+
+	rc = pm8xxx_vib_write_u8(vib, val, VIB_DRV);
+	if (rc < 0)
+		return rc;
+
+	vib->reg_vib_drv = val;
+	return 0;
+}
+
+/**
+ * pm8xxx_work_handler - worker to set vibration level
+ * @work: pointer to work_struct
+ */
+static void pm8xxx_work_handler(struct work_struct *work)
+{
+	struct pm8xxx_vib *vib = container_of(work, struct pm8xxx_vib, work);
+	int rc;
+	u8 val;
+
+	rc = pm8xxx_vib_read_u8(vib, &val, VIB_DRV);
+	if (rc < 0)
+		return;
+
+	/*
+	 * pmic vibrator supports voltage ranges from 1.2 to 3.1V, so
+	 * scale the level to fit into these ranges.
+	 */
+	if (vib->speed) {
+		vib->active = true;
+		vib->level = ((VIB_MAX_LEVELS * vib->speed) / MAX_FF_SPEED) +
+						VIB_MIN_LEVEL_mV;
+		vib->level /= 100;
+	} else {
+		vib->active = false;
+		vib->level = VIB_MIN_LEVEL_mV / 100;
+	}
+
+	pm8xxx_vib_set(vib, vib->active);
+}
+
+/**
+ * pm8xxx_vib_close - callback of input close callback
+ * @dev: input device pointer
+ *
+ * Turns off the vibrator.
+ */
+static void pm8xxx_vib_close(struct input_dev *dev)
+{
+	struct pm8xxx_vib *vib = input_get_drvdata(dev);
+
+	cancel_work_sync(&vib->work);
+	if (vib->active)
+		pm8xxx_vib_set(vib, false);
+}
+
+/**
+ * pm8xxx_vib_play_effect - function to handle vib effects.
+ * @dev: input device pointer
+ * @data: data of effect
+ * @effect: effect to play
+ *
+ * Currently this driver supports only rumble effects.
+ */
+static int pm8xxx_vib_play_effect(struct input_dev *dev, void *data,
+				  struct ff_effect *effect)
+{
+	struct pm8xxx_vib *vib = input_get_drvdata(dev);
+
+	vib->speed = effect->u.rumble.strong_magnitude >> 8;
+	if (!vib->speed)
+		vib->speed = effect->u.rumble.weak_magnitude >> 9;
+
+	schedule_work(&vib->work);
+
+	return 0;
+}
+
+static int __devinit pm8xxx_vib_probe(struct platform_device *pdev)
+
+{
+	struct pm8xxx_vib *vib;
+	struct input_dev *input_dev;
+	int error;
+	u8 val;
+
+	vib = kzalloc(sizeof(*vib), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!vib || !input_dev) {
+		dev_err(&pdev->dev, "couldn't allocate memory\n");
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	INIT_WORK(&vib->work, pm8xxx_work_handler);
+	vib->dev = &pdev->dev;
+	vib->vib_input_dev = input_dev;
+
+	/* operate in manual mode */
+	error = pm8xxx_vib_read_u8(vib, &val, VIB_DRV);
+	if (error < 0)
+		goto err_free_mem;
+	val &= ~VIB_DRV_EN_MANUAL_MASK;
+	error = pm8xxx_vib_write_u8(vib, val, VIB_DRV);
+	if (error < 0)
+		goto err_free_mem;
+
+	vib->reg_vib_drv = val;
+
+	input_dev->name = "pm8xxx_vib_ffmemless";
+	input_dev->id.version = 1;
+	input_dev->dev.parent = &pdev->dev;
+	input_dev->close = pm8xxx_vib_close;
+	input_set_drvdata(input_dev, vib);
+	input_set_capability(vib->vib_input_dev, EV_FF, FF_RUMBLE);
+
+	error = input_ff_create_memless(input_dev, NULL,
+					pm8xxx_vib_play_effect);
+	if (error) {
+		dev_err(&pdev->dev,
+			"couldn't register vibrator as FF device\n");
+		goto err_free_mem;
+	}
+
+	error = input_register_device(input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "couldn't register input device\n");
+		goto err_destroy_memless;
+	}
+
+	platform_set_drvdata(pdev, vib);
+	return 0;
+
+err_destroy_memless:
+	input_ff_destroy(input_dev);
+err_free_mem:
+	input_free_device(input_dev);
+	kfree(vib);
+
+	return error;
+}
+
+static int __devexit pm8xxx_vib_remove(struct platform_device *pdev)
+{
+	struct pm8xxx_vib *vib = platform_get_drvdata(pdev);
+
+	input_unregister_device(vib->vib_input_dev);
+	kfree(vib);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int pm8xxx_vib_suspend(struct device *dev)
+{
+	struct pm8xxx_vib *vib = dev_get_drvdata(dev);
+
+	/* Turn off the vibrator */
+	pm8xxx_vib_set(vib, false);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(pm8xxx_vib_pm_ops, pm8xxx_vib_suspend, NULL);
+
+static struct platform_driver pm8xxx_vib_driver = {
+	.probe		= pm8xxx_vib_probe,
+	.remove		= __devexit_p(pm8xxx_vib_remove),
+	.driver		= {
+		.name	= "pm8xxx-vib",
+		.owner	= THIS_MODULE,
+		.pm	= &pm8xxx_vib_pm_ops,
+	},
+};
+
+static int __init pm8xxx_vib_init(void)
+{
+	return platform_driver_register(&pm8xxx_vib_driver);
+}
+module_init(pm8xxx_vib_init);
+
+static void __exit pm8xxx_vib_exit(void)
+{
+	platform_driver_unregister(&pm8xxx_vib_driver);
+}
+module_exit(pm8xxx_vib_exit);
+
+MODULE_ALIAS("platform:pm8xxx_vib");
+MODULE_DESCRIPTION("PMIC8xxx vibrator driver based on ff-memless framework");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Amy Maloche <amaloche@codeaurora.org>");
