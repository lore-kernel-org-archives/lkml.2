Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0KSPze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:55:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0KSPzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:55:31 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/5] nouveau: Change the backlight parent device to the connector, not the PCI dev
Date: Fri, 19 Nov 2010 10:53:55 -0500
Message-Id: <1290182036-30484-4-git-send-email-mjg@redhat.com>
In-Reply-To: <1290182036-30484-1-git-send-email-mjg@redhat.com>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com>
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
 drivers/gpu/drm/nouveau/nouveau_backlight.c |   21 ++++++++++++---------
 drivers/gpu/drm/nouveau/nouveau_connector.c |    9 +++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    4 ++--
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 9485af3..7e8a448 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -87,10 +87,11 @@ static struct backlight_ops nv50_bl_ops = {
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
@@ -99,7 +100,7 @@ static int nouveau_nv40_backlight_init(struct drm_device *dev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 31;
-	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
+	bd = backlight_device_register("nv_backlight", &connector->kdev, dev,
 				       &nv40_bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
@@ -111,10 +112,11 @@ static int nouveau_nv40_backlight_init(struct drm_device *dev)
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
@@ -123,7 +125,7 @@ static int nouveau_nv50_backlight_init(struct drm_device *dev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 1025;
-	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
+	bd = backlight_device_register("nv_backlight", &connector->kdev, dev,
 				       &nv50_bl_ops, &props);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
@@ -134,15 +136,16 @@ static int nouveau_nv50_backlight_init(struct drm_device *dev)
 	return 0;
 }
 
-int nouveau_backlight_init(struct drm_device *dev)
+int nouveau_backlight_init(struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 
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
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 0871495..914058d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -106,6 +106,10 @@ nouveau_connector_destroy(struct drm_connector *drm_connector)
 	dev = nv_connector->base.dev;
 	NV_DEBUG_KMS(dev, "\n");
 
+	if (drm_connector->connector_type == DRM_MODE_CONNECTOR_LVDS ||
+	    drm_connector->connector_type == DRM_MODE_CONNECTOR_eDP)
+		nouveau_backlight_exit(dev);
+
 	kfree(nv_connector->edid);
 	drm_sysfs_connector_remove(drm_connector);
 	drm_connector_cleanup(drm_connector);
@@ -894,6 +898,11 @@ nouveau_connector_create(struct drm_device *dev, int index)
 	nouveau_connector_set_polling(connector);
 
 	drm_sysfs_connector_add(connector);
+
+	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS ||
+	    connector->connector_type == DRM_MODE_CONNECTOR_eDP)
+		nouveau_backlight_init(connector);
+
 	dcb->drm = connector;
 	return dcb->drm;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 3a07e58..3c65b77 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -933,10 +933,10 @@ static inline int nouveau_acpi_edid(struct drm_device *dev, struct drm_connector
 
 /* nouveau_backlight.c */
 #ifdef CONFIG_DRM_NOUVEAU_BACKLIGHT
-extern int nouveau_backlight_init(struct drm_device *);
+extern int nouveau_backlight_init(struct drm_connector *);
 extern void nouveau_backlight_exit(struct drm_device *);
 #else
-static inline int nouveau_backlight_init(struct drm_device *dev)
+static inline int nouveau_backlight_init(struct drm_connector *dev)
 {
 	return 0;
 }
-- 
1.7.3.2

