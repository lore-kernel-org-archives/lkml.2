Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab0FUN74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:59:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50844 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab0FUN7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:59:54 -0400
X-Authority-Analysis: v=1.1 cv=zLGBfXKW/yOQN1c4qTdQUWouaSiWOaUUjRgOJi1LSJI= c=1 sm=0 a=cXXvhkFfZJUA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VnNF1IyMAAAA:8 a=B_E2vzxBioxsKBfJk1wA:9 a=UKoqsbybJ-4HOR-nmroA:7 a=8OLh5qugkvEgwdVIA5q8i9I82csA:4 a=PUjeQqilurYA:10 a=6NJHm5-mpRoDR-50:21 a=g16NiHSiHbtTzPVt:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v5 3/14] User Space Breakpoint Assistance Layer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100614082832.29068.53628.sendpatchset@localhost6.localdomain6>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
	 <20100614082832.29068.53628.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Jun 2010 09:59:47 -0400
Message-ID: <1277128787.9181.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 13:58 +0530, Srikar Dronamraju wrote:
> user_bkpt_core.patch
> 
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 

> +/**
> + * user_bkpt_write_data - Write @nbytes from @kbuf at @vaddr in @tsk.
> + * Can be used to write to stack or data VM areas, but not instructions.
> + * Not exported, but available for use by arch-specific user_bkpt code.
> + * @tsk: The probed task
> + * @vaddr: Destination address, in user space.
> + * @kbuf: Source address, in kernel space to be read.

I'm curious. Anything prevent this from being called on instructions, or
is this just "Don't do that?". 

> + *
> + * Context: This function may sleep.
> + *
> + * Return number of bytes written.
> + */
> +unsigned long user_bkpt_write_data(struct task_struct *tsk,
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
> +
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
> +		ret = -EINVAL;
> +		goto put_out;
> +	}
> +
> +	/* If its VM_SHARED vma, lets not write to such vma's.  */
> +	if (vma->vm_flags & VM_SHARED) {
> +		ret = -EINVAL;
> +		goto put_out;
> +	}
> +
> +	/* Allocate a page */
> +	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
> +	if (!new_page) {
> +		ret = -ENOMEM;
> +		goto put_out;
> +	}
> +
> +	/*
> +	 * lock page will serialize against do_wp_page()'s
> +	 * PageAnon() handling
> +	 */
> +	lock_page(old_page);
> +	/* mark page RO so any concurrent access will end up in do_wp_page() */
> +	if (write_protect_page(vma, old_page, &orig_pte))
> +		goto unlock_out;
> +
> +	/* copy the page now that we've got it stable */
> +	vaddr_old = kmap_atomic(old_page, KM_USER0);
> +	vaddr_new = kmap_atomic(new_page, KM_USER1);
> +
> +	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
> +	/* poke the new insn in, ASSUMES we don't cross page boundary */
> +	vaddr = vaddr & (PAGE_SIZE - 1);

This should probably be vaddr = vaddr & ~PAGE_MASK;


-- Steve

> +	memcpy(vaddr_new + vaddr, &opcode, user_bkpt_opcode_sz);
> +
> +	kunmap_atomic(vaddr_new, KM_USER1);
> +	kunmap_atomic(vaddr_old, KM_USER0);
> +
> +	lock_page(new_page);
> +	/* flip pages, do_wp_page() will fail pte_same() and bail */
> +	ret = replace_page(vma, old_page, new_page, orig_pte);
> +
> +unlock_out:
> +	unlock_page(new_page);
> +	unlock_page(old_page);
> +	if (ret != 0)
> +		page_cache_release(new_page);
> +
> +put_out:
> +	put_page(old_page); /* we did a get_page in the beginning */
> +
> +mmput_out:
> +	up_read(&mm->mmap_sem);
> +	mmput(mm);
> +	return ret;
> +}
> +

