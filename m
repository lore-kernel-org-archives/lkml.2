Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2FMQYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:24:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43828 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2FMQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:24:14 -0400
Date: Wed, 13 Jun 2012 18:25:44 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: i915: lvds panel always blank when booted with lid closed
Message-ID: <20120613162544.GJ4829@phenom.ffwll.local>
Mail-Followup-To: dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20120613143600.GD3490@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613143600.GD3490@thinkpad-t410>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:36:00AM -0500, Seth Forshee wrote:
> When I boot my Thinkpad T410 in a docking station with the lid closed,
> the lvds panel remains blank even when this output is active. This
> happens up to and including 3.5-rc2.
> 
> I've determined that this happens because lvds isn't being initialized
> by the bios when I boot this way, and booting with lvds_channel_mode=2
> fixes the issue. I see that there's logic in is_dual_link_lvds()
> intended to detect this situation, but it's failing because the T410 has
> the LVDS_PIPEB_SELECT bit set. The simple patch below fixes my machine
> by masking off this bit when determining whether or not lvds was
> initialized by the bios.
> 
> I'm not sure though whether or not it's correct to expect that this bit
> might be set when lvds hasn't been initialized. The alternative seems to
> be quirking this machine as is done for some Macbooks. What is the
> correct solution?

Patch looks correct, but can you please change the mask from PIPEB to the
already exsting LVDS_PIPE_MASK? This way it's clearer what's going on.

Thanks, Daniel
> 
> Thanks,
> Seth
> 
> 
> From 250904ac95cda7630cdd8339724e3c8feceeb586 Mon Sep 17 00:00:00 2001
> From: Seth Forshee <seth.forshee@canonical.com>
> Date: Tue, 12 Jun 2012 16:52:14 -0500
> Subject: [PATCH] drm/i915: ignore LVDS_PIPEB_SELECT when checking for LVDS
>  register initialization
> 
> The Lenovo Thinkpad T410 has this bit set in the LVDS register when
> booted with the lid closed, even though the LVDS hasn't really been
> initialized. Ignore this bit so that the VBT value will be used instead.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index e0aa064..f81f249 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -434,7 +434,7 @@ static bool is_dual_link_lvds(struct drm_i915_private *dev_priv,
>  		 * register is uninitialized.
>  		 */
>  		val = I915_READ(reg);
> -		if (!(val & ~LVDS_DETECTED))
> +		if (!(val & ~(LVDS_PIPEB_SELECT | LVDS_DETECTED)))
>  			val = dev_priv->bios_lvds_val;
>  		dev_priv->lvds_val = val;
>  	}
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
