Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2GaFXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:23:23 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33915 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab2GaFXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 01:23:22 -0400
Date: Tue, 31 Jul 2012 10:52:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
 did it
Message-ID: <20120731052226.GA5087@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de>
 <20120730110658.GC11147@in.ibm.com>
 <20120730141638.GA5306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120730141638.GA5306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073105-9360-0000-0000-000008EECCCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-07-30 16:16:38]:

> On 07/30, Ananth N Mavinakayanahalli wrote:
> >
> > On Thu, Jul 26, 2012 at 05:20:43PM +0200, Sebastian Andrzej Siewior wrote:
> > > If someone is using single stepping over uprobe brackpoint then after
> > > we pass the uprobe single step, single stepping is disabled and the user
> > > who enebaled them in the first place does not know anything about this.
> > >
> > > This patch avoids enabling / disabling the single step mode if it is
> > > already enabled.
> >
> > This could happen any time 2 different entities call the
> > user_(en/dis)able_single_step() helpers on the same thread.
> 
> Yes. But nobody except ptrace should do use these helpers, I think.
> 
> > Wouldn't the right way to fix it be to teach these helpers
> > to honor what the TIF_SINGLESTEP
> 
> Well, I think uprobes should not use TIF_SINGLESTEP at all. This
> bit is (mostly) needed to handle the stepping over syscall. But
> I guess you didn't actually mean TIF_SINGLESTEP...
> 
> > flag setting was in the first place?
> 
> Perhaps, but I don't think so. If nothing else, we do not want
> to add the new counter/whatever in task_struct, while uprobes
> already has uprobe_task which can "remember" the state of _TF
> bit and more.
> 
> And this can't solve other problems. Suppose that gdb does
> PTRACE_SINGLESTEP but the original "popf" insn was already replaced
> by "int3", this will obviously confuse is_setting_trap_flag().
> 
> And we need the additional SIGTRAP from handle_singlestep().
> And we have more problems with DEBUGCTLMSR_BTF. And we do
> not want access_process_vm() from uprobes code.
> 
> So I think we need arch_uprobe_*able_step(struct uprobe_task *utask).
> Ignoring all problems except the one this patch tries to fix, x86
> can simply do:
> 
> 	arch_uprobe_enble_step(utask, struct arch_uprobe *auprobe)
> 	{
> 		utask->clear_tf =
> 			!(regs->flags & X86_EFLAGS_TF) &&
> 			(auprobe->insn != "popf");
> 		regs->flags |= X86_EFLAGS_TF;
> 	}
> 
> 	arch_uprobe_disable_step(utask)
> 	{
> 		if (utask->clear_tf)
> 			regs->flags &= ~X86_EFLAGS_TF;
> 	}
> 

We were using something similar to this approach. [though we were still
using TIF_SINGLESTEP flag]. However this was all changed based on
feedback from Roland and Peter.

Here is the pointer to the discussion.

https://lkml.org/lkml/2011/1/27/283

> Fortunately, we can never race with gdb/enable_step(), and we do
> not care why X86_EFLAGS_TF was set, and we do not care about
> TIF_SINGLESTEP/TIF_FORCED_TF.
> 
> However. This all needs more discussion (and help from Roland I guess).
> 
> Sebastian, I think your patch is simple and certainly makes the things
> better, just it is not correct (you already realized you can't use
> uprobe->flags) and it is not arch-friendly.
> 
> I'd suggest you to make 2 patches:
> 
> 	- 1/2 creates arch_uprobe_*_step(...) __weak helpers in
> 	      kernel/events/uprobes.c which simply call
> 	      user_*_single_step() and updates the callers
> 
> 	      Not strictly necessary, but imho makes sense...
> 
> 	- 2/2 adds the x86 implementation in arch/x86/kernel/uprobes.c
> 	      which still uses user_*_single_step() but checks
> 	      TIF_SINGLESTEP. As your patch does, but you should use
> 	      utask, not uprobe.
> 
> IOW, I simply suggest to make your patch x86-specific. Then we
> will try to do more fixes/improvements.
> 
> Sebastian, Ananth, what do you think?
> 
> Oleg.
> 

