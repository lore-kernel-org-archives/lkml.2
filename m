Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab1LBPqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:46:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43513 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1LBPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:46:08 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=WQKrF2fF-hAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=NYJXv619IkKg1yI-x4kA:9 a=KEtRX-mIHa5z8miy_xYA:7 a=QEXdDO2ut3YA:10 a=0kPLrQdw3YYA:10 a=jEp0ucaQiEUA:10 a=Iq1oNnCWIomtHMEa:21 a=3xXwiGiim9Tnpugv:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH-RT] Fix for sleeping function called from invalid
 context when running gdb
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1322833159-3846-1-git-send-email-jkacur@redhat.com>
References: <1322833159-3846-1-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 10:46:03 -0500
Message-ID: <1322840763.30977.39.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 14:39 +0100, John Kacur wrote:
> While running gdb on cyclictest on v3.2-rc2-rt3 I got the following error
> 
> [root@starship ~]# [11887.443716] BUG: sleeping function called from invalid con
> text at /home/jkacur/linux-rt/kernel/rtmutex.c:645
> [11887.443720] in_atomic(): 1, irqs_disabled(): 0, pid: 4859, name: cyclictest
> [11887.443723] no locks held by cyclictest/4859.
> [11887.443726] Pid: 4859, comm: cyclictest Not tainted 3.2.0-rc2-rt3-debug-expr+
>  #1
> [11887.443728] Call Trace:
> [11887.443737]  [<ffffffff81035543>] __might_sleep+0x185/0x18d
> [11887.443743]  [<ffffffff8107c3ed>] rt_spin_lock_fastlock.clone.0+0x24/0x31
> [11887.443749]  [<ffffffff813fba9b>] rt_spin_lock+0x16/0x40
> [11887.443754]  [<ffffffff81053eee>] force_sig_info+0x3d/0xeb
> [11887.443758]  [<ffffffff81053fb2>] force_sig+0x16/0x18
> [11887.443761]  [<ffffffff813fd0a1>] do_trap+0xef/0x130
> [11887.443766]  [<ffffffff81076525>] ? trace_hardirqs_on_caller+0x12a/0x161
> [11887.443771]  [<ffffffff813fd16f>] do_int3+0x8d/0x9a
> [11887.443774]  [<ffffffff813fc9e7>] int3+0x27/0x40
> 
> I found that there is a patch for this in v2.6.33.9-rt31 that I forward-ported
> to v3.2-rc2-rt3
> 
> I believe that Thomas Gleixner is the original author, but I'm not sure.
> Thomas - can you provide your signed-off-by if you are the author?

Actually, the author was Andi. It's in the 2.6.24-rt patch set too.
Here's the change log:


>From ak@suse.de Sat Oct 27 10:32:13 2007
Date: Sat, 27 Oct 2007 12:39:33 +0200
From: Andi Kleen <ak@suse.de>
To: linux-rt-users@vger.kernel.org
Subject: [PATCH] Don't disable preemption in exception handlers without IST


Some of the exception handlers that run on an IST in a normal kernel
still disable preemption. This causes might_sleep warning when sending signals
for debugging in PREEMPT-RT because sending signals can take a lock.
Since the ISTs are disabled now for those don't disable the preemption.

This completes the remove IST patch I sent some time ago and fixes
another case where using gdb caused warnings.

Also it will likely improve latency a little bit.

Signed-off-by: Andi Kleen <ak@suse.de>


Thomas, I think this patch is worth adding, unless you have a better
work around.


-- Steve



> 
> Forward-ported from v2.6.33.9-rt31 to v3.2-rc2-rt3
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  arch/x86/kernel/traps.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index a8e3eb8..3654390 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -87,9 +87,10 @@ static inline void conditional_sti(struct pt_regs *regs)
>  		local_irq_enable();
>  }
>  
> -static inline void preempt_conditional_sti(struct pt_regs *regs)
> +static inline void preempt_conditional_sti(struct pt_regs *regs, int stack)
>  {
> -	inc_preempt_count();
> +	if (stack)
> +		inc_preempt_count();
>  	if (regs->flags & X86_EFLAGS_IF)
>  		local_irq_enable();
>  }
> @@ -100,11 +101,12 @@ static inline void conditional_cli(struct pt_regs *regs)
>  		local_irq_disable();
>  }
>  
> -static inline void preempt_conditional_cli(struct pt_regs *regs)
> +static inline void preempt_conditional_cli(struct pt_regs *regs, int stack)
>  {
>  	if (regs->flags & X86_EFLAGS_IF)
>  		local_irq_disable();
> -	dec_preempt_count();
> +	if (stack)
> +		dec_preempt_count();
>  }
>  
>  static void __kprobes
> @@ -222,9 +224,9 @@ dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
>  	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
>  			12, SIGBUS) == NOTIFY_STOP)
>  		return;
> -	preempt_conditional_sti(regs);
> +	preempt_conditional_sti(regs, STACKFAULT_STACK);
>  	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
> -	preempt_conditional_cli(regs);
> +	preempt_conditional_cli(regs, STACKFAULT_STACK);
>  }
>  
>  dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
> @@ -316,9 +318,9 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
>  		return;
>  #endif
>  
> -	preempt_conditional_sti(regs);
> +	preempt_conditional_sti(regs, DEBUG_STACK);
>  	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
> -	preempt_conditional_cli(regs);
> +	preempt_conditional_cli(regs, DEBUG_STACK);
>  }
>  
>  #ifdef CONFIG_X86_64
> @@ -412,12 +414,12 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  		return;
>  
>  	/* It's safe to allow irq's after DR6 has been saved */
> -	preempt_conditional_sti(regs);
> +	preempt_conditional_sti(regs, DEBUG_STACK);
>  
>  	if (regs->flags & X86_VM_MASK) {
>  		handle_vm86_trap((struct kernel_vm86_regs *) regs,
>  				error_code, 1);
> -		preempt_conditional_cli(regs);
> +		preempt_conditional_cli(regs, DEBUG_STACK);
>  		return;
>  	}
>  
> @@ -436,7 +438,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  	si_code = get_si_code(tsk->thread.debugreg6);
>  	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
>  		send_sigtrap(tsk, regs, error_code, si_code);
> -	preempt_conditional_cli(regs);
> +	preempt_conditional_cli(regs, DEBUG_STACK);
>  
>  	return;
>  }


