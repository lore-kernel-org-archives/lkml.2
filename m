Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1BKGeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 01:34:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:12436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1BKGeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 01:34:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jLje0mDguSzFt7IJEi+c7MR6bPDqTAubiqp+ytevjqN/8vfdcr3NXEvOo2how8f/Wm
         IBYQr5y3wgnzNS6ajpmQ==
Date: Thu, 10 Feb 2011 22:34:11 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] drm/i915/tv: Use polling rather than interrupt-based
 hotplug
In-Reply-To: <1297332966-17647-1-git-send-email-chris@chris-wilson.co.uk>
Message-ID: <alpine.LSU.2.00.1102102220580.2017@sister.anvils>
References: <alpine.LSU.2.00.1102081132160.1591@sister.anvils> <1297332966-17647-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Chris Wilson wrote:

> The documentation recommends that we should use a polling method for TV
> detection as this is more power efficient than the interrupt based
> mechanism (as the encoder can be completely switched off). A secondary
> effect is that leaving the hotplug enabled seems to be causing pipe
> underruns as reported by Hugh Dickins on his Crestline.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: stable@kernel.org
> ---
> 
> Hugh, does this prevent the persistent PIPE UNDERRUN issue?

Brilliant, Chris, yes it does, thank you.  I checked both 2.6.38-rc4
and 2.6.37 (changing "irq_lock" back to "user_irq_lock") and verified
that both i386 and x86_64 "pipe a underrun"s have been fixed.  I also
just tried hooking up laptop to TV by VGA cable, and it appears to
drive the TV correctly too.

(It doesn't fix my text flush problem, but we'd given up expecting that.)

Thanks,
Hugh

> 
> ---
>  drivers/gpu/drm/i915/intel_tv.c |   43 +++++++++++++++++++++++++++-----------
>  1 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> index 93206e4..fe4a53a 100644
> --- a/drivers/gpu/drm/i915/intel_tv.c
> +++ b/drivers/gpu/drm/i915/intel_tv.c
> @@ -1234,7 +1234,8 @@ static const struct drm_display_mode reported_modes[] = {
>   * \return false if TV is disconnected.
>   */
>  static int
> -intel_tv_detect_type (struct intel_tv *intel_tv)
> +intel_tv_detect_type (struct intel_tv *intel_tv,
> +		      struct drm_connector *connector)
>  {
>  	struct drm_encoder *encoder = &intel_tv->base.base;
>  	struct drm_device *dev = encoder->dev;
> @@ -1245,11 +1246,13 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
>  	int type;
>  
>  	/* Disable TV interrupts around load detect or we'll recurse */
> -	spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
> -	i915_disable_pipestat(dev_priv, 0,
> -			      PIPE_HOTPLUG_INTERRUPT_ENABLE |
> -			      PIPE_HOTPLUG_TV_INTERRUPT_ENABLE);
> -	spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
> +	if (connector->polled & DRM_CONNECTOR_POLL_HPD) {
> +		spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
> +		i915_disable_pipestat(dev_priv, 0,
> +				      PIPE_HOTPLUG_INTERRUPT_ENABLE |
> +				      PIPE_HOTPLUG_TV_INTERRUPT_ENABLE);
> +		spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
> +	}
>  
>  	save_tv_dac = tv_dac = I915_READ(TV_DAC);
>  	save_tv_ctl = tv_ctl = I915_READ(TV_CTL);
> @@ -1302,11 +1305,13 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
>  	I915_WRITE(TV_CTL, save_tv_ctl);
>  
>  	/* Restore interrupt config */
> -	spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
> -	i915_enable_pipestat(dev_priv, 0,
> -			     PIPE_HOTPLUG_INTERRUPT_ENABLE |
> -			     PIPE_HOTPLUG_TV_INTERRUPT_ENABLE);
> -	spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
> +	if (connector->polled & DRM_CONNECTOR_POLL_HPD) {
> +		spin_lock_irqsave(&dev_priv->irq_lock, irqflags);
> +		i915_enable_pipestat(dev_priv, 0,
> +				     PIPE_HOTPLUG_INTERRUPT_ENABLE |
> +				     PIPE_HOTPLUG_TV_INTERRUPT_ENABLE);
> +		spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
> +	}
>  
>  	return type;
>  }
> @@ -1356,7 +1361,7 @@ intel_tv_detect(struct drm_connector *connector, bool force)
>  	drm_mode_set_crtcinfo(&mode, CRTC_INTERLACE_HALVE_V);
>  
>  	if (intel_tv->base.base.crtc && intel_tv->base.base.crtc->enabled) {
> -		type = intel_tv_detect_type(intel_tv);
> +		type = intel_tv_detect_type(intel_tv, connector);
>  	} else if (force) {
>  		struct drm_crtc *crtc;
>  		int dpms_mode;
> @@ -1364,7 +1369,7 @@ intel_tv_detect(struct drm_connector *connector, bool force)
>  		crtc = intel_get_load_detect_pipe(&intel_tv->base, connector,
>  						  &mode, &dpms_mode);
>  		if (crtc) {
> -			type = intel_tv_detect_type(intel_tv);
> +			type = intel_tv_detect_type(intel_tv, connector);
>  			intel_release_load_detect_pipe(&intel_tv->base, connector,
>  						       dpms_mode);
>  		} else
> @@ -1658,6 +1663,18 @@ intel_tv_init(struct drm_device *dev)
>  	intel_encoder = &intel_tv->base;
>  	connector = &intel_connector->base;
>  
> +	/* The documentation, for the older chipsets at least, recommend
> +	 * using a polling method rather than hotplug detection for TVs.
> +	 * This is because in order to perform the hotplug detection, the PLLs
> +	 * for the TV must be kept alive increasing power drain and starving
> +	 * bandwidth from other encoders. Notably for instance, it causes
> +	 * pipe underruns on Crestline when this encoder is supposedly idle.
> +	 *
> +	 * More recent chipsets favour HDMI rather than integrated S-Video.
> +	 */
> +	connector->polled =
> +		DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT;
> +
>  	drm_connector_init(dev, connector, &intel_tv_connector_funcs,
>  			   DRM_MODE_CONNECTOR_SVIDEO);
>  
> -- 
> 1.7.2.3
