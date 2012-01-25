Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab2AYWLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:11:03 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43904 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AYWLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:11:01 -0500
Date: Wed, 25 Jan 2012 23:11:00 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915: Select DP BPC at mode set,
 rather than mode validate
Message-ID: <20120125221100.GK3896@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Lubos Kolouch <lubos.kolouch@gmail.com>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com>
 <1327508186-26704-3-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
In-Reply-To: <1327508186-26704-3-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 08:16:26AM -0800, Keith Packard wrote:
> The DP configuration must match the pipe configuration, and until mode
> set we don't know what BPC will be used. Delay all decisions about BPC
> until mode set, computing the target BPC in both intel_dp_mode_fixup
> and either i9xx_crtc_mode_set or ironlake_crtc_mode_set. It might be
> slightly better to compute this only once, but storing the value
> between those two calls would be a pain.
> 
> Cc: Lubos Kolouch <lubos.kolouch@gmail.com>
> Cc: Adam Jackson <ajax@redhat.com>
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c |   27 +++++-------
>  drivers/gpu/drm/i915/intel_dp.c      |   77 +++++++++++++++++++++++++++-------
>  drivers/gpu/drm/i915/intel_drv.h     |    6 ++-
>  3 files changed, 78 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index b3b51c4..d613676 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -4850,9 +4850,9 @@ static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
>   * Dithering requirement (i.e. false if display bpc and pipe bpc match,
>   * true if they don't match).
>   */
> -static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
> -					 unsigned int *pipe_bpp,
> -					 struct drm_display_mode *mode)
> +bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
> +				  unsigned int *pipe_bpp,
> +				  struct drm_display_mode *mode)
>  {
>  	struct drm_device *dev = crtc->dev;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> @@ -4883,13 +4883,13 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
>  			continue;
>  		}
>  
> -		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
> -			/* Use VBT settings if we have an eDP panel */
> -			unsigned int edp_bpc = dev_priv->edp.bpp / 3;
> +		if (intel_encoder->type == INTEL_OUTPUT_EDP ||
> +		    intel_encoder->type == INTEL_OUTPUT_DISPLAYPORT) {
> +			unsigned int dp_bpc = intel_dp_max_bpp(&intel_encoder->base, mode);
>  
> -			if (edp_bpc < display_bpc) {
> -				DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n", display_bpc, edp_bpc);
> -				display_bpc = edp_bpc;
> +			if (dp_bpc < display_bpc) {
> +				DRM_DEBUG_KMS("clamping display bpc (was %d) to DP (%d)\n", display_bpc, dp_bpc);
> +				display_bpc = dp_bpc;
>  			}
>  			continue;
>  		}

I'm a bit unhappy how generic code in intel_display.c calls function out
of intel_dp.c. And choose_pipe_bpp_dither already has special cases for
quite a few other encoders ... Could we add an ->adjust_bpc function to
intel_encoder to separate this in a cleaner fashion?

I know that this isn't really the only layering violation in
intel_display.c, but functions in that file have an uncanny ability to
grow without bounds ;-)

> @@ -4923,11 +4923,6 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
>  		}
>  	}
>  
> -	if (mode->private_flags & INTEL_MODE_DP_FORCE_6BPC) {
> -		DRM_DEBUG_KMS("Dithering DP to 6bpc\n");
> -		display_bpc = 6;
> -	}
> -
>  	/*
>  	 * We could just drive the pipe at the highest bpc all the time and
>  	 * enable dithering as needed, but that costs bandwidth.  So choose
> @@ -4990,6 +4985,7 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
>  	int ret;
>  	u32 temp;
>  	u32 lvds_sync = 0;
> +	int dp_max_bpp = 0;
>  
>  	list_for_each_entry(encoder, &mode_config->encoder_list, base.head) {
>  		if (encoder->base.crtc != crtc)
> @@ -5016,6 +5012,7 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
>  			break;
>  		case INTEL_OUTPUT_DISPLAYPORT:
>  			is_dp = true;
> +			dp_max_bpp = intel_dp_max_bpp(&encoder->base, mode);
>  			break;
>  		}
>  
> @@ -5192,7 +5189,7 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
>  	/* default to 8bpc */
>  	pipeconf &= ~(PIPECONF_BPP_MASK | PIPECONF_DITHER_EN);
>  	if (is_dp) {
> -		if (mode->private_flags & INTEL_MODE_DP_FORCE_6BPC) {
> +		if (dp_max_bpp <= 18) {
>  			pipeconf |= PIPECONF_BPP_6 |
>  				    PIPECONF_DITHER_EN |
>  				    PIPECONF_DITHER_TYPE_SP;
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 94f860c..2482796 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -219,14 +219,51 @@ intel_dp_max_data_rate(int max_link_clock, int max_lanes)
>  	return (max_link_clock * max_lanes * 8) / 10;
>  }
>  
> +/*
> + * For the specified encoder, return the maximum bpp that can be used
> + * for the specified mode.
> + */
> +
> +static const int dp_supported_bpc[] = { 6, 8, 10, 12, 16 };
> +
> +#define NUM_DP_SUPPORTED_BPC (sizeof dp_supported_bpc/sizeof dp_supported_bpc[0])
> +
> +int
> +intel_dp_max_bpp(struct drm_encoder *encoder, struct drm_display_mode *mode)
> +{
> +	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
> +	int max_link_clock = intel_dp_link_clock(intel_dp_max_link_bw(intel_dp));
> +	int max_lanes = intel_dp_max_lane_count(intel_dp);
> +	int max_rate, mode_rate;
> +	int i;
> +
> +	max_rate = intel_dp_max_data_rate(max_link_clock, max_lanes);
> +	for (i = NUM_DP_SUPPORTED_BPC - 1; i >= 0; i--) {
> +		int bpp = dp_supported_bpc[i] * 3;	/* 3 channels of data (RGB) */
> +
> +		mode_rate = intel_dp_link_required(mode->clock, bpp);
> +		if (mode_rate <= max_rate) {
> +
> +			/* Limit EDP bpp to panel ability */
> +			if (intel_dp->base.type == INTEL_OUTPUT_EDP) {
> +				struct drm_device *dev = encoder->dev;
> +				struct drm_i915_private *dev_priv = dev->dev_private;
> +				int edp_bpp = dev_priv->edp.bpp;
> +
> +				if (bpp > edp_bpp)
> +					bpp = edp_bpp;
> +			}
> +			return bpp;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int
>  intel_dp_mode_valid(struct drm_connector *connector,
>  		    struct drm_display_mode *mode)
>  {
>  	struct intel_dp *intel_dp = intel_attached_dp(connector);
> -	int max_link_clock = intel_dp_link_clock(intel_dp_max_link_bw(intel_dp));
> -	int max_lanes = intel_dp_max_lane_count(intel_dp);
> -	int max_rate, mode_rate;
>  
>  	if (is_edp(intel_dp) && intel_dp->panel_fixed_mode) {
>  		if (mode->hdisplay > intel_dp->panel_fixed_mode->hdisplay)
> @@ -236,16 +273,8 @@ intel_dp_mode_valid(struct drm_connector *connector,
>  			return MODE_PANEL;
>  	}
>  
> -	mode_rate = intel_dp_link_required(mode->clock, 24);
> -	max_rate = intel_dp_max_data_rate(max_link_clock, max_lanes);
> -
> -	if (mode_rate > max_rate) {
> -			mode_rate = intel_dp_link_required(mode->clock, 18);
> -			if (mode_rate > max_rate)
> -				return MODE_CLOCK_HIGH;
> -			else
> -				mode->private_flags |= INTEL_MODE_DP_FORCE_6BPC;
> -	}
> +	if (intel_dp_max_bpp(&intel_dp->base.base, mode) == 0)
> +		return MODE_CLOCK_HIGH;
>  
>  	if (mode->clock < 10000)
>  		return MODE_CLOCK_LOW;
> @@ -673,9 +702,26 @@ intel_dp_mode_fixup(struct drm_encoder *encoder, struct drm_display_mode *mode,
>  	int lane_count, clock;
>  	int max_lane_count = intel_dp_max_lane_count(intel_dp);
>  	int max_clock = intel_dp_max_link_bw(intel_dp) == DP_LINK_BW_2_7 ? 1 : 0;
> -	int bpp = mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 24;
> +	unsigned int bpp;
>  	static int bws[2] = { DP_LINK_BW_1_62, DP_LINK_BW_2_7 };
>  
> +	if (HAS_PCH_SPLIT(dev))
> +		(void) intel_choose_pipe_bpp_dither(intel_dp->base.base.crtc, &bpp, mode);
> +	else {
> +		bpp = intel_dp_max_bpp(encoder, mode);
> +		if (bpp > 24)
> +			bpp = 24;
> +	}

As you've already said in another mail, this PCH_SPLIT here looks a bit
strange. Could we unify these two paths here a bit?

Otherwise I couldn't poke holes into it.
-Daniel

> +
> +	DRM_DEBUG_KMS("encoder assuming bpp %d (bpc %d)\n",
> +		      bpp, bpp / 3);
> +
> +	if (bpp == 0) {
> +		DRM_DEBUG_KMS("Display port cannot support requested clock %d\n",
> +			      mode->clock);
> +		return false;
> +	}
> +
>  	if (is_edp(intel_dp) && intel_dp->panel_fixed_mode) {
>  		intel_fixed_panel_mode(intel_dp->panel_fixed_mode, adjusted_mode);
>  		intel_pch_panel_fitting(dev, DRM_MODE_SCALE_FULLSCREEN,
> @@ -691,8 +737,7 @@ intel_dp_mode_fixup(struct drm_encoder *encoder, struct drm_display_mode *mode,
>  		for (clock = 0; clock <= max_clock; clock++) {
>  			int link_avail = intel_dp_max_data_rate(intel_dp_link_clock(bws[clock]), lane_count);
>  
> -			if (intel_dp_link_required(mode->clock, bpp)
> -					<= link_avail) {
> +			if (intel_dp_link_required(mode->clock, bpp) <= link_avail) {
>  				intel_dp->link_bw = bws[clock];
>  				intel_dp->lane_count = lane_count;
>  				adjusted_mode->clock = intel_dp_link_clock(intel_dp->link_bw);
> diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
> index 1348705..03b4595 100644
> --- a/drivers/gpu/drm/i915/intel_drv.h
> +++ b/drivers/gpu/drm/i915/intel_drv.h
> @@ -104,7 +104,6 @@
>  /* drm_display_mode->private_flags */
>  #define INTEL_MODE_PIXEL_MULTIPLIER_SHIFT (0x0)
>  #define INTEL_MODE_PIXEL_MULTIPLIER_MASK (0xf << INTEL_MODE_PIXEL_MULTIPLIER_SHIFT)
> -#define INTEL_MODE_DP_FORCE_6BPC (0x10)
>  
>  static inline void
>  intel_mode_set_pixel_multiplier(struct drm_display_mode *mode,
> @@ -303,11 +302,16 @@ extern void intel_dp_init(struct drm_device *dev, int dp_reg);
>  void
>  intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
>  		 struct drm_display_mode *adjusted_mode);
> +extern int intel_dp_max_bpp(struct drm_encoder *encoder, struct drm_display_mode *mode);
>  extern bool intel_dpd_is_edp(struct drm_device *dev);
>  extern void intel_edp_link_config(struct intel_encoder *, int *, int *);
>  extern bool intel_encoder_is_pch_edp(struct drm_encoder *encoder);
>  extern int intel_plane_init(struct drm_device *dev, enum pipe pipe);
>  
> +bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
> +				  unsigned int *pipe_bpp,
> +				  struct drm_display_mode *mode);
> +
>  /* intel_panel.c */
>  extern void intel_fixed_panel_mode(struct drm_display_mode *fixed_mode,
>  				   struct drm_display_mode *adjusted_mode);
> -- 
> 1.7.8.3
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
