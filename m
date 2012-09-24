Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab2IXJJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:09:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54459 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab2IXJJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:09:08 -0400
Date: Mon, 24 Sep 2012 14:38:58 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes: Kill set_swbp()->is_swbp_at_addr()
Message-ID: <20120924090858.GA2248@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120923201921.GA27424@redhat.com> <20120923201945.GA27446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120923201945.GA27446@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
x-cbid: 12092409-6078-0000-0000-00000FEBC08E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 10:19:45PM +0200, Oleg Nesterov wrote:
> A separate patch for better documentation.
> 
> set_swbp()->is_swbp_at_addr() is not needed for correctness, it is
> harmless to do the unnecessary __replace_page(old_page, new_page)
> when these 2 pages are identical.
> 
> And it can not be counted as optimization. mmap/register races are
> very unlikely, while in the likely case is_swbp_at_addr() adds the
> extra get_user_pages() even if the caller is uprobe_mmap(current->mm)
> and returns false.
> 
> Note also that the semantics/usage of is_swbp_at_addr() in uprobe.c
> is confusing. set_swbp() uses it to detect the case when this insn
> was already modified by uprobes, that is why it should always compare
> the opcode with UPROBE_SWBP_INSN even if the hardware (like powerpc)
> has other trap insns.

Agreed...

> It doesn't matter if this "int3" was in fact
> installed by gdb or application itself, we are going to "steal" this
> breakpoint anyway and execute the original insn from vm_file even if
> it no longer matches the memory.

Wouldn't this text make more sense:

It doesn't matter if this 'breakpoint' was in fact...

'int3' is still an x86 artifact.

On powerpc, we don't even get to install_breakpoint() ->set_swbp()
->is_swbp_at_addr() because arch_uprobe_analyze_insn() would've already
caused install_breakpoint() to return -ENOTSUPP.

> OTOH, handle_swbp()->find_active_uprobe() uses is_swbp_at_addr() to
> figure out whether we need to send SIGTRAP or not if we can not find
> uprobe, so in this case it should return true for all trap variants,
> not only for UPROBE_SWBP_INSN.

So, we will need a powerpc specific is_swbp_insn()... ok.

Ananth

