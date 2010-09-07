Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0IGJeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:34:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab0IGJdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:33:54 -0400
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
In-Reply-To: <20100907064851.GI14891@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
	 <1283377414.2059.1729.camel@laptop>
	 <20100903164219.GB1904@linux.vnet.ibm.com>
	 <1283534349.2050.297.camel@laptop>
	 <20100906174642.GG14891@linux.vnet.ibm.com>
	 <1283796922.1930.736.camel@laptop>
	 <20100907064851.GI14891@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Sep 2010 11:33:23 +0200
Message-ID: <1283852003.1930.1133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 12:18 +0530, Srikar Dronamraju wrote:
> > You're really not getting it, are you? No, it would result in the exact
> > same amount of actual breakpoints hit.
> 
> If there is just one instance of traced process for the inode then yes the
> number of breakpoints when traced with pid or based on inode would be the
> same. However if there are multiple instances of the traced process [example
> bash/zsh] (or the inode corresponds to a library that gets mapped into
> multiple processes example libc), and the user is interested in tracing
> just one instance of the process, then dont wont the inode based tracing
> amount to far more number of breakpoints hits? 

Not if your filter function works.

So let me try this again, (assumes boosted probes):

struct uprobe {
	struct inode	*inode;	/* we hold a ref */
	unsigned long	offset;

	int (*handler)(void); /* arguments.. ? */
	int (*filter)(struct task_struct *);

	int		insn_size;		/* size of */
	char		insn[MAX_INSN_SIZE];	/* the original insn */

	int		ret_addr_offset;	/* return addr offset
						   in the slot */
	char		replacement[SLOT_SIZE]; /* replacement
						   instructions */
	
	atomic_t	ref; /* lifetime muck */
	struct rcu_head	rcu;
};

static struct {
	raw_spinlock_t	tree_lock;
	rb_root		tree;
} uprobes;

static void uprobes_add(struct uprobe *uprobe)
{
	/* add to uprobes.tree, sorted on inode:offset */
}

static void uprobes_del(struct uprobe *uprobe)
{
	/* delete from uprobes.tree */
}

static struct uprobe *
uprobes_find_get(struct address_space *mapping, unsigned long offset)
{
	unsigned long flags;
	struct uprobe *uprobe;

	raw_spin_lock_irqsave(&uprobes.treelock, flags);
	uprobe = find_in_tree(&uprobes.tree);
	if (!atomic_inc_not_zero(&uprobe->ref))
		uprobe = NULL;
	raw_spin_unlock_irqrestore(&uprobes.treelock, flags);

	return uprobe;
}

static void __uprobe_free(struct rcu_head *head)
{
	struct uprobe *uprobe = container_of(head, struct uprobe, rcu);

	kfree(uprobe);
}

static void put_uprobe(struct uprobe *uprobe)
{
	if (atomic_dec_and_test(&uprobe->ref))
		call_rcu(&uprobe->rcu, __uprobe_free);
}

static inline int valid_vma(struct vm_area_struct *vma)
{
	if (!vma->vm_file)
		return 0;

	if (vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED) ==
			    (VM_READ|VM_EXEC))
		return 1;

	return 0;
}

int register_uprobe(struct uprobe *uprobe)
{
	struct vm_area_struct *vma;

	inode_get(uprobe->inode);
	atomic_set(1, &uprobe->ref);

	uprobes_add(uprobe); /* add before the rmap walk, so that 
				new mmap()s will find it too */

	for_each_rmap_vma(vma, uprobe->inode->i_mapping) {
		struct mm_struct *mm = vma->vm_mm;
		int install_probe = 0;

		if (!valid_vma(vma))
			continue;

		for_each_task_in_process(p, mm->owner) {
			if (uprobe->filter(p)) {
				p->has_uprobe = 1;
				install_probe = 1;
			}
		}

		if (install_probe) {
			mm->has_uprobes = 1;
			frob_text(uprobe, mm);
		}
	}
}

void unregister_uprobe(struct uprobe *uprobe)
{
	/* pretty much the same, except restore the original text */
	put_uprobe(uprobe);
}

void uprobe_fork(struct task_struct *child)
{
	struct vm_area_struct *vma;

	if (!child->mm->has_uprobes)	
		return;

	for_each_vma(vma, child->mm) {
		struct uprobe *uprobe;

		if (!valid_vma(vma))
			continue;

		for_each_probe_in_mapping(uprobe, vma->vm_file->f_mapping) {
			if (uprobe->filter(child)) {
				child->has_uprobe = 1;
				return;
			}
		}
	}
}

void uprobe_mmap(struct vm_area_struct *vma)
{
	struct uprobe *uprobe;

	if (!valid_vma(vma))
		return;

	for_each_probe_in_mapping(uprobe, vma->vm_file->f_mapping) {
		int install_probe = 0;

		for_each_task_in_process(p, vma->vm_mm->owner) {
			if (uprobe->filter(p)) {
				p->has_uprobe = 1;
				install_probe = 1;
			}
		}

		if (install_probe) {
			mm->has_uprobes = 1;
			frob_text(uprobe, mm);
		}
	}
}

void uprobe_hit(struct pt_regs *regs)
{
	unsigned long addr = instruction_pointer(regs);
	struct mm_struct *mm = current->mm;
	struct vm_area_struct *vma;
	unsigned long offset;

	down_read(&mm->mmap_sem);
	vma = find_vma(mm, addr);

	if (!valid_vma)
		goto fail;

	offset = addr - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT);

	uprobe = uprobes_find_get(vma->vm_file->f_mapping, offset);
	up_read(&mm->mmap_sem);

	if (!uprobe)
		goto fail;

	if (current->has_uprobe && uprobe->filter(current))
		uprobe->handle();

	ret_addr = addr + uprobe->insn_size;

	cpu = get_cpu()
	slot = get_slot(cpu);
	memcpy(slot, uprobe->replacement, SLOT_SIZE);
	memcpy(slot + uprobe->ret_addr_offset, &ret_addr, sizeof(unsigned
long));
	set_instruction_pointer(regs, uaddr_addr_of(slot));
	put_cpu(); /* preemption notifiers would take it from here */

	put_uprobe(uprobe);
	return;

fail:
	SIGTRAP
}

See, no extra traps, no funny intermediate data structures to manage,
and you get the power of ->filter() to implement whatever policy you
want, including simple process wide things.
