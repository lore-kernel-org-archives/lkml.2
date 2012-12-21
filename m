Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2LULfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:35:41 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14478 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2LULey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:34:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 21 Dec 2012 03:33:06 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>, <dev@lynxeye.de>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv4 8/8] gpu: host1x: Register DRM dummy device
Date: Fri, 21 Dec 2012 13:39:24 +0200
Message-ID: <1356089964-5265-9-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a dummy device for tegradrm, and provide a getter to
access the device.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c   |    5 ++++-
 drivers/gpu/drm/tegra/drm.c  |   11 +--------
 drivers/gpu/drm/tegra/gr2d.c |    4 +++-
 drivers/gpu/drm/tegra/hdmi.c |    5 ++++-
 drivers/gpu/host1x/Makefile  |    3 ++-
 drivers/gpu/host1x/dev.c     |    9 ++++++++
 drivers/gpu/host1x/dev.h     |    2 ++
 drivers/gpu/host1x/drm.c     |   51 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/drm.h     |   25 +++++++++++++++++++++
 include/linux/host1x.h       |    2 ++
 10 files changed, 103 insertions(+), 14 deletions(-)
 create mode 100644 drivers/gpu/host1x/drm.c
 create mode 100644 drivers/gpu/host1x/drm.h

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 24bcd06..d01be50 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/host1x.h>
 
 #include <mach/clk.h>
 
@@ -740,7 +741,9 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	struct resource *regs;
 	struct tegra_dc *dc;
 	int err;
-	struct tegradrm *tegradrm = platform_get_drvdata(pdev);
+	struct platform_device *drm_device =
+		host1x_drm_device(to_platform_device(pdev->dev.parent));
+	struct tegradrm *tegradrm = platform_get_drvdata(drm_device);
 
 	dc = devm_kzalloc(&pdev->dev, sizeof(*dc), GFP_KERNEL);
 	if (!dc)
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 637b621..d64935d 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -56,7 +56,6 @@ static int tegra_drm_add_client(struct device *dev, void *data)
 			client->np = of_node_get(dev->of_node);
 
 			list_add_tail(&client->list, &tegradrm->drm_clients);
-			dev_set_drvdata(dev, tegradrm);
 		}
 	}
 
@@ -258,16 +257,10 @@ static struct platform_driver tegra_drm_platform_driver = {
 static int __init tegra_drm_init(void)
 {
 	int err;
-	struct platform_device *drm_device;
-
-	drm_device = platform_device_register_simple("tegradrm", -1, NULL, 0);
-	if (!drm_device)
-		return -ENOMEM;
-	dma_set_coherent_mask(&drm_device->dev, DMA_BIT_MASK(32));
 
 	err = platform_driver_register(&tegra_drm_platform_driver);
 	if (err < 0)
-		goto unregister_tegra_dev;
+		return err;
 
 	err = platform_driver_register(&tegra_dc_driver);
 	if (err < 0)
@@ -288,8 +281,6 @@ unregister_dc:
 	platform_driver_unregister(&tegra_dc_driver);
 unregister_tegra_drv:
 	platform_driver_unregister(&tegra_drm_platform_driver);
-unregister_tegra_dev:
-	platform_device_unregister(drm_device);
 	return err;
 }
 module_init(tegra_drm_init);
diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index 8865099..a936902 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -247,7 +247,9 @@ static int __devinit gr2d_probe(struct platform_device *dev)
 {
 	int err;
 	struct gr2d *gr2d = NULL;
-	struct tegradrm *tegradrm = platform_get_drvdata(dev);
+	struct platform_device *drm_device =
+		host1x_drm_device(to_platform_device(dev->dev.parent));
+	struct tegradrm *tegradrm = platform_get_drvdata(drm_device);
 
 	gr2d = devm_kzalloc(&dev->dev, sizeof(*gr2d), GFP_KERNEL);
 	if (!gr2d)
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index fce3e66..a90a76f 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
+#include <linux/host1x.h>
 
 #include <mach/clk.h>
 
@@ -1214,7 +1215,9 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 	struct tegra_hdmi *hdmi;
 	struct resource *regs;
 	int err;
-	struct tegradrm *tegradrm = platform_get_drvdata(pdev);
+	struct platform_device *drm_device =
+		host1x_drm_device(to_platform_device(pdev->dev.parent));
+	struct tegradrm *tegradrm = platform_get_drvdata(drm_device);
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 049c07a..f8749fb 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -10,7 +10,8 @@ host1x-y = \
 	job.o \
 	debug.o \
 	memmgr.o \
-	hw/host1x01.o
+	hw/host1x01.o \
+	drm.o
 
 host1x-$(CONFIG_TEGRA_HOST1X_CMA) += cma.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 8d710ef..07e8813 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -25,6 +25,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include "dev.h"
+#include "drm.h"
 #include "intr.h"
 #include "channel.h"
 #include "debug.h"
@@ -145,6 +146,12 @@ static int host1x_probe(struct platform_device *dev)
 
 	/* set common host1x device data */
 	platform_set_drvdata(dev, host);
+
+	/* Alloc DRM device */
+	err = host1x_register_drm_device(host);
+	if (err)
+		goto fail;
+
 	host->regs = devm_request_and_ioremap(&dev->dev, regs);
 	if (!host->regs) {
 		dev_err(&dev->dev, "failed to remap host registers\n");
@@ -203,6 +210,7 @@ static int host1x_probe(struct platform_device *dev)
 
 fail:
 	host1x_syncpt_free(host->nop_sp);
+	host1x_unregister_drm_device(host);
 	kfree(host);
 	return err;
 }
@@ -212,6 +220,7 @@ static int __exit host1x_remove(struct platform_device *dev)
 	struct host1x *host = platform_get_drvdata(dev);
 	host1x_intr_deinit(&host->intr);
 	host1x_syncpt_deinit(host);
+	host1x_unregister_drm_device(host);
 	clk_disable_unprepare(host->clk);
 	return 0;
 }
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index aa5182e..05f8544 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -143,6 +143,8 @@ struct host1x {
 	int allocated_channels;
 
 	struct dentry *debugfs;
+
+	struct platform_device *drm_device;
 };
 
 static inline
diff --git a/drivers/gpu/host1x/drm.c b/drivers/gpu/host1x/drm.c
new file mode 100644
index 0000000..eaaaeed
--- /dev/null
+++ b/drivers/gpu/host1x/drm.c
@@ -0,0 +1,51 @@
+/*
+ * Tegra host1x driver DRM dummy device
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include "drm.h"
+#include "dev.h"
+
+int host1x_register_drm_device(struct host1x *host1x)
+{
+	struct platform_device *drm_device;
+
+	drm_device = platform_device_register_simple("tegradrm", -1, NULL, 0);
+	if (!drm_device)
+		return -ENOMEM;
+	dma_set_coherent_mask(&drm_device->dev, DMA_BIT_MASK(32));
+
+	host1x->drm_device = drm_device;
+	return 0;
+}
+EXPORT_SYMBOL(host1x_register_drm_device);
+
+void host1x_unregister_drm_device(struct host1x *host1x)
+{
+	if (host1x->drm_device)
+		platform_device_unregister(host1x->drm_device);
+}
+EXPORT_SYMBOL(host1x_unregister_drm_device);
+
+struct platform_device *host1x_drm_device(struct platform_device *pdev)
+{
+	struct host1x *host = platform_get_drvdata(pdev);
+	return host->drm_device;
+}
+EXPORT_SYMBOL(host1x_drm_device);
diff --git a/drivers/gpu/host1x/drm.h b/drivers/gpu/host1x/drm.h
new file mode 100644
index 0000000..84a827e
--- /dev/null
+++ b/drivers/gpu/host1x/drm.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HOST1X_DRM_H
+#define HOST1X_DRM_H
+
+struct host1x;
+
+int host1x_register_drm_device(struct host1x *host1x);
+void host1x_unregister_drm_device(struct host1x *host1x);
+
+#endif
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index a58c798..0906c19f 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -212,4 +212,6 @@ struct host1x_syncpt *host1x_syncpt_alloc(struct platform_device *pdev,
 		int client_managed);
 void host1x_syncpt_free(struct host1x_syncpt *sp);
 
+struct platform_device *host1x_drm_device(struct platform_device *pdev);
+
 #endif
-- 
1.7.9.5

