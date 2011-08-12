Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HLRhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:37:42 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:37150 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1HLRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:37:39 -0400
Message-ID: <4E4564D0.70104@gmail.com>
Date: Fri, 12 Aug 2011 10:37:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@linux.ie
Subject: Re: i915 suspend crash: BUG: unable to handle kernel NULL pointer
 deferrence
References: <4E44C537.8040101@gmail.com> <yunobzusona.fsf@aiko.keithp.com> <4E454D75.2090505@gmail.com> <yunliuysgf6.fsf@aiko.keithp.com>
In-Reply-To: <yunliuysgf6.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 08/12/2011 10:11 AM, Keith Packard wrote:
> On Fri, 12 Aug 2011 08:57:41 -0700, "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> [ 96.384971] [drm:i915_get_vblank_timestamp] *ERROR* Invalid crtc 0
>
> You're not using KMS are you...
>
> UMS mode disables a ton of features in the driver; you've hit a couple
> that weren't getting skipped in all cases.
>
> Here's some patches that make sure two of the disabled features are
> correctly bypassed. If these work for you, I'll create a couple of
> patches, one per bug. Afterwards, you should really consider switching
> to KMS...
>
> (meanwhile, thanks for finding bugs in ancient code!)
>
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index 02f96fd..9cbb0cd 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -2058,8 +2058,10 @@ void intel_irq_init(struct drm_device *dev)
>   		dev->driver->get_vblank_counter = gm45_get_vblank_counter;
>   	}
>
> -
> -	dev->driver->get_vblank_timestamp = i915_get_vblank_timestamp;
> +	if (drm_core_check_feature(dev, DRIVER_MODESET))
> +		dev->driver->get_vblank_timestamp = i915_get_vblank_timestamp;
> +	else
> +		dev->driver->get_vblank_timestamp = NULL;
>   	dev->driver->get_scanout_position = i915_get_crtc_scanoutpos;
>
>   	if (IS_IVYBRIDGE(dev)) {
> diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
> index 87677d6..f107423 100644
> --- a/drivers/gpu/drm/i915/i915_suspend.c
> +++ b/drivers/gpu/drm/i915/i915_suspend.c
> @@ -871,7 +871,8 @@ int i915_restore_state(struct drm_device *dev)
>   	}
>   	mutex_unlock(&dev->struct_mutex);
>
> -	intel_init_clock_gating(dev);
> +	if (drm_core_check_feature(dev, DRIVER_MODESET))
> +		intel_init_clock_gating(dev);
>
>   	if (IS_IRONLAKE_M(dev)) {
>   		ironlake_enable_drps(dev);
>
>

  I have: Enable modesetting on intel by default (DRM_I915_KMS) not set 
  in my .config. I will enable that and see if this fixes this issue, if 
not then I will test those patches out.
