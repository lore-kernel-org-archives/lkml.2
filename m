Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1JRFsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 01:48:00 -0400
Received: from mga06.intel.com ([134.134.136.21]:27812 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936Ab1JRFr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 01:47:58 -0400
Date: Mon, 17 Oct 2011 22:47:29 -0700
From: Ben Widawsky <benjamin.widawsky@intel.com>
To: keithp@keithp.com
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 11/12] i915:  Move i915_read/write out of line
Message-ID: <20111017224729.54e2dbc0@intel.com>
In-Reply-To: <1318547332-23155-11-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
	<1318547332-23155-11-git-send-email-andi@firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011 16:08:51 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> With the tracing code in there they are far too big to inline.
> 
> .text savings compared to a non force inline kernel:
> 
> i915_restore_display                        4393   12036   +7643
> i915_save_display                           4295   11459   +7164
> i915_handle_error                           2979    6666   +3687
> i915_driver_irq_handler                     2923    5086   +2163
> i915_ringbuffer_info                         458    1661   +1203
> i915_save_vga                                  -    1200   +1200
> i915_driver_irq_uninstall                    453    1624   +1171
> i915_driver_irq_postinstall                  913    2078   +1165
> ironlake_enable_drps                         719    1872   +1153
> i915_restore_vga                               -    1142   +1142
> intel_display_capture_error_state            784    2030   +1246
> intel_init_emon                              719    2016   +1297
> 
> and more ...
> 
> [AK: these are older numbers, with the new SNB forcewake checks
> it will be even worse]
> 
> Cc: keithp@keithp.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/i915_drv.c |   40 +++++++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/i915_drv.h |   22 ++------------------
>  2 files changed, 43 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index f07e425..c2de142 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -895,3 +895,43 @@ module_exit(i915_exit);
>  MODULE_AUTHOR(DRIVER_AUTHOR);
>  MODULE_DESCRIPTION(DRIVER_DESC);
>  MODULE_LICENSE("GPL and additional rights");
> +
> +/* We give fast paths for the really cool registers */
> +#define NEEDS_FORCE_WAKE(dev_priv, reg) \
> +	(((dev_priv)->info->gen >= 6) && \
> +	((reg) < 0x40000) && \
> +	((reg) != FORCEWAKE))
> +
> +#define __i915_read(x, y) \
> +u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
> +	u##x val = 0; \
> +	if (NEEDS_FORCE_WAKE((dev_priv), (reg))) { \
> +		gen6_gt_force_wake_get(dev_priv); \
> +		val = read##y(dev_priv->regs + reg); \
> +		gen6_gt_force_wake_put(dev_priv); \
> +	} else { \
> +		val = read##y(dev_priv->regs + reg); \
> +	} \
> +	trace_i915_reg_rw(false, reg, val, sizeof(val)); \
> +	return val; \
> +}
> +
> +__i915_read(8, b)
> +__i915_read(16, w)
> +__i915_read(32, l)
> +__i915_read(64, q)
> +#undef __i915_read
> +
> +#define __i915_write(x, y) \
> +void i915_write##x(struct drm_i915_private *dev_priv, u32 reg, u##x val) { \
> +	trace_i915_reg_rw(true, reg, val, sizeof(val)); \
> +	if (NEEDS_FORCE_WAKE((dev_priv), (reg))) { \
> +		__gen6_gt_wait_for_fifo(dev_priv); \
> +	} \
> +	write##y(val, dev_priv->regs + reg); \
> +}
> +__i915_write(8, b)
> +__i915_write(16, w)
> +__i915_write(32, l)
> +__i915_write(64, q)
> +#undef __i915_write
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 7916bd9..7d171ea 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -1354,18 +1354,7 @@ void __gen6_gt_wait_for_fifo(struct drm_i915_private *dev_priv);
>  	((reg) != FORCEWAKE))
>  
>  #define __i915_read(x, y) \
> -static inline u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
> -	u##x val = 0; \
> -	if (NEEDS_FORCE_WAKE((dev_priv), (reg))) { \
> -		gen6_gt_force_wake_get(dev_priv); \
> -		val = read##y(dev_priv->regs + reg); \
> -		gen6_gt_force_wake_put(dev_priv); \
> -	} else { \
> -		val = read##y(dev_priv->regs + reg); \
> -	} \
> -	trace_i915_reg_rw(false, reg, val, sizeof(val)); \
> -	return val; \
> -}
> +	u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg);
>  
>  __i915_read(8, b)
>  __i915_read(16, w)
> @@ -1374,13 +1363,8 @@ __i915_read(64, q)
>  #undef __i915_read
>  
>  #define __i915_write(x, y) \
> -static inline void i915_write##x(struct drm_i915_private *dev_priv, u32 reg, u##x val) { \
> -	trace_i915_reg_rw(true, reg, val, sizeof(val)); \
> -	if (NEEDS_FORCE_WAKE((dev_priv), (reg))) { \
> -		__gen6_gt_wait_for_fifo(dev_priv); \
> -	} \
> -	write##y(val, dev_priv->regs + reg); \
> -}
> +	void i915_write##x(struct drm_i915_private *dev_priv, u32 reg, u##x val);
> +
>  __i915_write(8, b)
>  __i915_write(16, w)
>  __i915_write(32, l)

Acked-by: Ben Widawsky <ben@bwidawsk.net>

The forcewake increased size should have been fixed a bit with the
forcewake struct encapsulation patch I posted to intel-gfx mailing list.
Keith, if you take this, could you also look into that patch?
<1315951648-5380-1-git-send-email-ben@bwidawsk.net>
