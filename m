Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2B1N1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:27:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57673 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2B1N1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:27:15 -0500
Date: Tue, 28 Feb 2012 18:56:01 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20120228132601.GC32211@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
 <20120227091212.GA7092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120227091212.GA7092@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022813-3270-0000-0000-000004637341
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Where possible, we check and skip singlestepping the 
> > breakpointed instructions. For now we skip single byte as well 
> > as few multibyte nop instructions. However this can be 
> > extended to other instructions too.
> 
> Is this an optimization - allowing a NOP to be inserted for easy 
> probe insertion?
> 

Yes, Its an optimization by which we avoid singlestep exception.

> >  
> >  #define MAX_UINSN_BYTES			  16
> > @@ -39,5 +41,17 @@ struct arch_uprobe {
> >  #endif
> >  };
> >  
> > -extern int arch_uprobes_analyze_insn(struct mm_struct *mm, struct arch_uprobe *arch_uprobe);
> > +struct arch_uprobe_task {
> > +	unsigned long saved_trap_no;
> 
> trap_no in struct thread_struct and now in arch_uprobe_task is a 
> misnomer - I always expect a trap_yes flag next to it ;-)
> 
> Please create a separate patch in front of this patch that 
> trivially renames trap_no to something saner like trap_nr, and 
> introduce this field as trap_nr as well.

Okay, Will do.

> 
> > +#ifdef CONFIG_X86_64
> > +	unsigned long saved_scratch_register;
> > +#endif
> > +};
> > +
> > +extern int arch_uprobe_analyze_insn(struct mm_struct *mm, struct arch_uprobe *arch_uprobe);
> > +extern int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs);
> > +extern int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs);
> > +extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
> > +extern int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
> > +extern void arch_uprobe_abort_xol(struct pt_regs *regs, struct arch_uprobe *auprobe);
> 
> Small API parameter consistency nit:
> 
> We tend to order function parameters by importance: the more 
> important parameter comes first.
> 
> In that sense arch_uprobe_pre_xol() and arch_uprobe_abort_xol() 
> have obviously inconsistent ordering: the first one is
> (aup, regs), the second one is (regs, aup).
> 
> Please make it consistent, at first glance the right one appears 
> to be:
> 
>  aup, mm
>  aup, regs
>  aup, regs
>  t
>  self, val, data
>  aup, regs
> 
> I'd put the arch_uprobe_analyze_insn() order change into a 
> separate patch, preceding this patch.

Okay, Will do.

> 
> >  #include <linux/kdebug.h>
> >  #include <asm/insn.h>
> >  
> > +#ifdef CONFIG_X86_32
> > +#define is_32bit_app(tsk) 1
> > +#else
> > +#define is_32bit_app(tsk) (test_tsk_thread_flag(tsk, TIF_IA32))
> > +#endif
> 
> Small detail, we prefer to use this variant:
> 
> #ifdef X
> # define foo()
> #else
> # define bar()
> #endif
> 
> to give the construct more visual structure.
> 
> Also, please put it into asm/compat.h and use it at other places 
> within arch/x86/ as well, there's half a dozen similar patterns 
> of TIP_IA32 tests in arch/x86/. Please make this a separate 
> patch, preceding this patch.

Okay.

> 
> Also, how does this interact with the new x32 ABI code in -tip?
> 

I havent taken a look at X86_X32_ABI. I will comeback to you on this.

> >   */
> > -int arch_uprobes_analyze_insn(struct mm_struct *mm, struct arch_uprobe *auprobe)
> > +int arch_uprobe_analyze_insn(struct mm_struct *mm, struct arch_uprobe *auprobe)
> 
> Btw., there's a few more 'uprobes' naming leftovers in the code, 
> like UPROBES_COPY_INSN.
> 

Okay, 

> >  {
> >  	int ret;
> >  	struct insn insn;
> > @@ -420,3 +426,260 @@ int arch_uprobes_analyze_insn(struct mm_struct *mm, struct arch_uprobe *auprobe)
> >  
> >  	return 0;
> >  }
> > +
> > +#define	UPROBE_TRAP_NO		UINT_MAX
> 
> this would be TRAP_NR too then.
> 
> Also, please put such defines at the top of the .c file, so that 
> it's easily in view.
> 

Okay, 

> > +#else
> > +static void
> > +pre_xol_rip_insn(struct arch_uprobe *auprobe, struct pt_regs *regs, struct arch_uprobe_task *tskinfo)
> 
> If the standard variable naming for 'struct arch_uprobe' is 
> 'auprobe', then the consistent one for 'struct arch_uprobe_task' 
> would be something like 'autask', not 'tskinfo'.
> 
> 'autask' would be a nice companion to the 'utask' name as well.
> 
> Please propagate the new naming through all other uses of struct 
> arch_uprobe_task as well, and through related local variables 
> and structure fields.
> 

Okay. 

> > +	switch (val) {
> > +	case DIE_INT3:
> > +		/* Run your handler here */
> > +		if (uprobe_bkpt_notifier(regs))
> > +			ret = NOTIFY_STOP;
> 
> This comment looks somewhat out of place.
> 
> Also, I have not noticed this in the first patch, but 'bkpt' is 
> not a standard way to refer to breakpoints: we either use 
> 'breakpoint' or 'bp'.
> 

This is again one of those things that I changed from bp to bkpt based
on LKML feedback. I am okay to go back to bp.

> > +
> > +		break;
> > +
> > +	case DIE_DEBUG:
> > +		if (uprobe_post_notifier(regs))
> > +			ret = NOTIFY_STOP;
> 
> This wants to be post_bp_notifier, right?
> 
> I'd suggest to name them in a symmetric way:
> 
>    uprobe_pre_bp_notifier();
>    uprobe_post_bp_notifier();
> 
> so that the connection and ordering is obvious in the higher 
> levels as well.

Okay. 

> 
> > +
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * xol insn either trapped or thread has a fatal signal, so reset the
> > + * instruction pointer to its probed address.
> 
> Verb tense mismatch at the beginning of the sentence. It is also 
> very friendly to do round, explanatory sentences like:
> 
>   'This function gets called when the XOL instruction either 
>    trapped or the thread had a fatal signal, ...'
> 
> Please review all other comments for similar patterns as well 
> and fix them.
> 

Okay. 

> > +bool arch_uprobe_skip_sstep(struct pt_regs *regs, struct arch_uprobe *auprobe)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < MAX_UINSN_BYTES; i++) {
> > +		if ((auprobe->insn[i] == 0x66))
> > +			continue;
> > +
> > +		if (auprobe->insn[i] == 0x90)
> > +			return true;
> > +
> > +		if (i == (MAX_UINSN_BYTES - 1))
> > +			break;
> 
> Looks like the loop could run from 0 to MAX_UINSN_BYTES-2 and 
> then this break would be superfluous.
> 

Even if we were to run from 0 to MAX_UINSN_BYTES - 2, we would have to
add extra code to handle 0x66* 0x90 (where 0x90 is stored at index i ==
MAX_UINSN_BYTES - 1. So I would like to keep this code as is.

> > +
> > +		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x1f))
> > +			return true;
> > +
> > +		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x19))
> > +			return true;
> > +
> > +		if ((auprobe->insn[i] == 0x87) && (auprobe->insn[i+1] == 0xc0))
> > +			return true;
> > +
> > +		break;
> > +	}
> > +	return false;
> 
> Looks like we will skip not just the instructions listed above, 
> but a lot more patterns:
> 
>   0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }
> 
> It might make sense to mention the pattern in the comment and 
> mention that it's intended to skip the instructions listed, 
> under the currently known x86 ISA.

Okay, Will do.

> 
> > +
> > +/*
> > + * uprobe_task: Metadata of a task while it singlesteps.
> > + */
> > +struct uprobe_task {
> > +	unsigned long xol_vaddr;
> > +	unsigned long vaddr;
> 
> These two fields are never actually used outside of architecture 
> code.
> 
> Unless there's a good reason to keep them outside I'd suggest to 
> move them into struct arch_uprobe_task. This has another 
> benefit: we can pass struct arch_uprobe_task to the architecture 
> methods, instead of struct uprobe_task. This would allow the 
> moving of the struct uprobe_task into uprobes.c - no code 
> outside uprobes.c needs to know its structure.
> 

The Xol layer(which is the next patch) uses them in arch agnostic way.
Also vaddr/xol_vaddr are populated/used in arch agnostic way.
We could still move them to arch_uprobe_task but we will then have to
ensure that every other arch defines them the way uprobes understands.

> > +
> > +	enum uprobe_task_state state;
> > +	struct arch_uprobe_task tskinfo;
> > +
> > +	struct uprobe *active_uprobe;
> > +};
> 
> Also, please check the style of 'struct uprobe' and make
> 'struct uprobe_task' match that style.
> 

Okay. 

> > +}
> > +static inline unsigned long get_uprobe_bkpt_addr(struct pt_regs *regs)
> > +{
> > +	return 0;
> > +}
> 
> Please use the standard uprobe method naming pattern for 
> get_uprobe_bkpt_addr().
> 

do you mean uprobe_get_bp_addr ?

> 
> >  
> > +static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
> > +{
> > +	struct uprobe_consumer *consumer;
> > +
> > +	if (!(uprobe->flags & UPROBES_RUN_HANDLER))
> > +		return;
> > +
> > +	down_read(&uprobe->consumer_rwsem);
> > +	consumer = uprobe->consumers;
> > +	for (consumer = uprobe->consumers; consumer; consumer = consumer->next) {
> > +		if (!consumer->filter || consumer->filter(consumer, current))
> > +			consumer->handler(consumer, regs);
> > +	}
> > +	up_read(&uprobe->consumer_rwsem);
> 
> Suggestion: as a local variable 'consumer' is mentioned many, 
> many times throughout the code. It might make sense to 
> standardize, for the strict case of local variables (not 
> structure fields), on the following pattern:
> 
> 	struct uprobe_consumer *uc;
> 
> 	...
> 
> 	uc = uprobe->consumers;
> 	for (uc = uprobe->consumers; uc; uc = uc->next) {
> 		if (!uc->filter || uc->filter(uc, current))
> 			uc->handler(uc, regs);
> 	}
> 
> See how much more compact and readable it is? This shorter form 
> also makes it immediately obvious that the first line before the 
> loop is superfulous, it's already done by the loop initializer.
> 
> Please propagate this new naming through other places within 
> uprobes.c as well.
> 

Okay. 

> > +}
> > +
> >  
> > +/*
> > + * There could be threads that have hit the breakpoint and are entering the
> > + * notifier code and trying to acquire the uprobes_treelock. The thread
> > + * calling delete_uprobe() that is removing the uprobe from the rb_tree can
> > + * race with these threads and might acquire the uprobes_treelock compared
> > + * to some of the breakpoint hit threads. In such a case, the breakpoint hit
> > + * threads will not find the uprobe. Hence wait till the current breakpoint
> > + * hit threads acquire the uprobes_treelock before the uprobe is removed
> > + * from the rbtree.
> 
> Hm, the last sentence does not parse for me. (even if it's 
> correct English it might make sense to rephrase it to be clearer 
> what is meant.)
> 

Would this be okay with you.

The current unregistering thread waits till all other threads that have hit
a breakpoint to acquire the uprobes_treelock before the uprobe is removed
from the rbtree.


> > +/*
> > + * If we are singlestepping, then ensure this thread is not connected to
> > + * non-fatal signals until completion of singlestep.  When xol insn itself
> > + * triggers the signal,  restart the original insn even if the task is
> > + * already SIGKILL'ed (since coredump should report the correct ip).  This
> > + * is even more important if the task has a handler for SIGSEGV/etc, The
> > + * _same_ instruction should be repeated again after return from the signal
> > + * handler, and SSTEP can never finish in this case.
> > + */
> > +bool uprobe_deny_signal(void)
> > +{
> > +	struct task_struct *tsk = current;
> > +	struct uprobe_task *utask = tsk->utask;
> > +
> > +	if (likely(!utask || !utask->active_uprobe))
> > +		return false;
> > +
> > +	WARN_ON_ONCE(utask->state != UTASK_SSTEP);
> > +
> > +	if (signal_pending(tsk)) {
> > +		spin_lock_irq(&tsk->sighand->siglock);
> > +		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
> > +		spin_unlock_irq(&tsk->sighand->siglock);
> > +
> > +		if (__fatal_signal_pending(tsk) || arch_uprobe_xol_was_trapped(tsk)) {
> > +			utask->state = UTASK_SSTEP_TRAPPED;
> > +			set_tsk_thread_flag(tsk, TIF_UPROBE);
> > +			set_tsk_thread_flag(tsk, TIF_NOTIFY_RESUME);
> > +		}
> > +	}
> > +
> > +	return true;
> > +}
> 

> Hm, seems racy to me: what happens if we get a signal shortly 
> *after* this code got called and before we take the siglock? It 
> might be safe, but it's not clearly obvious why and the code 
> does not explain it.
> 
> Why is this logic not within the 'relock' loop within 
> get_signal_to_deliver(), called with the siglock already taken? 
> That would avoid races and would also remove the siglock 
> taking/dropping above.
> 

At the time the thread is at get_signal_to_deliver, the thread has
either hit a uprobe and still not singlestepped or it isnt handling any
uprobes. If the thread has hit a uprobe but not yet singlestepped, we
want the thread to not handle signals, Hence it returns from the signal
handling function.  If a new signal were to be delivered, after we
return from get_signal_to_deliver, then we repeat the same, i.e return
after checking that uprobes is active. 

If the thread was not in the middle of a uprobe hit then we go through the
regular signal handling. 

Since there is no way this thread can hit a uprobe once a thread has entered
get_signal_to_deliver(kernel code), I dont see a reason to move it under relock:

> > + * All non-fatal signals cannot interrupt thread while the thread singlesteps.
> > + */
> > +void uprobe_notify_resume(struct pt_regs *regs)
> > +{
> > +	struct vm_area_struct *vma;
> > +	struct uprobe_task *utask;
> > +	struct mm_struct *mm;
> > +	struct uprobe *u;
> 
> 'u' is not what we use for a uprobe in other places - please use 
> consistent naming all across the code!
> 
> > +	unsigned long probept;
> 
> this wants to be the breakpoint virtual address, right?
> 
> If yes then 'bp_vaddr' would be a *much* clearer name for it.
> 
> > +
> > +	utask = current->utask;
> > +	u = NULL;
> > +	mm = current->mm;
> > +	if (!utask || utask->state == UTASK_BP_HIT) {
> 
> Please put these two starkly different pieces of functionality 
> on the two sides of the branch into two helper inline functions, 
> named apporpriately.
> 
> > +		probept = get_uprobe_bkpt_addr(regs);
> > +		down_read(&mm->mmap_sem);
> > +		vma = find_vma(mm, probept);
> > +
> > +		if (vma && vma->vm_start <= probept && valid_vma(vma, false))
> > +			u = find_uprobe(vma->vm_file->f_mapping->host, probept - vma->vm_start +
> > +					(vma->vm_pgoff << PAGE_SHIFT));
> 
> I'd stick the offset into a loff_t local variable first, plus 
> use an inode variable as well, then it would all be so much 
> easier to read:
> 
> 			inode = vma->vm_file->f_mapping->host;
> 			offset = vma->vm_pgoff << PAGE_SHIFT;
> 			offset += bp_vaddr - vma->vm_start;
> 
> 			uprobe = find_uprobe(inode, offset);
> 

Okay, 

> > +
> > +		srcu_read_unlock_raw(&uprobes_srcu, current->uprobes_srcu_id);
> > +		current->uprobes_srcu_id = -1;
> > +		up_read(&mm->mmap_sem);
> > +
> > +		if (!u)
> > +			/* No matching uprobe; signal SIGTRAP. */
> > +			goto cleanup_ret;
> > +
> > +		if (!utask) {
> > +			utask = add_utask();
> > +			/* Cannot Allocate; re-execute the instruction. */
> > +			if (!utask)
> > +				goto cleanup_ret;
> 
> Weird capitalization.
> 
> > +		}
> > +		utask->active_uprobe = u;
> > +		handler_chain(u, regs);
> > +		if (u->flags & UPROBES_SKIP_SSTEP && uprobe_skip_sstep(regs, u))
> > +			goto cleanup_ret;
> > +
> > +		utask->state = UTASK_SSTEP;
> > +		if (!pre_ssout(u, regs, probept))
> > +			user_enable_single_step(current);
> > +		else
> > +			/* Cannot Singlestep; re-execute the instruction. */
> > +			goto cleanup_ret;
> 
> Weird capitalization.
> 
> > +
> > +	} else {
> > +		u = utask->active_uprobe;
> > +		if (utask->state == UTASK_SSTEP_ACK)
> > +			arch_uprobe_post_xol(&u->arch, regs);
> > +		else if (utask->state == UTASK_SSTEP_TRAPPED)
> > +			arch_uprobe_abort_xol(regs, &u->arch);
> > +		else
> > +			WARN_ON_ONCE(1);
> > +
> > +		put_uprobe(u);
> > +		utask->active_uprobe = NULL;
> > +		utask->state = UTASK_RUNNING;
> > +		user_disable_single_step(current);
> > +
> > +		spin_lock_irq(&current->sighand->siglock);
> > +		recalc_sigpending(); /* see uprobe_deny_signal() */
> > +		spin_unlock_irq(&current->sighand->siglock);
> > +	}
> > +	return;
> > +
> > +cleanup_ret:
> > +	if (utask) {
> > +		utask->active_uprobe = NULL;
> > +		utask->state = UTASK_RUNNING;
> > +	}
> > +	if (u) {
> > +		if (!(u->flags & UPROBES_SKIP_SSTEP))
> > +			instruction_pointer_set(regs, probept);
> > +
> > +		put_uprobe(u);
> > +	} else {
> > +		send_sig(SIGTRAP, current, 0);
> > +	}
> 
> Please use a standard cleanup sequence.
> 
> The code flow is extremely mixed throughout 
> uprobe_notify_resume(), please clean it all up and make it much 
> more obvious.

Okay. 

> 
> > +}
> > +
> > +/*
> > + * uprobe_bkpt_notifier gets called from interrupt context as part of
> > + * notifier mechanism. Set TIF_UPROBE flag and indicate breakpoint hit.
> > + */
> > +int uprobe_bkpt_notifier(struct pt_regs *regs)
> > +{
> > +	struct uprobe_task *utask;
> > +
> > +	if (!current->mm)
> > +		return 0;
> > +
> > +	utask = current->utask;
> > +	if (utask)
> > +		utask->state = UTASK_BP_HIT;
> > +
> > +	set_thread_flag(TIF_UPROBE);
> > +	current->uprobes_srcu_id = srcu_read_lock_raw(&uprobes_srcu);
> > +	return 1;
> > +}
> > +
> > +/*
> > + * uprobe_post_notifier gets called in interrupt context as part of notifier
> > + * mechanism. Set TIF_UPROBE flag and indicate completion of singlestep.
> > + */
> > +int uprobe_post_notifier(struct pt_regs *regs)
> > +{
> > +	struct uprobe_task *utask = current->utask;
> > +
> > +	if (!current->mm || !utask || !utask->active_uprobe)
> > +		/* task is currently not uprobed */
> > +		return 0;
> > +
> > +	utask->state = UTASK_SSTEP_ACK;
> > +	set_thread_flag(TIF_UPROBE);
> > +	return 1;
> > +}
> > +
> > +struct notifier_block uprobe_exception_nb = {
> > +	.notifier_call = arch_uprobe_exception_notify,
> > +	.priority = INT_MAX - 1,	/* notified after kprobes, kgdb */
> 
> This too should align vertically.
> 

Okay, 

> > @@ -1292,6 +1295,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >  	INIT_LIST_HEAD(&p->pi_state_list);
> >  	p->pi_state_cache = NULL;
> >  #endif
> > +#ifdef CONFIG_UPROBES
> > +	p->utask = NULL;
> > +	p->uprobes_srcu_id = -1;
> > +#endif
> 
> Should be a uprobe_copy_process() callback.
> 

Okay. 

> 
> So ... this patch needs to split up into the preparatory patches 
> + main patch and it all needs to be reworked.
 

Okay.

-- 
Thanks and Regards
Srikar

