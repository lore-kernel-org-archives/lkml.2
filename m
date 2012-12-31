Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2LaGnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 01:43:25 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13552 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2LaGnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 01:43:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 30 Dec 2012 22:40:47 -0800
Message-ID: <50E133F8.40106@nvidia.com>
Date: Mon, 31 Dec 2012 08:43:04 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [PATCHv4 5/8] drm: tegra: Remove redundant host1x
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <1356089964-5265-6-git-send-email-tbergstrom@nvidia.com> <20121221143614.GA16167@avionic-0098.adnet.avionic-design.de> <50D55820.7030302@nvidia.com> <50D938AC.50001@wwwdotorg.org> <20121228212125.GA4615@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121228212125.GA4615@avionic-0098.adnet.avionic-design.de>
Content-Type: multipart/mixed;
	boundary="------------080100050902000708080107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------080100050902000708080107
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On 28.12.2012 23:21, Thierry Reding wrote:
> Instead of going over this back and forth, I've decided to rewrite this
> patch from scratch the way I think it should be done. Maybe that'll make
> things clearer. I haven't tested it on real hardware yet because I don't
> have access over the holidays, but I'll post the patch once I've
> verified that it actually works. The code is based on patches 1-4 of
> this series and is meant to replace patch 5.

I'm still not happy that host1x needs to know about drm. That's just a
wrong dependency, and wrong dependencies always end up biting back. We
need to figure out solution that satisfies both mine and your
requirements and reduce complexity.

DC/HDMI/GR2D probes are using the global data only for managing the
lists "drm_clients" and "clients". "clients" list is only required after
tegra_drm_load(). "drm_clients" is required to establish driver load order.

With dummy device, we can determine the registration (and probe) order.
tegra-drm can register the drivers for DC/HDMI/GR2D devices first, and
as last the device and driver for tegra-drm.

tegra-drm probe will allocate the global data, enumerate all drivers and
add them to the clients list. If one driver is not initialized, it'll
return with -EPROBE_DEFER and will be called again later. When all this
is successful, it'll call drm_platform_init().

The advantages:
 * No management of drm_clients list
 * No mucking with drvdata
 * host1x doesn't need to know about drm
 * The global data is allocated and deallocated by tegra-drm probe and
remove, and accessed only via drm_device->dev_private
 * Much less code

Something like the attached patch - not tested, as I don't have access
to hw now, but it shows the idea. It's based on patches 1-5 in the
series, and could replace patch 5.

Terje

--------------080100050902000708080107
Content-Type: text/x-patch;
	name="0001-drm-tegra-Postpone-usage-of-global-data.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-drm-tegra-Postpone-usage-of-global-data.patch"

>From a97d475d65e68ce37c345924171dc57c5e7729ee Mon Sep 17 00:00:00 2001
From: Terje Bergstrom <tbergstrom@nvidia.com>
Date: Sat, 29 Dec 2012 11:43:54 +0200
Subject: [PATCH] drm: tegra: Postpone usage of global data

Change-Id: Ibfd1d4eeb267ac185de4508a1547fb009b80e93a
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c   |   18 -----
 drivers/gpu/drm/tegra/drm.c  |  151 +++++++++++++-----------------------------
 drivers/gpu/drm/tegra/drm.h  |    1 -
 drivers/gpu/drm/tegra/gr2d.c |    7 --
 drivers/gpu/drm/tegra/hdmi.c |   18 -----
 5 files changed, 47 insertions(+), 148 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 24bcd06..73056b7 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -740,7 +740,6 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	struct resource *regs;
 	struct tegra_dc *dc;
 	int err;
-	struct tegradrm *tegradrm = platform_get_drvdata(pdev);
 
 	dc = devm_kzalloc(&pdev->dev, sizeof(*dc), GFP_KERNEL);
 	if (!dc)
@@ -780,7 +779,6 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&dc->client.list);
 	dc->client.ops = &dc_client_ops;
 	dc->client.dev = &pdev->dev;
-	dc->client.tegradrm = tegradrm;
 
 	err = tegra_dc_rgb_probe(dc);
 	if (err < 0 && err != -ENODEV) {
@@ -788,13 +786,6 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	err = tegra_drm_register_client(tegradrm, &dc->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register tegra drm client: %d\n",
-			err);
-		return err;
-	}
-
 	platform_set_drvdata(pdev, dc);
 
 	return 0;
@@ -803,15 +794,6 @@ static int tegra_dc_probe(struct platform_device *pdev)
 static int tegra_dc_remove(struct platform_device *pdev)
 {
 	struct tegra_dc *dc = platform_get_drvdata(pdev);
-	int err;
-
-	err = tegra_drm_unregister_client(dc->client.tegradrm,
-			&dc->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister tegra_drm client: %d\n",
-			err);
-		return err;
-	}
 
 	clk_disable_unprepare(dc->clk);
 
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 637b621..520c281 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -25,12 +25,6 @@
 #define DRIVER_MINOR 0
 #define DRIVER_PATCHLEVEL 0
 
-struct tegra_drm_client_entry {
-	struct tegra_drm_client *client;
-	struct device_node *np;
-	struct list_head list;
-};
-
 static int tegra_drm_add_client(struct device *dev, void *data)
 {
 	static const char * const compat[] = {
@@ -42,102 +36,26 @@ static int tegra_drm_add_client(struct device *dev, void *data)
 		"nvidia,tegra30-gr2d"
 	};
 	struct tegradrm *tegradrm = data;
-	struct tegra_drm_client_entry *client;
+	struct tegra_drm_client *client;
 	unsigned int i;
 
+	/* Check if dev is a tegra-drm device, and add to client list */
 	for (i = 0; i < ARRAY_SIZE(compat); i++) {
 		if (of_device_is_compatible(dev->of_node, compat[i]) &&
 		    of_device_is_available(dev->of_node)) {
-			client = kzalloc(sizeof(*client), GFP_KERNEL);
+			client = dev_get_drvdata(dev);
 			if (!client)
-				return -ENOMEM;
+				return -EPROBE_DEFER;
 
 			INIT_LIST_HEAD(&client->list);
-			client->np = of_node_get(dev->of_node);
 
-			list_add_tail(&client->list, &tegradrm->drm_clients);
-			dev_set_drvdata(dev, tegradrm);
+			list_add_tail(&client->list, &tegradrm->clients);
 		}
 	}
 
 	return 0;
 }
 
-static int tegra_drm_parse_dt(struct tegradrm *tegradrm)
-{
-	int err;
-	struct device *dev;
-
-	/* host1x is parent of all devices */
-	dev = bus_find_device_by_name(&platform_bus_type, NULL, "host1x");
-	if (!dev)
-		return -ENODEV;
-
-	/* find devices that are available and add them into the 'required'
-	 * list */
-	err = device_for_each_child(dev, tegradrm, tegra_drm_add_client);
-
-	return err;
-}
-
-int tegra_drm_register_client(struct tegradrm *tegradrm,
-		struct tegra_drm_client *client)
-{
-	struct tegra_drm_client_entry *drm, *tmp;
-	int err;
-
-	mutex_lock(&tegradrm->clients_lock);
-	list_add_tail(&client->list, &tegradrm->clients);
-	mutex_unlock(&tegradrm->clients_lock);
-
-	/* remove this device from 'required' list */
-	list_for_each_entry_safe(drm, tmp, &tegradrm->drm_clients, list)
-		if (drm->np == client->dev->of_node)
-			list_del(&drm->list);
-
-	/* if all required devices are found, register drm device */
-	if (list_empty(&tegradrm->drm_clients)) {
-		struct platform_device *pdev =
-			to_platform_device(tegradrm->dev);
-		err = drm_platform_init(&tegra_drm_driver, pdev);
-		if (err < 0) {
-			dev_err(client->dev, "drm_platform_init(): %d\n", err);
-			return err;
-		}
-	}
-
-	return 0;
-}
-
-int tegra_drm_unregister_client(struct tegradrm *tegradrm,
-		struct tegra_drm_client *client)
-{
-	struct tegra_drm_client *tmp;
-
-	list_for_each_entry_safe(client, tmp, &tegradrm->clients, list) {
-		if (client->ops && client->ops->drm_exit) {
-			int err = client->ops->drm_exit(client);
-			if (err < 0) {
-				dev_err(client->dev,
-					"DRM cleanup failed for %s: %d\n",
-					dev_name(client->dev), err);
-				return err;
-			}
-		}
-
-		/* if this is the last device, unregister the drm driver */
-		if (client->list.next == &tegradrm->clients) {
-			struct platform_device *pdev =
-				to_platform_device(tegradrm->dev);
-			drm_platform_exit(&tegra_drm_driver, pdev);
-		}
-
-		list_del_init(&client->list);
-	}
-
-	return 0;
-}
-
 static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 {
 	struct tegra_drm_client *client;
@@ -175,6 +93,21 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 
 static int tegra_drm_unload(struct drm_device *drm)
 {
+	struct tegradrm *tegradrm = drm->dev_private;
+	struct tegra_drm_client *client;
+
+	list_for_each_entry(client, &tegradrm->clients, list) {
+		if (client->ops && client->ops->drm_exit) {
+			int err = client->ops->drm_exit(client);
+			if (err < 0) {
+				dev_err(client->dev,
+					"DRM cleanup failed for %s: %d\n",
+					dev_name(client->dev), err);
+				return err;
+			}
+		}
+	}
+
 	drm_kms_helper_poll_fini(drm);
 	tegra_drm_fb_exit(drm);
 
@@ -232,9 +165,17 @@ static int tegra_drm_probe(struct platform_device *pdev)
 	mutex_init(&tegradrm->clients_lock);
 	INIT_LIST_HEAD(&tegradrm->clients);
 
-	err = tegra_drm_parse_dt(tegradrm);
+	/* find devices that are available and add them into the client list */
+	err = bus_for_each_dev(&platform_bus_type, NULL,
+			tegradrm, tegra_drm_add_client);
+	if (err < 0) {
+		pr_err("failed to add clients: %d\n", err);
+		return err;
+	}
+
+	err = drm_platform_init(&tegra_drm_driver, pdev);
 	if (err < 0) {
-		pr_err("failed to parse DT: %d\n", err);
+		dev_err(&pdev->dev, "drm_platform_init(): %d\n", err);
 		return err;
 	}
 
@@ -243,6 +184,7 @@ static int tegra_drm_probe(struct platform_device *pdev)
 
 static int tegra_drm_remove(struct platform_device *pdev)
 {
+	drm_platform_exit(&tegra_drm_driver, pdev);
 	return 0;
 }
 
@@ -260,18 +202,9 @@ static int __init tegra_drm_init(void)
 	int err;
 	struct platform_device *drm_device;
 
-	drm_device = platform_device_register_simple("tegradrm", -1, NULL, 0);
-	if (!drm_device)
-		return -ENOMEM;
-	dma_set_coherent_mask(&drm_device->dev, DMA_BIT_MASK(32));
-
-	err = platform_driver_register(&tegra_drm_platform_driver);
-	if (err < 0)
-		goto unregister_tegra_dev;
-
 	err = platform_driver_register(&tegra_dc_driver);
 	if (err < 0)
-		goto unregister_tegra_drv;
+		return err;
 
 	err = platform_driver_register(&tegra_hdmi_driver);
 	if (err < 0)
@@ -280,26 +213,36 @@ static int __init tegra_drm_init(void)
 	err = platform_driver_register(&tegra_gr2d_driver);
 	if (err < 0)
 		goto unregister_hdmi;
+
+	drm_device = platform_device_register_simple("tegradrm", -1, NULL, 0);
+	if (!drm_device)
+		goto unregister_gr2d;
+	dma_set_coherent_mask(&drm_device->dev, DMA_BIT_MASK(32));
+
+	err = platform_driver_register(&tegra_drm_platform_driver);
+	if (err < 0)
+		goto unregister_tegra_dev;
+
 	return 0;
 
+unregister_tegra_dev:
+	platform_device_unregister(drm_device);
+unregister_gr2d:
+	platform_driver_unregister(&tegra_gr2d_driver);
 unregister_hdmi:
 	platform_driver_unregister(&tegra_hdmi_driver);
 unregister_dc:
 	platform_driver_unregister(&tegra_dc_driver);
-unregister_tegra_drv:
-	platform_driver_unregister(&tegra_drm_platform_driver);
-unregister_tegra_dev:
-	platform_device_unregister(drm_device);
 	return err;
 }
 module_init(tegra_drm_init);
 
 static void __exit tegra_drm_exit(void)
 {
+	platform_driver_unregister(&tegra_drm_platform_driver);
 	platform_driver_unregister(&tegra_gr2d_driver);
 	platform_driver_unregister(&tegra_hdmi_driver);
 	platform_driver_unregister(&tegra_dc_driver);
-	platform_driver_unregister(&tegra_drm_platform_driver);
 }
 module_exit(tegra_drm_exit);
 
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 06100d7..34ec9d2 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -75,7 +75,6 @@ tegra_drm_fpriv(struct drm_file *file_priv)
 }
 
 struct tegra_drm_client {
-	struct tegradrm *tegradrm;
 	struct device *dev;
 
 	const struct tegra_drm_client_ops *ops;
diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index 8865099..f39fef2 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -247,7 +247,6 @@ static int __devinit gr2d_probe(struct platform_device *dev)
 {
 	int err;
 	struct gr2d *gr2d = NULL;
-	struct tegradrm *tegradrm = platform_get_drvdata(dev);
 
 	gr2d = devm_kzalloc(&dev->dev, sizeof(*gr2d), GFP_KERNEL);
 	if (!gr2d)
@@ -278,11 +277,6 @@ static int __devinit gr2d_probe(struct platform_device *dev)
 	gr2d->client.ops = &gr2d_client_ops;
 	gr2d->client.dev = &dev->dev;
 	gr2d->client.class = NV_GRAPHICS_2D_CLASS_ID;
-	gr2d->client.tegradrm = tegradrm;
-
-	err = tegra_drm_register_client(tegradrm, &gr2d->client);
-	if (err)
-		return err;
 
 	platform_set_drvdata(dev, gr2d);
 	return 0;
@@ -292,7 +286,6 @@ static int __exit gr2d_remove(struct platform_device *dev)
 {
 	struct gr2d *gr2d = platform_get_drvdata(dev);
 	host1x_syncpt_free(gr2d->syncpt);
-	tegra_drm_unregister_client(gr2d->client.tegradrm, &gr2d->client);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index fce3e66..d987510 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1214,7 +1214,6 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 	struct tegra_hdmi *hdmi;
 	struct resource *regs;
 	int err;
-	struct tegradrm *tegradrm = platform_get_drvdata(pdev);
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
@@ -1285,14 +1284,6 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 	hdmi->client.ops = &hdmi_client_ops;
 	INIT_LIST_HEAD(&hdmi->client.list);
 	hdmi->client.dev = &pdev->dev;
-	hdmi->client.tegradrm = tegradrm;
-
-	err = tegra_drm_register_client(tegradrm, &hdmi->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to register tegra drm client: %d\n",
-			err);
-		return err;
-	}
 
 	platform_set_drvdata(pdev, hdmi);
 
@@ -1302,15 +1293,6 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 static int tegra_hdmi_remove(struct platform_device *pdev)
 {
 	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
-	int err;
-
-	err = tegra_drm_unregister_client(hdmi->client.tegradrm,
-			&hdmi->client);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to unregister tegra drm client: %d\n",
-			err);
-		return err;
-	}
 
 	clk_unprepare(hdmi->clk_parent);
 	clk_unprepare(hdmi->clk);
-- 
1.7.9.5


--------------080100050902000708080107--
