Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0IAVny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:43:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0IAVnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:43:53 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
 (un)registration and exception handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Sep 2010 23:43:34 +0200
Message-ID: <1283377414.2059.1729.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 19:12 +0530, Srikar Dronamraju wrote:

> TODO:
> 1. Allow multiple probes at a probepoint.
> 2. Booster probes.
> 3. Allow probes to be inherited across fork.

I wouldn't worry about that, focus on inode attached probes and you get
fork for free.

> 4. probing function returns.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
> ---

>  arch/Kconfig             |    1 
>  fs/exec.c                |    4 
>  include/linux/mm_types.h |    4 
>  include/linux/sched.h    |    3 
>  include/linux/uprobes.h  |  143 ++++++++++
>  kernel/fork.c            |   21 +
>  kernel/uprobes.c         |  653 ++++++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 826 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 87bd26b..c8c8e3f 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -49,6 +49,7 @@ config OPTPROBES
>  
>  config UPROBES
>  	bool "User-space probes (EXPERIMENTAL)"
> +	default n
>  	depends on ARCH_SUPPORTS_UPROBES
>  	depends on MMU
>  	help

Seems like a weird place for this hunk, does this want to live
elsewhere?

> diff --git a/fs/exec.c b/fs/exec.c
> index 2d94552..d7e64d0 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1053,6 +1053,10 @@ void setup_new_exec(struct linux_binprm * bprm)
>  			
>  	flush_signal_handlers(current, 0);
>  	flush_old_files(current->files);
> +#ifdef CONFIG_UPROBES
> +	if (unlikely(current->utask))
> +		uprobe_free_utask(current);
> +#endif

A nicer way is to provide flush_uprobes() unconditionally.

>  }
>  EXPORT_SYMBOL(setup_new_exec);
>  
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index cb57d65..8f79e51 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -12,6 +12,7 @@
>  #include <linux/completion.h>
>  #include <linux/cpumask.h>
>  #include <linux/page-debug-flags.h>
> +#include <linux/uprobes.h>
>  #include <asm/page.h>
>  #include <asm/mmu.h>
>  
> @@ -310,6 +311,9 @@ struct mm_struct {
>  #ifdef CONFIG_MMU_NOTIFIER
>  	struct mmu_notifier_mm *mmu_notifier_mm;
>  #endif
> +#ifdef CONFIG_UPROBES
> +	struct uprobe_process *uproc;	/* per mm uprobes info */
> +#endif
>  };

I find the _process postfix a bit weird in this context, how about
something like:

  struct mm_uprobes *mm_uprobes;

instead?

>  /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index e18473f..e237ba2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1496,6 +1496,9 @@ struct task_struct {
>  		unsigned long memsw_bytes; /* uncharged mem+swap usage */
>  	} memcg_batch;
>  #endif
> +#ifdef CONFIG_UPROBES
> +	struct uprobe_task *utask;
> +#endif
>  };

Make that: 

	struct uprobe_task_state uprobe_state;

And provide an empty struct for !CONFIG_UPROBE, see below.


> +/* This is what the user supplies us. */
> +struct uprobe {
> +	/*
> +	 * The pid of the probed process.  Currently, this can be the
> +	 * thread ID (task->pid) of any active thread in the process.
> +	 */
> +	pid_t pid;

Would fail for pid namespaces I guess...

> +	/* Location of the probepoint */
> +	unsigned long vaddr;
> +
> +	/* Handler to run when the probepoint is hit */
> +	void (*handler)(struct uprobe*, struct pt_regs*);
> +};

Like previously said, I would much rather see an inode/offset based
interface and do the pid/fork/pgroup/cgroup etc.. stuff as filters on
top of that.

> +/*
> + * uprobe_process -- not a user-visible struct.

Seems like a weird comment for kernel code..

> + * A uprobe_process represents a probed process.  A process can have
> + * multiple probepoints (each represented by a uprobe_probept) and
> + * one or more threads (each represented by a uprobe_task).
> + *
> + * All processes/threads that share a mm share the same uprobe_process.
> + */
> +struct uprobe_process {

struct mm_uprobes {

> +	/*
> +	 * mutex locked for any change to the uprobe_process's
> +	 * graph (including uprobe_probept, taking a slot in xol_area) --
> +	 * e.g., due to probe [un]registration or special events like exit.
> +	 */
> +	struct mutex mutex;
> +
> +	/* Table of uprobe_probepts registered for this process */
> +	struct list_head uprobe_list;
> +
> +	atomic_t refcount;
> +
> +	/* lock held while traversing/modifying uprobe_list and n_ppts */
> +	spinlock_t pptlist_lock;	/* protects uprobe_list */

Its customary to write it like:

	spinlock_t	 list_lock; /* protects uprobe_list, nr_uprobes */
	struct list_head uprobe_list;
	int		 nr_uprobes;

> +
> +	/* number of probept allocated for this process */
> +	int n_ppts;
> +
> +	/*
> +	 * Manages slots for instruction-copies to be single-stepped
> +	 * out of line.
> +	 */
> +	void *xol_area;

Why void * and not simply:

	struct uprobes_xol_area xol_area;

That struct is small enough and you only get one per mm and saves you an
allocation/pointer-chase.

> +};
> +
> +/*
> + * uprobe_probept -- not a user-visible struct.
> + * A uprobe_probept represents a probepoint.
> + * Guarded by uproc->lock.
> + */
> +struct uprobe_probept {

you really got a way with names, uprobe_point would be so much better.

> +	/* breakpoint/XOL details */
> +	struct user_bkpt user_bkpt;
> +
> +	/*
> +	 * ppt goes in the uprobe_process->uprobe_table when registered --
> +	 * even before the breakpoint has been inserted.
> +	 */
> +	struct list_head ut_node;
> +
> +	atomic_t refcount;
> +
> +	/* The parent uprobe_process */
> +	struct uprobe_process *uproc;
> +
> +	struct uprobe *uprobe;
> +};

So this thing is a link between the process and the probe, I'm not quite
sure what you need the refcount for, it seems to me you can only have on
of these per process/probe combination.

If you had used inode/offset based probes they would have been unique in
the system and you could have had an {inode,offset} indexed global tree
(or possibly a tree per inode, but that would mean adding to the inode
structure, which I think is best avoided).

That would also reduce the mm state to purely the xol area, no need to
manage this process to probe map.

> +enum uprobe_task_state {
> +	UTASK_RUNNING,
> +	UTASK_BP_HIT,
> +	UTASK_SSTEP
> +};
> +
> +/*
> + * uprobe_utask -- not a user-visible struct.
> + * Corresponds to a thread in a probed process.
> + * Guarded by uproc->mutex.
> + */
> +struct uprobe_task {
> +	struct user_bkpt_task_arch_info arch_info;
> +
> +	enum uprobe_task_state state;
> +
> +	struct uprobe_probept *active_ppt;
> +};

I would be thinking you can obtain the active probe point from the
address the task is stuck at and the state seems fairly redundant. Which
leaves you with the arch state, which afaict is exactly as large as the
pointer currently in the task struct.

> --git a/kernel/fork.c b/kernel/fork.c
> index b7e9d60..d78cf5d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -187,6 +187,11 @@ void __put_task_struct(struct task_struct *tsk)
>  	delayacct_tsk_free(tsk);
>  	put_signal_struct(tsk->signal);
>  
> +#ifdef CONFIG_UPROBES
> +	if (unlikely(tsk->utask))
> +		uprobe_free_utask(tsk);
> +#endif
> +
>  	if (!profile_handoff_task(tsk))
>  		free_task(tsk);
>  }
> @@ -525,6 +530,10 @@ void __mmdrop(struct mm_struct *mm)
>  	mm_free_pgd(mm);
>  	destroy_context(mm);
>  	mmu_notifier_mm_destroy(mm);
> +#ifdef CONFIG_UPROBES
> +	if (unlikely(mm->uproc))
> +		uprobe_put_uprocess(mm);
> +#endif
>  	free_mm(mm);
>  }
>  EXPORT_SYMBOL_GPL(__mmdrop);
> @@ -683,6 +692,9 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
>  	if (mm->binfmt && !try_module_get(mm->binfmt->module))
>  		goto free_pt;
>  
> +#ifdef CONFIG_UPROBES
> +	mm->uproc = NULL;
> +#endif
>  	return mm;
>  
>  free_pt:
> @@ -1190,6 +1202,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	INIT_LIST_HEAD(&p->pi_state_list);
>  	p->pi_state_cache = NULL;
>  #endif
> +#ifdef CONFIG_UPROBES
> +	p->utask = NULL;
> +#endif
>  	/*
>  	 * sigaltstack should be cleared when sharing the same VM
>  	 */
> @@ -1288,6 +1303,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	proc_fork_connector(p);
>  	cgroup_post_fork(p);
>  	perf_event_fork(p);
> +#ifdef CONFIG_UPROBES
> +	if ((current->mm) && !(clone_flags & CLONE_VM)) {
> +		if (unlikely(current->mm->uproc))
> +			uprobe_handle_fork(p);
> +	}
> +#endif
>  	return p;
>  
>  bad_fork_free_pid:

All that can be replaced by unconditional functions, simply stub them
out for !CONFIG_UPROBE.

> diff --git a/kernel/uprobes.c b/kernel/uprobes.c
> index 230adf3..38c7abb 100644
> --- a/kernel/uprobes.c
> +++ b/kernel/uprobes.c
> @@ -21,6 +21,7 @@
>   *	Jim Keniston
>   */
>  #include <linux/kernel.h>
> +#include <linux/types.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/sched.h>
> @@ -36,6 +37,9 @@
>  #include <linux/file.h>
>  #include <linux/pid.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/kdebug.h>
> +
>  
>  struct user_bkpt_arch_info *arch = &user_bkpt_arch_info;
>  
> @@ -345,7 +349,7 @@ static int __insert_bkpt(struct task_struct *tsk,
>   *	@__insert_bkpt(). @user_bkpt->xol_vaddr must be the
>   *	address of an XOL instruction slot that is allocated to this
>   *	probepoint at least until after the completion of
> - *	@uprobes_post_sstep(), and populated with the contents of
> + *	@post_sstep(), and populated with the contents of
>   *	@user_bkpt->insn.
>   *	@tskinfo: points to a @user_bkpt_task_arch_info object for @tsk.
>   *	@regs: reflects the saved user state of @tsk.  pre_sstep()
> @@ -356,7 +360,7 @@ static int __insert_bkpt(struct task_struct *tsk,
>   *
>   * The client must ensure that the contents of @user_bkpt are not
>   * changed during the single-step operation -- i.e., between when
> - * @uprobes_pre_sstep() is called and when @uprobes_post_sstep() returns.
> + * @pre_sstep() is called and when @post_sstep() returns.
>   */
>  static int pre_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
>  		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
> @@ -610,7 +614,7 @@ static unsigned long xol_take_insn_slot(struct uprobes_xol_area *area)
>  
>  /*
>   * xol_get_insn_slot - If user_bkpt  was not allocated a slot, then
> - * allocate a slot. If uprobes_insert_bkpt is already called, (i.e
> + * allocate a slot. If insert_bkpt is already called, (i.e
>   * user_bkpt.vaddr != 0) then copy the instruction into the slot.
>   * @user_bkpt: probepoint information
>   * @xol_area refers the unique per process uprobes_xol_area for

Wandering hunks, these seem to want to get folded back to wherever the
original text comes from..

> @@ -741,6 +745,642 @@ validate_end:
>  }
>  /* end of slot allocation for XOL */
>  
> +
> +struct notifier_block uprobes_exception_nb = {
> +	.notifier_call = uprobes_exception_notify,
> +	.priority = 0x7ffffff0,
> +};
> +
> +typedef void (*uprobe_handler_t)(struct uprobe*, struct pt_regs*);
> +
> +/* Guards lookup, creation, and deletion of uproc. */
> +static DEFINE_MUTEX(uprobe_mutex);

uproc is per mm, why a global mutex?


> +/*
> + * Fork callback: The current task has spawned a process.
> + * NOTE: For now, we don't pass on uprobes from the parent to the
> + * child. We now do the necessary clearing of breakpoints in the
> + * child's address space.
> + * This function handles the case where vm is not shared between
> + * the parent and the child.
> + *
> + * TODO:
> + *	- Provide option for child to inherit uprobes.

Don't bother with that...

> + */
> +void uprobe_handle_fork(struct task_struct *child)
> +{
> +	struct uprobe_process *uproc;
> +	struct uprobe_probept *ppt;
> +	int ret;
> +
> +	uproc = current->mm->uproc;
> +
> +	/*
> +	 * New process spawned by parent but not sharing the same mm.
> +	 * Remove the probepoints in the child's text.
> +	 *
> +	 * We also hold the uproc->mutex for the parent - so no
> +	 * new uprobes will be registered 'til we return.
> +	 */

The grand thing about not having any of this process state is that you
dont need to clean it up either..

> +	mutex_lock(&uproc->mutex);
> +	list_for_each_entry(ppt, &uproc->uprobe_list, ut_node) {
> +		ret = __remove_bkpt(child, &ppt->user_bkpt);
> +		if (ret && ret != -EINVAL) {
> +			/* Ratelimit this? */
> +			printk(KERN_ERR "Pid %d forked %d; failed to"
> +				" remove probepoint at %#lx in child\n",
> +				current->pid, child->pid,
> +				ppt->user_bkpt.vaddr);
> +		}
> +	}
> +	mutex_unlock(&uproc->mutex);
> +}
> +
> +/*
> + * uprobe_notify_resume gets called in task context just before returning
> + * to userspace.
> + *
> + *  If its the first time the probepoint is hit, slot gets allocated here.
> + *  If its the first time the thread hit a breakpoint, utask gets
> + *  allocated here.
> + */
> +void uprobe_notify_resume(struct pt_regs *regs)
> +{
> +	struct uprobe_process *uproc;
> +	struct uprobe_probept *ppt;
> +	struct uprobe_task *utask;
> +	struct uprobe *u;
> +	unsigned long probept;
> +
> +	utask = current->utask;
> +	uproc = current->mm->uproc;
> +	if (unlikely(!utask)) {
> +		utask = add_utask(uproc);
> +
> +		/* Failed to allocate utask for the current task. */
> +		BUG_ON(!utask);
> +		probept = uprobes_get_bkpt_addr(regs);
> +		ppt = find_probept(uproc, probept);
> +
> +		/*
> +		 * The probept was refcounted in uprobe_bkpt_notifier;
> +		 * Hence it would be mysterious to miss ppt now
> +		 */
> +		WARN_ON(!ppt);
> +		utask->active_ppt = ppt;
> +		utask->state = UTASK_BP_HIT;
> +	} else
> +		ppt = utask->active_ppt;

You can replace this with:

 addr = instruction_pointer(task_pt_regs(current)) -
ip_advancement_by_brkpt_insn;

and then proceed from there like described below to obtain the struct
uprobe.

You can infer the SS/HIT state by checking if the user-addr is in the
XOL area or not.

> +	if (utask->state == UTASK_BP_HIT) {
> +		utask->state = UTASK_SSTEP;
> +		u = ppt->uprobe;
> +		if (u && u->handler)
> +			u->handler(u, regs);
> +
> +		if (!pre_ssout(ppt, regs))
> +			arch_uprobe_enable_sstep(regs);
> +	} else if (utask->state == UTASK_SSTEP) {
> +		if (sstep_complete(regs, ppt)) {
> +			put_probept(ppt);
> +			utask->active_ppt = NULL;
> +			utask->state = UTASK_RUNNING;
> +			arch_uprobe_disable_sstep(regs);
> +		}
> +	}
> +}
> +
> +/*
> + * uprobe_bkpt_notifier gets called from interrupt context
> + * it gets a reference to the ppt and sets TIF_UPROBE flag,
> + */
> +int uprobe_bkpt_notifier(struct pt_regs *regs)
> +{
> +	struct uprobe_process *uproc;
> +	struct uprobe_probept *ppt;
> +	struct uprobe_task *utask;
> +	unsigned long probept;
> +
> +	if (!current->mm || !current->mm->uproc)
> +		/* task is currently not uprobed */
> +		return 0;
> +
> +	uproc = current->mm->uproc;
> +	utask = current->utask;
> +	probept = uprobes_get_bkpt_addr(regs);

Its an address, not a struct uprobe_probept * so call it addr if
anything.

> +	ppt = find_probept(uproc, probept);
> +	if (!ppt)
> +		return 0;
> +	get_probept(ppt);
> +	if (utask) {
> +		utask->active_ppt = ppt;
> +		utask->state = UTASK_BP_HIT;
> +	}

Right, so all this should die..

Obtain the address, lookup the vma, get the file, compute the offset
inside that file -> {inode,offset}

Do the lookup in the global tree to obtain the uprobe, and possibly
execute the probe handler right here in interrupt context, if it fails
with -EFAULT, continue with the below:

> +#ifdef CONFIG_ARCH_SUPPORTS_UPROBES
> +	set_thread_flag(TIF_UPROBE);
> +#endif

How can we ever get here if the architecture doesn't support uprobes?

> +	return 1;
> +}
> +
> +/*
> + * uprobe_post_notifier gets called in interrupt context.
> + * It completes the single step operation.
> + */
> +int uprobe_post_notifier(struct pt_regs *regs)
> +{
> +	struct uprobe_probept *ppt;
> +	struct uprobe_task *utask;
> +
> +	if (!current->mm || !current->mm->uproc || !current->utask)
> +		/* task is currently not uprobed */
> +		return 0;
> +
> +	utask = current->utask;
> +
> +	ppt = utask->active_ppt;
> +	if (!ppt)
> +		return 0;
> +
> +	if (uprobes_resume_can_sleep(&ppt->user_bkpt)) {
> +#ifdef CONFIG_ARCH_SUPPORTS_UPROBES
> +		set_thread_flag(TIF_UPROBE);
> +#endif
> +		return 1;
> +	}
> +	if (sstep_complete(regs, ppt)) {
> +		put_probept(ppt);
> +		arch_uprobe_disable_sstep(regs);
> +		utask->active_ppt = NULL;
> +		utask->state = UTASK_RUNNING;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  static int __init init_uprobes(void)
>  {
>  	int result = 0;
> @@ -752,7 +1392,14 @@ static int __init init_uprobes(void)
>  	if (arch->ip_advancement_by_bkpt_insn > arch->max_insn_bytes)
>  		result = bad_arch_param("ip_advancement_by_bkpt_insn",
>  				arch->ip_advancement_by_bkpt_insn);
> +
> +	register_die_notifier(&uprobes_exception_nb);
>  	return result;
>  }
>  
> +static void __exit exit_uprobes(void)
> +{
> +}
> +
>  module_init(init_uprobes);
> +module_exit(exit_uprobes);


