Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0IATio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:38:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:51102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab0IATim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:38:42 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 2/15]  2: uprobes: Breakpoint
 insertion/removal in user space applications.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100825134141.5447.88627.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134141.5447.88627.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Sep 2010 21:38:12 +0200
Message-ID: <1283369892.2059.1493.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 19:11 +0530, Srikar Dronamraju wrote:

> +struct user_bkpt_arch_info *arch = &user_bkpt_arch_info;

That really wants to be static, 'arch' is a way too generic a name to
inject in the global namespace.

> +unsigned long uprobes_read_vm(struct task_struct *tsk, void __user *vaddr,
> +					void *kbuf, unsigned long nbytes)
> +{
> +	if (tsk == current) {
> +		unsigned long nleft = copy_from_user(kbuf, vaddr, nbytes);
> +		return nbytes - nleft;
> +	} else
> +		return access_process_vm(tsk, (unsigned long) vaddr, kbuf,
> +							nbytes, 0);
> +}
> +

> +unsigned long uprobes_write_data(struct task_struct *tsk,
> +				void __user *vaddr, const void *kbuf,
> +				unsigned long nbytes)
> +{
> +	unsigned long nleft;
> +
> +	if (tsk == current) {
> +		nleft = copy_to_user(vaddr, kbuf, nbytes);
> +		return nbytes - nleft;
> +	} else
> +		return access_process_vm(tsk, (unsigned long) vaddr,
> +						(void *) kbuf, nbytes, 1);
> +}

either: s/uprobes_read_vm/uprobes_read_data/ or
s/uproves_write_data/uproves_write_vm/

> +static int write_opcode(struct task_struct *tsk, unsigned long vaddr,
> +						user_bkpt_opcode_t opcode)
> +{
> +	struct mm_struct *mm;
> +	struct vm_area_struct *vma;
> +	struct page *old_page, *new_page;
> +	void *vaddr_old, *vaddr_new;
> +	pte_t orig_pte;
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
> +	ret = get_user_pages(tsk, mm, vaddr, 1, 1, 1, &old_page, &vma);
> +	if (ret <= 0)
> +		goto mmput_out;
> +
> +	/*
> +	 * check if the page we are interested is read-only mapped
> +	 * Since we are interested in text pages, Our pages of interest
> +	 * should be mapped read-only.
> +	 */
> +	if ((vma->vm_flags && (VM_READ|VM_WRITE)) != VM_READ) {

 s/&&/&/

> +		ret = -EINVAL;
> +		goto put_out;
> +	}
> +
> +	/* If its VM_SHARED vma, lets not write to such vma's.  */
> +	if (vma->vm_flags & VM_SHARED) {
> +		ret = -EINVAL;
> +		goto put_out;
> +	}

Something like:

  /* private, read-only, executable maps only */
  if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) != (VM_READ|VM_EXEC))

maybe?

> +	/* Allocate a page */
> +	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
> +	if (!new_page) {
> +		ret = -ENOMEM;
> +		goto put_out;
> +	}

> +int __weak set_orig_insn(struct task_struct *tsk,
> +			struct user_bkpt *user_bkpt, bool verify)
> +{
> +	if (verify) {
> +		user_bkpt_opcode_t opcode;
> +		int result = read_opcode(tsk, user_bkpt->vaddr, &opcode);
> +		if (result)
> +			return result;
> +		if (opcode != arch->bkpt_insn)

This assumes user_bkpt_opcode_t is a scalar value, but there's no
assertion of that, if someone were to define it like char[5] or somesuch
the comparison would still compile but not do what you'd expect.

> +			return -EINVAL;
> +	}
> +	return write_opcode(tsk, user_bkpt->vaddr, user_bkpt->opcode);
> +}

> +/**
> + * check_vma - verify if the address is in a executable vma.
> + * @tsk: the probed task
> + * @vaddr: virtual address of the instruction to be verified.
> + *
> + * Return 0 if vaddr is in an executable VM area,
> + * or -EINVAL otherwise.
> + */
> +static int check_vma(struct task_struct *tsk, unsigned long vaddr)
> +{
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm;
> +	int ret = -EINVAL;
> +
> +	mm = get_task_mm(tsk);
> +	if (!mm)
> +		return -EINVAL;
> +	down_read(&mm->mmap_sem);
> +	vma = find_vma(mm, vaddr);
> +	if (vma && vaddr >= vma->vm_start && (vma->vm_flags & VM_EXEC))

you fail to check vma->vm_end

Also, do we want to do the full private,ro,exec check here again?

> +		ret = 0;
> +	up_read(&mm->mmap_sem);
> +	mmput(mm);
> +	return ret;
> +}

> +int __weak validate_address(struct task_struct *tsk, unsigned long vaddr)
> +{
> +	return check_vma(tsk, vaddr);
> +}

So here check_vma() is the default implementation of validate_address(),
so why not name them accordingly?

> +/*
> + * __insert_bkpt - insert breakpoint
> + * Insert a breakpoint into the process that includes @tsk, at the
> + * virtual address @user_bkpt->vaddr.
> + *
> + * All threads of the probed process must be stopped while
> + * @__insert_bkpt() runs.

I hope not,.. the pte swizzle we do above does not require any such
thing, stale comment?

> + * Possible errors:
> + * -%ENOSYS: user_bkpt not supported for this architecture
> + * -%EINVAL: invalid instruction address
> + * -%EEXIST: breakpoint instruction already exists at that address
> + * -%EPERM: cannot probe this instruction
> + * -%EFAULT: failed to insert breakpoint instruction
> + */



> +static int pre_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
> +		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
> +{
> +	return pre_xol(tsk, user_bkpt, tskinfo, regs);
> +}
> +

> +static int post_sstep(struct task_struct *tsk, struct user_bkpt *user_bkpt,
> +		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
> +{
> +	return post_xol(tsk, user_bkpt, tskinfo, regs);
> +}

What's the point of these functions?


> +static int __remove_bkpt(struct task_struct *tsk,
> +					struct user_bkpt *user_bkpt)
> +{
> +	if (validate_address(tsk, user_bkpt->vaddr) != 0)
> +		return -EINVAL;
> +	return set_orig_insn(tsk, user_bkpt, true);
> +}

Why would we even consider calling this function on something that would
fail the validate_address() test? If that fails we would not have
installed the breakpoint to begin with, hence there would be no reason
to remove it.

> +bool __weak is_bkpt_insn(struct user_bkpt *user_bkpt)
> +{
> +	return (user_bkpt->opcode == arch->bkpt_insn);
> +}

Again, assumes the instruction thing is a scalar.



The big thing I'm missing in this patch is generic code handling the
actual breakpoint.. but maybe that's somewhere in the next patches.. /me
goes look.


