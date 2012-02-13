Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab2BMUaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:30:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55363 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab2BMUay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:30:54 -0500
Date: Mon, 13 Feb 2012 21:31:07 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Yufeng Shen <miletus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: Re: [PATCH] [PATCH] drm/i915: Fix race condition in accessing GMBUS
Message-ID: <20120213203107.GL5301@phenom.ffwll.local>
Mail-Followup-To: Yufeng Shen <miletus@chromium.org>,
	linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	Eugeni Dodonov <eugeni.dodonov@intel.com>
References: <1328825697-23685-1-git-send-email-miletus@chromium.org>
 <1328896201-20909-1-git-send-email-miletus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328896201-20909-1-git-send-email-miletus@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 12:50:01PM -0500, Yufeng Shen wrote:
> GMBUS has several ports and each has it's own corresponding
> I2C adpater. When multiple I2C adapters call gmbus_xfer() at
> the same time there is a race condition in using the underlying
> GMBUS controller. Fixing this by adding a mutex lock when calling
> gmbus_xfer().
> 
> Signed-off-by: Yufeng Shen <miletus@chromium.org>

2 more nitpicks:
- patch doesn't apply cleanly - can you please rebase against
  drm-intel-next-queued available at

  http://cgit.freedesktop.org/~danvet/drm-intel/

- please move the new gmbus_mutex to the other gmbus stuff in
  drm_i915_private and add a small comment to that it explains against
  concurrent use (from e.g. userspace) of the single gmbus controller.

Yours, Daniel

> ---
>  drivers/gpu/drm/i915/i915_drv.h  |    2 ++
>  drivers/gpu/drm/i915/intel_i2c.c |   23 +++++++++++++++++------
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 559fb6f..4ed9fd9 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -722,6 +722,8 @@ typedef struct drm_i915_private {
>  	u8 corr;
>  	spinlock_t *mchdev_lock;
>  
> +	struct mutex gmbus_mutex;
> +
>  	enum no_fbc_reason no_fbc_reason;
>  
>  	struct drm_mm_node *compressed_fb;
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index d98cee6..42569b1 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -232,11 +232,15 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
>  				    bus->force_bit, msgs, num);
> +		goto out;
> +	}
>  
>  	reg_offset = HAS_PCH_SPLIT(dev_priv->dev) ? PCH_GMBUS0 - GMBUS0 : 0;
>  
> @@ -320,7 +324,8 @@ done:
>  	 * start of the next xfer, till then let it sleep.
>  	 */
>  	I915_WRITE(GMBUS0 + reg_offset, 0);
> -	return i;
> +	ret = i;
> +	goto out;
>  
>  timeout:
>  	DRM_INFO("GMBUS timed out, falling back to bit banging on pin %d [%s]\n",
> @@ -330,9 +335,13 @@ timeout:
>  	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
>  	bus->force_bit = intel_gpio_create(dev_priv, bus->reg0 & 0xff);
>  	if (!bus->force_bit)
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +	else
> +		ret = intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
>  
> -	return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
> +out:
> +	mutex_unlock(&dev_priv->gmbus_mutex);
> +	return ret;
>  }
>  
>  static u32 gmbus_func(struct i2c_adapter *adapter)
> @@ -379,6 +388,8 @@ int intel_setup_gmbus(struct drm_device *dev)
>  	if (dev_priv->gmbus == NULL)
>  		return -ENOMEM;
>  
> +	mutex_init(&dev_priv->gmbus_mutex);
> +
>  	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
>  		struct intel_gmbus *bus = &dev_priv->gmbus[i];
>  
> -- 
> 1.7.3.4
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
