Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1LINBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:01:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:34808 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab1LIM76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:59:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83996291"
Message-Id: <20111209124556.111025822@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Dec 2011 20:42:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>, Wang Zhenyu <zhenyu.z.wang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Pierre-louis Bossart " <pierre-louis.bossart@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] drm/i915: HDMI hot remove notification to audio driver
References: <20111209124216.701131933@intel.com>
Content-Disposition: inline; filename=eld-hot-disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On HDMI monitor hot remove, clear SDVO_AUDIO_ENABLE accordingly, so that
the audio driver will receive hot plug events and take action to refresh
its device state and ELD contents.

The cleared SDVO_AUDIO_ENABLE bit needs to be restored to prevent losing
HDMI audio after DPMS on.

CC: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_dp.c   |    4 +++-
 drivers/gpu/drm/i915/intel_hdmi.c |    8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/intel_hdmi.c	2011-11-24 17:11:38.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_hdmi.c	2011-11-24 17:15:03.000000000 +0800
@@ -269,6 +269,10 @@ static void intel_hdmi_dpms(struct drm_e
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_hdmi *intel_hdmi = enc_to_intel_hdmi(encoder);
 	u32 temp;
+	u32 enable_bits = SDVO_ENABLE;
+
+	if (intel_hdmi->has_audio)
+		enable_bits |= SDVO_AUDIO_ENABLE;
 
 	temp = I915_READ(intel_hdmi->sdvox_reg);
 
@@ -281,9 +285,9 @@ static void intel_hdmi_dpms(struct drm_e
 	}
 
 	if (mode != DRM_MODE_DPMS_ON) {
-		temp &= ~SDVO_ENABLE;
+		temp &= ~enable_bits;
 	} else {
-		temp |= SDVO_ENABLE;
+		temp |= enable_bits;
 	}
 
 	I915_WRITE(intel_hdmi->sdvox_reg, temp);


