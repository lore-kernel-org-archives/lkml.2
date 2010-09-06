Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0IFGzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:55:44 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:39020 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab0IFGzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:55:41 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>, <riku.voipio@iki.fi>, <mike@compulab.co.il>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>
Subject: [PATCHv3 1/1] u8500: ab8500-pwm: Add pwm driver
Date: Mon, 6 Sep 2010 12:24:52 +0530
Message-ID: <1283756092-31473-2-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1283756092-31473-1-git-send-email-arun.murthy@stericsson.com>
References: <1283756092-31473-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a Pulse Width Modulation driver for Analog Baseband
Chip AB8500.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab8500-core.c |   13 +++-
 drivers/misc/Kconfig      |    9 +++
 drivers/misc/Makefile     |    1 +
 drivers/misc/ab8500-pwm.c |  168 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 190 insertions(+), 1 deletions(-)
 create mode 100644 drivers/misc/ab8500-pwm.c

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 6548f50..13a5be9 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -394,10 +394,21 @@ static struct mfd_cell ab8500_devs[] = {
 		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
 		.resources = ab8500_rtc_resources,
 	},
+	{
+		.name = "ab8500-pwm",
+		.id = 1,
+	},
+	{
+		.name = "ab8500-pwm",
+		.id = 2,
+	},
+	{
+		.name = "ab8500-pwm",
+		.id = 3,
+	},
 	{ .name = "ab8500-charger", },
 	{ .name = "ab8500-audio", },
 	{ .name = "ab8500-usb", },
-	{ .name = "ab8500-pwm", },
 	{ .name = "ab8500-regulator", },
 };
 
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 9df5b75..3d36492 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -62,6 +62,15 @@ config ATMEL_PWM
 	  purposes including software controlled power-efficient backlights
 	  on LCD displays, motor control, and waveform generation.
 
+config AB8500_PWM
+	bool "AB8500 PWM support"
+	depends on AB8500_CORE
+	select HAVE_PWM
+	help
+	  This driver exports functions to enable/disble/config/free Pulse
+	  Width Modulation in the Analog Baseband Chip AB8500.
+	  It is used by led and backlight driver to control the intensity.
+
 config ATMEL_TCLIB
 	bool "Atmel AT32/AT91 Timer/Counter Library"
 	depends on (AVR32 || ARCH_AT91)
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 255a80d..33bc441 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -35,3 +35,4 @@ obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
+obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
diff --git a/drivers/misc/ab8500-pwm.c b/drivers/misc/ab8500-pwm.c
new file mode 100644
index 0000000..54e3d05
--- /dev/null
+++ b/drivers/misc/ab8500-pwm.c
@@ -0,0 +1,168 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/pwm.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500.h>
+
+/*
+ * PWM Out generators
+ * Bank: 0x10
+ */
+#define AB8500_PWM_OUT_CTRL1_REG	0x60
+#define AB8500_PWM_OUT_CTRL2_REG	0x61
+#define AB8500_PWM_OUT_CTRL7_REG	0x66
+
+/* backlight driver constants */
+#define ENABLE_PWM			1
+#define DISABLE_PWM			0
+
+struct pwm_device {
+	struct device *dev;
+	struct list_head node;
+	const char *label;
+	unsigned int pwm_id;
+};
+
+static LIST_HEAD(pwm_list);
+
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	int ret = 0;
+	unsigned int higher_val, lower_val;
+	u8 reg;
+
+	/*
+	 * get the first 8 bits that are be written to
+	 * AB8500_PWM_OUT_CTRL1_REG[0:7]
+	 */
+	lower_val = duty_ns & 0x00FF;
+	/*
+	 * get bits [9:10] that are to be written to
+	 * AB8500_PWM_OUT_CTRL2_REG[0:1]
+	 */
+	higher_val = ((duty_ns & 0x0300) >> 8);
+
+	reg = AB8500_PWM_OUT_CTRL1_REG + ((pwm->pwm_id - 1) * 2);
+
+	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
+			reg, (u8)lower_val);
+	if (ret < 0)
+		return ret;
+	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
+			(reg + 1), (u8)higher_val);
+
+	return ret;
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_enable(struct pwm_device *pwm)
+{
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (pwm->pwm_id-1), ENABLE_PWM);
+	if (ret < 0)
+		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
+							pwm->label, ret);
+	return ret;
+}
+EXPORT_SYMBOL(pwm_enable);
+
+void pwm_disable(struct pwm_device *pwm)
+{
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (pwm->pwm_id-1), DISABLE_PWM);
+	if (ret < 0)
+		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
+							pwm->label, ret);
+	return;
+}
+EXPORT_SYMBOL(pwm_disable);
+
+struct pwm_device *pwm_request(int pwm_id, const char *label)
+{
+	struct pwm_device *pwm;
+
+	list_for_each_entry(pwm, &pwm_list, node) {
+		if (pwm->pwm_id == pwm_id) {
+			pwm->label = label;
+			pwm->pwm_id = pwm_id;
+			return pwm;
+		}
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL(pwm_request);
+
+void pwm_free(struct pwm_device *pwm)
+{
+	pwm_disable(pwm);
+}
+EXPORT_SYMBOL(pwm_free);
+
+static int __devinit ab8500_pwm_probe(struct platform_device *pdev)
+{
+	struct pwm_device *pwm;
+	/*
+	 * Nothing to be done in probe, this is required to get the
+	 * device which is required for ab8500 read and write
+	 */
+	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
+	if (pwm == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	pwm->dev = &pdev->dev;
+	pwm->pwm_id = pdev->id;
+	list_add_tail(&pwm->node, &pwm_list);
+	platform_set_drvdata(pdev, pwm);
+	dev_dbg(pwm->dev, "pwm probe successful\n");
+	return 0;
+}
+
+static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
+{
+	struct pwm_device *pwm = platform_get_drvdata(pdev);
+	list_del(&pwm->node);
+	dev_dbg(&pdev->dev, "pwm driver removed\n");
+	kfree(pwm);
+	return 0;
+}
+
+static struct platform_driver ab8500_pwm_driver = {
+	.driver = {
+		.name = "ab8500-pwm",
+		.owner = THIS_MODULE,
+	},
+	.probe = ab8500_pwm_probe,
+	.remove = __devexit_p(ab8500_pwm_remove),
+};
+
+static int __init ab8500_pwm_init(void)
+{
+	return platform_driver_register(&ab8500_pwm_driver);
+}
+
+static void __exit ab8500_pwm_exit(void)
+{
+	platform_driver_unregister(&ab8500_pwm_driver);
+}
+
+subsys_initcall(ab8500_pwm_init);
+module_exit(ab8500_pwm_exit);
+MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
+MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
+MODULE_ALIAS("AB8500 PWM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.2.dirty

