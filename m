Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2C1NFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:05:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43332 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2C1NFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:05:00 -0400
Date: Wed, 28 Mar 2012 15:05:42 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 07/13 v4] drm/i915/intel_i2c: allocate gmbus array as
 part of drm_i915_private
Message-ID: <20120328130542.GC27581@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
 <1332873382-29373-8-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332873382-29373-8-git-send-email-djkurtz@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 02:36:16AM +0800, Daniel Kurtz wrote:
> This memory is always allocated, and it is always a fixed size, so just
> allocate it along with the rest of the driver state.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I've picked up all your patches up and including this one for d-i-n,
thanks. I'm a bit unhappy about the gmbus to gmbus pin off-by-one stuff in
the previous patch, but I could not come up with a better way to do it.
And merging these 2 enumerations into one sounds like a good idea, so I've
picked it up.
-Daniel
> ---
>  drivers/gpu/drm/i915/i915_drv.h  |    2 +-
>  drivers/gpu/drm/i915/intel_i2c.c |   10 ----------
>  2 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index c5ad7b9..6983b4b 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -326,7 +326,7 @@ typedef struct drm_i915_private {
>  	/** gt_lock is also taken in irq contexts. */
>  	struct spinlock gt_lock;
>  
> -	struct intel_gmbus *gmbus;
> +	struct intel_gmbus gmbus[GMBUS_NUM_PORTS];
>  
>  	/** gmbus_mutex protects against concurrent usage of the single hw gmbus
>  	 * controller on different i2c buses. */
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index dcde6f6..c12db72 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -387,11 +387,6 @@ int intel_setup_gmbus(struct drm_device *dev)
>  	else
>  		dev_priv->gpio_mmio_base = 0;
>  
> -	dev_priv->gmbus = kcalloc(GMBUS_NUM_PORTS, sizeof(struct intel_gmbus),
> -				  GFP_KERNEL);
> -	if (dev_priv->gmbus == NULL)
> -		return -ENOMEM;
> -
>  	mutex_init(&dev_priv->gmbus_mutex);
>  
>  	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
> @@ -428,8 +423,6 @@ err:
>  		struct intel_gmbus *bus = &dev_priv->gmbus[i];
>  		i2c_del_adapter(&bus->adapter);
>  	}
> -	kfree(dev_priv->gmbus);
> -	dev_priv->gmbus = NULL;
>  	return ret;
>  }
>  
> @@ -468,7 +461,4 @@ void intel_teardown_gmbus(struct drm_device *dev)
>  		struct intel_gmbus *bus = &dev_priv->gmbus[i];
>  		i2c_del_adapter(&bus->adapter);
>  	}
> -
> -	kfree(dev_priv->gmbus);
> -	dev_priv->gmbus = NULL;
>  }
> -- 
> 1.7.7.3
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
