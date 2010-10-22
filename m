Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0JVBzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:55:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab0JVBzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:55:42 -0400
Date: Thu, 21 Oct 2010 18:55:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
Message-Id: <20101021185516.be13a83f.akpm@linux-foundation.org>
In-Reply-To: <20101021174536.26213ab7.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-17-git-send-email-david@fromorbit.com>
	<20100929215322.ff635d3e.akpm@linux-foundation.org>
	<20100930061039.GX5665@dastard>
	<20101016075510.GH19147@amd>
	<1287217748.2799.68.camel@edumazet-laptop>
	<20101016020744.366bd9c6.akpm@linux-foundation.org>
	<1287221475.2799.123.camel@edumazet-laptop>
	<1287238754.2799.376.camel@edumazet-laptop>
	<20101021153719.c8bde251.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1010211807280.3431@router.home>
	<20101021174536.26213ab7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 17:45:36 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> this_cpu_add_return() isn't really needed in this application.
> 
> {
> 	this_cpu_add(*fbc->counters, amount);
> 	if (unlikely(abs(this_cpu_read(*fbc->counters)) > fbc->batch))
> 		out_of_line_stuff();
> }	
> 
> will work just fine.

Did that.  Got alarmed at a few things.

The compiler cannot CSE the above code - it has to reload the percpu
base each time.  Doing it by hand:


{
	long *p;

	p = this_cpu_ptr(fbc->counters);
	*p += amount;
	if (unlikely(abs(*p) > fbc->batch))
		out_of_line_stuff();
}	

generates better code.

So this:

static __always_inline void percpu_counter_add_batch(struct percpu_counter *fbc,
						s64 amount, long batch)
{
	long *pcounter;

	preempt_disable();
	pcounter = this_cpu_ptr(fbc->counters);
	*pcounter += amount;
	if (unlikely(abs(*pcounter) >= batch))
		percpu_counter_handle_overflow(fbc);
	preempt_enable();
}

when compiling this:

--- a/lib/proportions.c~b
+++ a/lib/proportions.c
@@ -263,6 +263,11 @@ void __prop_inc_percpu(struct prop_descr
 	prop_put_global(pd, pg);
 }
 
+void foo(struct prop_local_percpu *pl)
+{
+	percpu_counter_add(&pl->events, 1);
+}
+
 /*
  * identical to __prop_inc_percpu, except that it limits this pl's fraction to
  * @frac/PROP_FRAC_BASE by ignoring events when this limit has been exceeded.

comes down to

.globl foo
	.type	foo, @function
foo:
	pushq	%rbp	#
	movslq	percpu_counter_batch(%rip),%rcx	# percpu_counter_batch, batch
	movq	96(%rdi), %rdx	# <variable>.counters, tcp_ptr__
	movq	%rsp, %rbp	#,
#APP
	add %gs:this_cpu_off, %rdx	# this_cpu_off, tcp_ptr__
#NO_APP
	movq	(%rdx), %rax	#* tcp_ptr__, D.11817
	incq	%rax	# D.11817
	movq	%rax, (%rdx)	# D.11817,* tcp_ptr__
	cqto
	xorq	%rdx, %rax	# tmp67, D.11817
	subq	%rdx, %rax	# tmp67, D.11817
	cmpq	%rcx, %rax	# batch, D.11817
	jl	.L33	#,
	call	percpu_counter_handle_overflow	#
.L33:
	leave
	ret


But what's really alarming is that the compiler (4.0.2) is cheerily
ignoring the inline directives and was generating out-of-line versions
of most of the percpu_counter.h functions into lib/proportions.s. 
That's rather a worry.

lib/proportions.o got rather larger as a result of inlining things and
it's not obvious that it's all a net benefit.

