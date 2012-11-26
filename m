Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2KZNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:16:26 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3712 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab2KZNQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:16:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 26 Nov 2012 05:16:16 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Arto Merilainen <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
Date: Mon, 26 Nov 2012 15:19:12 +0200
Message-ID: <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arto Merilainen <amerilainen@nvidia.com>

This patch removes the redundant host1x driver from tegradrm and
makes necessary bindings to the separate host driver.

This modification introduces a regression: Because there is no
general framework for attaching separate devices into the
same address space, this patch removes the ability to use IOMMU
in tegradrm.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/drm/tegra/Kconfig  |    8 +-
 drivers/gpu/drm/tegra/Makefile |    2 +-
 drivers/gpu/drm/tegra/dc.c     |   22 +--
 drivers/gpu/drm/tegra/drm.c    |  207 +++++++++++++++++++-----
 drivers/gpu/drm/tegra/drm.h    |   55 ++-----
 drivers/gpu/drm/tegra/dsi.c    |   24 ++-
 drivers/gpu/drm/tegra/fb.c     |   26 ++-
 drivers/gpu/drm/tegra/hdmi.c   |   24 ++-
 drivers/gpu/drm/tegra/host1x.c |  343 ----------------------------------------
 drivers/gpu/drm/tegra/tvo.c    |   33 ++--
 10 files changed, 246 insertions(+), 498 deletions(-)
 delete mode 100644 drivers/gpu/drm/tegra/host1x.c

diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
index affd741..4a0290e 100644
--- a/drivers/gpu/drm/tegra/Kconfig
+++ b/drivers/gpu/drm/tegra/Kconfig
@@ -1,6 +1,6 @@
 config DRM_TEGRA
 	tristate "NVIDIA Tegra DRM"
-	depends on DRM && OF && ARCH_TEGRA
+	depends on DRM && OF && ARCH_TEGRA && TEGRA_HOST1X
 	select DRM_KMS_HELPER
 	select DRM_GEM_CMA_HELPER
 	select DRM_KMS_CMA_HELPER
@@ -20,10 +20,4 @@ config DRM_TEGRA_DEBUG
 	help
 	  Say yes here to enable debugging support.
 
-config DRM_TEGRA_IOMMU
-	bool "NVIDIA Tegra DRM IOMMU support"
-	help
-	  Say yes here to enable the use of the IOMMU to allocate and
-	  map memory buffers.
-
 endif
diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
index e6e96af..57a334d 100644
--- a/drivers/gpu/drm/tegra/Makefile
+++ b/drivers/gpu/drm/tegra/Makefile
@@ -1,7 +1,7 @@
 ccflags-y := -Iinclude/drm
 ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
-tegra-drm-y := drm.o fb.o dc.o host1x.o
+tegra-drm-y := drm.o fb.o dc.o
 tegra-drm-y += output.o rgb.o hdmi.o tvo.o dsi.o
 tegra-drm-y += plane.o
 
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 3a16e93..1779008 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/nvhost.h>
 
 #include <mach/clk.h>
 
@@ -673,10 +674,10 @@ static int tegra_dc_debugfs_exit(struct tegra_dc *dc)
 	return 0;
 }
 
-static int tegra_dc_drm_init(struct host1x_client *client,
+static int tegra_dc_drm_init(struct tegra_drm_client *client,
 			     struct drm_device *drm)
 {
-	struct tegra_dc *dc = host1x_client_to_dc(client);
+	struct tegra_dc *dc = tegra_drm_client_to_dc(client);
 	int err;
 
 	dc->pipe = drm->mode_config.num_crtc;
@@ -712,9 +713,9 @@ static int tegra_dc_drm_init(struct host1x_client *client,
 	return 0;
 }
 
-static int tegra_dc_drm_exit(struct host1x_client *client)
+static int tegra_dc_drm_exit(struct tegra_drm_client *client)
 {
-	struct tegra_dc *dc = host1x_client_to_dc(client);
+	struct tegra_dc *dc = tegra_drm_client_to_dc(client);
 	int err;
 
 	devm_free_irq(dc->dev, dc->irq, dc);
@@ -734,14 +735,13 @@ static int tegra_dc_drm_exit(struct host1x_client *client)
 	return 0;
 }
 
-static const struct host1x_client_ops dc_client_ops = {
+static const struct tegra_drm_client_ops dc_client_ops = {
 	.drm_init = tegra_dc_drm_init,
 	.drm_exit = tegra_dc_drm_exit,
 };
 
 static int tegra_dc_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct resource *regs;
 	struct tegra_dc *dc;
 	int err;
@@ -791,13 +791,14 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	err = host1x_register_client(host1x, &dc->client);
+	err = tegra_drm_register_client(&dc->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to register tegra drm client: %d\n",
 			err);
 		return err;
 	}
 
+	host1x_busy(pdev);
 	platform_set_drvdata(pdev, dc);
 
 	return 0;
@@ -805,13 +806,12 @@ static int tegra_dc_probe(struct platform_device *pdev)
 
 static int tegra_dc_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_unregister_client(host1x, &dc->client);
+	err = tegra_drm_unregister_client(&dc->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to unregister tegra_drm client: %d\n",
 			err);
 		return err;
 	}
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 4a306c2..cba2d1d 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -24,44 +24,137 @@
 #define DRIVER_MINOR 0
 #define DRIVER_PATCHLEVEL 0
 
-#ifdef CONFIG_DRM_TEGRA_IOMMU
-#define TEGRA_DRM_IOMMU_BASE_ADDR	0x20000000
-#define TEGRA_DRM_IOMMU_SIZE		0x10000000
-#endif
+static LIST_HEAD(tegra_drm_subdrv_list);
+static LIST_HEAD(tegra_drm_subdrv_required);
 
-static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
+struct tegra_drm_client_entry {
+	struct device_node *np;
+	struct list_head list;
+};
+
+static int tegra_drm_add_client(struct device_node *np)
+{
+	struct tegra_drm_client_entry *client;
+
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&client->list);
+	client->np = of_node_get(np);
+
+	list_add_tail(&client->list, &tegra_drm_subdrv_required);
+
+	return 0;
+}
+
+static int tegra_drm_parse_dt(void)
 {
-	struct device *dev = drm->dev;
-	struct host1x *host1x;
+	static const char * const compat[] = {
+		"nvidia,tegra20-dc",
+		"nvidia,tegra20-hdmi",
+		"nvidia,tegra20-tvo",
+		"nvidia,tegra20-dsi",
+		"nvidia,tegra30-dc",
+		"nvidia,tegra30-hdmi",
+		"nvidia,tegra30-tvo",
+		"nvidia,tegra30-dsi"
+	};
+	unsigned int i;
 	int err;
+	struct device *dev;
 
-	host1x = dev_get_drvdata(dev);
-	drm->dev_private = host1x;
-	host1x->drm = drm;
+	/* host1x is parent of all devices */
+	dev = bus_find_device_by_name(&platform_bus_type, NULL, "host1x");
+	if (!dev)
+		return -ENODEV;
 
-	drm_mode_config_init(drm);
+	/* find devices that are available and add them into the 'required'
+	 * list */
+	for (i = 0; i < ARRAY_SIZE(compat); i++) {
+		struct device_node *np;
 
-	err = host1x_drm_init(host1x, drm);
-	if (err < 0)
-		return err;
+		for_each_child_of_node(dev->of_node, np) {
+			if (of_device_is_compatible(np, compat[i]) &&
+			    of_device_is_available(np)) {
+				err = tegra_drm_add_client(np);
+				if (err < 0)
+					return err;
+			}
+		}
+	}
 
-#ifdef CONFIG_DRM_TEGRA_IOMMU
-	host1x->dim = arm_iommu_create_mapping(&platform_bus_type,
-					       TEGRA_DRM_IOMMU_BASE_ADDR,
-					       TEGRA_DRM_IOMMU_SIZE, 0);
-	if (IS_ERR_OR_NULL(host1x->dim)) {
-		dev_err(dev, "%s: Create iommu mapping failed: %ld\n", __func__,
-			PTR_ERR(host1x->dim));
-		return PTR_ERR(host1x->dim);
+	return 0;
+}
+
+int tegra_drm_register_client(struct tegra_drm_client *client)
+{
+	struct tegra_drm_client_entry *drm, *tmp;
+	int err;
+
+	list_add_tail(&client->list, &tegra_drm_subdrv_list);
+
+	/* remove this device from 'required' list */
+	list_for_each_entry_safe(drm, tmp, &tegra_drm_subdrv_required, list)
+		if (drm->np == client->dev->of_node)
+			list_del(&drm->list);
+
+	/* if all required devices are found, register drm device */
+	if (list_empty(&tegra_drm_subdrv_required)) {
+		struct platform_device *pdev = to_platform_device(client->dev);
+
+		err = drm_platform_init(&tegra_drm_driver, pdev);
+		if (err < 0) {
+			dev_err(client->dev, "drm_platform_init(): %d\n", err);
+			return err;
+		}
 	}
 
-	err = arm_iommu_attach_device(drm->dev, host1x->dim);
-	if (err < 0) {
-		dev_err(dev, "%s: Attach iommu device failed: %d\n", __func__,
-			err);
-		return err;
+	return 0;
+}
+
+int tegra_drm_unregister_client(struct tegra_drm_client *client)
+{
+	list_for_each_entry(client, &tegra_drm_subdrv_list, list) {
+
+		struct platform_device *pdev = to_platform_device(client->dev);
+
+		if (client->ops && client->ops->drm_exit) {
+			int err = client->ops->drm_exit(client);
+			if (err < 0) {
+				dev_err(client->dev,
+					"DRM cleanup failed for %s: %d\n",
+					dev_name(client->dev), err);
+				return err;
+			}
+		}
+
+		/* if this is the last device, unregister the drm driver */
+		if (client->list.next == &tegra_drm_subdrv_list)
+			drm_platform_exit(&tegra_drm_driver, pdev);
+
+		list_del_init(&client->list);
+	}
+
+	return 0;
+}
+
+static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
+{
+	struct tegra_drm_client *client;
+	int err;
+
+	drm_mode_config_init(drm);
+
+	list_for_each_entry(client, &tegra_drm_subdrv_list, list) {
+		if (client->ops && client->ops->drm_init) {
+			int err = client->ops->drm_init(client, drm);
+			if (err < 0) {
+				dev_dbg(drm->dev, "drm_init() failed for %s: %d\n",
+					dev_name(client->dev), err);
+			}
+		}
 	}
-#endif
 
 	err = tegra_drm_fb_init(drm);
 	if (err < 0)
@@ -74,18 +167,9 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 
 static int tegra_drm_unload(struct drm_device *drm)
 {
-#ifdef CONFIG_DRM_TEGRA_IOMMU
-	struct host1x *host1x = dev_get_drvdata(drm->dev);
-#endif
-
 	drm_kms_helper_poll_fini(drm);
 	tegra_drm_fb_exit(drm);
 
-#ifdef CONFIG_DRM_TEGRA_IOMMU
-	if (host1x->dim)
-		arm_iommu_release_mapping(host1x->dim);
-#endif
-
 	drm_mode_config_cleanup(drm);
 
 	return 0;
@@ -98,10 +182,55 @@ static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
 
 static void tegra_drm_lastclose(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	tegra_drm_fb_restore(drm);
+}
 
-	drm_fbdev_cma_restore_mode(host1x->fbdev);
+static int __init tegra_drm_init(void)
+{
+	int err;
+
+	tegra_drm_parse_dt();
+
+	err = platform_driver_register(&tegra_dc_driver);
+	if (err < 0)
+		return err;
+
+	err = platform_driver_register(&tegra_hdmi_driver);
+	if (err < 0)
+		goto unregister_dc;
+
+	err = platform_driver_register(&tegra_tvo_driver);
+	if (err < 0)
+		goto unregister_hdmi;
+
+	err = platform_driver_register(&tegra_dsi_driver);
+	if (err < 0)
+		goto unregister_tvo;
+
+	return 0;
+
+unregister_tvo:
+	platform_driver_unregister(&tegra_tvo_driver);
+unregister_hdmi:
+	platform_driver_unregister(&tegra_hdmi_driver);
+unregister_dc:
+	platform_driver_unregister(&tegra_dc_driver);
+	return err;
 }
+module_init(tegra_drm_init);
+
+static void __exit tegra_drm_exit(void)
+{
+	platform_driver_unregister(&tegra_dsi_driver);
+	platform_driver_unregister(&tegra_tvo_driver);
+	platform_driver_unregister(&tegra_hdmi_driver);
+	platform_driver_unregister(&tegra_dc_driver);
+}
+module_exit(tegra_drm_exit);
+
+MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
+MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
+MODULE_LICENSE("GPL");
 
 static struct drm_ioctl_desc tegra_drm_ioctls[] = {
 };
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index c7079ff..b2f9f10 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -31,59 +31,31 @@ static inline struct tegra_framebuffer *to_tegra_fb(struct drm_framebuffer *fb)
 	return container_of(fb, struct tegra_framebuffer, base);
 }
 
-struct host1x {
-	struct drm_device *drm;
-	struct device *dev;
-	void __iomem *regs;
-	struct clk *clk;
-	int syncpt;
-	int irq;
-
-	struct mutex drm_clients_lock;
-	struct list_head drm_clients;
-	struct list_head drm_active;
-
-	struct mutex clients_lock;
-	struct list_head clients;
+struct tegra_drm_client;
 
-	struct drm_fbdev_cma *fbdev;
-	struct tegra_framebuffer fb;
-
-#ifdef CONFIG_DRM_TEGRA_IOMMU
-	struct dma_iommu_mapping *dim;
-#endif
-};
-
-struct host1x_client;
-
-struct host1x_client_ops {
-	int (*drm_init)(struct host1x_client *client, struct drm_device *drm);
-	int (*drm_exit)(struct host1x_client *client);
+struct tegra_drm_client_ops {
+	int (*drm_init)(struct tegra_drm_client *client,
+			struct drm_device *drm);
+	int (*drm_exit)(struct tegra_drm_client *client);
 };
 
-struct host1x_client {
-	struct host1x *host1x;
+struct tegra_drm_client {
 	struct device *dev;
 
-	const struct host1x_client_ops *ops;
+	const struct tegra_drm_client_ops *ops;
 
 	struct list_head list;
-};
 
-extern int host1x_drm_init(struct host1x *host1x, struct drm_device *drm);
-extern int host1x_drm_exit(struct host1x *host1x);
+};
 
-extern int host1x_register_client(struct host1x *host1x,
-				  struct host1x_client *client);
-extern int host1x_unregister_client(struct host1x *host1x,
-				    struct host1x_client *client);
+extern int tegra_drm_register_client(struct tegra_drm_client *client);
+extern int tegra_drm_unregister_client(struct tegra_drm_client *client);
 
 struct tegra_output;
 
 struct tegra_dc {
-	struct host1x_client client;
+	struct tegra_drm_client client;
 
-	struct host1x *host1x;
 	struct device *dev;
 
 	struct drm_crtc base;
@@ -103,7 +75,8 @@ struct tegra_dc {
 	struct dentry *debugfs;
 };
 
-static inline struct tegra_dc *host1x_client_to_dc(struct host1x_client *client)
+static inline struct tegra_dc *tegra_drm_client_to_dc(
+				struct tegra_drm_client *client)
 {
 	return container_of(client, struct tegra_dc, client);
 }
@@ -246,8 +219,8 @@ extern struct vm_operations_struct tegra_gem_vm_ops;
 /* from fb.c */
 extern int tegra_drm_fb_init(struct drm_device *drm);
 extern void tegra_drm_fb_exit(struct drm_device *drm);
+extern void tegra_drm_fb_restore(struct drm_device *drm);
 
-extern struct platform_driver tegra_host1x_driver;
 extern struct platform_driver tegra_hdmi_driver;
 extern struct platform_driver tegra_tvo_driver;
 extern struct platform_driver tegra_dsi_driver;
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 156b3753..4f4c709 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -15,7 +15,7 @@
 #include "drm.h"
 
 struct tegra_dsi {
-	struct host1x_client client;
+	struct tegra_drm_client client;
 	struct tegra_output output;
 
 	void __iomem *regs;
@@ -23,7 +23,7 @@ struct tegra_dsi {
 };
 
 static inline struct tegra_dsi *
-host1x_client_to_dsi(struct host1x_client *client)
+tegra_drm_client_to_dsi(struct tegra_drm_client *client)
 {
 	return container_of(client, struct tegra_dsi, client);
 }
@@ -59,10 +59,10 @@ static const struct tegra_output_ops dsi_ops = {
 	.disable = tegra_output_dsi_disable,
 };
 
-static int tegra_dsi_drm_init(struct host1x_client *client,
+static int tegra_dsi_drm_init(struct tegra_drm_client *client,
 			      struct drm_device *drm)
 {
-	struct tegra_dsi *dsi = host1x_client_to_dsi(client);
+	struct tegra_dsi *dsi = tegra_drm_client_to_dsi(client);
 	int err;
 
 	dsi->output.type = TEGRA_OUTPUT_DSI;
@@ -78,9 +78,9 @@ static int tegra_dsi_drm_init(struct host1x_client *client,
 	return 0;
 }
 
-static int tegra_dsi_drm_exit(struct host1x_client *client)
+static int tegra_dsi_drm_exit(struct tegra_drm_client *client)
 {
-	struct tegra_dsi *dsi = host1x_client_to_dsi(client);
+	struct tegra_dsi *dsi = tegra_drm_client_to_dsi(client);
 	int err;
 
 	err = tegra_output_exit(&dsi->output);
@@ -92,14 +92,13 @@ static int tegra_dsi_drm_exit(struct host1x_client *client)
 	return 0;
 }
 
-static const struct host1x_client_ops dsi_client_ops = {
+static const struct tegra_drm_client_ops dsi_client_ops = {
 	.drm_init = tegra_dsi_drm_init,
 	.drm_exit = tegra_dsi_drm_exit,
 };
 
 static int tegra_dsi_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_dsi *dsi;
 	struct resource *regs;
 	int err;
@@ -126,9 +125,9 @@ static int tegra_dsi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&dsi->client.list);
 	dsi->client.dev = &pdev->dev;
 
-	err = host1x_register_client(host1x, &dsi->client);
+	err = tegra_drm_register_client(&dsi->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to register tegra drm client: %d\n",
 			err);
 		return err;
 	}
@@ -140,13 +139,12 @@ static int tegra_dsi_probe(struct platform_device *pdev)
 
 static int tegra_dsi_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_dsi *dsi = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_unregister_client(host1x, &dsi->client);
+	err = tegra_drm_unregister_client(&dsi->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to unregister tegra drm client: %d\n",
 			err);
 		return err;
 	}
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
index 97993c6..d6f44fa 100644
--- a/drivers/gpu/drm/tegra/fb.c
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -9,11 +9,11 @@
 
 #include "drm.h"
 
+static struct drm_fbdev_cma *tegra_fbdev;
+
 static void tegra_drm_fb_output_poll_changed(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
-
-	drm_fbdev_cma_hotplug_event(host1x->fbdev);
+	drm_fbdev_cma_hotplug_event(tegra_fbdev);
 }
 
 static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
@@ -23,9 +23,6 @@ static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
 
 int tegra_drm_fb_init(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
-	struct drm_fbdev_cma *fbdev;
-
 	drm->mode_config.min_width = 0;
 	drm->mode_config.min_height = 0;
 
@@ -34,23 +31,24 @@ int tegra_drm_fb_init(struct drm_device *drm)
 
 	drm->mode_config.funcs = &tegra_drm_mode_funcs;
 
-	fbdev = drm_fbdev_cma_init(drm, 32, drm->mode_config.num_crtc,
+	tegra_fbdev = drm_fbdev_cma_init(drm, 32, drm->mode_config.num_crtc,
 				   drm->mode_config.num_connector);
-	if (IS_ERR(fbdev))
-		return PTR_ERR(fbdev);
+	if (IS_ERR(tegra_fbdev))
+		return PTR_ERR(tegra_fbdev);
 
 #ifndef CONFIG_FRAMEBUFFER_CONSOLE
-	drm_fbdev_cma_restore_mode(fbdev);
+	drm_fbdev_cma_restore_mode(tegra_fbdev);
 #endif
 
-	host1x->fbdev = fbdev;
-
 	return 0;
 }
 
 void tegra_drm_fb_exit(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	drm_fbdev_cma_fini(tegra_fbdev);
+}
 
-	drm_fbdev_cma_fini(host1x->fbdev);
+void tegra_drm_fb_restore(struct drm_device *drm)
+{
+	drm_fbdev_cma_restore_mode(tegra_fbdev);
 }
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 58f55dc..b2b8e58 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -22,7 +22,7 @@
 #include "dc.h"
 
 struct tegra_hdmi {
-	struct host1x_client client;
+	struct tegra_drm_client client;
 	struct tegra_output output;
 	struct device *dev;
 
@@ -46,7 +46,7 @@ struct tegra_hdmi {
 };
 
 static inline struct tegra_hdmi *
-host1x_client_to_hdmi(struct host1x_client *client)
+tegra_drm_client_to_hdmi(struct tegra_drm_client *client)
 {
 	return container_of(client, struct tegra_hdmi, client);
 }
@@ -1152,10 +1152,10 @@ static int tegra_hdmi_debugfs_exit(struct tegra_hdmi *hdmi)
 	return 0;
 }
 
-static int tegra_hdmi_drm_init(struct host1x_client *client,
+static int tegra_hdmi_drm_init(struct tegra_drm_client *client,
 			       struct drm_device *drm)
 {
-	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
+	struct tegra_hdmi *hdmi = tegra_drm_client_to_hdmi(client);
 	int err;
 
 	hdmi->output.type = TEGRA_OUTPUT_HDMI;
@@ -1177,9 +1177,9 @@ static int tegra_hdmi_drm_init(struct host1x_client *client,
 	return 0;
 }
 
-static int tegra_hdmi_drm_exit(struct host1x_client *client)
+static int tegra_hdmi_drm_exit(struct tegra_drm_client *client)
 {
-	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
+	struct tegra_hdmi *hdmi = tegra_drm_client_to_hdmi(client);
 	int err;
 
 	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
@@ -1204,14 +1204,13 @@ static int tegra_hdmi_drm_exit(struct host1x_client *client)
 	return 0;
 }
 
-static const struct host1x_client_ops hdmi_client_ops = {
+static const struct tegra_drm_client_ops hdmi_client_ops = {
 	.drm_init = tegra_hdmi_drm_init,
 	.drm_exit = tegra_hdmi_drm_exit,
 };
 
 static int tegra_hdmi_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_hdmi *hdmi;
 	struct resource *regs;
 	int err;
@@ -1286,9 +1285,9 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&hdmi->client.list);
 	hdmi->client.dev = &pdev->dev;
 
-	err = host1x_register_client(host1x, &hdmi->client);
+	err = tegra_drm_register_client(&hdmi->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to register tegra drm client: %d\n",
 			err);
 		return err;
 	}
@@ -1300,13 +1299,12 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 
 static int tegra_hdmi_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_unregister_client(host1x, &hdmi->client);
+	err = tegra_drm_unregister_client(&hdmi->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to unregister tegra drm client: %d\n",
 			err);
 		return err;
 	}
diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
deleted file mode 100644
index f9d3a84..0000000
--- a/drivers/gpu/drm/tegra/host1x.c
+++ /dev/null
@@ -1,343 +0,0 @@
-/*
- * Copyright (C) 2012 Avionic Design GmbH
- * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/platform_device.h>
-
-#include "drm.h"
-
-struct host1x_drm_client {
-	struct host1x_client *client;
-	struct device_node *np;
-	struct list_head list;
-};
-
-static int host1x_add_drm_client(struct host1x *host1x, struct device_node *np)
-{
-	struct host1x_drm_client *client;
-
-	client = kzalloc(sizeof(*client), GFP_KERNEL);
-	if (!client)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&client->list);
-	client->np = of_node_get(np);
-
-	list_add_tail(&client->list, &host1x->drm_clients);
-
-	return 0;
-}
-
-static int host1x_activate_drm_client(struct host1x *host1x,
-				      struct host1x_drm_client *drm,
-				      struct host1x_client *client)
-{
-	mutex_lock(&host1x->drm_clients_lock);
-	list_del_init(&drm->list);
-	list_add_tail(&drm->list, &host1x->drm_active);
-	drm->client = client;
-	mutex_unlock(&host1x->drm_clients_lock);
-
-	return 0;
-}
-
-static int host1x_remove_drm_client(struct host1x *host1x,
-				    struct host1x_drm_client *client)
-{
-	mutex_lock(&host1x->drm_clients_lock);
-	list_del_init(&client->list);
-	mutex_unlock(&host1x->drm_clients_lock);
-
-	of_node_put(client->np);
-	kfree(client);
-
-	return 0;
-}
-
-static int host1x_parse_dt(struct host1x *host1x)
-{
-	static const char * const compat[] = {
-		"nvidia,tegra20-dc",
-		"nvidia,tegra20-hdmi",
-		"nvidia,tegra20-tvo",
-		"nvidia,tegra20-dsi",
-		"nvidia,tegra30-dc",
-		"nvidia,tegra30-hdmi",
-		"nvidia,tegra30-tvo",
-		"nvidia,tegra30-dsi"
-	};
-	unsigned int i;
-	int err;
-
-	for (i = 0; i < ARRAY_SIZE(compat); i++) {
-		struct device_node *np;
-
-		for_each_child_of_node(host1x->dev->of_node, np) {
-			if (of_device_is_compatible(np, compat[i]) &&
-			    of_device_is_available(np)) {
-				err = host1x_add_drm_client(host1x, np);
-				if (err < 0)
-					return err;
-			}
-		}
-	}
-
-	return 0;
-}
-
-static int tegra_host1x_probe(struct platform_device *pdev)
-{
-	struct host1x *host1x;
-	struct resource *regs;
-	int err;
-
-	host1x = devm_kzalloc(&pdev->dev, sizeof(*host1x), GFP_KERNEL);
-	if (!host1x)
-		return -ENOMEM;
-
-	mutex_init(&host1x->drm_clients_lock);
-	INIT_LIST_HEAD(&host1x->drm_clients);
-	INIT_LIST_HEAD(&host1x->drm_active);
-	mutex_init(&host1x->clients_lock);
-	INIT_LIST_HEAD(&host1x->clients);
-	host1x->dev = &pdev->dev;
-
-	err = host1x_parse_dt(host1x);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to parse DT: %d\n", err);
-		return err;
-	}
-
-	host1x->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(host1x->clk))
-		return PTR_ERR(host1x->clk);
-
-	err = clk_prepare_enable(host1x->clk);
-	if (err < 0)
-		return err;
-
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		err = -ENXIO;
-		goto err;
-	}
-
-	err = platform_get_irq(pdev, 0);
-	if (err < 0)
-		goto err;
-
-	host1x->syncpt = err;
-
-	err = platform_get_irq(pdev, 1);
-	if (err < 0)
-		goto err;
-
-	host1x->irq = err;
-
-	host1x->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!host1x->regs) {
-		err = -EADDRNOTAVAIL;
-		goto err;
-	}
-
-	platform_set_drvdata(pdev, host1x);
-
-	return 0;
-
-err:
-	clk_disable_unprepare(host1x->clk);
-	return err;
-}
-
-static int tegra_host1x_remove(struct platform_device *pdev)
-{
-	struct host1x *host1x = platform_get_drvdata(pdev);
-
-	clk_disable_unprepare(host1x->clk);
-
-	return 0;
-}
-
-int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
-{
-	struct host1x_client *client;
-
-	mutex_lock(&host1x->clients_lock);
-
-	list_for_each_entry(client, &host1x->clients, list) {
-		if (client->ops && client->ops->drm_init) {
-			int err = client->ops->drm_init(client, drm);
-			if (err < 0) {
-				dev_err(host1x->dev,
-					"DRM setup failed for %s: %d\n",
-					dev_name(client->dev), err);
-				return err;
-			}
-		}
-	}
-
-	mutex_unlock(&host1x->clients_lock);
-
-	return 0;
-}
-
-int host1x_drm_exit(struct host1x *host1x)
-{
-	struct platform_device *pdev = to_platform_device(host1x->dev);
-	struct host1x_client *client;
-
-	if (!host1x->drm)
-		return 0;
-
-	mutex_lock(&host1x->clients_lock);
-
-	list_for_each_entry_reverse(client, &host1x->clients, list) {
-		if (client->ops && client->ops->drm_exit) {
-			int err = client->ops->drm_exit(client);
-			if (err < 0) {
-				dev_err(host1x->dev,
-					"DRM cleanup failed for %s: %d\n",
-					dev_name(client->dev), err);
-				return err;
-			}
-		}
-	}
-
-	mutex_unlock(&host1x->clients_lock);
-
-	drm_platform_exit(&tegra_drm_driver, pdev);
-	host1x->drm = NULL;
-
-	return 0;
-}
-
-int host1x_register_client(struct host1x *host1x, struct host1x_client *client)
-{
-	struct host1x_drm_client *drm, *tmp;
-	int err;
-
-	mutex_lock(&host1x->clients_lock);
-	list_add_tail(&client->list, &host1x->clients);
-	mutex_unlock(&host1x->clients_lock);
-
-	list_for_each_entry_safe(drm, tmp, &host1x->drm_clients, list)
-		if (drm->np == client->dev->of_node)
-			host1x_activate_drm_client(host1x, drm, client);
-
-	if (list_empty(&host1x->drm_clients)) {
-		struct platform_device *pdev = to_platform_device(host1x->dev);
-
-		err = drm_platform_init(&tegra_drm_driver, pdev);
-		if (err < 0) {
-			dev_err(host1x->dev, "drm_platform_init(): %d\n", err);
-			return err;
-		}
-	}
-
-	return 0;
-}
-
-int host1x_unregister_client(struct host1x *host1x,
-			     struct host1x_client *client)
-{
-	struct host1x_drm_client *drm, *tmp;
-	int err;
-
-	list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
-		if (drm->client == client) {
-			err = host1x_drm_exit(host1x);
-			if (err < 0) {
-				dev_err(host1x->dev, "host1x_drm_exit(): %d\n",
-					err);
-				return err;
-			}
-
-			host1x_remove_drm_client(host1x, drm);
-			break;
-		}
-	}
-
-	mutex_lock(&host1x->clients_lock);
-	list_del_init(&client->list);
-	mutex_unlock(&host1x->clients_lock);
-
-	return 0;
-}
-
-static struct of_device_id tegra_host1x_of_match[] = {
-	{ .compatible = "nvidia,tegra20-host1x", },
-	{ .compatible = "nvidia,tegra30-host1x", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, tegra_host1x_of_match);
-
-struct platform_driver tegra_host1x_driver = {
-	.driver = {
-		.name = "tegra-host1x",
-		.owner = THIS_MODULE,
-		.of_match_table = tegra_host1x_of_match,
-	},
-	.probe = tegra_host1x_probe,
-	.remove = tegra_host1x_remove,
-};
-
-static int __init tegra_host1x_init(void)
-{
-	int err;
-
-	err = platform_driver_register(&tegra_host1x_driver);
-	if (err < 0)
-		return err;
-
-	err = platform_driver_register(&tegra_dc_driver);
-	if (err < 0)
-		goto unregister_host1x;
-
-	err = platform_driver_register(&tegra_hdmi_driver);
-	if (err < 0)
-		goto unregister_dc;
-
-	err = platform_driver_register(&tegra_tvo_driver);
-	if (err < 0)
-		goto unregister_hdmi;
-
-	err = platform_driver_register(&tegra_dsi_driver);
-	if (err < 0)
-		goto unregister_tvo;
-
-	return 0;
-
-unregister_tvo:
-	platform_driver_unregister(&tegra_tvo_driver);
-unregister_hdmi:
-	platform_driver_unregister(&tegra_hdmi_driver);
-unregister_dc:
-	platform_driver_unregister(&tegra_dc_driver);
-unregister_host1x:
-	platform_driver_unregister(&tegra_host1x_driver);
-	return err;
-}
-module_init(tegra_host1x_init);
-
-static void __exit tegra_host1x_exit(void)
-{
-	platform_driver_unregister(&tegra_dsi_driver);
-	platform_driver_unregister(&tegra_tvo_driver);
-	platform_driver_unregister(&tegra_hdmi_driver);
-	platform_driver_unregister(&tegra_dc_driver);
-	platform_driver_unregister(&tegra_host1x_driver);
-}
-module_exit(tegra_host1x_exit);
-
-MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
-MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/tegra/tvo.c b/drivers/gpu/drm/tegra/tvo.c
index a67bd28..01ac356 100644
--- a/drivers/gpu/drm/tegra/tvo.c
+++ b/drivers/gpu/drm/tegra/tvo.c
@@ -15,7 +15,7 @@
 #include "drm.h"
 
 struct tegra_tvo {
-	struct host1x_client client;
+	struct tegra_drm_client client;
 	struct tegra_output output;
 
 	void __iomem *regs;
@@ -24,7 +24,7 @@ struct tegra_tvo {
 };
 
 static inline struct tegra_tvo *
-host1x_client_to_tvo(struct host1x_client *client)
+tegra_drm_client_to_tvo(struct tegra_drm_client *client)
 {
 	return container_of(client, struct tegra_tvo, client);
 }
@@ -60,10 +60,10 @@ static const struct tegra_output_ops tvo_ops = {
 	.disable = tegra_output_tvo_disable,
 };
 
-static int tegra_tvo_drm_init(struct host1x_client *client,
+static int tegra_tvo_drm_init(struct tegra_drm_client *client,
 			      struct drm_device *drm)
 {
-	struct tegra_tvo *tvo = host1x_client_to_tvo(client);
+	struct tegra_tvo *tvo = tegra_drm_client_to_tvo(client);
 	int err;
 
 	tvo->output.type = TEGRA_OUTPUT_TVO;
@@ -79,9 +79,9 @@ static int tegra_tvo_drm_init(struct host1x_client *client,
 	return 0;
 }
 
-static int tegra_tvo_drm_exit(struct host1x_client *client)
+static int tegra_tvo_drm_exit(struct tegra_drm_client *client)
 {
-	struct tegra_tvo *tvo = host1x_client_to_tvo(client);
+	struct tegra_tvo *tvo = tegra_drm_client_to_tvo(client);
 	int err;
 
 	err = tegra_output_exit(&tvo->output);
@@ -93,14 +93,13 @@ static int tegra_tvo_drm_exit(struct host1x_client *client)
 	return err;
 }
 
-static const struct host1x_client_ops tvo_client_ops = {
+static const struct tegra_drm_client_ops tvo_client_ops = {
 	.drm_init = tegra_tvo_drm_init,
 	.drm_exit = tegra_tvo_drm_exit,
 };
 
 static int tegra_tvo_probe(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_tvo *tvo;
 	struct resource *regs;
 	int err;
@@ -120,22 +119,25 @@ static int tegra_tvo_probe(struct platform_device *pdev)
 		return -ENXIO;
 
 	err = platform_get_irq(pdev, 0);
-	if (err < 0)
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to get tvo irq\n");
 		return err;
-
+	}
 	tvo->irq = err;
 
 	tvo->regs = devm_request_and_ioremap(&pdev->dev, regs);
-	if (!tvo->regs)
+	if (!tvo->regs) {
+		dev_err(&pdev->dev, "failed to request tvo regs\n");
 		return -EADDRNOTAVAIL;
+	}
 
 	tvo->client.ops = &tvo_client_ops;
 	INIT_LIST_HEAD(&tvo->client.list);
 	tvo->client.dev = &pdev->dev;
 
-	err = host1x_register_client(host1x, &tvo->client);
+	err = tegra_drm_register_client(&tvo->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to register tegra drm client: %d\n",
 			err);
 		return err;
 	}
@@ -147,13 +149,12 @@ static int tegra_tvo_probe(struct platform_device *pdev)
 
 static int tegra_tvo_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_tvo *tvo = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_unregister_client(host1x, &tvo->client);
+	err = tegra_drm_unregister_client(&tvo->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to unregister tegra drm client: %d\n",
 			err);
 		return err;
 	}
-- 
1.7.9.5

