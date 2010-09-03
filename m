Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265Ab0ICQk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:40:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56954 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab0ICQkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:40:22 -0400
Date: Fri, 3 Sep 2010 22:10:10 +0530
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
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
Message-ID: <20100903164010.GA1904@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
 <1283372009.2059.1557.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1283372009.2059.1557.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +struct uprobes_xol_area {
> > +	spinlock_t lock;	/* protects bitmap and slot (de)allocation*/
> > +	unsigned long *bitmap;	/* 0 = free slot */
> 
> Since you have a static sized bitmap, why not simply declare it here?
> 
> 	DECLARE_BITMAP(bitmap, MAX_UPROBES_XOL_SLOTS;

Okay,  will do.

> 
> > +	/*
> > +	 * We keep the vma's vm_start rather than a pointer to the vma
> > +	 * itself.  The probed process or a naughty kernel module could make
> > +	 * the vma go away, and we must handle that reasonably gracefully.
> > +	 */
> 
> Naughty kernel modules we don't care about, but yeah, it appears vma's
> installed using install_special_mapping() can be unmapped by the process
> itself,.. curious. 

Will clean this up.
> 
> Anyway, you could install your own vm_ops and provide a close method to
> track this.
> 
> > +	unsigned long vaddr;		/* Page(s) of instruction slots */
> > +};
> > +

<snipped>

> > +	vma = find_vma(mm, addr);
> > +
> > +	/* Don't expand vma on mremap(). */
> > +	vma->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;
> > +	area->vaddr = vma->vm_start;
> 
> Seems interesting,.. why not use install_special_mapping(), that's what
> the VDSO uses.

Okay, I hadnt looked at install_special_mapping earlier so I will take a
look and incorporate it. However I am not clear at this point what
install_special_mapping is giving us here.  Also install_special_mapping
is already defining its own vm_ops esp a close method thats doesnt seem
to be doing anything. So at this point I am not clear how we are link
the vm_ops, the close method and install_special_mapping.

> 
> > +/*
> > + * xol_alloc_area - Allocate process's uprobes_xol_area.
> > + * This area will be used for storing instructions for execution out of
> > + * line.
> 
> It doesn't actually do that, xol_add_vma() does that, this allocates the
> storage management bits.

Okay, will clean up. 

> 
> > + * Called with mm->uproc->mutex locked.
> 
> There's a nice way to not have to write that:
> 
>   lockdep_assert_held(&mm->uproc->mutex);

Okay, will do.

> 
> I would call that allocate, find would imply a constant operation, but
> you actually change the state.
> 

Okay, 

> > + * Called when holding xol_area->lock
> 
>   lockdep_assert_held(&area->lock);
> 
> > + */
> > +static unsigned long xol_take_insn_slot(struct uprobes_xol_area *area)
> > +{
> > +	unsigned long slot_addr;
> > +	int slot_nr;
> > +
> > +	slot_nr = find_first_zero_bit(area->bitmap, UINSNS_PER_PAGE);
> > +	if (slot_nr < UINSNS_PER_PAGE) {
> > +		set_bit(slot_nr, area->bitmap);
> 
> Since its all serialized by xol_area->lock, why use an atomic bitop?

Okay will use the non-atomic set_bit.

> 
> > +		slot_addr = area->vaddr +
> > +				(slot_nr * UPROBES_XOL_SLOT_BYTES);
> > +		return slot_addr;
> > +	}
> > +
> > +	return 0;
> > +}
> > +

<snipped>

> > +	/*
> > +	 * Initialize the slot if user_bkpt->vaddr points to valid
> > +	 * instruction slot.
> > +	 */
> > +	if (likely(xol_vaddr) && user_bkpt->vaddr) {
> 
> if (!xol_vaddr)
>   goto bail;
> 
> gives nices code, and saves an indent level.
> 
> Also, why would we ever get here with !user_bkpt->vaddr.

For now, user_bkpt->vaddr will always be set when we are here. 
However when we add uretprobe support, we would then get here with
user_bkpt->vaddr being NULL. 

I would drop the check for now, but add it later when we add the return
probe support.

> 
> (fwiw, my fingers hate bkpt, they either want to type bp, or brkpt)
> 

I had renamed the structure from ubp to user_bkpt based on your
comments. I had actually mentioned this in the summary mail that I had
sent on Jan 22 this year. I am fine to rename it to user_bp if that
helps but if you feel ubp is better, I can revert to ubp too.


> > +		len = access_process_vm(current, xol_vaddr, user_bkpt->insn,
> > +						UPROBES_XOL_SLOT_BYTES, 1);
> > +		if (unlikely(len < UPROBES_XOL_SLOT_BYTES))
> > +			printk(KERN_ERR "Failed to copy instruction at %#lx "
> > +					"len = %d\n", user_bkpt->vaddr, len);
> > +	}
> > +
> > +	/*
> > +	 * Update user_bkpt->xol_vaddr after giving a chance for the slot to
> > +	 * be initialized.
> > +	 */
> > +	mb();
> 
> Where is the matching barrier?

I dont want the compiler to reorder the instructions and do the
assignment for user_bkpt to be done before we complete the copy above.

If the assignment happens before we copy the content into the slot,
someother thread that might hit the same probe actually things the slot
is ready and tries to jump to that slot even before the slot is
initialized.

Please let me know if I could have done it differently.

> 
> > +	user_bkpt->xol_vaddr = xol_vaddr;
> > +	return user_bkpt->xol_vaddr;
> > +}
> > +
<snipped>

> 
> > +		spin_unlock_irqrestore(&xol_area->lock, flags);
> > +		found = 1;
> > +	}
> > +
> > +	if (!found)
> > +		printk(KERN_ERR "%s: no XOL vma for slot address %#lx\n",
> > +						__func__, slot_addr);
> 
> funny code flow,.. s/found = 1/return/ and loose the conditional and
> indent?

Okay, will do.

> 
> > +static int xol_validate_vaddr(struct pid *pid, unsigned long vaddr,
> > +				struct uprobes_xol_area *xol_area)
> > +{
> > +	struct task_struct *tsk;
> > +	unsigned long vma_end;
> > +	int result;
> > +
> > +	if (unlikely(!xol_area))
> > +		return 0;
> > +
> > +	tsk = get_pid_task(pid, PIDTYPE_PID);
> > +	if (unlikely(!tsk))
> > +		return -EINVAL;
> > +
> > +	result = validate_address(tsk, vaddr);
> > +	if (result != 0)
> > +		goto validate_end;
> > +
> > +	vma_end = xol_area->vaddr + PAGE_SIZE;
> > +	if (xol_area->vaddr <= vaddr && vaddr < vma_end)
> > +		result = 1;
> > +
> > +validate_end:
> > +	put_task_struct(tsk);
> > +	return result;
> > +}
> 
> This doesn't actually appear used in this patch,.. does it want to live
> elsewhere?

Yes, xol_validate_vaddr gets used in the next patch.  So probably it can
be moved to the next patch.

--
Thanks and Regards
Srikar
