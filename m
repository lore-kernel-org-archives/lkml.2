Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab1C2Jyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:54:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1C2Jyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:54:44 -0400
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1301391136.14111.98.camel@minggr.sh.intel.com>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Mar 2011 11:54:17 +0200
Message-ID: <1301392457.4859.74.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 17:32 +0800, Lin Ming wrote:
> 
> Peter suggested to reverse map the reported IP (PEBS + fixup)
> to a data access using dwarf info.
> So I wrote this patch to see if the direction is right. 

I'm not sure this is quite the same thing, I'm not arguing this might
not be useful, but this is not about data access.

Suppose you have a line like:

  foo->bar->fubar = tmp->blah;

There's 3 indirections there, a line number doesn't even get you close
to knowing what data access triggered the event.

struct bar {
        int poekoe[5];
        int fubar;
};

struct foo {
        long poekoe[3];
        struct bar *bar;
};

struct tmp {
        long poekoe[4];
        int blah;
};

void foo(struct foo *foo, struct tmp *tmp)
{
        foo->bar->fubar = tmp->blah;
}

Which gives (somewhat simplified):

foo:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax    /* load foo arg from stack */
	movq	24(%rax), %rax    /* load foo->bar */
	movq	-16(%rbp), %rdx   /* load tmp arg from stack */
	movl	32(%rdx), %edx    /* load tmp->blah */
	movl	%edx, 20(%rax)    /* store bar->fubar */
	leave
	ret
	.cfi_endproc

where I annotated the various moves with C comments.

Now depending on what exact IP you get using PEBS+fixup you could using
DWARF bits generate similar deductions from the code as I did in those
comments and thus know exactly what data member was accessed and how
(read/write).

With that data you could then borrow some pahole code and annotate the
various data structures to illustrate read/write distributions, which
can then be used as input for data-reorder.


