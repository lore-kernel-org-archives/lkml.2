Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0IAUNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:13:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0IAUNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:13:51 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
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
In-Reply-To: <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Sep 2010 22:13:29 +0200
Message-ID: <1283372009.2059.1557.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 19:11 +0530, Srikar Dronamraju wrote:
>  
> +/* Slot allocation for XOL */
> +
> +/*
> + * Every probepoint gets its own slot.  Once it's assigned a slot, it
> + * keeps that slot until the probepoint goes away. Only definite number
> + * of slots are allocated.
> + */
> +
> +struct uprobes_xol_area {
> +	spinlock_t lock;	/* protects bitmap and slot (de)allocation*/
> +	unsigned long *bitmap;	/* 0 = free slot */

Since you have a static sized bitmap, why not simply declare it here?

	DECLARE_BITMAP(bitmap, MAX_UPROBES_XOL_SLOTS;

> +	/*
> +	 * We keep the vma's vm_start rather than a pointer to the vma
> +	 * itself.  The probed process or a naughty kernel module could make
> +	 * the vma go away, and we must handle that reasonably gracefully.
> +	 */

Naughty kernel modules we don't care about, but yeah, it appears vma's
installed using install_special_mapping() can be unmapped by the process
itself,.. curious. 

Anyway, you could install your own vm_ops and provide a close method to
track this.

> +	unsigned long vaddr;		/* Page(s) of instruction slots */
> +};
> +
> +static int xol_add_vma(struct uprobes_xol_area *area)
> +{
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm;
> +	struct file *file;
> +	unsigned long addr;
> +
> +	mm = get_task_mm(current);
> +	if (!mm)
> +		return -ESRCH;
> +
> +	down_write(&mm->mmap_sem);
> +	/*
> +	 * Find the end of the top mapping and skip a page.
> +	 * If there is no space for PAGE_SIZE above
> +	 * that, mmap will ignore our address hint.
> +	 *
> +	 * We allocate a "fake" unlinked shmem file because
> +	 * anonymous memory might not be granted execute
> +	 * permission when the selinux security hooks have
> +	 * their way.
> +	 */
> +	vma = rb_entry(rb_last(&mm->mm_rb), struct vm_area_struct, vm_rb);
> +	addr = vma->vm_end + PAGE_SIZE;
> +	file = shmem_file_setup("uprobes/xol", PAGE_SIZE, VM_NORESERVE);
> +	if (!file) {
> +		printk(KERN_ERR "uprobes_xol failed to setup shmem_file "
> +			"while allocating vma for pid/tgid %d/%d for "
> +			"single-stepping out of line.\n",
> +			current->pid, current->tgid);
> +		goto fail;
> +	}
> +	addr = do_mmap_pgoff(file, addr, PAGE_SIZE, PROT_EXEC, MAP_PRIVATE, 0);
> +	fput(file);
> +
> +	if (addr & ~PAGE_MASK) {
> +		printk(KERN_ERR "uprobes_xol failed to allocate a vma for "
> +				"pid/tgid %d/%d for single-stepping out of "
> +				"line.\n", current->pid, current->tgid);
> +		goto fail;
> +	}
> +	vma = find_vma(mm, addr);
> +
> +	/* Don't expand vma on mremap(). */
> +	vma->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;
> +	area->vaddr = vma->vm_start;

Seems interesting,.. why not use install_special_mapping(), that's what
the VDSO uses.

> +	up_write(&mm->mmap_sem);
> +	mmput(mm);
> +	return 0;
> +
> +fail:
> +	up_write(&mm->mmap_sem);
> +	mmput(mm);
> +	return -ENOMEM;
> +}
> +
> +/*
> + * xol_alloc_area - Allocate process's uprobes_xol_area.
> + * This area will be used for storing instructions for execution out of
> + * line.

It doesn't actually do that, xol_add_vma() does that, this allocates the
storage management bits.

> + * Called with mm->uproc->mutex locked.

There's a nice way to not have to write that:

  lockdep_assert_held(&mm->uproc->mutex);

> + * Returns the allocated area or NULL.
> + */


> +/*
> + * xol_free_area - Free the area allocated for slots.

Again, it doesn't actually free the slots itself.

> + * @xol_area refers the unique per process uprobes_xol_area for
> + * this process.
> + *
> + */


> +/*
> + * Find a slot
> + *  - searching in existing vmas for a free slot.
> + *  - If no free slot in existing vmas, return 0;

I would call that allocate, find would imply a constant operation, but
you actually change the state.

> + * Called when holding xol_area->lock

  lockdep_assert_held(&area->lock);

> + */
> +static unsigned long xol_take_insn_slot(struct uprobes_xol_area *area)
> +{
> +	unsigned long slot_addr;
> +	int slot_nr;
> +
> +	slot_nr = find_first_zero_bit(area->bitmap, UINSNS_PER_PAGE);
> +	if (slot_nr < UINSNS_PER_PAGE) {
> +		set_bit(slot_nr, area->bitmap);

Since its all serialized by xol_area->lock, why use an atomic bitop?

> +		slot_addr = area->vaddr +
> +				(slot_nr * UPROBES_XOL_SLOT_BYTES);
> +		return slot_addr;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * xol_get_insn_slot - If user_bkpt  was not allocated a slot, then
> + * allocate a slot. If uprobes_insert_bkpt is already called, (i.e
> + * user_bkpt.vaddr != 0) then copy the instruction into the slot.
> + * @user_bkpt: probepoint information
> + * @xol_area refers the unique per process uprobes_xol_area for
> + * this process.
> + *
> + * Called with mm->uproc->mutex locked.
> + * Returns the allocated slot address or 0.
> + */
> +static unsigned long xol_get_insn_slot(struct user_bkpt *user_bkpt,
> +				struct uprobes_xol_area *xol_area)
> +{
> +	unsigned long flags, xol_vaddr = 0;
> +	int len;
> +
> +	if (unlikely(!xol_area))
> +		return 0;
> +
> +	if (user_bkpt->xol_vaddr)
> +		return user_bkpt->xol_vaddr;
> +
> +	spin_lock_irqsave(&xol_area->lock, flags);
> +	xol_vaddr = xol_take_insn_slot(xol_area);
> +	spin_unlock_irqrestore(&xol_area->lock, flags);
> +
> +	/*
> +	 * Initialize the slot if user_bkpt->vaddr points to valid
> +	 * instruction slot.
> +	 */
> +	if (likely(xol_vaddr) && user_bkpt->vaddr) {

if (!xol_vaddr)
  goto bail;

gives nices code, and saves an indent level.

Also, why would we ever get here with !user_bkpt->vaddr.

(fwiw, my fingers hate bkpt, they either want to type bp, or brkpt)

> +		len = access_process_vm(current, xol_vaddr, user_bkpt->insn,
> +						UPROBES_XOL_SLOT_BYTES, 1);
> +		if (unlikely(len < UPROBES_XOL_SLOT_BYTES))
> +			printk(KERN_ERR "Failed to copy instruction at %#lx "
> +					"len = %d\n", user_bkpt->vaddr, len);
> +	}
> +
> +	/*
> +	 * Update user_bkpt->xol_vaddr after giving a chance for the slot to
> +	 * be initialized.
> +	 */
> +	mb();

Where is the matching barrier?

> +	user_bkpt->xol_vaddr = xol_vaddr;
> +	return user_bkpt->xol_vaddr;
> +}
> +
> +/*
> + * xol_free_insn_slot - If slot was earlier allocated by
> + * @xol_get_insn_slot(), make the slot available for
> + * subsequent requests.
> + * @slot_addr: slot address as returned by
> + * @xol_get_insn_area().
> + * @xol_area refers the unique per process uprobes_xol_area for
> + * this process.
> + */
> +static void xol_free_insn_slot(unsigned long slot_addr,
> +				struct uprobes_xol_area *xol_area)
> +{
> +	unsigned long vma_end;
> +	int found = 0;
> +
> +	if (unlikely(!slot_addr || IS_ERR_VALUE(slot_addr)))
> +		return;
> +
> +	if (unlikely(!xol_area))
> +		return;
> +
> +	vma_end = xol_area->vaddr + PAGE_SIZE;
> +	if (xol_area->vaddr <= slot_addr && slot_addr < vma_end) {
> +		int slot_nr;
> +		unsigned long offset = slot_addr - xol_area->vaddr;
> +		unsigned long flags;
> +
> +		BUG_ON(offset % UPROBES_XOL_SLOT_BYTES);
> +
> +		slot_nr = offset / UPROBES_XOL_SLOT_BYTES;
> +		BUG_ON(slot_nr >= UINSNS_PER_PAGE);
> +
> +		spin_lock_irqsave(&xol_area->lock, flags);
> +		clear_bit(slot_nr, xol_area->bitmap);

Again, using atomic bitops while already holding a lock... pick one.

> +		spin_unlock_irqrestore(&xol_area->lock, flags);
> +		found = 1;
> +	}
> +
> +	if (!found)
> +		printk(KERN_ERR "%s: no XOL vma for slot address %#lx\n",
> +						__func__, slot_addr);

funny code flow,.. s/found = 1/return/ and loose the conditional and
indent?

> +}
> +
> +/*
> + * xol_validate_vaddr - Verify if the specified address is in an
> + * executable vma, but not in an XOL vma.
> + *	- Return 0 if the specified virtual address is in an
> + *	  executable vma, but not in an XOL vma.
> + *	- Return 1 if the specified virtual address is in an
> + *	  XOL vma.
> + *	- Return -EINTR otherwise.(i.e non executable vma, or
> + *	  not a valid address
> + * @pid: the probed process
> + * @vaddr: virtual address of the instruction to be validated.
> + * @xol_area refers the unique per process uprobes_xol_area for
> + * this process.
> + */
> +static int xol_validate_vaddr(struct pid *pid, unsigned long vaddr,
> +				struct uprobes_xol_area *xol_area)
> +{
> +	struct task_struct *tsk;
> +	unsigned long vma_end;
> +	int result;
> +
> +	if (unlikely(!xol_area))
> +		return 0;
> +
> +	tsk = get_pid_task(pid, PIDTYPE_PID);
> +	if (unlikely(!tsk))
> +		return -EINVAL;
> +
> +	result = validate_address(tsk, vaddr);
> +	if (result != 0)
> +		goto validate_end;
> +
> +	vma_end = xol_area->vaddr + PAGE_SIZE;
> +	if (xol_area->vaddr <= vaddr && vaddr < vma_end)
> +		result = 1;
> +
> +validate_end:
> +	put_task_struct(tsk);
> +	return result;
> +}

This doesn't actually appear used in this patch,.. does it want to live
elsewhere?
