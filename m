Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132Ab2KBMrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:47:53 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45015 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761918Ab2KBMrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:47:49 -0400
Date: Fri, 2 Nov 2012 18:21:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] uprobes/x86: Cleanup the single-stepping code
Message-ID: <20121102125113.GG11125@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121028173900.GA14621@redhat.com>
 <20121028173931.GA14652@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121028173931.GA14652@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110212-7282-0000-0000-00000E8A5045
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-10-28 18:39:31]:

> No functional changes.
> 
> Now that default arch_uprobe_enable/disable_step() helpers do nothing,
> x86 has no reason to reimplement them. Change arch_uprobe_*_xol() hooks
> to do the necessary work and remove the x86-specific hooks.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/uprobes.c |   54 +++++++++++++++-----------------------------
>  1 files changed, 19 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index aafa555..c71025b 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -478,6 +478,11 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	regs->ip = current->utask->xol_vaddr;
>  	pre_xol_rip_insn(auprobe, regs, autask);
> 
> +	autask->saved_tf = !!(regs->flags & X86_EFLAGS_TF);
> +	regs->flags |= X86_EFLAGS_TF;
> +	if (test_tsk_thread_flag(current, TIF_BLOCKSTEP))
> +		set_task_blockstep(current, false);
> +
>  	return 0;
>  }
> 
> @@ -603,6 +608,16 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	if (auprobe->fixups & UPROBE_FIX_CALL)
>  		result = adjust_ret_addr(regs->sp, correction);
> 
> +	/*
> +	 * arch_uprobe_pre_xol() doesn't save the state of TIF_BLOCKSTEP
> +	 * so we can get an extra SIGTRAP if we do not clear TF. We need
> +	 * to examine the opcode to make it right.
> +	 */
> +	if (utask->autask.saved_tf)
> +		send_sig(SIGTRAP, current, 0);
> +	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
> +		regs->flags &= ~X86_EFLAGS_TF;
> +
>  	return result;
>  }
> 
> @@ -647,6 +662,10 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	current->thread.trap_nr = utask->autask.saved_trap_nr;
>  	handle_riprel_post_xol(auprobe, regs, NULL);
>  	instruction_pointer_set(regs, utask->vaddr);
> +
> +	/* clear TF if it was set by us in arch_uprobe_pre_xol() */
> +	if (!utask->autask.saved_tf)
> +		regs->flags &= ~X86_EFLAGS_TF;
>  }
> 
>  /*
> @@ -676,38 +695,3 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  		send_sig(SIGTRAP, current, 0);
>  	return ret;
>  }
> -
> -void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
> -{
> -	struct task_struct *task = current;
> -	struct arch_uprobe_task	*autask	= &task->utask->autask;
> -	struct pt_regs *regs = task_pt_regs(task);
> -
> -	autask->saved_tf = !!(regs->flags & X86_EFLAGS_TF);
> -
> -	regs->flags |= X86_EFLAGS_TF;
> -	if (test_tsk_thread_flag(task, TIF_BLOCKSTEP))
> -		set_task_blockstep(task, false);
> -}
> -
> -void arch_uprobe_disable_step(struct arch_uprobe *auprobe)
> -{
> -	struct task_struct *task = current;
> -	struct arch_uprobe_task	*autask	= &task->utask->autask;
> -	bool trapped = (task->utask->state == UTASK_SSTEP_TRAPPED);
> -	struct pt_regs *regs = task_pt_regs(task);
> -	/*
> -	 * The state of TIF_BLOCKSTEP was not saved so we can get an extra
> -	 * SIGTRAP if we do not clear TF. We need to examine the opcode to
> -	 * make it right.
> -	 */
> -	if (unlikely(trapped)) {
> -		if (!autask->saved_tf)
> -			regs->flags &= ~X86_EFLAGS_TF;
> -	} else {
> -		if (autask->saved_tf)
> -			send_sig(SIGTRAP, task, 0);
> -		else if (!(auprobe->fixups & UPROBE_FIX_SETF))
> -			regs->flags &= ~X86_EFLAGS_TF;
> -	}
> -}
> -- 
> 1.5.5.1
> 

