Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1EEUm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:42:27 -0400
Received: from smtpout04.highway.telekom.at ([195.3.96.117]:11092 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751248Ab1EEUm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:42:26 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: i915/kms/backlight-combo mode problem (was: Re: Linux 2.6.39-rc5)
Date: Thu, 5 May 2011 22:42:21 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.5; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org,
        Carlos Corbacho <carlos@strangeworlds.co.uk>
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201105051745.27992@rk-nord.at> <s5htyd9kumz.wl%tiwai@suse.de>
In-Reply-To: <s5htyd9kumz.wl%tiwai@suse.de>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105052242.22217@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Iwai -- Thursday 05 May 2011:
> Try the fixed patch below.

> ---
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 456f404..4c6e187 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -332,6 +332,7 @@ typedef struct drm_i915_private {
>  	struct intel_overlay *overlay;
>  
>  	/* LVDS info */
> +	int backlight_combination_mode; /* 0=unknown, -1=no, 1=yes */
>  	int backlight_level;  /* restore backlight to this value */
>  	bool backlight_enabled;
>  	struct drm_display_mode *panel_fixed_mode;
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index f8f86e5..5a6be04 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -115,14 +115,24 @@ done:
>  static int is_backlight_combination_mode(struct drm_device *dev)
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> -
> -	if (INTEL_INFO(dev)->gen >= 4)
> -		return I915_READ(BLC_PWM_CTL2) & BLM_COMBINATION_MODE;
> -
> -	if (IS_GEN2(dev))
> -		return I915_READ(BLC_PWM_CTL) & BLM_LEGACY_MODE;
> -
> -	return 0;
> +	int combo_mode;
> +	u8 lbpc;
> +
> +	if (dev_priv->backlight_combination_mode)
> +		return dev_priv->backlight_combination_mode > 0;
> +
> +	pci_read_config_byte(dev->pdev, PCI_LBPC, &lbpc);
> +	if (!lbpc)
> +		combo_mode = 0;
> +	else if (INTEL_INFO(dev)->gen >= 4)
> +		combo_mode = I915_READ(BLC_PWM_CTL2) & BLM_COMBINATION_MODE;
> +	else if (IS_GEN2(dev))
> +		combo_mode = I915_READ(BLC_PWM_CTL) & BLM_LEGACY_MODE;
> +	else
> +		combo_mode = 0;
> +
> +	dev_priv->backlight_combination_mode = combo_mode ? 1 : -1;
> +	return combo_mode;
>  }
>  
>  static u32 i915_read_blc_pwm_ctl(struct drm_i915_private *dev_priv)

The first patch had a problem. Without the lbpc check for zero the backlight
still stayed off and could only be activated with the brightness-down key.
This revised patch works correctly for me. Thanks!

m.
