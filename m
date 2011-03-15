Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab1CORVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 13:21:49 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56055 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750Ab1CORVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 13:21:47 -0400
Date: Tue, 15 Mar 2011 22:45:36 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 5/20] 5: Uprobes: register/unregister
 probes.
Message-ID: <20110315171536.GA24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133454.27435.81020.sendpatchset@localhost6.localdomain6>
 <alpine.LFD.2.00.1103151439400.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103151439400.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2011-03-15 15:28:04]:

> On Mon, 14 Mar 2011, Srikar Dronamraju wrote:
> > +/* Returns 0 if it can install one probe */
> > +int register_uprobe(struct inode *inode, loff_t offset,
> > +				struct uprobe_consumer *consumer)
> > +{
> > +	struct prio_tree_iter iter;
> > +	struct list_head tmp_list;
> > +	struct address_space *mapping;
> > +	struct mm_struct *mm, *tmpmm;
> > +	struct vm_area_struct *vma;
> > +	struct uprobe *uprobe;
> > +	int ret = -1;
> > +
> > +	if (!inode || !consumer || consumer->next)
> > +		return -EINVAL;
> > +	uprobe = uprobes_add(inode, offset);
> 
> Does uprobes_add() always succeed ?
> 

Steve already gave this comment. Adding a check to catch if
uprobe_add returns NULL and return immediately.

> > +	INIT_LIST_HEAD(&tmp_list);
> > +	mapping = inode->i_mapping;
> > +
> > +	mutex_lock(&uprobes_mutex);
> > +	if (uprobe->consumers) {
> > +		ret = 0;
> > +		goto consumers_add;
> > +	}
> > +
> > +	spin_lock(&mapping->i_mmap_lock);
> > +	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, 0) {
> > +		loff_t vaddr;
> > +
> > +		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
> > +			continue;
> > +
> > +		mm = vma->vm_mm;
> > +		if (!valid_vma(vma)) {
> > +			mmput(mm);
> > +			continue;
> > +		}
> > +
> > +		vaddr = vma->vm_start + offset;
> > +		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> > +		if (vaddr > ULONG_MAX) {
> > +			/*
> > +			 * We cannot have a virtual address that is
> > +			 * greater than ULONG_MAX
> > +			 */
> > +			mmput(mm);
> > +			continue;
> > +		}
> > +		mm->uprobes_vaddr = (unsigned long) vaddr;
> > +		list_add(&mm->uprobes_list, &tmp_list);
> > +	}
> > +	spin_unlock(&mapping->i_mmap_lock);
> > +
> > +	if (list_empty(&tmp_list)) {
> > +		ret = 0;
> > +		goto consumers_add;
> > +	}
> > +	list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
> > +		down_read(&mm->mmap_sem);
> > +		if (!install_uprobe(mm, uprobe))
> > +			ret = 0;
> 
> Installing it once is success ?

This is a little tricky. My intention was to return success even if one
install is successful. If we return error, then the caller can go
ahead and free the consumer. Since we return success if there are
currently no processes that have mapped this inode, I was tempted to
return success on atleast one successful install.

> 
> > +		list_del(&mm->uprobes_list);
> 
> Also the locking rules for mm->uprobes_list want to be
> documented. They are completely non obvious.
> 
> > +		up_read(&mm->mmap_sem);
> > +		mmput(mm);
> > +	}
> > +
> > +consumers_add:
> > +	add_consumer(uprobe, consumer);
> > +	mutex_unlock(&uprobes_mutex);
> > +	put_uprobe(uprobe);
> 
> Why do we drop the refcount here?

The first time uprobe_add gets called for a unique inode:offset
pair, it sets the refcount to 2 (One for the uprobe creation and the
other for register activity). From next time onwards it
increments the refcount by  (for register activity) 1.
The refcount dropped here corresponds to the register activity.

Similarly unregister takes a refcount thro find_uprobe and drops it thro
del_consumer().  However it drops the creation refcount if and if
there are no more consumers.

I thought of just taking the refcount just for the first register and
decrement for the last unregister. However register/unregister can race
with each other causing the refcount to be zero and free the uprobe
structure even though we were still registering the probe.

> 
> > +	return ret;
> > +}
> 
> > +	/*
> > +	 * There could be other threads that could be spinning on
> > +	 * treelock; some of these threads could be interested in this
> > +	 * uprobe.  Give these threads a chance to run.
> > +	 */
> > +	synchronize_sched();
> 
> This makes no sense at all. We are not holding treelock, we are about
> to acquire it. Also what does it matter when they spin on treelock and
> are interested in this uprobe. Either they find it before we remove it
> or not. So why synchronize_sched()? I find the lifetime rules of
> uprobe utterly confusing. Could you explain please ?

There could be threads that have hit the breakpoint and are
entering the notifier code(interrupt context) and then
do_notify_resume(task context) and trying to acquire the treelock.
(treelock is held by the breakpoint hit threads in
uprobe_notify_resume which gets called in do_notify_resume()) The
current thread that is removing the uprobe from the rb_tree can race
with these threads and might acquire the treelock before some of the
breakpoint hit threads. If this happens the interrupted threads have
to re-read the opcode to see if the breakpoint location no more has the
breakpoint instruction and retry the instruction. However before it can
detect and retry, some other thread might insert a breakpoint at that
location. This can go in a loop.

The other option would be for the interrupted threads to turn that into
a signal. However I am not sure if this is a good option at all esp
since we already have the breakpoint removed.

To avoid this, I am planning to give some __extra__ time for the
breakpoint hit threads to compete and win the race for spinlock with
the unregistering thread.


-- 
Thanks and Regards
Srikar

> 
> > +	spin_lock_irqsave(&treelock, flags);
> > +	rb_erase(&uprobe->rb_node, &uprobes_tree);
> > +	spin_unlock_irqrestore(&treelock, flags);
> > +	iput(uprobe->inode);
> > +
