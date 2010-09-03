Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0ICQmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:42:33 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57289 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab0ICQmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:42:32 -0400
Date: Fri, 3 Sep 2010 22:12:19 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
 (un)registration and exception handling.
Message-ID: <20100903164219.GB1904@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
 <1283377414.2059.1729.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1283377414.2059.1729.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-09-01 23:43:34]:

> On Wed, 2010-08-25 at 19:12 +0530, Srikar Dronamraju wrote:
> 
> > TODO:
> > 1. Allow multiple probes at a probepoint.
> > 2. Booster probes.
> > 3. Allow probes to be inherited across fork.
> 
> I wouldn't worry about that, focus on inode attached probes and you get
> fork for free.

I am working on the file based probing. It compiles but havent got it to
test it yet, I can post the patch if you are interested. It should
achieve similar to inode probing.

However I would have an issue with making inode based probing the
default.
1. Making all probing based on inode can be a performance hog.

2. Since unlike kernel space, every process has a different space, so
why would we have to insert breakpoints in each of its process space if
we are not interested in them.

3. Ingo has a requirement for allowing normal users to use uprobes thro
perf. When this feature gets implemented, we have to be careful about a
normal users trying to just trace their application resulting in it
hitting performance all other users. 

	For example: one user places a probe on /usr/lib/libc.so: malloc
	- Another normal users looks at the current userspace probes and
	  constructs a program that just does malloc/free just to
	  degrade the performance of the system.

	- user could be interested in just one process which could be
	  calling malloc just 10 times. However during the same time
	  there are 1000 processes which could all together call 100000
	  times during the same time.

So even when we allow file based tracing across the system, it should be
restricted to just the root user.

As we discussed in previous discussions, Inode based tracing wasnt
accepted back in 2006. May be the approach was a problem then but what
was suggested then was pid based tracing.

> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 87bd26b..c8c8e3f 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -49,6 +49,7 @@ config OPTPROBES
> >  
> >  config UPROBES
> >  	bool "User-space probes (EXPERIMENTAL)"
> > +	default n
> >  	depends on ARCH_SUPPORTS_UPROBES
> >  	depends on MMU
> >  	help
> 
> Seems like a weird place for this hunk, does this want to live
> elsewhere?
> 

Okay, will cleanup.

> > +#ifdef CONFIG_UPROBES
> > +	if (unlikely(current->utask))
> > +		uprobe_free_utask(current);
> > +#endif
> 
> A nicer way is to provide flush_uprobes() unconditionally.

Okay  will do

> 
> > +#ifdef CONFIG_UPROBES
> > +	struct uprobe_process *uproc;	/* per mm uprobes info */
> > +#endif
> >  };
> 
> I find the _process postfix a bit weird in this context, how about
> something like:
> 
>   struct mm_uprobes *mm_uprobes;
> 
> instead?

Okay,  will do

> 
> > @@ -1496,6 +1496,9 @@ struct task_struct {
> >  		unsigned long memsw_bytes; /* uncharged mem+swap usage */
> >  	} memcg_batch;
> >  #endif
> > +#ifdef CONFIG_UPROBES
> > +	struct uprobe_task *utask;
> > +#endif
> >  };
> 
> Make that: 
> 
> 	struct uprobe_task_state uprobe_state;
> 
> And provide an empty struct for !CONFIG_UPROBE, see below.
> 

Okay,  will do

> 
> > +/* This is what the user supplies us. */
> > +struct uprobe {
> > +	/*
> > +	 * The pid of the probed process.  Currently, this can be the
> > +	 * thread ID (task->pid) of any active thread in the process.
> > +	 */
> > +	pid_t pid;
> 
> Would fail for pid namespaces I guess...

Can you explain a bit more?

> 
> > +	/* Location of the probepoint */
> > +	unsigned long vaddr;
> > +
> > +	/* Handler to run when the probepoint is hit */
> > +	void (*handler)(struct uprobe*, struct pt_regs*);
> > +};
> 

> > +/*
> > + * uprobe_process -- not a user-visible struct.
> 
> Seems like a weird comment for kernel code..

Okay, will cleanup.

> 
> > +	/* lock held while traversing/modifying uprobe_list and n_ppts */
> > +	spinlock_t pptlist_lock;	/* protects uprobe_list */
> 
> Its customary to write it like:
> 
> 	spinlock_t	 list_lock; /* protects uprobe_list, nr_uprobes */
> 	struct list_head uprobe_list;
> 	int		 nr_uprobes;
> 

Okay,  will do


> > +
> > +	/* number of probept allocated for this process */
> > +	int n_ppts;
> > +
> > +	/*
> > +	 * Manages slots for instruction-copies to be single-stepped
> > +	 * out of line.
> > +	 */
> > +	void *xol_area;
> 
> Why void * and not simply:
> 
> 	struct uprobes_xol_area xol_area;

Okay,  will do


> That struct is small enough and you only get one per mm and saves you an
> allocation/pointer-chase.
> 
> > +};
> > +
> > +/*
> > + * uprobe_probept -- not a user-visible struct.
> > + * A uprobe_probept represents a probepoint.
> > + * Guarded by uproc->lock.
> > + */
> > +struct uprobe_probept {
> 
> you really got a way with names, uprobe_point would be so much better.

Okay, 

> 
> > +	/* breakpoint/XOL details */
> > +	struct user_bkpt user_bkpt;
> > +
> > +	/*
> > +	 * ppt goes in the uprobe_process->uprobe_table when registered --
> > +	 * even before the breakpoint has been inserted.
> > +	 */
> > +	struct list_head ut_node;
> > +
> > +	atomic_t refcount;
> > +
> > +	/* The parent uprobe_process */
> > +	struct uprobe_process *uproc;
> > +
> > +	struct uprobe *uprobe;
> > +};
> 
> So this thing is a link between the process and the probe, I'm not quite
> sure what you need the refcount for, it seems to me you can only have on
> of these per process/probe combination.
> 
> If you had used inode/offset based probes they would have been unique in
> the system and you could have had an {inode,offset} indexed global tree
> (or possibly a tree per inode, but that would mean adding to the inode
> structure, which I think is best avoided).

Unlike kernel probing, uprobes has a disadvantage.
Lets assume that the request for removing a probepoint when some of the
threads have actually hit the probe. Because the handlers in uprobes can
sleep, we cant remove the probepoint at the same time as the request for
the removing the probe. This is where refcount steps in and helps us to
decide when we can remove the probepoint. Even inoode based
tracing or file based tracing would need it.

> 
> That would also reduce the mm state to purely the xol area, no need to
> manage this process to probe map.
> 
> > +enum uprobe_task_state {
> > +	UTASK_RUNNING,
> > +	UTASK_BP_HIT,
> > +	UTASK_SSTEP
> > +};
> > +
> > +/*
> > + * uprobe_utask -- not a user-visible struct.
> > + * Corresponds to a thread in a probed process.
> > + * Guarded by uproc->mutex.
> > + */
> > +struct uprobe_task {
> > +	struct user_bkpt_task_arch_info arch_info;
> > +
> > +	enum uprobe_task_state state;
> > +
> > +	struct uprobe_probept *active_ppt;
> > +};
> 
> I would be thinking you can obtain the active probe point from the
> address the task is stuck at and the state seems fairly redundant. Which
> leaves you with the arch state, which afaict is exactly as large as the
> pointer currently in the task struct.

Lets assume the thread is about to singlestep (or has singlestepped)
So the instruction pointer is pointing to one of the slot (or it could
be pointing to some other arbitrary address if it has singlestepped lets
say a jump instruction). 

We could get the active probe point from the address the task is stuck
if the instruction pointers happens to be pointing to slots.  But for
that we would have to maintain a relation between slots and the current
probepoint it is servicing.  I think its easier to cache the
active_probept then try to maintain this relationship. Moreover we are
never certain in some cases where the underlying instruction happened to
be a jump.

state is needed so that we know at do_notify_resume time whether the
thread should singlestep or has already singlestep.
Do you see a way to determine in do_notify_resume if the thread is
singlestepping or not. I dont think the instruction pointer can
determine if we are about to singlestep or have already singlestepped.

<snipped>

> >  	perf_event_fork(p);
> > +#ifdef CONFIG_UPROBES
> > +	if ((current->mm) && !(clone_flags & CLONE_VM)) {
> > +		if (unlikely(current->mm->uproc))
> > +			uprobe_handle_fork(p);
> > +	}
> > +#endif
> >  	return p;
> >  
> >  bad_fork_free_pid:
> 
> All that can be replaced by unconditional functions, simply stub them
> out for !CONFIG_UPROBE.


Okay. 


<snipped>
> >  
> >  /*
> >   * xol_get_insn_slot - If user_bkpt  was not allocated a slot, then
> > - * allocate a slot. If uprobes_insert_bkpt is already called, (i.e
> > + * allocate a slot. If insert_bkpt is already called, (i.e
> >   * user_bkpt.vaddr != 0) then copy the instruction into the slot.
> >   * @user_bkpt: probepoint information
> >   * @xol_area refers the unique per process uprobes_xol_area for
> 
> Wandering hunks, these seem to want to get folded back to wherever the
> original text comes from..
> 

Okay, will check and cleanup.

> > @@ -741,6 +745,642 @@ validate_end:
> >  }
> >  /* end of slot allocation for XOL */
> >  
> > +
> > +struct notifier_block uprobes_exception_nb = {
> > +	.notifier_call = uprobes_exception_notify,
> > +	.priority = 0x7ffffff0,
> > +};
> > +
> > +typedef void (*uprobe_handler_t)(struct uprobe*, struct pt_regs*);
> > +
> > +/* Guards lookup, creation, and deletion of uproc. */
> > +static DEFINE_MUTEX(uprobe_mutex);
> 
> uproc is per mm, why a global mutex?

yes, uproc is per mm but gets created when the first probe on that
process gets registered.
Do you have anyother lock that you have in mind?
I could have used the mmap_sem, but I am not sure if we should be taking
a write lock on the mmap_sem.  

> 
> 
> > +/*
> > + * Fork callback: The current task has spawned a process.
> > + * NOTE: For now, we don't pass on uprobes from the parent to the
> > + * child. We now do the necessary clearing of breakpoints in the
> > + * child's address space.
> > + * This function handles the case where vm is not shared between
> > + * the parent and the child.
> > + *
> > + * TODO:
> > + *	- Provide option for child to inherit uprobes.
> 
> Don't bother with that...

I think it would be needed down the line. Lets keep it in TODO for
now.

> 
> > + */
> > +void uprobe_handle_fork(struct task_struct *child)
> > +{
> > +	struct uprobe_process *uproc;
> > +	struct uprobe_probept *ppt;
> > +	int ret;
> > +
> > +	uproc = current->mm->uproc;
> > +
> > +	/*
> > +	 * New process spawned by parent but not sharing the same mm.
> > +	 * Remove the probepoints in the child's text.
> > +	 *
> > +	 * We also hold the uproc->mutex for the parent - so no
> > +	 * new uprobes will be registered 'til we return.
> > +	 */
> 
> The grand thing about not having any of this process state is that you
> dont need to clean it up either..

If we had done inode based tracing and a process that has breakpoints forks, 
wont we have to recreate the breakpoint metadata for the child process?
I dont see the child calling mmap. When and how would be the probepoint
data, user_bkpt data for the breakpoints, get replicated/linked to the
child?

> > +	if (unlikely(!utask)) {
> > +		utask = add_utask(uproc);
> > +
> > +		/* Failed to allocate utask for the current task. */
> > +		BUG_ON(!utask);
> > +		probept = uprobes_get_bkpt_addr(regs);
> > +		ppt = find_probept(uproc, probept);
> > +
> > +		/*
> > +		 * The probept was refcounted in uprobe_bkpt_notifier;
> > +		 * Hence it would be mysterious to miss ppt now
> > +		 */
> > +		WARN_ON(!ppt);
> > +		utask->active_ppt = ppt;
> > +		utask->state = UTASK_BP_HIT;
> > +	} else
> > +		ppt = utask->active_ppt;
> 
> You can replace this with:
> 
>  addr = instruction_pointer(task_pt_regs(current)) -
> ip_advancement_by_brkpt_insn;

uprobes_get_bkpt_addr does this exactly. However after we have
singlestepped, we cant rely on this. Also how do we know if we have
already singlestepped or not? After singlestepping we may still be
pointing to some slot or the instruction pointer could be pointing
something completely different.

> 
> and then proceed from there like described below to obtain the struct
> uprobe.
> 
> You can infer the SS/HIT state by checking if the user-addr is in the
> XOL area or not.
> 
> > +	if (utask->state == UTASK_BP_HIT) {
> > +		utask->state = UTASK_SSTEP;
> > +		u = ppt->uprobe;
> > +		if (u && u->handler)
> > +			u->handler(u, regs);
> > +
> > +		if (!pre_ssout(ppt, regs))
> > +			arch_uprobe_enable_sstep(regs);
> > +	} else if (utask->state == UTASK_SSTEP) {
> > +		if (sstep_complete(regs, ppt)) {
> > +			put_probept(ppt);
> > +			utask->active_ppt = NULL;
> > +			utask->state = UTASK_RUNNING;
> > +			arch_uprobe_disable_sstep(regs);
> > +		}
> > +	}
> > +}
> > +
> > +/*
> > + * uprobe_bkpt_notifier gets called from interrupt context
> > + * it gets a reference to the ppt and sets TIF_UPROBE flag,
> > + */
> > +int uprobe_bkpt_notifier(struct pt_regs *regs)
> > +{
> > +	struct uprobe_process *uproc;
> > +	struct uprobe_probept *ppt;
> > +	struct uprobe_task *utask;
> > +	unsigned long probept;
> > +
> > +	if (!current->mm || !current->mm->uproc)
> > +		/* task is currently not uprobed */
> > +		return 0;
> > +
> > +	uproc = current->mm->uproc;
> > +	utask = current->utask;
> > +	probept = uprobes_get_bkpt_addr(regs);
> 
> Its an address, not a struct uprobe_probept * so call it addr if
> anything.

Okay, 

> 
> > +	ppt = find_probept(uproc, probept);
> > +	if (!ppt)
> > +		return 0;
> > +	get_probept(ppt);
> > +	if (utask) {
> > +		utask->active_ppt = ppt;
> > +		utask->state = UTASK_BP_HIT;
> > +	}
> 
> Right, so all this should die..
> 
> Obtain the address, lookup the vma, get the file, compute the offset
> inside that file -> {inode,offset}
> 
> Do the lookup in the global tree to obtain the uprobe, and possibly
> execute the probe handler right here in interrupt context, if it fails
> with -EFAULT, continue with the below:

We dropped running the handler in interrupt context based on comments to
my previous postings. It not only makes it complex at the time of
handling the probe but we didnt see a difference when we compare the
time it took to run the handler in task context to running the handler
in interrupt context. I had even posted the timing info when
register_uprobes was exported. 

> 
> > +#ifdef CONFIG_ARCH_SUPPORTS_UPROBES
> > +	set_thread_flag(TIF_UPROBE);
> > +#endif
> 
> How can we ever get here if the architecture doesn't support uprobes?

Right, this is not needed, the #ifdefs were added just allow to compile 
kernel/uprobes.o even when  CONFIG_UPROBES wasnt enabled.
There was a comment to one of my earlier posting on LKML about compiling
kernel/uprobe.o when CONFIG_UPROBES wasnt enabled failed.

I am more than happy to remove the #ifdef.

> 
> > +	return 1;
> > +}
> > +
