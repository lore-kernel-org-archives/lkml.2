Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1F3TlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:41:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab1F3TlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:41:08 -0400
Date: Thu, 30 Jun 2011 15:40:12 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for kprobes
Message-ID: <20110630194012.GB2457@redhat.com>
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
 <1309449117.26417.90.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309449117.26417.90.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 11:51:57AM -0400, Steven Rostedt wrote:
> Kprobes requires preemption to be disabled as it single steps the code
> it replaced with a breakpoint. But because the code that is single
> stepped could be reading the preempt count, the kprobe disabling of the
> preempt count can cause the wrong value to end up as a result. Here's an
> example:
> 
> If we add a kprobe on a inc_preempt_count() call:
> 
> 	[ preempt_count = 0 ]
> 
> 	ld preempt_count, %eax	<<--- trap
> 
> 		<trap>
> 		preempt_disable();
> 		[ preempt_count = 1]
> 		setup_singlestep();
> 		<trap return>
> 
> 	[ preempt_count = 1 ]
> 
> 	ld preempt_count, %eax
> 
> 	[ %eax = 1 ]
> 
> 		<trap>
> 		post_kprobe_handler()
> 			preempt_enable_no_resched();
> 			[ preempt_count = 0 ]
> 		<trap return>
> 
> 	[ %eax = 1 ]
> 
> 	add %eax,1
> 
> 	[ %eax = 2 ]
> 
> 	st %eax, preempt_count
> 
> 	[ preempt_count = 2 ]
> 
> 
> We just caused preempt count to increment twice when it should have only
> incremented once, and this screws everything else up.
> 
> To solve this, I've added a per_cpu variable called
> kprobe_preempt_disabled, that is set by the kprobe code. If it is set,
> the preempt_schedule() will not preempt the code.
> 
> I did not update task_struct for a separate variable for kprobes to test
> because it would just bloat that structure with one more test. Adding a
> flag per cpu is much better than adding one per task. The kprobes are
> slow anyway, so causing it to do a little bit more work is not a
> problem.
> 
> I tested this code against the probes that caused my previous crashes,
> and it works fine.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index f1a6244..2ed67e6 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c

Since this is an issue for all arches, shouldn't this include the
transform:

preempt_enable_no_resched() -> kprobe_preempt_enable()

and

preempt_disable() -> kprobe_preempt_disable()

for all arches?

Or, is that a follow-up patch?

Thanks,

-Jason


> @@ -475,7 +475,7 @@ static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
>  		 * stepping.
>  		 */
>  		regs->ip = (unsigned long)p->ainsn.insn;
> -		preempt_enable_no_resched();
> +		kprobe_preempt_enable();
>  		return;
>  	}
>  #endif
> @@ -547,7 +547,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>  	 * re-enable preemption at the end of this function,
>  	 * and also in reenter_kprobe() and setup_singlestep().
>  	 */
> -	preempt_disable();
> +	kprobe_preempt_disable();
>  
>  	kcb = get_kprobe_ctlblk();
>  	p = get_kprobe(addr);
> @@ -583,7 +583,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>  		 * the original instruction.
>  		 */
>  		regs->ip = (unsigned long)addr;
> -		preempt_enable_no_resched();
> +		kprobe_preempt_enable();
>  		return 1;
>  	} else if (kprobe_running()) {
>  		p = __this_cpu_read(current_kprobe);
> @@ -593,7 +593,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>  		}
>  	} /* else: not a kprobe fault; let the kernel handle it */
>  
> -	preempt_enable_no_resched();
> +	kprobe_preempt_enable();
>  	return 0;
>  }
>  
> @@ -917,7 +917,7 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
>  	}
>  	reset_current_kprobe();
>  out:
> -	preempt_enable_no_resched();
> +	kprobe_preempt_enable();
>  
>  	/*
>  	 * if somebody else is singlestepping across a probe point, flags
> @@ -951,7 +951,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
>  			restore_previous_kprobe(kcb);
>  		else
>  			reset_current_kprobe();
> -		preempt_enable_no_resched();
> +		kprobe_preempt_enable();
>  		break;
>  	case KPROBE_HIT_ACTIVE:
>  	case KPROBE_HIT_SSDONE:
> @@ -1098,7 +1098,7 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
>  		memcpy((kprobe_opcode_t *)(kcb->jprobe_saved_sp),
>  		       kcb->jprobes_stack,
>  		       MIN_STACK_SIZE(kcb->jprobe_saved_sp));
> -		preempt_enable_no_resched();
> +		kprobe_preempt_enable();
>  		return 1;
>  	}
>  	return 0;
> @@ -1530,7 +1530,7 @@ static int  __kprobes setup_detour_execution(struct kprobe *p,
>  		regs->ip = (unsigned long)op->optinsn.insn + TMPL_END_IDX;
>  		if (!reenter)
>  			reset_current_kprobe();
> -		preempt_enable_no_resched();
> +		kprobe_preempt_enable();
>  		return 1;
>  	}
>  	return 0;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a837b20..c7c423e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -258,6 +258,24 @@ extern spinlock_t mmlist_lock;
>  
>  struct task_struct;
>  
> +#ifdef CONFIG_KPROBES
> +DECLARE_PER_CPU(int, kprobe_preempt_disabled);
> +
> +static inline void kprobe_preempt_disable(void)
> +{
> +	preempt_disable();
> +	__get_cpu_var(kprobe_preempt_disabled) = 1;
> +	preempt_enable_no_resched();
> +}
> +
> +static inline void kprobe_preempt_enable(void)
> +{
> +	preempt_disable();
> +	__get_cpu_var(kprobe_preempt_disabled) = 0;
> +	preempt_enable_no_resched();
> +}
> +#endif
> +
>  #ifdef CONFIG_PROVE_RCU
>  extern int lockdep_tasklist_lock_is_held(void);
>  #endif /* #ifdef CONFIG_PROVE_RCU */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3f2e502..990d53d 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -443,6 +443,30 @@ static struct root_domain def_root_domain;
>  
>  #endif /* CONFIG_SMP */
>  
> +#ifdef CONFIG_KPROBES
> +/*
> + * Kprobes can not disable preempting with the preempt_count.
> + * If it does, and it single steps kernel code that modifies
> + * the preempt_count, it will corrupt the result.
> + *
> + * Since kprobes is slow anyways, we do not need to bloat the
> + * task_struct or thread_struct with another variable to test.
> + * Simply use a per_cpu variable and require the kprobe code
> + * to disable preemption normally to set it.
> + */
> +DEFINE_PER_CPU(int, kprobe_preempt_disabled);
> +
> +static inline int preempt_disabled_kprobe(void)
> +{
> +	return __get_cpu_var(kprobe_preempt_disabled);
> +}
> +#else
> +static inline int preempt_disabled_kprobe(void)
> +{
> +	return 0;
> +}
> +#endif
> +
>  /*
>   * This is the main, per-CPU runqueue data structure.
>   *
> @@ -4106,7 +4130,7 @@ void __kprobes add_preempt_count(int val)
>  	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
>  				PREEMPT_MASK - 10);
>  #endif
> -	if (preempt_count() == val)
> +	if (preempt_count() == val && !preempt_disabled_kprobe())
>  		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
>  }
>  EXPORT_SYMBOL(add_preempt_count);
> @@ -4127,7 +4151,7 @@ void __kprobes sub_preempt_count(int val)
>  		return;
>  #endif
>  
> -	if (preempt_count() == val)
> +	if (preempt_count() == val && !preempt_disabled_kprobe())
>  		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
>  	preempt_count() -= val;
>  }
> @@ -4373,6 +4397,10 @@ asmlinkage void __sched notrace preempt_schedule(void)
>  
>  	do {
>  		add_preempt_count_notrace(PREEMPT_ACTIVE);
> +		if (unlikely(preempt_disabled_kprobe())) {
> +			sub_preempt_count_notrace(PREEMPT_ACTIVE);
> +			break;
> +		}
>  		schedule();
>  		sub_preempt_count_notrace(PREEMPT_ACTIVE);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
