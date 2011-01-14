Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab1ANTZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:25:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933180Ab1ANTZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:25:11 -0500
From: Matthew Garrett <mjg@redhat.com>
To: akpm@linux-foundation.org
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/5] nouveau: Change the backlight parent device to the connector, not the PCI dev
Date: Fri, 14 Jan 2011 14:24:24 -0500
Message-Id: <1295033065-13450-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1295033065-13450-1-git-send-email-mjg@redhat.com>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may eventually end up with per-connector backlights, especially with
ddcci devices. Make sure that the parent node for the backlight device is
the connector rather than the PCI device.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_backlight.c |   24 ++++++++++++++----------
 drivers/gpu/drm/nouveau/nouveau_connector.c |    9 +++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    8 ++++----
 drivers/gpu/drm/nouveau/nouveau_state.c     |    6 ------
 4 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 18d7bcc..00a55df 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -88,10 +88,11 @@ static const struct backlight_ops nv50_bl_ops = {
 	.update_status = nv50_set_intensity,
 };
 
-static int nouveau_nv40_backlight_init(struct drm_device *dev)
+static int nouveau_nv40_backlight_init(struct drm_connector *connector)
 {
-	struct backlight_properties props;
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
 	struct backlight_device *bd;
 
 	if (!(nv_rd32(dev, NV40_PMC_BACKLIGHT) & NV40_PMC_BACKLIGHT_MASK))
@@ -100,7 +101,7 @@ static int nouveau_nv40_backlight_init(struct drm_device *dev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 31;
-	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
+	bd = backlight_device_register("nv_backlight", &connector->kdev, dev,
 				       &nv40_bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
@@ -112,10 +113,11 @@ static int nouveau_nv40_backlight_init(struct drm_device *dev)
 	return 0;
 }
 
-static int nouveau_nv50_backlight_init(struct drm_device *dev)
+static int nouveau_nv50_backlight_init(struct drm_connector *connector)
 {
-	struct backlight_properties props;
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
 	struct backlight_device *bd;
 
 	if (!nv_rd32(dev, NV50_PDISPLAY_SOR_BACKLIGHT))
@@ -124,7 +126,7 @@ static int nouveau_nv50_backlight_init(struct drm_device *dev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 1025;
-	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
+	bd = backlight_device_register("nv_backlight", &connector->kdev, dev,
 				       &nv50_bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
@@ -135,8 +137,9 @@ static int nouveau_nv50_backlight_init(struct drm_device *dev)
 	return 0;
 }
 
-int nouveau_backlight_init(struct drm_device *dev)
+int nouveau_backlight_init(struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 
 #ifdef CONFIG_ACPI
@@ -149,9 +152,9 @@ int nouveau_backlight_init(struct drm_device *dev)
 
 	switch (dev_priv->card_type) {
 	case NV_40:
-		return nouveau_nv40_backlight_init(dev);
+		return nouveau_nv40_backlight_init(connector);
 	case NV_50:
-		return nouveau_nv50_backlight_init(dev);
+		return nouveau_nv50_backlight_init(connector);
 	default:
 		break;
 	}
@@ -159,8 +162,9 @@ int nouveau_backlight_init(struct drm_device *dev)
 	return 0;
 }
 
-void nouveau_backlight_exit(struct drm_device *dev)
+void nouveau_backlight_exit(struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 
 	if (dev_priv->backlight) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index a21e000..3a1ecc7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -116,6 +116,10 @@ nouveau_connector_destroy(struct drm_connector *connector)
 				      nouveau_connector_hotplug, connector);
 	}
 
+	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS ||
+	    connector->connector_type == DRM_MODE_CONNECTOR_eDP)
+		nouveau_backlight_exit(connector);
+
 	kfree(nv_connector->edid);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
@@ -893,6 +897,11 @@ nouveau_connector_create(struct drm_device *dev, int index)
 	}
 
 	drm_sysfs_connector_add(connector);
+
+	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS ||
+	    connector->connector_type == DRM_MODE_CONNECTOR_eDP)
+		nouveau_backlight_init(connector);
+
 	dcb->drm = connector;
 	return dcb->drm;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 46e3257..1918ed1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -999,15 +999,15 @@ static inline int nouveau_acpi_edid(struct drm_device *dev, struct drm_connector
 
 /* nouveau_backlight.c */
 #ifdef CONFIG_DRM_NOUVEAU_BACKLIGHT
-extern int nouveau_backlight_init(struct drm_device *);
-extern void nouveau_backlight_exit(struct drm_device *);
+extern int nouveau_backlight_init(struct drm_connector *);
+extern void nouveau_backlight_exit(struct drm_connector *);
 #else
-static inline int nouveau_backlight_init(struct drm_device *dev)
+static inline int nouveau_backlight_init(struct drm_connector *dev)
 {
 	return 0;
 }
 
-static inline void nouveau_backlight_exit(struct drm_device *dev) { }
+static inline void nouveau_backlight_exit(struct drm_connector *dev) { }
 #endif
 
 /* nouveau_bios.c */
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index a54fc43..f688f04 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -738,10 +738,6 @@ nouveau_card_init(struct drm_device *dev)
 			goto out_fence;
 	}
 
-	ret = nouveau_backlight_init(dev);
-	if (ret)
-		NV_ERROR(dev, "Error %d registering backlight\n", ret);
-
 	nouveau_fbcon_init(dev);
 	drm_kms_helper_poll_init(dev);
 	return 0;
@@ -793,8 +789,6 @@ static void nouveau_card_takedown(struct drm_device *dev)
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nouveau_engine *engine = &dev_priv->engine;
 
-	nouveau_backlight_exit(dev);
-
 	if (!engine->graph.accel_blocked) {
 		nouveau_fence_fini(dev);
 		nouveau_channel_put_unlocked(&dev_priv->channel);
-- 
1.7.3.4

