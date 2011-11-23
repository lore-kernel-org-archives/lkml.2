Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab1KWIaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:30:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:29114 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab1KWIaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:30:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,557,1315206000"; 
   d="scan'208";a="78293357"
Date: Wed, 23 Nov 2011 16:29:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] drm/i915: hot plug/unplug notification to HDMI
 audio driver
Message-ID: <20111123082958.GA4209@localhost>
References: <20111121063749.GA23450@localhost>
 <86hb1xife8.fsf@sumi.keithp.com>
 <20111122074055.GA21560@localhost>
 <86sjlgf20l.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sjlgf20l.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 02:25:14AM +0800, Keith Packard wrote:
> On Tue, 22 Nov 2011 15:40:55 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > So the v3 patch will behave equally well on KMS console, gnome desktop
> > and bare X. Shall we just use it, or go back and use the original
> > ->hot_remove patch?
> 
> I'm not sure why we need any change to the core DRM code. The HDMI and
> DP drivers will be told when to turn the monitors on and off, and that's

Yeah, The DP driver will be notified via the intel_dp_hot_plug() hook
if I understand it right.

> the appropriate time to control whether audio is routed to them.

However ->hot_plug() is called too early to be useful for this case.

What I need is a hot plug hook that knows whether the monitor is
plugged or removed, which is only possible if the hook is called
after ->detect().

Or, we can avoid adding the ->hotplug() hook and just add the call
directly to intel_hdmi_detect() and intel_dp_detect().

The below patch does this and eliminates the DRM callback :-)

> Hotplug is considered simply a notification to user space that
> something has changed -- user space is in charge of configuring
> which outputs are in use.

Yeah, and here is another notification to the audio driver demanded by
the HD audio spec.

Thanks,
Fengguang
---
Subject: drm/i915: hot plug/remove notification to HDMI audio driver
Date: Fri Nov 11 13:49:04 CST 2011

On monitor hot plug/unplug, set/clear SDVO_AUDIO_ENABLE or
DP_AUDIO_OUTPUT_ENABLE accordingly, so that the audio driver will
receive hot plug events and take action to refresh its device state and
ELD contents.

After intel_dp_detect() knows whether the monitor is plugged or
removed, it will call intel_dp_hotplug_audio() to notify the audio
driver of the event.

It's noticed that bare metal X may not call ->mode_set() at monitor hot
plug, so it's necessary to call drm_edid_to_eld() earlier at ->detect()
time rather than in intel_ddc_get_modes(), so that intel_write_eld() can
see the new ELD in intel_dp_hotplug_audio().

The call sequence on hot plug is

- KMS console, full blown X (eg. gnome desktop)
	->detect
	  drm_edid_to_eld
	->mode_set
	  intel_write_eld
	  set SDVO_AUDIO_ENABLE/DP_AUDIO_OUTPUT_ENABLE
- bare metal X (eg. fluxbox)
	->detect
	  drm_edid_to_eld
	  intel_dp_hotplug_audio()
	    intel_write_eld
	    set SDVO_AUDIO_ENABLE/DP_AUDIO_OUTPUT_ENABLE

On hot remove, the call sequence is

	->detect
	  intel_dp_hotplug_audio()
	    clear SDVO_AUDIO_ENABLE/DP_AUDIO_OUTPUT_ENABLE

cc: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_dp.c    |   47 ++++++++++++++++++++-------
 drivers/gpu/drm/i915/intel_hdmi.c  |   32 ++++++++++++++++++
 drivers/gpu/drm/i915/intel_modes.c |    2 -
 3 files changed, 68 insertions(+), 13 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/intel_dp.c	2011-11-23 15:16:10.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_dp.c	2011-11-23 16:20:25.000000000 +0800
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <drm/drm_edid.h>
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc.h"
@@ -1940,6 +1941,27 @@ intel_dp_get_edid_modes(struct drm_conne
 	return ret;
 }
 
+static void intel_dp_hotplug_audio(struct drm_connector *connector,
+				   enum drm_connector_status status)
+{
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	struct drm_device *dev = intel_dp->base.base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct drm_crtc *crtc = intel_dp->base.base.crtc;
+
+	DRM_DEBUG_DRIVER("hotplug status %d crtc %p eld %#x\n",
+			 status, crtc, (unsigned int)connector->eld[0]);
+
+	if (status == connector_status_disconnected)
+		intel_dp->DP &= ~DP_AUDIO_OUTPUT_ENABLE;
+	else if (status == connector_status_connected && crtc) {
+		intel_write_eld(&intel_dp->base.base, &crtc->mode);
+		intel_dp->DP |= DP_AUDIO_OUTPUT_ENABLE;
+	} else
+		return;
+	I915_WRITE(intel_dp->output_reg, intel_dp->DP);
+	POSTING_READ(intel_dp->output_reg);
+}
 
 /**
  * Uses CRT_HOTPLUG_EN and CRT_HOTPLUG_STAT to detect DP connection.
@@ -1968,20 +1990,23 @@ intel_dp_detect(struct drm_connector *co
 		      intel_dp->dpcd[6], intel_dp->dpcd[7]);
 
 	if (status != connector_status_connected)
-		return status;
+		goto out;
 
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
 
-	return connector_status_connected;
+	if (intel_dp->force_audio)
+		intel_dp->has_audio = intel_dp->force_audio > 0;
+out:
+	if (status != connector->status)
+		intel_dp_hotplug_audio(connector, status);
+
+	return status;
 }
 
 static int intel_dp_get_modes(struct drm_connector *connector)
--- linux.orig/drivers/gpu/drm/i915/intel_hdmi.c	2011-11-23 15:16:10.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_hdmi.c	2011-11-23 16:20:25.000000000 +0800
@@ -319,6 +319,34 @@ static bool intel_hdmi_mode_fixup(struct
 	return true;
 }
 
+static void intel_hdmi_hotplug_audio(struct drm_connector *connector,
+				     enum drm_connector_status status)
+{
+	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
+	struct drm_i915_private *dev_priv = connector->dev->dev_private;
+	struct drm_crtc *crtc = intel_hdmi->base.base.crtc;
+	u32 temp;
+
+	DRM_DEBUG_DRIVER("hotplug status %d crtc %p eld %#x\n",
+			 status, crtc, (unsigned int)connector->eld[0]);
+
+	if (status == connector_status_disconnected)
+		temp = I915_READ(intel_hdmi->sdvox_reg) & ~SDVO_AUDIO_ENABLE;
+	else if (status == connector_status_connected && crtc) {
+		/*
+		 * It's for bare metal X (eg. fluxbox) only, which may not call
+		 * ->mode_set on hot plug.  KMS console and full blown X (eg.
+		 * gnome desktop) will see NULL crtc at this time and call
+		 * ->mode_set to enable HDMI audio a bit later.
+		 */
+		intel_write_eld(&intel_hdmi->base.base, &crtc->mode);
+		temp = I915_READ(intel_hdmi->sdvox_reg) | SDVO_AUDIO_ENABLE;
+	} else
+		return;
+	I915_WRITE(intel_hdmi->sdvox_reg, temp);
+	POSTING_READ(intel_hdmi->sdvox_reg);
+}
+
 static enum drm_connector_status
 intel_hdmi_detect(struct drm_connector *connector, bool force)
 {
@@ -337,6 +365,7 @@ intel_hdmi_detect(struct drm_connector *
 			status = connector_status_connected;
 			intel_hdmi->has_hdmi_sink = drm_detect_hdmi_monitor(edid);
 			intel_hdmi->has_audio = drm_detect_monitor_audio(edid);
+			drm_edid_to_eld(connector, edid);
 		}
 		connector->display_info.raw_edid = NULL;
 		kfree(edid);
@@ -347,6 +376,9 @@ intel_hdmi_detect(struct drm_connector *
 			intel_hdmi->has_audio = intel_hdmi->force_audio > 0;
 	}
 
+	if (status != connector->status)
+		intel_hdmi_hotplug_audio(connector, status);
+
 	return status;
 }
 
--- linux.orig/drivers/gpu/drm/i915/intel_modes.c	2011-11-23 15:16:10.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_modes.c	2011-11-23 15:16:11.000000000 +0800
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
