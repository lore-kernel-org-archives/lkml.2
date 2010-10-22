Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0JVB66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:58:58 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10097 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037Ab0JVB65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:58:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADqNwEx5Ldx0/2dsb2JhbAChXnK+Z4VKBI9O
Date: Fri, 22 Oct 2010 12:58:45 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
Message-ID: <20101022015845.GA6265@amd>
References: <20100930061039.GX5665@dastard>
 <20101016075510.GH19147@amd>
 <1287217748.2799.68.camel@edumazet-laptop>
 <20101016020744.366bd9c6.akpm@linux-foundation.org>
 <1287221475.2799.123.camel@edumazet-laptop>
 <1287238754.2799.376.camel@edumazet-laptop>
 <20101021153719.c8bde251.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1010211807280.3431@router.home>
 <20101021174536.26213ab7.akpm@linux-foundation.org>
 <20101021185516.be13a83f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021185516.be13a83f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 06:55:16PM -0700, Andrew Morton wrote:
> On Thu, 21 Oct 2010 17:45:36 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > this_cpu_add_return() isn't really needed in this application.
> > 
> > {
> > 	this_cpu_add(*fbc->counters, amount);
> > 	if (unlikely(abs(this_cpu_read(*fbc->counters)) > fbc->batch))
> > 		out_of_line_stuff();
> > }	
> > 
> > will work just fine.
> 
> Did that.  Got alarmed at a few things.
> 
> The compiler cannot CSE the above code - it has to reload the percpu
> base each time.  Doing it by hand:
> 
> 
> {
> 	long *p;
> 
> 	p = this_cpu_ptr(fbc->counters);
> 	*p += amount;
> 	if (unlikely(abs(*p) > fbc->batch))
> 		out_of_line_stuff();
> }	
> 
> generates better code.
> 
> So this:
> 
> static __always_inline void percpu_counter_add_batch(struct percpu_counter *fbc,
> 						s64 amount, long batch)
> {
> 	long *pcounter;
> 
> 	preempt_disable();
> 	pcounter = this_cpu_ptr(fbc->counters);
> 	*pcounter += amount;
> 	if (unlikely(abs(*pcounter) >= batch))
> 		percpu_counter_handle_overflow(fbc);
> 	preempt_enable();
> }
> 
> when compiling this:
> 
> --- a/lib/proportions.c~b
> +++ a/lib/proportions.c
> @@ -263,6 +263,11 @@ void __prop_inc_percpu(struct prop_descr
>  	prop_put_global(pd, pg);
>  }
>  
> +void foo(struct prop_local_percpu *pl)
> +{
> +	percpu_counter_add(&pl->events, 1);
> +}
> +
>  /*
>   * identical to __prop_inc_percpu, except that it limits this pl's fraction to
>   * @frac/PROP_FRAC_BASE by ignoring events when this limit has been exceeded.
> 
> comes down to
> 
> .globl foo
> 	.type	foo, @function
> foo:
> 	pushq	%rbp	#
> 	movslq	percpu_counter_batch(%rip),%rcx	# percpu_counter_batch, batch
> 	movq	96(%rdi), %rdx	# <variable>.counters, tcp_ptr__
> 	movq	%rsp, %rbp	#,
> #APP
> 	add %gs:this_cpu_off, %rdx	# this_cpu_off, tcp_ptr__
> #NO_APP
> 	movq	(%rdx), %rax	#* tcp_ptr__, D.11817
> 	incq	%rax	# D.11817
> 	movq	%rax, (%rdx)	# D.11817,* tcp_ptr__
> 	cqto
> 	xorq	%rdx, %rax	# tmp67, D.11817
> 	subq	%rdx, %rax	# tmp67, D.11817
> 	cmpq	%rcx, %rax	# batch, D.11817
> 	jl	.L33	#,
> 	call	percpu_counter_handle_overflow	#
> .L33:
> 	leave
> 	ret
> 
> 
> But what's really alarming is that the compiler (4.0.2) is cheerily
> ignoring the inline directives and was generating out-of-line versions
> of most of the percpu_counter.h functions into lib/proportions.s. 
> That's rather a worry.

You you have the "ignore inlining" and "compile for size" turned
on? They often suck.

