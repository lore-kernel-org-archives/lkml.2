Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab1KPN3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:29:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:25474 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab1KPN3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:29:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,521,1315206000"; 
   d="scan'208";a="75649627"
Message-Id: <20111116132221.374839261@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 16 Nov 2011 21:20:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>, Wang Zhenyu <zhenyu.z.wang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: dri-devel@lists.freedesktop.org
cc: intel-gfx@lists.freedesktop.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] drm/i915: hot removal notification to HDMI audio driver
References: <20111116132004.299754849@intel.com>
Content-Disposition: inline; filename=eld-hot-removal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On monitor hot removal:

1) clear SDVO_AUDIO_ENABLE or DP_AUDIO_OUTPUT_ENABLE
2) clear ELD Valid bit

So that the audio driver will receive hot plug events and take action to
refresh its device state and ELD contents.

cc: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/drm_crtc_helper.c |    4 ++++
 drivers/gpu/drm/i915/intel_dp.c   |   17 +++++++++++++++++
 drivers/gpu/drm/i915/intel_drv.h  |    4 ++++
 drivers/gpu/drm/i915/intel_hdmi.c |   17 +++++++++++++++++
 include/drm/drm_crtc.h            |    1 +
 5 files changed, 43 insertions(+)

--- linux.orig/drivers/gpu/drm/i915/intel_dp.c	2011-11-16 20:54:28.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_dp.c	2011-11-16 21:19:42.000000000 +0800
@@ -1984,6 +1984,22 @@ intel_dp_detect(struct drm_connector *co
 	return connector_status_connected;
 }
 
+static void intel_dp_hot_remove(struct drm_connector *connector)
+{
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	struct drm_device *dev = intel_dp->base.base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct drm_crtc *crtc = intel_dp->base.base.crtc;
+
+	intel_dp->DP &= ~DP_AUDIO_OUTPUT_ENABLE;
+	I915_WRITE(intel_dp->output_reg, intel_dp->DP);
+	POSTING_READ(intel_dp->output_reg);
+
+	connector->eld[0] = 0;
+	if (dev_priv->display.write_eld)
+		dev_priv->display.write_eld(connector, crtc);
+}
+
 static int intel_dp_get_modes(struct drm_connector *connector)
 {
 	struct intel_dp *intel_dp = intel_attached_dp(connector);
@@ -2143,6 +2159,7 @@ static const struct drm_connector_funcs 
 	.detect = intel_dp_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.set_property = intel_dp_set_property,
+	.hot_remove = intel_dp_hot_remove,
 	.destroy = intel_dp_destroy,
 };
 
--- linux.orig/drivers/gpu/drm/i915/intel_drv.h	2011-11-16 20:54:27.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_drv.h	2011-11-16 21:19:42.000000000 +0800
@@ -382,6 +382,10 @@ extern void intel_fb_restore_mode(struct
 extern void intel_init_clock_gating(struct drm_device *dev);
 extern void intel_write_eld(struct drm_encoder *encoder,
 			    struct drm_display_mode *mode);
+extern void intel_hotplug_status(struct drm_device *dev,
+			  struct drm_connector *connector,
+			  struct drm_crtc *crtc,
+			  enum drm_connector_status status);
 extern void intel_cpt_verify_modeset(struct drm_device *dev, int pipe);
 
 #endif /* __INTEL_DRV_H__ */
--- linux.orig/drivers/gpu/drm/i915/intel_hdmi.c	2011-11-16 20:55:13.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_hdmi.c	2011-11-16 21:19:42.000000000 +0800
@@ -350,6 +350,22 @@ intel_hdmi_detect(struct drm_connector *
 	return status;
 }
 
+static void intel_hdmi_hot_remove(struct drm_connector *connector)
+{
+	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
+	struct drm_i915_private *dev_priv = connector->dev->dev_private;
+	u32 temp;
+
+	temp = I915_READ(intel_hdmi->sdvox_reg);
+	I915_WRITE(intel_hdmi->sdvox_reg, temp & ~SDVO_AUDIO_ENABLE);
+	POSTING_READ(intel_hdmi->sdvox_reg);
+
+	connector->eld[0] = 0;
+	if (dev_priv->display.write_eld)
+		dev_priv->display.write_eld(connector,
+					    intel_hdmi->base.base.crtc);
+}
+
 static int intel_hdmi_get_modes(struct drm_connector *connector)
 {
 	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
@@ -459,6 +475,7 @@ static const struct drm_connector_funcs 
 	.detect = intel_hdmi_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.set_property = intel_hdmi_set_property,
+	.hot_remove = intel_hdmi_hot_remove,
 	.destroy = intel_hdmi_destroy,
 };
 
--- linux.orig/drivers/gpu/drm/drm_crtc_helper.c	2011-11-16 20:55:13.000000000 +0800
+++ linux/drivers/gpu/drm/drm_crtc_helper.c	2011-11-16 21:19:42.000000000 +0800
@@ -905,6 +905,10 @@ static void output_poll_execute(struct w
 			      old_status, connector->status);
 		if (old_status != connector->status)
 			changed = true;
+		if (old_status == connector_status_connected &&
+		    connector->status == connector_status_disconnected)
+			connector->funcs->hot_remove(connector);
+
 	}
 
 	mutex_unlock(&dev->mode_config.mutex);
--- linux.orig/include/drm/drm_crtc.h	2011-11-16 20:54:28.000000000 +0800
+++ linux/include/drm/drm_crtc.h	2011-11-16 21:19:42.000000000 +0800
@@ -419,6 +419,7 @@ struct drm_connector_funcs {
 	int (*fill_modes)(struct drm_connector *connector, uint32_t max_width, uint32_t max_height);
 	int (*set_property)(struct drm_connector *connector, struct drm_property *property,
 			     uint64_t val);
+	void (*hot_remove)(struct drm_connector *connector);
 	void (*destroy)(struct drm_connector *connector);
 	void (*force)(struct drm_connector *connector);
 };


