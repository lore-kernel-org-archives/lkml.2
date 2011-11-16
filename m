Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1KPM7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:59:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38747 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab1KPM7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:59:03 -0500
Message-ID: <4EC3B391.90001@gmail.com>
Date: Wed, 16 Nov 2011 13:58:57 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, harald@redhat.com,
        Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org
Subject: Re: Strange effect with i915 backlight controller
References: <4EB3F860.6010408@gmail.com> <4EB87E6A.3060403@gmail.com> <4EBBE9A1.8020501@gmail.com> <s5hmxc49ec0.wl%tiwai@suse.de> <4EBFEF29.9050005@gmail.com> <s5h1utb6l9s.wl%tiwai@suse.de>
In-Reply-To: <s5h1utb6l9s.wl%tiwai@suse.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 11:39 AM, Takashi Iwai wrote:
> OK, then perhaps a better fix is to change the check to be equivalent
> with pineview, as you mentioned in the original post.  The handling of
> bit 0 for old chips was lost during the refactoring of backlight code
> since 2.6.37.
> 
> Does the patch below work for you?
> 
> The only concern by this fix is that it changes the max value.  If
> apps expect some certain (e.g. recorded) value, it may screw up.  But
> I don't expect this would happen with sane apps.

Works perfectly - let's ship it :)


Thanks again,
Daniel


> ===
> From: Takashi Iwai <tiwai@suse.de>
> Subject: drm/i915: Fix invalid backpanel values for GEN3 or older chips
> 
> While refactoring of backlight control code in commit [a95735569:
> drm/i915: Refactor panel backlight controls], the handling of the bit
> 0 of duty-cycle was gone except for pineview.  This resulted in invalid
> register values for old chips like 915GM.  When the bit 0 is set, the
> backlight is turned off suddenly.
> 
> This patch changes the bit-0 check by replacing with the condition of
> gen < 4 (pineview is included in this condition, too).
> 
> Reported-by: Daniel Mack <zonque@gmail.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/gpu/drm/i915/intel_panel.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> index 499d4c0..737d00f 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -178,12 +178,10 @@ u32 intel_panel_get_max_backlight(struct drm_device *dev)
>  	if (HAS_PCH_SPLIT(dev)) {
>  		max >>= 16;
>  	} else {
> -		if (IS_PINEVIEW(dev)) {
> +		if (INTEL_INFO(dev)->gen < 4) {
>  			max >>= 17;
>  		} else {
>  			max >>= 16;
> -			if (INTEL_INFO(dev)->gen < 4)
> -				max &= ~1;
>  		}
>  
>  		if (is_backlight_combination_mode(dev))
> @@ -203,7 +201,7 @@ u32 intel_panel_get_backlight(struct drm_device *dev)
>  		val = I915_READ(BLC_PWM_CPU_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
>  	} else {
>  		val = I915_READ(BLC_PWM_CTL) & BACKLIGHT_DUTY_CYCLE_MASK;
> -		if (IS_PINEVIEW(dev))
> +		if (INTEL_INFO(dev)->gen < 4)
>  			val >>= 1;
>  
>  		if (is_backlight_combination_mode(dev)) {
> @@ -246,7 +244,7 @@ static void intel_panel_actually_set_backlight(struct drm_device *dev, u32 level
>  	}
>  
>  	tmp = I915_READ(BLC_PWM_CTL);
> -	if (IS_PINEVIEW(dev)) {
> +	if (INTEL_INFO(dev)->gen < 4) {
>  		tmp &= ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);
>  		level <<= 1;
>  	} else

