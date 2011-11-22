Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1KVI0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:26:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:11116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab1KVI0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:26:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78689074"
Date: Tue, 22 Nov 2011 16:26:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] drm/i915: hot plug/unplug notification to HDMI
 audio driver
Message-ID: <20111122082636.GA27494@localhost>
References: <20111121063749.GA23450@localhost>
 <86hb1xife8.fsf@sumi.keithp.com>
 <20111122074055.GA21560@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122074055.GA21560@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The X environment will eventually call mode_set when the user
> > environment decides to use the monitor. Any audio bits can, and should,
> > await the user's choice of a video mode before choosing the audio format
> > to use. We should not be adding eld information until the monitor is in
> > use.
> 
> Yeah. I just tested the full gnome desktop and find it behave like the
> KMS console:
> 
> 1) ->mode_set will be called
> 2) crtc is 0 in intel_hdmi_hotplug(), hence skipping the ELD code there
> 
> So the v3 patch will behave equally well on KMS console, gnome desktop
> and bare X. Shall we just use it, or go back and use the original
> ->hot_remove patch?

Here is the patch with updated comments and changelog to reflect the
new findings.

---
Subject: drm/i915: hot plug/unplug notification to HDMI audio driver
Date: Fri Nov 11 13:49:04 CST 2011

On monitor hot plug/unplug, update ELD and set/clear SDVO_AUDIO_ENABLE
or DP_AUDIO_OUTPUT_ENABLE accordingly.  So that the audio driver will
receive hot plug events and take action to refresh its device state and
ELD contents.

A new callback ->hotplug() is added to struct drm_connector_funcs which
will be called immediately after ->detect() knowing that the monitor is
either plugged or unplugged.

It's noticed that X may not call ->mode_set() at monitor hot plug, so it's
necessary to call drm_edid_to_eld() earlier at ->detect() time rather than
in intel_ddc_get_modes(), so that intel_write_eld() can see the new ELD
in ->hotplug.

The call sequence on hot plug is
(the difference part lies in ->mode_set vs ->hotplug)

- KMS console
	->detect
	  drm_edid_to_eld
	->mode_set
	  intel_write_eld
	  set SDVO_AUDIO_ENABLE/DP_AUDIO_OUTPUT_ENABLE
- X
	->detect
	  drm_edid_to_eld
	->hotplug
	  intel_write_eld
	  set SDVO_AUDIO_ENABLE/DP_AUDIO_OUTPUT_ENABLE

On hot remove, the call sequence is

	->hotplug
	  clear SDVO_AUDIO_ENABLE/DP_AUDIO_OUTPUT_ENABLE

cc: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/drm_crtc_helper.c  |    6 +++
 drivers/gpu/drm/i915/intel_dp.c    |   44 +++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_hdmi.c  |   31 +++++++++++++++++++
 drivers/gpu/drm/i915/intel_modes.c |    2 -
 include/drm/drm_crtc.h             |    1 
 5 files changed, 72 insertions(+), 12 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/intel_dp.c	2011-11-21 11:26:09.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_dp.c	2011-11-21 14:12:21.000000000 +0800
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <drm/drm_edid.h>
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc.h"
@@ -1970,20 +1971,44 @@ intel_dp_detect(struct drm_connector *co
 	if (status != connector_status_connected)
 		return status;
 
-	if (intel_dp->force_audio) {
-		intel_dp->has_audio = intel_dp->force_audio > 0;
-	} else {
-		edid = intel_dp_get_edid(connector, &intel_dp->adapter);
-		if (edid) {
-			intel_dp->has_audio = drm_detect_monitor_audio(edid);
-			connector->display_info.raw_edid = NULL;
-			kfree(edid);
-		}
+	edid = intel_dp_get_edid(connector, &intel_dp->adapter);
+	if (edid) {
+		intel_dp->has_audio = drm_detect_monitor_audio(edid);
+		drm_edid_to_eld(connector, edid);
+		connector->display_info.raw_edid = NULL;
+		kfree(edid);
 	}
 
+	if (intel_dp->force_audio)
+		intel_dp->has_audio = intel_dp->force_audio > 0;
+
 	return connector_status_connected;
 }
 
+static void intel_dp_hotplug(struct drm_connector *connector)
+{
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	struct drm_device *dev = intel_dp->base.base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct drm_crtc *crtc = intel_dp->base.base.crtc;
+
+	DRM_DEBUG_DRIVER("DisplayPort hotplug status %d crtc %p eld %#x\n",
+			 connector->status,
+			 crtc,
+			 (unsigned int)connector->eld[0]);
+
+	if (connector->status == connector_status_disconnected) {
+		intel_dp->DP &= ~DP_AUDIO_OUTPUT_ENABLE;
+	} else if (connector->status == connector_status_connected && crtc) {
+		intel_write_eld(&intel_dp->base.base, &crtc->mode);
+		intel_dp->DP |= DP_AUDIO_OUTPUT_ENABLE;
+	} else {
+		return;
+	}
+	I915_WRITE(intel_dp->output_reg, intel_dp->DP);
+	POSTING_READ(intel_dp->output_reg);
+}
+
 static int intel_dp_get_modes(struct drm_connector *connector)
 {
 	struct intel_dp *intel_dp = intel_attached_dp(connector);
@@ -2143,6 +2168,7 @@ static const struct drm_connector_funcs 
 	.detect = intel_dp_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.set_property = intel_dp_set_property,
+	.hotplug = intel_dp_hotplug,
 	.destroy = intel_dp_destroy,
 };
 
--- linux.orig/drivers/gpu/drm/i915/intel_hdmi.c	2011-11-21 11:26:09.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_hdmi.c	2011-11-21 14:12:26.000000000 +0800
@@ -337,6 +337,7 @@ intel_hdmi_detect(struct drm_connector *
 			status = connector_status_connected;
 			intel_hdmi->has_hdmi_sink = drm_detect_hdmi_monitor(edid);
 			intel_hdmi->has_audio = drm_detect_monitor_audio(edid);
+			drm_edid_to_eld(connector, edid);
 		}
 		connector->display_info.raw_edid = NULL;
 		kfree(edid);
@@ -350,6 +351,35 @@ intel_hdmi_detect(struct drm_connector *
 	return status;
 }
 
+static void intel_hdmi_hotplug(struct drm_connector *connector)
+{
+	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
+	struct drm_i915_private *dev_priv = connector->dev->dev_private;
+	struct drm_crtc *crtc = intel_hdmi->base.base.crtc;
+	u32 temp;
+
+	DRM_DEBUG_DRIVER("HDMI hotplug status %d crtc %p eld %#x\n",
+			 connector->status,
+			 crtc,
+			 (unsigned int)connector->eld[0]);
+
+	if (connector->status == connector_status_disconnected) {
+		temp = I915_READ(intel_hdmi->sdvox_reg) & ~SDVO_AUDIO_ENABLE;
+	} else if (connector->status == connector_status_connected && crtc) {
+		/*
+		 * It's for X only, which may not call ->mode_set on hot plug.
+		 * KMS console has NULL crtc at this time and will
+		 * call ->mode_set to enable HDMI audio a bit later.
+		 */
+		intel_write_eld(&intel_hdmi->base.base, &crtc->mode);
+		temp = I915_READ(intel_hdmi->sdvox_reg) | SDVO_AUDIO_ENABLE;
+	} else {
+		return;
+	}
+	I915_WRITE(intel_hdmi->sdvox_reg, temp);
+	POSTING_READ(intel_hdmi->sdvox_reg);
+}
+
 static int intel_hdmi_get_modes(struct drm_connector *connector)
 {
 	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
@@ -459,6 +489,7 @@ static const struct drm_connector_funcs 
 	.detect = intel_hdmi_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
 	.set_property = intel_hdmi_set_property,
+	.hotplug = intel_hdmi_hotplug,
 	.destroy = intel_hdmi_destroy,
 };
 
--- linux.orig/drivers/gpu/drm/drm_crtc_helper.c	2011-11-21 11:26:09.000000000 +0800
+++ linux/drivers/gpu/drm/drm_crtc_helper.c	2011-11-21 16:19:11.000000000 +0800
@@ -903,8 +903,12 @@ static void output_poll_execute(struct w
 			      connector->base.id,
 			      drm_get_connector_name(connector),
 			      old_status, connector->status);
-		if (old_status != connector->status)
+		if (old_status != connector->status) {
 			changed = true;
+			if (connector->funcs->hotplug)
+				connector->funcs->hotplug(connector);
+		}
+
 	}
 
 	mutex_unlock(&dev->mode_config.mutex);
--- linux.orig/include/drm/drm_crtc.h	2011-11-21 11:26:09.000000000 +0800
+++ linux/include/drm/drm_crtc.h	2011-11-21 11:26:14.000000000 +0800
@@ -419,6 +419,7 @@ struct drm_connector_funcs {
 	int (*fill_modes)(struct drm_connector *connector, uint32_t max_width, uint32_t max_height);
 	int (*set_property)(struct drm_connector *connector, struct drm_property *property,
 			     uint64_t val);
+	void (*hotplug)(struct drm_connector *connector);
 	void (*destroy)(struct drm_connector *connector);
 	void (*force)(struct drm_connector *connector);
 };
--- linux.orig/drivers/gpu/drm/i915/intel_modes.c	2011-11-21 11:26:09.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_modes.c	2011-11-21 11:26:14.000000000 +0800
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/fb.h>
-#include <drm/drm_edid.h>
 #include "drmP.h"
 #include "intel_drv.h"
 #include "i915_drv.h"
@@ -75,7 +74,6 @@ int intel_ddc_get_modes(struct drm_conne
 	if (edid) {
 		drm_mode_connector_update_edid_property(connector, edid);
 		ret = drm_add_edid_modes(connector, edid);
-		drm_edid_to_eld(connector, edid);
 		connector->display_info.raw_edid = NULL;
 		kfree(edid);
 	}
