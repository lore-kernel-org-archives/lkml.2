Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab2KOWXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:23:06 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44983 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2KOWXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:23:03 -0500
Date: Thu, 15 Nov 2012 17:22:59 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Rob Clark <rob.clark@linaro.org>
cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Rob Clark <rob@ti.com>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
In-Reply-To: <1353016879-15007-1-git-send-email-rob.clark@linaro.org>
Message-ID: <alpine.LFD.2.02.1211151722280.1238@xanadu.home>
References: <1353016879-15007-1-git-send-email-rob.clark@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Rob Clark wrote:

> From: Rob Clark <rob@ti.com>
> 
> A new atomic modeset/pageflip ioctl being developed in DRM requires
> get_user() to work for 64bit types (in addition to just put_user()).
> 
> v1: original
> v2: pass correct size to check_uaccess, and better handling of narrowing
>     double word read with __get_user_xb() (Russell King's suggestion)
> v3: explain in comment about why this works for narrowing fetch to 1,
>     2, or 4 byte type on ARM.
> 
> Signed-off-by: Rob Clark <rob@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/uaccess.h | 22 +++++++++++++++++++++-
>  arch/arm/lib/getuser.S         | 17 ++++++++++++++++-
>  2 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
> index 7e1f760..4cfa793 100644
> --- a/arch/arm/include/asm/uaccess.h
> +++ b/arch/arm/include/asm/uaccess.h
> @@ -100,6 +100,7 @@ static inline void set_fs(mm_segment_t fs)
>  extern int __get_user_1(void *);
>  extern int __get_user_2(void *);
>  extern int __get_user_4(void *);
> +extern int __get_user_8(void *);
>  
>  #define __GUP_CLOBBER_1	"lr", "cc"
>  #ifdef CONFIG_CPU_USE_DOMAINS
> @@ -108,6 +109,7 @@ extern int __get_user_4(void *);
>  #define __GUP_CLOBBER_2 "lr", "cc"
>  #endif
>  #define __GUP_CLOBBER_4	"lr", "cc"
> +#define __GUP_CLOBBER_8	"lr", "cc"
>  
>  #define __get_user_x(__r2,__p,__e,__l,__s)				\
>  	   __asm__ __volatile__ (					\
> @@ -118,11 +120,23 @@ extern int __get_user_4(void *);
>  		: "0" (__p), "r" (__l)					\
>  		: __GUP_CLOBBER_##__s)
>  
> +/*
> + * Narrowing a double-word get into a single 32bit word register, which works
> + * for 1, 2, or 4 byte types on ARM because there are no integer registers
> + * smaller than 32bit
> + */
> +#ifdef BIG_ENDIAN
> +#define __get_user_xb(__r2,__p,__e,__l,__s)				\
> +	__get_user_x(__r2,(uintptr_t)__p + 4,__e,__l,__s)
> +#else
> +#define __get_user_xb __get_user_x
> +#endif
> +
>  #define __get_user_check(x,p)							\
>  	({								\
>  		unsigned long __limit = current_thread_info()->addr_limit - 1; \
>  		register const typeof(*(p)) __user *__p asm("r0") = (p);\
> -		register unsigned long __r2 asm("r2");			\
> +		register typeof(x) __r2 asm("r2");			\
>  		register unsigned long __l asm("r1") = __limit;		\
>  		register int __e asm("r0");				\
>  		switch (sizeof(*(__p))) {				\
> @@ -135,6 +149,12 @@ extern int __get_user_4(void *);
>  		case 4:							\
>  			__get_user_x(__r2, __p, __e, __l, 4);		\
>  			break;						\
> +		case 8:							\
> +			if (sizeof((x)) < 8)				\
> +				__get_user_xb(__r2, __p, __e, __l, 4);	\
> +			else						\
> +				__get_user_x(__r2, __p, __e, __l, 8);	\
> +			break;						\
>  		default: __e = __get_user_bad(); break;			\
>  		}							\
>  		x = (typeof(*(p))) __r2;				\
> diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
> index 9b06bb4..ed98707 100644
> --- a/arch/arm/lib/getuser.S
> +++ b/arch/arm/lib/getuser.S
> @@ -18,7 +18,7 @@
>   * Inputs:	r0 contains the address
>   *		r1 contains the address limit, which must be preserved
>   * Outputs:	r0 is the error code
> - *		r2 contains the zero-extended value
> + *		r2, r3 contains the zero-extended value
>   *		lr corrupted
>   *
>   * No other registers must be altered.  (see <asm/uaccess.h>
> @@ -66,6 +66,19 @@ ENTRY(__get_user_4)
>  	mov	pc, lr
>  ENDPROC(__get_user_4)
>  
> +ENTRY(__get_user_8)
> +	check_uaccess r0, 8, r1, r2, __get_user_bad
> +#ifdef CONFIG_THUMB2_KERNEL
> +5: TUSER(ldr)	r2, [r0]
> +6: TUSER(ldr)	r3, [r0, #4]
> +#else
> +5: TUSER(ldr)	r2, [r0], #4
> +6: TUSER(ldr)	r3, [r0]
> +#endif
> +	mov	r0, #0
> +	mov	pc, lr
> +ENDPROC(__get_user_8)
> +
>  __get_user_bad:
>  	mov	r2, #0
>  	mov	r0, #-EFAULT
> @@ -77,4 +90,6 @@ ENDPROC(__get_user_bad)
>  	.long	2b, __get_user_bad
>  	.long	3b, __get_user_bad
>  	.long	4b, __get_user_bad
> +	.long	5b, __get_user_bad
> +	.long	6b, __get_user_bad
>  .popsection
> -- 
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
