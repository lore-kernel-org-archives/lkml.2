Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2GaSXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab2GaSXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:23:24 -0400
Date: Tue, 31 Jul 2012 19:51:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, a.p.zijlstra@chello.nl,
        mingo@redhat.com, srikar@linux.vnet.ibm.com, roland@hack.frob.com
Subject: Re: [PATCH 2/2] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120731175108.GC14576@redhat.com>
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de> <1343735548-18101-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343735548-18101-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, Sebastian, I'll try to read this patch tomorrow, but I am not
expert anyway.

However, honestly I do not like it. I think we should change this
step-by-step, that is why I suggested to use TIF_SINGLESTEP and
user_enable_single_step() like your initial patch did. With this
patch at least the debugger doesn't lose the control over the tracee
if it steps over the probed insn, and this is the main (and known ;)
problem to me.

Every change needs the discussion. For example, _enable should
clear DEBUGCTLMSR_BTF, this is obvious. But it is not clear to
me if _disable should restore it. What if the probed insn was
"jmp"? We need the additional complications to handle this case
really correctly, and for what? OK, gdb can get the extra SIGTRAP
from the tracee, but this is fine. And uprobes can confuse gdb
in many ways.

Even the "send_sig(SIGTRAP)" from _disable should be weighted.
Yes, yes, it was me who pointed we miss the trap. But is it really
that important? I dunno, and the problem is that send_sig(SIGTRAP)
is not the right interface (yes, handle_swbp() does this too).


But I am not maintainer.

Srikar, what do you think?


On 07/31, Sebastian Andrzej Siewior wrote:
> The arch specific implementation enables single stepping directly by
> setting the trap flag. "Single-Step on branches" is always disabled
> since only one opcode has to be executed.
> 
> The disable call removes the trap flag unless it was there before. It
> does not touch the flags register if the executed instruction was
> "popf". It does not take into account various prefixes like "lock popf"
> or "repz popf".
> SIGTRAP is sent to the process in case it was traced so the debugger
> knows once we advanced by one opcode. This isn't done in case we have to
> restore the BTF flag. In case the BTF flag is set, we should look at the
> opcode and send SIGTRAP depending on the jump/flag status. For now we
> wait for the next exception/jump to be taken.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/include/asm/uprobes.h |    3 ++
>  arch/x86/kernel/uprobes.c      |   60 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index f3971bb..47f4cf1 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -46,6 +46,9 @@ struct arch_uprobe_task {
>  #ifdef CONFIG_X86_64
>  	unsigned long			saved_scratch_register;
>  #endif
> +#define UPROBE_CLEAR_TF			(1 << 0)
> +#define UPROBE_SET_BTF			(1 << 1)
> +	unsigned int			restore_flags;
>  };
>  
>  extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 36fd420..6eec3e4 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -673,3 +673,63 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	}
>  	return false;
>  }
> +
> +static int insn_is_popf(const u8 *insn)
> +{
> +	/* popf */
> +	if (insn[0] == 0x9d)
> +		return 1;
> +	return 0;
> +}
> +
> +void arch_uprobe_enable_step(struct task_struct *child,
> +		struct arch_uprobe *auprobe)
> +{
> +	struct uprobe_task	*utask		= child->utask;
> +	struct arch_uprobe_task	*autask		= &utask->autask;
> +	struct pt_regs		*regs		= task_pt_regs(child);
> +	unsigned long		debugctl;
> +
> +	autask->restore_flags = 0;
> +	if (!(regs->flags & X86_EFLAGS_TF) &&
> +			!insn_is_popf(auprobe->insn)) {
> +		autask->restore_flags |= UPROBE_CLEAR_TF;
> +
> +		debugctl = get_debugctlmsr();
> +		if (debugctl & DEBUGCTLMSR_BTF) {
> +			autask->restore_flags |= UPROBE_SET_BTF;
> +			debugctl &= ~DEBUGCTLMSR_BTF;
> +			update_debugctlmsr(debugctl);
> +		}
> +	}
> +	regs->flags |= X86_EFLAGS_TF;
> +}
> +
> +void arch_uprobe_disable_step(struct task_struct *child,
> +		struct arch_uprobe *auprobe)
> +{
> +	struct uprobe_task *utask	= child->utask;
> +	struct arch_uprobe_task	*autask		= &utask->autask;
> +	struct pt_regs *regs		= task_pt_regs(child);
> +
> +	/*
> +	 * Disable the single step flag if it was set by us. Notify the debugger
> +	 * via SIGTRAP in case it was already there so it learns that we
> +	 * advanced by an opcode unless the debugger is waiting for the next
> +	 * jump to be taken. This logic gets it wrong if the uprobe was set
> +	 * on jump instruction that would raise an exception.
> +	 */
> +	if (autask->restore_flags & UPROBE_CLEAR_TF) {
> +		regs->flags &= ~X86_EFLAGS_TF;
> +	} else {
> +		if (autask->restore_flags & UPROBE_SET_BTF) {
> +			unsigned long	debugctl;
> +
> +			debugctl = get_debugctlmsr();
> +			debugctl |= DEBUGCTLMSR_BTF;
> +			update_debugctlmsr(debugctl);
> +		} else {
> +			send_sig(SIGTRAP, current, 0);
> +		}
> +	}
> +}
> -- 
> 1.7.10.4
> 

