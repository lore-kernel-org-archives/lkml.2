Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2HQO7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:59:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:3385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab2HQO7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <1344918891-6283-5-git-send-email-keithp@keithp.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com>
	<1344918891-6283-5-git-send-email-keithp@keithp.com>
Date: Fri, 17 Aug 2012 15:58:57 +0100
Message-ID: <CAPX-8+-fcLQB_48DjL8UN5j3_brH8JHOJXFc4MgOwwHBrsw_Mg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 4/7] drm/i915: Check display_bpc against
 max_fdi_bpp after display_bpc is set
From: "Lespiau, Damien" <damien.lespiau@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 5:34 AM, Keith Packard <keithp@keithp.com> wrote:
> @@ -3845,8 +3836,20 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
>
>         display_bpc = min(display_bpc, bpc);
>
> -       DRM_DEBUG_KMS("setting pipe bpc to %d (max display bpc %d)\n",
> -                     bpc, display_bpc);
> +       display_bpc = 6;

It seems that you are overriding display_bpc unconditionally here,
some left over from debugging?

> +       if (display_bpc * 3 > max_fdi_bpp) {
> +               if (max_fdi_bpp < 24)
> +                       display_bpc = 6;
> +               else if (max_fdi_bpp < 30)
> +                       display_bpc = 8;
> +               else if (max_fdi_bpp < 36)
> +                       display_bpc = 10;
> +               DRM_DEBUG_KMS("Dithering FDI to %dbpc\n", display_bpc);
> +       }
> +
> +       DRM_DEBUG_KMS("setting pipe bpc to %d (max display bpc %d) (max_fdi_bpp %d)\n",
> +                     bpc, display_bpc, max_fdi_bpp);
>
>         *pipe_bpp = display_bpc * 3;

"setting pipe bpc to %d", bpc and  *pipe_bpp = display_bpc, looks like
a bogus debug message to me.

> @@ -4763,9 +4765,12 @@ static int ironlake_crtc_mode_set(struct drm_crtc *crtc,
>                  * Compute the available FDI bandwidth, use that
>                  * to compute the maximum supported BPP
>                  */
> -               fdi_bw = link_bw * max_lane * 19 / 20;
> -               max_fdi_bpp = fdi_bw / target_clock;
> -               DRM_DEBUG_KMS("max lane %d yields max fdi bpp %d\n", max_lane, max_fdi_bpp);
> +               fdi_bw = (link_bw * 8) * max_lane;
> +               pps = target_clock * 21 / 20;
> +
> +               max_fdi_bpp = fdi_bw / pps;
> +               DRM_DEBUG_KMS("link_bw %d max_lane %d fdi_bw %u pps %u max_fdi_bpp %d\n",
> +                             link_bw, max_lane, fdi_bw, pps, max_fdi_bpp);
>         }

While I understood the first computation of max_fdi_bpp in patch 2 of
this series, I have to confess you lost me there. Would you mind
clarifying this?

-- 
Damien
