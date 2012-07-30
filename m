Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2G3OTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:19:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab2G3OTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:19:52 -0400
Date: Mon, 30 Jul 2012 16:16:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
	did it
Message-ID: <20120730141638.GA5306@redhat.com>
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de> <20120730110658.GC11147@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730110658.GC11147@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Ananth N Mavinakayanahalli wrote:
>
> On Thu, Jul 26, 2012 at 05:20:43PM +0200, Sebastian Andrzej Siewior wrote:
> > If someone is using single stepping over uprobe brackpoint then after
> > we pass the uprobe single step, single stepping is disabled and the user
> > who enebaled them in the first place does not know anything about this.
> >
> > This patch avoids enabling / disabling the single step mode if it is
> > already enabled.
>
> This could happen any time 2 different entities call the
> user_(en/dis)able_single_step() helpers on the same thread.

Yes. But nobody except ptrace should do use these helpers, I think.

> Wouldn't the right way to fix it be to teach these helpers
> to honor what the TIF_SINGLESTEP

Well, I think uprobes should not use TIF_SINGLESTEP at all. This
bit is (mostly) needed to handle the stepping over syscall. But
I guess you didn't actually mean TIF_SINGLESTEP...

> flag setting was in the first place?

Perhaps, but I don't think so. If nothing else, we do not want
to add the new counter/whatever in task_struct, while uprobes
already has uprobe_task which can "remember" the state of _TF
bit and more.

And this can't solve other problems. Suppose that gdb does
PTRACE_SINGLESTEP but the original "popf" insn was already replaced
by "int3", this will obviously confuse is_setting_trap_flag().

And we need the additional SIGTRAP from handle_singlestep().
And we have more problems with DEBUGCTLMSR_BTF. And we do
not want access_process_vm() from uprobes code.

So I think we need arch_uprobe_*able_step(struct uprobe_task *utask).
Ignoring all problems except the one this patch tries to fix, x86
can simply do:

	arch_uprobe_enble_step(utask, struct arch_uprobe *auprobe)
	{
		utask->clear_tf =
			!(regs->flags & X86_EFLAGS_TF) &&
			(auprobe->insn != "popf");
		regs->flags |= X86_EFLAGS_TF;
	}

	arch_uprobe_disable_step(utask)
	{
		if (utask->clear_tf)
			regs->flags &= ~X86_EFLAGS_TF;
	}

Fortunately, we can never race with gdb/enable_step(), and we do
not care why X86_EFLAGS_TF was set, and we do not care about
TIF_SINGLESTEP/TIF_FORCED_TF.




However. This all needs more discussion (and help from Roland I guess).

Sebastian, I think your patch is simple and certainly makes the things
better, just it is not correct (you already realized you can't use
uprobe->flags) and it is not arch-friendly.

I'd suggest you to make 2 patches:

	- 1/2 creates arch_uprobe_*_step(...) __weak helpers in
	      kernel/events/uprobes.c which simply call
	      user_*_single_step() and updates the callers

	      Not strictly necessary, but imho makes sense...

	- 2/2 adds the x86 implementation in arch/x86/kernel/uprobes.c
	      which still uses user_*_single_step() but checks
	      TIF_SINGLESTEP. As your patch does, but you should use
	      utask, not uprobe.

IOW, I simply suggest to make your patch x86-specific. Then we
will try to do more fixes/improvements.


Sebastian, Ananth, what do you think?

Oleg.

