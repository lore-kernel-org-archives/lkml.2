Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab0LHSRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:17:41 -0500
Received: from mail.openrapids.net ([64.15.138.104]:56718 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755502Ab0LHSRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:17:39 -0500
Date: Wed, 8 Dec 2010 13:17:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>, hpa@zytor.com
Subject: Re: [cpuops cmpxchg V1 2/4] x86: this_cpu_cmpxchg and
	this_cpu_xchg operations
Message-ID: <20101208181736.GC30693@Krystal>
References: <20101208175520.456864019@linux.com> <20101208175543.000201149@linux.com> <alpine.DEB.2.00.1012081207250.26943@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012081207250.26943@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:12:38 up 14 days, 23:15,  4 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> Alternate approach: Could also use cmpxchg for xchg..
> 
> 
> Subject: cpuops: Use cmpxchg for xchg to avoid lock semantics
> 
> Cmpxchg has a lower cycle count due to the implied lock semantics of xchg.
> 
> Simulate the xchg through cmpxchg for the cpu ops.

Hi Christoph,

Can you show if this provides savings in terms of:

- instruction cache footprint
- cycles required to run
- large-scale impact on the branch prediction buffers

Given that this targets per-cpu data only, the additional impact on cache-line
exchange traffic of using cmpxchg over xchg (cache-line not grabbed as exclusive
by the initial read) should not really matter.

I'm CCing Arjan and HPA, because they might have some interesting insight into
the performance impact of lock-prefixed xchg vs using local cmpxchg in a loop.

Thanks,

Mathieu


> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  arch/x86/include/asm/percpu.h |   68 +++++++-----------------------------------
>  1 file changed, 12 insertions(+), 56 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/percpu.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-08 11:43:50.000000000 -0600
> +++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-08 12:00:21.000000000 -0600
> @@ -212,48 +212,6 @@ do {									\
>  	ret__;								\
>  })
> 
> -/*
> - * Beware: xchg on x86 has an implied lock prefix. There will be the cost of
> - * full lock semantics even though they are not needed.
> - */
> -#define percpu_xchg_op(var, nval)					\
> -({									\
> -	typeof(var) __ret;						\
> -	typeof(var) __new = (nval);					\
> -	switch (sizeof(var)) {						\
> -	case 1:								\
> -		asm("xchgb %2, "__percpu_arg(1)			\
> -			    : "=a" (__ret), "+m" (var)			\
> -			    : "q" (__new)				\
> -			    : "memory");				\
> -		break;							\
> -	case 2:								\
> -		asm("xchgw %2, "__percpu_arg(1)			\
> -			    : "=a" (__ret), "+m" (var)			\
> -			    : "r" (__new)				\
> -			    : "memory");				\
> -		break;							\
> -	case 4:								\
> -		asm("xchgl %2, "__percpu_arg(1)			\
> -			    : "=a" (__ret), "+m" (var)			\
> -			    : "r" (__new)				\
> -			    : "memory");				\
> -		break;							\
> -	case 8:								\
> -		asm("xchgq %2, "__percpu_arg(1)			\
> -			    : "=a" (__ret), "+m" (var)			\
> -			    : "r" (__new)				\
> -			    : "memory");				\
> -		break;							\
> -	default: __bad_percpu_size();					\
> -	}								\
> -	__ret;								\
> -})
> -
> -/*
> - * cmpxchg has no such implied lock semantics as a result it is much
> - * more efficient for cpu local operations.
> - */
>  #define percpu_cmpxchg_op(var, oval, nval)				\
>  ({									\
>  	typeof(var) __ret;						\
> @@ -412,16 +370,6 @@ do {									\
>  #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
>  #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
> 
> -#define __this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define __this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define __this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define this_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define irqsafe_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define irqsafe_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define irqsafe_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
> -
>  #ifndef CONFIG_M386
>  #define __this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
>  #define __this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
> @@ -489,16 +437,24 @@ do {									\
>  #define __this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
>  #define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
> 
> -#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
> -#define irqsafe_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
> -
>  #define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
>  #define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
>  #define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
> 
>  #endif
> 
> +#define this_cpu_xchg(pcp, val) \
> +({									\
> +	typeof(val) __o;						\
> +	do {								\
> +	 	__o = __this_cpu_read(pcp);				\
> +	} while (this_cpu_cmpxchg(pcp, __o, val) != __o);		\
> +	__o;								\
> +})
> +
> +#define __this_cpu_xchg this_cpu_xchg
> +#define irqsafe_cpu_xchg this_cpu_xchg
> +
>  /* This is not atomic against other CPUs -- CPU preemption needs to be off */
>  #define x86_test_and_clear_bit_percpu(bit, var)				\
>  ({									\
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
