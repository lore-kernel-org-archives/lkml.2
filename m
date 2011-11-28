Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1K1HlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:41:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:19748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1K1HlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:41:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,582,1315206000"; 
   d="scan'208";a="95944918"
Message-Id: <20111128074029.878450261@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 28 Nov 2011 15:33:41 +0800
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
Subject: [PATCH 4/4] drm/i915: HDMI hot remove notification to audio driver
References: <20111128073337.815008177@intel.com>
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


