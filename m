Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab2APXIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:08:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:50817 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2APXIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:08:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96500460"
Date: Tue, 17 Jan 2012 07:08:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Takashi Iwai <tiwai@suse.de>,
        "intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Lemaire <rlemaire@suse.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: set AUD_CONFIG N_value_index for
 DisplayPort
Message-ID: <20120116230809.GA7837@localhost>
References: <20120109131717.GA4713@localhost>
 <86y5tgx02g.fsf@sumi.keithp.com>
 <20120110054519.GA27257@localhost>
 <86ty404yhd.fsf@sumi.keithp.com>
 <20120116080252.GA18538@localhost>
 <20120116202618.GG3627@phenom.ffwll.local>
 <86obu31io4.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86obu31io4.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:44:43PM -0800, Keith Packard wrote:
> On Mon, 16 Jan 2012 21:26:18 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > Keith, does this address your concern and this patch is r-b: Keith or do
> > we want an
> > 
> > } else {
> > 	I915_WRITE(aud_config, 0);
> > }
> > 
> > for paranoia?
> 
> I think we want this added, just to be sure we set the configuration
> correctly in all cases; it's easy to imagine moving from DP to HDMI and
> leaving this bit set.

Ah good point! Here is the updated patch.

---
Subject: drm/i915: set AUD_CONFIG N_value_index for DisplayPort
Date: Fri Jan 06 14:41:31 CST 2012

It should be programmed to "0" for HDMI or "1" for DisplayPort.

This enables DisplayPort audio for

- HP EliteBook 8460p
  (whose BIOS does not set the N_value_index bit for us)

- DisplayPort monitor hot plugged after boot
  (otherwise most BIOS will fill the N_value_index bit for us)

Tested-by: Robert Lemaire <rlemaire@suse.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |   12 ++++++++++++
 drivers/gpu/drm/i915/intel_display.c |    8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

--- linux.orig/drivers/gpu/drm/i915/i915_reg.h	2012-01-07 23:11:10.000000000 +0800
+++ linux/drivers/gpu/drm/i915/i915_reg.h	2012-01-10 13:20:17.000000000 +0800
@@ -3582,4 +3582,16 @@
 #define CPT_AUD_CNTL_ST_A		0xE50B4
 #define CPT_AUD_CNTRL_ST2		0xE50C0
 
+#define IBX_AUD_CONFIG_A			0xe2000
+#define CPT_AUD_CONFIG_A			0xe5000
+#define   AUD_CONFIG_N_VALUE_INDEX		(1 << 29)
+#define   AUD_CONFIG_N_PROG_ENABLE		(1 << 28)
+#define   AUD_CONFIG_UPPER_N_SHIFT		20
+#define   AUD_CONFIG_UPPER_N_VALUE		(0xff << 20)
+#define   AUD_CONFIG_LOWER_N_SHIFT		4
+#define   AUD_CONFIG_LOWER_N_VALUE		(0xfff << 4)
+#define   AUD_CONFIG_PIXEL_CLOCK_HDMI_SHIFT	16
+#define   AUD_CONFIG_PIXEL_CLOCK_HDMI		(0xf << 16)
+#define   AUD_CONFIG_DISABLE_NCTS		(1 << 3)
+
 #endif /* _I915_REG_H_ */
--- linux.orig/drivers/gpu/drm/i915/intel_display.c	2012-01-07 23:11:10.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2012-01-17 07:06:29.000000000 +0800
@@ -5908,15 +5908,18 @@ static void ironlake_write_eld(struct dr
 	uint32_t i;
 	int len;
 	int hdmiw_hdmiedid;
+	int aud_config;
 	int aud_cntl_st;
 	int aud_cntrl_st2;
 
 	if (HAS_PCH_IBX(connector->dev)) {
 		hdmiw_hdmiedid = IBX_HDMIW_HDMIEDID_A;
+		aud_config = IBX_AUD_CONFIG_A;
 		aud_cntl_st = IBX_AUD_CNTL_ST_A;
 		aud_cntrl_st2 = IBX_AUD_CNTL_ST2;
 	} else {
 		hdmiw_hdmiedid = CPT_HDMIW_HDMIEDID_A;
+		aud_config = CPT_AUD_CONFIG_A;
 		aud_cntl_st = CPT_AUD_CNTL_ST_A;
 		aud_cntrl_st2 = CPT_AUD_CNTRL_ST2;
 	}
@@ -5924,6 +5927,7 @@ static void ironlake_write_eld(struct dr
 	i = to_intel_crtc(crtc)->pipe;
 	hdmiw_hdmiedid += i * 0x100;
 	aud_cntl_st += i * 0x100;
+	aud_config += i * 0x100;
 
 	DRM_DEBUG_DRIVER("ELD on pipe %c\n", pipe_name(i));
 
@@ -5943,7 +5947,9 @@ static void ironlake_write_eld(struct dr
 	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
 		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
 		eld[5] |= (1 << 2);	/* Conn_Type, 0x1 = DisplayPort */
-	}
+		I915_WRITE(aud_config, AUD_CONFIG_N_VALUE_INDEX); /* 0x1 = DP */
+	} else
+		I915_WRITE(aud_config, 0);
 
 	if (intel_eld_uptodate(connector,
 			       aud_cntrl_st2, eldv,
