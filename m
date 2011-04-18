Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1DRQq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:46:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35515 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1DRQqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:46:51 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 12/26] 12: uprobes: slot allocation
 for uprobes
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110401143457.15455.64839.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143457.15455.64839.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 18:46:11 +0200
Message-ID: <1303145171.32491.886.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:04 +0530, Srikar Dronamraju wrote:
> Every task is allocated a fixed slot. When a probe is hit, the original
> instruction corresponding to the probe hit is copied to per-task fixed
> slot. Currently we allocate one page of slots for each mm. Bitmaps are
> used to know which slots are free. Each slot is made of 128 bytes so
> that its cache aligned.
> 
> TODO: On massively threaded processes (or if a huge number of processes
> share the same mm), there is a possiblilty of running out of slots.
> One alternative could be to extend the slots as when slots are required.

As long as you're single stepping things and not using boosted probes
you can fully serialize the slot usage. Claim a slot on trap and release
the slot on finish. Claiming can wait on a free slot since you already
have the whole SLEEPY thing.


> +static int xol_add_vma(struct uprobes_xol_area *area)
> +{
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm;
> +	struct file *file;
> +	unsigned long addr;
> +	int ret = -ENOMEM;
> +
> +	mm = get_task_mm(current);
> +	if (!mm)
> +		return -ESRCH;
> +
> +	down_write(&mm->mmap_sem);
> +	if (mm->uprobes_xol_area) {
> +		ret = -EALREADY;
> +		goto fail;
> +	}
> +
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

That just annoys me, so we're working around some stupid sekurity crap,
executable anonymous maps are perfectly fine, also what do JITs do?

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
> +	if (get_user_pages(current, mm, area->vaddr, 1, 1, 1, &area->page,
> +				&vma) > 0)
> +		ret = 0;
> +
> +fail:
> +	up_write(&mm->mmap_sem);
> +	mmput(mm);
> +	return ret;
> +}
