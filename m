Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab1I3Sq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:46:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55684 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1I3Sq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:46:26 -0400
Date: Fri, 30 Sep 2011 20:47:00 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 18/21] drm/i915: Disable eDP VDD in a delayed work proc
 instead of synchronously
Message-ID: <20110930184700.GV2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-19-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-19-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:50PM -0700, Keith Packard wrote:
> There's no good reason to turn off the eDP force VDD bit synchronously
> while probing devices; that just sticks a huge delay into all mode
> setting paths. Instead, queue a delayed work proc to disable the VDD
> force bit and then remember when that fires to ensure that the
> appropriate delay is respected before trying to turn it back on.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |  121 +++++++++++++++++++++++++++++++--------
>  1 files changed, 97 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index c7ccb46..08817b0 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -62,6 +62,9 @@ struct intel_dp {
>  	int panel_power_up_delay;
>  	int panel_power_down_delay;
>  	struct drm_display_mode *panel_fixed_mode;  /* for eDP */
> +	struct delayed_work panel_vdd_work;
> +	bool want_panel_vdd;
> +	unsigned long panel_off_jiffies;
>  };
>  
>  /**
> @@ -611,7 +614,7 @@ intel_dp_i2c_aux_ch(struct i2c_adapter *adapter, int mode,
>  }
>  
>  static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp);
> -static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp);
> +static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp, bool sync);
>  
>  static int
>  intel_dp_i2c_init(struct intel_dp *intel_dp,
> @@ -634,7 +637,7 @@ intel_dp_i2c_init(struct intel_dp *intel_dp,
>  
>  	ironlake_edp_panel_vdd_on(intel_dp);
>  	ret = i2c_dp_aux_add_bus(&intel_dp->adapter);
> -	ironlake_edp_panel_vdd_off(intel_dp);
> +	ironlake_edp_panel_vdd_off(intel_dp, false);
>  	return ret;
>  }
>  
> @@ -848,6 +851,23 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
>  	}
>  }
>  
> +static void ironlake_wait_panel_off(struct intel_dp *intel_dp)
> +{
> +	unsigned long	off_time;
> +	unsigned long	delay;
> +	DRM_DEBUG_KMS("Wait for panel power off time\n");
> +	off_time = intel_dp->panel_off_jiffies + msecs_to_jiffies(intel_dp->panel_power_down_delay);
> +	if (time_after(jiffies, off_time)) {
> +		DRM_DEBUG_KMS("Time already passed");
> +		return;
> +	}
> +	delay = jiffies_to_msecs(off_time - jiffies);
> +	if (delay > intel_dp->panel_power_down_delay)
> +		delay = intel_dp->panel_power_down_delay;
> +	DRM_DEBUG_KMS("Waiting an additional %ld ms\n", delay);
> +	msleep(delay);
> +}

A cancel_work might be good here, not point in waking up the cpu for no
reason. And can you add "panel off timer: " to the deboug output?

> +
>  static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
>  {
>  	struct drm_device *dev = intel_dp->base.base.dev;
> @@ -858,6 +878,16 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
>  		return;
>  	DRM_DEBUG_KMS("Turn eDP VDD on\n");
>  
> +	WARN(intel_dp->want_panel_vdd,
> +	     "eDP VDD already requested on\n");
> +
> +	intel_dp->want_panel_vdd = true;
> +	if (ironlake_edp_have_panel_vdd(intel_dp)) {
> +		DRM_DEBUG_KMS("eDP VDD already on\n");
> +		return;
> +	}
> +
> +	ironlake_wait_panel_off(intel_dp);
>  	pp = I915_READ(PCH_PP_CONTROL);
>  	pp &= ~PANEL_UNLOCK_MASK;
>  	pp |= PANEL_UNLOCK_REGS;
> @@ -871,31 +901,64 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
>  	 * If the panel wasn't on, delay before accessing aux channel
>  	 */
>  	if (!ironlake_edp_have_panel_power(intel_dp)) {
> +		DRM_DEBUG_KMS("eDP was not running\n");
>  		msleep(intel_dp->panel_power_up_delay);
> -		DRM_DEBUG_KMS("eDP VDD was not on\n");
>  	}
>  }
>  
> -static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
> +static void ironlake_panel_vdd_off_sync(struct intel_dp *intel_dp)
>  {
>  	struct drm_device *dev = intel_dp->base.base.dev;
>  	struct drm_i915_private *dev_priv = dev->dev_private;
>  	u32 pp;
>  
> +	if (!intel_dp->want_panel_vdd && ironlake_edp_have_panel_vdd(intel_dp)) {
> +		pp = I915_READ(PCH_PP_CONTROL);
> +		pp &= ~PANEL_UNLOCK_MASK;
> +		pp |= PANEL_UNLOCK_REGS;
> +		pp &= ~EDP_FORCE_VDD;
> +		I915_WRITE(PCH_PP_CONTROL, pp);
> +		POSTING_READ(PCH_PP_CONTROL);
> +
> +		/* Make sure sequencer is idle before allowing subsequent activity */
> +		DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
> +			      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
> +		intel_dp->panel_off_jiffies = jiffies;
> +	}
> +}
> +
> +static void ironlake_panel_vdd_work(struct work_struct *__work)
> +{
> +	struct intel_dp *intel_dp = container_of(to_delayed_work(__work),
> +						 struct intel_dp, panel_vdd_work);
> +	struct drm_device *dev = intel_dp->base.base.dev;
> +
> +	mutex_lock(&dev->struct_mutex);
> +	ironlake_panel_vdd_off_sync(intel_dp);
> +	mutex_unlock(&dev->struct_mutex);
> +}

Like Chris already mentioned, s/struct_mutex/mode_config.mutex/ Maybe also
move the intel_dp->want_panel_vdd check in here - we need it only here to
avoid a race with vdd_on. I've almost overlooked it and already started to
write the complaint about the race ;-)

> +
> +static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp, bool sync)
> +{
>  	if (!is_edp(intel_dp))
>  		return;
> -	DRM_DEBUG_KMS("Turn eDP VDD off\n");
> -	pp = I915_READ(PCH_PP_CONTROL);
> -	pp &= ~PANEL_UNLOCK_MASK;
> -	pp |= PANEL_UNLOCK_REGS;
> -	pp &= ~EDP_FORCE_VDD;
> -	I915_WRITE(PCH_PP_CONTROL, pp);
> -	POSTING_READ(PCH_PP_CONTROL);
>  
> -	/* Make sure sequencer is idle before allowing subsequent activity */
> -	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
> -		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
> -	msleep(intel_dp->panel_power_down_delay);
> +	DRM_DEBUG_KMS("Turn eDP VDD off %d\n", intel_dp->want_panel_vdd);
> +	WARN(!intel_dp->want_panel_vdd, "eDP VDD not forced on");
> +	
> +	intel_dp->want_panel_vdd = false;
> +
> +	if (sync) {
> +		ironlake_panel_vdd_off_sync(intel_dp);
> +	} else {
> +		/*
> +		 * Queue the timer to fire a long
> +		 * time from now (relative to the power down delay)
> +		 * to keep the panel power up across a sequence of operations
> +		 */
> +		schedule_delayed_work(&intel_dp->panel_vdd_work,
> +				      msecs_to_jiffies(intel_dp->panel_power_down_delay * 5));
> +	}
>  }
>  
>  /* Returns true if the panel was already on when called */
> @@ -908,6 +971,7 @@ static void ironlake_edp_panel_on (struct intel_dp *intel_dp)
>  	if (ironlake_edp_have_panel_power(intel_dp))
>  		return;
>  
> +	ironlake_wait_panel_off(intel_dp);
>  	pp = I915_READ(PCH_PP_CONTROL);
>  	pp &= ~PANEL_UNLOCK_MASK;
>  	pp |= PANEL_UNLOCK_REGS;
> @@ -951,7 +1015,6 @@ static void ironlake_edp_panel_off(struct drm_encoder *encoder)
>  	pp &= ~POWER_TARGET_ON;
>  	I915_WRITE(PCH_PP_CONTROL, pp);
>  	POSTING_READ(PCH_PP_CONTROL);
> -	msleep(intel_dp->panel_power_down_delay);
>  
>  	if (wait_for((I915_READ(PCH_PP_STATUS) & idle_off_mask) == 0, 5000))
>  		DRM_ERROR("panel off wait timed out: 0x%08x\n",
> @@ -960,6 +1023,7 @@ static void ironlake_edp_panel_off(struct drm_encoder *encoder)
>  	pp |= PANEL_POWER_RESET; /* restore panel reset bit */
>  	I915_WRITE(PCH_PP_CONTROL, pp);
>  	POSTING_READ(PCH_PP_CONTROL);
> +	intel_dp->panel_off_jiffies = jiffies;
>  }
>  
>  static void ironlake_edp_backlight_on (struct drm_device *dev)
> @@ -1053,7 +1117,7 @@ static void intel_dp_prepare(struct drm_encoder *encoder)
>  	/* Wake up the sink first */
>  	ironlake_edp_panel_vdd_on(intel_dp);
>  	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
> -	ironlake_edp_panel_vdd_off(intel_dp);
> +	ironlake_edp_panel_vdd_off(intel_dp, false);
>  
>  	if (is_edp(intel_dp)) {
>  		ironlake_edp_backlight_off(dev);
> @@ -1077,7 +1141,7 @@ static void intel_dp_commit(struct drm_encoder *encoder)
>  
>  	if (is_edp(intel_dp))
>  		ironlake_edp_panel_on(intel_dp);
> -	ironlake_edp_panel_vdd_off(intel_dp);
> +	ironlake_edp_panel_vdd_off(intel_dp, true);
>  
>  	intel_dp_complete_link_train(intel_dp);
>  
> @@ -1111,10 +1175,10 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
>  			intel_dp_start_link_train(intel_dp);
>  			if (is_edp(intel_dp))
>  				ironlake_edp_panel_on(intel_dp);
> -			ironlake_edp_panel_vdd_off(intel_dp);
> +			ironlake_edp_panel_vdd_off(intel_dp, true);
>  			intel_dp_complete_link_train(intel_dp);
>  		} else
> -			ironlake_edp_panel_vdd_off(intel_dp);
> +			ironlake_edp_panel_vdd_off(intel_dp, false);

Any reason why one vdd_off is sync while the other isn't?

>  		if (is_edp(intel_dp))
>  			ironlake_edp_backlight_on(dev);
>  	}
> @@ -1752,7 +1816,7 @@ intel_dp_get_edid(struct drm_connector *connector, struct i2c_adapter *adapter)
>  
>  	ironlake_edp_panel_vdd_on(intel_dp);
>  	edid = drm_get_edid(connector, adapter);
> -	ironlake_edp_panel_vdd_off(intel_dp);
> +	ironlake_edp_panel_vdd_off(intel_dp, false);
>  	return edid;
>  }
>  
> @@ -1764,7 +1828,7 @@ intel_dp_get_edid_modes(struct drm_connector *connector, struct i2c_adapter *ada
>  
>  	ironlake_edp_panel_vdd_on(intel_dp);
>  	ret = intel_ddc_get_modes(connector, adapter);
> -	ironlake_edp_panel_vdd_off(intel_dp);
> +	ironlake_edp_panel_vdd_off(intel_dp, false);
>  	return ret;
>  }
>  
> @@ -1951,6 +2015,10 @@ static void intel_dp_encoder_destroy(struct drm_encoder *encoder)
>  
>  	i2c_del_adapter(&intel_dp->adapter);
>  	drm_encoder_cleanup(encoder);
> +	if (is_edp(intel_dp)) {
> +		cancel_delayed_work_sync(&intel_dp->panel_vdd_work);
> +		ironlake_panel_vdd_off_sync(intel_dp);
> +	}
>  	kfree(intel_dp);
>  }
>  
> @@ -2087,8 +2155,11 @@ intel_dp_init(struct drm_device *dev, int output_reg)
>  	else if (output_reg == DP_D || output_reg == PCH_DP_D)
>  		intel_encoder->clone_mask = (1 << INTEL_DP_D_CLONE_BIT);
>  
> -	if (is_edp(intel_dp))
> +	if (is_edp(intel_dp)) {
>  		intel_encoder->clone_mask = (1 << INTEL_EDP_CLONE_BIT);
> +		INIT_DELAYED_WORK(&intel_dp->panel_vdd_work,
> +				  ironlake_panel_vdd_work);
> +	}
>  
>  	intel_encoder->crtc_mask = (1 << 0) | (1 << 1);
>  	connector->interlace_allowed = true;
> @@ -2163,9 +2234,11 @@ intel_dp_init(struct drm_device *dev, int output_reg)
>  		DRM_DEBUG_KMS("panel power up delay %d, power down delay %d\n",
>  			      intel_dp->panel_power_up_delay, intel_dp->panel_power_down_delay);
>  
> +		intel_dp->panel_off_jiffies = jiffies - intel_dp->panel_power_down_delay;
> +
>  		ironlake_edp_panel_vdd_on(intel_dp);
>  		ret = intel_dp_get_dpcd(intel_dp);
> -		ironlake_edp_panel_vdd_off(intel_dp);
> +		ironlake_edp_panel_vdd_off(intel_dp, false);
>  		if (ret) {
>  			if (intel_dp->dpcd[DP_DPCD_REV] >= 0x11)
>  				dev_priv->no_aux_handshake =
> -- 
> 1.7.6.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
