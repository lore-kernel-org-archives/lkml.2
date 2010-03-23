Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0CWEmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:42:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab0CWEmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:42:51 -0400
Date: Mon, 22 Mar 2010 21:40:09 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v1 4/10] User Space Breakpoint Assistance Layer
Message-Id: <20100322214009.bb90d6e2.akpm@linux-foundation.org>
In-Reply-To: <20100320142541.11427.98291.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
	<20100320142541.11427.98291.sendpatchset@localhost6.localdomain6>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010 19:55:41 +0530 Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> User Space Breakpoint Assistance Layer (USER_BKPT)
> 

A quick scan, just to show I was paying attention ;)

>
> ...
>
> +/*
> + * Read @nbytes at @vaddr from @tsk into @kbuf.  Return number of bytes read.
> + * Not exported, but available for use by arch-specific user_bkpt code.
> + */

You may as well finish off the kerneldoc on some of these functions.

> +int user_bkpt_read_vm(struct task_struct *tsk, unsigned long vaddr,
> +						void *kbuf, int nbytes)
> +{
> +	if (tsk == current) {
> +		int nleft = copy_from_user(kbuf, (void __user *) vaddr,
> +				nbytes);
> +		return nbytes - nleft;
> +	} else
> +		return access_process_vm(tsk, vaddr, kbuf, nbytes, 0);
> +}

copy_from_user() takes and returns an unsigned long arg but this
function is converting these to and from ints.  That's OK if we're 100%
sure that we'll never get or return an arg >2G.  Otherwise things could
get ghastly.  Please have a think.  (Dittoes for some other functionss
around here).

> +
> + * Write @nbytes from @kbuf at @vaddr in @tsk.  Return number of bytes written.
> + * Can be used to write to stack or data VM areas, but not instructions.
> + * Not exported, but available for use by arch-specific user_bkpt code.
> + */
> +int user_bkpt_write_data(struct task_struct *tsk, unsigned long vaddr,
> +					const void *kbuf, int nbytes)
> +{
> +	int nleft;
> +
> +	if (tsk == current) {
> +		nleft = copy_to_user((void __user *) vaddr, kbuf, nbytes);
> +		return nbytes - nleft;
> +	} else
> +		return access_process_vm(tsk, vaddr, (void *) kbuf,
> +							nbytes, 1);
> +}

This looks like it has the wrong interface.  It should take a `void
__user *vaddr'.  If any casting is to be done, it should be done at the
highest level so that sparse can check that the thing is used correctly
in as many places as possible.

> +/*
> + * Given an address, get its pte. Very similar to get_locked_pte except
> + * there is no spinlock involved.
> + */
> +static inline pte_t *get_pte(struct mm_struct *mm, unsigned long vaddr)

The inline is either unneeded or undesirable, I suspect.

> +{
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	pgd = pgd_offset(mm, vaddr);
> +	pud = pud_alloc(mm, pgd, vaddr);
> +	if (!pud)
> +		return NULL;
> +	pmd = pmd_alloc(mm, pud, vaddr);
> +	if (!pmd)
> +		return NULL;
> +	pte = pte_alloc_map(mm, pmd, vaddr);
> +	return pte;
> +}
> +
> +static int write_opcode(struct task_struct *tsk, unsigned long vaddr,
> +						user_bkpt_opcode_t opcode)
> +{
> +	struct mm_struct *mm;
> +	struct vm_area_struct *vma;
> +	struct page *old_page, *new_page;
> +	void *maddr;
> +	pte_t *old_pte;
> +	int offset;
> +	int ret = -EINVAL;
> +
> +	if (!tsk)
> +		return ret;
> +
> +	mm = get_task_mm(tsk);
> +	if (!mm)
> +		return ret;
> +
> +	down_read(&mm->mmap_sem);
> +
> +	/* Read the page with vaddr into memory */
> +	ret = get_user_pages(tsk, mm, vaddr, 1, 0, 1, &old_page, &vma);
> +	if (ret <= 0) {
> +		up_read(&mm->mmap_sem);
> +		goto mmput_out;
> +	}
> +
> +	/* Allocate a page and copy contents over from the old page */
> +	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);

It might be smarter to allocate this page outside the mmap_sem region. 
More scalable, less opportunity for weird deadlocks.

> +	if (!new_page) {
> +		ret = -ENOMEM;
> +		goto unlock_out;
> +	}
> +
> +	/*
> +	 * check if the page we are interested is read-only mapped
> +	 * Since we are interested in text pages, Our pages of interest
> +	 * should be mapped read-only.
> +	 */
> +	if ((vma->vm_flags && (VM_READ|VM_WRITE)) != VM_READ) {
> +		ret = -EINVAL;
> +		goto unlock_out;
> +	}
> +
> +	copy_user_highpage(new_page, old_page, vaddr, vma);
> +	maddr = kmap(new_page);
> +	offset = vaddr & (PAGE_SIZE - 1);
> +	memcpy(maddr + offset, &opcode, user_bkpt_opcode_sz);
> +	kunmap(new_page);

kmap_atomic() is preferred - it's faster.  kmap() is still deadlockable
I guess if a process ever kmaps two pages at the same time.  This code
doesn't do that, but kmap is still a bit sucky.

> +	old_pte = get_pte(mm, vaddr);
> +	if (!old_pte) {
> +		ret = -EINVAL;
> +		goto unlock_out;
> +	}
> +
> +	/*
> +	 * Now replace the page in vma with the new page.
> +	 * This is a text page; so, setup mapping and index.
> +	 */
> +	new_page->mapping = old_page->mapping;
> +	new_page->index = old_page->index;
> +	ret = replace_page(vma, old_page, new_page, *old_pte);
> +
> +unlock_out:
> +	if (ret != 0)
> +		page_cache_release(new_page);
> +	put_page(old_page); /* we did a get_page in the beginning */
> +	up_read(&mm->mmap_sem);
> +mmput_out:
> +	mmput(mm);
> +	return ret;
> +}
> +
>
> ...
>
> +/**
> + * user_bkpt_validate_insn_addr - Validate if the instruction is an
> + * executable vma.

It used to be the case that the above linebreak is "wrong".  (Nobody
ever tests their kerneldoc output!) I have a vague feeling that this
might have been fixed lately.  Randy?

> + * Returns 0 if the vaddr is a valid instruction address.
> + * @tsk: the probed task
> + * @vaddr: virtual address of the instruction to be verified.
> + *
> + * Possible errors:
> + * -%EINVAL: Instruction passed is not a valid instruction address.
> + */
> +int user_bkpt_validate_insn_addr(struct task_struct *tsk, unsigned long vaddr)
> +{
> +	int result;
> +
> +	result = check_vma(tsk, vaddr);
> +	if (result != 0)
> +		return result;
> +	if (arch->validate_address)
> +		result = arch->validate_address(tsk, vaddr);
> +	return result;
> +}
> +
>
> ...
>
> +int user_bkpt_insert_bkpt(struct task_struct *tsk, struct user_bkpt *user_bkpt)
> +{
> +	int result, len;
> +
> +	BUG_ON(!tsk || !user_bkpt);

If this BUG_ON triggers, we won't know which of these pointers was NULL,
which makes us sad.

> +	if (!validate_strategy(user_bkpt->strategy, USER_BKPT_HNT_MASK))
> +		return -EINVAL;
> +
>
> ...
>
> +int user_bkpt_pre_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
> +		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
> +{
> +	int result;
> +
> +	BUG_ON(!tsk || !user_bkpt || !regs);

ditto.

Really, there's never much point in

	BUG_ON(!some_pointer);

Just go ahead and dereference the pointer.  If it's NULL then we'll get
an oops which gives all the information which the BUG_ON would have
given.

> +	if (uses_xol_strategy(user_bkpt->strategy)) {
> +		BUG_ON(!user_bkpt->xol_vaddr);
> +		return arch->pre_xol(tsk, user_bkpt, tskinfo, regs);
> +	}
> +
> +	/*
> +	 * Single-step this instruction inline.  Replace the breakpoint
> +	 * with the original opcode.
> +	 */
> +	result = arch->set_orig_insn(tsk, user_bkpt, false);
> +	if (result == 0)
> +		arch->set_ip(regs, user_bkpt->vaddr);
> +	return result;
> +}
> +
> +/**
> + * user_bkpt_post_sstep - prepare to resume execution after single-step
> + * @tsk: the probed task
> + * @user_bkpt: the probepoint information, as with @user_bkpt_pre_sstep()
> + * @tskinfo: the @user_bkpt_task_arch_info object, if any, passed to
> + *	@user_bkpt_pre_sstep()
> + * @regs: reflects the saved state of @tsk after the single-step
> + *	operation.  @user_bkpt_post_sstep() adjusts @tsk's state as needed,
> + *	including pointing the instruction pointer at the instruction
> + *	following the probed instruction.
> + * Possible errors:
> + * -%EFAULT: Failed to read or write @tsk's address space as needed.
> + */
> +int user_bkpt_post_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
> +		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
> +{
> +	BUG_ON(!tsk || !user_bkpt || !regs);

More dittoes.  It's just bloat.

> +	if (uses_xol_strategy(user_bkpt->strategy))
> +		return arch->post_xol(tsk, user_bkpt, tskinfo, regs);
> +
> +	/*
> +	 * Single-stepped this instruction inline.  Put the breakpoint
> +	 * instruction back.
> +	 */
> +	return arch->set_bkpt(tsk, user_bkpt);
> +}
> +
>
> ...
>

