Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0K0PAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:00:20 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41314 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752553Ab0K0PAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:00:17 -0500
Date: Sat, 27 Nov 2010 10:00:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 04/10] x86: Support for
	this_cpu_add,sub,dec,inc_return
Message-ID: <20101127150015.GE15365@Krystal>
References: <20101126210937.383047168@linux.com> <20101126210951.303044608@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126210951.303044608@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:58:53 up 3 days, 20:01,  3 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> Supply an implementation for x86 in order to generate more efficient code.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  arch/x86/include/asm/percpu.h |   50 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> Index: linux-2.6/arch/x86/include/asm/percpu.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-11-23 16:35:19.000000000 -0600
> +++ linux-2.6/arch/x86/include/asm/percpu.h	2010-11-23 16:36:05.000000000 -0600
> @@ -177,6 +177,45 @@ do {									\
>  	}								\
>  } while (0)
>  
> +
> +/*
> + * Add return operation
> + */
> +#define percpu_add_return_op(var, val)					\
> +({									\
> +	typedef typeof(var) pao_T__;					\
> +	typeof(var) pfo_ret__ = val;					\
> +	if (0) {							\
> +		pao_T__ pao_tmp__;					\
> +		pao_tmp__ = (val);					\
> +		(void)pao_tmp__;					\
> +	}								\

OK, I'm dumb: why is the above needed ?

> +	switch (sizeof(var)) {						\
> +	case 1:								\
> +		asm("xaddb %0, "__percpu_arg(1)				\
> +			    : "+q" (pfo_ret__), "+m" (var)		\
> +			    : : "memory");				\
> +		break;							\
> +	case 2:								\
> +		asm("xaddw %0, "__percpu_arg(1)				\
> +			    : "+r" (pfo_ret__), "+m" (var)		\
> +			    : : "memory");				\
> +		break;							\
> +	case 4:								\
> +		asm("xaddl %0, "__percpu_arg(1)				\
> +			    : "+r"(pfo_ret__), "+m" (var)		\
> +			    : : "memory");				\
> +		break;							\
> +	case 8:								\
> +		asm("xaddq %0, "__percpu_arg(1)				\
> +			    : "+re" (pfo_ret__),  "+m" (var)		\
> +			    : : "memory");				\
> +		break;							\
> +	default: __bad_percpu_size();					\
> +	}								\
> +	pfo_ret__ + (val);						\
> +})
> +
>  #define percpu_from_op(op, var, constraint)		\
>  ({							\
>  	typeof(var) pfo_ret__;				\
> @@ -300,6 +339,14 @@ do {									\
>  #define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
>  #define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)

(pcp) -> pcp. Same for other similar cases below.

Thanks,

Mathieu

>  
> +#ifndef CONFIG_M386
> +#define __this_cpu_add_return_1(pcp, val)	percpu_add_return_op((pcp), val)
> +#define __this_cpu_add_return_2(pcp, val)	percpu_add_return_op((pcp), val)
> +#define __this_cpu_add_return_4(pcp, val)	percpu_add_return_op((pcp), val)
> +#define this_cpu_add_return_1(pcp, val)		percpu_add_return_op((pcp), val)
> +#define this_cpu_add_return_2(pcp, val)		percpu_add_return_op((pcp), val)
> +#define this_cpu_add_return_4(pcp, val)		percpu_add_return_op((pcp), val)
> +#endif
>  /*
>   * Per cpu atomic 64 bit operations are only available under 64 bit.
>   * 32 bit must fall back to generic operations.
> @@ -324,6 +371,9 @@ do {									\
>  #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
>  #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
>  
> +#define __this_cpu_add_return_8(pcp, val)	percpu_add_return_op((pcp), val)
> +#define this_cpu_add_return_8(pcp, val)	percpu_add_return_op((pcp), val)
> +
>  #endif
>  
>  /* This is not atomic against other CPUs -- CPU preemption needs to be off */
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
