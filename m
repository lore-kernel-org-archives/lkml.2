Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab0LNQom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:44:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37098 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759608Ab0LNQok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:44:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GMhfQ8nPqfTiA7ux/L8eNHGmGu1VpFC47pfbr0V7NbBS3j+7qyq3hY7rfFidJP+F3Z
         elSxe6HmIkfc9mWYbeW2ngvjKE36r+f3uOjRG/gww/DjYEZ0fowWv8kWhDkKuv+tgUir
         BgD45+HQGhzwtF3Emnu1oMRa67ktfAXUNyGWM=
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101214162855.392020353@linux.com>
References: <20101214162842.542421046@linux.com>
	 <20101214162855.392020353@linux.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 17:44:32 +0100
Message-ID: <1292345072.5934.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 14 décembre 2010 à 10:28 -0600, Christoph Lameter a écrit :
> pièce jointe document texte brut (cpuops_xchg_with_cmpxchg)
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


You should use the fact that the failed cmpxchg loads in al/ax/eax/rax
the current value, so :

	"\n\tmov "__percpu_arg(1)",%%al"
	"\n1:\tcmpxchgb %2, "__percpu_arg(1)
	"\n\tjnz 1b"

(No need to reload the value again)


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


