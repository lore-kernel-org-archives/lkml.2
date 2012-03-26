Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2CZP2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:28:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47641 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab2CZP2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:28:52 -0400
Date: Mon, 26 Mar 2012 17:29:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 01/11 v3] drm/i915/intel_i2c: cleanup
Message-ID: <20120326152935.GW4014@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
 <1332772010-19619-2-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332772010-19619-2-git-send-email-djkurtz@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:26:40PM +0800, Daniel Kurtz wrote:
> 80 col, spaces around operators and other basic cleanup.
> Some info message cleanup.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

On reconsideration, nacked. You desperately try to squeeze a function with
already 5 indent levels (not counting indentation due to function
arguments and overflow) with already 100+ lines of code into 80 columns.

Please do the right thing and split out a few of helper functions. I
suggest you split out the read and write code, i.e.

if (msgs[i].flags & I2C_M_RD)
	gmbus_xfer_read()
else
	gmbus_xfer_write

This way you get 3 levels of tab space of room and I won't have to
complain as much that some of your later patches make gmbus_xfer way too
bug.

Yours, Daniel

> ---
>  drivers/gpu/drm/i915/intel_i2c.c |   32 +++++++++++++++++++++-----------
>  1 files changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index 0713cc2..86b1861 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -230,13 +230,16 @@ gmbus_xfer(struct i2c_adapter *adapter,
>  				   (len << GMBUS_BYTE_COUNT_SHIFT) |
>  				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
>  				   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
> -			POSTING_READ(GMBUS2+reg_offset);
> +			POSTING_READ(GMBUS2 + reg_offset);
>  			do {
>  				u32 val, loop = 0;
>  
> -				if (wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_RDY), 50))
> +				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
> +					     (GMBUS_SATOER | GMBUS_HW_RDY),
> +					     50))
>  					goto timeout;
> -				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
> +				if (I915_READ(GMBUS2 + reg_offset) &
> +				    GMBUS_SATOER)
>  					goto clear_err;
>  
>  				val = I915_READ(GMBUS3 + reg_offset);
> @@ -260,12 +263,15 @@ gmbus_xfer(struct i2c_adapter *adapter,
>  				   (msgs[i].len << GMBUS_BYTE_COUNT_SHIFT) |
>  				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
>  				   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
> -			POSTING_READ(GMBUS2+reg_offset);
> +			POSTING_READ(GMBUS2 + reg_offset);
>  
>  			while (len) {
> -				if (wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_RDY), 50))
> +				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
> +					     (GMBUS_SATOER | GMBUS_HW_RDY),
> +					     50))
>  					goto timeout;
> -				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
> +				if (I915_READ(GMBUS2 + reg_offset) &
> +				    GMBUS_SATOER)
>  					goto clear_err;
>  
>  				val = loop = 0;
> @@ -274,11 +280,14 @@ gmbus_xfer(struct i2c_adapter *adapter,
>  				} while (--len && ++loop < 4);
>  
>  				I915_WRITE(GMBUS3 + reg_offset, val);
> -				POSTING_READ(GMBUS2+reg_offset);
> +				POSTING_READ(GMBUS2 + reg_offset);
>  			}
>  		}
>  
> -		if (i + 1 < num && wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE), 50))
> +		if (i + 1 < num &&
> +		    wait_for(I915_READ(GMBUS2 + reg_offset) &
> +			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
> +			     50))
>  			goto timeout;
>  		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
>  			goto clear_err;
> @@ -300,14 +309,15 @@ done:
>  	 * till then let it sleep.
>  	 */
>  	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0, 10))
> -		DRM_INFO("GMBUS timed out waiting for idle\n");
> +		DRM_INFO("GMBUS [%s] timed out waiting for idle\n",
> +			 bus->adapter.name);
>  	I915_WRITE(GMBUS0 + reg_offset, 0);
>  	ret = i;
>  	goto out;
>  
>  timeout:
> -	DRM_INFO("GMBUS timed out, falling back to bit banging on pin %d [%s]\n",
> -		 bus->reg0 & 0xff, bus->adapter.name);
> +	DRM_INFO("GMBUS [%s] timed out, falling back to bit banging on pin %d\n",
> +		 bus->adapter.name, bus->reg0 & 0xff);
>  	I915_WRITE(GMBUS0 + reg_offset, 0);
>  
>  	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
> -- 
> 1.7.7.3
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
