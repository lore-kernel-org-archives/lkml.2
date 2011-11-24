Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab1KXJio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:38:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:5315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab1KXJib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:38:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="79490004"
Date: Thu, 24 Nov 2011 17:38:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] drm/i915: hot plug/unplug notification to HDMI
 audio driver
Message-ID: <20111124093826.GA27836@localhost>
References: <20111121063749.GA23450@localhost>
 <86hb1xife8.fsf@sumi.keithp.com>
 <20111122074055.GA21560@localhost>
 <86sjlgf20l.fsf@sumi.keithp.com>
 <20111123082958.GA4209@localhost>
 <86fwheej2e.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fwheej2e.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 03:26:49AM +0800, Keith Packard wrote:
> On Wed, 23 Nov 2011 16:29:58 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > What I need is a hot plug hook that knows whether the monitor is
> > plugged or removed, which is only possible if the hook is called
> > after ->detect().
> 
> That would be mode_set to tell you that the monitor is in use, and the
> disable function to tell you when the monitor is no longer in use.
> 
> You do not want to do anything to the hardware in the hot_plug paths;
> those are strictly informative; telling user space which connectors are
> present.

Thanks a lot for the tips! When doing things in the right path, I got
a much reduced patch :-)

Due to DP being a bit more tricky than HDMI and no convenient DP test
environment, I'll have to delay the DP part to next week...

Thanks,
Fengguang
---
Subject: drm/i915: HDMI hot remove notification to audio driver
Date: Fri Nov 11 13:49:04 CST 2011

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
