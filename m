Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2CZOsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:48:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56355 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab2CZOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:48:37 -0400
Date: Mon, 26 Mar 2012 16:49:19 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 03/11 v3] drm/i915/intel_i2c: use i2c pre/post_xfer
 functions to setup gpio xfers
Message-ID: <20120326144919.GP4014@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
 <1332772010-19619-4-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332772010-19619-4-git-send-email-djkurtz@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:26:42PM +0800, Daniel Kurtz wrote:
> Instead of rolling our own custom quirk_xfer function, use the bit_algo
> pre_xfer and post_xfer functions to setup and teardown bit-banged
> i2c transactions.
> 
> gmbus_xfer uses .force_bit to determine which i2c_algorithm to use,
> either i2c_bit_algo.master_xfer or its own.  So, Similarly, let gmbus_func
> use .force_bit to determine which i2c functionalities are available,
> either i2c_bit_algo.functionality, or its own.

Please split this part of the patch into a separate patch. Furthermore I'm
not sure what this should buy us, given that we might magically changes
our i2c feature set once with gone to fallback mode. Can you please
elaborate why we need this?

The pre_xfer/post_xfer stuff looks good to me, that part along is
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Yours, Daniel

> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/i915/intel_i2c.c |   72 +++++++++++++++++++++++--------------
>  1 files changed, 45 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index 54f85a1..ae08a08 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -137,6 +137,35 @@ static void set_data(void *data, int state_high)
>  	POSTING_READ(bus->gpio_reg);
>  }
>  
> +static int
> +intel_gpio_pre_xfer(struct i2c_adapter *adapter)
> +{
> +	struct intel_gmbus *bus = container_of(adapter,
> +					       struct intel_gmbus,
> +					       adapter);
> +	struct drm_i915_private *dev_priv = bus->dev_priv;
> +
> +	intel_i2c_reset(dev_priv->dev);
> +	intel_i2c_quirk_set(dev_priv, true);
> +	set_data(bus, 1);
> +	set_clock(bus, 1);
> +	udelay(I2C_RISEFALL_TIME);
> +	return 0;
> +}
> +
> +static void
> +intel_gpio_post_xfer(struct i2c_adapter *adapter)
> +{
> +	struct intel_gmbus *bus = container_of(adapter,
> +					       struct intel_gmbus,
> +					       adapter);
> +	struct drm_i915_private *dev_priv = bus->dev_priv;
> +
> +	set_data(bus, 1);
> +	set_clock(bus, 1);
> +	intel_i2c_quirk_set(dev_priv, false);
> +}
> +
>  static bool
>  intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
>  {
> @@ -166,6 +195,8 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
>  	algo->setscl = set_clock;
>  	algo->getsda = get_data;
>  	algo->getscl = get_clock;
> +	algo->pre_xfer = intel_gpio_pre_xfer;
> +	algo->post_xfer = intel_gpio_post_xfer;
>  	algo->udelay = I2C_RISEFALL_TIME;
>  	algo->timeout = usecs_to_jiffies(2200);
>  	algo->data = bus;
> @@ -174,30 +205,6 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
>  }
>  
>  static int
> -intel_i2c_quirk_xfer(struct intel_gmbus *bus,
> -		     struct i2c_msg *msgs,
> -		     int num)
> -{
> -	struct drm_i915_private *dev_priv = bus->dev_priv;
> -	int ret;
> -
> -	intel_i2c_reset(dev_priv->dev);
> -
> -	intel_i2c_quirk_set(dev_priv, true);
> -	set_data(bus, 1);
> -	set_clock(bus, 1);
> -	udelay(I2C_RISEFALL_TIME);
> -
> -	ret = i2c_bit_algo.master_xfer(&bus->adapter, msgs, num);
> -
> -	set_data(bus, 1);
> -	set_clock(bus, 1);
> -	intel_i2c_quirk_set(dev_priv, false);
> -
> -	return ret;
> -}
> -
> -static int
>  gmbus_xfer(struct i2c_adapter *adapter,
>  	   struct i2c_msg *msgs,
>  	   int num)
> @@ -211,7 +218,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
>  	mutex_lock(&dev_priv->gmbus_mutex);
>  
>  	if (bus->force_bit) {
> -		ret = intel_i2c_quirk_xfer(bus, msgs, num);
> +		ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
>  		goto out;
>  	}
>  
> @@ -325,8 +332,9 @@ timeout:
>  		ret = -EIO;
>  	} else {
>  		bus->force_bit = true;
> -		ret = intel_i2c_quirk_xfer(bus, msgs, num);
> +		ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
>  	}
> +
>  out:
>  	mutex_unlock(&dev_priv->gmbus_mutex);
>  	return ret;
> @@ -334,11 +342,21 @@ out:
>  
>  static u32 gmbus_func(struct i2c_adapter *adapter)
>  {
> -	return i2c_bit_algo.functionality(adapter) &
> +	struct intel_gmbus *bus = container_of(adapter,
> +					       struct intel_gmbus,
> +					       adapter);
> +	struct drm_i915_private *dev_priv = bus->dev_priv;
> +	u32 func;
> +
> +	mutex_lock(&dev_priv->gmbus_mutex);
> +	func = bus->force_bit ? i2c_bit_algo.functionality(adapter) :
>  		(I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL |
>  		/* I2C_FUNC_10BIT_ADDR | */
>  		I2C_FUNC_SMBUS_READ_BLOCK_DATA |
>  		I2C_FUNC_SMBUS_BLOCK_PROC_CALL);
> +	mutex_unlock(&dev_priv->gmbus_mutex);
> +
> +	return func;
>  }
>  
>  static const struct i2c_algorithm gmbus_algorithm = {
> -- 
> 1.7.7.3
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
