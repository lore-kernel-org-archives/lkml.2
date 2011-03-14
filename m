Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1CNQ6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:58:53 -0400
Received: from mout.perfora.net ([74.208.4.195]:59532 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab1CNQ6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:58:52 -0400
Date: Mon, 14 Mar 2011 12:58:18 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 3/20]  3: uprobes: Breakground page
	replacement.
Message-ID: <20110314165818.GA18507@fibrous.localdomain>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314133433.27435.49566.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314133433.27435.49566.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:7opqTtGS+C7b4BQlxh5dxyEEHiNxRj1LHJ0Fo+7UTEg
 hf1rz0Fnv4uNaaARRqV9U/6lczbBljxZx/lAg8H8VlIMOmX2AH
 PKQUBSmemXsctuIDKwomLbOac4jJEJ3q4NEMw770m6XkPAf2gV
 UHrRDsdYe007vpziNyhTZ10maSvnLp/mznIe20DHJFaoI5KIla
 uu9Xf30HdYPqHNhF3W4LNd4IE8Sg7cXxYRGDs99FEo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 07:04:33PM +0530, Srikar Dronamraju wrote:
> +/**
> + * read_opcode - read the opcode at a given virtual address.
> + * @tsk: the probed task.
> + * @vaddr: the virtual address to store the opcode.
> + * @opcode: location to store the read opcode.
> + *
> + * For task @tsk, read the opcode at @vaddr and store it in @opcode.
> + * Return 0 (success) or a negative errno.
> + */
> +int __weak read_opcode(struct task_struct *tsk, unsigned long vaddr,
> +						uprobe_opcode_t *opcode)
> +{
> +	struct vm_area_struct *vma;
> +	struct page *page;
> +	void *vaddr_new;
> +	int ret;
> +
> +	ret = get_user_pages(tsk, tsk->mm, vaddr, 1, 0, 0, &page, &vma);
> +	if (ret <= 0)
> +		return -EFAULT;
> +	ret = -EFAULT;
> +
> +	/*
> +	 * check if the page we are interested is read-only mapped
> +	 * Since we are interested in text pages, Our pages of interest
> +	 * should be mapped read-only.
> +	 */
> +	if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) ==
> +						(VM_READ|VM_EXEC))
> +		goto put_out;
> +
> +	lock_page(page);
> +	vaddr_new = kmap_atomic(page, KM_USER0);
> +	vaddr &= ~PAGE_MASK;
> +	memcpy(&opcode, vaddr_new + vaddr, uprobe_opcode_sz);
> +	kunmap_atomic(vaddr_new, KM_USER0);
> +	unlock_page(page);
> +	ret =  uprobe_opcode_sz;

This looks wrong.  We should be setting ret = 0 on success here?

> +
> +put_out:
> +	put_page(page); /* we did a get_page in the beginning */
> +	return ret;
> +}

-- 
steve

