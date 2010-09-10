Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0IJODL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:03:11 -0400
Received: from server109-228-6-235.live-servers.net ([109.228.6.235]:57536
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754182Ab0IJODJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:03:09 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] drm/i915: Expose a native backlight device
Date: Fri, 10 Sep 2010 14:38:03 +0100
Message-Id: <1284125883-1456-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283963539-4039-2-git-send-email-mjg@redhat.com>
References: <1283963539-4039-2-git-send-email-mjg@redhat.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on an original patch by Matthew Garrett <mjg@redhat.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/gpu/drm/i915/intel_dp.c    |    7 ++++-
 drivers/gpu/drm/i915/intel_drv.h   |   19 +++++++++++++
 drivers/gpu/drm/i915/intel_lvds.c  |    4 +++
 drivers/gpu/drm/i915/intel_panel.c |   50 ++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index b9efeaf..537375d 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1522,8 +1522,10 @@ static int intel_dp_get_modes(struct drm_connector *connector)
 }
 
 static void
-intel_dp_destroy (struct drm_connector *connector)
+intel_dp_destroy(struct drm_connector *connector)
 {
+	intel_panel_backlight_destroy(to_intel_connector(connector));
+
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -1729,4 +1731,7 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 		u32 temp = I915_READ(PEG_BAND_GAP_DATA);
 		I915_WRITE(PEG_BAND_GAP_DATA, (temp & ~0xf) | 0xd);
 	}
+
+	if (IS_eDP(intel_dp))
+	    intel_panel_backlight_create(intel_connector);
 }
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 1ada684..5b6f9f7 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <linux/i2c-algo-bit.h>
+#include <linux/backlight.h>
 #include "i915_drv.h"
 #include "drm_crtc.h"
 #include "drm_crtc_helper.h"
@@ -151,6 +152,9 @@ struct intel_encoder {
 struct intel_connector {
 	struct drm_connector base;
 	struct intel_encoder *encoder;
+
+	/* expose a RAW native backlight interface */
+	struct backlight_device *backlight;
 };
 
 struct intel_crtc {
@@ -229,6 +233,21 @@ extern u32 intel_panel_get_max_backlight(struct drm_device *dev);
 extern u32 intel_panel_get_backlight(struct drm_device *dev);
 extern void intel_panel_set_backlight(struct drm_device *dev, u32 level);
 
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+extern int intel_panel_backlight_create(struct intel_connector *connector);
+extern void intel_panel_backlight_destroy(struct intel_connector *connector);
+#else
+static inline int intel_panel_backlight_create(struct intel_connector *connector)
+{
+	return -ENODEV;
+}
+
+static inline void intel_panel_backlight_destroy(struct intel_connector *connector)
+{
+	return;
+}
+#endif
+
 extern int intel_panel_fitter_pipe (struct drm_device *dev);
 extern void intel_crtc_load_lut(struct drm_crtc *crtc);
 extern void intel_encoder_prepare (struct drm_encoder *encoder);
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 93a711d..65d3e66 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -541,6 +541,8 @@ static void intel_lvds_destroy(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	intel_panel_backlight_destroy(to_intel_connector(connector));
+
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
@@ -964,6 +966,8 @@ out:
 	/* keep the LVDS connector */
 	dev_priv->int_lvds_connector = connector;
 	drm_sysfs_connector_add(connector);
+
+	intel_panel_backlight_create(intel_connector);
 	return;
 
 failed:
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 30abe7a..ec7d38e 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -218,3 +218,53 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level)
 		tmp &= ~BACKLIGHT_DUTY_CYCLE_MASK;
 	I915_WRITE(BLC_PWM_CTL, tmp | level);
 }
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+static int intel_backlight_update_status(struct backlight_device *bd)
+{
+	struct intel_connector *connector = bl_get_data(bd);
+	intel_panel_set_backlight(connector->base.dev, bd->props.brightness);
+	return 0;
+}
+
+static int intel_backlight_get_brightness(struct backlight_device *bd)
+{
+	struct intel_connector *connector = bl_get_data(bd);
+	return intel_panel_get_backlight(connector->base.dev);
+}
+
+static const struct backlight_ops intel_backlight_ops = {
+	.update_status = intel_backlight_update_status,
+	.get_brightness = intel_backlight_get_brightness,
+};
+
+int intel_panel_backlight_create(struct intel_connector *connector)
+{
+	struct drm_device *dev = connector->base.dev;
+	struct backlight_properties props;
+
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = intel_panel_get_max_backlight(dev);
+	connector->backlight =
+		backlight_device_register("intel_backlight",
+					  &connector->base.kdev,
+					  connector,
+					  &intel_backlight_ops,
+					  &props);
+	if (IS_ERR(connector->backlight)) {
+		int ret = PTR_ERR(connector->backlight);
+		DRM_ERROR("Failed to register backlight: %d\n", ret);
+		connector->backlight = NULL;
+		return ret;
+	}
+
+	connector->backlight->props.brightness = intel_panel_get_backlight(dev);
+	return 0;
+}
+
+void intel_panel_backlight_destroy(struct intel_connector *connector)
+{
+	if (connector->backlight)
+		backlight_device_unregister(connector->backlight);
+}
+#endif
-- 
1.7.1

