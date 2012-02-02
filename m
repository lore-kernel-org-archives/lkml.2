Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2BBCZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:25:10 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56819 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2BBCZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:25:07 -0500
X-AuditID: b753bd60-9825fba00000359c-fc-4f29f4003eae
X-AuditID: b753bd60-9825fba00000359c-fc-4f29f4003eae
Message-ID: <4F29F3F7.5000802@hitachi.com>
Date: Thu, 02 Feb 2012 11:24:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: Re: [PATCH RT 1/2 v3] x86: Do not disable preemption in int3 on
 32bit
References: <20120201210612.730595791@goodmis.org> <20120201210748.397671856@goodmis.org>
In-Reply-To: <20120201210748.397671856@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/02 6:06), Steven Rostedt wrote:
> Preemption must be disabled before enabling interrupts in do_trap
> on x86_64 because the stack in use for int3 and debug is a per CPU
> stack set by th IST. But 32bit does not have an IST and the stack
> still belongs to the current task and there is no problem in scheduling
> out the task.
> 
> Keep preemption enabled on X86_32 when enabling interrupts for
> do_trap().
> 
> The name of the function is changed from preempt_conditional_sti/cli()
> to conditional_sti/cli_ist(), to annotate that this function is used
> when the stack is on the IST.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> 
> Index: linux-rt.git/arch/x86/kernel/traps.c
> ===================================================================
> --- linux-rt.git.orig/arch/x86/kernel/traps.c
> +++ linux-rt.git/arch/x86/kernel/traps.c
> @@ -87,9 +87,21 @@ static inline void conditional_sti(struc
>  		local_irq_enable();
>  }
>  
> -static inline void preempt_conditional_sti(struct pt_regs *regs)
> +static inline void conditional_sti_ist(struct pt_regs *regs)
>  {
> +#ifdef CONFIG_X86_64
> +	/*
> +	 * X86_64 uses a per CPU stack on the IST for certain traps
> +	 * like int3. The task can not be preempted when using one
> +	 * of these stacks, thus preemption must be disabled, otherwise
> +	 * the stack can be corrupted if the task is scheduled out,
> +	 * and another task comes in and uses this stack.
> +	 *
> +	 * On x86_32 the task keeps its own stack and it is OK if the
> +	 * task schedules out.
> +	 */
>  	inc_preempt_count();
> +#endif
>  	if (regs->flags & X86_EFLAGS_IF)
>  		local_irq_enable();
>  }
> @@ -100,11 +112,13 @@ static inline void conditional_cli(struc
>  		local_irq_disable();
>  }
>  
> -static inline void preempt_conditional_cli(struct pt_regs *regs)
> +static inline void conditional_cli_ist(struct pt_regs *regs)
>  {
>  	if (regs->flags & X86_EFLAGS_IF)
>  		local_irq_disable();
> +#ifdef CONFIG_X86_64
>  	dec_preempt_count();
> +#endif
>  }
>  
>  static void __kprobes
> @@ -222,9 +236,9 @@ dotraplinkage void do_stack_segment(stru
>  	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
>  			12, SIGBUS) == NOTIFY_STOP)
>  		return;
> -	preempt_conditional_sti(regs);
> +	conditional_sti_ist(regs);
>  	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
> -	preempt_conditional_cli(regs);
> +	conditional_cli_ist(regs);
>  }
>  
>  dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
> @@ -316,9 +330,9 @@ dotraplinkage void __kprobes do_int3(str
>  		return;
>  #endif
>  
> -	preempt_conditional_sti(regs);
> +	conditional_sti_ist(regs);
>  	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
> -	preempt_conditional_cli(regs);
> +	conditional_cli_ist(regs);
>  }
>  
>  #ifdef CONFIG_X86_64
> @@ -412,12 +426,12 @@ dotraplinkage void __kprobes do_debug(st
>  		return;
>  
>  	/* It's safe to allow irq's after DR6 has been saved */
> -	preempt_conditional_sti(regs);
> +	conditional_sti_ist(regs);
>  
>  	if (regs->flags & X86_VM_MASK) {
>  		handle_vm86_trap((struct kernel_vm86_regs *) regs,
>  				error_code, 1);
> -		preempt_conditional_cli(regs);
> +		conditional_cli_ist(regs);
>  		return;
>  	}
>  
> @@ -436,7 +450,7 @@ dotraplinkage void __kprobes do_debug(st
>  	si_code = get_si_code(tsk->thread.debugreg6);
>  	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
>  		send_sigtrap(tsk, regs, error_code, si_code);
> -	preempt_conditional_cli(regs);
> +	conditional_cli_ist(regs);
>  
>  	return;
>  }
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
