Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935732Ab2JYTZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:25:01 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35224 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab2JYTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:24:59 -0400
Date: Thu, 25 Oct 2012 21:26:01 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Yuly Novikov <ynovikov@chromium.org>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH] drm/i915/dp: allow configuring eDP panel fitting scaling
 mode
Message-ID: <20121025192601.GF5691@phenom.ffwll.local>
Mail-Followup-To: Yuly Novikov <ynovikov@chromium.org>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>
References: <1351187867-21401-1-git-send-email-ynovikov@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351187867-21401-1-git-send-email-ynovikov@chromium.org>
X-Operating-System: Linux phenom 3.6.0-rc7+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:57:47PM -0400, Yuly Novikov wrote:
> LVDS allowed changing panel fitting scaling mode, while eDP didn't.
> Copied relevant code from LVDS to eDP.
> This also changes default mode on eDP to ascpect ratio preserving scaling.
> 
> Signed-off-by: Yuly Novikov <ynovikov@chromium.org>

Jani from our team is working on unifying a bunch of things between lvds
and eDP, some of them already merged into drm-intel-next-queued branch.
Jani, can you please take a look?

Thanks, Daniel

> ---
>  drivers/gpu/drm/i915/intel_dp.c  |   33 ++++++++++++++++++++++++++++++---
>  drivers/gpu/drm/i915/intel_drv.h |    1 +
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 368ed8e..a65546e 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -685,7 +685,7 @@ intel_dp_mode_fixup(struct drm_encoder *encoder,
>  
>  	if (is_edp(intel_dp) && intel_dp->panel_fixed_mode) {
>  		intel_fixed_panel_mode(intel_dp->panel_fixed_mode, adjusted_mode);
> -		intel_pch_panel_fitting(dev, DRM_MODE_SCALE_FULLSCREEN,
> +		intel_pch_panel_fitting(dev, intel_dp->fitting_mode,
>  					mode, adjusted_mode);
>  	}
>  
> @@ -2358,6 +2358,22 @@ intel_dp_set_property(struct drm_connector *connector,
>  		goto done;
>  	}
>  
> +	if (is_edp(intel_dp) &&
> +		property == connector->dev->mode_config.scaling_mode_property) {
> +		if (val == DRM_MODE_SCALE_NONE) {
> +			DRM_DEBUG_KMS("no scaling not supported\n");
> +			return -EINVAL;
> +		}
> +
> +		if (intel_dp->fitting_mode == val) {
> +			/* the eDP scaling property is not changed */
> +			return 0;
> +		}
> +		intel_dp->fitting_mode = val;
> +
> +		goto done;
> +	}
> +
>  	return -EINVAL;
>  
>  done:
> @@ -2469,10 +2485,21 @@ bool intel_dpd_is_edp(struct drm_device *dev)
>  }
>  
>  static void
> -intel_dp_add_properties(struct intel_dp *intel_dp, struct drm_connector *connector)
> +intel_dp_add_properties(struct drm_device *dev,
> +			struct intel_dp *intel_dp,
> +			struct drm_connector *connector)
>  {
>  	intel_attach_force_audio_property(connector);
>  	intel_attach_broadcast_rgb_property(connector);
> +
> +	if (is_edp(intel_dp)) {
> +		drm_mode_create_scaling_mode_property(dev);
> +		drm_connector_attach_property(
> +			connector,
> +			dev->mode_config.scaling_mode_property,
> +			DRM_MODE_SCALE_ASPECT);
> +		intel_dp->fitting_mode = DRM_MODE_SCALE_ASPECT;
> +	}
>  }
>  
>  void
> @@ -2665,7 +2692,7 @@ intel_dp_init(struct drm_device *dev, int output_reg, enum port port)
>  		intel_panel_setup_backlight(dev);
>  	}
>  
> -	intel_dp_add_properties(intel_dp, connector);
> +	intel_dp_add_properties(dev, intel_dp, connector);
>  
>  	/* For G4X desktop chip, PEG_BAND_GAP_DATA 3:0 must first be written
>  	 * 0xd.  Failure to do so will result in spurious interrupts being
> diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
> index fe71425..da50cd4 100644
> --- a/drivers/gpu/drm/i915/intel_drv.h
> +++ b/drivers/gpu/drm/i915/intel_drv.h
> @@ -358,6 +358,7 @@ struct intel_dp {
>  	int backlight_on_delay;
>  	int backlight_off_delay;
>  	struct drm_display_mode *panel_fixed_mode;  /* for eDP */
> +	int fitting_mode;  /* for eDP */
>  	struct delayed_work panel_vdd_work;
>  	bool want_panel_vdd;
>  	struct edid *edid; /* cached EDID for eDP */
> -- 
> 1.7.7.3
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
