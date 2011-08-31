Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1HaPqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:46:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab1HaPqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:46:44 -0400
Date: Wed, 31 Aug 2011 18:45:58 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110831154558.GA12259@redhat.com>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>
 <x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
 <4E5D5817.6040704@kernel.dk>
 <CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
 <4E5D64E8.7000102@kernel.dk>
 <20110830154157.d802d097.akpm@linux-foundation.org>
 <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
 <20110830155438.bc31ab99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830155438.bc31ab99.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 03:54:38PM -0700, Andrew Morton wrote:
> On Tue, 30 Aug 2011 15:45:35 -0700
> Daniel Ehrenberg <dehrenberg@google.com> wrote:
> 
> > >> Not quite sure, and after working on them and fixing thing up, I don't
> > >> even think they are that complex or intrusive (which I think otherwise
> > >> would've been the main objection). Andrew may know/remember.
> > >
> > > Boy, that was a long time ago. __I was always unhappy with the patches
> > > because of the amount of additional code/complexity they added.
> > >
> > > Then the great syslets/threadlets design session happened and it was
> > > expected that such a facility would make special async handling for AIO
> > > unnecessary. __Then syslets/threadlets didn't happen.
> > 
> > Do you think we could accomplish the goals with less additional
> > code/complexity? It looks like the latest version of the patch set
> > wasn't so invasive.
> > 
> > If syslets/threadlets aren't happening, should these patches be
> > reconsidered for inclusion in the kernel?
> 
> I haven't seen any demand at all for the feature in many years.  That
> doesn't mean that there _isn't_ any demand - perhaps everyone got
> exhausted.
> 
> If there is demand then that should be described and circulated, see
> how much interest there is in resurrecting the effort.
> 
KVM also have similar needs. KVM has x86 emulator in kernel which is,
in fact, a state machines that sometimes need an input from userspace
to proceed.  Currently, when userspace input is needed, KVM goes back
to userspace to retrieve the input and than retries the emulation. Some
instructions may require several such iterations. This is somewhat similar
to aio except that in KVM case emulation waits for userspace instead of
disk/network HW. The resulting code is complex and error prone. It would
be nice to not have to unwind the stack from the middle of the emulator
just to be able to exit to userspace to retrieve the value. One idea that
came up was to execute emulator on separate kernel stack (withing same
task). When emulator needs a value from userspace it sleeps while main
stack goes to userspace to get the value. When the value is available
main stack wakes up emulator stack and emulation continues from the
place it was stopped. Cooperative multithreading inside the kernel
if you want. Bellow is the patch I prototyped to implement that on
x86_64. I made KVM x86 emulator to use it too. I think AIO can use the
same technique. io_submit will execute IO on alternative stack. If it
blocks main thread will continue to run. When IO is completed IO stack
will resume (alternative stack has priority over main stack).


diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0d1171c..4d85ec8 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -472,6 +472,14 @@ struct thread_struct {
 	unsigned		io_bitmap_max;
 };
 
+struct arch_stack_struct {
+	unsigned long sp;
+};
+
+struct stack_struct;
+
+extern void arch_alt_stack_setup(struct stack_struct *stack);
+
 static inline unsigned long native_get_debugreg(int regno)
 {
 	unsigned long val = 0;	/* Damn you, gcc! */
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index c2ff2a1..ade6756 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -18,12 +18,15 @@
 #endif
 
 struct task_struct; /* one of the stranger aspects of C forward declarations */
+struct stack_struct;
 struct task_struct *__switch_to(struct task_struct *prev,
 				struct task_struct *next);
 struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
 extern void show_regs_common(void);
+extern struct stack_struct* switch_alt_stack(struct stack_struct *,
+				   	     struct stack_struct *);
 
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index f693e44..2d17e0d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -658,3 +658,52 @@ unsigned long KSTK_ESP(struct task_struct *task)
 	return (test_tsk_thread_flag(task, TIF_IA32)) ?
 			(task_pt_regs(task)->sp) : ((task)->thread.usersp);
 }
+
+struct stack_struct* switch_alt_stack(struct stack_struct *prev,
+		struct stack_struct *next)
+{
+	struct stack_struct* last;
+
+	next->ti->flags = prev->ti->flags;
+	next->ti->status = prev->ti->status;
+	next->ti->cpu = prev->ti->cpu;
+	next->ti->preempt_count =  prev->ti->preempt_count;
+
+	prev->state = current->state;
+	current->thread.sp = next->arch.sp;
+	current->stack = next->ti;
+	current->state = next->state;
+	current->current_stack = next;
+	percpu_write(kernel_stack,
+			(unsigned long)task_stack_page(current) +
+			THREAD_SIZE - KERNEL_STACK_OFFSET);
+
+	/* ->flags can be updated by other CPUs during the switch */
+	atomic_set_mask(prev->ti->flags, &next->ti->flags);
+
+	/* switch stack */
+	asm volatile("pushq %%rbp\n\t"
+		     "movq %%rsp, %P[sp](%[prev])\n\t"
+		     "movq %P[sp](%[next]),%%rsp\n\t"
+		     "cmpl %[stack_start], %P[stack_state](%[next])\n\t"
+		     "jne 1f\n\t"
+		     "jmp start_alt_stack\n\t"
+		     "1:\n\t"
+		     "popq %%rbp\n\t"
+		     "movq %[prev], %[last]\n\t"
+		     : [last] "=a" (last)
+		     : [prev] "S" (prev), [next] "D" (next),
+		     [sp] "i" (offsetof(struct stack_struct, arch.sp)),
+		     [stack_start] "i" (STACK_START),
+		     [stack_state] "i" (offsetof(struct stack_struct, stack_state)) :
+		     "memory", "cc", "rbx", "rcx", "rdx",
+		     "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15");
+
+	return last;
+}
+
+void arch_alt_stack_setup(struct stack_struct *stack)
+{
+	stack->arch.sp = ((unsigned long)stack->ti + THREAD_SIZE);
+}
+
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d14e058..fe6964b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -164,6 +164,10 @@ extern struct cred init_cred;
 	RCU_INIT_POINTER(.cred, &init_cred),				\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
+	.main_stack.ti	= &init_thread_info,				\
+	.main_stack.stack_state = STACK_LIVE,				\
+	.current_stack	= &tsk.main_stack,				\
+	.stacks		= LIST_HEAD_INIT(tsk.stacks),			\
 	.fs		= &init_fs,					\
 	.files		= &init_files,					\
 	.signal		= &init_signals,				\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..551fefe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1217,6 +1217,22 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+struct stack_struct {
+	struct list_head next;
+	void (*fn)(void*);
+	void *arg;
+	volatile long state;
+	struct thread_info *ti;
+	u32 flags;
+	enum {STACK_LIVE, STACK_START, STACK_DEAD} stack_state;
+	struct arch_stack_struct arch;
+};
+
+#define SSF_AUTODELETE		(1<<0)
+#define SSF_RESTORE_STATE	(1<<1)
+#define SSF_START_WAITED	(1<<2)
+#define SSF_FORCE_SWITCH	(1<<3)
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1380,6 +1396,10 @@ struct task_struct {
 #endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
+	struct list_head stacks;
+	struct stack_struct main_stack;
+	struct stack_struct *current_stack;
+
 /* filesystem information */
 	struct fs_struct *fs;
 /* open file information */
@@ -2714,4 +2734,14 @@ static inline unsigned long rlimit_max(unsigned int limit)
 
 #endif /* __KERNEL__ */
 
+/* alt stacks */
+extern int init_alt_stack(struct stack_struct *s, void (*fn)(void*), void *arg,
+		bool  autodelete);
+extern void deinit_alt_stack(struct stack_struct *stack);
+extern void launch_alt_stack(struct stack_struct *stack);
+extern int run_on_alt_stack(void (*fn)(void*), void *arg);
+extern void exit_alt_stack(void);
+extern void schedule_alt_stack_tail(struct task_struct *p);
+extern void wait_alt_stacks(struct task_struct *tsk);
+extern NORET_TYPE void start_alt_stack(struct stack_struct *stack);
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..90ea9eb 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -941,6 +941,7 @@ NORET_TYPE void do_exit(long code)
 	exit_irq_thread();
 
 	exit_signals(tsk);  /* sets PF_EXITING */
+	wait_alt_stacks(tsk);
 	/*
 	 * tsk->flags are checked in the futex code to protect against
 	 * an exiting task cleaning up the robust pi futexes.
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..34f28b8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -274,6 +274,12 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	tsk->stack = ti;
 
+	tsk->main_stack.ti = ti;
+	tsk->main_stack.stack_state = STACK_LIVE;
+	tsk->current_stack = &tsk->main_stack;
+	INIT_LIST_HEAD(&tsk->stacks);
+	list_add(&tsk->main_stack.next, &tsk->stacks);
+
 	err = prop_local_init_single(&tsk->dirties);
 	if (err)
 		goto out;
diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..d69579c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2667,6 +2667,57 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 	raw_spin_unlock(&rq->lock);
 }
 
+static bool wake_up_alt_stacks(struct task_struct *p, unsigned int state)
+{
+	struct list_head *e;
+	bool found = false, unlock = false;
+	struct rq *rq;
+
+	if (p->on_rq) {
+		/*
+		 * rq lock protects against race with walking the stacks
+		 * list in schedule()
+		 */
+		rq = __task_rq_lock(p);
+		if (!p->on_rq)
+			__task_rq_unlock(rq);
+		else
+			unlock = true;
+	}
+
+	list_for_each(e, &p->stacks) {
+		struct stack_struct *ss =
+			list_entry(e, struct stack_struct, next);
+
+		if (p->current_stack == ss || !(ss->state & state))
+			continue;
+
+		ss->state = TASK_RUNNING;
+		found = true;
+	}
+
+	if (p->state == TASK_RUNNING) {
+		if (found && p->current_stack == &p->main_stack) {
+			p->current_stack->flags |= SSF_FORCE_SWITCH;
+			set_tsk_need_resched(p);
+			kick_process(p);
+		}
+		found = false;
+	} else if (!found)
+		found = (p->state & state);
+	else if (!(p->state & state)) {
+		/* need to switch to waked up stack */
+		p->current_stack->flags |= SSF_RESTORE_STATE;
+		p->current_stack->state = p->state;
+		set_tsk_need_resched(p);
+	}
+
+	if (unlock)
+		__task_rq_unlock(rq);
+
+	return found;
+}
+
 /**
  * try_to_wake_up - wake up a thread
  * @p: the thread to be awakened
@@ -2690,7 +2741,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 
 	smp_wmb();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	if (!(p->state & state))
+
+	if (!wake_up_alt_stacks(p, state))
 		goto out;
 
 	success = 1; /* we're going to change ->state */
@@ -4278,6 +4330,56 @@ pick_next_task(struct rq *rq)
 	BUG(); /* the idle class will always have a runnable task */
 }
 
+static noinline int try_alt_stack(struct task_struct *p)
+{
+	struct list_head *e;
+	bool found = false;
+	struct stack_struct *next = &p->main_stack, *prev;
+
+	p->current_stack->flags &= ~SSF_FORCE_SWITCH;
+
+	list_for_each(e, &p->stacks) {
+		next = list_entry(e, struct stack_struct, next);
+
+		if (p->current_stack == next || next->state)
+			continue;
+
+		found = true;
+		break;
+	}
+
+	/*
+	 * If current task is dead and all other stacks are sleeping
+	 * then switch to the main stack
+	 */
+	if (!found) {
+	       if (p->state == TASK_DEAD)
+		       next = &p->main_stack;
+	       else
+		       return 0;
+	}
+
+	if (next == p->current_stack)
+		return 0;
+
+	prev = switch_alt_stack(p->current_stack, next);
+
+	if (prev->state == TASK_DEAD) {
+		list_del(&prev->next);
+		if (prev->flags & SSF_AUTODELETE) {
+			deinit_alt_stack(prev);
+			kfree(prev);
+		} else
+			prev->stack_state = STACK_DEAD;
+		put_task_struct(p);
+		/* check if main stack is waiting for alt stack in exit */
+		if ((p->flags & PF_EXITING) && list_is_singular(&p->stacks))
+			p->state = TASK_RUNNING;
+	}
+
+	return 1;
+}
+
 /*
  * schedule() is the main scheduler function.
  */
@@ -4303,10 +4405,19 @@ need_resched:
 	raw_spin_lock_irq(&rq->lock);
 
 	switch_count = &prev->nivcsw;
-	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
+	if ((prev->state || (prev->current_stack->flags & SSF_FORCE_SWITCH))
+			&& !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
-		} else {
+		} else if (!list_is_singular(&prev->stacks)) {
+			if (try_alt_stack(prev)) {
+				cpu = smp_processor_id();
+				rq = cpu_rq(cpu);
+				prev = rq->curr;
+			}
+		}
+		
+		if (prev->state) {
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
 
@@ -4366,8 +4477,13 @@ need_resched:
 	post_schedule(rq);
 
 	preempt_enable_no_resched();
-	if (need_resched())
+	if (need_resched()) {
+		if (current->current_stack->flags & SSF_RESTORE_STATE) {
+			current->current_stack->flags &= ~SSF_RESTORE_STATE;
+			current->state = current->current_stack->state;
+		}
 		goto need_resched;
+	}
 }
 EXPORT_SYMBOL(schedule);
 
@@ -8204,6 +8320,8 @@ void __init sched_init(void)
 		zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
+	list_add(&init_task.main_stack.next, &init_task.stacks);
+
 	scheduler_running = 1;
 }
 
@@ -9358,3 +9476,127 @@ struct cgroup_subsys cpuacct_subsys = {
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
 
+int init_alt_stack(struct stack_struct *stack, void (*fn)(void*), void *arg,
+		bool autodelete)
+{
+	stack->ti = alloc_thread_info_node(current, numa_node_id());
+
+	if (!stack->ti)
+		return -ENOMEM;
+
+	*(unsigned long *)(stack->ti + 1) = STACK_END_MAGIC;
+
+	stack->fn = fn;
+	stack->arg = arg;
+	stack->stack_state = STACK_DEAD;
+	stack->flags = autodelete ? SSF_AUTODELETE : 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(init_alt_stack);
+
+void launch_alt_stack(struct stack_struct *stack)
+{
+	unsigned long flags;
+
+	BUG_ON(stack->stack_state != STACK_DEAD);
+
+	*stack->ti = *task_thread_info(current);
+	arch_alt_stack_setup(stack);
+
+	stack->state = TASK_RUNNING;
+	stack->stack_state = STACK_START;
+	/* pi_lock synchronize with ttwu */
+	raw_spin_lock_irqsave(&current->pi_lock, flags);
+	list_add(&stack->next, &current->stacks);
+	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+	get_task_struct(current);
+	if (current->current_stack == &current->main_stack) {
+		/* force switching to new stack */
+		stack->flags |= SSF_START_WAITED;
+		while (stack->stack_state == STACK_START) {
+			current->state = TASK_UNINTERRUPTIBLE;
+			schedule();
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(launch_alt_stack);
+
+int run_on_alt_stack(void (*fn)(void*), void *arg)
+{
+	int r;
+	struct stack_struct *stack = kmalloc(sizeof(*stack), GFP_KERNEL);
+
+	if (!stack)
+		return -ENOMEM;
+
+	r = init_alt_stack(stack, fn, arg, true);
+
+	if (r)
+		kfree(stack);
+	else
+		launch_alt_stack(stack);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(run_on_alt_stack);
+
+void deinit_alt_stack(struct stack_struct *stack)
+{
+	free_pages((unsigned long)stack->ti, get_order(THREAD_SIZE));
+}
+EXPORT_SYMBOL_GPL(deinit_alt_stack);
+
+NORET_TYPE void exit_alt_stack(void)
+{
+	if (current->current_stack != &current->main_stack) {
+		current->state = TASK_DEAD;
+		schedule();
+	}
+	BUG();
+	/* Avoid "noreturn function does return".  */
+	for (;;)
+		cpu_relax();    /* For when BUG is null */
+}
+EXPORT_SYMBOL_GPL(exit_alt_stack);
+
+void schedule_alt_stack_tail(struct task_struct *p)
+	__releases(rq->lock)
+{
+	raw_spin_unlock_irq(&this_rq()->lock);
+	preempt_enable();
+}
+
+NORET_TYPE void start_alt_stack(struct stack_struct *stack)
+{
+	stack->stack_state = STACK_LIVE;
+	if (stack->flags & SSF_START_WAITED) {
+		current->main_stack.state = TASK_RUNNING;
+		stack->flags &= ~SSF_START_WAITED;
+	}
+	schedule_alt_stack_tail(current);
+	stack->fn(stack->arg);
+	exit_alt_stack();
+	BUG();
+}
+
+void wait_alt_stacks(struct task_struct *tsk)
+{
+	if (current->current_stack != &current->main_stack) {
+		struct list_head *e;
+		printk(KERN_ALERT"Exit is called on alt stack. Reboot is needed\n");
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		list_for_each(e, &tsk->stacks) {
+			struct stack_struct *ss =
+				list_entry(e, struct stack_struct, next);
+			if (tsk->current_stack != ss)
+				ss->state = TASK_UNINTERRUPTIBLE;
+			schedule();
+		}
+	}
+
+	while(!list_is_singular(&tsk->stacks)) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule();
+	}
+}
--
			Gleb.
