Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0ICRTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:19:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:43613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab0ICRTg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:19:36 -0400
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
In-Reply-To: <20100903164219.GB1904@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
	 <1283377414.2059.1729.camel@laptop>
	 <20100903164219.GB1904@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 19:19:09 +0200
Message-ID: <1283534349.2050.297.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 22:12 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-09-01 23:43:34]:
> 
> > On Wed, 2010-08-25 at 19:12 +0530, Srikar Dronamraju wrote:
> > 
> > > TODO:
> > > 1. Allow multiple probes at a probepoint.
> > > 2. Booster probes.
> > > 3. Allow probes to be inherited across fork.
> > 
> > I wouldn't worry about that, focus on inode attached probes and you get
> > fork for free.
> 
> I am working on the file based probing. It compiles but havent got it to
> test it yet, I can post the patch if you are interested. It should
> achieve similar to inode probing.
> 
> However I would have an issue with making inode based probing the
> default.
> 1. Making all probing based on inode can be a performance hog.

How so? You can add filters if you want.

> 2. Since unlike kernel space, every process has a different space, so
> why would we have to insert breakpoints in each of its process space if
> we are not interested in them.

You don't have to, but you can. The problem I have with this stuff is
that it makes the pid thing a primary interface, whereas it should be
one of many filter possibilities.

> 3. Ingo has a requirement for allowing normal users to use uprobes thro
> perf. When this feature gets implemented, we have to be careful about a
> normal users trying to just trace their application resulting in it
> hitting performance all other users. 
> 
> 	For example: one user places a probe on /usr/lib/libc.so: malloc
> 	- Another normal users looks at the current userspace probes and
> 	  constructs a program that just does malloc/free just to
> 	  degrade the performance of the system.
> 
> 	- user could be interested in just one process which could be
> 	  calling malloc just 10 times. However during the same time
> 	  there are 1000 processes which could all together call 100000
> 	  times during the same time.

See the filter thing.

> > > +/* This is what the user supplies us. */
> > > +struct uprobe {
> > > +	/*
> > > +	 * The pid of the probed process.  Currently, this can be the
> > > +	 * thread ID (task->pid) of any active thread in the process.
> > > +	 */
> > > +	pid_t pid;
> > 
> > Would fail for pid namespaces I guess...
> 
> Can you explain a bit more?

What pid namespace will you interpret that number in?

> > > +	/* Location of the probepoint */
> > > +	unsigned long vaddr;
> > > +
> > > +	/* Handler to run when the probepoint is hit */
> > > +	void (*handler)(struct uprobe*, struct pt_regs*);
> > > +};


> > > +	/* breakpoint/XOL details */
> > > +	struct user_bkpt user_bkpt;
> > > +
> > > +	/*
> > > +	 * ppt goes in the uprobe_process->uprobe_table when registered --
> > > +	 * even before the breakpoint has been inserted.
> > > +	 */
> > > +	struct list_head ut_node;
> > > +
> > > +	atomic_t refcount;
> > > +
> > > +	/* The parent uprobe_process */
> > > +	struct uprobe_process *uproc;
> > > +
> > > +	struct uprobe *uprobe;
> > > +};
> > 
> > So this thing is a link between the process and the probe, I'm not quite
> > sure what you need the refcount for, it seems to me you can only have on
> > of these per process/probe combination.
> > 
> > If you had used inode/offset based probes they would have been unique in
> > the system and you could have had an {inode,offset} indexed global tree
> > (or possibly a tree per inode, but that would mean adding to the inode
> > structure, which I think is best avoided).
> 
> Unlike kernel probing, uprobes has a disadvantage.
> Lets assume that the request for removing a probepoint when some of the
> threads have actually hit the probe. Because the handlers in uprobes can
> sleep, we cant remove the probepoint at the same time as the request for
> the removing the probe. This is where refcount steps in and helps us to
> decide when we can remove the probepoint. Even inoode based
> tracing or file based tracing would need it.

Stick the refcount in the actual struct uprobe instead?

> > 
> > That would also reduce the mm state to purely the xol area, no need to
> > manage this process to probe map.
> > 
> > > +enum uprobe_task_state {
> > > +	UTASK_RUNNING,
> > > +	UTASK_BP_HIT,
> > > +	UTASK_SSTEP
> > > +};
> > > +
> > > +/*
> > > + * uprobe_utask -- not a user-visible struct.
> > > + * Corresponds to a thread in a probed process.
> > > + * Guarded by uproc->mutex.
> > > + */
> > > +struct uprobe_task {
> > > +	struct user_bkpt_task_arch_info arch_info;
> > > +
> > > +	enum uprobe_task_state state;
> > > +
> > > +	struct uprobe_probept *active_ppt;
> > > +};
> > 
> > I would be thinking you can obtain the active probe point from the
> > address the task is stuck at and the state seems fairly redundant. Which
> > leaves you with the arch state, which afaict is exactly as large as the
> > pointer currently in the task struct.
> 
> Lets assume the thread is about to singlestep (or has singlestepped)
> So the instruction pointer is pointing to one of the slot (or it could
> be pointing to some other arbitrary address if it has singlestepped lets
> say a jump instruction). 
> 
> We could get the active probe point from the address the task is stuck
> if the instruction pointers happens to be pointing to slots.  But for
> that we would have to maintain a relation between slots and the current
> probepoint it is servicing.  I think its easier to cache the
> active_probept then try to maintain this relationship. Moreover we are
> never certain in some cases where the underlying instruction happened to
> be a jump.
> 
> state is needed so that we know at do_notify_resume time whether the
> thread should singlestep or has already singlestep.
> Do you see a way to determine in do_notify_resume if the thread is
> singlestepping or not. I dont think the instruction pointer can
> determine if we are about to singlestep or have already singlestepped.

The to singlestep or not would be implied by the IP pointing to the
start of a slot or not, but yes, I guess that as long as you do
singlestep you need some state.. sucks though. Boosted probes are much
nicer, they don't need that extra arch storage either, they can simply
push/pop the register.

> > > @@ -741,6 +745,642 @@ validate_end:
> > >  }
> > >  /* end of slot allocation for XOL */
> > >  
> > > +
> > > +struct notifier_block uprobes_exception_nb = {
> > > +	.notifier_call = uprobes_exception_notify,
> > > +	.priority = 0x7ffffff0,
> > > +};
> > > +
> > > +typedef void (*uprobe_handler_t)(struct uprobe*, struct pt_regs*);
> > > +
> > > +/* Guards lookup, creation, and deletion of uproc. */
> > > +static DEFINE_MUTEX(uprobe_mutex);
> > 
> > uproc is per mm, why a global mutex?
> 
> yes, uproc is per mm but gets created when the first probe on that
> process gets registered.
> Do you have anyother lock that you have in mind?
> I could have used the mmap_sem, but I am not sure if we should be taking
> a write lock on the mmap_sem.  

No particular other lock in mind, you could cmpxchg the pointer if
that's all you need it for. The problem is that if you want inode based
probes without a filter this will become a rather hot lock on fork().


> > 
> > > + */
> > > +void uprobe_handle_fork(struct task_struct *child)
> > > +{
> > > +	struct uprobe_process *uproc;
> > > +	struct uprobe_probept *ppt;
> > > +	int ret;
> > > +
> > > +	uproc = current->mm->uproc;
> > > +
> > > +	/*
> > > +	 * New process spawned by parent but not sharing the same mm.
> > > +	 * Remove the probepoints in the child's text.
> > > +	 *
> > > +	 * We also hold the uproc->mutex for the parent - so no
> > > +	 * new uprobes will be registered 'til we return.
> > > +	 */
> > 
> > The grand thing about not having any of this process state is that you
> > dont need to clean it up either..
> 
> If we had done inode based tracing and a process that has breakpoints forks, 
> wont we have to recreate the breakpoint metadata for the child process?
> I dont see the child calling mmap. When and how would be the probepoint
> data, user_bkpt data for the breakpoints, get replicated/linked to the
> child?

What meta-data? You can find the uprobe itself from inode:offset, and
you know the return address from the trap site + orig ins size.

You don't need the probepoint, and there'd be only a single uprobe
instance.

The Xol area can be found at current->mm->xol_area, I don't think you
need more to process a uprobe.

> > > +	if (unlikely(!utask)) {
> > > +		utask = add_utask(uproc);
> > > +
> > > +		/* Failed to allocate utask for the current task. */
> > > +		BUG_ON(!utask);
> > > +		probept = uprobes_get_bkpt_addr(regs);
> > > +		ppt = find_probept(uproc, probept);
> > > +
> > > +		/*
> > > +		 * The probept was refcounted in uprobe_bkpt_notifier;
> > > +		 * Hence it would be mysterious to miss ppt now
> > > +		 */
> > > +		WARN_ON(!ppt);
> > > +		utask->active_ppt = ppt;
> > > +		utask->state = UTASK_BP_HIT;
> > > +	} else
> > > +		ppt = utask->active_ppt;
> > 
> > You can replace this with:
> > 
> >  addr = instruction_pointer(task_pt_regs(current)) -
> > ip_advancement_by_brkpt_insn;
> 
> uprobes_get_bkpt_addr does this exactly. However after we have
> singlestepped, we cant rely on this. Also how do we know if we have
> already singlestepped or not? After singlestepping we may still be
> pointing to some slot or the instruction pointer could be pointing
> something completely different.

if its not the start of a slot, you've already single-stepped. Ideally
you'd directly implement boosted probes, but I realize that's a tad more
work than keeping state.

> > > +	ppt = find_probept(uproc, probept);
> > > +	if (!ppt)
> > > +		return 0;
> > > +	get_probept(ppt);
> > > +	if (utask) {
> > > +		utask->active_ppt = ppt;
> > > +		utask->state = UTASK_BP_HIT;
> > > +	}
> > 
> > Right, so all this should die..
> > 
> > Obtain the address, lookup the vma, get the file, compute the offset
> > inside that file -> {inode,offset}
> > 
> > Do the lookup in the global tree to obtain the uprobe, and possibly
> > execute the probe handler right here in interrupt context, if it fails
> > with -EFAULT, continue with the below:
> 
> We dropped running the handler in interrupt context based on comments to
> my previous postings. It not only makes it complex at the time of
> handling the probe but we didnt see a difference when we compare the
> time it took to run the handler in task context to running the handler
> in interrupt context. I had even posted the timing info when
> register_uprobes was exported. 

Is that because of the singlestep overhead? With boosted probes I would
think it'd be much faster to take 1 trap, deal with it and continue
execution, than to frob tons of kernel code in between.



A bit more about these filter thingies, add a method to struct uprobe,
something like int uprobe::wants_probe(struct task_struct *p) and add a
single bit to task_struct (there's a few bitfields with holes in there).

The on clone()/mmap() call the relevant wants_probe() methods, if one is
true, set the task_struct::has_uprobe flag and install the probes.

If nothing in the process wants probing, you'll never install the probes
and nothing ever triggers, of only one of many tasks in the process gets
tagged, you'll have to look up the probe anyway to know where to
continue, but you can avoid calling the handler.


