Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2B0Rxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:53:39 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55825 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2B0Rxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:53:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dave.martin@linaro.org designates 10.180.14.73 as permitted sender) smtp.mail=dave.martin@linaro.org
Date: Mon, 27 Feb 2012 17:53:27 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Ian.Campbell@citrix.com, arnd@arndb.de,
        catalin.marinas@arm.com, david.vrabel@citrix.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
Message-ID: <20120227175327.GA2023@linaro.org>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 05:48:22PM +0000, Stefano Stabellini wrote:
> We need a register to pass the hypercall number because we might not
> know it at compile time and HVC only takes an immediate argument.
> 
> Among the available registers r12 seems to be the best choice because it
> is defined as "intra-procedure call scratch register".

This would be massively simplified if you didn't try to inline the HVC.
Does it really need to be inline?

> 
> Use the ISS to pass an hypervisor specific tag.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: kvm@vger.kernel.org
> ---
>  arch/arm/include/asm/xen/hypercall.h |   87 +++++++++++++++++++---------------
>  1 files changed, 48 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
> index 404e63f0..04eba1c 100644
> --- a/arch/arm/include/asm/xen/hypercall.h
> +++ b/arch/arm/include/asm/xen/hypercall.h
> @@ -33,13 +33,17 @@
>  #ifndef _ASM_ARM_XEN_HYPERCALL_H
>  #define _ASM_ARM_XEN_HYPERCALL_H
>  
> -#define __HVC_IMM(name)	"( " #name " & 0xf) + "	  \
> -			    "((" #name " << 4) & 0xfff00)"
> +#include <xen/interface/xen.h>
> +#include <asm/errno.h>
>  
> -#define ____HYPERCALL(name) ".word 0xe1400070 + " __HVC_IMM(name)
> -#define __HYPERCALL(name) ____HYPERCALL(__HYPERVISOR_##name)
> +#define XEN_HYPERCALL_TAG  "0XEA1"
> +
> +#define __HVC_IMM(tag)	"( " tag " & 0xf) + "	  \
> +			    "((" tag " << 4) & 0xfff00)"
> +#define __HYPERCALL ".word 0xe1400070 + " __HVC_IMM(XEN_HYPERCALL_TAG)

Please, do not do this.  It won't work in Thumb, where the encodings are
different.

It is reasonable to expect anyone building Xen to have reasonably new
tools, you you can justifiably use

AFLAGS_thisfile.o := -Wa,-march=armv7-a+virt

in the Makefile and just use the hvc instruction directly.


Of course, this is only practical if the HVC invocation is not inlined.
If we can't avoid macro-ising HVC, we should do it globally, not locally
to the Xen code.  That way we at least keep all the horror in one place.

Cheers
---Dave

>  
>  #define __HYPERCALL_RETREG	"r0"
> +#define __HYPERCALL_NUMBER	"r12"
>  #define __HYPERCALL_ARG1REG	"r0"
>  #define __HYPERCALL_ARG2REG	"r1"
>  #define __HYPERCALL_ARG3REG	"r2"
> @@ -48,30 +52,32 @@
>  
>  #define __HYPERCALL_DECLS						\
>  	register unsigned long __res  asm(__HYPERCALL_RETREG);		\
> +	register unsigned long __num  asm(__HYPERCALL_NUMBER) = __num; \
>  	register unsigned long __arg1 asm(__HYPERCALL_ARG1REG) = __arg1; \
>  	register unsigned long __arg2 asm(__HYPERCALL_ARG2REG) = __arg2; \
>  	register unsigned long __arg3 asm(__HYPERCALL_ARG3REG) = __arg3; \
>  	register unsigned long __arg4 asm(__HYPERCALL_ARG4REG) = __arg4; \
>  	register unsigned long __arg5 asm(__HYPERCALL_ARG5REG) = __arg5;
>  
> -#define __HYPERCALL_0PARAM	"=r" (__res)
> +#define __HYPERCALL_0PARAM	"=r" (__res), "+r" (__num)
>  #define __HYPERCALL_1PARAM	__HYPERCALL_0PARAM, "+r" (__arg1)
>  #define __HYPERCALL_2PARAM	__HYPERCALL_1PARAM, "+r" (__arg2)
>  #define __HYPERCALL_3PARAM	__HYPERCALL_2PARAM, "+r" (__arg3)
>  #define __HYPERCALL_4PARAM	__HYPERCALL_3PARAM, "+r" (__arg4)
>  #define __HYPERCALL_5PARAM	__HYPERCALL_4PARAM, "+r" (__arg5)
>  
> -#define __HYPERCALL_0ARG()
> -#define __HYPERCALL_1ARG(a1)						\
> -	__HYPERCALL_0ARG()		__arg1 = (unsigned long)(a1);
> -#define __HYPERCALL_2ARG(a1,a2)						\
> -	__HYPERCALL_1ARG(a1)		__arg2 = (unsigned long)(a2);
> -#define __HYPERCALL_3ARG(a1,a2,a3)					\
> -	__HYPERCALL_2ARG(a1,a2)		__arg3 = (unsigned long)(a3);
> -#define __HYPERCALL_4ARG(a1,a2,a3,a4)					\
> -	__HYPERCALL_3ARG(a1,a2,a3)	__arg4 = (unsigned long)(a4);
> -#define __HYPERCALL_5ARG(a1,a2,a3,a4,a5)				\
> -	__HYPERCALL_4ARG(a1,a2,a3,a4)	__arg5 = (unsigned long)(a5);
> +#define __HYPERCALL_0ARG(hypercall)						\
> +	__num = (unsigned long)hypercall;
> +#define __HYPERCALL_1ARG(hypercall,a1)						\
> +	__HYPERCALL_0ARG(hypercall)		__arg1 = (unsigned long)(a1);
> +#define __HYPERCALL_2ARG(hypercall,a1,a2)						\
> +	__HYPERCALL_1ARG(hypercall,a1)		__arg2 = (unsigned long)(a2);
> +#define __HYPERCALL_3ARG(hypercall,a1,a2,a3)					\
> +	__HYPERCALL_2ARG(hypercall,a1,a2)		__arg3 = (unsigned long)(a3);
> +#define __HYPERCALL_4ARG(hypercall,a1,a2,a3,a4)					\
> +	__HYPERCALL_3ARG(hypercall,a1,a2,a3)	__arg4 = (unsigned long)(a4);
> +#define __HYPERCALL_5ARG(hypercall,a1,a2,a3,a4,a5)				\
> +	__HYPERCALL_4ARG(hypercall,a1,a2,a3,a4)	__arg5 = (unsigned long)(a5);
>  
>  #define __HYPERCALL_CLOBBER5	"memory"
>  #define __HYPERCALL_CLOBBER4	__HYPERCALL_CLOBBER5, __HYPERCALL_ARG5REG
> @@ -80,102 +86,105 @@
>  #define __HYPERCALL_CLOBBER1	__HYPERCALL_CLOBBER2, __HYPERCALL_ARG2REG
>  #define __HYPERCALL_CLOBBER0	__HYPERCALL_CLOBBER1, __HYPERCALL_ARG1REG
>  
> -#define _hypercall0(type, name)						\
> +#define _hypercall0(type, hypercall)						\
>  ({									\
>  	__HYPERCALL_DECLS;						\
> -	__HYPERCALL_0ARG();						\
> -	asm volatile (__HYPERCALL(name)					\
> +	__HYPERCALL_0ARG(hypercall);						\
> +	asm volatile (__HYPERCALL					\
>  		      : __HYPERCALL_0PARAM				\
>  		      : 						\
>  		      : __HYPERCALL_CLOBBER0);				\
>  	(type)__res;							\
>  })
>  
> -#define _hypercall1(type, name, a1)					\
> +#define _hypercall1(type, hypercall, a1)					\
>  ({									\
>  	__HYPERCALL_DECLS;						\
> -	__HYPERCALL_1ARG(a1);						\
> -	asm volatile (__HYPERCALL(name)					\
> +	__HYPERCALL_1ARG(hypercall, a1);						\
> +	asm volatile (__HYPERCALL					\
>  		      : __HYPERCALL_1PARAM				\
>  		      : 						\
>  		      : __HYPERCALL_CLOBBER1);				\
>  	(type)__res;							\
>  })
>  
> -#define _hypercall2(type, name, a1, a2)					\
> +#define _hypercall2(type, hypercall, a1, a2)					\
>  ({									\
>  	__HYPERCALL_DECLS;						\
> -	__HYPERCALL_2ARG(a1, a2);					\
> -	asm volatile (__HYPERCALL(name)					\
> +	__HYPERCALL_2ARG(hypercall, a1, a2);					\
> +	asm volatile (__HYPERCALL					\
>  		      : __HYPERCALL_2PARAM				\
>  		      : 						\
>  		      : __HYPERCALL_CLOBBER2);				\
>  	(type)__res;							\
>  })
>  
> -#define _hypercall3(type, name, a1, a2, a3)				\
> +#define _hypercall3(type, hypercall, a1, a2, a3)				\
>  ({									\
>  	__HYPERCALL_DECLS;						\
> -	__HYPERCALL_3ARG(a1, a2, a3);					\
> -	asm volatile (__HYPERCALL(name)					\
> +	__HYPERCALL_3ARG(hypercall, a1, a2, a3);					\
> +	asm volatile (__HYPERCALL					\
>  		      : __HYPERCALL_3PARAM				\
>  		      : 						\
>  		      : __HYPERCALL_CLOBBER3);				\
>  	(type)__res;							\
>  })
>  
> -#define _hypercall4(type, name, a1, a2, a3, a4)				\
> +#define _hypercall4(type, hypercall, a1, a2, a3, a4)				\
>  ({									\
>  	__HYPERCALL_DECLS;						\
> -	__HYPERCALL_4ARG(a1, a2, a3, a4);				\
> -	asm volatile (__HYPERCALL(name)					\
> +	__HYPERCALL_4ARG(hypercall, a1, a2, a3, a4);				\
> +	asm volatile (__HYPERCALL					\
>  		      : __HYPERCALL_4PARAM				\
>  		      : 						\
>  		      : __HYPERCALL_CLOBBER4);				\
>  	(type)__res;							\
>  })
>  
> -#define _hypercall5(type, name, a1, a2, a3, a4, a5)			\
> +#define _hypercall5(type, hypercall, a1, a2, a3, a4, a5)			\
>  ({									\
>  	__HYPERCALL_DECLS;						\
> -	__HYPERCALL_5ARG(a1, a2, a3, a4, a5);				\
> -	asm volatile (__HYPERCALL(name)					\
> +	__HYPERCALL_5ARG(hypercall, a1, a2, a3, a4, a5);				\
> +	asm volatile (__HYPERCALL					\
>  		      : __HYPERCALL_5PARAM				\
>  		      : 						\
>  		      : __HYPERCALL_CLOBBER5);				\
>  	(type)__res;							\
>  })
>  
> +#define HYPERCALL(name) \
> +	(__HYPERVISOR_##name)
> +
>  /* -- Hypercall definitions go below -- */
>  
>  static inline int
>  HYPERVISOR_xen_version(int cmd, void *arg)
>  {
> -	return _hypercall2(int, xen_version, cmd, arg);
> +	return _hypercall2(int, HYPERCALL(xen_version), cmd, arg);
>  }
>  
>  static inline int
>  HYPERVISOR_console_io(int cmd, int count, char *str)
>  {
> -	return _hypercall3(int, console_io, cmd, count, str);
> +	return _hypercall3(int, HYPERCALL(console_io), cmd, count, str);
>  }
>  
>  static inline int
>  HYPERVISOR_grant_table_op(unsigned int cmd, void *uop, unsigned int count)
>  {
> -	return _hypercall3(int, grant_table_op, cmd, uop, count);
> +	return _hypercall3(int, HYPERCALL(grant_table_op), cmd, uop, count);
>  }
>  
>  static inline int
>  HYPERVISOR_sched_op(int cmd, void *arg)
>  {
> -	return _hypercall2(int, sched_op, cmd, arg);
> +	return _hypercall2(int, HYPERCALL(sched_op), cmd, arg);
>  }
>  
>  static inline int
>  HYPERVISOR_event_channel_op(int cmd, void *arg)
>  {
> -	return _hypercall2(int, event_channel_op, cmd, arg);
> +	return _hypercall2(int, HYPERCALL(event_channel_op), cmd, arg);
>  }
>  
>  #endif /* _ASM_ARM_XEN_HYPERCALL_H */
> -- 
> 1.7.2.5
> 
> 
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
