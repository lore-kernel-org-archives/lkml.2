Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0HCVhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:37:23 -0400
Received: from claw.goop.org ([74.207.240.146]:53294 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab0HCVhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:37:20 -0400
Message-ID: <4C588C0C.1070702@goop.org>
Date: Tue, 03 Aug 2010 14:37:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
References: <4C3A06E3.50402@kernel.org>
In-Reply-To: <4C3A06E3.50402@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/11/2010 11:01 AM, Tejun Heo wrote:
> Hello,
>
> This is something suggested by Rusty Russell a while ago.  It makes
> IRQ masking a software switch like preemption or softirq
> enable/disable.  Hardware interrupt masking (cli/sti) and delivery are
> decoupled from actual IRQ handling.  IRQ disabling is done by single
> instruction moving 1 to a percpu variable.  Enabling is similar but it
> should check whether there's any pending interrupt to handle.
>
> This change greatly reduces the number of hardware IRQ masking
> manipulations.  cli/sti still being somewhat costly operations (I hear
> nehalem is better tho), this should be able to improve overall
> performance, especially on paravirts.
>
> I just got it working and it behaves pretty good on qemu.  Actual
> machines can't idle but seem to work otherwise.  I'll fix up idle, get
> paravirt working and try to get some perf measurements but I'll be
> mostly off next week, so it will take some time.  In the meantime,
> what do you guys think?

This is very similar to how Xen does interrupts, since a paravirtualized 
kernel can't use sti/cli; lguest has the same constraint, which may have 
been the context Rusty mentioned it in.

As such a lot of your patch is redundant, since it can be implemented 
via paravirt-ops without having to hack all over the kernel; that would 
be a good way to at least prototype the code.

Of course if it becomes core to the x86 architecture or the kernel 
overall, then most of the irq-related paravirt-ops can go away and be 
limited to the actual interrupt handler and the machinery needed to 
really mask/unmask the hardware and set the pending flag (which would 
likely just be contained within the hypervisor-specific code, and not 
need any new kernel interfaces to replace the dropped paravirt irq ones).

A couple of comments below, but I haven't done more than skim the patch.

> Thanks.
>
> HIGHLY_EXPERIMENTAL_DONT_APPLY
> ---
>   arch/x86/ia32/ia32entry.S       |   12 +--
>   arch/x86/include/asm/irqflags.h |  103 ++++++++++++++++++++++------
>   arch/x86/include/asm/paravirt.h |   21 +----
>   arch/x86/include/asm/system.h   |    4 -
>   arch/x86/kernel/cpu/common.c    |   10 ++
>   arch/x86/kernel/entry_64.S      |  143 +++++++++++++++++++++++++---------------
>   arch/x86/kernel/irq.c           |   21 +++++
>   arch/x86/kernel/process.c       |   21 ++---
>   arch/x86/kernel/process_64.c    |    2
>   arch/x86/kernel/smpboot.c       |    2
>   arch/x86/kernel/traps.c         |   16 ++--
>   arch/x86/mm/fault.c             |    6 -
>   drivers/acpi/processor_idle.c   |   24 +++---
>   drivers/cpuidle/cpuidle.c       |    6 -
>   include/linux/irqflags.h        |   31 ++++++++
>   init/main.c                     |    2
>   lib/smp_processor_id.c          |    2
>   17 files changed, 283 insertions(+), 143 deletions(-)
>
> Index: work/drivers/acpi/processor_idle.c
> ===================================================================
> --- work.orig/drivers/acpi/processor_idle.c
> +++ work/drivers/acpi/processor_idle.c
> @@ -137,7 +137,7 @@ static void acpi_safe_halt(void)
>   	smp_mb();
>   	if (!need_resched()) {
>   		safe_halt();
> -		local_irq_disable();
> +		hw_irq_disable();
>   	}
>   	current_thread_info()->status |= TS_POLLING;
>   }
> @@ -826,11 +826,11 @@ static int acpi_idle_enter_c1(struct cpu
>   	if (unlikely(!pr))
>   		return 0;
>
> -	local_irq_disable();
> +	hw_irq_disable();
>
>   	/* Do not access any ACPI IO ports in suspend path */
>   	if (acpi_idle_suspend) {
> -		local_irq_enable();
> +		hw_irq_enable();
>   		cpu_relax();
>   		return 0;
>   	}
> @@ -841,7 +841,7 @@ static int acpi_idle_enter_c1(struct cpu
>   	kt2 = ktime_get_real();
>   	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
>
> -	local_irq_enable();
> +	hw_irq_enable();
>   	cx->usage++;
>   	lapic_timer_state_broadcast(pr, cx, 0);
>
> @@ -870,7 +870,7 @@ static int acpi_idle_enter_simple(struct
>   	if (acpi_idle_suspend)
>   		return(acpi_idle_enter_c1(dev, state));
>
> -	local_irq_disable();
> +	hw_irq_disable();
>
>   	if (cx->entry_method != ACPI_CSTATE_FFH) {
>   		current_thread_info()->status&= ~TS_POLLING;
> @@ -882,7 +882,7 @@ static int acpi_idle_enter_simple(struct
>
>   		if (unlikely(need_resched())) {
>   			current_thread_info()->status |= TS_POLLING;
> -			local_irq_enable();
> +			hw_irq_enable();
>   			return 0;
>   		}
>   	}
> @@ -908,7 +908,7 @@ static int acpi_idle_enter_simple(struct
>   	/* Tell the scheduler how much we idled: */
>   	sched_clock_idle_wakeup_event(idle_time_ns);
>
> -	local_irq_enable();
> +	hw_irq_enable();
>   	if (cx->entry_method != ACPI_CSTATE_FFH)
>   		current_thread_info()->status |= TS_POLLING;
>
> @@ -952,14 +952,14 @@ static int acpi_idle_enter_bm(struct cpu
>   			dev->last_state = dev->safe_state;
>   			return dev->safe_state->enter(dev, dev->safe_state);
>   		} else {
> -			local_irq_disable();
> +			hw_irq_disable();
>   			acpi_safe_halt();
> -			local_irq_enable();
> +			hw_irq_enable();
>   			return 0;
>   		}
>   	}
>
> -	local_irq_disable();
> +	hw_irq_disable();
>
>   	if (cx->entry_method != ACPI_CSTATE_FFH) {
>   		current_thread_info()->status&= ~TS_POLLING;
> @@ -971,7 +971,7 @@ static int acpi_idle_enter_bm(struct cpu
>
>   		if (unlikely(need_resched())) {
>   			current_thread_info()->status |= TS_POLLING;
> -			local_irq_enable();
> +			hw_irq_enable();
>   			return 0;
>   		}
>   	}
> @@ -1025,7 +1025,7 @@ static int acpi_idle_enter_bm(struct cpu
>   	/* Tell the scheduler how much we idled: */
>   	sched_clock_idle_wakeup_event(idle_time_ns);
>
> -	local_irq_enable();
> +	hw_irq_enable();
>   	if (cx->entry_method != ACPI_CSTATE_FFH)
>   		current_thread_info()->status |= TS_POLLING;
>
> Index: work/drivers/cpuidle/cpuidle.c
> ===================================================================
> --- work.orig/drivers/cpuidle/cpuidle.c
> +++ work/drivers/cpuidle/cpuidle.c
> @@ -61,7 +61,7 @@ static void cpuidle_idle_call(void)
>   #if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
>   			default_idle();
>   #else
> -			local_irq_enable();
> +			hw_irq_enable();
>   #endif
>   		return;
>   	}
> @@ -77,7 +77,7 @@ static void cpuidle_idle_call(void)
>   	/* ask the governor for the next state */
>   	next_state = cpuidle_curr_governor->select(dev);
>   	if (need_resched()) {
> -		local_irq_enable();
> +		hw_irq_enable();
>   		return;
>   	}
>
> @@ -229,7 +229,7 @@ static int poll_idle(struct cpuidle_devi
>   	int ret;
>
>   	t1 = ktime_get();
> -	local_irq_enable();
> +	hw_irq_enable();
>   	while (!need_resched())
>   		cpu_relax();
>
> Index: work/include/linux/irqflags.h
> ===================================================================
> --- work.orig/include/linux/irqflags.h
> +++ work/include/linux/irqflags.h
> @@ -79,6 +79,17 @@
>   			raw_local_irq_restore(flags);	\
>   		}					\
>   	} while (0)
> +
> +#ifndef __ARCH_HAS_HW_IRQ
> +#define raw_hw_irq_enable()		raw_local_irq_enable()
> +#define raw_hw_irq_disable()		raw_local_irq_disable()
> +#endif
> +
> +#define hw_irq_enable() \
> +	do { trace_hardirqs_on(); raw_hw_irq_enable(); } while (0)
> +#define hw_irq_disable() \
> +	do { raw_hw_irq_disable(); trace_hardirqs_off(); } while (0)
> +
>   #else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
>   /*
>    * The local_irq_*() APIs are equal to the raw_local_irq*()
> @@ -96,6 +107,10 @@
>   		typecheck(unsigned long, flags);	\
>   		local_irq_restore(flags);		\
>   	} while (0)
> +# define raw_hw_irq_enable()		raw_local_irq_enable()
> +# define raw_hw_irq_disable()		raw_local_irq_disable()
> +# define hw_irq_enable()		raw_hw_irq_enable()
> +# define hw_irq_disable()		raw_hw_irq_disable()
>   #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
>
>   #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
> @@ -124,6 +139,22 @@
>   	typecheck(unsigned long, flags);	\
>   	raw_irqs_disabled_flags(flags);		\
>   })
> +
> +#ifdef __ARCH_HAS_HW_IRQ
> +static inline bool hw_irqs_disabled(void)
> +{
> +	unsigned long flags;
> +
> +	if (irqs_disabled())
> +		return true;
> +
> +	raw_hw_irq_save_flags(flags);
> +	return raw_hw_irqs_disabled_flags(flags);
> +}
> +#else	/* __ARCH_HAS_HW_IRQ */
> +#define hw_irqs_disabled()		irqs_disabled()
> +#endif	/* __ARCH_HAS_HW_IRQ */
> +
>   #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
>
>   #endif
> Index: work/init/main.c
> ===================================================================
> --- work.orig/init/main.c
> +++ work/init/main.c
> @@ -626,7 +626,7 @@ asmlinkage void __init start_kernel(void
>   		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
>   				 "enabled early\n");
>   	early_boot_irqs_on();
> -	local_irq_enable();
> +	hw_irq_enable();
>
>   	/* Interrupts are enabled now so all GFP allocations are safe. */
>   	gfp_allowed_mask = __GFP_BITS_MASK;
> Index: work/arch/x86/include/asm/system.h
> ===================================================================
> --- work.orig/arch/x86/include/asm/system.h
> +++ work/arch/x86/include/asm/system.h
> @@ -102,8 +102,8 @@ do {									\
>   #define __RESTORE(reg, offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
>
>   /* frame pointer must be last for get_wchan */
> -#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> -#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
> +#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> +#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\t"
>
>   #define __EXTRA_CLOBBER  \
>   	, "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
> Index: work/arch/x86/ia32/ia32entry.S
> ===================================================================
> --- work.orig/arch/x86/ia32/ia32entry.S
> +++ work/arch/x86/ia32/ia32entry.S
> @@ -162,7 +162,7 @@ sysenter_dispatch:
>   	movq	%rax,RAX-ARGOFFSET(%rsp)
>   	GET_THREAD_INFO(%r10)
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	testl	$_TIF_ALLWORK_MASK,TI_flags(%r10)
>   	jnz	sysexit_audit
>   sysexit_from_sys_call:
> @@ -182,7 +182,7 @@ sysexit_from_sys_call:
>   	popq	%rcx				/* User %esp */
>   	CFI_ADJUST_CFA_OFFSET -8
>   	CFI_REGISTER rsp,rcx
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS_SYSEXIT32
>
>   #ifdef CONFIG_AUDITSYSCALL
> @@ -207,7 +207,7 @@ sysexit_from_sys_call:
>   	.macro auditsys_exit exit
>   	testl $(_TIF_ALLWORK_MASK&  ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
>   	jnz ia32_ret_from_sys_call
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	sti
>   	movl %eax,%esi		/* second arg, syscall return value */
>   	cmpl $0,%eax		/* is it<  0? */
> @@ -219,7 +219,7 @@ sysexit_from_sys_call:
>   	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
>   	movl $(_TIF_ALLWORK_MASK&  ~_TIF_SYSCALL_AUDIT),%edi
>   	cli
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	testl %edi,TI_flags(%r10)
>   	jz \exit
>   	CLEAR_RREGS -ARGOFFSET
> @@ -323,7 +323,7 @@ cstar_dispatch:
>   	movq %rax,RAX-ARGOFFSET(%rsp)
>   	GET_THREAD_INFO(%r10)
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	testl $_TIF_ALLWORK_MASK,TI_flags(%r10)
>   	jnz sysretl_audit
>   sysretl_from_sys_call:
> @@ -336,7 +336,7 @@ sysretl_from_sys_call:
>   	xorq	%r10,%r10
>   	xorq	%r9,%r9
>   	xorq	%r8,%r8
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	movl RSP-ARGOFFSET(%rsp),%esp
>   	CFI_RESTORE rsp
>   	USERGS_SYSRET32
> Index: work/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- work.orig/arch/x86/kernel/cpu/common.c
> +++ work/arch/x86/kernel/cpu/common.c
> @@ -1005,6 +1005,14 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
>
>   DEFINE_PER_CPU(unsigned int, irq_count) = -1;
>
> +DEFINE_PER_CPU(unsigned int, x86_irq_enable) = 0;
> +EXPORT_PER_CPU_SYMBOL(x86_irq_enable);
> +
> +DEFINE_PER_CPU(unsigned long, x86_irq_pending) = 0;
> +EXPORT_PER_CPU_SYMBOL(x86_irq_pending);

How do you handle multiple pending interrupts?  Or does something 
prevent multiple interrupts from being pending at the same time?

In Xen the pending and mask flags are adjacent bytes, which makes 
something like the "pending and unmasked" test needed for restore_irq 
very neat (see arch/x86/xen/xen-asm.S xen_restore_fl_direct).  It's also 
probably more cache-friendly.


> +
> +DEFINE_PER_CPU(void (*)(struct pt_regs *), x86_irq_pending_handler) = NULL;
> +
>   /*
>    * Special IST stacks which the CPU switches to when it calls
>    * an IST-marked descriptor entry. Up to 7 stacks (hardware
> @@ -1211,7 +1219,7 @@ void __cpuinit cpu_init(void)
>   	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
>   		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
>   		for (;;)
> -			local_irq_enable();
> +			hw_irq_enable();
>   	}
>
>   	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
> Index: work/arch/x86/kernel/entry_64.S
> ===================================================================
> --- work.orig/arch/x86/kernel/entry_64.S
> +++ work/arch/x86/kernel/entry_64.S
> @@ -175,11 +175,11 @@ ENDPROC(native_usergs_sysret64)
>   #endif /* CONFIG_PARAVIRT */
>
>
> -.macro TRACE_IRQS_IRETQ offset=ARGOFFSET
> +.macro TRACE_HW_IRQS_IRETQ offset=ARGOFFSET
>   #ifdef CONFIG_TRACE_IRQFLAGS
>   	bt   $9,EFLAGS-\offset(%rsp)	/* interrupts off? */
>   	jnc  1f
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   1:
>   #endif
>   .endm
> @@ -317,17 +317,14 @@ ENTRY(save_args)
>   	leaq -ARGOFFSET+16(%rsp),%rdi	/* arg1 for handler */
>   	movq_cfi rbp, 8		/* push %rbp */
>   	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
> -	testl $3, CS(%rdi)
> -	je 1f
> -	SWAPGS
>   	/*
>   	 * irq_count is used to check if a CPU is already on an interrupt stack
>   	 * or not. While this is essentially redundant with preempt_count it is
>   	 * a little cheaper to use a separate counter in the PDA (short of
>   	 * moving irq_enter into assembly, which would be too much work)
>   	 */
> -1:	incl PER_CPU_VAR(irq_count)
> -	jne 2f
> +	incl PER_CPU_VAR(irq_count)
> +	jne 1f
>   	popq_cfi %rax			/* move return address... */
>   	mov PER_CPU_VAR(irq_stack_ptr),%rsp
>   	EMPTY_FRAME 0
> @@ -336,7 +333,7 @@ ENTRY(save_args)
>   	/*
>   	 * We entered an interrupt context - irqs are off:
>   	 */
> -2:	TRACE_IRQS_OFF
> +1:	TRACE_HW_IRQS_OFF
>   	ret
>   	CFI_ENDPROC
>   END(save_args)
> @@ -497,7 +494,7 @@ sysret_check:
>   	LOCKDEP_SYS_EXIT
>   	GET_THREAD_INFO(%rcx)
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	movl TI_flags(%rcx),%edx
>   	andl %edi,%edx
>   	jnz  sysret_careful
> @@ -505,7 +502,7 @@ sysret_check:
>   	/*
>   	 * sysretq will re-enable interrupts:
>   	 */
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	movq RIP-ARGOFFSET(%rsp),%rcx
>   	CFI_REGISTER	rip,rcx
>   	RESTORE_ARGS 0,-ARG_SKIP,1
> @@ -519,7 +516,7 @@ sysret_check:
>   sysret_careful:
>   	bt $TIF_NEED_RESCHED,%edx
>   	jnc sysret_signal
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS(CLBR_NONE)
>   	pushq %rdi
>   	CFI_ADJUST_CFA_OFFSET 8
> @@ -530,7 +527,7 @@ sysret_careful:
>
>   	/* Handle a signal */
>   sysret_signal:
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS(CLBR_NONE)
>   #ifdef CONFIG_AUDITSYSCALL
>   	bt $TIF_SYSCALL_AUDIT,%edx
> @@ -612,7 +609,7 @@ tracesys:
>    */
>   GLOBAL(int_ret_from_sys_call)
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	testl $3,CS-ARGOFFSET(%rsp)
>   	je retint_restore_args
>   	movl $_TIF_ALLWORK_MASK,%edi
> @@ -632,7 +629,7 @@ GLOBAL(int_with_check)
>   int_careful:
>   	bt $TIF_NEED_RESCHED,%edx
>   	jnc  int_very_careful
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS(CLBR_NONE)
>   	pushq %rdi
>   	CFI_ADJUST_CFA_OFFSET 8
> @@ -640,12 +637,12 @@ int_careful:
>   	popq %rdi
>   	CFI_ADJUST_CFA_OFFSET -8
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	jmp int_with_check
>
>   	/* handle signals and tracing -- both require a full stack frame */
>   int_very_careful:
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS(CLBR_NONE)
>   int_check_syscall_exit_work:
>   	SAVE_REST
> @@ -671,7 +668,7 @@ int_signal:
>   int_restore_rest:
>   	RESTORE_REST
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	jmp int_with_check
>   	CFI_ENDPROC
>   END(system_call)
> @@ -796,11 +793,22 @@ END(interrupt)
>
>   /* 0(%rsp): ~(interrupt number) */
>   	.macro interrupt func
> +	testl $3, CS-ORIG_RAX(%rsp)
> +	je 1f
> +	SWAPGS
> +1:	btrl $0, PER_CPU_VAR(x86_irq_enable)

What state is the real eflags.IF at this point?  Disabled?

> +	jc 2f
> +	pushq $\func
> +	CFI_ADJUST_CFA_OFFSET 8
> +	jmp mark_irq_pending
> +2:	TRACE_IRQS_OFF
>   	subq $10*8, %rsp
>   	CFI_ADJUST_CFA_OFFSET 10*8
>   	call save_args
>   	PARTIAL_FRAME 0
>   	call \func
> +	TRACE_IRQS_ON
> +	movl $1, PER_CPU_VAR(x86_irq_enable)

Does this leave the interrupts logically enabled, but physically 
disabled (until the final iret)?

>   	.endm
>
>   /*
> @@ -818,8 +826,6 @@ common_interrupt:
>   	interrupt do_IRQ
>   	/* 0(%rsp): old_rsp-ARGOFFSET */
>   ret_from_intr:
> -	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
>   	decl PER_CPU_VAR(irq_count)
>   	leaveq
>   	CFI_DEF_CFA_REGISTER	rsp
> @@ -844,21 +850,8 @@ retint_check:
>   	jnz  retint_careful
>
>   retint_swapgs:		/* return to user-space */
> -	/*
> -	 * The iretq could re-enable interrupts:
> -	 */
> -	DISABLE_INTERRUPTS(CLBR_ANY)
> -	TRACE_IRQS_IRETQ
>   	SWAPGS
> -	jmp restore_args
> -
>   retint_restore_args:	/* return to kernel space */
> -	DISABLE_INTERRUPTS(CLBR_ANY)
> -	/*
> -	 * The iretq could re-enable interrupts:
> -	 */
> -	TRACE_IRQS_IRETQ
> -restore_args:
>   	RESTORE_ARGS 0,8,0
>
>   irq_return:
> @@ -901,7 +894,7 @@ retint_careful:
>   	CFI_RESTORE_STATE
>   	bt    $TIF_NEED_RESCHED,%edx
>   	jnc   retint_signal
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS(CLBR_NONE)
>   	pushq %rdi
>   	CFI_ADJUST_CFA_OFFSET	8
> @@ -910,13 +903,13 @@ retint_careful:
>   	CFI_ADJUST_CFA_OFFSET	-8
>   	GET_THREAD_INFO(%rcx)
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	jmp retint_check
>
>   retint_signal:
>   	testl $_TIF_DO_NOTIFY_MASK,%edx
>   	jz    retint_swapgs
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS(CLBR_NONE)
>   	SAVE_REST
>   	movq $-1,ORIG_RAX(%rsp)
> @@ -925,7 +918,7 @@ retint_signal:
>   	call do_notify_resume
>   	RESTORE_REST
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	GET_THREAD_INFO(%rcx)
>   	jmp retint_with_reschedule
>
> @@ -937,14 +930,62 @@ ENTRY(retint_kernel)
>   	jnz  retint_restore_args
>   	bt  $TIF_NEED_RESCHED,TI_flags(%rcx)
>   	jnc  retint_restore_args
> -	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
> +	bt   $0, PER_CPU_VAR(x86_irq_enable)	/* interrupts off? */
>   	jnc  retint_restore_args
> +	bt   $9, EFLAGS-ARGOFFSET(%rsp)		/* hw interrupts off? */
> +	jnc  retint_restore_args
> +	movl $0, PER_CPU_VAR(x86_irq_enable)
> +	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_ON
> +	ENABLE_INTERRUPTS(CLBR_NONE)
>   	call preempt_schedule_irq
> +	DISABLE_INTERRUPTS(CLBR_NONE)
> +	TRACE_HW_IRQS_OFF
> +	TRACE_IRQS_ON
> +	movl $1, PER_CPU_VAR(x86_irq_enable)
>   	jmp exit_intr
>   #endif
>
>   	CFI_ENDPROC
>   END(common_interrupt)
> +
> +mark_irq_pending:
> +	XCPT_FRAME 1 8
> +	btl $31, PER_CPU_VAR(x86_irq_pending)	/* negative if pending */
> +	jc 1f
> +	popq PER_CPU_VAR(x86_irq_pending_handler)
> +	CFI_ADJUST_CFA_OFFSET -8
> +	popq PER_CPU_VAR(x86_irq_pending)
> +	CFI_ADJUST_CFA_OFFSET -8
> +	andl $~X86_EFLAGS_IF, EFLAGS-RIP(%rsp)
> +	testl $3, CS-RIP(%rsp)
> +	je irq_return
> +	SWAPGS
> +	jmp irq_return
> +1:	ud2
> +	CFI_ENDPROC
> +
> +/* void call_on_irq_stack(void *fn, void *arg) */
> +ENTRY(call_on_irq_stack)
> +	CFI_STARTPROC
> +	pushq_cfi %rbp
> +	CFI_REL_OFFSET rbp, 0
> +	movq %rsp, %rbp
> +	CFI_DEF_CFA_REGISTER %rbp
> +	incl PER_CPU_VAR(irq_count)
> +	cmove PER_CPU_VAR(irq_stack_ptr),%rsp
> +	pushq %rbp			# backlink for old unwinder
> +	movq %rdi, %rcx
> +	movq %rsi, %rdi
> +	call *%rcx
> +	leaveq
> +	CFI_DEF_CFA_REGISTER %rsp
> +	CFI_ADJUST_CFA_OFFSET -8
> +	decl PER_CPU_VAR(irq_count)
> +	ret
> +	CFI_ENDPROC
> +END(cal_irq_handler)
> +
>   /*
>    * End of kprobes section
>    */
> @@ -1056,7 +1097,7 @@ ENTRY(\sym)
>   	CFI_ADJUST_CFA_OFFSET 8
>   	subq $15*8, %rsp
>   	call save_paranoid
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	movq %rsp,%rdi		/* pt_regs pointer */
>   	xorl %esi,%esi		/* no error code */
>   	call \do_sym
> @@ -1073,7 +1114,7 @@ ENTRY(\sym)
>   	CFI_ADJUST_CFA_OFFSET 8
>   	subq $15*8, %rsp
>   	call save_paranoid
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	movq %rsp,%rdi		/* pt_regs pointer */
>   	xorl %esi,%esi		/* no error code */
>   	PER_CPU(init_tss, %r12)
> @@ -1111,7 +1152,7 @@ ENTRY(\sym)
>   	CFI_ADJUST_CFA_OFFSET 15*8
>   	call save_paranoid
>   	DEFAULT_FRAME 0
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	movq %rsp,%rdi			/* pt_regs pointer */
>   	movq ORIG_RAX(%rsp),%rsi	/* get error code */
>   	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
> @@ -1367,18 +1408,18 @@ paranoidzeroentry machine_check *machine
>   ENTRY(paranoid_exit)
>   	INTR_FRAME
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	testl %ebx,%ebx				/* swapgs needed? */
>   	jnz paranoid_restore
>   	testl $3,CS(%rsp)
>   	jnz   paranoid_userspace
>   paranoid_swapgs:
> -	TRACE_IRQS_IRETQ 0
> +	TRACE_HW_IRQS_IRETQ 0
>   	SWAPGS_UNSAFE_STACK
>   	RESTORE_ALL 8
>   	jmp irq_return
>   paranoid_restore:
> -	TRACE_IRQS_IRETQ 0
> +	TRACE_HW_IRQS_IRETQ 0
>   	RESTORE_ALL 8
>   	jmp irq_return
>   paranoid_userspace:
> @@ -1392,20 +1433,20 @@ paranoid_userspace:
>   	testl $_TIF_NEED_RESCHED,%ebx
>   	jnz paranoid_schedule
>   	movl %ebx,%edx			/* arg3: thread flags */
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS(CLBR_NONE)
>   	xorl %esi,%esi 			/* arg2: oldset */
>   	movq %rsp,%rdi 			/* arg1:&pt_regs */
>   	call do_notify_resume
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	jmp paranoid_userspace
>   paranoid_schedule:
> -	TRACE_IRQS_ON
> +	TRACE_HW_IRQS_ON
>   	ENABLE_INTERRUPTS(CLBR_ANY)
>   	call schedule
>   	DISABLE_INTERRUPTS(CLBR_ANY)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	jmp paranoid_userspace
>   	CFI_ENDPROC
>   END(paranoid_exit)
> @@ -1440,7 +1481,7 @@ ENTRY(error_entry)
>   error_swapgs:
>   	SWAPGS
>   error_sti:
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	ret
>   	CFI_ENDPROC
>
> @@ -1476,7 +1517,7 @@ ENTRY(error_exit)
>   	movl %ebx,%eax
>   	RESTORE_REST
>   	DISABLE_INTERRUPTS(CLBR_NONE)
> -	TRACE_IRQS_OFF
> +	TRACE_HW_IRQS_OFF
>   	GET_THREAD_INFO(%rcx)
>   	testl %eax,%eax
>   	jne retint_kernel
> @@ -1499,12 +1540,12 @@ ENTRY(nmi)
>   	CFI_ADJUST_CFA_OFFSET 15*8
>   	call save_paranoid
>   	DEFAULT_FRAME 0
> -	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
> +	/* paranoidentry do_nmi, 0; without TRACE_HW_IRQS_OFF */
>   	movq %rsp,%rdi
>   	movq $-1,%rsi
>   	call do_nmi
>   #ifdef CONFIG_TRACE_IRQFLAGS
> -	/* paranoidexit; without TRACE_IRQS_OFF */
> +	/* paranoidexit; without TRACE_HW_IRQS_OFF */
>   	/* ebx:	no swapgs flag */
>   	DISABLE_INTERRUPTS(CLBR_NONE)
>   	testl %ebx,%ebx				/* swapgs needed? */
> Index: work/arch/x86/kernel/process.c
> ===================================================================
> --- work.orig/arch/x86/kernel/process.c
> +++ work/arch/x86/kernel/process.c
> @@ -381,11 +381,10 @@ void default_idle(void)
>
>   		if (!need_resched())
>   			safe_halt();	/* enables interrupts racelessly */
> -		else
> -			local_irq_enable();
> +		hw_irq_enable();
>   		current_thread_info()->status |= TS_POLLING;
>   	} else {
> -		local_irq_enable();
> +		hw_irq_enable();
>   		/* loop is done by the caller */
>   		cpu_relax();
>   	}
> @@ -396,7 +395,7 @@ EXPORT_SYMBOL(default_idle);
>
>   void stop_this_cpu(void *dummy)
>   {
> -	local_irq_disable();
> +	hw_irq_disable();
>   	/*
>   	 * Remove this CPU:
>   	 */
> @@ -465,10 +464,8 @@ static void mwait_idle(void)
>   		smp_mb();
>   		if (!need_resched())
>   			__sti_mwait(0, 0);
> -		else
> -			local_irq_enable();
> -	} else
> -		local_irq_enable();
> +	}
> +	hw_irq_enable();
>   }
>
>   /*
> @@ -479,7 +476,7 @@ static void mwait_idle(void)
>   static void poll_idle(void)
>   {
>   	trace_power_start(POWER_CSTATE, 0);
> -	local_irq_enable();
> +	hw_irq_enable();
>   	while (!need_resched())
>   		cpu_relax();
>   	trace_power_end(0);
> @@ -614,9 +611,9 @@ static void c1e_idle(void)
>   		 * The switch back from broadcast mode needs to be
>   		 * called with interrupts disabled.
>   		 */
> -		 local_irq_disable();
> -		 clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,&cpu);
> -		 local_irq_enable();
> +		hw_irq_disable();
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,&cpu);
> +		hw_irq_enable();
>   	} else
>   		default_idle();
>   }
> Index: work/arch/x86/include/asm/irqflags.h
> ===================================================================
> --- work.orig/arch/x86/include/asm/irqflags.h
> +++ work/arch/x86/include/asm/irqflags.h
> @@ -4,6 +4,13 @@
>   #include<asm/processor-flags.h>
>
>   #ifndef __ASSEMBLY__
> +
> +#include<asm/percpu.h>
> +
> +DECLARE_PER_CPU(unsigned int, x86_irq_enable);		/* boolean switch */
> +DECLARE_PER_CPU(unsigned long, x86_irq_pending);	/* pending vector */
> +DECLARE_PER_CPU(void (*)(struct pt_regs *), x86_irq_pending_handler);
> +
>   /*
>    * Interrupt control:
>    */
> @@ -54,6 +61,45 @@ static inline void native_halt(void)
>   	asm volatile("hlt": : :"memory");
>   }
>
> +extern void __raw_local_irq_enable_slow_path(void);
> +
> +static inline unsigned long __raw_local_save_flags(void)
> +{
> +	return percpu_read(x86_irq_enable);
> +}
> +
> +static inline void raw_local_irq_restore(unsigned long flags)
> +{
> +	barrier();
> +	percpu_write(x86_irq_enable, flags);
> +	barrier();
> +	if (flags&&  unlikely(percpu_read(x86_irq_pending)))
> +		__raw_local_irq_enable_slow_path();
> +}
> +
> +static inline void raw_local_irq_disable(void)
> +{
> +	percpu_write(x86_irq_enable, 0);
> +	barrier();
> +}
> +
> +static inline void raw_local_irq_enable(void)
> +{
> +	barrier();
> +	percpu_write(x86_irq_enable, 1);
> +	barrier();
> +	if (unlikely(percpu_read(x86_irq_pending)))
> +		__raw_local_irq_enable_slow_path();
> +}
> +
> +static inline unsigned long __raw_local_irq_save(void)
> +{
> +	unsigned long flags = __raw_local_save_flags();
> +
> +	raw_local_irq_disable();
> +
> +	return flags;
> +}
>   #endif
>
>   #ifdef CONFIG_PARAVIRT
> @@ -61,22 +107,17 @@ static inline void native_halt(void)
>   #else
>   #ifndef __ASSEMBLY__
>
> -static inline unsigned long __raw_local_save_flags(void)
> +static inline unsigned long __raw_hw_save_flags(void)
>   {
>   	return native_save_fl();
>   }
>
> -static inline void raw_local_irq_restore(unsigned long flags)
> -{
> -	native_restore_fl(flags);
> -}
> -
> -static inline void raw_local_irq_disable(void)
> +static inline void __raw_hw_irq_disable(void)
>   {
>   	native_irq_disable();
>   }
>
> -static inline void raw_local_irq_enable(void)
> +static inline void __raw_hw_irq_enable(void)
>   {
>   	native_irq_enable();
>   }
> @@ -87,6 +128,7 @@ static inline void raw_local_irq_enable(
>    */
>   static inline void raw_safe_halt(void)
>   {
> +	percpu_write(x86_irq_enable, 1);
>   	native_safe_halt();
>   }
>
> @@ -99,17 +141,6 @@ static inline void halt(void)
>   	native_halt();
>   }
>
> -/*
> - * For spinlocks, etc:
> - */
> -static inline unsigned long __raw_local_irq_save(void)
> -{
> -	unsigned long flags = __raw_local_save_flags();
> -
> -	raw_local_irq_disable();
> -
> -	return flags;
> -}
>   #else
>
>   #define ENABLE_INTERRUPTS(x)	sti
> @@ -161,14 +192,34 @@ static inline unsigned long __raw_local_
>
>   static inline int raw_irqs_disabled_flags(unsigned long flags)
>   {
> -	return !(flags&  X86_EFLAGS_IF);
> +	return !flags;
>   }
>
>   static inline int raw_irqs_disabled(void)
>   {
> -	unsigned long flags = __raw_local_save_flags();
> +	return raw_irqs_disabled_flags(__raw_local_save_flags());
> +}
> +
> +#define __ARCH_HAS_HW_IRQ
> +
> +#define raw_hw_irq_save_flags(flags)				\
> +	do { (flags) = __raw_hw_save_flags(); } while (0)
> +
> +static inline void raw_hw_irq_disable(void)
> +{
> +	__raw_hw_irq_disable();
> +	percpu_write(x86_irq_enable, 0);
> +}
>
> -	return raw_irqs_disabled_flags(flags);
> +static inline void raw_hw_irq_enable(void)
> +{
> +	raw_local_irq_enable();
> +	__raw_hw_irq_enable();
> +}
> +
> +static inline int raw_hw_irqs_disabled_flags(unsigned long flags)
> +{
> +	return !(flags&  X86_EFLAGS_IF);
>   }
>
>   #else
> @@ -176,13 +227,13 @@ static inline int raw_irqs_disabled(void
>   #ifdef CONFIG_X86_64
>   #define ARCH_LOCKDEP_SYS_EXIT		call lockdep_sys_exit_thunk
>   #define ARCH_LOCKDEP_SYS_EXIT_IRQ	\
> -	TRACE_IRQS_ON; \
> +	TRACE_HW_IRQS_ON; \
>   	sti; \
>   	SAVE_REST; \
>   	LOCKDEP_SYS_EXIT; \
>   	RESTORE_REST; \
>   	cli; \
> -	TRACE_IRQS_OFF;
> +	TRACE_HW_IRQS_OFF;
>
>   #else
>   #define ARCH_LOCKDEP_SYS_EXIT			\
> @@ -212,5 +263,9 @@ static inline int raw_irqs_disabled(void
>   #  define LOCKDEP_SYS_EXIT_IRQ
>   # endif
>
> +/* HW IRQS tracing isn't implemented yet */
> +#define TRACE_HW_IRQS_ON
> +#define TRACE_HW_IRQS_OFF
> +
>   #endif /* __ASSEMBLY__ */
>   #endif
> Index: work/arch/x86/kernel/process_64.c
> ===================================================================
> --- work.orig/arch/x86/kernel/process_64.c
> +++ work/arch/x86/kernel/process_64.c
> @@ -132,7 +132,7 @@ void cpu_idle(void)
>   			 * from here on, until they go to idle.
>   			 * Otherwise, idle callbacks can misfire.
>   			 */
> -			local_irq_disable();
> +			hw_irq_disable();
>   			enter_idle();
>   			/* Don't trace irqs off for idle */
>   			stop_critical_timings();
> Index: work/arch/x86/kernel/smpboot.c
> ===================================================================
> --- work.orig/arch/x86/kernel/smpboot.c
> +++ work/arch/x86/kernel/smpboot.c
> @@ -1364,7 +1364,7 @@ void play_dead_common(void)
>   	/*
>   	 * With physical CPU hotplug, we should halt the cpu
>   	 */
> -	local_irq_disable();
> +	hw_irq_disable();
>   }
>
>   void native_play_dead(void)
> Index: work/arch/x86/include/asm/paravirt.h
> ===================================================================
> --- work.orig/arch/x86/include/asm/paravirt.h
> +++ work/arch/x86/include/asm/paravirt.h
> @@ -107,6 +107,7 @@ static inline void write_cr8(unsigned lo
>
>   static inline void raw_safe_halt(void)
>   {
> +	percpu_write(x86_irq_enable, 1);
>   	PVOP_VCALL0(pv_irq_ops.safe_halt);
>   }
>
> @@ -829,35 +830,21 @@ static __always_inline void arch_spin_un
>   #define __PV_IS_CALLEE_SAVE(func)			\
>   	((struct paravirt_callee_save) { func })
>
> -static inline unsigned long __raw_local_save_flags(void)
> +static inline unsigned long __raw_hw_save_flags(void)
>   {
>   	return PVOP_CALLEE0(unsigned long, pv_irq_ops.save_fl);
>   }
>
> -static inline void raw_local_irq_restore(unsigned long f)
> -{
> -	PVOP_VCALLEE1(pv_irq_ops.restore_fl, f);
> -}
> -
> -static inline void raw_local_irq_disable(void)
> +static inline void __raw_hw_irq_disable(void)
>   {
>   	PVOP_VCALLEE0(pv_irq_ops.irq_disable);
>   }
>
> -static inline void raw_local_irq_enable(void)
> +static inline void __raw_hw_irq_enable(void)
>   {
>   	PVOP_VCALLEE0(pv_irq_ops.irq_enable);
>   }
>
> -static inline unsigned long __raw_local_irq_save(void)
> -{
> -	unsigned long f;
> -
> -	f = __raw_local_save_flags();
> -	raw_local_irq_disable();
> -	return f;
> -}
> -
>
>   /* Make sure as little as possible of this mess escapes. */
>   #undef PARAVIRT_CALL
> Index: work/arch/x86/kernel/irq.c
> ===================================================================
> --- work.orig/arch/x86/kernel/irq.c
> +++ work/arch/x86/kernel/irq.c
> @@ -14,6 +14,7 @@
>   #include<asm/idle.h>
>   #include<asm/mce.h>
>   #include<asm/hw_irq.h>
> +#include<asm/desc.h>
>
>   atomic_t irq_err_count;
>
> @@ -217,6 +218,26 @@ u64 arch_irq_stat(void)
>   	return sum;
>   }
>
> +void call_on_irq_stack(void *fn, void *arg);
> +
> +void __raw_local_irq_enable_slow_path(void)
> +{
> +	struct pt_regs regs;
> +
> +	regs.sp = (unsigned long)&regs;
> +	regs.orig_ax = percpu_read(x86_irq_pending);
> +	regs.flags = 0x2;	/* bit 1 is always set */
> +
> +	percpu_write(x86_irq_enable, 0);
> +	percpu_write(x86_irq_pending, 0);
> +
> +	call_on_irq_stack(percpu_read(x86_irq_pending_handler),&regs);
> +
> +	trace_hardirqs_on();
> +	percpu_write(x86_irq_enable, 1);
> +	__raw_hw_irq_enable();
> +}
> +EXPORT_SYMBOL(__raw_local_irq_enable_slow_path);
>
>   /*
>    * do_IRQ handles all normal device IRQ's (the special
> Index: work/arch/x86/kernel/traps.c
> ===================================================================
> --- work.orig/arch/x86/kernel/traps.c
> +++ work/arch/x86/kernel/traps.c
> @@ -86,26 +86,26 @@ static int ignore_nmis;
>   static inline void conditional_sti(struct pt_regs *regs)
>   {
>   	if (regs->flags&  X86_EFLAGS_IF)
> -		local_irq_enable();
> +		__raw_hw_irq_enable();
>   }
>
>   static inline void preempt_conditional_sti(struct pt_regs *regs)
>   {
>   	inc_preempt_count();
>   	if (regs->flags&  X86_EFLAGS_IF)
> -		local_irq_enable();
> +		__raw_hw_irq_enable();
>   }
>
>   static inline void conditional_cli(struct pt_regs *regs)
>   {
>   	if (regs->flags&  X86_EFLAGS_IF)
> -		local_irq_disable();
> +		__raw_hw_irq_disable();
>   }
>
>   static inline void preempt_conditional_cli(struct pt_regs *regs)
>   {
>   	if (regs->flags&  X86_EFLAGS_IF)
> -		local_irq_disable();
> +		__raw_hw_irq_disable();
>   	dec_preempt_count();
>   }
>
> @@ -283,7 +283,7 @@ do_general_protection(struct pt_regs *re
>
>   #ifdef CONFIG_X86_32
>   gp_in_vm86:
> -	local_irq_enable();
> +	__raw_hw_irq_enable();
>   	handle_vm86_fault((struct kernel_vm86_regs *) regs, error_code);
>   	return;
>   #endif
> @@ -749,7 +749,7 @@ asmlinkage void math_state_restore(void)
>   	struct task_struct *tsk = thread->task;
>
>   	if (!tsk_used_math(tsk)) {
> -		local_irq_enable();
> +		__raw_hw_irq_enable();
>   		/*
>   		 * does a slab alloc which can sleep
>   		 */
> @@ -760,7 +760,7 @@ asmlinkage void math_state_restore(void)
>   			do_group_exit(SIGKILL);
>   			return;
>   		}
> -		local_irq_disable();
> +		__raw_hw_irq_disable();
>   	}
>
>   	clts();				/* Allow maths ops (or we recurse) */
> @@ -804,7 +804,7 @@ do_device_not_available(struct pt_regs *
>   dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
>   {
>   	siginfo_t info;
> -	local_irq_enable();
> +	__raw_hw_irq_enable();
>
>   	info.si_signo = SIGILL;
>   	info.si_errno = 0;
> Index: work/arch/x86/mm/fault.c
> ===================================================================
> --- work.orig/arch/x86/mm/fault.c
> +++ work/arch/x86/mm/fault.c
> @@ -711,7 +711,7 @@ __bad_area_nosemaphore(struct pt_regs *r
>   		/*
>   		 * It's possible to have interrupts off here:
>   		 */
> -		local_irq_enable();
> +		__raw_hw_irq_enable();
>
>   		/*
>   		 * Valid to do another page fault here because this one came
> @@ -1019,11 +1019,11 @@ do_page_fault(struct pt_regs *regs, unsi
>   	 * potential system fault or CPU buglet:
>   	 */
>   	if (user_mode_vm(regs)) {
> -		local_irq_enable();
> +		__raw_hw_irq_enable();
>   		error_code |= PF_USER;
>   	} else {
>   		if (regs->flags&  X86_EFLAGS_IF)
> -			local_irq_enable();
> +			__raw_hw_irq_enable();
>   	}
>
>   	if (unlikely(error_code&  PF_RSVD))
> Index: work/lib/smp_processor_id.c
> ===================================================================
> --- work.orig/lib/smp_processor_id.c
> +++ work/lib/smp_processor_id.c
> @@ -15,7 +15,7 @@ notrace unsigned int debug_smp_processor
>   	if (likely(preempt_count))
>   		goto out;
>
> -	if (irqs_disabled())
> +	if (hw_irqs_disabled())
>   		goto out;
>
>   	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

