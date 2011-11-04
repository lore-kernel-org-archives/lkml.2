Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1KDOEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:04:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8367 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab1KDOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:04:45 -0400
X-AuditID: cbfee61b-b7b7fae000005864-87-4eb3f0fb2173
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@redhat.com
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com, jy0922.shim@samsung.com,
        inki.dae@samsung.com, t.stanislaws@samsung.com
Subject: [RFC] drm/exynos: added hdmi display support
Date: Fri, 04 Nov 2011 23:04:50 +0900
Message-id: <1320415490-9810-1-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 04 Nov 2011 14:04:28.0863 (UTC)
 FILETIME=[AB04ECF0:01CC9AFA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patch is hdmi display support for exynos drm driver.

This patch is based on previous exynos drm patch and here is link for it:
https://lkml.org/lkml/2011/11/4/115


There is already v4l2 based exynos hdmi driver in drivers/media/video/s5p-tv
and some low level code is already in s5p-tv and even headers for register
define are almost same. but in this RFC, we decide not to consider separated
common code with s5p-tv.


Exynos HDMI is composed of 5 blocks, mixer, vp, hdmi, hdmiphy and ddc.

1. mixer. The piece of hardware responsible for mixing and blending multiple
data inputs before passing it to an output device.  The mixer is capable of
handling up to three image layers. One is the output of VP.  Other two are
images in RGB format.  The blending factor, and layers' priority are controlled
by mixer's registers. The output is passed to HDMI.

2. vp (video processor). It is used for processing of NV12 data.  An image
stored in RAM is accessed by DMA. The output in YCbCr444 format is send to
mixer.

3. hdmi. The piece of HW responsible for generation of HDMI packets. It takes
pixel data from mixer and transforms it into data frames. The output is send
to HDMIPHY interface.

4. hdmiphy. Physical interface for HDMI. Its duties are sending HDMI packets to
HDMI connector. Basically, it contains a PLL that produces source clock for
mixer, vp and hdmi.

5. ddc (display data channel). It is dedicated i2c channel to exchange display
information as edid with display monitor.

Current version does not fully support two mixer layes and vp layer. For
supporting multi laters, we are trying with Jesse's drm plane patch and it will
be sent as other RFC. Currently only default mixer layer is displayed.

In this RFC, common drm_hdmi driver has opertion pointers for mixer and hdmi
and hdmi has hdmiphy and ddc i2c clients and controls them. and drm_hdmi driver
is registered as sub driver of exynos_drm.

Vblank interrupts for fimd and hdmi are handled by each display driver
internally because drm framework cannot support multiple irq id. And pipe number
is used to check what display device irq happens.


There are remaining things.
- drm plane feature support. Refer below link.
  http://thread.gmane.org/gmane.comp.video.dri.devel/61821
- multi planar format support for vp layer
- common low level code with v4l2 s5p-tv driver
- code clean


We would be pleased you to give us any comments.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/exynos/Kconfig           |    7 +
 drivers/gpu/drm/exynos/Makefile          |    2 +
 drivers/gpu/drm/exynos/exynos_ddc.c      |   62 ++
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c |  396 ++++++++++
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h |   73 ++
 drivers/gpu/drm/exynos/exynos_hdmi.c     | 1181 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/exynos/exynos_hdmi.h     |   89 +++
 drivers/gpu/drm/exynos/exynos_hdmiphy.c  |   62 ++
 drivers/gpu/drm/exynos/exynos_mixer.c    |  822 +++++++++++++++++++++
 drivers/gpu/drm/exynos/exynos_mixer.h    |   87 +++
 drivers/gpu/drm/exynos/regs-hdmi.h       |  147 ++++
 drivers/gpu/drm/exynos/regs-mixer.h      |  139 ++++
 drivers/gpu/drm/exynos/regs-vp.h         |   91 +++
 include/drm/exynos_drm.h                 |   27 +
 14 files changed, 3185 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpu/drm/exynos/exynos_ddc.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_hdmi.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_drm_hdmi.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_hdmi.h
 create mode 100644 drivers/gpu/drm/exynos/exynos_hdmiphy.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_mixer.c
 create mode 100644 drivers/gpu/drm/exynos/exynos_mixer.h
 create mode 100644 drivers/gpu/drm/exynos/regs-hdmi.h
 create mode 100644 drivers/gpu/drm/exynos/regs-mixer.h
 create mode 100644 drivers/gpu/drm/exynos/regs-vp.h

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 847466a..f9aaa56 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -18,3 +18,10 @@ config DRM_EXYNOS_FIMD
 	help
 	  Choose this option if you want to use Exynos FIMD for DRM.
 	  If M is selected, the module will be called exynos_drm_fimd
+
+config DRM_EXYNOS_HDMI
+	tristate "Exynos DRM HDMI"
+	depends on DRM_EXYNOS
+	help
+	  Choose this option if you want to use Exynos HDMI for DRM.
+	  If M is selected, the module will be called exynos_drm_hdmi
diff --git a/drivers/gpu/drm/exynos/Makefile b/drivers/gpu/drm/exynos/Makefile
index 0496d3f..85cfef6 100644
--- a/drivers/gpu/drm/exynos/Makefile
+++ b/drivers/gpu/drm/exynos/Makefile
@@ -9,3 +9,5 @@ exynosdrm-y := exynos_drm_drv.o exynos_drm_encoder.o exynos_drm_connector.o \
 
 obj-$(CONFIG_DRM_EXYNOS) += exynosdrm.o
 obj-$(CONFIG_DRM_EXYNOS_FIMD) += exynos_drm_fimd.o
+obj-$(CONFIG_DRM_EXYNOS_HDMI) += exynos_hdmi.o exynos_mixer.o exynos_ddc.o \
+				 exynos_hdmiphy.o exynos_drm_hdmi.o
diff --git a/drivers/gpu/drm/exynos/exynos_ddc.c b/drivers/gpu/drm/exynos/exynos_ddc.c
new file mode 100644
index 0000000..496410a
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_ddc.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2011 Samsung Electronics Co.Ltd
+ * Authors:
+ *	Seung-Woo Kim <sw0312.kim@samsung.com>
+ *	Inki Dae <inki.dae@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include "drmP.h"
+
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+
+
+#include "exynos_drm_drv.h"
+#include "exynos_hdmi.h"
+
+static int s5p_ddc_probe(struct i2c_client *client,
+			const struct i2c_device_id *dev_id)
+{
+	hdmi_attach_ddc_client(client);
+
+	/* TODO. */
+
+	dev_info(&client->adapter->dev, "attached s5p_ddc "
+		"into i2c adapter successfully\n");
+
+	return 0;
+}
+
+static int s5p_ddc_remove(struct i2c_client *client)
+{
+	dev_info(&client->adapter->dev, "detached s5p_ddc "
+		"from i2c adapter successfully\n");
+
+	/* TODO. */
+
+	return 0;
+}
+
+static struct i2c_device_id ddc_idtable[] = {
+	{"s5p_ddc", 0},
+	{ },
+};
+
+struct i2c_driver ddc_driver = {
+	.driver = {
+		.name = "s5p_ddc",
+		.owner = THIS_MODULE,
+	},
+	.id_table	= ddc_idtable,
+	.probe		= s5p_ddc_probe,
+	.remove		= __devexit_p(s5p_ddc_remove),
+	.command		= NULL,
+};
+EXPORT_SYMBOL(ddc_driver);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_hdmi.c b/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
new file mode 100644
index 0000000..794dffb
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_drm_hdmi.c
@@ -0,0 +1,396 @@
+/*
+ * Copyright (C) 2011 Samsung Electronics Co.Ltd
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Seung-Woo Kim <sw0312.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include "drmP.h"
+
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include <drm/exynos_drm.h>
+
+#include "exynos_drm_drv.h"
+#include "exynos_drm_hdmi.h"
+
+#define to_context(dev)		platform_get_drvdata(to_platform_device(dev))
+#define to_subdrv(dev)		to_context(dev)
+#define get_ctx_from_subdrv(subdrv)	container_of(subdrv,\
+					struct drm_hdmi_context, subdrv);
+
+/* these callback points shoud be set by specific drivers. */
+static struct exynos_hdmi_display_ops *hdmi_display_ops;
+static struct exynos_hdmi_manager_ops *hdmi_manager_ops;
+static struct exynos_hdmi_overlay_ops *hdmi_overlay_ops;
+
+struct drm_hdmi_context {
+	struct exynos_drm_subdrv	subdrv;
+	struct exynos_drm_hdmi_context	*hdmi_ctx;
+	struct exynos_drm_hdmi_context	*mixer_ctx;
+};
+
+void exynos_drm_display_ops_register(struct exynos_hdmi_display_ops
+					*display_ops)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (display_ops)
+		hdmi_display_ops = display_ops;
+}
+
+void exynos_drm_manager_ops_register(struct exynos_hdmi_manager_ops
+					*manager_ops)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (manager_ops)
+		hdmi_manager_ops = manager_ops;
+}
+
+void exynos_drm_overlay_ops_register(struct exynos_hdmi_overlay_ops
+					*overlay_ops)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (overlay_ops)
+		hdmi_overlay_ops = overlay_ops;
+}
+
+static bool drm_hdmi_is_connected(struct device *dev)
+{
+	struct drm_hdmi_context *ctx = to_context(dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_display_ops && hdmi_display_ops->is_connected)
+		return hdmi_display_ops->is_connected(ctx->hdmi_ctx->ctx);
+
+	return false;
+}
+
+static int drm_hdmi_get_edid(struct device *dev,
+		struct drm_connector *connector, u8 *edid, int len)
+{
+	struct drm_hdmi_context *ctx = to_context(dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_display_ops && hdmi_display_ops->get_edid)
+		return hdmi_display_ops->get_edid(ctx->hdmi_ctx->ctx,
+				connector, edid, len);
+
+	return 0;
+}
+
+static int drm_hdmi_check_timing(struct device *dev, void *timing)
+{
+	struct drm_hdmi_context *ctx = to_context(dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_display_ops && hdmi_display_ops->check_timing)
+		return hdmi_display_ops->check_timing(ctx->hdmi_ctx->ctx,
+				timing);
+
+	return 0;
+}
+
+static int drm_hdmi_power_on(struct device *dev, int mode)
+{
+	struct drm_hdmi_context *ctx = to_context(dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_display_ops && hdmi_display_ops->power_on)
+		return hdmi_display_ops->power_on(ctx->hdmi_ctx->ctx, mode);
+
+	return 0;
+}
+
+static struct exynos_drm_display_ops drm_hdmi_display_ops = {
+	.type = EXYNOS_DISPLAY_TYPE_HDMI,
+	.is_connected = drm_hdmi_is_connected,
+	.get_edid = drm_hdmi_get_edid,
+	.check_timing = drm_hdmi_check_timing,
+	.power_on = drm_hdmi_power_on,
+};
+
+static int drm_hdmi_enable_vblank(struct device *subdrv_dev)
+{
+	struct drm_hdmi_context *ctx = to_context(subdrv_dev);
+	struct exynos_drm_subdrv *subdrv = &ctx->subdrv;
+	struct exynos_drm_manager *manager = &subdrv->manager;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_overlay_ops && hdmi_overlay_ops->enable_vblank)
+		return hdmi_overlay_ops->enable_vblank(ctx->mixer_ctx->ctx,
+							manager->pipe);
+
+	return 0;
+}
+
+static void drm_hdmi_disable_vblank(struct device *subdrv_dev)
+{
+	struct drm_hdmi_context *ctx = to_context(subdrv_dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_overlay_ops && hdmi_overlay_ops->disable_vblank)
+		return hdmi_overlay_ops->disable_vblank(ctx->mixer_ctx->ctx);
+}
+
+static void drm_hdmi_mode_set(struct device *subdrv_dev, void *mode)
+{
+	struct drm_hdmi_context *ctx = to_context(subdrv_dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_manager_ops && hdmi_manager_ops->mode_set)
+		hdmi_manager_ops->mode_set(ctx->hdmi_ctx->ctx, mode);
+}
+
+static void drm_hdmi_commit(struct device *subdrv_dev)
+{
+	struct drm_hdmi_context *ctx = to_context(subdrv_dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_manager_ops && hdmi_manager_ops->commit)
+		hdmi_manager_ops->commit(ctx->hdmi_ctx->ctx);
+}
+
+static struct exynos_drm_manager_ops drm_hdmi_manager_ops = {
+	.enable_vblank = drm_hdmi_enable_vblank,
+	.disable_vblank = drm_hdmi_disable_vblank,
+	.mode_set = drm_hdmi_mode_set,
+	.commit = drm_hdmi_commit,
+};
+
+static void drm_mixer_mode_set(struct device *subdrv_dev,
+		struct exynos_drm_overlay *overlay)
+{
+	struct drm_hdmi_context *ctx = to_context(subdrv_dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_overlay_ops && hdmi_overlay_ops->win_mode_set)
+		hdmi_overlay_ops->win_mode_set(ctx->mixer_ctx->ctx, overlay);
+}
+
+static void drm_mixer_commit(struct device *subdrv_dev)
+{
+	struct drm_hdmi_context *ctx = to_context(subdrv_dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_overlay_ops && hdmi_overlay_ops->win_commit)
+		hdmi_overlay_ops->win_commit(ctx->mixer_ctx->ctx);
+}
+
+static void drm_mixer_disable(struct device *subdrv_dev)
+{
+	struct drm_hdmi_context *ctx = to_context(subdrv_dev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (hdmi_overlay_ops && hdmi_overlay_ops->win_disable)
+		hdmi_overlay_ops->win_disable(ctx->mixer_ctx->ctx);
+}
+
+static struct exynos_drm_overlay_ops drm_hdmi_overlay_ops = {
+	.mode_set = drm_mixer_mode_set,
+	.commit = drm_mixer_commit,
+	.disable = drm_mixer_disable,
+};
+
+
+static int hdmi_subdrv_probe(struct drm_device *drm_dev,
+		struct device *dev)
+{
+	struct exynos_drm_subdrv *subdrv = to_subdrv(dev);
+	struct drm_hdmi_context *ctx;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_drm_common_hdmi_pd *pd;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	pd = pdev->dev.platform_data;
+
+	if (!pd) {
+		DRM_DEBUG_KMS("platform data is null.\n");
+		return -EFAULT;
+	}
+
+	if (!pd->hdmi_dev) {
+		DRM_DEBUG_KMS("hdmi device is null.\n");
+		return -EFAULT;
+	}
+
+	if (!pd->mixer_dev) {
+		DRM_DEBUG_KMS("mixer device is null.\n");
+		return -EFAULT;
+	}
+
+	ret = platform_driver_register(&hdmi_driver);
+	if (ret) {
+		DRM_DEBUG_KMS("failed to register hdmi driver.\n");
+		return ret;
+	}
+
+	ret = platform_driver_register(&mixer_driver);
+	if (ret) {
+		DRM_DEBUG_KMS("failed to register mixer driver.\n");
+		goto err_hdmidrv;
+	}
+
+	ctx = get_ctx_from_subdrv(subdrv);
+
+	ctx->hdmi_ctx = (struct exynos_drm_hdmi_context *)
+				to_context(pd->hdmi_dev);
+	if (!ctx->hdmi_ctx) {
+		DRM_DEBUG_KMS("hdmi context is null.\n");
+		ret = -EFAULT;
+		goto err_mixerdrv;
+	}
+
+	ctx->hdmi_ctx->drm_dev = drm_dev;
+
+	ctx->mixer_ctx = (struct exynos_drm_hdmi_context *)
+				to_context(pd->mixer_dev);
+	if (!ctx->mixer_ctx) {
+		DRM_DEBUG_KMS("mixer context is null.\n");
+		ret = -EFAULT;
+		goto err_mixerdrv;
+	}
+
+	ctx->mixer_ctx->drm_dev = drm_dev;
+
+	return 0;
+
+err_mixerdrv:
+	platform_driver_unregister(&mixer_driver);
+err_hdmidrv:
+	platform_driver_unregister(&hdmi_driver);
+	return ret;
+}
+
+static void hdmi_subdrv_remove(struct drm_device *drm_dev)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	platform_driver_unregister(&hdmi_driver);
+	platform_driver_unregister(&mixer_driver);
+}
+
+static int __devinit exynos_drm_hdmi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct exynos_drm_subdrv *subdrv;
+	struct drm_hdmi_context *ctx;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		DRM_LOG_KMS("failed to alloc common hdmi context.\n");
+		return -ENOMEM;
+	}
+
+	subdrv = &ctx->subdrv;
+
+	subdrv->probe = hdmi_subdrv_probe;
+	subdrv->remove = hdmi_subdrv_remove;
+	subdrv->manager.pipe = -1;
+	subdrv->manager.ops = &drm_hdmi_manager_ops;
+	subdrv->manager.overlay_ops = &drm_hdmi_overlay_ops;
+	subdrv->manager.display_ops = &drm_hdmi_display_ops;
+	subdrv->manager.dev = dev;
+
+	platform_set_drvdata(pdev, subdrv);
+
+	exynos_drm_subdrv_register(subdrv);
+
+	return 0;
+}
+
+static int hdmi_runtime_suspend(struct device *dev)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	return 0;
+}
+
+static int hdmi_runtime_resume(struct device *dev)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	return 0;
+}
+
+static const struct dev_pm_ops hdmi_pm_ops = {
+	.runtime_suspend = hdmi_runtime_suspend,
+	.runtime_resume	 = hdmi_runtime_resume,
+};
+
+static int __devexit exynos_drm_hdmi_remove(struct platform_device *pdev)
+{
+	struct drm_hdmi_context *ctx = platform_get_drvdata(pdev);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	exynos_drm_subdrv_unregister(&ctx->subdrv);
+	kfree(ctx);
+
+	return 0;
+}
+
+static struct platform_driver exynos_drm_common_hdmi_driver = {
+	.probe		= exynos_drm_hdmi_probe,
+	.remove		= __devexit_p(exynos_drm_hdmi_remove),
+	.driver		= {
+		.name	= "exynos-drm-hdmi",
+		.owner	= THIS_MODULE,
+		.pm = &hdmi_pm_ops,
+	},
+};
+
+static int __init exynos_drm_hdmi_init(void)
+{
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	ret = platform_driver_register(&exynos_drm_common_hdmi_driver);
+	if (ret) {
+		DRM_DEBUG_KMS("failed to register hdmi common driver.\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void __exit exynos_drm_hdmi_exit(void)
+{
+	platform_driver_unregister(&exynos_drm_common_hdmi_driver);
+}
+
+module_init(exynos_drm_hdmi_init);
+module_exit(exynos_drm_hdmi_exit);
+
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_AUTHOR("Seung-Woo Kim, <sw0312.kim@samsung.com>");
+MODULE_DESCRIPTION("Samsung SoC DRM HDMI Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/exynos/exynos_drm_hdmi.h b/drivers/gpu/drm/exynos/exynos_drm_hdmi.h
new file mode 100644
index 0000000..54a8b6b
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_drm_hdmi.h
@@ -0,0 +1,73 @@
+/* exynos_drm_hdmi.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authoer: Inki Dae <inki.dae@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _EXYNOS_DRM_HDMI_H_
+#define _EXYNOS_DRM_HDMI_H_
+
+/*
+ * exynos hdmi common context structure.
+ *
+ * @drm_dev: pointer to drm_device.
+ * @ctx: pointer to the context of specific device driver.
+ *	this context should be hdmi_context or mixer_context.
+ */
+struct exynos_drm_hdmi_context {
+	struct drm_device	*drm_dev;
+	void			*ctx;
+};
+
+struct exynos_hdmi_display_ops {
+	bool (*is_connected)(void *ctx);
+	int (*get_edid)(void *ctx, struct drm_connector *connector,
+			u8 *edid, int len);
+	int (*check_timing)(void *ctx, void *timing);
+	int (*power_on)(void *ctx, int mode);
+};
+
+struct exynos_hdmi_manager_ops {
+	void (*mode_set)(void *ctx, void *mode);
+	void (*commit)(void *ctx);
+	void (*disable)(void *ctx);
+};
+
+struct exynos_hdmi_overlay_ops {
+	int (*enable_vblank)(void *ctx, int pipe);
+	void (*disable_vblank)(void *ctx);
+	void (*win_mode_set)(void *ctx, struct exynos_drm_overlay *overlay);
+	void (*win_commit)(void *ctx);
+	void (*win_disable)(void *ctx);
+};
+
+extern struct platform_driver hdmi_driver;
+extern struct platform_driver mixer_driver;
+
+void exynos_drm_display_ops_register(struct exynos_hdmi_display_ops
+					*display_ops);
+void exynos_drm_manager_ops_register(struct exynos_hdmi_manager_ops
+					*manager_ops);
+void exynos_drm_overlay_ops_register(struct exynos_hdmi_overlay_ops
+					*overlay_ops);
+
+#endif
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
new file mode 100644
index 0000000..39508de
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -0,0 +1,1181 @@
+/*
+ * Copyright (C) 2011 Samsung Electronics Co.Ltd
+ * Authors:
+ * Seung-Woo Kim <sw0312.kim@samsung.com>
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * Based on drivers/media/video/s5p-tv/hdmi_drv.c
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include "drmP.h"
+#include "drm_edid.h"
+#include "drm_crtc_helper.h"
+
+#include "regs-hdmi.h"
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+
+#include <drm/exynos_drm.h>
+
+#include "exynos_drm_drv.h"
+#include "exynos_drm_hdmi.h"
+
+#include "exynos_hdmi.h"
+
+#define HDMI_OVERLAY_NUMBER	3
+#define get_hdmi_context(dev)	platform_get_drvdata(to_platform_device(dev))
+
+static const u8 hdmiphy_conf27[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+	0x6B, 0x10, 0x02, 0x51, 0xDF, 0xF2, 0x54, 0x87,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xE3, 0x26, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf27_027[32] = {
+	0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x09, 0x64,
+	0x6B, 0x10, 0x02, 0x51, 0xDF, 0xF2, 0x54, 0x87,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xE3, 0x26, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf74_175[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+	0x6D, 0x10, 0x01, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa5, 0x26, 0x01, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf74_25[32] = {
+	0x01, 0x05, 0x00, 0xd8, 0x10, 0x9c, 0xf8, 0x40,
+	0x6a, 0x10, 0x01, 0x51, 0xff, 0xf1, 0x54, 0xba,
+	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xe0,
+	0x22, 0x40, 0xa4, 0x26, 0x01, 0x00, 0x00, 0x00,
+};
+
+static const u8 hdmiphy_conf148_5[32] = {
+	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
+	0x6A, 0x18, 0x00, 0x51, 0xff, 0xF1, 0x54, 0xba,
+	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+	0x22, 0x40, 0xa4, 0x26, 0x02, 0x00, 0x00, 0x00,
+};
+
+struct hdmi_tg_regs {
+	u8 cmd;
+	u8 h_fsz_l;
+	u8 h_fsz_h;
+	u8 hact_st_l;
+	u8 hact_st_h;
+	u8 hact_sz_l;
+	u8 hact_sz_h;
+	u8 v_fsz_l;
+	u8 v_fsz_h;
+	u8 vsync_l;
+	u8 vsync_h;
+	u8 vsync2_l;
+	u8 vsync2_h;
+	u8 vact_st_l;
+	u8 vact_st_h;
+	u8 vact_sz_l;
+	u8 vact_sz_h;
+	u8 field_chg_l;
+	u8 field_chg_h;
+	u8 vact_st2_l;
+	u8 vact_st2_h;
+	u8 vsync_top_hdmi_l;
+	u8 vsync_top_hdmi_h;
+	u8 vsync_bot_hdmi_l;
+	u8 vsync_bot_hdmi_h;
+	u8 field_top_hdmi_l;
+	u8 field_top_hdmi_h;
+	u8 field_bot_hdmi_l;
+	u8 field_bot_hdmi_h;
+};
+
+struct hdmi_core_regs {
+	u8 h_blank[2];
+	u8 v_blank[3];
+	u8 h_v_line[3];
+	u8 vsync_pol[1];
+	u8 int_pro_mode[1];
+	u8 v_blank_f[3];
+	u8 h_sync_gen[3];
+	u8 v_sync_gen1[3];
+	u8 v_sync_gen2[3];
+	u8 v_sync_gen3[3];
+};
+
+struct hdmi_preset_conf {
+	struct hdmi_core_regs core;
+	struct hdmi_tg_regs tg;
+};
+
+static const struct hdmi_preset_conf hdmi_conf_480p = {
+	.core = {
+		.h_blank = {0x8a, 0x00},
+		.v_blank = {0x0d, 0x6a, 0x01},
+		.h_v_line = {0x0d, 0xa2, 0x35},
+		.vsync_pol = {0x01},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00},
+		.h_sync_gen = {0x0e, 0x30, 0x11},
+		.v_sync_gen1 = {0x0f, 0x90, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x5a, 0x03, /* h_fsz */
+		0x8a, 0x00, 0xd0, 0x02, /* hact */
+		0x0d, 0x02, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0xe0, 0x01, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_720p60 = {
+	.core = {
+		.h_blank = {0x72, 0x01},
+		.v_blank = {0xee, 0xf2, 0x00},
+		.h_v_line = {0xee, 0x22, 0x67},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x6c, 0x50, 0x02},
+		.v_sync_gen1 = {0x0a, 0x50, 0x00},
+		.v_sync_gen2 = {0x01, 0x10, 0x00},
+		.v_sync_gen3 = {0x01, 0x10, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x72, 0x06, /* h_fsz */
+		0x71, 0x01, 0x01, 0x05, /* hact */
+		0xee, 0x02, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x1e, 0x00, 0xd0, 0x02, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_1080i50 = {
+	.core = {
+		.h_blank = {0xd0, 0x02},
+		.v_blank = {0x32, 0xB2, 0x00},
+		.h_v_line = {0x65, 0x04, 0xa5},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x01},
+		.v_blank_f = {0x49, 0x2A, 0x23},
+		.h_sync_gen = {0x0E, 0xEA, 0x08},
+		.v_sync_gen1 = {0x07, 0x20, 0x00},
+		.v_sync_gen2 = {0x39, 0x42, 0x23},
+		.v_sync_gen3 = {0x38, 0x87, 0x73},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x50, 0x0A, /* h_fsz */
+		0xCF, 0x02, 0x81, 0x07, /* hact */
+		0x65, 0x04, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x16, 0x00, 0x1c, 0x02, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_1080p50 = {
+	.core = {
+		.h_blank = {0xd0, 0x02},
+		.v_blank = {0x65, 0x6c, 0x01},
+		.h_v_line = {0x65, 0x04, 0xa5},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x0e, 0xea, 0x08},
+		.v_sync_gen1 = {0x09, 0x40, 0x00},
+		.v_sync_gen2 = {0x01, 0x10, 0x00},
+		.v_sync_gen3 = {0x01, 0x10, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x50, 0x0A, /* h_fsz */
+		0xCF, 0x02, 0x81, 0x07, /* hact */
+		0x65, 0x04, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0x38, 0x04, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x48, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_1080i60 = {
+	.core = {
+		.h_blank = {0x18, 0x01},
+		.v_blank = {0x32, 0xB2, 0x00},
+		.h_v_line = {0x65, 0x84, 0x89},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x01},
+		.v_blank_f = {0x49, 0x2A, 0x23},
+		.h_sync_gen = {0x56, 0x08, 0x02},
+		.v_sync_gen1 = {0x07, 0x20, 0x00},
+		.v_sync_gen2 = {0x39, 0x42, 0x23},
+		.v_sync_gen3 = {0xa4, 0x44, 0x4a},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x98, 0x08, /* h_fsz */
+		0x17, 0x01, 0x81, 0x07, /* hact */
+		0x65, 0x04, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x16, 0x00, 0x1c, 0x02, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x49, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+};
+
+static const struct hdmi_preset_conf hdmi_conf_1080p60 = {
+	.core = {
+		.h_blank = {0x18, 0x01},
+		.v_blank = {0x65, 0x6c, 0x01},
+		.h_v_line = {0x65, 0x84, 0x89},
+		.vsync_pol = {0x00},
+		.int_pro_mode = {0x00},
+		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
+		.h_sync_gen = {0x56, 0x08, 0x02},
+		.v_sync_gen1 = {0x09, 0x40, 0x00},
+		.v_sync_gen2 = {0x01, 0x10, 0x00},
+		.v_sync_gen3 = {0x01, 0x10, 0x00},
+		/* other don't care */
+	},
+	.tg = {
+		0x00, /* cmd */
+		0x98, 0x08, /* h_fsz */
+		0x17, 0x01, 0x81, 0x07, /* hact */
+		0x65, 0x04, /* v_fsz */
+		0x01, 0x00, 0x33, 0x02, /* vsync */
+		0x2d, 0x00, 0x38, 0x04, /* vact */
+		0x33, 0x02, /* field_chg */
+		0x48, 0x02, /* vact_st2 */
+		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
+		0x01, 0x00, 0x33, 0x02, /* field top/bot */
+	},
+};
+
+static const struct hdmi_conf hdmi_confs[] = {
+	{ 1280, 720, 60, false, hdmiphy_conf74_25, &hdmi_conf_720p60 },
+	{ 1280, 720, 50, false, hdmiphy_conf74_25, &hdmi_conf_720p60 },
+	{ 720, 480, 60, false, hdmiphy_conf27_027, &hdmi_conf_480p },
+	{ 1920, 1080, 50, true, hdmiphy_conf74_25, &hdmi_conf_1080i50 },
+	{ 1920, 1080, 50, false, hdmiphy_conf148_5, &hdmi_conf_1080p50 },
+	{ 1920, 1080, 60, true, hdmiphy_conf74_25, &hdmi_conf_1080i60 },
+	{ 1920, 1080, 60, false, hdmiphy_conf148_5, &hdmi_conf_1080p60 },
+};
+
+
+static inline u32 hdmi_reg_read(struct hdmi_context *hdata, u32 reg_id)
+{
+	return readl(hdata->regs + reg_id);
+}
+
+static inline void hdmi_reg_writeb(struct hdmi_context *hdata,
+				 u32 reg_id, u8 value)
+{
+	writeb(value, hdata->regs + reg_id);
+}
+
+static inline void hdmi_reg_writemask(struct hdmi_context *hdata,
+				 u32 reg_id, u32 value, u32 mask)
+{
+	u32 old = readl(hdata->regs + reg_id);
+	value = (value & mask) | (old & ~mask);
+	writel(value, hdata->regs + reg_id);
+}
+
+static void hdmi_regs_dump(struct hdmi_context *hdata, char *prefix)
+{
+#define DUMPREG(reg_id) \
+	DRM_DEBUG_KMS("%s:" #reg_id " = %08x\n", prefix, \
+	readl(hdata->regs + reg_id))
+	DRM_DEBUG_KMS("%s: ---- CONTROL REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_INTC_FLAG);
+	DUMPREG(HDMI_INTC_CON);
+	DUMPREG(HDMI_HPD_STATUS);
+	DUMPREG(HDMI_PHY_RSTOUT);
+	DUMPREG(HDMI_PHY_VPLL);
+	DUMPREG(HDMI_PHY_CMU);
+	DUMPREG(HDMI_CORE_RSTOUT);
+
+	DRM_DEBUG_KMS("%s: ---- CORE REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_CON_0);
+	DUMPREG(HDMI_CON_1);
+	DUMPREG(HDMI_CON_2);
+	DUMPREG(HDMI_SYS_STATUS);
+	DUMPREG(HDMI_PHY_STATUS);
+	DUMPREG(HDMI_STATUS_EN);
+	DUMPREG(HDMI_HPD);
+	DUMPREG(HDMI_MODE_SEL);
+	DUMPREG(HDMI_HPD_GEN);
+	DUMPREG(HDMI_DC_CONTROL);
+	DUMPREG(HDMI_VIDEO_PATTERN_GEN);
+
+	DRM_DEBUG_KMS("%s: ---- CORE SYNC REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_H_BLANK_0);
+	DUMPREG(HDMI_H_BLANK_1);
+	DUMPREG(HDMI_V_BLANK_0);
+	DUMPREG(HDMI_V_BLANK_1);
+	DUMPREG(HDMI_V_BLANK_2);
+	DUMPREG(HDMI_H_V_LINE_0);
+	DUMPREG(HDMI_H_V_LINE_1);
+	DUMPREG(HDMI_H_V_LINE_2);
+	DUMPREG(HDMI_VSYNC_POL);
+	DUMPREG(HDMI_INT_PRO_MODE);
+	DUMPREG(HDMI_V_BLANK_F_0);
+	DUMPREG(HDMI_V_BLANK_F_1);
+	DUMPREG(HDMI_V_BLANK_F_2);
+	DUMPREG(HDMI_H_SYNC_GEN_0);
+	DUMPREG(HDMI_H_SYNC_GEN_1);
+	DUMPREG(HDMI_H_SYNC_GEN_2);
+	DUMPREG(HDMI_V_SYNC_GEN_1_0);
+	DUMPREG(HDMI_V_SYNC_GEN_1_1);
+	DUMPREG(HDMI_V_SYNC_GEN_1_2);
+	DUMPREG(HDMI_V_SYNC_GEN_2_0);
+	DUMPREG(HDMI_V_SYNC_GEN_2_1);
+	DUMPREG(HDMI_V_SYNC_GEN_2_2);
+	DUMPREG(HDMI_V_SYNC_GEN_3_0);
+	DUMPREG(HDMI_V_SYNC_GEN_3_1);
+	DUMPREG(HDMI_V_SYNC_GEN_3_2);
+
+	DRM_DEBUG_KMS("%s: ---- TG REGISTERS ----\n", prefix);
+	DUMPREG(HDMI_TG_CMD);
+	DUMPREG(HDMI_TG_H_FSZ_L);
+	DUMPREG(HDMI_TG_H_FSZ_H);
+	DUMPREG(HDMI_TG_HACT_ST_L);
+	DUMPREG(HDMI_TG_HACT_ST_H);
+	DUMPREG(HDMI_TG_HACT_SZ_L);
+	DUMPREG(HDMI_TG_HACT_SZ_H);
+	DUMPREG(HDMI_TG_V_FSZ_L);
+	DUMPREG(HDMI_TG_V_FSZ_H);
+	DUMPREG(HDMI_TG_VSYNC_L);
+	DUMPREG(HDMI_TG_VSYNC_H);
+	DUMPREG(HDMI_TG_VSYNC2_L);
+	DUMPREG(HDMI_TG_VSYNC2_H);
+	DUMPREG(HDMI_TG_VACT_ST_L);
+	DUMPREG(HDMI_TG_VACT_ST_H);
+	DUMPREG(HDMI_TG_VACT_SZ_L);
+	DUMPREG(HDMI_TG_VACT_SZ_H);
+	DUMPREG(HDMI_TG_FIELD_CHG_L);
+	DUMPREG(HDMI_TG_FIELD_CHG_H);
+	DUMPREG(HDMI_TG_VACT_ST2_L);
+	DUMPREG(HDMI_TG_VACT_ST2_H);
+	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_L);
+	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_H);
+	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_L);
+	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_H);
+	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_L);
+	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_H);
+	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_L);
+	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_H);
+#undef DUMPREG
+}
+
+static int hdmi_conf_index(struct drm_display_mode *mode)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hdmi_confs); ++i)
+		if (hdmi_confs[i].width == mode->hdisplay &&
+				hdmi_confs[i].height == mode->vdisplay &&
+				hdmi_confs[i].vrefresh == mode->vrefresh &&
+				hdmi_confs[i].interlace ==
+				((mode->flags & DRM_MODE_FLAG_INTERLACE) ?
+				 true : false))
+			return i;
+
+	return -1;
+}
+
+static bool hdmi_is_connected(void *ctx)
+{
+	struct hdmi_context *hdata = (struct hdmi_context *)ctx;
+	u32 val = hdmi_reg_read(hdata, HDMI_HPD_STATUS);
+
+	if (val)
+		return true;
+
+	return false;
+}
+
+static int hdmi_get_edid(void *ctx, struct drm_connector *connector,
+				u8 *edid, int len)
+{
+	struct edid *raw_edid;
+	struct hdmi_context *hdata = (struct hdmi_context *)ctx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	if (!hdata->ddc_port)
+		return -ENODEV;
+
+	raw_edid = drm_get_edid(connector, hdata->ddc_port->adapter);
+	if (raw_edid) {
+		memcpy(edid, raw_edid, min((1 + raw_edid->extensions)
+					* EDID_LENGTH, len));
+		DRM_DEBUG_KMS("width[%d] x height[%d]\n",
+				raw_edid->width_cm, raw_edid->height_cm);
+	} else {
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int hdmi_check_timing(void *ctx, void *timing)
+{
+	struct fb_videomode *check_timing = timing;
+	int i;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	DRM_DEBUG_KMS("[%d]x[%d] [%d]Hz [%x]\n", check_timing->xres,
+			check_timing->yres, check_timing->refresh,
+			check_timing->vmode);
+
+	for (i = 0; i < ARRAY_SIZE(hdmi_confs); ++i)
+		if (hdmi_confs[i].width == check_timing->xres &&
+			hdmi_confs[i].height == check_timing->yres &&
+			hdmi_confs[i].vrefresh == check_timing->refresh &&
+			hdmi_confs[i].interlace ==
+			((check_timing->vmode & FB_VMODE_INTERLACED) ?
+			 true : false))
+			return 0;
+
+	return -EINVAL;
+}
+
+static int hdmi_display_power_on(void *ctx, int mode)
+{
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		DRM_DEBUG_KMS("hdmi [on]\n");
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+		break;
+	case DRM_MODE_DPMS_SUSPEND:
+		break;
+	case DRM_MODE_DPMS_OFF:
+		DRM_DEBUG_KMS("hdmi [off]\n");
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static struct exynos_hdmi_display_ops display_ops = {
+	.is_connected	= hdmi_is_connected,
+	.get_edid	= hdmi_get_edid,
+	.check_timing	= hdmi_check_timing,
+	.power_on	= hdmi_display_power_on,
+};
+
+static void hdmi_conf_reset(struct hdmi_context *hdata)
+{
+	/* disable hpd handle for drm */
+	hdata->hpd_handle = false;
+
+	/* resetting HDMI core */
+	hdmi_reg_writemask(hdata, HDMI_CORE_RSTOUT,  0, HDMI_CORE_SW_RSTOUT);
+	mdelay(10);
+	hdmi_reg_writemask(hdata, HDMI_CORE_RSTOUT, ~0, HDMI_CORE_SW_RSTOUT);
+	mdelay(10);
+
+	/* enable hpd handle for drm */
+	hdata->hpd_handle = true;
+}
+
+static void hdmi_conf_init(struct hdmi_context *hdata)
+{
+	/* disable hpd handle for drm */
+	hdata->hpd_handle = false;
+
+	/* enable HPD interrupts */
+	hdmi_reg_writemask(hdata, HDMI_INTC_CON, 0, HDMI_INTC_EN_GLOBAL |
+		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
+	mdelay(10);
+	hdmi_reg_writemask(hdata, HDMI_INTC_CON, ~0, HDMI_INTC_EN_GLOBAL |
+		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
+
+	/* choose HDMI mode */
+	hdmi_reg_writemask(hdata, HDMI_MODE_SEL,
+		HDMI_MODE_HDMI_EN, HDMI_MODE_MASK);
+	/* disable bluescreen */
+	hdmi_reg_writemask(hdata, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
+	/* choose bluescreen (fecal) color */
+	hdmi_reg_writeb(hdata, HDMI_BLUE_SCREEN_0, 0x12);
+	hdmi_reg_writeb(hdata, HDMI_BLUE_SCREEN_1, 0x34);
+	hdmi_reg_writeb(hdata, HDMI_BLUE_SCREEN_2, 0x56);
+	/* enable AVI packet every vsync, fixes purple line problem */
+	hdmi_reg_writeb(hdata, HDMI_AVI_CON, 0x02);
+	/* force RGB, look to CEA-861-D, table 7 for more detail */
+	hdmi_reg_writeb(hdata, HDMI_AVI_BYTE(0), 0 << 5);
+	hdmi_reg_writemask(hdata, HDMI_CON_1, 0x10 << 5, 0x11 << 5);
+
+	hdmi_reg_writeb(hdata, HDMI_SPD_CON, 0x02);
+	hdmi_reg_writeb(hdata, HDMI_AUI_CON, 0x02);
+	hdmi_reg_writeb(hdata, HDMI_ACR_CON, 0x04);
+
+	/* enable hpd handle for drm */
+	hdata->hpd_handle = true;
+}
+
+static void hdmi_timing_apply(struct hdmi_context *hdata,
+				 const struct hdmi_preset_conf *conf)
+{
+	const struct hdmi_core_regs *core = &conf->core;
+	const struct hdmi_tg_regs *tg = &conf->tg;
+	int tries;
+
+	/* setting core registers */
+	hdmi_reg_writeb(hdata, HDMI_H_BLANK_0, core->h_blank[0]);
+	hdmi_reg_writeb(hdata, HDMI_H_BLANK_1, core->h_blank[1]);
+	hdmi_reg_writeb(hdata, HDMI_V_BLANK_0, core->v_blank[0]);
+	hdmi_reg_writeb(hdata, HDMI_V_BLANK_1, core->v_blank[1]);
+	hdmi_reg_writeb(hdata, HDMI_V_BLANK_2, core->v_blank[2]);
+	hdmi_reg_writeb(hdata, HDMI_H_V_LINE_0, core->h_v_line[0]);
+	hdmi_reg_writeb(hdata, HDMI_H_V_LINE_1, core->h_v_line[1]);
+	hdmi_reg_writeb(hdata, HDMI_H_V_LINE_2, core->h_v_line[2]);
+	hdmi_reg_writeb(hdata, HDMI_VSYNC_POL, core->vsync_pol[0]);
+	hdmi_reg_writeb(hdata, HDMI_INT_PRO_MODE, core->int_pro_mode[0]);
+	hdmi_reg_writeb(hdata, HDMI_V_BLANK_F_0, core->v_blank_f[0]);
+	hdmi_reg_writeb(hdata, HDMI_V_BLANK_F_1, core->v_blank_f[1]);
+	hdmi_reg_writeb(hdata, HDMI_V_BLANK_F_2, core->v_blank_f[2]);
+	hdmi_reg_writeb(hdata, HDMI_H_SYNC_GEN_0, core->h_sync_gen[0]);
+	hdmi_reg_writeb(hdata, HDMI_H_SYNC_GEN_1, core->h_sync_gen[1]);
+	hdmi_reg_writeb(hdata, HDMI_H_SYNC_GEN_2, core->h_sync_gen[2]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_1_0, core->v_sync_gen1[0]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_1_1, core->v_sync_gen1[1]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_1_2, core->v_sync_gen1[2]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_2_0, core->v_sync_gen2[0]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_2_1, core->v_sync_gen2[1]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_2_2, core->v_sync_gen2[2]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_3_0, core->v_sync_gen3[0]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_3_1, core->v_sync_gen3[1]);
+	hdmi_reg_writeb(hdata, HDMI_V_SYNC_GEN_3_2, core->v_sync_gen3[2]);
+	/* Timing generator registers */
+	hdmi_reg_writeb(hdata, HDMI_TG_H_FSZ_L, tg->h_fsz_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_H_FSZ_H, tg->h_fsz_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_HACT_ST_L, tg->hact_st_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_HACT_ST_H, tg->hact_st_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_HACT_SZ_L, tg->hact_sz_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_HACT_SZ_H, tg->hact_sz_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_V_FSZ_L, tg->v_fsz_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_V_FSZ_H, tg->v_fsz_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_VSYNC_L, tg->vsync_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_VSYNC_H, tg->vsync_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_VSYNC2_L, tg->vsync2_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_VSYNC2_H, tg->vsync2_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_VACT_ST_L, tg->vact_st_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_VACT_ST_H, tg->vact_st_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_VACT_SZ_L, tg->vact_sz_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_VACT_SZ_H, tg->vact_sz_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_FIELD_CHG_L, tg->field_chg_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_FIELD_CHG_H, tg->field_chg_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_VACT_ST2_L, tg->vact_st2_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_VACT_ST2_H, tg->vact_st2_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_VSYNC_TOP_HDMI_L, tg->vsync_top_hdmi_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_VSYNC_TOP_HDMI_H, tg->vsync_top_hdmi_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_VSYNC_BOT_HDMI_L, tg->vsync_bot_hdmi_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_VSYNC_BOT_HDMI_H, tg->vsync_bot_hdmi_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_FIELD_TOP_HDMI_L, tg->field_top_hdmi_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_FIELD_TOP_HDMI_H, tg->field_top_hdmi_h);
+	hdmi_reg_writeb(hdata, HDMI_TG_FIELD_BOT_HDMI_L, tg->field_bot_hdmi_l);
+	hdmi_reg_writeb(hdata, HDMI_TG_FIELD_BOT_HDMI_H, tg->field_bot_hdmi_h);
+
+	/* waiting for HDMIPHY's PLL to get to steady state */
+	for (tries = 100; tries; --tries) {
+		u32 val = hdmi_reg_read(hdata, HDMI_PHY_STATUS);
+		if (val & HDMI_PHY_STATUS_READY)
+			break;
+		mdelay(1);
+	}
+	/* steady state not achieved */
+	if (tries == 0) {
+		DRM_ERROR("hdmiphy's pll could not reach steady state.\n");
+		hdmi_regs_dump(hdata, "timing apply");
+	}
+
+	clk_disable(hdata->res.sclk_hdmi);
+	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_hdmiphy);
+	clk_enable(hdata->res.sclk_hdmi);
+
+	/* enable HDMI and timing generator */
+	hdmi_reg_writemask(hdata, HDMI_CON_0, ~0, HDMI_EN);
+	if (core->int_pro_mode[0])
+		hdmi_reg_writemask(hdata, HDMI_TG_CMD, ~0, HDMI_TG_EN |
+				HDMI_FIELD_EN);
+	else
+		hdmi_reg_writemask(hdata, HDMI_TG_CMD, ~0, HDMI_TG_EN);
+}
+
+static void hdmiphy_conf_reset(struct hdmi_context *hdata)
+{
+	u8 buffer[2];
+
+	clk_disable(hdata->res.sclk_hdmi);
+	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_pixel);
+	clk_enable(hdata->res.sclk_hdmi);
+
+	/* operation mode */
+	buffer[0] = 0x1f;
+	buffer[1] = 0x00;
+
+	if (hdata->hdmiphy_port)
+		i2c_master_send(hdata->hdmiphy_port, buffer, 2);
+
+	/* reset hdmiphy */
+	hdmi_reg_writemask(hdata, HDMI_PHY_RSTOUT, ~0, HDMI_PHY_SW_RSTOUT);
+	mdelay(10);
+	hdmi_reg_writemask(hdata, HDMI_PHY_RSTOUT,  0, HDMI_PHY_SW_RSTOUT);
+	mdelay(10);
+}
+
+static void hdmiphy_conf_apply(struct hdmi_context *hdata)
+{
+	u8 buffer[32];
+	u8 operation[2];
+	u8 read_buffer[32] = {0, };
+	int ret;
+	int i;
+
+	if (!hdata->hdmiphy_port) {
+		DRM_ERROR("hdmiphy is not attached\n");
+		return;
+	}
+
+	/* pixel clock */
+	memcpy(buffer, hdmi_confs[hdata->cur_conf].hdmiphy_data, 32);
+	ret = i2c_master_send(hdata->hdmiphy_port, buffer, 32);
+	if (ret != 32) {
+		DRM_ERROR("failed to configure HDMIPHY via I2C\n");
+		return;
+	}
+
+	mdelay(10);
+
+	/* operation mode */
+	operation[0] = 0x1f;
+	operation[1] = 0x80;
+
+	ret = i2c_master_send(hdata->hdmiphy_port, operation, 2);
+	if (ret != 2) {
+		DRM_ERROR("failed to enable hdmiphy\n");
+		return;
+	}
+
+	ret = i2c_master_recv(hdata->hdmiphy_port, read_buffer, 32);
+	if (ret < 0) {
+		DRM_ERROR("failed to read hdmiphy config\n");
+		return;
+	}
+
+	for (i = 0; i < ret; i++)
+		DRM_DEBUG_KMS("hdmiphy[0x%02x] write[0x%02x] - "
+			"recv [0x%02x]\n", i, buffer[i], read_buffer[i]);
+}
+
+static void hdmi_conf_apply(struct hdmi_context *hdata)
+{
+	const struct hdmi_preset_conf *conf =
+		  hdmi_confs[hdata->cur_conf].conf;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	hdmiphy_conf_reset(hdata);
+	hdmiphy_conf_apply(hdata);
+
+	hdmi_conf_reset(hdata);
+	hdmi_conf_init(hdata);
+
+	/* setting core registers */
+	hdmi_timing_apply(hdata, conf);
+
+	hdmi_regs_dump(hdata, "start");
+}
+
+static void hdmi_mode_set(void *ctx, void *mode)
+{
+	struct hdmi_context *hdata = (struct hdmi_context *)ctx;
+	int conf_idx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	conf_idx = hdmi_conf_index(mode);
+	if (conf_idx >= 0 && conf_idx < ARRAY_SIZE(hdmi_confs))
+		hdata->cur_conf = conf_idx;
+	else
+		DRM_DEBUG_KMS("not supported mode\n");
+}
+
+static void hdmi_commit(void *ctx)
+{
+	struct hdmi_context *hdata = (struct hdmi_context *)ctx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	hdmi_conf_apply(hdata);
+}
+
+static void hdmi_clear_win(struct hdmi_context *hdata, int win)
+{
+	/* TODO. */
+}
+
+static void hdmi_disable(void *ctx)
+{
+	struct hdmi_context *hdata = (struct hdmi_context *)ctx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	/* TODO. */
+	hdmiphy_conf_reset(hdata);
+	hdmi_conf_reset(hdata);
+}
+
+static struct exynos_hdmi_manager_ops manager_ops = {
+	.mode_set	= hdmi_mode_set,
+	.commit		= hdmi_commit,
+	.disable	= hdmi_disable,
+};
+
+/*
+ * Handle hotplug events outside the interrupt handler proper.
+ */
+static void hdmi_hotplug_func(struct work_struct *work)
+{
+	struct hdmi_context *hdata =
+		container_of(work, struct hdmi_context, hotplug_work);
+	struct exynos_drm_hdmi_context *ctx =
+		(struct exynos_drm_hdmi_context *)hdata->parent_ctx;
+
+	drm_helper_hpd_irq_event(ctx->drm_dev);
+}
+
+static irqreturn_t hdmi_irq_handler(int irq, void *arg)
+{
+	struct exynos_drm_hdmi_context *ctx = arg;
+	struct hdmi_context *hdata = (struct hdmi_context *)ctx->ctx;
+	u32 intc_flag;
+
+	intc_flag = hdmi_reg_read(hdata, HDMI_INTC_FLAG);
+	/* clearing flags for HPD plug/unplug */
+	if (intc_flag & HDMI_INTC_FLAG_HPD_UNPLUG) {
+		DRM_DEBUG_KMS("unplugged, handling:%d\n", hdata->hpd_handle);
+		hdmi_reg_writemask(hdata, HDMI_INTC_FLAG, ~0,
+			HDMI_INTC_FLAG_HPD_UNPLUG);
+	}
+	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
+		DRM_DEBUG_KMS("plugged, handling:%d\n", hdata->hpd_handle);
+		hdmi_reg_writemask(hdata, HDMI_INTC_FLAG, ~0,
+			HDMI_INTC_FLAG_HPD_PLUG);
+	}
+
+	if (hdata->hpd_handle)
+		queue_work(hdata->wq, &hdata->hotplug_work);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit hdmi_resources_init(struct hdmi_context *hdata)
+{
+	struct device *dev = hdata->dev;
+	struct hdmi_resources *res = &hdata->res;
+	static char *supply[] = {
+		"hdmi-en",
+		"vdd",
+		"vdd_osc",
+		"vdd_pll",
+	};
+	int i, ret;
+
+	DRM_DEBUG_KMS("HDMI resource init\n");
+
+	memset(res, 0, sizeof *res);
+
+	/* get clocks, power */
+	res->hdmi = clk_get(dev, "hdmi");
+	if (IS_ERR_OR_NULL(res->hdmi)) {
+		DRM_ERROR("failed to get clock 'hdmi'\n");
+		goto fail;
+	}
+	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+		DRM_ERROR("failed to get clock 'sclk_hdmi'\n");
+		goto fail;
+	}
+	res->sclk_pixel = clk_get(dev, "sclk_pixel");
+	if (IS_ERR_OR_NULL(res->sclk_pixel)) {
+		DRM_ERROR("failed to get clock 'sclk_pixel'\n");
+		goto fail;
+	}
+	res->sclk_hdmiphy = clk_get(dev, "sclk_hdmiphy");
+	if (IS_ERR_OR_NULL(res->sclk_hdmiphy)) {
+		DRM_ERROR("failed to get clock 'sclk_hdmiphy'\n");
+		goto fail;
+	}
+	res->hdmiphy = clk_get(dev, "hdmiphy");
+	if (IS_ERR_OR_NULL(res->hdmiphy)) {
+		DRM_ERROR("failed to get clock 'hdmiphy'\n");
+		goto fail;
+	}
+
+	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
+
+	res->regul_bulk = kzalloc(ARRAY_SIZE(supply) *
+		sizeof res->regul_bulk[0], GFP_KERNEL);
+	if (!res->regul_bulk) {
+		DRM_ERROR("failed to get memory for regulators\n");
+		goto fail;
+	}
+	for (i = 0; i < ARRAY_SIZE(supply); ++i) {
+		res->regul_bulk[i].supply = supply[i];
+		res->regul_bulk[i].consumer = NULL;
+	}
+	ret = regulator_bulk_get(dev, ARRAY_SIZE(supply), res->regul_bulk);
+	if (ret) {
+		DRM_ERROR("failed to get regulators\n");
+		goto fail;
+	}
+	res->regul_count = ARRAY_SIZE(supply);
+
+	return 0;
+fail:
+	DRM_ERROR("HDMI resource init - failed\n");
+	return -ENODEV;
+}
+
+static int hdmi_resources_cleanup(struct hdmi_context *hdata)
+{
+	struct hdmi_resources *res = &hdata->res;
+
+	regulator_bulk_free(res->regul_count, res->regul_bulk);
+	/* kfree is NULL-safe */
+	kfree(res->regul_bulk);
+	if (!IS_ERR_OR_NULL(res->hdmiphy))
+		clk_put(res->hdmiphy);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
+		clk_put(res->sclk_hdmiphy);
+	if (!IS_ERR_OR_NULL(res->sclk_pixel))
+		clk_put(res->sclk_pixel);
+	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
+		clk_put(res->sclk_hdmi);
+	if (!IS_ERR_OR_NULL(res->hdmi))
+		clk_put(res->hdmi);
+	memset(res, 0, sizeof *res);
+
+	return 0;
+}
+
+static void hdmi_resource_poweron(struct hdmi_context *hdata)
+{
+	struct hdmi_resources *res = &hdata->res;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	/* turn HDMI power on */
+	regulator_bulk_enable(res->regul_count, res->regul_bulk);
+	/* power-on hdmi physical interface */
+	clk_enable(res->hdmiphy);
+	/* turn clocks on */
+	clk_enable(res->hdmi);
+	clk_enable(res->sclk_hdmi);
+
+	hdmiphy_conf_reset(hdata);
+	hdmi_conf_reset(hdata);
+	hdmi_conf_init(hdata);
+
+}
+
+static void hdmi_resource_poweroff(struct hdmi_context *hdata)
+{
+	struct hdmi_resources *res = &hdata->res;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	/* turn clocks off */
+	clk_disable(res->sclk_hdmi);
+	clk_disable(res->hdmi);
+	/* power-off hdmiphy */
+	clk_disable(res->hdmiphy);
+	/* turn HDMI power off */
+	regulator_bulk_disable(res->regul_count, res->regul_bulk);
+}
+
+static int hdmi_runtime_suspend(struct device *dev)
+{
+	struct exynos_drm_hdmi_context *ctx = get_hdmi_context(dev);
+
+	DRM_DEBUG_KMS("%s\n", __func__);
+
+	hdmi_resource_poweroff((struct hdmi_context *)ctx->ctx);
+
+	return 0;
+}
+
+static int hdmi_runtime_resume(struct device *dev)
+{
+	struct exynos_drm_hdmi_context *ctx = get_hdmi_context(dev);
+
+	DRM_DEBUG_KMS("%s\n", __func__);
+
+	hdmi_resource_poweron((struct hdmi_context *)ctx->ctx);
+
+	return 0;
+}
+
+static const struct dev_pm_ops hdmi_pm_ops = {
+	.runtime_suspend = hdmi_runtime_suspend,
+	.runtime_resume	 = hdmi_runtime_resume,
+};
+
+static struct i2c_client *hdmi_ddc, *hdmi_hdmiphy;
+
+void hdmi_attach_ddc_client(struct i2c_client *ddc)
+{
+	if (ddc)
+		hdmi_ddc = ddc;
+}
+
+void hdmi_attach_hdmiphy_client(struct i2c_client *hdmiphy)
+{
+	if (hdmiphy)
+		hdmi_hdmiphy = hdmiphy;
+}
+
+static int __devinit hdmi_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct exynos_drm_hdmi_context *drm_hdmi_ctx;
+	struct hdmi_context *hdata;
+	struct exynos_drm_hdmi_pdata *pdata;
+	struct resource *res;
+	int win;
+	int ret;
+
+	DRM_DEBUG_KMS("[%d]\n", __LINE__);
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		DRM_ERROR("no platform data specified\n");
+		return -EINVAL;
+	}
+
+	drm_hdmi_ctx = kzalloc(sizeof(*drm_hdmi_ctx), GFP_KERNEL);
+	if (!drm_hdmi_ctx) {
+		DRM_ERROR("failed to allocate common hdmi context.\n");
+		return -ENOMEM;
+	}
+
+	hdata = kzalloc(sizeof(struct hdmi_context), GFP_KERNEL);
+	if (!hdata) {
+		DRM_ERROR("out of memory\n");
+		kfree(drm_hdmi_ctx);
+		return -ENOMEM;
+	}
+
+	drm_hdmi_ctx->ctx = (void *)hdata;
+	hdata->parent_ctx = (void *)drm_hdmi_ctx;
+
+	platform_set_drvdata(pdev, drm_hdmi_ctx);
+
+	hdata->default_win = pdata->default_win;
+	hdata->default_timing = &pdata->timing;
+	hdata->default_bpp = pdata->bpp;
+	hdata->dev = dev;
+
+	ret = hdmi_resources_init(hdata);
+	if (ret) {
+		ret = -EINVAL;
+		goto err_data;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		DRM_ERROR("failed to find registers\n");
+		ret = -ENOENT;
+		goto err_resource;
+	}
+
+	hdata->regs_res = request_mem_region(res->start, resource_size(res),
+					   dev_name(dev));
+	if (!hdata->regs_res) {
+		DRM_ERROR("failed to claim register region\n");
+		ret = -ENOENT;
+		goto err_resource;
+	}
+
+	hdata->regs = ioremap(res->start, resource_size(res));
+	if (!hdata->regs) {
+		DRM_ERROR("failed to map registers\n");
+		ret = -ENXIO;
+		goto err_req_region;
+	}
+
+	/* DDC i2c driver */
+	if (i2c_add_driver(&ddc_driver)) {
+		DRM_ERROR("failed to register ddc i2c driver\n");
+		ret = -ENOENT;
+		goto err_iomap;
+	}
+
+	hdata->ddc_port = hdmi_ddc;
+
+	/* hdmiphy i2c driver */
+	if (i2c_add_driver(&hdmiphy_driver)) {
+		DRM_ERROR("failed to register hdmiphy i2c driver\n");
+		ret = -ENOENT;
+		goto err_ddc;
+	}
+
+	hdata->hdmiphy_port = hdmi_hdmiphy;
+
+	/* clear win registers */
+	for (win = 0; win < HDMI_OVERLAY_NUMBER; win++)
+		hdmi_clear_win(hdata, win);
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		DRM_ERROR("get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto err_hdmiphy;
+	}
+
+	/* create workqueue and hotplug work */
+	hdata->wq = alloc_workqueue("exynos-drm-hdmi",
+			WQ_UNBOUND | WQ_NON_REENTRANT, 1);
+	if (hdata->wq == NULL) {
+		DRM_ERROR("Failed to create workqueue.\n");
+		ret = -ENOMEM;
+		goto err_hdmiphy;
+	}
+	INIT_WORK(&hdata->hotplug_work, hdmi_hotplug_func);
+
+	/* register hpd interrupt */
+	ret = request_irq(res->start, hdmi_irq_handler, 0, "drm_hdmi",
+				drm_hdmi_ctx);
+	if (ret) {
+		DRM_ERROR("request interrupt failed.\n");
+		goto err_workqueue;
+	}
+	hdata->irq = res->start;
+
+	/* register specific callbacks to common hdmi. */
+	exynos_drm_display_ops_register(&display_ops);
+	exynos_drm_manager_ops_register(&manager_ops);
+
+	hdmi_resource_poweron(hdata);
+
+	return 0;
+
+err_workqueue:
+	destroy_workqueue(hdata->wq);
+err_hdmiphy:
+	i2c_del_driver(&hdmiphy_driver);
+err_ddc:
+	i2c_del_driver(&ddc_driver);
+err_iomap:
+	iounmap(hdata->regs);
+err_req_region:
+	release_resource(hdata->regs_res);
+	kfree(hdata->regs_res);
+err_resource:
+	hdmi_resources_cleanup(hdata);
+err_data:
+	kfree(hdata);
+	kfree(drm_hdmi_ctx);
+	return ret;
+}
+
+static int __devexit hdmi_remove(struct platform_device *pdev)
+{
+	struct exynos_drm_hdmi_context *ctx = platform_get_drvdata(pdev);
+	struct hdmi_context *hdata = (struct hdmi_context *)ctx->ctx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	hdmi_resource_poweroff(hdata);
+
+	disable_irq(hdata->irq);
+	free_irq(hdata->irq, hdata);
+
+	cancel_work_sync(&hdata->hotplug_work);
+	destroy_workqueue(hdata->wq);
+
+	hdmi_resources_cleanup(hdata);
+
+	iounmap(hdata->regs);
+
+	release_resource(hdata->regs_res);
+	kfree(hdata->regs_res);
+
+	/* hdmiphy i2c driver */
+	i2c_del_driver(&hdmiphy_driver);
+	/* DDC i2c driver */
+	i2c_del_driver(&ddc_driver);
+
+	kfree(hdata);
+
+	return 0;
+}
+
+struct platform_driver hdmi_driver = {
+	.probe		= hdmi_probe,
+	.remove		= __devexit_p(hdmi_remove),
+	.driver		= {
+		.name	= "exynos4-hdmi",
+		.owner	= THIS_MODULE,
+		.pm = &hdmi_pm_ops,
+	},
+};
+EXPORT_SYMBOL(hdmi_driver);
+
+MODULE_AUTHOR("Seung-Woo Kim, <sw0312.kim@samsung.com>");
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
+MODULE_DESCRIPTION("Samsung DRM HDMI core Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.h b/drivers/gpu/drm/exynos/exynos_hdmi.h
new file mode 100644
index 0000000..c9de7d9
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.h
@@ -0,0 +1,89 @@
+/*
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Seung-Woo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _EXYNOS_HDMI_H_
+#define _EXYNOS_HDMI_H_
+
+struct hdmi_conf {
+	int width;
+	int height;
+	int vrefresh;
+	bool interlace;
+	const u8 *hdmiphy_data;
+	const struct hdmi_preset_conf *conf;
+};
+
+struct hdmi_resources {
+	struct clk *hdmi;
+	struct clk *sclk_hdmi;
+	struct clk *sclk_pixel;
+	struct clk *sclk_hdmiphy;
+	struct clk *hdmiphy;
+	struct regulator_bulk_data *regul_bulk;
+	int regul_count;
+};
+
+struct hdmi_context {
+	struct device			*dev;
+	struct drm_device		*drm_dev;
+	struct fb_videomode		*default_timing;
+	unsigned int			default_win;
+	unsigned int			default_bpp;
+	bool				hpd_handle;
+
+	struct resource			*regs_res;
+	/** base address of HDMI registers */
+	void __iomem *regs;
+	/** HDMI hotplug interrupt */
+	unsigned int irq;
+	/** workqueue for delayed work */
+	struct workqueue_struct *wq;
+	/** hotplug handling work */
+	struct work_struct hotplug_work;
+
+	struct i2c_client *ddc_port;
+	struct i2c_client *hdmiphy_port;
+
+	/** current hdmiphy conf index */
+	int cur_conf;
+	/** other resources */
+	struct hdmi_resources res;
+
+	void *parent_ctx;
+};
+
+
+void hdmi_attach_ddc_client(struct i2c_client *ddc);
+void hdmi_attach_hdmiphy_client(struct i2c_client *hdmiphy);
+
+extern struct i2c_driver hdmiphy_driver;
+extern struct i2c_driver ddc_driver;
+
+extern struct platform_driver hdmi_driver;
+extern struct platform_driver mixer_driver;
+
+#endif
diff --git a/drivers/gpu/drm/exynos/exynos_hdmiphy.c b/drivers/gpu/drm/exynos/exynos_hdmiphy.c
new file mode 100644
index 0000000..1928147
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_hdmiphy.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2011 Samsung Electronics Co.Ltd
+ * Authors:
+ *	Seung-Woo Kim <sw0312.kim@samsung.com>
+ *	Inki Dae <inki.dae@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include "drmP.h"
+
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+
+#include "exynos_drm_drv.h"
+#include "exynos_hdmi.h"
+
+
+static int hdmiphy_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	hdmi_attach_hdmiphy_client(client);
+
+	/* TODO. */
+
+	dev_info(&client->adapter->dev, "attached s5p_hdmiphy "
+		"into i2c adapter successfully\n");
+
+	return 0;
+}
+
+static int hdmiphy_remove(struct i2c_client *client)
+{
+	dev_info(&client->adapter->dev, "detached s5p_hdmiphy "
+		"from i2c adapter successfully\n");
+
+	/* TODO. */
+
+	return 0;
+}
+
+static const struct i2c_device_id hdmiphy_id[] = {
+	{ "s5p_hdmiphy", 0 },
+	{ },
+};
+
+struct i2c_driver hdmiphy_driver = {
+	.driver = {
+		.name	= "s5p-hdmiphy",
+		.owner	= THIS_MODULE,
+	},
+	.id_table = hdmiphy_id,
+	.probe		= hdmiphy_probe,
+	.remove		= __devexit_p(hdmiphy_remove),
+	.command		= NULL,
+};
+EXPORT_SYMBOL(hdmiphy_driver);
diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
new file mode 100644
index 0000000..d8e3b2e
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -0,0 +1,822 @@
+/*
+ * Copyright (C) 2011 Samsung Electronics Co.Ltd
+ * Authors:
+ * Seung-Woo Kim <sw0312.kim@samsung.com>
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * Based on drivers/media/video/s5p-tv/mixer_reg.c
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include "drmP.h"
+
+#include "regs-mixer.h"
+#include "regs-vp.h"
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+
+#include <drm/exynos_drm.h>
+
+#include "exynos_drm_drv.h"
+#include "exynos_drm_hdmi.h"
+#include "exynos_hdmi.h"
+#include "exynos_mixer.h"
+
+#define get_mixer_context(dev)	platform_get_drvdata(to_platform_device(dev))
+
+static inline u32 vp_reg_read(struct mixer_resources *res, u32 reg_id)
+{
+	return readl(res->vp_regs + reg_id);
+}
+
+static inline void vp_reg_write(struct mixer_resources *res, u32 reg_id,
+				 u32 val)
+{
+	writel(val, res->vp_regs + reg_id);
+}
+
+static inline void vp_reg_writemask(struct mixer_resources *res, u32 reg_id,
+				 u32 val, u32 mask)
+{
+	u32 old = vp_reg_read(res, reg_id);
+
+	val = (val & mask) | (old & ~mask);
+	writel(val, res->vp_regs + reg_id);
+}
+
+static inline u32 mixer_reg_read(struct mixer_resources *res, u32 reg_id)
+{
+	return readl(res->mixer_regs + reg_id);
+}
+
+static inline void mixer_reg_write(struct mixer_resources *res, u32 reg_id,
+				 u32 val)
+{
+	writel(val, res->mixer_regs + reg_id);
+}
+
+static inline void mixer_reg_writemask(struct mixer_resources *res,
+				 u32 reg_id, u32 val, u32 mask)
+{
+	u32 old = mixer_reg_read(res, reg_id);
+
+	val = (val & mask) | (old & ~mask);
+	writel(val, res->mixer_regs + reg_id);
+}
+
+static void mixer_regs_dump(struct mixer_context *ctx)
+{
+#define DUMPREG(reg_id) \
+do { \
+	DRM_DEBUG_KMS(#reg_id " = %08x\n", \
+		(u32)readl(ctx->mixer_res.mixer_regs + reg_id)); \
+} while (0)
+
+	DUMPREG(MXR_STATUS);
+	DUMPREG(MXR_CFG);
+	DUMPREG(MXR_INT_EN);
+	DUMPREG(MXR_INT_STATUS);
+
+	DUMPREG(MXR_LAYER_CFG);
+	DUMPREG(MXR_VIDEO_CFG);
+
+	DUMPREG(MXR_GRAPHIC0_CFG);
+	DUMPREG(MXR_GRAPHIC0_BASE);
+	DUMPREG(MXR_GRAPHIC0_SPAN);
+	DUMPREG(MXR_GRAPHIC0_WH);
+	DUMPREG(MXR_GRAPHIC0_SXY);
+	DUMPREG(MXR_GRAPHIC0_DXY);
+
+	DUMPREG(MXR_GRAPHIC1_CFG);
+	DUMPREG(MXR_GRAPHIC1_BASE);
+	DUMPREG(MXR_GRAPHIC1_SPAN);
+	DUMPREG(MXR_GRAPHIC1_WH);
+	DUMPREG(MXR_GRAPHIC1_SXY);
+	DUMPREG(MXR_GRAPHIC1_DXY);
+#undef DUMPREG
+}
+
+static void vp_regs_dump(struct mixer_context *ctx)
+{
+#define DUMPREG(reg_id) \
+do { \
+	DRM_DEBUG_KMS(#reg_id " = %08x\n", \
+		(u32) readl(ctx->mixer_res.vp_regs + reg_id)); \
+} while (0)
+
+	DUMPREG(VP_ENABLE);
+	DUMPREG(VP_SRESET);
+	DUMPREG(VP_SHADOW_UPDATE);
+	DUMPREG(VP_FIELD_ID);
+	DUMPREG(VP_MODE);
+	DUMPREG(VP_IMG_SIZE_Y);
+	DUMPREG(VP_IMG_SIZE_C);
+	DUMPREG(VP_PER_RATE_CTRL);
+	DUMPREG(VP_TOP_Y_PTR);
+	DUMPREG(VP_BOT_Y_PTR);
+	DUMPREG(VP_TOP_C_PTR);
+	DUMPREG(VP_BOT_C_PTR);
+	DUMPREG(VP_ENDIAN_MODE);
+	DUMPREG(VP_SRC_H_POSITION);
+	DUMPREG(VP_SRC_V_POSITION);
+	DUMPREG(VP_SRC_WIDTH);
+	DUMPREG(VP_SRC_HEIGHT);
+	DUMPREG(VP_DST_H_POSITION);
+	DUMPREG(VP_DST_V_POSITION);
+	DUMPREG(VP_DST_WIDTH);
+	DUMPREG(VP_DST_HEIGHT);
+	DUMPREG(VP_H_RATIO);
+	DUMPREG(VP_V_RATIO);
+
+#undef DUMPREG
+}
+
+static void mixer_vsync_set_update(struct mixer_context *ctx, bool enable)
+{
+	struct mixer_resources *res = &ctx->mixer_res;
+
+	/* block update on vsync */
+	mixer_reg_writemask(res, MXR_STATUS, enable ?
+			MXR_STATUS_SYNC_ENABLE : 0, MXR_STATUS_SYNC_ENABLE);
+
+	vp_reg_write(res, VP_SHADOW_UPDATE, enable ?
+			VP_SHADOW_UPDATE_ENABLE : 0);
+
+	/* update vsync interrupt */
+	mixer_reg_writemask(res, MXR_INT_EN, enable ?
+			MXR_INT_EN_VSYNC : 0, MXR_INT_EN_VSYNC);
+}
+
+static void vp_video_buffer(struct mixer_context *ctx, int win)
+{
+	struct hdmi_win_data *win_data;
+
+	win_data = &ctx->win_data[win];
+
+	vp_regs_dump(ctx);
+}
+
+static void mixer_graph_buffer(struct mixer_context *ctx, int win)
+{
+	struct mixer_resources *res = &ctx->mixer_res;
+	unsigned long flags;
+	unsigned int full_width, width, height;
+	unsigned int x_ratio, y_ratio;
+	unsigned int src_x_offset, src_y_offset, dst_x_offset, dst_y_offset;
+	unsigned int mode_width, mode_height;
+	struct hdmi_win_data *win_data;
+	unsigned int paddr;
+	unsigned int fmt;
+	u32 val;
+
+	if (win > 1) {
+		vp_video_buffer(ctx, win);
+		return;
+	}
+
+	win_data = &ctx->win_data[win];
+
+	#define RGB565 4
+	#define ARGB1555 5
+	#define ARGB4444 6
+	#define ARGB8888 7
+
+	switch (win_data->bpp) {
+	case 16:
+		fmt = ARGB4444;
+		break;
+	case 32:
+		fmt = ARGB8888;
+		break;
+	default:
+		fmt = ARGB8888;
+	}
+
+	paddr = win_data->paddr;
+	full_width = win_data->fb_width;
+	width = win_data->crtc_width;
+	height = win_data->crtc_height;
+	mode_width = win_data->mode_width;
+	mode_height = win_data->mode_height;
+
+	/* 2x scaling feature */
+	x_ratio = 0;
+	y_ratio = 0;
+
+	src_x_offset = win_data->fb_x;
+	src_y_offset = win_data->fb_y;
+	dst_x_offset = win_data->crtc_x;
+	dst_y_offset = win_data->crtc_y;
+
+	if (win_data->scan_flags & DRM_MODE_FLAG_INTERLACE)
+		ctx->interlace = true;
+	else
+		ctx->interlace = false;
+
+	spin_lock_irqsave(&res->reg_slock, flags);
+
+	/* setup format */
+	mixer_reg_writemask(res, MXR_GRAPHIC_CFG(win),
+		MXR_GRP_CFG_FORMAT_VAL(fmt), MXR_GRP_CFG_FORMAT_MASK);
+
+	/* setup geometry */
+	mixer_reg_write(res, MXR_GRAPHIC_SPAN(win), full_width);
+
+	val  = MXR_GRP_WH_WIDTH(width);
+	val |= MXR_GRP_WH_HEIGHT(height);
+	val |= MXR_GRP_WH_H_SCALE(x_ratio);
+	val |= MXR_GRP_WH_V_SCALE(y_ratio);
+	mixer_reg_write(res, MXR_GRAPHIC_WH(win), val);
+
+	/* setup offsets in source image */
+	val  = MXR_GRP_SXY_SX(src_x_offset);
+	val |= MXR_GRP_SXY_SY(src_y_offset);
+	mixer_reg_write(res, MXR_GRAPHIC_SXY(win), val);
+
+	/* setup offsets in display image */
+	val  = MXR_GRP_DXY_DX(dst_x_offset);
+	val |= MXR_GRP_DXY_DY(dst_y_offset);
+	mixer_reg_write(res, MXR_GRAPHIC_DXY(win), val);
+
+	/* set buffer address to mixer */
+	val = paddr ? ~0 : 0;
+	if (win == 0)
+		mixer_reg_writemask(res, MXR_CFG, val, MXR_CFG_GRP0_ENABLE);
+	else
+		mixer_reg_writemask(res, MXR_CFG, val, MXR_CFG_GRP1_ENABLE);
+	mixer_reg_write(res, MXR_GRAPHIC_BASE(win), paddr);
+
+	/* choosing between interlace and progressive mode */
+	val = (ctx->interlace ? MXR_CFG_SCAN_INTERLACE :
+				MXR_CFG_SCAN_PROGRASSIVE);
+
+	/* choosing between porper HD and SD mode */
+	if (mode_height == 480) {
+		val |= MXR_CFG_SCAN_NTSC | MXR_CFG_SCAN_SD;
+		val |= MXR_CFG_RGB601_0_255;
+	} else if (mode_height == 576) {
+		val |= MXR_CFG_SCAN_PAL | MXR_CFG_SCAN_SD;
+		val |= MXR_CFG_RGB601_0_255;
+	} else if (mode_height == 720) {
+		val |= MXR_CFG_SCAN_HD_720 | MXR_CFG_SCAN_HD;
+		val |= MXR_CFG_RGB709_16_235;
+		mixer_reg_write(res, MXR_CM_COEFF_Y,
+				(1 << 30) | (94 << 20) | (314 << 10) |
+				(32 << 0));
+		mixer_reg_write(res, MXR_CM_COEFF_CB,
+				(972 << 20) | (851 << 10) | (225 << 0));
+		mixer_reg_write(res, MXR_CM_COEFF_CR,
+				(225 << 20) | (820 << 10) | (1004 << 0));
+	} else if (mode_height == 1080) {
+		val |= MXR_CFG_SCAN_HD_1080 | MXR_CFG_SCAN_HD;
+		val |= MXR_CFG_RGB709_16_235;
+		mixer_reg_write(res, MXR_CM_COEFF_Y,
+				(1 << 30) | (94 << 20) | (314 << 10) |
+				(32 << 0));
+		mixer_reg_write(res, MXR_CM_COEFF_CB,
+				(972 << 20) | (851 << 10) | (225 << 0));
+		mixer_reg_write(res, MXR_CM_COEFF_CR,
+				(225 << 20) | (820 << 10) | (1004 << 0));
+	} else {
+		val |= MXR_CFG_SCAN_HD_720 | MXR_CFG_SCAN_HD;
+		val |= MXR_CFG_RGB709_16_235;
+		mixer_reg_write(res, MXR_CM_COEFF_Y,
+				(1 << 30) | (94 << 20) | (314 << 10) |
+				(32 << 0));
+		mixer_reg_write(res, MXR_CM_COEFF_CB,
+				(972 << 20) | (851 << 10) | (225 << 0));
+		mixer_reg_write(res, MXR_CM_COEFF_CR,
+				(225 << 20) | (820 << 10) | (1004 << 0));
+	}
+
+	mixer_reg_writemask(res, MXR_CFG, val, MXR_CFG_SCAN_MASK);
+
+	mixer_reg_writemask(res, MXR_STATUS, ~0, MXR_STATUS_REG_RUN);
+
+	spin_unlock_irqrestore(&res->reg_slock, flags);
+	mixer_regs_dump(ctx);
+}
+
+static void vp_win_reset(struct mixer_context *ctx)
+{
+	struct mixer_resources *res = &ctx->mixer_res;
+	int tries = 100;
+
+	vp_reg_write(res, VP_SRESET, VP_SRESET_PROCESSING);
+	for (tries = 100; tries; --tries) {
+		/* waiting until VP_SRESET_PROCESSING is 0 */
+		if (~vp_reg_read(res, VP_SRESET) & VP_SRESET_PROCESSING)
+			break;
+		mdelay(10);
+	}
+	WARN(tries == 0, "failed to reset Video Processor\n");
+}
+
+static int mixer_enable_vblank(void *ctx, int pipe)
+{
+	struct mixer_context *mixer_ctx = ctx;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	mixer_ctx->pipe = pipe;
+
+	mixer_vsync_set_update(mixer_ctx, true);
+
+	return 0;
+}
+
+static void mixer_disable_vblank(void *ctx)
+{
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	mixer_vsync_set_update(ctx, false);
+}
+
+static void mixer_clear_win(struct mixer_context *ctx, int win)
+{
+	struct hdmi_win_data *win_data;
+
+	if (win < 0 || win > HDMI_OVERLAY_NUMBER) {
+		DRM_ERROR("overlay plane[%d] is wrong\n", win);
+		return;
+	}
+
+	win_data = &ctx->win_data[win];
+	memset(win_data, 0x00, sizeof(*win_data));
+}
+
+static void mixer_win_mode_set(void *ctx,
+			      struct exynos_drm_overlay *overlay)
+{
+	struct mixer_context *mixer_ctx = ctx;
+	struct hdmi_win_data *win_data;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	if (!overlay) {
+		DRM_ERROR("overlay is NULL\n");
+		return;
+	}
+
+	DRM_DEBUG_KMS("set [%d]x[%d] at (%d,%d) to [%d]x[%d] at (%d,%d)\n",
+				 overlay->fb_width, overlay->fb_height,
+				 overlay->fb_x, overlay->fb_y,
+				 overlay->crtc_width, overlay->crtc_height,
+				 overlay->crtc_x, overlay->crtc_y);
+
+	win_data = &mixer_ctx->win_data[mixer_ctx->default_win];
+
+	win_data->paddr = overlay->paddr;
+	win_data->vaddr = overlay->vaddr;
+	win_data->bpp = overlay->bpp;
+
+	win_data->crtc_x = overlay->crtc_x;
+	win_data->crtc_y = overlay->crtc_y;
+	win_data->crtc_width = overlay->crtc_width;
+	win_data->crtc_height = overlay->crtc_height;
+
+	win_data->fb_x = overlay->fb_x;
+	win_data->fb_y = overlay->fb_y;
+	win_data->fb_width = overlay->fb_width;
+	win_data->fb_height = overlay->fb_height;
+
+	win_data->mode_width = overlay->mode_width;
+	win_data->mode_height = overlay->mode_height;
+
+	win_data->scan_flags = overlay->scan_flag;
+}
+
+static void mixer_win_commit(void *ctx)
+{
+	struct mixer_context *mixer_ctx = ctx;
+	int win = mixer_ctx->default_win;
+
+	DRM_DEBUG_KMS("[%d] %s, win: %d\n", __LINE__, __func__, win);
+
+	mixer_graph_buffer(mixer_ctx, win);
+}
+
+static void mixer_win_disable(void *ctx)
+{
+	struct mixer_context *mixer_ctx = ctx;
+	struct hdmi_win_data *win_data;
+	int win = mixer_ctx->default_win;
+
+	DRM_DEBUG_KMS("[%d] %s, win: %d\n", __LINE__, __func__, win);
+
+	if (win < 0 || win > HDMI_OVERLAY_NUMBER)
+		return;
+
+	win_data = &mixer_ctx->win_data[win];
+
+	mixer_clear_win(mixer_ctx, win);
+	mixer_graph_buffer(mixer_ctx, win);
+}
+
+static struct exynos_hdmi_overlay_ops overlay_ops = {
+	.enable_vblank		= mixer_enable_vblank,
+	.disable_vblank		= mixer_disable_vblank,
+	.win_mode_set		= mixer_win_mode_set,
+	.win_commit		= mixer_win_commit,
+	.win_disable		= mixer_win_disable,
+};
+
+/* for pageflip event */
+static void mixer_finish_pageflip(struct drm_device *drm_dev, int crtc)
+{
+	struct exynos_drm_private *dev_priv = drm_dev->dev_private;
+	struct drm_pending_vblank_event *e, *t;
+	struct timeval now;
+	unsigned long flags;
+	bool is_checked = false;
+
+	spin_lock_irqsave(&drm_dev->event_lock, flags);
+
+	list_for_each_entry_safe(e, t, &dev_priv->pageflip_event_list,
+			base.link) {
+		/* if event's pipe isn't same as crtc then ignore it. */
+		if (crtc != e->pipe)
+			continue;
+
+		is_checked = true;
+		do_gettimeofday(&now);
+		e->event.sequence = 0;
+		e->event.tv_sec = now.tv_sec;
+		e->event.tv_usec = now.tv_usec;
+
+		list_move_tail(&e->base.link, &e->base.file_priv->event_list);
+		wake_up_interruptible(&e->base.file_priv->event_wait);
+	}
+
+	if (is_checked)
+		drm_vblank_put(drm_dev, crtc);
+
+	spin_unlock_irqrestore(&drm_dev->event_lock, flags);
+}
+
+static irqreturn_t mixer_irq_handler(int irq, void *arg)
+{
+	struct exynos_drm_hdmi_context *drm_hdmi_ctx = arg;
+	struct mixer_context *ctx =
+			(struct mixer_context *)drm_hdmi_ctx->ctx;
+	struct mixer_resources *res = &ctx->mixer_res;
+	u32 val, val_base;
+
+	spin_lock(&res->reg_slock);
+
+	/* read interrupt status for handling and clearing flags for VSYNC */
+	val = mixer_reg_read(res, MXR_INT_STATUS);
+
+	/* handling VSYNC */
+	if (val & MXR_INT_STATUS_VSYNC) {
+		/* interlace scan need to check shadow register */
+		if (ctx->interlace) {
+			val_base = mixer_reg_read(res, MXR_GRAPHIC_BASE_S(0));
+			if (ctx->win_data[0].paddr != val_base)
+				goto out;
+
+			val_base = mixer_reg_read(res, MXR_GRAPHIC_BASE_S(1));
+			if (ctx->win_data[1].paddr != val_base)
+				goto out;
+		}
+
+		drm_handle_vblank(drm_hdmi_ctx->drm_dev, ctx->pipe);
+		mixer_finish_pageflip(drm_hdmi_ctx->drm_dev, ctx->pipe);
+	}
+
+out:
+	/* clear interrupts */
+	if (~val & MXR_INT_EN_VSYNC) {
+		/* vsync interrupt use different bit for read and clear */
+		val &= ~MXR_INT_EN_VSYNC;
+		val |= MXR_INT_CLEAR_VSYNC;
+	}
+	mixer_reg_write(res, MXR_INT_STATUS, val);
+
+	spin_unlock(&res->reg_slock);
+
+	return IRQ_HANDLED;
+}
+
+static void mixer_win_reset(struct mixer_context *ctx)
+{
+	struct mixer_resources *res = &ctx->mixer_res;
+	unsigned long flags;
+	u32 val; /* value stored to register */
+
+	spin_lock_irqsave(&res->reg_slock, flags);
+
+	mixer_reg_writemask(res, MXR_CFG, MXR_CFG_DST_HDMI, MXR_CFG_DST_MASK);
+
+	/* set output in RGB888 mode */
+	mixer_reg_writemask(res, MXR_CFG, MXR_CFG_OUT_RGB888, MXR_CFG_OUT_MASK);
+
+	/* 16 beat burst in DMA */
+	mixer_reg_writemask(res, MXR_STATUS, MXR_STATUS_16_BURST,
+		MXR_STATUS_BURST_MASK);
+
+	/* setting default layer priority: layer1 > video > layer0
+	 * because typical usage scenario would be
+	 * layer0 - framebuffer
+	 * video - video overlay
+	 * layer1 - OSD
+	 */
+	val  = MXR_LAYER_CFG_GRP0_VAL(1);
+	val |= MXR_LAYER_CFG_VP_VAL(2);
+	val |= MXR_LAYER_CFG_GRP1_VAL(3);
+	mixer_reg_write(res, MXR_LAYER_CFG, val);
+
+	/* use dark gray background color */
+	mixer_reg_write(res, MXR_BG_COLOR0, 0x008080);
+	mixer_reg_write(res, MXR_BG_COLOR1, 0x008080);
+	mixer_reg_write(res, MXR_BG_COLOR2, 0x008080);
+
+	/* setting graphical layers */
+
+	val  = MXR_GRP_CFG_COLOR_KEY_DISABLE; /* no blank key */
+	val |= MXR_GRP_CFG_WIN_BLEND_EN;
+	val |= MXR_GRP_CFG_ALPHA_VAL(0xff); /* non-transparent alpha */
+
+	/* the same configuration for both layers */
+	mixer_reg_write(res, MXR_GRAPHIC_CFG(0), val);
+
+	val |= MXR_GRP_CFG_BLEND_PRE_MUL;
+	val |= MXR_GRP_CFG_PIXEL_BLEND_EN;
+	mixer_reg_write(res, MXR_GRAPHIC_CFG(1), val);
+
+	/* configuration of Video Processor Registers */
+	vp_win_reset(ctx);
+#if 0
+	vp_default_filter(res);
+#endif
+
+	mixer_reg_writemask(res, MXR_CFG, 0, MXR_CFG_GRP0_ENABLE);
+	mixer_reg_writemask(res, MXR_CFG, 0, MXR_CFG_GRP0_ENABLE);
+
+	spin_unlock_irqrestore(&res->reg_slock, flags);
+}
+
+static void mixer_resource_poweron(struct mixer_context *ctx)
+{
+	struct mixer_resources *res = &ctx->mixer_res;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	clk_enable(res->mixer);
+	clk_enable(res->vp);
+	clk_enable(res->sclk_mixer);
+
+	mixer_win_reset(ctx);
+}
+
+static void mixer_resource_poweroff(struct mixer_context *ctx)
+{
+	struct mixer_resources *res = &ctx->mixer_res;
+
+	DRM_DEBUG_KMS("[%d] %s\n", __LINE__, __func__);
+
+	clk_disable(res->mixer);
+	clk_disable(res->vp);
+	clk_disable(res->sclk_mixer);
+}
+
+static int mixer_runtime_resume(struct device *dev)
+{
+	struct exynos_drm_hdmi_context *ctx = get_mixer_context(dev);
+
+	DRM_DEBUG_KMS("resume - start\n");
+
+	mixer_resource_poweron((struct mixer_context *)ctx->ctx);
+
+	return 0;
+}
+
+static int mixer_runtime_suspend(struct device *dev)
+{
+	struct exynos_drm_hdmi_context *ctx = get_mixer_context(dev);
+
+	DRM_DEBUG_KMS("suspend - start\n");
+
+	mixer_resource_poweroff((struct mixer_context *)ctx->ctx);
+
+	return 0;
+}
+
+static const struct dev_pm_ops mixer_pm_ops = {
+	.runtime_suspend = mixer_runtime_suspend,
+	.runtime_resume	 = mixer_runtime_resume,
+};
+
+static int __devinit mixer_resources_init(struct exynos_drm_hdmi_context *ctx,
+				 struct platform_device *pdev)
+{
+	struct mixer_context *mixer_ctx =
+			(struct mixer_context *)ctx->ctx;
+	struct device *dev = &pdev->dev;
+	struct mixer_resources *mixer_res = &mixer_ctx->mixer_res;
+	struct resource *res;
+	int ret;
+
+	mixer_res->dev = dev;
+	spin_lock_init(&mixer_res->reg_slock);
+
+	mixer_res->mixer = clk_get(dev, "mixer");
+	if (IS_ERR_OR_NULL(mixer_res->mixer)) {
+		dev_err(dev, "failed to get clock 'mixer'\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+	mixer_res->vp = clk_get(dev, "vp");
+	if (IS_ERR_OR_NULL(mixer_res->vp)) {
+		dev_err(dev, "failed to get clock 'vp'\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+	mixer_res->sclk_mixer = clk_get(dev, "sclk_mixer");
+	if (IS_ERR_OR_NULL(mixer_res->sclk_mixer)) {
+		dev_err(dev, "failed to get clock 'sclk_mixer'\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+	mixer_res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
+	if (IS_ERR_OR_NULL(mixer_res->sclk_hdmi)) {
+		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+	mixer_res->sclk_dac = clk_get(dev, "sclk_dac");
+	if (IS_ERR_OR_NULL(mixer_res->sclk_dac)) {
+		dev_err(dev, "failed to get clock 'sclk_dac'\n");
+		ret = -ENODEV;
+		goto fail;
+	}
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
+	if (res == NULL) {
+		dev_err(dev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	clk_set_parent(mixer_res->sclk_mixer, mixer_res->sclk_hdmi);
+
+	mixer_res->mixer_regs = ioremap(res->start, resource_size(res));
+	if (mixer_res->mixer_regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vp");
+	if (res == NULL) {
+		dev_err(dev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail_mixer_regs;
+	}
+
+	mixer_res->vp_regs = ioremap(res->start, resource_size(res));
+	if (mixer_res->vp_regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_mixer_regs;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "irq");
+	if (res == NULL) {
+		dev_err(dev, "get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto fail_vp_regs;
+	}
+
+	ret = request_irq(res->start, mixer_irq_handler, 0, "drm_mixer", ctx);
+	if (ret) {
+		dev_err(dev, "request interrupt failed.\n");
+		goto fail_vp_regs;
+	}
+	mixer_res->irq = res->start;
+
+	return 0;
+
+fail_vp_regs:
+	iounmap(mixer_res->vp_regs);
+
+fail_mixer_regs:
+	iounmap(mixer_res->mixer_regs);
+
+fail:
+	if (!IS_ERR_OR_NULL(mixer_res->sclk_dac))
+		clk_put(mixer_res->sclk_dac);
+	if (!IS_ERR_OR_NULL(mixer_res->sclk_hdmi))
+		clk_put(mixer_res->sclk_hdmi);
+	if (!IS_ERR_OR_NULL(mixer_res->sclk_mixer))
+		clk_put(mixer_res->sclk_mixer);
+	if (!IS_ERR_OR_NULL(mixer_res->vp))
+		clk_put(mixer_res->vp);
+	if (!IS_ERR_OR_NULL(mixer_res->mixer))
+		clk_put(mixer_res->mixer);
+	mixer_res->dev = NULL;
+	return ret;
+}
+
+static void mixer_resources_cleanup(struct mixer_context *ctx)
+{
+	struct mixer_resources *res = &ctx->mixer_res;
+
+	disable_irq(res->irq);
+	free_irq(res->irq, ctx);
+
+	iounmap(res->vp_regs);
+	iounmap(res->mixer_regs);
+}
+
+static int __devinit mixer_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct exynos_drm_hdmi_context *drm_hdmi_ctx;
+	struct mixer_context *ctx;
+	int ret;
+
+	dev_info(dev, "probe start\n");
+
+	drm_hdmi_ctx = kzalloc(sizeof(*drm_hdmi_ctx), GFP_KERNEL);
+	if (!drm_hdmi_ctx) {
+		DRM_ERROR("failed to allocate common hdmi context.\n");
+		return -ENOMEM;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		DRM_ERROR("failed to alloc mixer context.\n");
+		kfree(drm_hdmi_ctx);
+		return -ENOMEM;
+	}
+
+	drm_hdmi_ctx->ctx = (void *)ctx;
+
+	platform_set_drvdata(pdev, drm_hdmi_ctx);
+
+	/* acquire resources: regs, irqs, clocks */
+	ret = mixer_resources_init(drm_hdmi_ctx, pdev);
+	if (ret)
+		goto fail;
+
+	/* register specific callback point to common hdmi. */
+	exynos_drm_overlay_ops_register(&overlay_ops);
+
+	mixer_resource_poweron(ctx);
+
+	return 0;
+
+
+fail:
+	dev_info(dev, "probe failed\n");
+	return ret;
+}
+
+static int mixer_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct exynos_drm_hdmi_context *drm_hdmi_ctx =
+					platform_get_drvdata(pdev);
+	struct mixer_context *ctx = (struct mixer_context *)drm_hdmi_ctx->ctx;
+
+	dev_info(dev, "remove sucessful\n");
+
+	mixer_resource_poweroff(ctx);
+	mixer_resources_cleanup(ctx);
+
+	return 0;
+}
+
+struct platform_driver mixer_driver = {
+	.driver = {
+		.name = "s5p-mixer",
+		.owner = THIS_MODULE,
+		.pm = &mixer_pm_ops,
+	},
+	.probe = mixer_probe,
+	.remove = __devexit_p(mixer_remove),
+};
+EXPORT_SYMBOL(mixer_driver);
+
+MODULE_AUTHOR("Seung-Woo Kim, <sw0312.kim@samsung.com>");
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
+MODULE_DESCRIPTION("Samsung DRM HDMI mixer Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/exynos/exynos_mixer.h b/drivers/gpu/drm/exynos/exynos_mixer.h
new file mode 100644
index 0000000..4745a45
--- /dev/null
+++ b/drivers/gpu/drm/exynos/exynos_mixer.h
@@ -0,0 +1,87 @@
+/*
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Seung-Woo Kim <sw0312.kim@samsung.com>
+ *	Inki Dae <inki.dae@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _EXYNOS_MIXER_H_
+#define _EXYNOS_MIXER_H_
+
+#define HDMI_OVERLAY_NUMBER	3
+
+struct hdmi_win_data {
+	unsigned int		paddr;
+	void __iomem		*vaddr;
+	unsigned int		bpp;
+	unsigned int		crtc_x;
+	unsigned int		crtc_y;
+	unsigned int		crtc_width;
+	unsigned int		crtc_height;
+	unsigned int		fb_x;
+	unsigned int		fb_y;
+	unsigned int		fb_width;
+	unsigned int		fb_height;
+	unsigned int		mode_width;
+	unsigned int		mode_height;
+	unsigned int		scan_flags;
+};
+
+struct mixer_resources {
+	struct device *dev;
+	/** interrupt index */
+	int irq;
+	/** pointer to Mixer registers */
+	void __iomem *mixer_regs;
+	/** pointer to Video Processor registers */
+	void __iomem *vp_regs;
+	/** spinlock for protection of registers */
+	spinlock_t reg_slock;
+	/** other resources */
+	struct clk *mixer;
+	struct clk *vp;
+	struct clk *sclk_mixer;
+	struct clk *sclk_hdmi;
+	struct clk *sclk_dac;
+};
+
+struct mixer_context {
+	unsigned int			default_win;
+	struct fb_videomode		*default_timing;
+	unsigned int			default_bpp;
+
+	/** mixer interrupt */
+	unsigned int irq;
+	/** current crtc pipe for vblank */
+	int pipe;
+	/** interlace scan mode */
+	bool interlace;
+
+	/** mixer and vp resources */
+	struct mixer_resources mixer_res;
+
+	/** overlay window data */
+	struct hdmi_win_data		win_data[HDMI_OVERLAY_NUMBER];
+};
+
+#endif
diff --git a/drivers/gpu/drm/exynos/regs-hdmi.h b/drivers/gpu/drm/exynos/regs-hdmi.h
new file mode 100644
index 0000000..72e6b52
--- /dev/null
+++ b/drivers/gpu/drm/exynos/regs-hdmi.h
@@ -0,0 +1,147 @@
+/*
+ *
+ *  Cloned from drivers/media/video/s5p-tv/regs-hdmi.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * HDMI register header file for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef SAMSUNG_REGS_HDMI_H
+#define SAMSUNG_REGS_HDMI_H
+
+/*
+ * Register part
+*/
+
+#define HDMI_CTRL_BASE(x)		((x) + 0x00000000)
+#define HDMI_CORE_BASE(x)		((x) + 0x00010000)
+#define HDMI_TG_BASE(x)			((x) + 0x00050000)
+
+/* Control registers */
+#define HDMI_INTC_CON			HDMI_CTRL_BASE(0x0000)
+#define HDMI_INTC_FLAG			HDMI_CTRL_BASE(0x0004)
+#define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
+#define HDMI_PHY_RSTOUT			HDMI_CTRL_BASE(0x0014)
+#define HDMI_PHY_VPLL			HDMI_CTRL_BASE(0x0018)
+#define HDMI_PHY_CMU			HDMI_CTRL_BASE(0x001C)
+#define HDMI_CORE_RSTOUT		HDMI_CTRL_BASE(0x0020)
+
+/* Core registers */
+#define HDMI_CON_0			HDMI_CORE_BASE(0x0000)
+#define HDMI_CON_1			HDMI_CORE_BASE(0x0004)
+#define HDMI_CON_2			HDMI_CORE_BASE(0x0008)
+#define HDMI_SYS_STATUS			HDMI_CORE_BASE(0x0010)
+#define HDMI_PHY_STATUS			HDMI_CORE_BASE(0x0014)
+#define HDMI_STATUS_EN			HDMI_CORE_BASE(0x0020)
+#define HDMI_HPD			HDMI_CORE_BASE(0x0030)
+#define HDMI_MODE_SEL			HDMI_CORE_BASE(0x0040)
+#define HDMI_BLUE_SCREEN_0		HDMI_CORE_BASE(0x0050)
+#define HDMI_BLUE_SCREEN_1		HDMI_CORE_BASE(0x0054)
+#define HDMI_BLUE_SCREEN_2		HDMI_CORE_BASE(0x0058)
+#define HDMI_H_BLANK_0			HDMI_CORE_BASE(0x00A0)
+#define HDMI_H_BLANK_1			HDMI_CORE_BASE(0x00A4)
+#define HDMI_V_BLANK_0			HDMI_CORE_BASE(0x00B0)
+#define HDMI_V_BLANK_1			HDMI_CORE_BASE(0x00B4)
+#define HDMI_V_BLANK_2			HDMI_CORE_BASE(0x00B8)
+#define HDMI_H_V_LINE_0			HDMI_CORE_BASE(0x00C0)
+#define HDMI_H_V_LINE_1			HDMI_CORE_BASE(0x00C4)
+#define HDMI_H_V_LINE_2			HDMI_CORE_BASE(0x00C8)
+#define HDMI_VSYNC_POL			HDMI_CORE_BASE(0x00E4)
+#define HDMI_INT_PRO_MODE		HDMI_CORE_BASE(0x00E8)
+#define HDMI_V_BLANK_F_0		HDMI_CORE_BASE(0x0110)
+#define HDMI_V_BLANK_F_1		HDMI_CORE_BASE(0x0114)
+#define HDMI_V_BLANK_F_2		HDMI_CORE_BASE(0x0118)
+#define HDMI_H_SYNC_GEN_0		HDMI_CORE_BASE(0x0120)
+#define HDMI_H_SYNC_GEN_1		HDMI_CORE_BASE(0x0124)
+#define HDMI_H_SYNC_GEN_2		HDMI_CORE_BASE(0x0128)
+#define HDMI_V_SYNC_GEN_1_0		HDMI_CORE_BASE(0x0130)
+#define HDMI_V_SYNC_GEN_1_1		HDMI_CORE_BASE(0x0134)
+#define HDMI_V_SYNC_GEN_1_2		HDMI_CORE_BASE(0x0138)
+#define HDMI_V_SYNC_GEN_2_0		HDMI_CORE_BASE(0x0140)
+#define HDMI_V_SYNC_GEN_2_1		HDMI_CORE_BASE(0x0144)
+#define HDMI_V_SYNC_GEN_2_2		HDMI_CORE_BASE(0x0148)
+#define HDMI_V_SYNC_GEN_3_0		HDMI_CORE_BASE(0x0150)
+#define HDMI_V_SYNC_GEN_3_1		HDMI_CORE_BASE(0x0154)
+#define HDMI_V_SYNC_GEN_3_2		HDMI_CORE_BASE(0x0158)
+#define HDMI_ACR_CON			HDMI_CORE_BASE(0x0180)
+#define HDMI_AVI_CON			HDMI_CORE_BASE(0x0300)
+#define HDMI_AVI_BYTE(n)		HDMI_CORE_BASE(0x0320 + 4 * (n))
+#define HDMI_DC_CONTROL			HDMI_CORE_BASE(0x05C0)
+#define HDMI_VIDEO_PATTERN_GEN		HDMI_CORE_BASE(0x05C4)
+#define HDMI_HPD_GEN			HDMI_CORE_BASE(0x05C8)
+#define HDMI_AUI_CON			HDMI_CORE_BASE(0x0360)
+#define HDMI_SPD_CON			HDMI_CORE_BASE(0x0400)
+
+/* Timing generator registers */
+#define HDMI_TG_CMD			HDMI_TG_BASE(0x0000)
+#define HDMI_TG_H_FSZ_L			HDMI_TG_BASE(0x0018)
+#define HDMI_TG_H_FSZ_H			HDMI_TG_BASE(0x001C)
+#define HDMI_TG_HACT_ST_L		HDMI_TG_BASE(0x0020)
+#define HDMI_TG_HACT_ST_H		HDMI_TG_BASE(0x0024)
+#define HDMI_TG_HACT_SZ_L		HDMI_TG_BASE(0x0028)
+#define HDMI_TG_HACT_SZ_H		HDMI_TG_BASE(0x002C)
+#define HDMI_TG_V_FSZ_L			HDMI_TG_BASE(0x0030)
+#define HDMI_TG_V_FSZ_H			HDMI_TG_BASE(0x0034)
+#define HDMI_TG_VSYNC_L			HDMI_TG_BASE(0x0038)
+#define HDMI_TG_VSYNC_H			HDMI_TG_BASE(0x003C)
+#define HDMI_TG_VSYNC2_L		HDMI_TG_BASE(0x0040)
+#define HDMI_TG_VSYNC2_H		HDMI_TG_BASE(0x0044)
+#define HDMI_TG_VACT_ST_L		HDMI_TG_BASE(0x0048)
+#define HDMI_TG_VACT_ST_H		HDMI_TG_BASE(0x004C)
+#define HDMI_TG_VACT_SZ_L		HDMI_TG_BASE(0x0050)
+#define HDMI_TG_VACT_SZ_H		HDMI_TG_BASE(0x0054)
+#define HDMI_TG_FIELD_CHG_L		HDMI_TG_BASE(0x0058)
+#define HDMI_TG_FIELD_CHG_H		HDMI_TG_BASE(0x005C)
+#define HDMI_TG_VACT_ST2_L		HDMI_TG_BASE(0x0060)
+#define HDMI_TG_VACT_ST2_H		HDMI_TG_BASE(0x0064)
+#define HDMI_TG_VSYNC_TOP_HDMI_L	HDMI_TG_BASE(0x0078)
+#define HDMI_TG_VSYNC_TOP_HDMI_H	HDMI_TG_BASE(0x007C)
+#define HDMI_TG_VSYNC_BOT_HDMI_L	HDMI_TG_BASE(0x0080)
+#define HDMI_TG_VSYNC_BOT_HDMI_H	HDMI_TG_BASE(0x0084)
+#define HDMI_TG_FIELD_TOP_HDMI_L	HDMI_TG_BASE(0x0088)
+#define HDMI_TG_FIELD_TOP_HDMI_H	HDMI_TG_BASE(0x008C)
+#define HDMI_TG_FIELD_BOT_HDMI_L	HDMI_TG_BASE(0x0090)
+#define HDMI_TG_FIELD_BOT_HDMI_H	HDMI_TG_BASE(0x0094)
+
+/*
+ * Bit definition part
+ */
+
+/* HDMI_INTC_CON */
+#define HDMI_INTC_EN_GLOBAL		(1 << 6)
+#define HDMI_INTC_EN_HPD_PLUG		(1 << 3)
+#define HDMI_INTC_EN_HPD_UNPLUG		(1 << 2)
+
+/* HDMI_INTC_FLAG */
+#define HDMI_INTC_FLAG_HPD_PLUG		(1 << 3)
+#define HDMI_INTC_FLAG_HPD_UNPLUG	(1 << 2)
+
+/* HDMI_PHY_RSTOUT */
+#define HDMI_PHY_SW_RSTOUT		(1 << 0)
+
+/* HDMI_CORE_RSTOUT */
+#define HDMI_CORE_SW_RSTOUT		(1 << 0)
+
+/* HDMI_CON_0 */
+#define HDMI_BLUE_SCR_EN		(1 << 5)
+#define HDMI_EN				(1 << 0)
+
+/* HDMI_PHY_STATUS */
+#define HDMI_PHY_STATUS_READY		(1 << 0)
+
+/* HDMI_MODE_SEL */
+#define HDMI_MODE_HDMI_EN		(1 << 1)
+#define HDMI_MODE_DVI_EN		(1 << 0)
+#define HDMI_MODE_MASK			(3 << 0)
+
+/* HDMI_TG_CMD */
+#define HDMI_TG_EN			(1 << 0)
+#define HDMI_FIELD_EN			(1 << 1)
+
+#endif /* SAMSUNG_REGS_HDMI_H */
diff --git a/drivers/gpu/drm/exynos/regs-mixer.h b/drivers/gpu/drm/exynos/regs-mixer.h
new file mode 100644
index 0000000..9aeeaae
--- /dev/null
+++ b/drivers/gpu/drm/exynos/regs-mixer.h
@@ -0,0 +1,139 @@
+/*
+ *
+ *  Cloned from drivers/media/video/s5p-tv/regs-mixer.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * Mixer register header file for Samsung Mixer driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+#ifndef SAMSUNG_REGS_MIXER_H
+#define SAMSUNG_REGS_MIXER_H
+
+/*
+ * Register part
+ */
+#define MXR_STATUS			0x0000
+#define MXR_CFG				0x0004
+#define MXR_INT_EN			0x0008
+#define MXR_INT_STATUS			0x000C
+#define MXR_LAYER_CFG			0x0010
+#define MXR_VIDEO_CFG			0x0014
+#define MXR_GRAPHIC0_CFG		0x0020
+#define MXR_GRAPHIC0_BASE		0x0024
+#define MXR_GRAPHIC0_SPAN		0x0028
+#define MXR_GRAPHIC0_SXY		0x002C
+#define MXR_GRAPHIC0_WH			0x0030
+#define MXR_GRAPHIC0_DXY		0x0034
+#define MXR_GRAPHIC0_BLANK		0x0038
+#define MXR_GRAPHIC1_CFG		0x0040
+#define MXR_GRAPHIC1_BASE		0x0044
+#define MXR_GRAPHIC1_SPAN		0x0048
+#define MXR_GRAPHIC1_SXY		0x004C
+#define MXR_GRAPHIC1_WH			0x0050
+#define MXR_GRAPHIC1_DXY		0x0054
+#define MXR_GRAPHIC1_BLANK		0x0058
+#define MXR_BG_CFG			0x0060
+#define MXR_BG_COLOR0			0x0064
+#define MXR_BG_COLOR1			0x0068
+#define MXR_BG_COLOR2			0x006C
+#define MXR_CM_COEFF_Y			0x0080
+#define MXR_CM_COEFF_CB			0x0084
+#define MXR_CM_COEFF_CR			0x0088
+#define MXR_GRAPHIC0_BASE_S		0x2024
+#define MXR_GRAPHIC1_BASE_S		0x2044
+
+/* for parametrized access to layer registers */
+#define MXR_GRAPHIC_CFG(i)		(0x0020 + (i) * 0x20)
+#define MXR_GRAPHIC_BASE(i)		(0x0024 + (i) * 0x20)
+#define MXR_GRAPHIC_SPAN(i)		(0x0028 + (i) * 0x20)
+#define MXR_GRAPHIC_SXY(i)		(0x002C + (i) * 0x20)
+#define MXR_GRAPHIC_WH(i)		(0x0030 + (i) * 0x20)
+#define MXR_GRAPHIC_DXY(i)		(0x0034 + (i) * 0x20)
+#define MXR_GRAPHIC_BLANK(i)		(0x0038 + (i) * 0x20)
+#define MXR_GRAPHIC_BASE_S(i)		(0x2024 + (i) * 0x20)
+
+/*
+ * Bit definition part
+ */
+
+/* generates mask for range of bits */
+#define MXR_MASK(high_bit, low_bit) \
+	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
+
+#define MXR_MASK_VAL(val, high_bit, low_bit) \
+	(((val) << (low_bit)) & MXR_MASK(high_bit, low_bit))
+
+/* bits for MXR_STATUS */
+#define MXR_STATUS_16_BURST		(1 << 7)
+#define MXR_STATUS_BURST_MASK		(1 << 7)
+#define MXR_STATUS_BIG_ENDIAN		(1 << 3)
+#define MXR_STATUS_ENDIAN_MASK		(1 << 3)
+#define MXR_STATUS_SYNC_ENABLE		(1 << 2)
+#define MXR_STATUS_REG_RUN		(1 << 0)
+
+/* bits for MXR_CFG */
+#define MXR_CFG_RGB601_0_255		(0 << 9)
+#define MXR_CFG_RGB601_16_235		(1 << 9)
+#define MXR_CFG_RGB709_0_255		(2 << 9)
+#define MXR_CFG_RGB709_16_235		(3 << 9)
+#define MXR_CFG_OUT_YUV444		(0 << 8)
+#define MXR_CFG_OUT_RGB888		(1 << 8)
+#define MXR_CFG_OUT_MASK		(1 << 8)
+#define MXR_CFG_DST_SDO			(0 << 7)
+#define MXR_CFG_DST_HDMI		(1 << 7)
+#define MXR_CFG_DST_MASK		(1 << 7)
+#define MXR_CFG_SCAN_HD_720		(0 << 6)
+#define MXR_CFG_SCAN_HD_1080		(1 << 6)
+#define MXR_CFG_GRP1_ENABLE		(1 << 5)
+#define MXR_CFG_GRP0_ENABLE		(1 << 4)
+#define MXR_CFG_VP_ENABLE		(1 << 3)
+#define MXR_CFG_SCAN_INTERLACE		(0 << 2)
+#define MXR_CFG_SCAN_PROGRASSIVE	(1 << 2)
+#define MXR_CFG_SCAN_NTSC		(0 << 1)
+#define MXR_CFG_SCAN_PAL		(1 << 1)
+#define MXR_CFG_SCAN_SD			(0 << 0)
+#define MXR_CFG_SCAN_HD			(1 << 0)
+#define MXR_CFG_SCAN_MASK		0x647
+
+/* bits for MXR_GRAPHICn_CFG */
+#define MXR_GRP_CFG_COLOR_KEY_DISABLE	(1 << 21)
+#define MXR_GRP_CFG_BLEND_PRE_MUL	(1 << 20)
+#define MXR_GRP_CFG_WIN_BLEND_EN	(1 << 17)
+#define MXR_GRP_CFG_PIXEL_BLEND_EN	(1 << 16)
+#define MXR_GRP_CFG_FORMAT_VAL(x)	MXR_MASK_VAL(x, 11, 8)
+#define MXR_GRP_CFG_FORMAT_MASK		MXR_GRP_CFG_FORMAT_VAL(~0)
+#define MXR_GRP_CFG_ALPHA_VAL(x)	MXR_MASK_VAL(x, 7, 0)
+
+/* bits for MXR_GRAPHICn_WH */
+#define MXR_GRP_WH_H_SCALE(x)		MXR_MASK_VAL(x, 28, 28)
+#define MXR_GRP_WH_V_SCALE(x)		MXR_MASK_VAL(x, 12, 12)
+#define MXR_GRP_WH_WIDTH(x)		MXR_MASK_VAL(x, 26, 16)
+#define MXR_GRP_WH_HEIGHT(x)		MXR_MASK_VAL(x, 10, 0)
+
+/* bits for MXR_GRAPHICn_SXY */
+#define MXR_GRP_SXY_SX(x)		MXR_MASK_VAL(x, 26, 16)
+#define MXR_GRP_SXY_SY(x)		MXR_MASK_VAL(x, 10, 0)
+
+/* bits for MXR_GRAPHICn_DXY */
+#define MXR_GRP_DXY_DX(x)		MXR_MASK_VAL(x, 26, 16)
+#define MXR_GRP_DXY_DY(x)		MXR_MASK_VAL(x, 10, 0)
+
+/* bits for MXR_INT_EN */
+#define MXR_INT_EN_VSYNC		(1 << 11)
+#define MXR_INT_EN_ALL			(0x0f << 8)
+
+/* bit for MXR_INT_STATUS */
+#define MXR_INT_CLEAR_VSYNC		(1 << 11)
+#define MXR_INT_STATUS_VSYNC		(1 << 0)
+
+/* bit for MXR_LAYER_CFG */
+#define MXR_LAYER_CFG_GRP1_VAL(x)	MXR_MASK_VAL(x, 11, 8)
+#define MXR_LAYER_CFG_GRP0_VAL(x)	MXR_MASK_VAL(x, 7, 4)
+#define MXR_LAYER_CFG_VP_VAL(x)		MXR_MASK_VAL(x, 3, 0)
+
+#endif /* SAMSUNG_REGS_MIXER_H */
diff --git a/drivers/gpu/drm/exynos/regs-vp.h b/drivers/gpu/drm/exynos/regs-vp.h
new file mode 100644
index 0000000..10b737a
--- /dev/null
+++ b/drivers/gpu/drm/exynos/regs-vp.h
@@ -0,0 +1,91 @@
+/*
+ *
+ *  Cloned from drivers/media/video/s5p-tv/regs-vp.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Video processor register header file for Samsung Mixer driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SAMSUNG_REGS_VP_H
+#define SAMSUNG_REGS_VP_H
+
+/*
+ * Register part
+ */
+
+#define VP_ENABLE			0x0000
+#define VP_SRESET			0x0004
+#define VP_SHADOW_UPDATE		0x0008
+#define VP_FIELD_ID			0x000C
+#define VP_MODE				0x0010
+#define VP_IMG_SIZE_Y			0x0014
+#define VP_IMG_SIZE_C			0x0018
+#define VP_PER_RATE_CTRL		0x001C
+#define VP_TOP_Y_PTR			0x0028
+#define VP_BOT_Y_PTR			0x002C
+#define VP_TOP_C_PTR			0x0030
+#define VP_BOT_C_PTR			0x0034
+#define VP_ENDIAN_MODE			0x03CC
+#define VP_SRC_H_POSITION		0x0044
+#define VP_SRC_V_POSITION		0x0048
+#define VP_SRC_WIDTH			0x004C
+#define VP_SRC_HEIGHT			0x0050
+#define VP_DST_H_POSITION		0x0054
+#define VP_DST_V_POSITION		0x0058
+#define VP_DST_WIDTH			0x005C
+#define VP_DST_HEIGHT			0x0060
+#define VP_H_RATIO			0x0064
+#define VP_V_RATIO			0x0068
+#define VP_POLY8_Y0_LL			0x006C
+#define VP_POLY4_Y0_LL			0x00EC
+#define VP_POLY4_C0_LL			0x012C
+
+/*
+ * Bit definition part
+ */
+
+/* generates mask for range of bits */
+
+#define VP_MASK(high_bit, low_bit) \
+	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
+
+#define VP_MASK_VAL(val, high_bit, low_bit) \
+	(((val) << (low_bit)) & VP_MASK(high_bit, low_bit))
+
+ /* VP_ENABLE */
+#define VP_ENABLE_ON			(1 << 0)
+
+/* VP_SRESET */
+#define VP_SRESET_PROCESSING		(1 << 0)
+
+/* VP_SHADOW_UPDATE */
+#define VP_SHADOW_UPDATE_ENABLE		(1 << 0)
+
+/* VP_MODE */
+#define VP_MODE_NV12			(0 << 6)
+#define VP_MODE_NV21			(1 << 6)
+#define VP_MODE_LINE_SKIP		(1 << 5)
+#define VP_MODE_MEM_LINEAR		(0 << 4)
+#define VP_MODE_MEM_TILED		(1 << 4)
+#define VP_MODE_FMT_MASK		(5 << 4)
+#define VP_MODE_FIELD_ID_AUTO_TOGGLING	(1 << 2)
+#define VP_MODE_2D_IPC			(1 << 1)
+
+/* VP_IMG_SIZE_Y */
+/* VP_IMG_SIZE_C */
+#define VP_IMG_HSIZE(x)			VP_MASK_VAL(x, 29, 16)
+#define VP_IMG_VSIZE(x)			VP_MASK_VAL(x, 13, 0)
+
+/* VP_SRC_H_POSITION */
+#define VP_SRC_H_POSITION_VAL(x)	VP_MASK_VAL(x, 14, 4)
+
+/* VP_ENDIAN_MODE */
+#define VP_ENDIAN_MODE_LITTLE		(1 << 0)
+
+#endif /* SAMSUNG_REGS_VP_H */
diff --git a/include/drm/exynos_drm.h b/include/drm/exynos_drm.h
index 1d161cb..bdbf250 100644
--- a/include/drm/exynos_drm.h
+++ b/include/drm/exynos_drm.h
@@ -103,4 +103,31 @@ struct exynos_drm_fimd_pdata {
 	unsigned int			bpp;
 };
 
+/**
+ * Platform Specific Structure for DRM based HDMI.
+ *
+ * @hdmi_dev: device point to specific hdmi driver.
+ * @mixer_dev: device point to specific mixer driver.
+ *
+ * this structure is used for common hdmi driver and each device object
+ * would be used to access specific device driver(hdmi or mixer driver)
+ */
+struct exynos_drm_common_hdmi_pd {
+	struct device *hdmi_dev;
+	struct device *mixer_dev;
+};
+
+/**
+ * Platform Specific Structure for DRM based HDMI core.
+ *
+ * @timing: default video mode for initializing
+ * @default_win: default window layer number to be used for UI.
+ * @bpp: default bit per pixel.
+ */
+struct exynos_drm_hdmi_pdata {
+	struct fb_videomode		timing;
+	unsigned int			default_win;
+	unsigned int			bpp;
+};
+
 #endif
-- 
1.7.4.1

