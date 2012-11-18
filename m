Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2KRQgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 11:36:50 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:50003 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2KRQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 11:36:34 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20v4=204/4=5D=20input=3A=20misc=3A=20introduce=20retu-pwrbutton?=
Date: Sun, 18 Nov 2012 18:36:22 +0200
Message-Id: <1353256582-12166-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353256582-12166-1-git-send-email-aaro.koskinen@iki.fi>
References: <1353256582-12166-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Retu power button driver.

Cc: linux-input@vger.kernel.org
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/Kconfig          |   10 ++++
 drivers/input/misc/Makefile         |    1 +
 drivers/input/misc/retu-pwrbutton.c |  102 +++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+)
 create mode 100644 drivers/input/misc/retu-pwrbutton.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7c0f1ec..e5be189 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -367,6 +367,16 @@ config INPUT_CM109
 	  To compile this driver as a module, choose M here: the module will be
 	  called cm109.
 
+config INPUT_RETU_PWRBUTTON
+	tristate "Retu Power button Driver"
+	depends on MFD_RETU
+	help
+	  Say Y here if you want to enable power key reporting via the
+	  Retu chips found in Nokia Internet Tablets (770, N800, N810).
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called retu-pwrbutton.
+
 config INPUT_TWL4030_PWRBUTTON
 	tristate "TWL4030 Power button Driver"
 	depends on TWL4030_CORE
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 83fe6f5..4fbee0d 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
 obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
 obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
+obj-$(CONFIG_INPUT_RETU_PWRBUTTON)	+= retu-pwrbutton.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
 obj-$(CONFIG_INPUT_SPARCSPKR)		+= sparcspkr.o
diff --git a/drivers/input/misc/retu-pwrbutton.c b/drivers/input/misc/retu-pwrbutton.c
new file mode 100644
index 0000000..043a12b
--- /dev/null
+++ b/drivers/input/misc/retu-pwrbutton.c
@@ -0,0 +1,102 @@
+/*
+ * Retu power button driver.
+ *
+ * Copyright (C) 2004-2010 Nokia Corporation
+ *
+ * Original code written by Ari Saastamoinen, Juha Yrjölä and Felipe Balbi.
+ * Rewritten by Aaro Koskinen.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/irq.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/input.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/retu.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
+#define RETU_STATUS_PWRONX (1 << 5)
+
+static irqreturn_t retu_pwrbutton_irq(int irq, void *_pwr)
+{
+	bool state;
+	struct input_dev *idev = _pwr;
+	struct retu_dev *rdev = input_get_drvdata(idev);
+
+	state = !(retu_read(rdev, RETU_REG_STATUS) & RETU_STATUS_PWRONX);
+	input_report_key(idev, KEY_POWER, state);
+	input_sync(idev);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit retu_pwrbutton_probe(struct platform_device *pdev)
+{
+	struct retu_dev *rdev = dev_get_drvdata(pdev->dev.parent);
+	struct input_dev *idev;
+	int ret;
+
+	idev = input_allocate_device();
+	if (!idev)
+		return -ENOMEM;
+
+	idev->evbit[0]				= BIT_MASK(EV_KEY);
+	idev->keybit[BIT_WORD(KEY_POWER)]	= BIT_MASK(KEY_POWER);
+	idev->name				= "retu-pwrbutton";
+
+	platform_set_drvdata(pdev, idev);
+	input_set_drvdata(idev, rdev);
+
+	ret = input_register_device(idev);
+	if (ret < 0) {
+		input_free_device(idev);
+		return ret;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, platform_get_irq(pdev, 0),
+					NULL, retu_pwrbutton_irq, 0,
+					"retu-pwrbutton", idev);
+	if (ret < 0)
+		input_unregister_device(idev);
+
+	return ret;
+}
+
+static int __devexit retu_pwrbutton_remove(struct platform_device *pdev)
+{
+	struct input_dev *idev = platform_get_drvdata(pdev);
+
+	disable_irq(platform_get_irq(pdev, 0));
+	input_unregister_device(idev);
+
+	return 0;
+}
+
+static struct platform_driver retu_pwrbutton_driver = {
+	.probe		= retu_pwrbutton_probe,
+	.remove		= __devexit_p(retu_pwrbutton_remove),
+	.driver		= {
+		.name	= "retu-pwrbutton",
+		.owner	= THIS_MODULE,
+	},
+};
+module_platform_driver(retu_pwrbutton_driver);
+
+MODULE_ALIAS("platform:retu-pwrbutton");
+MODULE_DESCRIPTION("Retu Power Button");
+MODULE_AUTHOR("Ari Saastamoinen");
+MODULE_AUTHOR("Felipe Balbi");
+MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

