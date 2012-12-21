Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2LULff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:35:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14482 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2LULey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:34:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 21 Dec 2012 03:34:46 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>, <dev@lynxeye.de>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv4 5/8] drm: tegra: Remove redundant host1x
Date: Fri, 21 Dec 2012 13:39:21 +0200
Message-ID: <1356089964-5265-6-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arto Merilainen <amerilainen@nvidia.com>

This patch removes the redundant host1x driver from tegradrm and
makes necessary bindings to the separate host driver.

The infrastructure for drm client lists is merged to drm.c.

The patch simplifies driver initialization; The original driver had
two lists for registered devices (clients and drm_active). The
clients list included references to all registered devices whereas
the drm_active list included only the devices that the tegradrm
driver itself supported. host1x is separated into a driver of its own
and hence there should be no need to support registration of external
drivers.  Therefore, only the drm_active list is reserved. Removal of
the list also simplifies the driver unregistration.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/drm/tegra/Kconfig  |    2 +-
 drivers/gpu/drm/tegra/Makefile |    2 +-
 drivers/gpu/drm/tegra/dc.c     |   23 +--
 drivers/gpu/drm/tegra/drm.c    |  231 ++++++++++++++++++++++++++--
 drivers/gpu/drm/tegra/drm.h    |   43 +++---
 drivers/gpu/drm/tegra/fb.c     |   17 ++-
 drivers/gpu/drm/tegra/hdmi.c   |   27 ++--
 drivers/gpu/drm/tegra/host1x.c |  325 ----------------------------------------
 include/drm/tegra_drm.h        |   20 +++
 9 files changed, 298 insertions(+), 392 deletions(-)
 delete mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 include/drm/tegra_drm.h

diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
index be1daf7..4a0290e 100644
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
diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
index 80f73d1..f4c05bb 100644
--- a/drivers/gpu/drm/tegra/Makefile
+++ b/drivers/gpu/drm/tegra/Makefile
@@ -1,7 +1,7 @@
 ccflags-y := -Iinclude/drm
 ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
-tegra-drm-y := drm.o fb.o dc.o host1x.o
+tegra-drm-y := drm.o fb.o dc.o
 tegra-drm-y += output.o rgb.o hdmi.o
 
 obj-$(CONFIG_DRM_TEGRA) += tegra-drm.o
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 0744103..24bcd06 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -673,10 +673,10 @@ static int tegra_dc_debugfs_exit(struct tegra_dc *dc)
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
@@ -708,9 +708,9 @@ static int tegra_dc_drm_init(struct host1x_client *client,
 	return 0;
 }
 
-static int tegra_dc_drm_exit(struct host1x_client *client)
+static int tegra_dc_drm_exit(struct tegra_drm_client *client)
 {
-	struct tegra_dc *dc = host1x_client_to_dc(client);
+	struct tegra_dc *dc = tegra_drm_client_to_dc(client);
 	int err;
 
 	devm_free_irq(dc->dev, dc->irq, dc);
@@ -730,17 +730,17 @@ static int tegra_dc_drm_exit(struct host1x_client *client)
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
+	struct tegradrm *tegradrm = platform_get_drvdata(pdev);
 
 	dc = devm_kzalloc(&pdev->dev, sizeof(*dc), GFP_KERNEL);
 	if (!dc)
@@ -780,6 +780,7 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&dc->client.list);
 	dc->client.ops = &dc_client_ops;
 	dc->client.dev = &pdev->dev;
+	dc->client.tegradrm = tegradrm;
 
 	err = tegra_dc_rgb_probe(dc);
 	if (err < 0 && err != -ENODEV) {
@@ -787,9 +788,9 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	err = host1x_register_client(host1x, &dc->client);
+	err = tegra_drm_register_client(tegradrm, &dc->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to register tegra drm client: %d\n",
 			err);
 		return err;
 	}
@@ -801,13 +802,13 @@ static int tegra_dc_probe(struct platform_device *pdev)
 
 static int tegra_dc_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_unregister_client(host1x, &dc->client);
+	err = tegra_drm_unregister_client(dc->client.tegradrm,
+			&dc->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to unregister tegra_drm client: %d\n",
 			err);
 		return err;
 	}
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 3a503c9..3de6c8e 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
+#include <linux/host1x.h>
 
 #include <mach/clk.h>
 #include <linux/dma-mapping.h>
@@ -24,21 +25,142 @@
 #define DRIVER_MINOR 0
 #define DRIVER_PATCHLEVEL 0
 
+struct tegra_drm_client_entry {
+	struct tegra_drm_client *client;
+	struct device_node *np;
+	struct list_head list;
+};
+
+static int tegra_drm_add_client(struct device *dev, void *data)
+{
+	static const char * const compat[] = {
+		"nvidia,tegra20-dc",
+		"nvidia,tegra20-hdmi",
+		"nvidia,tegra30-dc",
+		"nvidia,tegra30-hdmi",
+	};
+	struct tegradrm *tegradrm = data;
+	struct tegra_drm_client_entry *client;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(compat); i++) {
+		if (of_device_is_compatible(dev->of_node, compat[i]) &&
+		    of_device_is_available(dev->of_node)) {
+			client = kzalloc(sizeof(*client), GFP_KERNEL);
+			if (!client)
+				return -ENOMEM;
+
+			INIT_LIST_HEAD(&client->list);
+			client->np = of_node_get(dev->of_node);
+
+			list_add_tail(&client->list, &tegradrm->drm_clients);
+			dev_set_drvdata(dev, tegradrm);
+		}
+	}
+
+	return 0;
+}
+
+static int tegra_drm_parse_dt(struct tegradrm *tegradrm)
+{
+	int err;
+	struct device *dev;
+
+	/* host1x is parent of all devices */
+	dev = bus_find_device_by_name(&platform_bus_type, NULL, "host1x");
+	if (!dev)
+		return -ENODEV;
+
+	/* find devices that are available and add them into the 'required'
+	 * list */
+	err = device_for_each_child(dev, tegradrm, tegra_drm_add_client);
+
+	return err;
+}
+
+int tegra_drm_register_client(struct tegradrm *tegradrm,
+		struct tegra_drm_client *client)
+{
+	struct tegra_drm_client_entry *drm, *tmp;
+	int err;
+
+	mutex_lock(&tegradrm->clients_lock);
+	list_add_tail(&client->list, &tegradrm->clients);
+	mutex_unlock(&tegradrm->clients_lock);
+
+	/* remove this device from 'required' list */
+	list_for_each_entry_safe(drm, tmp, &tegradrm->drm_clients, list)
+		if (drm->np == client->dev->of_node)
+			list_del(&drm->list);
+
+	/* if all required devices are found, register drm device */
+	if (list_empty(&tegradrm->drm_clients)) {
+		struct platform_device *pdev =
+			to_platform_device(tegradrm->dev);
+		err = drm_platform_init(&tegra_drm_driver, pdev);
+		if (err < 0) {
+			dev_err(client->dev, "drm_platform_init(): %d\n", err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+int tegra_drm_unregister_client(struct tegradrm *tegradrm,
+		struct tegra_drm_client *client)
+{
+	struct tegra_drm_client *tmp;
+
+	list_for_each_entry_safe(client, tmp, &tegradrm->clients, list) {
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
+		if (client->list.next == &tegradrm->clients) {
+			struct platform_device *pdev =
+				to_platform_device(tegradrm->dev);
+			drm_platform_exit(&tegra_drm_driver, pdev);
+		}
+
+		list_del_init(&client->list);
+	}
+
+	return 0;
+}
+
 static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 {
-	struct device *dev = drm->dev;
-	struct host1x *host1x;
+	struct tegra_drm_client *client;
 	int err;
+	struct tegradrm *tegradrm = dev_get_drvdata(drm->dev);
 
-	host1x = dev_get_drvdata(dev);
-	drm->dev_private = host1x;
-	host1x->drm = drm;
+	drm->dev_private = tegradrm;
 
 	drm_mode_config_init(drm);
 
-	err = host1x_drm_init(host1x, drm);
-	if (err < 0)
-		return err;
+	mutex_lock(&tegradrm->clients_lock);
+
+	list_for_each_entry(client, &tegradrm->clients, list) {
+		if (client->ops && client->ops->drm_init) {
+			err = client->ops->drm_init(client, drm);
+			if (err < 0) {
+				dev_dbg(drm->dev, "drm_init() failed for %s: %d\n",
+					dev_name(client->dev), err);
+				mutex_unlock(&tegradrm->clients_lock);
+				return err;
+			}
+		}
+	}
+
+	mutex_unlock(&tegradrm->clients_lock);
 
 	err = tegra_drm_fb_init(drm);
 	if (err < 0)
@@ -64,13 +186,97 @@ static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
 	return 0;
 }
 
+static void tegra_drm_close(struct drm_device *drm, struct drm_file *filp)
+{
+
+}
+
 static void tegra_drm_lastclose(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	tegra_drm_fb_restore(drm);
+}
+
+static int tegra_drm_probe(struct platform_device *pdev)
+{
+	int err;
+	struct tegradrm *tegradrm;
+
+	tegradrm = devm_kzalloc(&pdev->dev, sizeof(*tegradrm), GFP_KERNEL);
+	if (!tegradrm)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, tegradrm);
+	tegradrm->dev = &pdev->dev;
 
-	drm_fbdev_cma_restore_mode(host1x->fbdev);
+	mutex_init(&tegradrm->drm_clients_lock);
+	INIT_LIST_HEAD(&tegradrm->drm_clients);
+	mutex_init(&tegradrm->clients_lock);
+	INIT_LIST_HEAD(&tegradrm->clients);
+
+	err = tegra_drm_parse_dt(tegradrm);
+	if (err < 0) {
+		pr_err("failed to parse DT: %d\n", err);
+		return err;
+	}
+
+	return 0;
 }
 
+static int tegra_drm_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver tegra_drm_platform_driver = {
+	.driver = {
+		.name = "tegradrm",
+		.owner = THIS_MODULE,
+	},
+	.probe = tegra_drm_probe,
+	.remove = tegra_drm_remove,
+};
+
+static int __init tegra_drm_init(void)
+{
+	int err;
+	struct platform_device *drm_device;
+
+	drm_device = platform_device_register_simple("tegradrm", -1, NULL, 0);
+	if (!drm_device)
+		return -ENOMEM;
+	dma_set_coherent_mask(&drm_device->dev, DMA_BIT_MASK(32));
+
+	err = platform_driver_register(&tegra_drm_platform_driver);
+	if (err < 0)
+		goto unregister_tegra_dev;
+
+	err = platform_driver_register(&tegra_dc_driver);
+	if (err < 0)
+		goto unregister_tegra_drv;
+
+	err = platform_driver_register(&tegra_hdmi_driver);
+	if (err < 0)
+		goto unregister_dc;
+	return 0;
+
+unregister_dc:
+	platform_driver_unregister(&tegra_dc_driver);
+unregister_tegra_drv:
+	platform_driver_unregister(&tegra_drm_platform_driver);
+unregister_tegra_dev:
+	platform_device_unregister(drm_device);
+	return err;
+}
+module_init(tegra_drm_init);
+
+static void __exit tegra_drm_exit(void)
+{
+	platform_driver_unregister(&tegra_hdmi_driver);
+	platform_driver_unregister(&tegra_dc_driver);
+	platform_driver_unregister(&tegra_drm_platform_driver);
+}
+module_exit(tegra_drm_exit);
+
 static struct drm_ioctl_desc tegra_drm_ioctls[] = {
 };
 
@@ -94,6 +300,7 @@ struct drm_driver tegra_drm_driver = {
 	.load = tegra_drm_load,
 	.unload = tegra_drm_unload,
 	.open = tegra_drm_open,
+	.preclose = tegra_drm_close,
 	.lastclose = tegra_drm_lastclose,
 
 	.gem_free_object = drm_gem_cma_free_object,
@@ -113,3 +320,7 @@ struct drm_driver tegra_drm_driver = {
 	.minor = DRIVER_MINOR,
 	.patchlevel = DRIVER_PATCHLEVEL,
 };
+
+MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
+MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 3a843a7..34cc3a1 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -17,6 +17,7 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fixed.h>
+#include <drm/tegra_drm.h>
 
 struct tegra_framebuffer {
 	struct drm_framebuffer base;
@@ -28,17 +29,11 @@ static inline struct tegra_framebuffer *to_tegra_fb(struct drm_framebuffer *fb)
 	return container_of(fb, struct tegra_framebuffer, base);
 }
 
-struct host1x {
-	struct drm_device *drm;
+struct tegradrm {
 	struct device *dev;
-	void __iomem *regs;
-	struct clk *clk;
-	int syncpt;
-	int irq;
 
 	struct mutex drm_clients_lock;
 	struct list_head drm_clients;
-	struct list_head drm_active;
 
 	struct mutex clients_lock;
 	struct list_head clients;
@@ -47,36 +42,33 @@ struct host1x {
 	struct tegra_framebuffer fb;
 };
 
-struct host1x_client;
+struct tegra_drm_client;
 
-struct host1x_client_ops {
-	int (*drm_init)(struct host1x_client *client, struct drm_device *drm);
-	int (*drm_exit)(struct host1x_client *client);
+struct tegra_drm_client_ops {
+	int (*drm_init)(struct tegra_drm_client *, struct drm_device *);
+	int (*drm_exit)(struct tegra_drm_client *);
 };
 
-struct host1x_client {
-	struct host1x *host1x;
+struct tegra_drm_client {
+	struct tegradrm *tegradrm;
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
+extern int tegra_drm_register_client(struct tegradrm *tegradrm,
+		struct tegra_drm_client *client);
+extern int tegra_drm_unregister_client(struct tegradrm *tegradrm,
+		struct tegra_drm_client *client);
 
 struct tegra_output;
 
 struct tegra_dc {
-	struct host1x_client client;
+	struct tegra_drm_client client;
 
-	struct host1x *host1x;
 	struct device *dev;
 
 	struct drm_crtc base;
@@ -96,7 +88,8 @@ struct tegra_dc {
 	struct dentry *debugfs;
 };
 
-static inline struct tegra_dc *host1x_client_to_dc(struct host1x_client *client)
+static inline struct tegra_dc *tegra_drm_client_to_dc(
+				struct tegra_drm_client *client)
 {
 	return container_of(client, struct tegra_dc, client);
 }
@@ -225,8 +218,8 @@ extern struct vm_operations_struct tegra_gem_vm_ops;
 /* from fb.c */
 extern int tegra_drm_fb_init(struct drm_device *drm);
 extern void tegra_drm_fb_exit(struct drm_device *drm);
+extern void tegra_drm_fb_restore(struct drm_device *drm);
 
-extern struct platform_driver tegra_host1x_driver;
 extern struct platform_driver tegra_hdmi_driver;
 extern struct platform_driver tegra_dc_driver;
 extern struct drm_driver tegra_drm_driver;
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
index 97993c6..7c686d8 100644
--- a/drivers/gpu/drm/tegra/fb.c
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -11,9 +11,9 @@
 
 static void tegra_drm_fb_output_poll_changed(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	struct tegradrm *tegradrm = drm->dev_private;
 
-	drm_fbdev_cma_hotplug_event(host1x->fbdev);
+	drm_fbdev_cma_hotplug_event(tegradrm->fbdev);
 }
 
 static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
@@ -23,7 +23,7 @@ static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
 
 int tegra_drm_fb_init(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	struct tegradrm *tegradrm = drm->dev_private;
 	struct drm_fbdev_cma *fbdev;
 
 	drm->mode_config.min_width = 0;
@@ -43,14 +43,19 @@ int tegra_drm_fb_init(struct drm_device *drm)
 	drm_fbdev_cma_restore_mode(fbdev);
 #endif
 
-	host1x->fbdev = fbdev;
+	tegradrm->fbdev = fbdev;
 
 	return 0;
 }
 
 void tegra_drm_fb_exit(struct drm_device *drm)
 {
-	struct host1x *host1x = drm->dev_private;
+	struct tegradrm *tegradrm = drm->dev_private;
+	drm_fbdev_cma_fini(tegradrm->fbdev);
+}
 
-	drm_fbdev_cma_fini(host1x->fbdev);
+void tegra_drm_fb_restore(struct drm_device *drm)
+{
+	struct tegradrm *tegradrm = drm->dev_private;
+	drm_fbdev_cma_restore_mode(tegradrm->fbdev);
 }
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index ab40164..fce3e66 100644
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
@@ -1204,17 +1204,17 @@ static int tegra_hdmi_drm_exit(struct host1x_client *client)
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
+	struct tegradrm *tegradrm = platform_get_drvdata(pdev);
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
@@ -1285,10 +1285,11 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 	hdmi->client.ops = &hdmi_client_ops;
 	INIT_LIST_HEAD(&hdmi->client.list);
 	hdmi->client.dev = &pdev->dev;
+	hdmi->client.tegradrm = tegradrm;
 
-	err = host1x_register_client(host1x, &hdmi->client);
+	err = tegra_drm_register_client(tegradrm, &hdmi->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to register tegra drm client: %d\n",
 			err);
 		return err;
 	}
@@ -1300,13 +1301,13 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 
 static int tegra_hdmi_remove(struct platform_device *pdev)
 {
-	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
 	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
 	int err;
 
-	err = host1x_unregister_client(host1x, &hdmi->client);
+	err = tegra_drm_unregister_client(hdmi->client.tegradrm,
+			&hdmi->client);
 	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+		dev_err(&pdev->dev, "failed to unregister tegra drm client: %d\n",
 			err);
 		return err;
 	}
diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
deleted file mode 100644
index bdb97a5..0000000
--- a/drivers/gpu/drm/tegra/host1x.c
+++ /dev/null
@@ -1,325 +0,0 @@
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
-		"nvidia,tegra30-dc",
-		"nvidia,tegra30-hdmi",
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
-	{ .compatible = "nvidia,tegra30-host1x", },
-	{ .compatible = "nvidia,tegra20-host1x", },
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
-	return 0;
-
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
-	platform_driver_unregister(&tegra_hdmi_driver);
-	platform_driver_unregister(&tegra_dc_driver);
-	platform_driver_unregister(&tegra_host1x_driver);
-}
-module_exit(tegra_host1x_exit);
-
-MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
-MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
-MODULE_LICENSE("GPL");
diff --git a/include/drm/tegra_drm.h b/include/drm/tegra_drm.h
new file mode 100644
index 0000000..8632f49
--- /dev/null
+++ b/include/drm/tegra_drm.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+#ifndef _TEGRA_DRM_H_
+#define _TEGRA_DRM_H_
+
+#endif
-- 
1.7.9.5

