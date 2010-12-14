Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab0LNQfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:35:14 -0500
Received: from mail.openrapids.net ([64.15.138.104]:51761 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759478Ab0LNQfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:35:13 -0500
Date: Tue, 14 Dec 2010 11:35:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
	lock semantics
Message-ID: <20101214163509.GB20667@Krystal>
References: <20101214162842.542421046@linux.com> <20101214162855.392020353@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214162855.392020353@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:34:28 up 20 days, 21:37,  4 users,  load average: 0.05, 0.07,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> Use cmpxchg instead of xchg to realize this_cpu_xchg.
> 
> xchg will cause LOCK overhead since LOCK is always implied but cmpxchg
> will not.
> 
> Baselines:
> 
> xchg()		= 18 cycles (no segment prefix, LOCK semantics)
> __this_cpu_xchg = 1 cycle
> 
> (simulated using this_cpu_read/write, two prefixes. Looks like the
> cpu can use loop optimization to get rid of most of the overhead)
> 
> Cycles before:
> 
> this_cpu_xchg	 = 37 cycles (segment prefix and LOCK (implied by xchg))
> 
> After:
> 
> this_cpu_xchg	= 11 cycle (using cmpxchg without lock semantics)

Cool! Thanks for benchmarking these, it's really worth it.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  arch/x86/include/asm/percpu.h |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/percpu.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-10 12:46:31.000000000 -0600
> +++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-10 13:25:21.000000000 -0600
> @@ -213,8 +213,9 @@ do {									\
>  })
>  
>  /*
> - * Beware: xchg on x86 has an implied lock prefix. There will be the cost of
> - * full lock semantics even though they are not needed.
> + * xchg is implemented using cmpxchg without a lock prefix. xchg is
> + * expensive due to the implied lock prefix. The processor cannot prefetch
> + * cachelines if xchg is used.
>   */
>  #define percpu_xchg_op(var, nval)					\
>  ({									\
> @@ -222,25 +223,33 @@ do {									\
>  	typeof(var) __new = (nval);					\
>  	switch (sizeof(var)) {						\
>  	case 1:								\
> -		asm("xchgb %2, "__percpu_arg(1)			\
> +		asm("\n1:mov "__percpu_arg(1)",%%al"			\
> +		    "\n\tcmpxchgb %2, "__percpu_arg(1)			\
> +		    "\n\tjnz 1b"					\
>  			    : "=a" (__ret), "+m" (var)			\
>  			    : "q" (__new)				\
>  			    : "memory");				\
>  		break;							\
>  	case 2:								\
> -		asm("xchgw %2, "__percpu_arg(1)			\
> +		asm("\n1:mov "__percpu_arg(1)",%%ax"			\
> +		    "\n\tcmpxchgw %2, "__percpu_arg(1)			\
> +		    "\n\tjnz 1b"					\
>  			    : "=a" (__ret), "+m" (var)			\
>  			    : "r" (__new)				\
>  			    : "memory");				\
>  		break;							\
>  	case 4:								\
> -		asm("xchgl %2, "__percpu_arg(1)			\
> +		asm("\n1:mov "__percpu_arg(1)",%%eax"			\
> +		    "\n\tcmpxchgl %2, "__percpu_arg(1)			\
> +		    "\n\tjnz 1b"					\
>  			    : "=a" (__ret), "+m" (var)			\
>  			    : "r" (__new)				\
>  			    : "memory");				\
>  		break;							\
>  	case 8:								\
> -		asm("xchgq %2, "__percpu_arg(1)			\
> +		asm("\n1:mov "__percpu_arg(1)",%%rax"			\
> +		    "\n\tcmpxchgq %2, "__percpu_arg(1)			\
> +		    "\n\tjnz 1b"					\
>  			    : "=a" (__ret), "+m" (var)			\
>  			    : "r" (__new)				\
>  			    : "memory");				\
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
