Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1FOIzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:55:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47715 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab1FOIzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jze4WbbEWkzHEzZaZq6HTpom0kHETKfIUyow2CewvmrM6v/Fi0kKisVTd2LjJZYld9
         piWpQ7iXxFOnEopmLYAdEADlfymoy69bxW32ED7y366fLgm3Lds4ZiazvxBKccoweVkW
         ZKJ1cUsxG0CNH+XGbcxqKJQXaW3Gk/1aNAN3E=
Date: Wed, 15 Jun 2011 10:55:12 +0200
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
Message-ID: <20110615085512.GO8141@htj.dyndns.org>
References: <20110601172543.437240675@linux.com>
 <20110601172614.173427964@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601172614.173427964@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph, Pekka.  Sorry about the delay.

On Wed, Jun 01, 2011 at 12:25:47PM -0500, Christoph Lameter wrote:
> Index: linux-2.6/arch/x86/include/asm/cmpxchg_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/cmpxchg_64.h	2011-06-01 11:01:05.002406114 -0500
> +++ linux-2.6/arch/x86/include/asm/cmpxchg_64.h	2011-06-01 11:01:48.222405834 -0500
> +#define cmpxchg_double(ptr, o1, o2, n1, n2)				\
> +({									\
> +	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
> +	VM_BUG_ON((unsigned long)(ptr) % 16);				\
> +	cmpxchg16b((ptr), (o1), (o2), (n1), (n2));			\
> +})
> +
> +#define cmpxchg_double_local(ptr, o1, o2, n1, n2)			\
> +({									\
> +	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
> +	VM_BUG_ON((unsigned long)(ptr) % 16);				\
> +	cmpxchg16b_local((ptr), (o1), (o2), (n1), (n2));		\
> +})

Do we really need cmpxchg16b*() macros separately?  Why not just
collapse them into cmpxchg_double*()?  Also, it would be better if we
have the same level of VM_BUG_ON() checks as in percpu cmpxchg_double
ops.  Maybe we should put them in a separate macro?

> +#define system_has_cmpxchg_double() cpu_has_cx16

Where's the fallback %false definition for the above feature macro for
archs which don't support cmpxchg_double?  Also, is system_has_*()
conventional?  Isn't arch_has_*() more conventional for this purpose?

>  #endif /* _ASM_X86_CMPXCHG_64_H */
> Index: linux-2.6/arch/x86/include/asm/cmpxchg_32.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/cmpxchg_32.h	2011-06-01 11:01:05.022406109 -0500
> +++ linux-2.6/arch/x86/include/asm/cmpxchg_32.h	2011-06-01 11:01:48.222405834 -0500
> @@ -280,4 +280,52 @@ static inline unsigned long cmpxchg_386(
>  
>  #endif
>  
> +#define cmpxchg8b(ptr, o1, o2, n1, n2)				\
> +({								\
> +	char __ret;						\
> +	__typeof__(o2) __dummy;					\
> +	__typeof__(*(ptr)) __old1 = (o1);			\
> +	__typeof__(o2) __old2 = (o2);				\
> +	__typeof__(*(ptr)) __new1 = (n1);			\
> +	__typeof__(o2) __new2 = (n2);				\
> +	asm volatile(LOCK_PREFIX "cmpxchg8b %2; setz %1"	\
> +		       : "=d"(__dummy), "=a" (__ret), "+m" (*ptr)\
> +		       : "a" (__old1), "d"(__old2),		\
> +		         "b" (__new1), "c" (__new2)		\
> +		       : "memory");				\
> +	__ret; })
> +
> +
> +#define cmpxchg8b_local(ptr, o1, o2, n1, n2)			\
> +({								\
> +	char __ret;						\
> +	__typeof__(o2) __dummy;					\
> +	__typeof__(*(ptr)) __old1 = (o1);			\
> +	__typeof__(o2) __old2 = (o2);				\
> +	__typeof__(*(ptr)) __new1 = (n1);			\
> +	__typeof__(o2) __new2 = (n2);				\
> +	asm volatile("cmpxchg8b %2; setz %1"			\
> +		       : "=d"(__dummy), "=a"(__ret), "+m" (*ptr)\
> +		       : "a" (__old), "d"(__old2),		\
> +		         "b" (__new1), "c" (__new2),		\
> +		       : "memory");				\
> +	__ret; })

Wouldn't it be better to use cmpxchg64() for cmpxchg_double()?

Another thing is that choosing different code path depending on
has_cmpxchg_double() would be quite messy and won't bode well with
many people.  I agree that fallback implementation would be heavier
for SMP safe operations but some archs already do that for cmpxchg
(forgot which one).  If we're gonna export this to generic code,
wouldn't it be better to implement proper generic fallbacks and
provide has_*() as hint?

Thank you.

-- 
tejun
