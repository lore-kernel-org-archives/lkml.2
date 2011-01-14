Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab1ANT0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:26:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab1ANTZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:25:15 -0500
From: Matthew Garrett <mjg@redhat.com>
To: akpm@linux-foundation.org
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/5] i915: Add native backlight control
Date: Fri, 14 Jan 2011 14:24:22 -0500
Message-Id: <1295033065-13450-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1295033065-13450-1-git-send-email-mjg@redhat.com>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all systems expose a firmware or platform mechanism for changing the
backlight intensity on i915, so add native driver support.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>
---
 drivers/gpu/drm/i915/i915_drv.h       |    4 ++
 drivers/gpu/drm/i915/intel_dp.c       |    7 +++
 drivers/gpu/drm/i915/intel_drv.h      |    3 +-
 drivers/gpu/drm/i915/intel_lvds.c     |    5 ++
 drivers/gpu/drm/i915/intel_opregion.c |    1 -
 drivers/gpu/drm/i915/intel_panel.c    |   72 ++++++++++++++++++++++++++++++++-
 6 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 5969f46..2d6ef13 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -36,6 +36,7 @@
 #include <linux/io-mapping.h>
 #include <linux/i2c.h>
 #include <drm/intel-gtt.h>
+#include <linux/backlight.h>
 
 /* General customization:
  */
@@ -667,6 +668,7 @@ typedef struct drm_i915_private {
 	int child_dev_num;
 	struct child_device_config *child_dev;
 	struct drm_connector *int_lvds_connector;
+	struct drm_connector *int_edp_connector;
 
 	bool mchbar_need_disable;
 
@@ -695,6 +697,8 @@ typedef struct drm_i915_private {
 
 	/* list of fbdev register on this device */
 	struct intel_fbdev *fbdev;
+
+	struct backlight_device *backlight;
 } drm_i915_private_t;
 
 struct drm_i915_gem_object {
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 1f4242b..54e89e9 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1682,6 +1682,11 @@ done:
 static void
 intel_dp_destroy (struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
+
+	if (intel_dpd_is_edp(dev))
+		intel_panel_destroy_backlight(dev);
+
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -1911,6 +1916,8 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 					DRM_MODE_TYPE_PREFERRED;
 			}
 		}
+		dev_priv->int_edp_connector = connector;
+		intel_panel_setup_backlight(dev);
 	}
 
 	intel_dp_add_properties(intel_dp, connector);
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 74db255..074d41a 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -257,9 +257,10 @@ extern void intel_pch_panel_fitting(struct drm_device *dev,
 extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
-extern void intel_panel_setup_backlight(struct drm_device *dev);
+extern int intel_panel_setup_backlight(struct drm_device *dev);
 extern void intel_panel_enable_backlight(struct drm_device *dev);
 extern void intel_panel_disable_backlight(struct drm_device *dev);
+extern void intel_panel_destroy_backlight(struct drm_device *dev);
 
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
 extern void intel_encoder_prepare (struct drm_encoder *encoder);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index ace8d5d..75f38c0 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -580,6 +580,8 @@ static void intel_lvds_destroy(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	intel_panel_destroy_backlight(dev);
+
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
@@ -1055,6 +1057,9 @@ out:
 	/* keep the LVDS connector */
 	dev_priv->int_lvds_connector = connector;
 	drm_sysfs_connector_add(connector);
+
+	intel_panel_setup_backlight(dev);
+
 	return true;
 
 failed:
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index f295a7a..5df3d38 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -224,7 +224,6 @@ void intel_opregion_asle_intr(struct drm_device *dev)
 	asle->aslc = asle_stat;
 }
 
-/* Only present on Ironlake+ */
 void intel_opregion_gse_intr(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index c65992d..4ab4239 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -274,10 +274,80 @@ void intel_panel_enable_backlight(struct drm_device *dev)
 	dev_priv->backlight_enabled = true;
 }
 
-void intel_panel_setup_backlight(struct drm_device *dev)
+void intel_panel_init_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
 	dev_priv->backlight_level = intel_panel_get_backlight(dev);
 	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
 }
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+static int intel_panel_update_status(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(bd);
+	intel_panel_set_backlight(dev, bd->props.brightness);
+	return 0;
+}
+
+static int intel_panel_get_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(bd);
+	return intel_panel_get_backlight(dev);
+}
+
+static const struct backlight_ops intel_panel_bl_ops = {
+	.update_status = intel_panel_update_status,
+	.get_brightness = intel_panel_get_brightness,
+};
+
+int intel_panel_setup_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
+	struct drm_connector *connector;
+
+	intel_panel_init_backlight(dev);
+
+	if (dev_priv->int_lvds_connector)
+		connector = dev_priv->int_lvds_connector;
+	else if (dev_priv->int_edp_connector)
+		connector = dev_priv->int_edp_connector;
+	else
+		return -ENODEV;
+
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = intel_panel_get_max_backlight(dev);
+	dev_priv->backlight =
+		backlight_device_register("intel_backlight",
+					  &connector->kdev, dev,
+					  &intel_panel_bl_ops, &props);
+
+	if (IS_ERR(dev_priv->backlight)) {
+		DRM_ERROR("Failed to register backlight: %ld\n",
+			  PTR_ERR(dev_priv->backlight));
+		dev_priv->backlight = NULL;
+		return -ENODEV;
+	}
+	dev_priv->backlight->props.brightness = intel_panel_get_backlight(dev);
+	return 0;
+}
+
+void intel_panel_destroy_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	if (dev_priv->backlight)
+		backlight_device_unregister(dev_priv->backlight);
+}
+#else
+int intel_panel_setup_backlight(struct drm_device *dev)
+{
+	intel_panel_init_backlight(dev);
+	return 0;
+}
+
+void intel_panel_destroy_backlight(struct drm_device *dev)
+{
+	return;
+}
+#endif
-- 
1.7.3.4

