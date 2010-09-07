Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab0IGMZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:25:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44771 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab0IGMZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:25:36 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
 (un)registration and exception handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20100907115117.GJ14891@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
	 <1283377414.2059.1729.camel@laptop>
	 <20100903164219.GB1904@linux.vnet.ibm.com>
	 <1283534349.2050.297.camel@laptop>
	 <20100906174642.GG14891@linux.vnet.ibm.com>
	 <1283796922.1930.736.camel@laptop>
	 <20100907064851.GI14891@linux.vnet.ibm.com>
	 <1283852003.1930.1133.camel@laptop>
	 <20100907115117.GJ14891@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Sep 2010 14:25:07 +0200
Message-ID: <1283862307.1930.1344.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 17:21 +0530, Srikar Dronamraju wrote:
> > > multiple processes example libc), and the user is interested in tracing
> > > just one instance of the process, then dont wont the inode based tracing
> > > amount to far more number of breakpoints hits? 
> > 
> > Not if your filter function works.
> > 
> > So let me try this again, (assumes boosted probes):
> > 
> 
> > struct uprobe {
> > 	struct inode	*inode;	/* we hold a ref */
> > 	unsigned long	offset;
> > 
> > 	int (*handler)(void); /* arguments.. ? */
> > 	int (*filter)(struct task_struct *);
> > 
> > 	int		insn_size;		/* size of */
> > 	char		insn[MAX_INSN_SIZE];	/* the original insn */
> > 
> > 	int		ret_addr_offset;	/* return addr offset
> > 						   in the slot */
> > 	char		replacement[SLOT_SIZE]; /* replacement
> > 						   instructions */
> > 	
> > 	atomic_t	ref; /* lifetime muck */
> > 	struct rcu_head	rcu;
> > };
> 
> 
> struct uprobe is a input structure. Do we want to have
> implementation details in it?

I didn't consider the user-space interface at all, consuming the uprobe
name for that seems silly.

> > static struct uprobe *
> > uprobes_find_get(struct address_space *mapping, unsigned long offset)
> > {
> > 	unsigned long flags;
> > 	struct uprobe *uprobe;
> > 
> > 	raw_spin_lock_irqsave(&uprobes.treelock, flags);
> > 	uprobe = find_in_tree(&uprobes.tree);
> 
> Wouldnt this be a scalability issue on bigger machines?
> Every probehit having to parse a global tree to figureout which
> uprobe it was seems a overkill.
> Consider a 5000 uprobes placed on a 128 box with probes placed on
> heavily used functions.

Use a seqcount, its a read-mostly data structure, its just that the
RB-tree isn't RCU friendly.

> > 	if (!atomic_inc_not_zero(&uprobe->ref))
> > 		uprobe = NULL;
> > 	raw_spin_unlock_irqrestore(&uprobes.treelock, flags);
> > 
> > 	return uprobe;
> > }

> > static void put_uprobe(struct uprobe *uprobe)
> > {
> > 	if (atomic_dec_and_test(&uprobe->ref))
> > 		call_rcu(&uprobe->rcu, __uprobe_free);
> 
> How are we synchronizing put_uprobe and a thread that has hit the
> breakpoint and searching thro global probes list? 

RCU, see the above atomic_inc_not_zero() it will not obtain a reference
after the final put, the object will stay valid until we pass an rcu
quesent state.

> One Nit: On probe hit we increment the ref only few times. However 
> we are decrementing everytime. So if two probes occur on two cpus
> simultaneously, we have a chance of uprobe being freed after both of
> them are handled. (or am I missing something?)

-ENOPARSE.

> > int register_uprobe(struct uprobe *uprobe)
> > {
> > 	struct vm_area_struct *vma;
> > 
> > 	inode_get(uprobe->inode);
> > 	atomic_set(1, &uprobe->ref);
> > 
> > 	uprobes_add(uprobe); /* add before the rmap walk, so that 
> > 				new mmap()s will find it too */
> > 
> > 	for_each_rmap_vma(vma, uprobe->inode->i_mapping) {
> I understand that perf top calls perf record in a loop.

It doesn't, nor do I see the relevance.

> For every perf record, we would be looping thro each vma associated with
> the inode. 
> For a probe on a libc, we would iterate thro all vmas. If the
> tracing was per posix process, this may not be needed.

Feh, probe register should be considered an utter slow path.

We do rmap walks on pages all the time, I can't see it being a problem
here.

> > 		struct mm_struct *mm = vma->vm_mm;
> > 		int install_probe = 0;
> > 
> > 		if (!valid_vma(vma))
> > 			continue;
> > 
> > 		for_each_task_in_process(p, mm->owner) {
> > 			if (uprobe->filter(p)) {
> > 				p->has_uprobe = 1;
> > 				install_probe = 1;
> > 			}
> > 		}
> > 
> > 		if (install_probe) {
> > 			mm->has_uprobes = 1;
> > 			frob_text(uprobe, mm);
> > 		}
> > 	}
> > }


> > void uprobe_fork(struct task_struct *child)
> > {
> > 	struct vm_area_struct *vma;
> > 
> > 	if (!child->mm->has_uprobes)	
> > 		return;
> > 
> > 	for_each_vma(vma, child->mm) {
> > 		struct uprobe *uprobe;
> > 
> > 		if (!valid_vma(vma))
> > 			continue;
> > 
> > 		for_each_probe_in_mapping(uprobe, vma->vm_file->f_mapping) {
> 
> Are you looking at listing of uprobes per vma?
> Does it again traverse the global list?

Yeah, it does a range lookup in the tree [inode:0 - inode:-1). O(log(n))
to find the first entry, O(log(n)) for each consecutive entry, unless we
thread the tree.

Note that read-mostly global data is no problem.

> > 			if (uprobe->filter(child)) {
> > 				child->has_uprobe = 1;
> > 				return;
> > 			}
> > 		}
> > 	}
> > }
> > 
> > void uprobe_mmap(struct vm_area_struct *vma)
> > {
> > 	struct uprobe *uprobe;
> > 
> > 	if (!valid_vma(vma))
> > 		return;
> > 
> > 	for_each_probe_in_mapping(uprobe, vma->vm_file->f_mapping) {
> 
> For each mmap, we are traversing all elements in the global tree?
> What would happen if we have a huge number of uprobes in a system all
> from one user on his app. Wont it slow down mmap for all other users?

Only mmap() of that particular inode, the range lookup would be the
regular O(log(n)) for an empty range.

But again, mmap() is a relative slow path, and you need something like
this anyway if you want to support inode based probes at all.

> > 		int install_probe = 0;
> > 
> > 		for_each_task_in_process(p, vma->vm_mm->owner) {
> > 			if (uprobe->filter(p)) {
> > 				p->has_uprobe = 1;
> > 				install_probe = 1;
> > 			}
> > 		}
> > 
> > 		if (install_probe) {
> > 			mm->has_uprobes = 1;
> > 			frob_text(uprobe, mm);
> > 		}
> > 	}
> > }
> > 
> > void uprobe_hit(struct pt_regs *regs)
> > {
> > 	unsigned long addr = instruction_pointer(regs);
> > 	struct mm_struct *mm = current->mm;
> > 	struct vm_area_struct *vma;
> > 	unsigned long offset;
> > 
> > 	down_read(&mm->mmap_sem);
> 
> uprobe_hit I assume is going to be called in interrupt context.
> I guess down_read can sleep here.

I assumed process context here, but its trivial to make it work from
interrupt context if you want, all we need is a spinlock/seqlock around
the vm_rb mods in __vma_link_rb() and __vma_unlink().

> > 	vma = find_vma(mm, addr);
> > 
> > 	if (!valid_vma)
> > 		goto fail;
> > 
> > 	offset = addr - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);
> 
> Again for every probehit, we are going through the list of vmas and
> checking if it has a probe which I think is unnecessary.

O(log(n)) lookup, hardly a problem.

> Nit: In some archs, the instruction pointer might be pointing to th next
> instruction after a breakpoint hit, we would have to adjust that.

Sure..

> > 	uprobe = uprobes_find_get(vma->vm_file->f_mapping, offset);
> > 	up_read(&mm->mmap_sem);
> > 
> > 	if (!uprobe)
> > 		goto fail;
> > 
> > 	if (current->has_uprobe && uprobe->filter(current))
> > 		uprobe->handle();
> > 
> > 	ret_addr = addr + uprobe->insn_size;
> > 
> > 	cpu = get_cpu()
> > 	slot = get_slot(cpu);
> > 	memcpy(slot, uprobe->replacement, SLOT_SIZE);
> > 	memcpy(slot + uprobe->ret_addr_offset, &ret_addr, sizeof(unsigned
> > long));
> > 	set_instruction_pointer(regs, uaddr_addr_of(slot));
> > 	put_cpu(); /* preemption notifiers would take it from here */
> > 
> 
> What if we were pre-empted after this. Would preemption notifiers also
> do a copy of instruction to the new slot? If yes, can you please
> update me with more pointers.

You'd need to keep a copy of the slot in task state I think.

> And I dont know if we can do a boosting for all instructions.
> I think even on kprobes we dont do a boosting for all instructions.
> Masami, Can you correct me on this?

You can do it with single-step if you want, just keep more task state.

> > 	put_uprobe(uprobe);
> > 	return;
> > 
> > fail:
> > 	SIGTRAP
> > }
> > 
> > See, no extra traps, no funny intermediate data structures to manage,
> > and you get the power of ->filter() to implement whatever policy you
> > want, including simple process wide things.
> 
> Yes, I see its advantages and disadvantages,  I feel this
> implementation wouldnt scale. Just because we dont want to
> housekeep some information, we are looping thro the global tree to
> figure out if there is uprobe specific stuff to be done.

Its mostly read-only data (adding/removing probes is rare), its all
O(log(n)), I really don't see a problem with that.

If you really worry about it you could try a hash lookup for the inode
part and keep a tree per probed inode.

