Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1CaIq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:46:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:21202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1CaIqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:46:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,274,1299484800"; 
   d="scan'208";a="673640414"
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Lin Ming <ming.m.lin@intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <4D92818A.8020405@hitachi.com>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
	 <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost>
	 <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop>
	 <1301418533.2250.419.camel@laptop>
	 <20110329174556.GC24129@ghostprotocols.net>  <4D92818A.8020405@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 16:45:55 +0800
Message-ID: <1301561155.14111.288.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 09:04 +0800, Masami Hiramatsu wrote:
> (2011/03/30 2:45), Arnaldo Carvalho de Melo wrote:
> > Em Tue, Mar 29, 2011 at 07:08:53PM +0200, Peter Zijlstra escreveu:
> >> On Tue, 2011-03-29 at 19:06 +0200, Peter Zijlstra wrote:
> >>> On Tue, 2011-03-29 at 19:03 +0200, Peter Zijlstra wrote:
> >>>>> Is it an unwind of the call frame stack to find out what data member was
> >>>>> accessed?
> > 
> >>>> No need to unwind stacks, DWARF should have information on function
> >>>> local stack. It should be able to tell you the type of things like -8(%
> >>>> rbp). 
> > 
> >>> That is, we don't even have a life stack to unwind, so we simply cannot
> >>> unwind at all, but the debug information should be able to tell you the
> >>> type of whatever would live at a certain stack position if we were to
> >>> have a stack.
> > 
> >> Furthermore, I've now completely exhausted my knowledge of debuginfo and
> >> hope Masami and Arnaldo will help with further details ;-)
> > 
> > :-)
> > 
> > I think the place to look is 'perf probe', look for the way one
> > variable is translated to an expression passed to the kprobe_tracer, I
> > think you'll need the reverse operation.
> > 
> > Look at tools/perf/util/probe-finder.c, function find_variable() and
> > convert_variable_location().
> 
> Right, perf probe is available for looking up a variable at
> an address, however, since it just depends on the dwarf,
> we can just know the mapping from (actual) variables to
> locations (registers/stacks etc.)
> 
> It seems that Peter requires more than that, his request is
> getting a map from (temporarily used) register to a specific
> member of a data structure pointed by a pointer. But dwarf is
> not enough for that.
> 
> Peter gave us a good example of that.
> 
> > void foo(struct foo *foo, struct tmp *tmp)
> > {
> >         foo->bar->fubar = tmp->blah;
> > }
> >
> > foo:
> > 	.cfi_startproc
> > 	pushq	%rbp
> > 	.cfi_def_cfa_offset 16
> > 	movq	%rsp, %rbp
> > 	.cfi_offset 6, -16
> > 	.cfi_def_cfa_register 6
> > 	movq	%rdi, -8(%rbp)
> > 	movq	%rsi, -16(%rbp)
> > 	movq	-8(%rbp), %rax    /* load foo arg from stack */
> > 	movq	24(%rax), %rax    /* load foo->bar */
> > 	movq	-16(%rbp), %rdx   /* load tmp arg from stack */
> > 	movl	32(%rdx), %edx    /* load tmp->blah */
> > 	movl	%edx, 20(%rax)    /* store bar->fubar */  <<==(1)
> > 	leave
> > 	ret
> > 	.cfi_endproc
> 
> At (1), dwarf tells us the location of 'foo' is -8(%rbp) and 'tmp' is
> -16(%rbp), but doesn't know to what 20(%rax) is mapped, because
> foo->bar->fubar is not a real variable.

I am considering if it is possible to do "instruction unwind" to get a
map from (temporarily used) register to a specific member of a data
structure pointed by a pointer.

4004a0: 	movq	-8(%rbp), %rax    /* load foo arg from stack */
4004a4:		movq	24(%rax), %rax    /* load foo->bar */
4004a8:		movq	-16(%rbp), %rdx   /* load tmp arg from stack */
4004ac:		movl	32(%rdx), %edx    /* load tmp->blah */
4004af:		movl	%edx, 20(%rax)    /* store bar->fubar */ 

foo: -8(%rbp)
tmp: -16(%rbp)

Assume we are now at ip 4004af, from the instruction decoder, we know
it's a store operation, and we want to find out what %rax is.

1. unwind to 4004ac
   Ignore this, because it does not touch %rax

2. unwind to 4004a8
   Ignore this, because it does not touch %rax

3. unwind to 4004a4
   20(%rax) => 20(24(%rax)), continue to unwind because we still
   have no idea what %rax is

4. unwind to 4004a0
   20(24(%rax)) => 20(24(-8(%rbp))), stop unwind, because we now know
   -8(%rbp) is foo.

So the original 20(%rax) is replace as 20(24(-8(%rbp))), and it means
foo->bar->fubar

Does this make sense?

Thanks,
Lin Ming

> 
> So that what we need is a kind of the reverse compiler which generates
> intermediate code (a sequence of register assignments) from
> instruction code. That's not impossible task, but just hard and fun. :)
> For that purpose, we'll need an instruction decoder and an evaluator
> which allows us to trace the sequence of address dereferences.
> 
> Anyway, I'd recommend that we should start with just showing
> the corresponding "source line" of the address. It may be
> enough for some cases.
> 
> Thank you,
> 
> 


