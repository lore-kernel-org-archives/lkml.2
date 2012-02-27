Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2B0JNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:13:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40102 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2B0JNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:13:01 -0500
Date: Mon, 27 Feb 2012 10:12:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH] uprobes/core: handle breakpoint and signal step
 exception.
Message-ID: <20120227091212.GA7092@elte.hu>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Uprobes uses exception notifiers to get to know if a thread 
> hit a breakpoint or singlestep exception.
> 
> When a thread hits a uprobe or is singlestepping post a uprobe 
> hit, the uprobe exception notifier, sets its TIF_UPROBE bit, 

[ only two commas needed in this line ]

> which will then be checked on its return to userspace path 
> (do_notify_resume() ->uprobe_notify_resume()), where the 
> consumers handlers are run (in task context) based on the 
> defined filters.
> 
> Uprobe hits are thread specific and hence we need to maintain 
> information about if a task hit a uprobe, what uprobe was hit, 
> the slot where the original instruction was copied for xol so 
> that it can be singlestepped with appropriate fixups.
> 
> In some cases, special care is needed for instructions that 
> are executed out of line (xol). These are architecture 
> specific artefacts, such as handling RIP relative instructions 
> on x86_64.
> 
> Since the instruction at which the uprobe was inserted is executed out
> of line, architecture specific fixups are added so that the thread
> continues normal execution in the presence of a uprobe.
> 
> Postpone the signals until we execute the probed insn. post_xol()
> path does a recalc_sigpending() before return to user-mode, this
> ensures the signal can't be lost.

Sigh - this is where a CPU emulator would be so much more robust 
- and we already have one in the KVM code.

> Uprobes relies on DIE_DEBUG notification to notify if a 
> singlestep is complete.
> 
> Adds x86 specific uprobe exception notifiers and appropriate 
> hooks needed to determine a uprobe hit and subsequent post 
> processing.
> 
> Add requisite x86 fixups for xol for uprobes. Specific cases 
> needing fixups include relative jumps (x86_64), calls, etc.
> 
> Where possible, we check and skip singlestepping the 
> breakpointed instructions. For now we skip single byte as well 
> as few multibyte nop instructions. However this can be 
> extended to other instructions too.

Is this an optimization - allowing a NOP to be inserted for easy 
probe insertion?

> Credit to Oleg Nesterov for suggestions/patches related to 
> signal, breakpoint, singlestep handling code.
> 
> Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 	---
> Changelog
> 
> (v10):
>  - Resolve comments suggested by Ingo Molnar.
>  - arch specific functions start with arch_uprobe_
> 
> (v9):
>  - Use instruction_pointer_set instead of set_instruction_pointer.
>  - Changed can_skip_xol to uprobe_skip_sstep as suggested by Ananth
> 
> (v7):
>  - Resolve comments from Dan Carpenter.
>  - add_utask returns NULL on error.
>  - Handles architecture agnostic parts of a uprobe breakpoint hit and
>    subsequent xol singlestepping.
> 
> (v6)
>  - added x86 specific hook for aborting xol.
> 
> (v5)
>  - Use srcu_raw instead of synchronize_sched
>  - Introduce per task srcu_id to store the srcu_id
>  - Modified comments.
>  - No more do a i386 specific enable interrupts. (Its not part of another
>    patch posted separately)
> ---
>  arch/x86/include/asm/thread_info.h |    2 
>  arch/x86/include/asm/uprobes.h     |   16 ++
>  arch/x86/kernel/signal.c           |    6 +
>  arch/x86/kernel/uprobes.c          |  275 +++++++++++++++++++++++++++++++++++
>  include/linux/sched.h              |    4 +
>  include/linux/uprobes.h            |   44 ++++++
>  kernel/events/uprobes.c            |  279 ++++++++++++++++++++++++++++++++++++
>  kernel/fork.c                      |    7 +
>  kernel/signal.c                    |    6 +
>  9 files changed, 629 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index af1db7e..2f06cdf 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -85,6 +85,7 @@ struct thread_info {
>  #define TIF_SECCOMP		8	/* secure computing */
>  #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
>  #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
> +#define TIF_UPROBE		12	/* breakpointed or singlestepping */
>  #define TIF_NOTSC		16	/* TSC is not accessible in userland */
>  #define TIF_IA32		17	/* IA32 compatibility process */
>  #define TIF_FORK		18	/* ret_from_fork */
> @@ -109,6 +110,7 @@ struct thread_info {
>  #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
>  #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
>  #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
> +#define _TIF_UPROBE		(1 << TIF_UPROBE)
>  #define _TIF_NOTSC		(1 << TIF_NOTSC)
>  #define _TIF_IA32		(1 << TIF_IA32)
>  #define _TIF_FORK		(1 << TIF_FORK)
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index f7ce310..d331577 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -23,6 +23,8 @@
>   *	Jim Keniston
>   */
>  
> +#include <linux/notifier.h>
> +
>  typedef u8 uprobe_opcode_t;
>  
>  #define MAX_UINSN_BYTES			  16
> @@ -39,5 +41,17 @@ struct arch_uprobe {
>  #endif
>  };
>  
> -extern int arch_uprobes_analyze_insn(struct mm_struct *mm, struct arch_uprobe *arch_uprobe);
> +struct arch_uprobe_task {
> +	unsigned long saved_trap_no;

trap_no in struct thread_struct and now in arch_uprobe_task is a 
misnomer - I always expect a trap_yes flag next to it ;-)

Please create a separate patch in front of this patch that 
trivially renames trap_no to something saner like trap_nr, and 
introduce this field as trap_nr as well.

> +#ifdef CONFIG_X86_64
> +	unsigned long saved_scratch_register;
> +#endif
> +};
> +
> +extern int arch_uprobe_analyze_insn(struct mm_struct *mm, struct arch_uprobe *arch_uprobe);
> +extern int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs);
> +extern int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs);
> +extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
> +extern int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
> +extern void arch_uprobe_abort_xol(struct pt_regs *regs, struct arch_uprobe *auprobe);

Small API parameter consistency nit:

We tend to order function parameters by importance: the more 
important parameter comes first.

In that sense arch_uprobe_pre_xol() and arch_uprobe_abort_xol() 
have obviously inconsistent ordering: the first one is
(aup, regs), the second one is (regs, aup).

Please make it consistent, at first glance the right one appears 
to be:

 aup, mm
 aup, regs
 aup, regs
 t
 self, val, data
 aup, regs

I'd put the arch_uprobe_analyze_insn() order change into a 
separate patch, preceding this patch.

>  #endif	/* _ASM_UPROBES_H */
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 5134e17..153fdaf 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -18,6 +18,7 @@
>  #include <linux/personality.h>
>  #include <linux/uaccess.h>
>  #include <linux/user-return-notifier.h>
> +#include <linux/uprobes.h>
>  
>  #include <asm/processor.h>
>  #include <asm/ucontext.h>
> @@ -824,6 +825,11 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
>  		mce_notify_process();
>  #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
>  
> +	if (thread_info_flags & _TIF_UPROBE) {
> +		clear_thread_flag(TIF_UPROBE);
> +		uprobe_notify_resume(regs);
> +	}
> +
>  	/* deal with pending signal delivery */
>  	if (thread_info_flags & _TIF_SIGPENDING)
>  		do_signal(regs);
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 04dfcef..5e60ac2 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -24,10 +24,17 @@
>  #include <linux/sched.h>
>  #include <linux/ptrace.h>
>  #include <linux/uprobes.h>
> +#include <linux/uaccess.h>
>  
>  #include <linux/kdebug.h>
>  #include <asm/insn.h>
>  
> +#ifdef CONFIG_X86_32
> +#define is_32bit_app(tsk) 1
> +#else
> +#define is_32bit_app(tsk) (test_tsk_thread_flag(tsk, TIF_IA32))
> +#endif

Small detail, we prefer to use this variant:

#ifdef X
# define foo()
#else
# define bar()
#endif

to give the construct more visual structure.

Also, please put it into asm/compat.h and use it at other places 
within arch/x86/ as well, there's half a dozen similar patterns 
of TIP_IA32 tests in arch/x86/. Please make this a separate 
patch, preceding this patch.

Also, how does this interact with the new x32 ABI code in -tip?

> +
>  /* Post-execution fixups. */
>  
>  /* No fixup needed */
> @@ -221,10 +228,9 @@ static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
>  }
>  
>  /*
> - * Figure out which fixups post_xol() will need to perform, and annotate
> - * arch_uprobe->fixups accordingly.  To start with,
> - * arch_uprobe->fixups is either zero or it reflects rip-related
> - * fixups.
> + * Figure out which fixups arch_uprobe_post_xol() will need to perform, and
> + * annotate arch_uprobe->fixups accordingly.  To start with,
> + * arch_uprobe->fixups is either zero or it reflects rip-related fixups.
>   */
>  static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
>  {
> @@ -400,12 +406,12 @@ static int validate_insn_bits(struct mm_struct *mm, struct arch_uprobe *auprobe,
>  #endif /* CONFIG_X86_64 */
>  
>  /**
> - * arch_uprobes_analyze_insn - instruction analysis including validity and fixups.
> + * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
>   * @mm: the probed address space.
>   * @arch_uprobe: the probepoint information.
>   * Return 0 on success or a -ve number on error.
>   */
> -int arch_uprobes_analyze_insn(struct mm_struct *mm, struct arch_uprobe *auprobe)
> +int arch_uprobe_analyze_insn(struct mm_struct *mm, struct arch_uprobe *auprobe)

Btw., there's a few more 'uprobes' naming leftovers in the code, 
like UPROBES_COPY_INSN.

>  {
>  	int ret;
>  	struct insn insn;
> @@ -420,3 +426,260 @@ int arch_uprobes_analyze_insn(struct mm_struct *mm, struct arch_uprobe *auprobe)
>  
>  	return 0;
>  }
> +
> +#define	UPROBE_TRAP_NO		UINT_MAX

this would be TRAP_NR too then.

Also, please put such defines at the top of the .c file, so that 
it's easily in view.

> +#ifdef CONFIG_X86_64
> +/*
> + * If we're emulating a rip-relative instruction, save the contents
> + * of the scratch register and store the target address in that register.
> + */
> +static void
> +pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs, struct arch_uprobe_task *tskinfo)
> +{
> +	if (auprobe->fixups & UPROBES_FIX_RIP_AX) {
> +		tskinfo->saved_scratch_register = regs->ax;
> +		regs->ax = current->utask->vaddr;
> +		regs->ax += auprobe->rip_rela_target_address;
> +	} else if (auprobe->fixups & UPROBES_FIX_RIP_CX) {
> +		tskinfo->saved_scratch_register = regs->cx;
> +		regs->cx = current->utask->vaddr;
> +		regs->cx += auprobe->rip_rela_target_address;
> +	}
> +}
> +#else
> +static void
> +pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs, struct arch_uprobe_task *tskinfo)

If the standard variable naming for 'struct arch_uprobe' is 
'auprobe', then the consistent one for 'struct arch_uprobe_task' 
would be something like 'autask', not 'tskinfo'.

'autask' would be a nice companion to the 'utask' name as well.

Please propagate the new naming through all other uses of struct 
arch_uprobe_task as well, and through related local variables 
and structure fields.

> +{
> +	/* No RIP-relative addressing on 32-bit */
> +}
> +#endif
> +
> +/*
> + * arch_uprobe_pre_xol - prepare to execute out of line.
> + * @auprobe: the probepoint information.
> + * @regs: reflects the saved user state of @tsk.
> + */
> +int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct arch_uprobe_task *tskinfo;
> +
> +	tskinfo = &current->utask->tskinfo;
> +	tskinfo->saved_trap_no = current->thread.trap_no;
> +	current->thread.trap_no = UPROBE_TRAP_NO;
> +	regs->ip = current->utask->xol_vaddr;
> +	pre_xol_rip_insn(auprobe, regs, tskinfo);
> +	return 0;

Please put a newline before the return.


> +}
> +
> +/*
> + * Called by arch_uprobe_post_xol() to adjust the return address pushed by a
> + * call instruction executed out of line.
> + */
> +static int adjust_ret_addr(unsigned long sp, long correction)
> +{
> +	int rasize, ncopied;
> +	long ra = 0;
> +
> +	if (is_32bit_app(current))
> +		rasize = 4;
> +	else
> +		rasize = 8;
> +
> +	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
> +	if (unlikely(ncopied))
> +		return -EFAULT;
> +
> +	ra += correction;
> +	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
> +	if (unlikely(ncopied))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_X86_64
> +static bool is_riprel_insn(struct arch_uprobe *auprobe)
> +{
> +	return ((auprobe->fixups & (UPROBES_FIX_RIP_AX | UPROBES_FIX_RIP_CX)) != 0);
> +}
> +
> +static void handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
> +{
> +	if (is_riprel_insn(auprobe)) {
> +		struct arch_uprobe_task *tskinfo;
> +
> +		tskinfo = &current->utask->tskinfo;
> +		if (auprobe->fixups & UPROBES_FIX_RIP_AX)
> +			regs->ax = tskinfo->saved_scratch_register;
> +		else
> +			regs->cx = tskinfo->saved_scratch_register;
> +
> +		/*
> +		 * The original instruction includes a displacement, and so
> +		 * is 4 bytes longer than what we've just single-stepped.
> +		 * Fall through to handle stuff like "jmpq *...(%rip)" and
> +		 * "callq *...(%rip)".
> +		 */
> +		if (correction)
> +			*correction += 4;
> +	}
> +}
> +#else
> +static void handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
> +{
> +	/* No RIP-relative addressing on 32-bit */
> +}
> +#endif
> +
> +/*
> + * If xol insn itself traps and generates a signal(Say,
> + * SIGILL/SIGSEGV/etc), then detect the case where a singlestepped
> + * instruction jumps back to its own address. It is assumed that anything
> + * like do_page_fault/do_trap/etc sets thread.trap_no != -1.
> + *
> + * arch_uprobe_pre_xol/arch_uprobe_post_xol save/restore thread.trap_no,
> + * arch_uprobe_xol_was_trapped() simply checks that ->trap_no is not equal to
> + * UPROBE_TRAP_NO == -1 set by arch_uprobe_pre_xol().
> + */
> +bool arch_uprobe_xol_was_trapped(struct task_struct *tsk)
> +{
> +	if (tsk->thread.trap_no != UPROBE_TRAP_NO)
> +		return true;
> +
> +	return false;
> +}
> +
> +/*
> + * Called after single-stepping. To avoid the SMP problems that can
> + * occur when we temporarily put back the original opcode to
> + * single-step, we single-stepped a copy of the instruction.
> + *
> + * This function prepares to resume execution after the single-step.
> + * We have to fix things up as follows:
> + *
> + * Typically, the new ip is relative to the copied instruction.  We need
> + * to make it relative to the original instruction (FIX_IP).  Exceptions
> + * are return instructions and absolute or indirect jump or call instructions.
> + *
> + * If the single-stepped instruction was a call, the return address that
> + * is atop the stack is the address following the copied instruction.  We
> + * need to make it the address following the original instruction (FIX_CALL).
> + *
> + * If the original instruction was a rip-relative instruction such as
> + * "movl %edx,0xnnnn(%rip)", we have instead executed an equivalent
> + * instruction using a scratch register -- e.g., "movl %edx,(%rax)".
> + * We need to restore the contents of the scratch register and adjust
> + * the ip, keeping in mind that the instruction we executed is 4 bytes
> + * shorter than the original instruction (since we squeezed out the offset
> + * field).  (FIX_RIP_AX or FIX_RIP_CX)
> + */
> +int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask;
> +	long correction;
> +	int result = 0;
> +
> +	WARN_ON_ONCE(current->thread.trap_no != UPROBE_TRAP_NO);
> +
> +	utask = current->utask;
> +	current->thread.trap_no = utask->tskinfo.saved_trap_no;
> +	correction = (long)(utask->vaddr - utask->xol_vaddr);
> +	handle_riprel_post_xol(auprobe, regs, &correction);
> +	if (auprobe->fixups & UPROBES_FIX_IP)
> +		regs->ip += correction;
> +
> +	if (auprobe->fixups & UPROBES_FIX_CALL)
> +		result = adjust_ret_addr(regs->sp, correction);
> +
> +	return result;
> +}
> +
> +/*
> + * Wrapper routine for handling exceptions.

It's not a wrapper, it's a callback function.

> + */
> +int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data)
> +{
> +	struct die_args *args = data;
> +	struct pt_regs *regs = args->regs;
> +	int ret = NOTIFY_DONE;
> +
> +	/* We are only interested in userspace traps */
> +	if (regs && !user_mode_vm(regs))
> +		return NOTIFY_DONE;
> +
> +	switch (val) {
> +	case DIE_INT3:
> +		/* Run your handler here */
> +		if (uprobe_bkpt_notifier(regs))
> +			ret = NOTIFY_STOP;

This comment looks somewhat out of place.

Also, I have not noticed this in the first patch, but 'bkpt' is 
not a standard way to refer to breakpoints: we either use 
'breakpoint' or 'bp'.

> +
> +		break;
> +
> +	case DIE_DEBUG:
> +		if (uprobe_post_notifier(regs))
> +			ret = NOTIFY_STOP;

This wants to be post_bp_notifier, right?

I'd suggest to name them in a symmetric way:

   uprobe_pre_bp_notifier();
   uprobe_post_bp_notifier();

so that the connection and ordering is obvious in the higher 
levels as well.

> +
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * xol insn either trapped or thread has a fatal signal, so reset the
> + * instruction pointer to its probed address.

Verb tense mismatch at the beginning of the sentence. It is also 
very friendly to do round, explanatory sentences like:

  'This function gets called when the XOL instruction either 
   trapped or the thread had a fatal signal, ...'

Please review all other comments for similar patterns as well 
and fix them.

> + */
> +void arch_uprobe_abort_xol(struct pt_regs *regs, struct arch_uprobe *auprobe)
> +{
> +	struct uprobe_task *utask = current->utask;
> +
> +	current->thread.trap_no = utask->tskinfo.saved_trap_no;
> +	handle_riprel_post_xol(auprobe, regs, NULL);
> +	instruction_pointer_set(regs, utask->vaddr);
> +}
> +
> +/*
> + * Skip these instructions:
> + *
> + * 0f 19 90 90 90 90 90		nopl   -0x6f6f6f70(%rax)
> + * 0f 1f 00			nopl (%rax)
> + * 0f 1f 40 00			nopl 0x0(%rax)
> + * 0f 1f 44 00 00		nopl 0x0(%rax,%rax,1)
> + * 0f 1f 80 00 00 00 00		nopl 0x0(%rax)
> + * 0f 1f 84 00 00 00 00		nopl 0x0(%rax,%rax,1)
> + * 66 0f 1f 44 00 00 00		nopw 0x0(%rax,%rax,1)
> + * 66 0f 1f 84 00 00 00		nopw 0x0(%rax,%rax,1)
> + * 66 87 c0			xchg %eax,%eax
> + * 66 90			nop
> + * 87 c0			xchg %eax,%eax
> + * 90 				nop
> + */
> +

unnecessary newline.

> +bool arch_uprobe_skip_sstep(struct pt_regs *regs, struct arch_uprobe *auprobe)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_UINSN_BYTES; i++) {
> +		if ((auprobe->insn[i] == 0x66))
> +			continue;
> +
> +		if (auprobe->insn[i] == 0x90)
> +			return true;
> +
> +		if (i == (MAX_UINSN_BYTES - 1))
> +			break;

Looks like the loop could run from 0 to MAX_UINSN_BYTES-2 and 
then this break would be superfluous.

> +
> +		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x1f))
> +			return true;
> +
> +		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x19))
> +			return true;
> +
> +		if ((auprobe->insn[i] == 0x87) && (auprobe->insn[i+1] == 0xc0))
> +			return true;
> +
> +		break;
> +	}
> +	return false;

Looks like we will skip not just the instructions listed above, 
but a lot more patterns:

  0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }

It might make sense to mention the pattern in the comment and 
mention that it's intended to skip the instructions listed, 
under the currently known x86 ISA.

> +}
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1a63984..f188558 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1605,6 +1605,10 @@ struct task_struct {
>  #ifdef CONFIG_HAVE_HW_BREAKPOINT
>  	atomic_t ptrace_bp_refcnt;
>  #endif
> +#ifdef CONFIG_UPROBES
> +	struct uprobe_task *utask;
> +	int uprobes_srcu_id;
> +#endif
>  };
>  
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index f85797e..73c8711 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -39,6 +39,8 @@ struct vm_area_struct;
>  
>  /* Dont run handlers when first register/ last unregister in progress*/
>  #define UPROBES_RUN_HANDLER	0x2
> +/* Can skip singlestep */
> +#define UPROBES_SKIP_SSTEP	0x4
>  
>  struct uprobe_consumer {
>  	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
> @@ -52,12 +54,40 @@ struct uprobe_consumer {
>  };
>  
>  #ifdef CONFIG_UPROBES
> +enum uprobe_task_state {
> +	UTASK_RUNNING,
> +	UTASK_BP_HIT,
> +	UTASK_SSTEP,
> +	UTASK_SSTEP_ACK,
> +	UTASK_SSTEP_TRAPPED,
> +};
> +
> +/*
> + * uprobe_task: Metadata of a task while it singlesteps.
> + */
> +struct uprobe_task {
> +	unsigned long xol_vaddr;
> +	unsigned long vaddr;

These two fields are never actually used outside of architecture 
code.

Unless there's a good reason to keep them outside I'd suggest to 
move them into struct arch_uprobe_task. This has another 
benefit: we can pass struct arch_uprobe_task to the architecture 
methods, instead of struct uprobe_task. This would allow the 
moving of the struct uprobe_task into uprobes.c - no code 
outside uprobes.c needs to know its structure.

> +
> +	enum uprobe_task_state state;
> +	struct arch_uprobe_task tskinfo;
> +
> +	struct uprobe *active_uprobe;
> +};

Also, please check the style of 'struct uprobe' and make
'struct uprobe_task' match that style.

> +
>  extern int __weak set_bkpt(struct mm_struct *mm, struct arch_uprobe *auprobe, unsigned long vaddr);
>  extern int __weak set_orig_insn(struct mm_struct *mm, struct arch_uprobe *auprobe, unsigned long vaddr, bool verify);
>  extern bool __weak is_bkpt_insn(uprobe_opcode_t *insn);
>  extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *consumer);
>  extern void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *consumer);
>  extern int uprobe_mmap(struct vm_area_struct *vma);
> +extern void uprobe_free_utask(struct task_struct *tsk);
> +extern unsigned long __weak get_uprobe_bkpt_addr(struct pt_regs *regs);
> +extern int uprobe_post_notifier(struct pt_regs *regs);
> +extern int uprobe_bkpt_notifier(struct pt_regs *regs);
> +extern void uprobe_notify_resume(struct pt_regs *regs);
> +extern bool uprobe_deny_signal(void);
> +extern bool __weak arch_uprobe_skip_sstep(struct pt_regs *regs, struct arch_uprobe *auprobe);
>  #else /* CONFIG_UPROBES is not defined */
>  static inline int
>  uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *consumer)
> @@ -72,5 +102,19 @@ static inline int uprobe_mmap(struct vm_area_struct *vma)
>  {
>  	return 0;
>  }
> +static inline void uprobe_notify_resume(struct pt_regs *regs)
> +{
> +}
> +static inline bool uprobe_deny_signal(void)
> +{
> +	return false;
> +}
> +static inline unsigned long get_uprobe_bkpt_addr(struct pt_regs *regs)
> +{
> +	return 0;
> +}

Please use the standard uprobe method naming pattern for 
get_uprobe_bkpt_addr().


> +static inline void uprobe_free_utask(struct task_struct *tsk)
> +{
> +}
>  #endif /* CONFIG_UPROBES */
>  #endif	/* _LINUX_UPROBES_H */
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 5ce32e3..cc955e8 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -30,9 +30,12 @@
>  #include <linux/rmap.h>		/* anon_vma_prepare */
>  #include <linux/mmu_notifier.h>	/* set_pte_at_notify */
>  #include <linux/swap.h>		/* try_to_free_swap */
> +#include <linux/ptrace.h>	/* user_enable_single_step */
> +#include <linux/kdebug.h>	/* notifier mechanism */
>  
>  #include <linux/uprobes.h>
>  
> +static struct srcu_struct uprobes_srcu;
>  static struct rb_root uprobes_tree = RB_ROOT;
>  
>  static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
> @@ -486,6 +489,8 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
>  	u = __insert_uprobe(uprobe);
>  	spin_unlock_irqrestore(&uprobes_treelock, flags);
>  
> +	/* For now assume that the instruction need not be single-stepped */
> +	uprobe->flags |= UPROBES_SKIP_SSTEP;
>  	return u;
>  }
>  
> @@ -523,6 +528,22 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
>  	return uprobe;
>  }
>  
> +static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_consumer *consumer;
> +
> +	if (!(uprobe->flags & UPROBES_RUN_HANDLER))
> +		return;
> +
> +	down_read(&uprobe->consumer_rwsem);
> +	consumer = uprobe->consumers;
> +	for (consumer = uprobe->consumers; consumer; consumer = consumer->next) {
> +		if (!consumer->filter || consumer->filter(consumer, current))
> +			consumer->handler(consumer, regs);
> +	}
> +	up_read(&uprobe->consumer_rwsem);

Suggestion: as a local variable 'consumer' is mentioned many, 
many times throughout the code. It might make sense to 
standardize, for the strict case of local variables (not 
structure fields), on the following pattern:

	struct uprobe_consumer *uc;

	...

	uc = uprobe->consumers;
	for (uc = uprobe->consumers; uc; uc = uc->next) {
		if (!uc->filter || uc->filter(uc, current))
			uc->handler(uc, regs);
	}

See how much more compact and readable it is? This shorter form 
also makes it immediately obvious that the first line before the 
loop is superfulous, it's already done by the loop initializer.

Please propagate this new naming through other places within 
uprobes.c as well.

> +}
> +
>  /* Returns the previous consumer */
>  static struct uprobe_consumer *
>  consumer_add(struct uprobe *uprobe, struct uprobe_consumer *consumer)
> @@ -643,7 +664,7 @@ static int install_breakpoint(struct mm_struct *mm, struct uprobe *uprobe,
>  		if (is_bkpt_insn((uprobe_opcode_t *)uprobe->arch.insn))
>  			return -EEXIST;
>  
> -		ret = arch_uprobes_analyze_insn(mm, &uprobe->arch);
> +		ret = arch_uprobe_analyze_insn(mm, &uprobe->arch);
>  		if (ret)
>  			return ret;
>  
> @@ -659,10 +680,21 @@ static void remove_breakpoint(struct mm_struct *mm, struct uprobe *uprobe, loff_
>  	set_orig_insn(mm, &uprobe->arch, (unsigned long)vaddr, true);
>  }
>  
> +/*
> + * There could be threads that have hit the breakpoint and are entering the
> + * notifier code and trying to acquire the uprobes_treelock. The thread
> + * calling delete_uprobe() that is removing the uprobe from the rb_tree can
> + * race with these threads and might acquire the uprobes_treelock compared
> + * to some of the breakpoint hit threads. In such a case, the breakpoint hit
> + * threads will not find the uprobe. Hence wait till the current breakpoint
> + * hit threads acquire the uprobes_treelock before the uprobe is removed
> + * from the rbtree.

Hm, the last sentence does not parse for me. (even if it's 
correct English it might make sense to rephrase it to be clearer 
what is meant.)

> + */
>  static void delete_uprobe(struct uprobe *uprobe)
>  {
>  	unsigned long flags;
>  
> +	synchronize_srcu(&uprobes_srcu);
>  	spin_lock_irqsave(&uprobes_treelock, flags);
>  	rb_erase(&uprobe->rb_node, &uprobes_tree);
>  	spin_unlock_irqrestore(&uprobes_treelock, flags);
> @@ -1007,6 +1039,248 @@ int uprobe_mmap(struct vm_area_struct *vma)
>  	return ret;
>  }
>  
> +/**
> + * get_uprobe_bkpt_addr - compute address of bkpt given post-bkpt regs
> + * @regs: Reflects the saved state of the task after it has hit a breakpoint
> + * instruction.
> + * Return the address of the breakpoint instruction.
> + */
> +unsigned long __weak get_uprobe_bkpt_addr(struct pt_regs *regs)
> +{
> +	return instruction_pointer(regs) - UPROBES_BKPT_INSN_SIZE;
> +}
> +
> +/*
> + * Called with no locks held.
> + * Called in context of a exiting or a exec-ing thread.
> + */
> +void uprobe_free_utask(struct task_struct *tsk)
> +{
> +	struct uprobe_task *utask = tsk->utask;
> +
> +	if (tsk->uprobes_srcu_id != -1)
> +		srcu_read_unlock_raw(&uprobes_srcu, tsk->uprobes_srcu_id);
> +
> +	if (!utask)
> +		return;
> +
> +	if (utask->active_uprobe)
> +		put_uprobe(utask->active_uprobe);
> +
> +	kfree(utask);
> +	tsk->utask = NULL;
> +}
> +
> +/*
> + * Allocate a uprobe_task object for the task.
> + * Called when the thread hits a breakpoint for the first time.
> + *
> + * Returns:
> + * - pointer to new uprobe_task on success
> + * - NULL otherwise
> + */
> +static struct uprobe_task *add_utask(void)
> +{
> +	struct uprobe_task *utask;
> +
> +	utask = kzalloc(sizeof *utask, GFP_KERNEL);
> +	if (unlikely(utask == NULL))
> +		return NULL;

!task

> +
> +	utask->active_uprobe = NULL;
> +	current->utask = utask;
> +	return utask;

newline.

> +}
> +
> +/* Prepare to single-step probed instruction out of line. */
> +static int pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long vaddr)
> +{
> +	return -EFAULT;
> +}
> +
> +/*
> + * If we are singlestepping, then ensure this thread is not connected to
> + * non-fatal signals until completion of singlestep.  When xol insn itself
> + * triggers the signal,  restart the original insn even if the task is
> + * already SIGKILL'ed (since coredump should report the correct ip).  This
> + * is even more important if the task has a handler for SIGSEGV/etc, The
> + * _same_ instruction should be repeated again after return from the signal
> + * handler, and SSTEP can never finish in this case.
> + */
> +bool uprobe_deny_signal(void)
> +{
> +	struct task_struct *tsk = current;
> +	struct uprobe_task *utask = tsk->utask;
> +
> +	if (likely(!utask || !utask->active_uprobe))
> +		return false;
> +
> +	WARN_ON_ONCE(utask->state != UTASK_SSTEP);
> +
> +	if (signal_pending(tsk)) {
> +		spin_lock_irq(&tsk->sighand->siglock);
> +		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
> +		spin_unlock_irq(&tsk->sighand->siglock);
> +
> +		if (__fatal_signal_pending(tsk) || arch_uprobe_xol_was_trapped(tsk)) {
> +			utask->state = UTASK_SSTEP_TRAPPED;
> +			set_tsk_thread_flag(tsk, TIF_UPROBE);
> +			set_tsk_thread_flag(tsk, TIF_NOTIFY_RESUME);
> +		}
> +	}
> +
> +	return true;
> +}

Hm, seems racy to me: what happens if we get a signal shortly 
*after* this code got called and before we take the siglock? It 
might be safe, but it's not clearly obvious why and the code 
does not explain it.

Why is this logic not within the 'relock' loop within 
get_signal_to_deliver(), called with the siglock already taken? 
That would avoid races and would also remove the siglock 
taking/dropping above.

> +
> +static bool uprobe_skip_sstep(struct pt_regs *regs, struct uprobe *u)
> +{
> +	if (arch_uprobe_skip_sstep(regs, &u->arch))
> +		return true;
> +
> +	u->flags &= ~UPROBES_SKIP_SSTEP;
> +	return false;
> +}
> +
> +/*
> + * On breakpoint hit, breakpoint notifier sets the TIF_UPROBE flag.  (and on
> + * subsequent probe hits on the thread sets the state to UTASK_BP_HIT) and
> + * allows the thread to return from interrupt.  While returning to
> + * userspace, thread noticies the TIF_UPROBE flag and calls

typo.

> + * uprobe_notify_resume(). uprobe_notify_resume will run the handler and ask
> + * the thread to singlestep.
> + *
> + * On subsequent singlestep exception, singlestep notifier sets the
> + * TIF_UPROBE flag and also sets the state to UTASK_SSTEP_ACK and allows the
> + * thread to return from interrupt. While returning to userspace, thread
> + * notices the TIF_UPROBE and calls uprobe_notify_resume().
> + * uprobe_notify_resume disables singlestep and performs the required
> + * fix-ups.
> + *
> + * All non-fatal signals cannot interrupt thread while the thread singlesteps.
> + */
> +void uprobe_notify_resume(struct pt_regs *regs)
> +{
> +	struct vm_area_struct *vma;
> +	struct uprobe_task *utask;
> +	struct mm_struct *mm;
> +	struct uprobe *u;

'u' is not what we use for a uprobe in other places - please use 
consistent naming all across the code!

> +	unsigned long probept;

this wants to be the breakpoint virtual address, right?

If yes then 'bp_vaddr' would be a *much* clearer name for it.

> +
> +	utask = current->utask;
> +	u = NULL;
> +	mm = current->mm;
> +	if (!utask || utask->state == UTASK_BP_HIT) {

Please put these two starkly different pieces of functionality 
on the two sides of the branch into two helper inline functions, 
named apporpriately.

> +		probept = get_uprobe_bkpt_addr(regs);
> +		down_read(&mm->mmap_sem);
> +		vma = find_vma(mm, probept);
> +
> +		if (vma && vma->vm_start <= probept && valid_vma(vma, false))
> +			u = find_uprobe(vma->vm_file->f_mapping->host, probept - vma->vm_start +
> +					(vma->vm_pgoff << PAGE_SHIFT));

I'd stick the offset into a loff_t local variable first, plus 
use an inode variable as well, then it would all be so much 
easier to read:

			inode = vma->vm_file->f_mapping->host;
			offset = vma->vm_pgoff << PAGE_SHIFT;
			offset += bp_vaddr - vma->vm_start;

			uprobe = find_uprobe(inode, offset);

> +
> +		srcu_read_unlock_raw(&uprobes_srcu, current->uprobes_srcu_id);
> +		current->uprobes_srcu_id = -1;
> +		up_read(&mm->mmap_sem);
> +
> +		if (!u)
> +			/* No matching uprobe; signal SIGTRAP. */
> +			goto cleanup_ret;
> +
> +		if (!utask) {
> +			utask = add_utask();
> +			/* Cannot Allocate; re-execute the instruction. */
> +			if (!utask)
> +				goto cleanup_ret;

Weird capitalization.

> +		}
> +		utask->active_uprobe = u;
> +		handler_chain(u, regs);
> +		if (u->flags & UPROBES_SKIP_SSTEP && uprobe_skip_sstep(regs, u))
> +			goto cleanup_ret;
> +
> +		utask->state = UTASK_SSTEP;
> +		if (!pre_ssout(u, regs, probept))
> +			user_enable_single_step(current);
> +		else
> +			/* Cannot Singlestep; re-execute the instruction. */
> +			goto cleanup_ret;

Weird capitalization.

> +
> +	} else {
> +		u = utask->active_uprobe;
> +		if (utask->state == UTASK_SSTEP_ACK)
> +			arch_uprobe_post_xol(&u->arch, regs);
> +		else if (utask->state == UTASK_SSTEP_TRAPPED)
> +			arch_uprobe_abort_xol(regs, &u->arch);
> +		else
> +			WARN_ON_ONCE(1);
> +
> +		put_uprobe(u);
> +		utask->active_uprobe = NULL;
> +		utask->state = UTASK_RUNNING;
> +		user_disable_single_step(current);
> +
> +		spin_lock_irq(&current->sighand->siglock);
> +		recalc_sigpending(); /* see uprobe_deny_signal() */
> +		spin_unlock_irq(&current->sighand->siglock);
> +	}
> +	return;
> +
> +cleanup_ret:
> +	if (utask) {
> +		utask->active_uprobe = NULL;
> +		utask->state = UTASK_RUNNING;
> +	}
> +	if (u) {
> +		if (!(u->flags & UPROBES_SKIP_SSTEP))
> +			instruction_pointer_set(regs, probept);
> +
> +		put_uprobe(u);
> +	} else {
> +		send_sig(SIGTRAP, current, 0);
> +	}

Please use a standard cleanup sequence.

The code flow is extremely mixed throughout 
uprobe_notify_resume(), please clean it all up and make it much 
more obvious.

> +}
> +
> +/*
> + * uprobe_bkpt_notifier gets called from interrupt context as part of
> + * notifier mechanism. Set TIF_UPROBE flag and indicate breakpoint hit.
> + */
> +int uprobe_bkpt_notifier(struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask;
> +
> +	if (!current->mm)
> +		return 0;
> +
> +	utask = current->utask;
> +	if (utask)
> +		utask->state = UTASK_BP_HIT;
> +
> +	set_thread_flag(TIF_UPROBE);
> +	current->uprobes_srcu_id = srcu_read_lock_raw(&uprobes_srcu);
> +	return 1;
> +}
> +
> +/*
> + * uprobe_post_notifier gets called in interrupt context as part of notifier
> + * mechanism. Set TIF_UPROBE flag and indicate completion of singlestep.
> + */
> +int uprobe_post_notifier(struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask = current->utask;
> +
> +	if (!current->mm || !utask || !utask->active_uprobe)
> +		/* task is currently not uprobed */
> +		return 0;
> +
> +	utask->state = UTASK_SSTEP_ACK;
> +	set_thread_flag(TIF_UPROBE);
> +	return 1;
> +}
> +
> +struct notifier_block uprobe_exception_nb = {
> +	.notifier_call = arch_uprobe_exception_notify,
> +	.priority = INT_MAX - 1,	/* notified after kprobes, kgdb */

This too should align vertically.

> +};
> +
>  static int __init init_uprobes(void)
>  {
>  	int i;
> @@ -1015,7 +1289,8 @@ static int __init init_uprobes(void)
>  		mutex_init(&uprobes_mutex[i]);
>  		mutex_init(&uprobes_mmap_mutex[i]);
>  	}
> -	return 0;
> +	init_srcu_struct(&uprobes_srcu);
> +	return register_die_notifier(&uprobe_exception_nb);
>  }
>  
>  static void __exit exit_uprobes(void)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b77fd55..df711bb 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -66,6 +66,7 @@
>  #include <linux/user-return-notifier.h>
>  #include <linux/oom.h>
>  #include <linux/khugepaged.h>
> +#include <linux/uprobes.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -700,6 +701,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>  		exit_pi_state_list(tsk);
>  #endif
>  
> +	uprobe_free_utask(tsk);
> +
>  	/* Get rid of any cached register state */
>  	deactivate_mm(tsk, mm);
>  
> @@ -1292,6 +1295,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	INIT_LIST_HEAD(&p->pi_state_list);
>  	p->pi_state_cache = NULL;
>  #endif
> +#ifdef CONFIG_UPROBES
> +	p->utask = NULL;
> +	p->uprobes_srcu_id = -1;
> +#endif

Should be a uprobe_copy_process() callback.

>  	/*
>  	 * sigaltstack should be cleared when sharing the same VM
>  	 */
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 8511e39..24a9c39 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -29,6 +29,7 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/nsproxy.h>
>  #include <linux/user_namespace.h>
> +#include <linux/uprobes.h>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/signal.h>
>  
> @@ -2192,6 +2193,9 @@ int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
>  	struct signal_struct *signal = current->signal;
>  	int signr;
>  
> +	if (unlikely(uprobe_deny_signal()))
> +		return 0;
> +
>  relock:
>  	/*
>  	 * We'll jump back here after any time we were stopped in TASK_STOPPED.
> @@ -3004,7 +3008,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
>  	return 0;
>  }
>  
> -int 
> +int
>  do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
>  {
>  	stack_t oss;

So ... this patch needs to split up into the preparatory patches 
+ main patch and it all needs to be reworked.

Thanks,

	Ingo
