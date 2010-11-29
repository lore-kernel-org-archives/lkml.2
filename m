Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0K2TWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:22:42 -0500
Received: from mail.openrapids.net ([64.15.138.104]:44374 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751520Ab0K2TWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:22:40 -0500
Date: Mon, 29 Nov 2010 14:22:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 04/10] x86: Support for
	this_cpu_add,sub,dec,inc_return
Message-ID: <20101129192238.GD25610@Krystal>
References: <20101126210937.383047168@linux.com> <20101126210951.303044608@linux.com> <20101127150015.GE15365@Krystal> <alpine.DEB.2.00.1011291025410.3923@router.home> <20101129183333.GA25610@Krystal> <alpine.DEB.2.00.1011291244410.4836@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011291244410.4836@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:09:40 up 6 days, 12 min,  4 users,  load average: 1.14, 1.04,
	1.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Mon, 29 Nov 2010, Mathieu Desnoyers wrote:
> 
> > > > > +#define percpu_add_return_op(var, val)					\
> > > > > +({									\
> > > > > +	typedef typeof(var) pao_T__;					\
> > > > > +	typeof(var) pfo_ret__ = val;					\
> > > > > +	if (0) {							\
> > > > > +		pao_T__ pao_tmp__;					\
> > > > > +		pao_tmp__ = (val);					\
> > > > > +		(void)pao_tmp__;					\
> > > > > +	}								\
> > > >
> > > > OK, I'm dumb: why is the above needed ?
> > >
> > > Ensure that the compiler agrees that  *var and val are compatible. Taken
> > > over from percpu_add_op().
> >
> > Isn't that the purpose of __builtin_types_compatible_p(t1, t2) ?
> 
> We also have a __same_type() macro in linux/compiler.h... But if I use
> that the kernel build fails. I guess the check is too strict.

Ah, ok, so you don't mind if var and val have different types. You just want
the compiler to be able to cast one into the other without complaining.

Isn't it already checked by "typeof(var) pfo_ret__ = val;" ?

Which semantic do you expect when using different types for var and val ?

The assembly all acts on the following pfo_ret__ :

  typeof(var) pfo_ret__ = val;

But at the end, you return :

  pfo_ret__ + (val);

So if pfo_ret has a type smaller than val (e.g. unsigned short vs unsigned int),
unless I'm mistakened, the type returned by percpu_add_return_op will be an
unsigned int (the larger of the two), but the atomic operation is performed on
an unsigned short. This might cause confusion for the caller. Casting

  pfo_ret__ + (typeof(var)) (val);

might be appropriate.

Thanks,

Mathieu

> 
> ---
>  arch/x86/include/asm/percpu.h |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/percpu.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-11-29 12:46:50.000000000 -0600
> +++ linux-2.6/arch/x86/include/asm/percpu.h	2010-11-29 12:52:25.000000000 -0600
> @@ -127,11 +127,7 @@ do {									\
>  	typedef typeof(var) pao_T__;					\
>  	const int pao_ID__ = (__builtin_constant_p(val) &&		\
>  			      ((val) == 1 || (val) == -1)) ? (val) : 0;	\
> -	if (0) {							\
> -		pao_T__ pao_tmp__;					\
> -		pao_tmp__ = (val);					\
> -		(void)pao_tmp__;					\
> -	}								\
> +	BUILD_BUG_ON(!__same_type(var, val));				\
>  	switch (sizeof(var)) {						\
>  	case 1:								\
>  		if (pao_ID__ == 1)					\
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
