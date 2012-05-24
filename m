Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab2EXKfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:35:13 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:41378
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202Ab2EXKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:35:10 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzc8kzz1202hzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ahbe9i)
Subject: [PATCH] Watchdog: DA9052/53 PMIC watchdog support v4
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: Anthony Olech <Anthony.Olech@diasemi.com>, <linux-kernel@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 16:02:52 +0530
Message-ID: <1337855572.19955.9.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for the watchdog functionality provided by the Dialog
Semiconductor DA9052 PMIC chip.

Tested on samsung smdkv6410 and i.mx53 QS boards.

Signed-off-by: Anthony Olech <Anthony.Olech@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
Changed since V4:
- Fix for the minimum time watchdog window TWDMIN
Changes since V3:
- Add new watchdog framework
Changes since V2:
- Code restructured for simplicty.
- Add watchdog documentation.
- Remove Auto strobing feature.
- Remove strobe filtering flag.
---
 Documentation/watchdog/watchdog-parameters.txt |    5 +
 drivers/watchdog/Kconfig                       |   12 ++
 drivers/watchdog/Makefile                      |    1 +
 drivers/watchdog/da9052_wdt.c                  |  240 ++++++++++++++++++++++++
 4 files changed, 258 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/da9052_wdt.c

diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
index 17ddd82..04fddbac 100644
--- a/Documentation/watchdog/watchdog-parameters.txt
+++ b/Documentation/watchdog/watchdog-parameters.txt
@@ -78,6 +78,11 @@ wd0_timeout: Default watchdog0 timeout in 1/10secs
 wd1_timeout: Default watchdog1 timeout in 1/10secs
 wd2_timeout: Default watchdog2 timeout in 1/10secs
 -------------------------------------------------
+da9052wdt:
+timeout: Watchdog timeout in seconds. 2<= timeout <=131, default=2.048s
+nowayout: Watchdog cannot be stopped once started
+	(default=kernel config parameter)
+-------------------------------------------------
 davinci_wdt:
 heartbeat: Watchdog heartbeat period in seconds from 1 to 600, default 60
 -------------------------------------------------
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index d92d748..004e261 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -64,6 +64,18 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config DA9052_WATCHDOG
+        tristate "Dialog DA9052 Watchdog"
+        depends on PMIC_DA9052
+        select WATCHDOG_CORE
+        help
+          Support for the watchdog in the DA9052 PMIC. Watchdog trigger
+          cause system reset.
+
+          Say Y here to include support for the DA9052 watchdog.
+          Alternatively say M to compile the driver as a module,
+          which will be called da9052_wdt.
+
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 442bfbe..67b9f68 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -166,4 +166,5 @@ obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
+obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
new file mode 100644
index 0000000..0e2dde1
--- /dev/null
+++ b/drivers/watchdog/da9052_wdt.c
@@ -0,0 +1,240 @@
+/*
+ * System monitoring driver for DA9052 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: Anthony Olech <Anthony.Olech@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/watchdog.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+
+#define DA9052_DEF_TIMEOUT	4
+#define DA9052_TWDMIN		256
+
+struct da9052_wdt_drvdata {
+	struct watchdog_device wdt;
+	struct da9052 *da9052;
+	struct mutex lock;
+	unsigned long jpast;
+};
+
+static const struct {
+	u8 reg_val;
+	int time;  /* Seconds */
+} da9052_wdt_maps[] = {
+	{ 1, 2 },
+	{ 2, 4 },
+	{ 3, 8 },
+	{ 4, 16 },
+	{ 5, 32 },
+	{ 5, 33 },  /* Actual time  32.768s so included both 32s and 33s */
+	{ 6, 65 },
+	{ 6, 66 },  /* Actual time 65.536s so include both, 65s and 66s */
+	{ 7, 131 },
+};
+
+static int da9052_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				  unsigned int timeout)
+{
+	struct da9052_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9052 *da9052 = driver_data->da9052;
+	int ret, i;
+
+	/* Disable the Watchdog timer before setting
+	 * new time out.
+	 */
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_TWDSCALE, 0);
+	if (ret < 0) {
+		dev_err(da9052->dev, "Failed to disable watchdog bit, %d\n",
+			ret);
+		return ret;
+	}
+	if (timeout) {
+		/* To change the timeout, da9052 needs to
+		 * be disabled for at least 150 us.
+		 */
+		udelay(150);
+
+		/* Set the desired timeout */
+		for (i = 0; i < ARRAY_SIZE(da9052_wdt_maps); i++)
+			if (da9052_wdt_maps[i].time == timeout)
+				break;
+
+		if (i == ARRAY_SIZE(da9052_wdt_maps))
+			ret = -EINVAL;
+		else
+			ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+						DA9052_CONTROLD_TWDSCALE,
+						da9052_wdt_maps[i].reg_val);
+		if (ret < 0) {
+			dev_err(da9052->dev,
+				"Failed to update timescale bit, %d\n", ret);
+			return ret;
+		}
+
+		driver_data->jpast = jiffies;
+	}
+
+	return 0;
+}
+
+static int da9052_wdt_start(struct watchdog_device *wdt_dev)
+{
+	struct da9052_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	int ret = 0;
+
+	mutex_lock(&driver_data->lock);
+	ret = da9052_wdt_set_timeout(wdt_dev, DA9052_DEF_TIMEOUT);
+	mutex_unlock(&driver_data->lock);
+
+	return ret;
+}
+
+static int da9052_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	struct da9052_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9052 *da9052 = driver_data->da9052;
+	int ret = 0;
+
+	mutex_lock(&driver_data->lock);
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_TWDSCALE, 0);
+	mutex_unlock(&driver_data->lock);
+
+	return ret;
+}
+
+static int da9052_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct da9052_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9052 *da9052 = driver_data->da9052;
+	unsigned long msec, jnow = jiffies;
+	int ret;
+
+	mutex_lock(&driver_data->lock);
+
+	/* We have a minimum time for watchdog window called TWDMIN. A write
+	 * to the watchdog before this elapsed time should cause an error.
+	 */
+	msec = (jnow - driver_data->jpast) * 1000/HZ;
+	if (msec < DA9052_TWDMIN)
+		mdelay(msec);
+
+	/* Reset the watchdog timer */
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_WATCHDOG, 1 << 7);
+	if (ret < 0)
+		goto err_strobe;
+
+	/* FIXME: Reset the watchdog core, in general PMIC
+	 * is supposed to do this
+	 */
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_WATCHDOG, 0 << 7);
+err_strobe:
+	mutex_unlock(&driver_data->lock);
+	return ret;
+}
+
+static struct watchdog_info da9052_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity	= "DA9052 Watchdog",
+};
+
+static const struct watchdog_ops da9052_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = da9052_wdt_start,
+	.stop = da9052_wdt_stop,
+	.ping = da9052_wdt_ping,
+	.set_timeout = da9052_wdt_set_timeout,
+};
+
+
+static int __devinit da9052_wdt_probe(struct platform_device *pdev)
+{
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+	struct da9052_wdt_drvdata *driver_data;
+	struct watchdog_device *da9052_wdt;
+	int ret;
+
+	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
+				   GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(da9052->dev, "Unable to alloacate watchdog device\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	mutex_init(&driver_data->lock);
+	driver_data->da9052 = da9052;
+
+	da9052_wdt = &driver_data->wdt;
+
+	da9052_wdt->info = &da9052_wdt_info;
+	da9052_wdt->ops = &da9052_wdt_ops;
+	/* watchdog min timeout is fixed for 256ms */
+	da9052_wdt->min_elapse_time = 256;
+	watchdog_set_drvdata(da9052_wdt, driver_data);
+
+	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
+				DA9052_CONTROLD_TWDSCALE, 0);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to disable watchdog bits, %d\n",
+			ret);
+		goto err;
+	}
+
+	ret = watchdog_register_device(&driver_data->wdt);
+	if (ret != 0) {
+		dev_err(da9052->dev, "watchdog_register_device() failed: %d\n",
+			ret);
+		goto err;
+	}
+
+	dev_set_drvdata(&pdev->dev, driver_data);
+err:
+	return ret;
+}
+
+static int __devexit da9052_wdt_remove(struct platform_device *pdev)
+{
+	struct da9052_wdt_drvdata *driver_data = dev_get_drvdata(&pdev->dev);
+
+	watchdog_unregister_device(&driver_data->wdt);
+
+	return 0;
+}
+
+static struct platform_driver da9052_wdt_driver = {
+	.probe = da9052_wdt_probe,
+	.remove = __devexit_p(da9052_wdt_remove),
+	.driver = {
+		.name	= "da9052-watchdog",
+	},
+};
+
+module_platform_driver(da9052_wdt_driver);
+
+MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 SM Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-wdt");
+
-- 
1.7.5.4


