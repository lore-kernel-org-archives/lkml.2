Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224Ab1KJL5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 06:57:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:26966 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab1KJL5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 06:57:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,488,1315206000"; 
   d="scan'208";a="72869888"
Date: Thu, 10 Nov 2011 19:57:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Keith Packard <keithp@keithp.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
Message-ID: <20111110115712.GA6492@localhost>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
 <20111108145510.GA5142@elliptictech.com>
 <CA+55aFwx5=T1piX5qPj2jCAbzdHAQX2gYJODZnQ40h9hiDjkbQ@mail.gmail.com>
 <s5hty6dlp5o.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <s5hty6dlp5o.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Nick,

On Wed, Nov 09, 2011 at 03:40:19PM +0800, Takashi Iwai wrote:
> At Tue, 8 Nov 2011 12:23:30 -0800,
> Linus Torvalds wrote:
> > 
> > Hmm, I don't know what caused this to trigger, but I'm adding both the
> > i915 people and the HDA people to the cc, and they can fight to the
> > death about this in the HDMI Thunderdome.
> 
> It must be the new addition of ELD-passing code.
> 
> Fengguang, can the drm or i915 driver check whether ELD is changed or
> not?  Writing ELD at each time even when unchanged confuses the audio
> side, as if the monitor is hotplugged.

The attached patch is tested OK to prevent extra hot plug events.

However it has one side effect: when HDMI monitor is hot removed,
the ELD keeps remain valid. I need to find a way to test for the
presence of the monitor and handle that case as well. When all done,
I'll submit the patches together for review.

Thanks,
Fengguang

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=no-extra-eld-passing

Subject: drm/i915: don't trigger hotplug events on unchanged ELD
Date: Thu Nov 10 17:48:49 CST 2011

The ELD may or may not change when switching the video mode.
If unchanged, don't trigger hot plug events to HDMI audio driver.

This avoids disturbing the user with repeated printks.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/intel_display.c |   51 ++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 5 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/intel_display.c	2011-11-10 17:23:04.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2011-11-10 17:59:25.000000000 +0800
@@ -5811,6 +5811,35 @@ static int intel_crtc_mode_set(struct dr
 	return ret;
 }
 
+static bool intel_eld_uptodate(struct drm_connector *connector,
+			       int reg_eldv, uint32_t bits_eldv,
+			       int reg_elda, uint32_t bits_elda,
+			       int reg_edid)
+{
+	struct drm_i915_private *dev_priv = connector->dev->dev_private;
+	uint8_t *eld = connector->eld;
+	uint32_t i;
+
+	i = I915_READ(reg_eldv);
+	i &= bits_eldv;
+
+	if (!eld[0])
+		return !i;
+
+	if (!i)
+		return false;
+
+	i = I915_READ(reg_elda);
+	i &= ~bits_elda;
+	I915_WRITE(reg_elda, i);
+
+	for (i = 0; i < eld[2]; i++)
+		if (I915_READ(reg_edid) != *((uint32_t *)eld + i))
+			return false;
+
+	return true;
+}
+
 static void g4x_write_eld(struct drm_connector *connector,
 			  struct drm_crtc *crtc)
 {
@@ -5827,6 +5856,12 @@ static void g4x_write_eld(struct drm_con
 	else
 		eldv = G4X_ELDV_DEVCTG;
 
+	if (intel_eld_uptodate(connector,
+			       G4X_AUD_CNTL_ST, eldv,
+			       G4X_AUD_CNTL_ST, G4X_ELD_ADDR,
+			       G4X_HDMIW_HDMIEDID))
+		return;
+
 	i = I915_READ(G4X_AUD_CNTL_ST);
 	i &= ~(eldv | G4X_ELD_ADDR);
 	len = (i >> 9) & 0x1f;		/* ELD buffer size */
@@ -5886,6 +5921,17 @@ static void ironlake_write_eld(struct dr
 		eldv = GEN5_ELD_VALIDB << ((i - 1) * 4);
 	}
 
+	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
+		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
+		eld[5] |= (1 << 2);	/* Conn_Type, 0x1 = DisplayPort */
+	}
+
+	if (intel_eld_uptodate(connector,
+			       aud_cntrl_st2, eldv,
+			       aud_cntl_st, GEN5_ELD_ADDRESS,
+			       hdmiw_hdmiedid))
+		return;
+
 	i = I915_READ(aud_cntrl_st2);
 	i &= ~eldv;
 	I915_WRITE(aud_cntrl_st2, i);
@@ -5893,11 +5939,6 @@ static void ironlake_write_eld(struct dr
 	if (!eld[0])
 		return;
 
-	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
-		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
-		eld[5] |= (1 << 2);	/* Conn_Type, 0x1 = DisplayPort */
-	}
-
 	i = I915_READ(aud_cntl_st);
 	i &= ~GEN5_ELD_ADDRESS;
 	I915_WRITE(aud_cntl_st, i);

--VS++wcV0S1rZb1Fb--
