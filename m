Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2JEKHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:07:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50900 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab2JEKHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:07:34 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <olof@lixom.net>,
        <rdunlap@xenotime.net>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH 1/3] drivers: bus: ocp2scp: add pdata support
Date: Fri, 5 Oct 2012 15:37:06 +0530
Message-ID: <1349431628-2819-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349431628-2819-1-git-send-email-kishon@ti.com>
References: <1349431628-2819-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocp2scp was not having pdata support which makes *musb* fail for non-dt
boot in OMAP platform. The pdata will have information about the devices
that is connected to ocp2scp. ocp2scp driver will now make use of this
information to create the devices that is attached to ocp2scp.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/bus/omap-ocp2scp.c                 |   67 ++++++++++++++++++++++++++--
 include/linux/platform_data/omap_ocp2scp.h |   31 +++++++++++++
 2 files changed, 95 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/platform_data/omap_ocp2scp.h

diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
index ff63560..5db8297 100644
--- a/drivers/bus/omap-ocp2scp.c
+++ b/drivers/bus/omap-ocp2scp.c
@@ -22,6 +22,26 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
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
 
 static int ocp2scp_remove_devices(struct device *dev, void *c)
 {
@@ -34,20 +54,61 @@ static int ocp2scp_remove_devices(struct device *dev, void *c)
 
 static int __devinit omap_ocp2scp_probe(struct platform_device *pdev)
 {
-	int			ret;
-	struct device_node	*np = pdev->dev.of_node;
+	int ret;
+	unsigned res_cnt, i;
+	struct device_node *np = pdev->dev.of_node;
+	struct platform_device *pdev_child;
+	struct omap_ocp2scp_platform_data *pdata = pdev->dev.platform_data;
+	struct omap_ocp2scp_dev *dev;
 
 	if (np) {
 		ret = of_platform_populate(np, NULL, NULL, &pdev->dev);
 		if (ret) {
-			dev_err(&pdev->dev, "failed to add resources for ocp2scp child\n");
+			dev_err(&pdev->dev,
+			    "failed to add resources for ocp2scp child\n");
 			goto err0;
 		}
+	} else if (pdata) {
+		for (i = 0, dev = *pdata->devices; i < pdata->dev_cnt; i++,
+		    dev++) {
+			res_cnt = _count_resources(dev->res);
+
+			pdev_child = platform_device_alloc(dev->drv_name, -1);
+			if (!pdev_child) {
+				dev_err(&pdev->dev,
+				  "failed to allocate mem for ocp2scp child\n");
+				goto err0;
+			}
+
+			ret = platform_device_add_resources(pdev_child,
+			    dev->res, res_cnt);
+			if (ret) {
+				dev_err(&pdev->dev,
+				 "failed to add resources for ocp2scp child\n");
+				goto err1;
+			}
+
+			pdev_child->dev.parent	= &pdev->dev;
+
+			ret = platform_device_add(pdev_child);
+			if (ret) {
+				dev_err(&pdev->dev,
+				   "failed to register ocp2scp child device\n");
+				goto err1;
+			}
+		}
+	} else {
+		dev_err(&pdev->dev, "OCP2SCP initialized without plat data\n");
+		return -EINVAL;
 	}
+
 	pm_runtime_enable(&pdev->dev);
 
 	return 0;
 
+err1:
+	platform_device_put(pdev_child);
+
 err0:
 	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
 
diff --git a/include/linux/platform_data/omap_ocp2scp.h b/include/linux/platform_data/omap_ocp2scp.h
new file mode 100644
index 0000000..5c6c393
--- /dev/null
+++ b/include/linux/platform_data/omap_ocp2scp.h
@@ -0,0 +1,31 @@
+/*
+ * omap_ocp2scp.h -- ocp2scp header file
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com
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
1.7.9.5

