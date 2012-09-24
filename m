Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2IXPVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:21:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab2IXPVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:21:48 -0400
Date: Mon, 24 Sep 2012 17:23:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes: Kill set_swbp()->is_swbp_at_addr()
Message-ID: <20120924152302.GA13098@redhat.com>
References: <20120923201945.GA27446@redhat.com> <1348477426.11847.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348477426.11847.6.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Peter Zijlstra wrote:
>
> On Sun, 2012-09-23 at 22:19 +0200, Oleg Nesterov wrote:
> > A separate patch for better documentation.
> >
> > set_swbp()->is_swbp_at_addr() is not needed for correctness, it is
> > harmless to do the unnecessary __replace_page(old_page, new_page)
> > when these 2 pages are identical.
> >
> > And it can not be counted as optimization. mmap/register races are
> > very unlikely, while in the likely case is_swbp_at_addr() adds the
> > extra get_user_pages() even if the caller is uprobe_mmap(current->mm)
> > and returns false.
>
> It does save a page of memory though...

No, it doesn't, I think.

If this page has int3 it is not file-backed, it was already COW'ed by
uprobes or gdb.

Note the !UPROBE_COPY_INSN code in install breakpoint which has another
is_swbp_insn(). Yes, this logic is not 100% correct and needs more fixes.

So it can only prevent the unnecessary alloc_page() + replace_page() +
free_page(old_page), but only in unlikely case.

And please note that 3/4 restores this optimization, but avoids the
extra get_user_pages(). This will be more important when we add the
filtering, uprobe_register() will need to call register_for_each_vma()
every time when the new consumer comes.

> > Note also that the semantics/usage of is_swbp_at_addr() in uprobe.c
> > is confusing. set_swbp() uses it to detect the case when this insn
> > was already modified by uprobes, that is why it should always compare
> > the opcode with UPROBE_SWBP_INSN even if the hardware (like powerpc)
> > has other trap insns. It doesn't matter if this "int3" was in fact
> > installed by gdb or application itself, we are going to "steal" this
> > breakpoint anyway and execute the original insn from vm_file even if
> > it no longer matches the memory.
> >
> > OTOH, handle_swbp()->find_active_uprobe() uses is_swbp_at_addr() to
> > figure out whether we need to send SIGTRAP or not if we can not find
> > uprobe, so in this case it should return true for all trap variants,
> > not only for UPROBE_SWBP_INSN.
> >
> > This patch removes set_swbp()->is_swbp_at_addr(), the next patches
> > will remove it from set_orig_insn() which is similar to set_swbp()
> > in this respect. So the only caller will be handle_swbp() and we
> > can make its semantics clear.
>
> This does leave me with the question of _why_ you're removing it..

Again, 3/4 restores this optimization, and imho this series can be
counted as a cleanup/simplification and makes sense anyway.

But the main reason is dufferent. Once again. Lets ignore the problems
with gdb which can install breakpoints too.


set_swbp() and set_orig_insn() use is_swbp_at_addr() to figure out
whether this opcode was modified by uprobes or not. So in this case
is_swbp_insn() has to compare the opcode with UPROBE_SWBP_INSN used
by set_swbp().

But handle_swbp()->find_active_uprobe()->is_swbp_at_addr() is different,
it needs to decide should we send SIGTRAP or not if uprobe was not
found. On x86 this is the same, but powerpc has other insns which
can trigger powerpc's do_int3() counterpart, so in this case
is_swbp_insn() should return true for all trap variants.

Oleg.

