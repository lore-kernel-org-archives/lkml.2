Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1BANs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:48:57 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27646 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1BANsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:48:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6243"; a="72780283"
From: Anirudh Ghayal <aghayal@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Amy Maloche <amaloche@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mohan Pallaka <mpallaka@codeaurora.org>
Subject: [RFC v2 PATCH 7/7] input: misc: Add support for PM8058 based vibrator driver
Date: Tue,  1 Feb 2011 19:17:43 +0530
Message-Id: <1296568063-12010-8-git-send-email-aghayal@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org>
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amy Maloche <amaloche@codeaurora.org>

Add support for pmic8058 based vibrator to facilitate haptics.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Mohan Pallaka <mpallaka@codeaurora.org>
---
 drivers/input/misc/Kconfig             |   12 ++
 drivers/input/misc/Makefile            |    1 +
 drivers/input/misc/pmic8058-vibrator.c |  306 ++++++++++++++++++++++++++++++++
 3 files changed, 319 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/misc/pmic8058-vibrator.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 3802f54..e391f9e 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -74,6 +74,18 @@ config INPUT_PCSPKR
 	  To compile this driver as a module, choose M here: the
 	  module will be called pcspkr.
 
+config INPUT_PMIC8058_VIBRATOR
+	tristate "Qualcomm PM8058 vibrator support"
+	depends on PMIC8058
+	select INPUT_FF_MEMLESS
+	help
+	  This option enables device driver support for the vibrator
+	  on Qualcomm PM8058 chip. This driver supports ff-memless interface
+	  from input framework.
+
+	  To compile this driver as module, choose M here: the
+	  module will be called pmic8058-vibrator.
+
 config INPUT_SPARCSPKR
 	tristate "SPARC Speaker support"
 	depends on PCI && SPARC64
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index df9a679..b5fa9f6 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
 obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
 obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
 obj-$(CONFIG_INPUT_PMIC8058_OTHC)	+= pmic8058-othc.o
+obj-$(CONFIG_INPUT_PMIC8058_VIBRATOR)	+= pmic8058-vibrator.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
 obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
 obj-$(CONFIG_INPUT_PMIC8058_PWRKEY)	+= pmic8058-pwrkey.o
diff --git a/drivers/input/misc/pmic8058-vibrator.c b/drivers/input/misc/pmic8058-vibrator.c
new file mode 100644
index 0000000..cb1a797
--- /dev/null
+++ b/drivers/input/misc/pmic8058-vibrator.c
@@ -0,0 +1,306 @@
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/pmic8058.h>
+#include <linux/input/pmic8058-vibrator.h>
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
+/*
+ * struct pmic8058_vib - structure to hold vibrator data
+ * vib_input_dev: input device supporting force feedback
+ * work: work structure to set the vibration parameters
+ * dev: device supporting force feedback
+ * pdata: platform data
+ * pm_chip: reference to pmic chip to carry out read/write operations
+ * speed: speed of vibration set from userland
+ * state: state of vibrator
+ * level: level of vibration to set in the chip
+ * reg_vib_drv: VIB_DRV register value
+ *
+ */
+struct pmic8058_vib {
+	struct input_dev *vib_input_dev;
+	struct work_struct work;
+	struct device *dev;
+	const struct pmic8058_vibrator_pdata *pdata;
+	struct pm8058_chip	*pm_chip;
+	int speed;
+	int state;
+	int level;
+	u8  reg_vib_drv;
+};
+
+/*
+ * pmic8058_vib_read_u8 - helper to read a byte from pmic chip
+ * vib: pointer to vibrator structure
+ * data: placeholder for data to be read
+ * reg: register address
+ *
+ */
+static int pmic8058_vib_read_u8(struct pmic8058_vib *vib,
+				 u8 *data, u16 reg)
+{
+	int rc;
+
+	rc = pm8058_read(vib->pm_chip, reg, data, 1);
+	if (rc < 0)
+		dev_warn(vib->dev, "Error reading pmic8058 reg 0x%x(0x%x)\n",
+				reg, rc);
+	return rc;
+}
+
+/*
+ * pmic8058_vib_write_u8 - helper to write a byte to pmic chip
+ * vib: pointer to vibrator structure
+ * data: data to write
+ * reg: register address
+ *
+ */
+static int pmic8058_vib_write_u8(struct pmic8058_vib *vib,
+				 u8 data, u16 reg)
+{
+	int rc;
+
+	rc = pm8058_write(vib->pm_chip, reg, &data, 1);
+	if (rc < 0)
+		dev_warn(vib->dev, "Error writing pmic8058 reg 0x%x(0x%x)\n",
+				reg, rc);
+	return rc;
+}
+
+/*
+ * pmic8058_vib_set - handler to start/stop vibration
+ * vib: pointer to vibrator structure
+ * on: state to set
+ *
+ */
+static int pmic8058_vib_set(struct pmic8058_vib *vib, int on)
+{
+	int rc;
+	u8 val;
+
+	val = vib->reg_vib_drv;
+
+	if (on)
+		val |= ((vib->level << VIB_DRV_SEL_SHIFT) & VIB_DRV_SEL_MASK);
+	else
+		val &= ~VIB_DRV_SEL_MASK;
+
+	rc = pmic8058_vib_write_u8(vib, val, VIB_DRV);
+	if (rc < 0)
+		return rc;
+
+	vib->reg_vib_drv = val;
+	return rc;
+}
+
+/*
+ * pmic8058_work_handler - worker to set vibration level
+ * work: pointer to work_struct
+ *
+ */
+static void pmic8058_work_handler(struct work_struct *work)
+{
+	struct pmic8058_vib *vib;
+	int rc;
+	u8 val;
+
+	vib  = container_of(work, struct pmic8058_vib, work);
+
+	rc = pmic8058_vib_read_u8(vib, &val, VIB_DRV);
+	if (rc < 0)
+		return;
+
+	/*
+	 * pmic vibrator supports voltage ranges from 1.2 to 3.1V, so
+	 * scale the level to fit into these ranges.
+	 */
+	if (vib->speed) {
+		vib->state = 1;
+		vib->level = ((VIB_MAX_LEVELS * vib->speed) / MAX_FF_SPEED) +
+						VIB_MIN_LEVEL_mV;
+		vib->level /= 100;
+	} else {
+		vib->state = 0;
+		vib->level = VIB_MIN_LEVEL_mV / 100;
+	}
+	pmic8058_vib_set(vib, vib->state);
+}
+
+/*
+ * pmic8058_vib_play_effect - function to handle vib effects.
+ * dev: input device pointer
+ * data: data of effect
+ * effect: effect to play
+ *
+ * Currently this driver supports only rumble effects.
+ *
+ */
+static int pmic8058_vib_play_effect(struct input_dev *dev, void *data,
+		      struct ff_effect *effect)
+{
+	struct pmic8058_vib *vib = input_get_drvdata(dev);
+
+	vib->speed = effect->u.rumble.strong_magnitude >> 8;
+	if (!vib->speed)
+		vib->speed = effect->u.rumble.weak_magnitude >> 9;
+	schedule_work(&vib->work);
+	return 0;
+}
+
+static int __devinit pmic8058_vib_probe(struct platform_device *pdev)
+
+{
+	struct pm8058_chip *pm_chip;
+	struct pmic8058_vib *vib;
+	const struct pmic8058_vibrator_pdata *pdata = pdev->dev.platform_data;
+	int rc;
+	u8 val;
+
+	pm_chip = platform_get_drvdata(pdev);
+	if (pm_chip == NULL) {
+		dev_err(&pdev->dev, "no parent data passed in\n");
+		return -EINVAL;
+	}
+
+	if (!pdata)
+		return -EINVAL;
+
+	if (pdata->level_mV < VIB_MIN_LEVEL_mV ||
+			 pdata->level_mV > VIB_MAX_LEVEL_mV)
+		return -EINVAL;
+
+	vib = kzalloc(sizeof(*vib), GFP_KERNEL);
+	if (!vib)
+		return -ENOMEM;
+
+	vib->pm_chip	= pm_chip;
+	vib->pdata	= pdata;
+	vib->dev	= &pdev->dev;
+
+	INIT_WORK(&vib->work, pmic8058_work_handler);
+
+	vib->vib_input_dev = input_allocate_device();
+
+	if (vib->vib_input_dev == NULL) {
+		dev_err(&pdev->dev, "couldn't allocate input device\n");
+		rc = -ENOMEM;
+		goto err_alloc_dev;
+	}
+
+	input_set_drvdata(vib->vib_input_dev, vib);
+
+	vib->vib_input_dev->name = "pmic8058_vibrator";
+	vib->vib_input_dev->id.version = 1;
+	vib->vib_input_dev->dev.parent = &pdev->dev;
+
+	/* operate in manual mode */
+	rc = pmic8058_vib_read_u8(vib, &val, VIB_DRV);
+	if (rc < 0)
+		goto err_read_vib;
+	val &= ~VIB_DRV_EN_MANUAL_MASK;
+	rc = pmic8058_vib_write_u8(vib, val, VIB_DRV);
+	if (rc < 0)
+		goto err_read_vib;
+
+	vib->reg_vib_drv = val;
+
+	input_set_capability(vib->vib_input_dev, EV_FF, FF_RUMBLE);
+
+	rc = input_ff_create_memless(vib->vib_input_dev, NULL,
+					pmic8058_vib_play_effect);
+	if (rc < 0) {
+		dev_dbg(&pdev->dev, "couldn't register vibrator to FF\n");
+		goto err_create_memless;
+	}
+
+	platform_set_drvdata(pdev, vib);
+
+	rc = input_register_device(vib->vib_input_dev);
+	if (rc < 0) {
+		dev_dbg(&pdev->dev, "couldn't register input device\n");
+		goto err_reg_input_dev;
+	}
+	return 0;
+
+err_reg_input_dev:
+	input_ff_destroy(vib->vib_input_dev);
+err_create_memless:
+err_read_vib:
+	input_free_device(vib->vib_input_dev);
+err_alloc_dev:
+	kfree(vib);
+	return rc;
+}
+
+static int __devexit pmic8058_vib_remove(struct platform_device *pdev)
+{
+	struct pmic8058_vib *vib = platform_get_drvdata(pdev);
+
+	cancel_work_sync(&vib->work);
+	if (vib->state)
+		pmic8058_vib_set(vib, 0);
+
+	input_unregister_device(vib->vib_input_dev);
+	kfree(vib);
+	return 0;
+}
+
+static struct platform_driver pmic8058_vib_driver = {
+	.probe		= pmic8058_vib_probe,
+	.remove		= __devexit_p(pmic8058_vib_remove),
+	.driver		= {
+		.name	= "pm8058-vib",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init pmic8058_vib_init(void)
+{
+	return platform_driver_register(&pmic8058_vib_driver);
+}
+module_init(pmic8058_vib_init);
+
+static void __exit pmic8058_vib_exit(void)
+{
+	platform_driver_unregister(&pmic8058_vib_driver);
+}
+module_exit(pmic8058_vib_exit);
+
+MODULE_ALIAS("platform:pmic8058_vib");
+MODULE_DESCRIPTION("PMIC8058 vibrator driver based on ff-memless framework");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Amy Maloche <amaloche@codeaurora.org>");
-- 
1.7.3.5

