Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab2HQOpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:45:12 -0400
Received: from mga05.intel.com ([192.55.52.89]:26101 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758066Ab2HQOpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <1344918891-6283-3-git-send-email-keithp@keithp.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com>
	<1344918891-6283-3-git-send-email-keithp@keithp.com>
Date: Fri, 17 Aug 2012 15:45:02 +0100
Message-ID: <CAPX-8+8euppecLhZu3XR95uM5e9m_kYmbJ6vmgBU=d03cs=RWA@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 2/7] drm/i915: FDI B/C share 4 lanes on Ivybridge
From: "Lespiau, Damien" <damien.lespiau@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 5:34 AM, Keith Packard <keithp@keithp.com> wrote:

@@ -3728,7 +3728,8 @@ static inline bool intel_panel_use_ssc(struct
drm_i915_private *dev_priv)
  */
 static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
                                         unsigned int *pipe_bpp,
-                                        struct drm_display_mode *mode)
+                                        struct drm_display_mode *mode,
+                                        int max_fdi_bpp)

There's some kernel-doc for this function, maybe add a @max_fdi_bpp there?


> @@ -3800,6 +3801,15 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
>                 display_bpc = 6;
>         }
>
> +       if (display_bpc * 3 > max_fdi_bpp) {
> +               if (max_fdi_bpp < 24)
> +                       display_bpc = 6;
> +               else if (max_fdi_bpp < 30)
> +                       display_bpc = 8;
> +               else if (max_fdi_bpp < 36)
> +                       display_bpc = 10;
> +               DRM_DEBUG_KMS("Dithering FDI to %dbpc\n", display_bpc);
> +       }

This chunk is being moved around in a later patch in the series,
merging the two patches in one looks like a good idea?


> +       /* If the other FDI link is using too many lanes, we can't have
> +        * any
> +        */
> +       if (other_intel_crtc->fdi_lanes > 2)
> +               return 0;
> +
> +       /* When both are running, we only get 2 lanes at most
> +        */
> +       return 2;
> +}

I guess this does not cover the case of pipe B using 3 lanes meaning
pipe C can use 1?

> @@ -4672,7 +4731,18 @@ static int ironlake_crtc_mode_set(struct drm_crtc *crtc,
>            according to current link config */
>         if (is_cpu_edp) {
>                 intel_edp_link_config(edp_encoder, &lane, &link_bw);
> +               max_fdi_bpp = 0;
> +               max_lane = lane;
>         } else {
> +               u32     fdi_bw;
> +
> +               /* [e]DP over FDI requires target mode clock
> +                  instead of link clock */
> +               if (is_dp)
> +                       target_clock = mode->clock;
> +               else
> +                       target_clock = adjusted_mode->clock;
> +

This duplicates the code just that is just a few lines away, instead
how about moving the logic to set target_clock up in front of this
whole if()?

>                 /* FDI is a binary signal running at ~2.7GHz, encoding
>                  * each output octet as 10 bits. The actual frequency
>                  * is stored as a divider into a 100MHz clock, and the
> @@ -4681,6 +4751,18 @@ static int ironlake_crtc_mode_set(struct drm_crtc *crtc,
>                  * is:
>                  */
>                 link_bw = intel_fdi_link_freq(dev) * MHz(100)/KHz(1)/10;
> +
> +               max_lane = 4;
> +               if (IS_IVYBRIDGE(dev))
> +                       max_lane = ivb_fdi_max_lanes(crtc);
> +
> +               /*
> +                * Compute the available FDI bandwidth, use that
> +                * to compute the maximum supported BPP
> +                */
> +               fdi_bw = link_bw * max_lane * 19 / 20;
> +               max_fdi_bpp = fdi_bw / target_clock;
> +               DRM_DEBUG_KMS("max lane %d yields max fdi bpp %d\n", max_lane, max_fdi_bpp);
>         }

This chunk is also reworked in a later commit in this series.

-- 
Damien
