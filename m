Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2JFGyq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 02:54:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53846 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2JFGyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 02:54:44 -0400
Date: Sat, 6 Oct 2012 12:25:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes: Kill set_swbp()->is_swbp_at_addr()
Message-ID: <20121006065511.GC27781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120923201921.GA27424@redhat.com>
 <20120923201945.GA27446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120923201945.GA27446@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12100606-3534-0000-0000-00000D8050F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-23 22:19:45]:

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
> has other trap insns. It doesn't matter if this "int3" was in fact
> installed by gdb or application itself, we are going to "steal" this
> breakpoint anyway and execute the original insn from vm_file even if
> it no longer matches the memory.
> 
> OTOH, handle_swbp()->find_active_uprobe() uses is_swbp_at_addr() to
> figure out whether we need to send SIGTRAP or not if we can not find
> uprobe, so in this case it should return true for all trap variants,
> not only for UPROBE_SWBP_INSN.
> 
> This patch removes set_swbp()->is_swbp_at_addr(), the next patches
> will remove it from set_orig_insn() which is similar to set_swbp()
> in this respect. So the only caller will be handle_swbp() and we
> can make its semantics clear.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

