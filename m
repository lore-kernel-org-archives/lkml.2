Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0KSPzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:55:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0KSPz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:55:28 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/5] i915: Add native backlight control
Date: Fri, 19 Nov 2010 10:53:53 -0500
Message-Id: <1290182036-30484-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1290182036-30484-1-git-send-email-mjg@redhat.com>
References: <1290182036-30484-1-git-send-email-mjg@redhat.com>
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
 drivers/gpu/drm/i915/intel_drv.h      |    2 +
 drivers/gpu/drm/i915/intel_lvds.c     |    5 ++
 drivers/gpu/drm/i915/intel_opregion.c |    1 -
 drivers/gpu/drm/i915/intel_panel.c    |   67 +++++++++++++++++++++++++++++++++
 6 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 90414ae..f311ce4 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -36,6 +36,7 @@
 #include <linux/io-mapping.h>
 #include <linux/i2c.h>
 #include <drm/intel-gtt.h>
+#include <linux/backlight.h>
 
 /* General customization:
  */
@@ -679,6 +680,7 @@ typedef struct drm_i915_private {
 	int child_dev_num;
 	struct child_device_config *child_dev;
 	struct drm_connector *int_lvds_connector;
+	struct drm_connector *int_edp_connector;
 
 	bool mchbar_need_disable;
 
@@ -707,6 +709,8 @@ typedef struct drm_i915_private {
 
 	/* list of fbdev register on this device */
 	struct intel_fbdev *fbdev;
+
+	struct backlight_device *backlight;
 } drm_i915_private_t;
 
 /** driver private structure attached to each drm_gem_object */
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index c8e0055..7cfefb5 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1639,6 +1639,11 @@ done:
 static void
 intel_dp_destroy (struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
+
+	if (intel_dpd_is_edp(dev))
+		intel_panel_backlight_destroy(dev);
+
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -1868,6 +1873,8 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 					DRM_MODE_TYPE_PREFERRED;
 			}
 		}
+		dev_priv->int_edp_connector = connector;
+		intel_panel_backlight_setup(dev);
 	}
 
 	intel_dp_add_properties(intel_dp, connector);
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 21551fe..7917bec 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -256,6 +256,8 @@ extern void intel_pch_panel_fitting(struct drm_device *dev,
 extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
+extern int intel_panel_backlight_setup(struct drm_device *dev);
+extern void intel_panel_backlight_destroy(struct drm_device *dev);
 
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
 extern void intel_encoder_prepare (struct drm_encoder *encoder);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 4324a32..f69a7b8 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -569,6 +569,8 @@ static void intel_lvds_destroy(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	intel_panel_backlight_destroy(dev);
+
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
@@ -1026,6 +1028,9 @@ out:
 	/* keep the LVDS connector */
 	dev_priv->int_lvds_connector = connector;
 	drm_sysfs_connector_add(connector);
+
+	intel_panel_backlight_setup(dev);
+
 	return;
 
 failed:
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 9b0d9a8..bf79c02 100644
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
index 92ff8f3..1eaa66e 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -218,3 +218,70 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level)
 		tmp &= ~BACKLIGHT_DUTY_CYCLE_MASK;
 	I915_WRITE(BLC_PWM_CTL, tmp | level);
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
+int intel_panel_backlight_setup(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct backlight_properties props;
+	struct drm_connector *connector;
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
+void intel_panel_backlight_destroy(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	if (dev_priv->backlight)
+		backlight_device_unregister(dev_priv->backlight);
+}
+#else
+int intel_panel_backlight_setup(struct drm_device *dev)
+{
+	return 0;
+}
+
+void intel_panel_backlight_destroy(struct drm_device *dev)
+{
+	return;
+}
+#endif
-- 
1.7.3.2

