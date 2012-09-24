Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2IXJEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:04:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41329 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2IXJEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:04:04 -0400
Message-ID: <1348477426.11847.6.camel@twins>
Subject: Re: [PATCH 1/4] uprobes: Kill set_swbp()->is_swbp_at_addr()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Sep 2012 11:03:46 +0200
In-Reply-To: <20120923201945.GA27446@redhat.com>
References: <20120923201945.GA27446@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-23 at 22:19 +0200, Oleg Nesterov wrote:
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

It does save a page of memory though...

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

This does leave me with the question of _why_ you're removing it.. the
above says what it does, and maybe gives a clue as to why you think it
is superfluous but I think its better to be clear on this.
