Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792Ab2JLJTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:19:35 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:52442
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181Ab2JLJTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:19:33 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(zzc84fmc8kzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441hbe9i1155h)
Subject: [Patch v2 6/7] Watchdog: DA9055 Watchdog driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-watchdog@vger.kernel.org>,
        David Dajun Chen <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Oct 2012 15:00:03 +0530
Message-ID: <1350034203.11527.19.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Watchdog patch for the DA9055 PMIC. This patch has got dependency on
the DA9055 MFD core.

This patch is functionally tested on SMDK6410

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
changes since version v2:
- remove duplicate includes
- use of module_platform_driver macro
---
 drivers/watchdog/Kconfig      |   10 ++
 drivers/watchdog/Makefile     |    1 +
 drivers/watchdog/da9055_wdt.c |  216 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/da9055_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 53d7571..eb51bf2 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -76,6 +76,16 @@ config DA9052_WATCHDOG
           Alternatively say M to compile the driver as a module,
           which will be called da9052_wdt.
 
+config DA9055_WATCHDOG
+	tristate "Dialog Semiconductor DA9055 Watchdog"
+	depends on MFD_DA9055
+	help
+	  If you say yes here you get support for watchdog on the Dialog
+	  Semiconductor DA9055 PMIC.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called da9055_wdt.
+
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 572b39b..97bbdb3 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -164,6 +164,7 @@ obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 
 # Architecture Independent
 obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
+obj-$(CONFIG_DA9055_WATCHDOG) += da9055_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
diff --git a/drivers/watchdog/da9055_wdt.c b/drivers/watchdog/da9055_wdt.c
new file mode 100644
index 0000000..493f7b5
--- /dev/null
+++ b/drivers/watchdog/da9055_wdt.c
@@ -0,0 +1,216 @@
+/*
+ * System monitoring driver for DA9055 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/delay.h>
+
+#include <linux/mfd/da9055/core.h>
+#include <linux/mfd/da9055/reg.h>
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+#define DA9055_DEF_TIMEOUT	4
+#define DA9055_TWDMIN		256
+
+struct da9055_wdt_data {
+	struct watchdog_device wdt;
+	struct da9055 *da9055;
+	struct kref kref;
+};
+
+static const struct {
+	u8 reg_val;
+	int user_time;  /* In seconds */
+} da9055_wdt_maps[] = {
+	{ 0, 0 },
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
+static int da9055_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				  unsigned int timeout)
+{
+	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9055 *da9055 = driver_data->da9055;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(da9055_wdt_maps); i++)
+		if (da9055_wdt_maps[i].user_time == timeout)
+			break;
+
+	if (i == ARRAY_SIZE(da9055_wdt_maps))
+		ret = -EINVAL;
+	else
+		ret = da9055_reg_update(da9055, DA9055_REG_CONTROL_B,
+					DA9055_TWDSCALE_MASK,
+					da9055_wdt_maps[i].reg_val <<
+					DA9055_TWDSCALE_SHIFT);
+	if (ret < 0)
+		dev_err(da9055->dev,
+			"Failed to update timescale bit, %d\n", ret);
+
+	wdt_dev->timeout = timeout;
+
+	return ret;
+}
+
+static int da9055_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct da9055 *da9055 = driver_data->da9055;
+	int ret;
+
+	/*
+	 * We have a minimum time for watchdog window called TWDMIN. A write
+	 * to the watchdog before this elapsed time will cause an error.
+	 */
+	mdelay(DA9055_TWDMIN);
+
+	/* Reset the watchdog timer */
+	ret = da9055_reg_update(da9055, DA9055_REG_CONTROL_E,
+				DA9055_WATCHDOG_MASK, 1);
+
+	return ret;
+}
+
+static void da9055_wdt_release_resources(struct kref *r)
+{
+	struct da9055_wdt_data *driver_data =
+		container_of(r, struct da9055_wdt_data, kref);
+
+	kfree(driver_data);
+}
+
+static void da9055_wdt_ref(struct watchdog_device *wdt_dev)
+{
+	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+
+	kref_get(&driver_data->kref);
+}
+
+static void da9055_wdt_unref(struct watchdog_device *wdt_dev)
+{
+	struct da9055_wdt_data *driver_data = watchdog_get_drvdata(wdt_dev);
+
+	kref_put(&driver_data->kref, da9055_wdt_release_resources);
+}
+
+static int da9055_wdt_start(struct watchdog_device *wdt_dev)
+{
+	return da9055_wdt_set_timeout(wdt_dev, wdt_dev->timeout);
+}
+
+static int da9055_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	return da9055_wdt_set_timeout(wdt_dev, 0);
+}
+
+static struct watchdog_info da9055_wdt_info = {
+	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity	= "DA9055 Watchdog",
+};
+
+static const struct watchdog_ops da9055_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = da9055_wdt_start,
+	.stop = da9055_wdt_stop,
+	.ping = da9055_wdt_ping,
+	.set_timeout = da9055_wdt_set_timeout,
+	.ref = da9055_wdt_ref,
+	.unref = da9055_wdt_unref,
+};
+
+static int __devinit da9055_wdt_probe(struct platform_device *pdev)
+{
+	struct da9055 *da9055 = dev_get_drvdata(pdev->dev.parent);
+	struct da9055_wdt_data *driver_data;
+	struct watchdog_device *da9055_wdt;
+	int ret;
+
+	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
+				   GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(da9055->dev, "Failed to allocate watchdog device\n");
+		return -ENOMEM;
+	}
+
+	driver_data->da9055 = da9055;
+
+	da9055_wdt = &driver_data->wdt;
+
+	da9055_wdt->timeout = DA9055_DEF_TIMEOUT;
+	da9055_wdt->info = &da9055_wdt_info;
+	da9055_wdt->ops = &da9055_wdt_ops;
+	watchdog_set_nowayout(da9055_wdt, nowayout);
+	watchdog_set_drvdata(da9055_wdt, driver_data);
+
+	kref_init(&driver_data->kref);
+
+	ret = da9055_wdt_stop(da9055_wdt);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to stop watchdog, %d\n", ret);
+		goto err;
+	}
+
+	dev_set_drvdata(&pdev->dev, driver_data);
+
+	ret = watchdog_register_device(&driver_data->wdt);
+	if (ret != 0)
+		dev_err(da9055->dev, "watchdog_register_device() failed: %d\n",
+			ret);
+
+err:
+	return ret;
+}
+
+static int __devexit da9055_wdt_remove(struct platform_device *pdev)
+{
+	struct da9055_wdt_data *driver_data = dev_get_drvdata(&pdev->dev);
+
+	watchdog_unregister_device(&driver_data->wdt);
+	kref_put(&driver_data->kref, da9055_wdt_release_resources);
+
+	return 0;
+}
+
+static struct platform_driver da9055_wdt_driver = {
+	.probe = da9055_wdt_probe,
+	.remove = __devexit_p(da9055_wdt_remove),
+	.driver = {
+		.name	= "da9055-watchdog",
+	},
+};
+
+module_platform_driver(da9055_wdt_driver);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9055 watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9055-watchdog");
-- 
1.7.0.4


