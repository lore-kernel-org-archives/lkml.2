Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab2BJRQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:16:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59550 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab2BJRQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:16:50 -0500
Date: Fri, 10 Feb 2012 18:17:01 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Yufeng Shen <miletus@chromium.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Fix race condition in accessing GMBUS
Message-ID: <20120210171701.GC4311@phenom.ffwll.local>
Mail-Followup-To: Yufeng Shen <miletus@chromium.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1328825697-23685-1-git-send-email-miletus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328825697-23685-1-git-send-email-miletus@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 05:14:57PM -0500, Yufeng Shen wrote:
> GMBUS has several ports and each has it's own corresponding
> I2C adpater. When multiple I2C adapters call gmbus_xfer() at
> the same time there is a race condition in using the underlying
> GMBUS controller. Fixing this by adding a mutex lock when calling
> gmbus_xfer().
> 
> Signed-off-by: Yufeng Shen <miletus@chromium.org>
> ---
>  drivers/gpu/drm/i915/i915_drv.h  |    2 ++
>  drivers/gpu/drm/i915/intel_i2c.c |   21 ++++++++++++++++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 9689ca3..d0f826e 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -733,6 +733,8 @@ typedef struct drm_i915_private {
>  	u8 corr;
>  	spinlock_t *mchdev_lock;
>  
> +	struct mutex gmbus_mutex;
> +
>  	enum no_fbc_reason no_fbc_reason;
>  
>  	struct drm_mm_node *compressed_fb;
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index d30cccc..24fafdc 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -233,11 +233,16 @@ gmbus_xfer(struct i2c_adapter *adapter,
>  					       struct intel_gmbus,
>  					       adapter);
>  	struct drm_i915_private *dev_priv = adapter->algo_data;
> -	int i, reg_offset;
> +	int i, reg_offset, ret;
>  
> -	if (bus->force_bit)
> -		return intel_i2c_quirk_xfer(dev_priv,
> +	mutex_lock(&dev_priv->gmbus_mutex);
> +
> +	if (bus->force_bit) {
> +		ret = intel_i2c_quirk_xfer(dev_priv,
>  					    bus->force_bit, msgs, num);
> +		mutex_unlock(&dev_priv->gmbus_mutex);
> +		return ret;

The usual code pattern is to have

out:
	mutex_unlock(mutex)

	return ret;

add the end of the function and

	ret = retval;
	goto out;

on all exit paths. This way it's clearer to see that all locks (or other
resources) get properly unlocked and unref'ed. Can you please adjust your
patch accordingly?

Otherwise the patch looks good.

Thanks, Daniel

> +	}
>  
>  	reg_offset = HAS_PCH_SPLIT(dev_priv->dev) ? PCH_GMBUS0 - GMBUS0 : 0;
>  
> @@ -321,6 +326,7 @@ done:
>  	 * start of the next xfer, till then let it sleep.
>  	 */
>  	I915_WRITE(GMBUS0 + reg_offset, 0);
> +	mutex_unlock(&dev_priv->gmbus_mutex);
>  	return i;
>  
>  timeout:
> @@ -331,9 +337,12 @@ timeout:
>  	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
>  	bus->force_bit = intel_gpio_create(dev_priv, bus->reg0 & 0xff);
>  	if (!bus->force_bit)
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +	else
> +		ret = intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
>  
> -	return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
> +	mutex_unlock(&dev_priv->gmbus_mutex);
> +	return ret;
>  }
>  
>  static u32 gmbus_func(struct i2c_adapter *adapter)
> @@ -380,6 +389,8 @@ int intel_setup_gmbus(struct drm_device *dev)
>  	if (dev_priv->gmbus == NULL)
>  		return -ENOMEM;
>  
> +	mutex_init(&dev_priv->gmbus_mutex);
> +
>  	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
>  		struct intel_gmbus *bus = &dev_priv->gmbus[i];
>  
> -- 
> 1.7.3.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
