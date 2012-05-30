Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2E3K5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:57:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34516 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2E3K5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:57:13 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <paul@pwsan.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: [RFC PATCH 3/5] drivers: misc: omap: add a new driver for ocp2scp
Date: Wed, 30 May 2012 16:26:32 +0530
Message-ID: <1338375394-16268-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338375394-16268-1-git-send-email-kishon@ti.com>
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new driver _ocp2scp_. This driver takes the responsibility of creating
all the devices that is connected to OCP2SCP. In the case of OMAP4, USB2PHY
is connected to ocp2scp.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/misc/Kconfig                       |    8 ++
 drivers/misc/Makefile                      |    1 +
 drivers/misc/omap-ocp2scp.c                |  135 ++++++++++++++++++++++++++++
 include/linux/platform_data/omap_ocp2scp.h |   31 +++++++
 4 files changed, 175 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/omap-ocp2scp.c
 create mode 100644 include/linux/platform_data/omap_ocp2scp.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2661f6e..c70aa15 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -508,6 +508,14 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.
 
+config OMAP_OCP2SCP
+	tristate "OMAP OCP2SCP DRIVER"
+	help
+	  Driver to enable ocp2scp module which transforms ocp interface
+	  protocol to scp protocol. In OMAP4, USB PHY is connected via
+	  OCP2SCP and in OMAP5, both USB PHY and SATA PHY is connected via
+	  OCP2SCP.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 456972f..4d7c8ce 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -50,4 +50,5 @@ obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
+obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
 obj-$(CONFIG_INTEL_MEI)		+= mei/
diff --git a/drivers/misc/omap-ocp2scp.c b/drivers/misc/omap-ocp2scp.c
new file mode 100644
index 0000000..c53b9f4
--- /dev/null
+++ b/drivers/misc/omap-ocp2scp.c
@@ -0,0 +1,135 @@
+/*
+ * omap-ocp2scp.c - transform ocp interface protocol to scp protocol
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/pm_runtime.h>
+#include <linux/platform_data/omap_ocp2scp.h>
+
+/**
+ * _count_resources - count for the number of resources
+ * @res: struct resource *
+ *
+ * Count and return the number of resources populated for the device that is
+ * connected to ocp2scp.
+ */
+static unsigned _count_resources(struct resource *res)
+{
+	int cnt	= 0;
+
+	while (res->start != res->end) {
+		cnt++;
+		res++;
+	}
+
+	return cnt;
+}
+
+static int ocp2scp_remove_devices(struct device *dev, void *c)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	platform_device_unregister(pdev);
+
+	return 0;
+}
+
+static int __devinit omap_ocp2scp_probe(struct platform_device *pdev)
+{
+	int					ret;
+	unsigned				res_cnt, i;
+	struct platform_device			*pdev_child;
+	struct omap_ocp2scp_platform_data	*pdata;
+	struct omap_ocp2scp_dev			*dev;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "OCP2SCP initialized without plat data\n");
+		return -EINVAL;
+	}
+
+	for (i = 0, dev = *pdata->devices; i < pdata->dev_cnt; i++, dev++) {
+		res_cnt = _count_resources(dev->res);
+
+		pdev_child = platform_device_alloc(dev->drv_name, -1);
+		if (!pdev_child) {
+			dev_err(&pdev->dev, "failed to allocate memory for ocp2scp child\n");
+			return -ENOMEM;
+		}
+
+		ret = platform_device_add_resources(pdev_child, dev->res,
+								res_cnt);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to add resources for ocp2scp child\n");
+			goto err0;
+		}
+
+		pdev_child->dev.parent	= &pdev->dev;
+
+		ret = platform_device_add(pdev_child);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to register ocp2scp child device\n");
+			goto err0;
+		}
+	}
+
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+
+err0:
+	platform_device_put(pdev_child);
+	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
+
+	return ret;
+}
+
+static int __devexit omap_ocp2scp_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
+
+	return 0;
+}
+
+static struct platform_driver omap_ocp2scp_driver = {
+	.probe		= omap_ocp2scp_probe,
+	.remove		= __devexit_p(omap_ocp2scp_remove),
+	.driver		= {
+		.name	= "omap-ocp2scp",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init omap_ocp2scp_init(void)
+{
+	return platform_driver_register(&omap_ocp2scp_driver);
+}
+arch_initcall(omap_ocp2scp_init);
+
+static void __exit omap_ocp2scp_exit(void)
+{
+	platform_driver_unregister(&omap_ocp2scp_driver);
+}
+module_exit(omap_ocp2scp_exit);
+
+MODULE_ALIAS("platform: omap-ocp2scp");
+MODULE_AUTHOR("Kishon Vijay Abraham I <kishon@ti.com>");
+MODULE_DESCRIPTION("OMAP OCP2SCP DRIVER");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/omap_ocp2scp.h b/include/linux/platform_data/omap_ocp2scp.h
new file mode 100644
index 0000000..dcbbf2a
--- /dev/null
+++ b/include/linux/platform_data/omap_ocp2scp.h
@@ -0,0 +1,31 @@
+/*
+ * omap_ocp2scp.h -- ocp2scp header file
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __DRIVERS_OMAP_OCP2SCP_H
+#define __DRIVERS_OMAP_OCP2SCP_H
+
+struct omap_ocp2scp_dev {
+	const char			*drv_name;
+	struct resource			*res;
+};
+
+struct omap_ocp2scp_platform_data {
+	int				dev_cnt;
+	struct omap_ocp2scp_dev		**devices;
+};
+#endif /* __DRIVERS_OMAP_OCP2SCP_H */
-- 
1.7.5.4

