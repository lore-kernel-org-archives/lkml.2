Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2ILMND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:13:03 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53334 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab2ILMNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:13:00 -0400
Date: Wed, 12 Sep 2012 17:38:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] uprobes: Xol should send SIGTRAP if X86_EFLAGS_TF
 was	set
Message-ID: <20120912120857.GA9582@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120903152525.GA9028@redhat.com>
 <20120903152616.GA9081@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120903152616.GA9081@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091212-1976-0000-0000-0000113D3DC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-03 17:26:16]:

> arch_uprobe_disable_step() correctly preserves X86_EFLAGS_TF and
> returns to user-mode. But this means the application gets SIGTRAP
> only after the next insn.
> 

Agree.

> This means that UPROBE_CLEAR_TF logic is not really right. _enable
> should only record the state of X86_EFLAGS_TF, and _disable should
> check it separately from UPROBE_FIX_SETF.
> 
> Remove arch_uprobe_task->restore_flags, add ->saved_tf instead, and
> change enable/disable accordingly.
> 
> arch_uprobe_skip_sstep() logic has the same problem, change it to
> check X86_EFLAGS_TF and send SIGTRAP as well. We will cleanup this
> all after we fold enable/disable_step into pre/post_hol hooks.
> 
> Note: send_sig(SIGTRAP) is not actually right, we need send_sigtrap().

Are you pointing to the info field not being filled? or are there other
problems?

> But this needs more changes, handle_swbp() does the same and this is
> equally wrong.

send_sigtrap() is arch specific and defined for only few archs.
we would have to force. But these are not related to the patch.

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/x86/include/asm/uprobes.h |    3 +--
>  arch/x86/kernel/uprobes.c      |   19 +++++++++++++------
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index cee5862..d561ff5 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -46,8 +46,7 @@ struct arch_uprobe_task {
>  #ifdef CONFIG_X86_64
>  	unsigned long			saved_scratch_register;
>  #endif
> -#define UPROBE_CLEAR_TF			(1 << 0)
> -	unsigned int			restore_flags;
> +	unsigned int			saved_tf;
>  };
> 
>  extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 3b4aae6..7e993d1 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -653,7 +653,7 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>   * Skip these instructions as per the currently known x86 ISA.
>   * 0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }
>   */
> -bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +static bool __skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  {
>  	int i;
> 
> @@ -681,16 +681,21 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	return false;
>  }
> 
> +bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	bool ret = __skip_sstep(auprobe, regs);

Should we add a comment here saying ptrace or some debugger wants to
trace this instruction and we singlestepped and hence we want to inform
them now and otherwise they would only know one instruction later?

> +	if (ret && (regs->flags & X86_EFLAGS_TF))
> +		send_sig(SIGTRAP, current, 0);
> +	return ret;
> +}
> +
>  void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
>  {
>  	struct task_struct *task = current;
>  	struct arch_uprobe_task	*autask	= &task->utask->autask;
>  	struct pt_regs *regs = task_pt_regs(task);
> 
> -	autask->restore_flags = 0;
> -	if (!(regs->flags & X86_EFLAGS_TF) &&
> -	    !(auprobe->fixups & UPROBE_FIX_SETF))
> -		autask->restore_flags |= UPROBE_CLEAR_TF;
> +	autask->saved_tf = !!(regs->flags & X86_EFLAGS_TF);
> 
>  	regs->flags |= X86_EFLAGS_TF;
>  	if (test_tsk_thread_flag(task, TIF_BLOCKSTEP))
> @@ -707,6 +712,8 @@ void arch_uprobe_disable_step(struct arch_uprobe *auprobe)
>  	 * SIGTRAP if we do not clear TF. We need to examine the opcode to
>  	 * make it right.
>  	 */
> -	if (autask->restore_flags & UPROBE_CLEAR_TF)
> +	if (autask->saved_tf)
> +		send_sig(SIGTRAP, task, 0);
> +	else if (!(auprobe->fixups & UPROBE_FIX_SETF))
>  		regs->flags &= ~X86_EFLAGS_TF;
>  }
> -- 
> 1.5.5.1
> 

