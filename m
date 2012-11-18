Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2KRQhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 11:37:18 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:59971 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2KRQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 11:36:33 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-watchdog@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH v4 3/4] watchdog: introduce retu_wdt driver
Date: Sun, 18 Nov 2012 18:36:21 +0200
Message-Id: <1353256582-12166-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353256582-12166-1-git-send-email-aaro.koskinen@iki.fi>
References: <1353256582-12166-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce Retu watchdog driver.

Cc: linux-watchdog@vger.kernel.org
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/Kconfig    |   12 +++
 drivers/watchdog/Makefile   |    1 +
 drivers/watchdog/retu_wdt.c |  178 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+)
 create mode 100644 drivers/watchdog/retu_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index ad1bb93..c3a836d 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -352,6 +352,18 @@ config IMX2_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called imx2_wdt.
 
+config RETU_WATCHDOG
+	tristate "Retu watchdog"
+	depends on MFD_RETU
+	select WATCHDOG_CORE
+	help
+	  Retu watchdog driver for Nokia Internet Tablets (700, N800,
+	  N810). At least on N800 the watchdog cannot be disabled, so
+	  this driver is essential and you should enable it.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called retu_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 572b39b..d2f1c0c 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
 obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
+obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
diff --git a/drivers/watchdog/retu_wdt.c b/drivers/watchdog/retu_wdt.c
new file mode 100644
index 0000000..aeb0f39
--- /dev/null
+++ b/drivers/watchdog/retu_wdt.c
@@ -0,0 +1,178 @@
+/*
+ * Retu watchdog driver
+ *
+ * Copyright (C) 2004, 2005 Nokia Corporation
+ *
+ * Based on code written by Amit Kucheria and Michael Buesch.
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
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/retu.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+
+/* Watchdog timer values in seconds */
+#define RETU_WDT_MAX_TIMER	63
+
+struct retu_wdt_dev {
+	struct retu_dev		*rdev;
+	struct device		*dev;
+	struct delayed_work	ping_work;
+};
+
+/*
+ * Since Retu watchdog cannot be disabled in hardware, we must kick it
+ * with a timer until userspace watchdog software takes over. If
+ * CONFIG_WATCHDOG_NOWAYOUT is set, we never start the feeding.
+ */
+static void retu_wdt_ping_enable(struct retu_wdt_dev *wdev)
+{
+	retu_write(wdev->rdev, RETU_REG_WATCHDOG, RETU_WDT_MAX_TIMER);
+	schedule_delayed_work(&wdev->ping_work,
+			round_jiffies_relative(RETU_WDT_MAX_TIMER * HZ / 2));
+}
+
+static void retu_wdt_ping_disable(struct retu_wdt_dev *wdev)
+{
+	retu_write(wdev->rdev, RETU_REG_WATCHDOG, RETU_WDT_MAX_TIMER);
+	cancel_delayed_work_sync(&wdev->ping_work);
+}
+
+static void retu_wdt_ping_work(struct work_struct *work)
+{
+	struct retu_wdt_dev *wdev = container_of(to_delayed_work(work),
+						struct retu_wdt_dev, ping_work);
+	retu_wdt_ping_enable(wdev);
+}
+
+static int retu_wdt_start(struct watchdog_device *wdog)
+{
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	retu_wdt_ping_disable(wdev);
+
+	return retu_write(wdev->rdev, RETU_REG_WATCHDOG, wdog->timeout);
+}
+
+static int retu_wdt_stop(struct watchdog_device *wdog)
+{
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	retu_wdt_ping_enable(wdev);
+
+	return 0;
+}
+
+static int retu_wdt_ping(struct watchdog_device *wdog)
+{
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	return retu_write(wdev->rdev, RETU_REG_WATCHDOG, wdog->timeout);
+}
+
+static int retu_wdt_set_timeout(struct watchdog_device *wdog,
+				unsigned int timeout)
+{
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	wdog->timeout = timeout;
+	return retu_write(wdev->rdev, RETU_REG_WATCHDOG, wdog->timeout);
+}
+
+static const struct watchdog_info retu_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "Retu watchdog",
+};
+
+static const struct watchdog_ops retu_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= retu_wdt_start,
+	.stop		= retu_wdt_stop,
+	.ping		= retu_wdt_ping,
+	.set_timeout	= retu_wdt_set_timeout,
+};
+
+static int __devinit retu_wdt_probe(struct platform_device *pdev)
+{
+	struct retu_dev *rdev = dev_get_drvdata(pdev->dev.parent);
+	bool nowayout = WATCHDOG_NOWAYOUT;
+	struct watchdog_device *retu_wdt;
+	struct retu_wdt_dev *wdev;
+	int ret;
+
+	retu_wdt = devm_kzalloc(&pdev->dev, sizeof(*retu_wdt), GFP_KERNEL);
+	if (!retu_wdt)
+		return -ENOMEM;
+
+	wdev = devm_kzalloc(&pdev->dev, sizeof(*wdev), GFP_KERNEL);
+	if (!wdev)
+		return -ENOMEM;
+
+	retu_wdt->info		= &retu_wdt_info;
+	retu_wdt->ops		= &retu_wdt_ops;
+	retu_wdt->timeout	= RETU_WDT_MAX_TIMER;
+	retu_wdt->min_timeout	= 0;
+	retu_wdt->max_timeout	= RETU_WDT_MAX_TIMER;
+
+	watchdog_set_drvdata(retu_wdt, wdev);
+	watchdog_set_nowayout(retu_wdt, nowayout);
+
+	wdev->rdev		= rdev;
+	wdev->dev		= &pdev->dev;
+
+	INIT_DELAYED_WORK(&wdev->ping_work, retu_wdt_ping_work);
+
+	ret = watchdog_register_device(retu_wdt);
+	if (ret < 0)
+		return ret;
+
+	if (nowayout)
+		retu_wdt_ping(retu_wdt);
+	else
+		retu_wdt_ping_enable(wdev);
+
+	platform_set_drvdata(pdev, retu_wdt);
+
+	return 0;
+}
+
+static int __devexit retu_wdt_remove(struct platform_device *pdev)
+{
+	struct watchdog_device *wdog = platform_get_drvdata(pdev);
+	struct retu_wdt_dev *wdev = watchdog_get_drvdata(wdog);
+
+	watchdog_unregister_device(wdog);
+	cancel_delayed_work_sync(&wdev->ping_work);
+
+	return 0;
+}
+
+static struct platform_driver retu_wdt_driver = {
+	.probe		= retu_wdt_probe,
+	.remove		= __devexit_p(retu_wdt_remove),
+	.driver		= {
+		.name	= "retu-wdt",
+	},
+};
+module_platform_driver(retu_wdt_driver);
+
+MODULE_ALIAS("platform:retu-wdt");
+MODULE_DESCRIPTION("Retu watchdog");
+MODULE_AUTHOR("Amit Kucheria");
+MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

