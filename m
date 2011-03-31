Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab1CaNz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:55:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:50086 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1CaNz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:55:57 -0400
Date: Thu, 31 Mar 2011 10:46:38 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH] perf report: add sort by file lines
Message-ID: <20110331134638.GA25095@ghostprotocols.net>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
 <1301392457.4859.74.camel@twins>
 <1301417155.3620.8.camel@localhost>
 <1301418183.2250.416.camel@laptop>
 <1301418404.2250.417.camel@laptop>
 <1301418533.2250.419.camel@laptop>
 <20110329174556.GC24129@ghostprotocols.net>
 <4D92818A.8020405@hitachi.com>
 <1301561155.14111.288.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301561155.14111.288.camel@minggr.sh.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 31, 2011 at 04:45:55PM +0800, Lin Ming escreveu:
> On Wed, 2011-03-30 at 09:04 +0800, Masami Hiramatsu wrote:
> > > foo:
> > > 	.cfi_startproc
> > > 	pushq	%rbp
> > > 	.cfi_def_cfa_offset 16
> > > 	movq	%rsp, %rbp
> > > 	.cfi_offset 6, -16
> > > 	.cfi_def_cfa_register 6
> > > 	movq	%rdi, -8(%rbp)
> > > 	movq	%rsi, -16(%rbp)
> > > 	movq	-8(%rbp), %rax    /* load foo arg from stack */
> > > 	movq	24(%rax), %rax    /* load foo->bar */
> > > 	movq	-16(%rbp), %rdx   /* load tmp arg from stack */
> > > 	movl	32(%rdx), %edx    /* load tmp->blah */
> > > 	movl	%edx, 20(%rax)    /* store bar->fubar */  <<==(1)
> > > 	leave
> > > 	ret
> > > 	.cfi_endproc
> > 
> > At (1), dwarf tells us the location of 'foo' is -8(%rbp) and 'tmp' is
> > -16(%rbp), but doesn't know to what 20(%rax) is mapped, because
> > foo->bar->fubar is not a real variable.
> 
> I am considering if it is possible to do "instruction unwind" to get a
> map from (temporarily used) register to a specific member of a data
> structure pointed by a pointer.
> 
> 4004a0: 	movq	-8(%rbp), %rax    /* load foo arg from stack */
> 4004a4:		movq	24(%rax), %rax    /* load foo->bar */
> 4004a8:		movq	-16(%rbp), %rdx   /* load tmp arg from stack */
> 4004ac:		movl	32(%rdx), %edx    /* load tmp->blah */
> 4004af:		movl	%edx, 20(%rax)    /* store bar->fubar */ 
> 
> foo: -8(%rbp)
> tmp: -16(%rbp)
> 
> Assume we are now at ip 4004af, from the instruction decoder, we know
> it's a store operation, and we want to find out what %rax is.
> 
> 1. unwind to 4004ac
>    Ignore this, because it does not touch %rax
> 
> 2. unwind to 4004a8
>    Ignore this, because it does not touch %rax
> 
> 3. unwind to 4004a4
>    20(%rax) => 20(24(%rax)), continue to unwind because we still
>    have no idea what %rax is
> 
> 4. unwind to 4004a0
>    20(24(%rax)) => 20(24(-8(%rbp))), stop unwind, because we now know
>    -8(%rbp) is foo.
> 
> So the original 20(%rax) is replace as 20(24(-8(%rbp))), and it means
> foo->bar->fubar
> 
> Does this make sense?

I think it does, so we do just like with annotation, but parsing objdump
-S output, is that what you're planning?

After we have the members we can do data annotation, in much the same
way we do with code annotation, i.e. augmenting pahole output.

- Arnaldo
