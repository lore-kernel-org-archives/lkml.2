Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2IGPBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:01:08 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41499 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2IGPBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:01:05 -0400
Date: Fri, 7 Sep 2012 20:27:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: Introduce
 arch_uprobe_enable/disable_step()
Message-ID: <20120907145737.GN30238@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120903152525.GA9028@redhat.com>
 <20120903152559.GA9054@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120903152559.GA9054@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12090714-0260-0000-0000-000001D06453
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-03 17:25:59]:

> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> As Oleg pointed out in [0] uprobe should not use the ptrace interface
> for enabling/disabling single stepping.
> 
> [0] http://lkml.kernel.org/20120730141638.GA5306@redhat.com

I think the link should be 
http://lkml.kernel.org/r/20120730141638.GA5306@redhat.com


> 
> Add the new "__weak arch" helpers which simply call user_*_single_step()
> as a preparation. This is only needed to not break the powerpc port, we
> will fold this logic into arch_uprobe_pre/post_xol() hooks later.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  include/linux/uprobes.h |    2 ++
>  kernel/events/uprobes.c |   14 ++++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 6d4fe79..e6f0331 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -112,6 +112,8 @@ extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
>  extern void uprobe_free_utask(struct task_struct *t);
>  extern void uprobe_copy_process(struct task_struct *t);
>  extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
> +extern void __weak arch_uprobe_enable_step(struct arch_uprobe *arch);
> +extern void __weak arch_uprobe_disable_step(struct arch_uprobe *arch);
>  extern int uprobe_post_sstep_notifier(struct pt_regs *regs);
>  extern int uprobe_pre_sstep_notifier(struct pt_regs *regs);
>  extern void uprobe_notify_resume(struct pt_regs *regs);
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 82a1043..125d1b7 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1444,6 +1444,16 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
>  	return uprobe;
>  }
> 
> +void __weak arch_uprobe_enable_step(struct arch_uprobe *arch)
> +{
> +	user_enable_single_step(current);
> +}
> +
> +void __weak arch_uprobe_disable_step(struct arch_uprobe *arch)
> +{
> +	user_disable_single_step(current);
> +}
> +
>  /*
>   * Run handler and ask thread to singlestep.
>   * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
> @@ -1490,7 +1500,7 @@ static void handle_swbp(struct pt_regs *regs)
> 
>  	utask->state = UTASK_SSTEP;
>  	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
> -		user_enable_single_step(current);
> +		arch_uprobe_enable_step(&uprobe->arch);
>  		return;
>  	}
> 
> @@ -1529,7 +1539,7 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
>  	put_uprobe(uprobe);
>  	utask->active_uprobe = NULL;
>  	utask->state = UTASK_RUNNING;
> -	user_disable_single_step(current);
> +	arch_uprobe_disable_step(&uprobe->arch);
>  	xol_free_insn_slot(current);
> 
>  	spin_lock_irq(&current->sighand->siglock);
> -- 
> 1.5.5.1
> 

