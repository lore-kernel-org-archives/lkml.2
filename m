Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1C2Qp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:45:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:12203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1C2Qp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:45:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,263,1299484800"; 
   d="scan'208";a="726549061"
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1301392457.4859.74.camel@twins>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
	 <1301392457.4859.74.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 00:45:55 +0800
Message-Id: <1301417155.3620.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 17:54 +0800, Peter Zijlstra wrote:
> On Tue, 2011-03-29 at 17:32 +0800, Lin Ming wrote:
> > 
> > Peter suggested to reverse map the reported IP (PEBS + fixup)
> > to a data access using dwarf info.
> > So I wrote this patch to see if the direction is right. 
> 
> I'm not sure this is quite the same thing, I'm not arguing this might
> not be useful, but this is not about data access.
> 
> Suppose you have a line like:
> 
>   foo->bar->fubar = tmp->blah;
> 
> There's 3 indirections there, a line number doesn't even get you close
> to knowing what data access triggered the event.
> 
> struct bar {
>         int poekoe[5];
>         int fubar;
> };
> 
> struct foo {
>         long poekoe[3];
>         struct bar *bar;
> };
> 
> struct tmp {
>         long poekoe[4];
>         int blah;
> };
> 
> void foo(struct foo *foo, struct tmp *tmp)
> {
>         foo->bar->fubar = tmp->blah;
> }
> 
> Which gives (somewhat simplified):
> 
> foo:
> 	.cfi_startproc
> 	pushq	%rbp
> 	.cfi_def_cfa_offset 16
> 	movq	%rsp, %rbp
> 	.cfi_offset 6, -16
> 	.cfi_def_cfa_register 6
> 	movq	%rdi, -8(%rbp)
> 	movq	%rsi, -16(%rbp)
> 	movq	-8(%rbp), %rax    /* load foo arg from stack */
> 	movq	24(%rax), %rax    /* load foo->bar */
> 	movq	-16(%rbp), %rdx   /* load tmp arg from stack */
> 	movl	32(%rdx), %edx    /* load tmp->blah */
> 	movl	%edx, 20(%rax)    /* store bar->fubar */
> 	leave
> 	ret
> 	.cfi_endproc

I need to have a close look at how dwarf cfi thing works.

> 
> where I annotated the various moves with C comments.
> 
> Now depending on what exact IP you get using PEBS+fixup you could using
> DWARF bits generate similar deductions from the code as I did in those
> comments and thus know exactly what data member was accessed and how
> (read/write).

Is it an unwind of the call frame stack to find out what data member was
accessed?
How to know the access type(read or write)?

> 
> With that data you could then borrow some pahole code and annotate the
> various data structures to illustrate read/write distributions, which
> can then be used as input for data-reorder.

Could you explain a bit more about this?

Thanks,
Lin Ming


