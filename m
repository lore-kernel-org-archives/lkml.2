Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2IGPDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:03:16 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:47788 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2IGPDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:03:14 -0400
Date: Fri, 7 Sep 2012 20:29:49 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] uprobes: x86: Implement x86 specific
 arch_uprobe_*_step
Message-ID: <20120907145949.GO30238@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120903152525.GA9028@redhat.com>
 <20120903152602.GA9061@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120903152602.GA9061@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12090715-5140-0000-0000-0000020AE86C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-03 17:26:02]:

> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The arch specific implementation behaves like user_enable_single_step()
> except that it does not disable single stepping if it was already
> enabled by ptrace. This allows the debugger to single step over an
> uprobe. The state of block stepping is not restored. It makes only sense
> together with TF and if that was enabled then the debugger is notified.
> 
> Note: this is still not correct. For example, TIF_SINGLESTEP check
> is not right, the application itsel can set X86_EFLAGS_TF. And otoh

nit: 
s/itsel/itself

> we leak TIF_SINGLESTEP (set by enable) if the probed insn is "popf".
> See the next patches, we need the changes in arch/x86/kernel/step.c
> first.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/x86/include/asm/uprobes.h |    2 ++
>  arch/x86/kernel/uprobes.c      |   33 +++++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index f3971bb..cee5862 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -46,6 +46,8 @@ struct arch_uprobe_task {
>  #ifdef CONFIG_X86_64
>  	unsigned long			saved_scratch_register;
>  #endif
> +#define UPROBE_CLEAR_TF			(1 << 0)
> +	unsigned int			restore_flags;
>  };
> 
>  extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 36fd420..309a0e0 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -41,6 +41,9 @@
>  /* Adjust the return address of a call insn */
>  #define UPROBE_FIX_CALL	0x2
> 
> +/* Instruction will modify TF, don't change it */
> +#define UPROBE_FIX_SETF	0x4
> +
>  #define UPROBE_FIX_RIP_AX	0x8000
>  #define UPROBE_FIX_RIP_CX	0x4000
> 
> @@ -239,6 +242,10 @@ static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
>  	insn_get_opcode(insn);	/* should be a nop */
> 
>  	switch (OPCODE1(insn)) {
> +	case 0x9d:
> +		/* popf */
> +		auprobe->fixups |= UPROBE_FIX_SETF;
> +		break;
>  	case 0xc3:		/* ret/lret */
>  	case 0xcb:
>  	case 0xc2:
> @@ -673,3 +680,29 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  	}
>  	return false;
>  }
> +
> +void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
> +{
> +	struct uprobe_task	*utask		= current->utask;
> +	struct arch_uprobe_task	*autask		= &utask->autask;
> +
> +	autask->restore_flags = 0;
> +	if (!test_tsk_thread_flag(current, TIF_SINGLESTEP) &&
> +			!(auprobe->fixups & UPROBE_FIX_SETF))
> +		autask->restore_flags |= UPROBE_CLEAR_TF;
> +	/*
> +	 * The state of TIF_BLOCKSTEP is not saved. With the TF flag set we
> +	 * would to examine the opcode and the flags to make it right. Without
> +	 * TF block stepping makes no sense.
> +	 */
> +	user_enable_single_step(current);
> +}
> +
> +void arch_uprobe_disable_step(struct arch_uprobe *auprobe)
> +{
> +	struct uprobe_task *utask		= current->utask;
> +	struct arch_uprobe_task	*autask		= &utask->autask;
> +
> +	if (autask->restore_flags & UPROBE_CLEAR_TF)
> +		user_disable_single_step(current);
> +}
> -- 
> 1.5.5.1
> 

