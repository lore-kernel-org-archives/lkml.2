Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2BAN1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:27:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55335 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2BAN07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:26:59 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/3] watchdog: Add Congatec CGEB watchdog driver
Date: Wed,  1 Feb 2012 14:26:33 +0100
Message-Id: <1328102793-4313-4-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
References: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d076
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides support for the CGEB watchdog found on some
Congatec x86 modules.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/watchdog/Kconfig                  |    9 ++
 drivers/watchdog/Makefile                 |    1 +
 drivers/watchdog/congatec_cgeb_watchdog.c |  181 +++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/congatec_cgeb_watchdog.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79fd606..a1f35a5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -880,6 +880,15 @@ config SBC_EPX_C3_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called sbc_epx_c3.
 
+config CONGATEC_CGEB_WATCHDOG
+	tristate "Congatec CGEB watchdog"
+	---help---
+	  This driver provides support for the watchdogs found on Congatec
+	  modules with the CGEB BIOS interface.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called congatec_cgeb_wdt.
+
 # M32R Architecture
 
 # M68K Architecture
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index fe893e9..d0b2f1d 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -107,6 +107,7 @@ obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
+obj-$(CONFIG_CONGATEC_CGEB_WATCHDOG) += congatec_cgeb_watchdog.o
 
 # M32R Architecture
 
diff --git a/drivers/watchdog/congatec_cgeb_watchdog.c b/drivers/watchdog/congatec_cgeb_watchdog.c
new file mode 100644
index 0000000..a4be745
--- /dev/null
+++ b/drivers/watchdog/congatec_cgeb_watchdog.c
@@ -0,0 +1,181 @@
+/*
+ * CGEB watchdog driver
+ *
+ * (c) 2011 Sascha Hauer, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/mfd/congatec-cgeb.h>
+
+#define CGOS_WDOG_MODE_REBOOT_PC    0
+#define CGOS_WDOG_MODE_RESTART_OS   1
+#define CGOS_WDOG_MODE_STAGED    0x80
+
+#define CGOS_WDOG_OPMODE_DISABLED      0
+#define CGOS_WDOG_OPMODE_ONETIME_TRIG  1
+#define CGOS_WDOG_OPMODE_SINGLE_EVENT  2
+#define CGOS_WDOG_OPMODE_EVENT_REPEAT  3
+
+#define CGOS_WDOG_EVENT_INT 0	/* NMI/IRQ */
+#define CGOS_WDOG_EVENT_SCI 1	/* SMI/SCI */
+#define CGOS_WDOG_EVENT_RST 2	/* system reset */
+#define CGOS_WDOG_EVENT_BTN 3	/* power button */
+
+#define CGOS_WDOG_EVENT_MAX_STAGES 3
+
+struct cgeb_watchdog_stage {
+	unsigned long timeout;
+	unsigned long event;
+};
+
+struct cgeb_watchdog_config {
+	unsigned long size;
+	unsigned long timeout; /* not used in staged mode */
+	unsigned long delay;
+	unsigned long mode;
+	/* optional parameters for staged watchdog */
+	unsigned long op_mode;
+	unsigned long stage_count;
+	struct cgeb_watchdog_stage stages[CGOS_WDOG_EVENT_MAX_STAGES];
+};
+
+struct cgeb_watchdog_priv {
+	struct cgeb_board_data	*board;
+	struct watchdog_device	wdd;
+	unsigned int		timeout_s;
+	int unit;
+};
+
+static struct watchdog_info cgeb_wdd_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.firmware_version = 0,
+	.identity = "cgeb watchdog",
+};
+
+static unsigned int watchdog_set_config(struct cgeb_watchdog_priv *priv,
+		unsigned int timeout_s)
+{
+	struct cgeb_board_data *board = priv->board;
+	struct cgeb_watchdog_config wdi;
+	struct cgeb_function_parameters fps;
+
+	memset(&wdi, 0, sizeof(wdi));
+	memset(&fps, 0, sizeof(fps));
+
+	fps.unit = priv->unit;
+	fps.iptr = &wdi;
+
+	wdi.timeout = timeout_s * 1000;
+	wdi.delay = 0;
+	wdi.size = sizeof(wdi);
+	wdi.mode = CGOS_WDOG_MODE_REBOOT_PC;
+
+	return cgeb_call(board, &fps, CgebWDogSetConfig);
+}
+
+static int cgeb_watchdog_start(struct watchdog_device *wdd)
+{
+	struct cgeb_watchdog_priv *priv = watchdog_get_drvdata(wdd);
+
+	return watchdog_set_config(priv, priv->timeout_s);
+}
+
+static int cgeb_watchdog_stop(struct watchdog_device *wdd)
+{
+	struct cgeb_watchdog_priv *priv = watchdog_get_drvdata(wdd);
+
+	return watchdog_set_config(priv, 0);
+}
+
+static int cgeb_watchdog_set_timeout(struct watchdog_device *wdd,
+		unsigned int timeout_s)
+{
+	struct cgeb_watchdog_priv *priv = watchdog_get_drvdata(wdd);
+
+	if (!timeout_s)
+		return -EINVAL;
+
+	priv->timeout_s = timeout_s;
+
+	return 0;
+}
+
+struct watchdog_ops cgeb_watchdog_ops = {
+	.start = cgeb_watchdog_start,
+	.stop = cgeb_watchdog_stop,
+	.set_timeout = cgeb_watchdog_set_timeout,
+};
+
+static int __devinit cgeb_watchdog_probe(struct platform_device *pdev)
+{
+	struct cgeb_watchdog_priv *priv;
+	struct cgeb_pdata *pdata = pdev->dev.platform_data;
+	int ret;
+
+	dev_info(&pdev->dev, "registering\n");
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->wdd.ops = &cgeb_watchdog_ops;
+	priv->wdd.info = &cgeb_wdd_info;
+	priv->wdd.min_timeout = 1;
+	priv->wdd.max_timeout = 3600;
+	priv->board = pdata->board;
+	priv->unit = pdata->unit;
+
+	watchdog_set_drvdata(&priv->wdd, priv);
+	platform_set_drvdata(pdev, priv);
+
+	ret = watchdog_register_device(&priv->wdd);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int __devexit cgeb_watchdog_remove(struct platform_device *pdev)
+{
+	struct cgeb_watchdog_priv *priv = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&priv->wdd);
+
+	return 0;
+}
+
+static struct platform_driver cgeb_watchdog_driver = {
+	.probe		= cgeb_watchdog_probe,
+	.remove		= __exit_p(cgeb_watchdog_remove),
+	.driver	= {
+		.name	= "cgeb-watchdog",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init cgeb_watchdog_driver_init(void)
+{
+	return platform_driver_register(&cgeb_watchdog_driver);
+}
+
+static void __exit cgeb_watchdog_driver_exit(void)
+{
+	platform_driver_unregister(&cgeb_watchdog_driver);
+}
+
+module_init(cgeb_watchdog_driver_init);
+module_exit(cgeb_watchdog_driver_exit);
+
+MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
+MODULE_DESCRIPTION("cgeb watchdog driver");
+MODULE_LICENSE("GPL");
-- 
1.7.2.5

