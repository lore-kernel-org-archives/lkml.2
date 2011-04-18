Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1DRQN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:13:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab1DRQNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:13:53 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 8/26]  8: uprobes: store/restore
 original instruction.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110401143358.15455.53804.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143358.15455.53804.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 18:12:47 +0200
Message-ID: <1303143167.32491.866.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:03 +0530, Srikar Dronamraju wrote:

> +static int __copy_insn(struct address_space *mapping, char *insn,
> +			unsigned long nbytes, unsigned long offset)
> +{
> +	struct page *page;
> +	void *vaddr;
> +	unsigned long off1;
> +	loff_t idx;
> +
> +	idx = offset >> PAGE_CACHE_SHIFT;
> +	off1 = offset &= ~PAGE_MASK;
> +	page = grab_cache_page(mapping, (unsigned long)idx);

What if the page wasn't present due to being swapped out?

> +	if (!page)
> +		return -ENOMEM;
> +
> +	vaddr = kmap_atomic(page, KM_USER0);
> +	memcpy(insn, vaddr + off1, nbytes);
> +	kunmap_atomic(vaddr, KM_USER0);
> +	unlock_page(page);
> +	page_cache_release(page);
> +	return 0;
> +}
> +
> +static int copy_insn(struct uprobe *uprobe, unsigned long addr)
> +{
> +	struct address_space *mapping;
> +	int bytes;
> +	unsigned long nbytes;
> +
> +	addr &= ~PAGE_MASK;
> +	nbytes = PAGE_SIZE - addr;
> +	mapping = uprobe->inode->i_mapping;
> +
> +	/* Instruction at end of binary; copy only available bytes */
> +	if (uprobe->offset + MAX_UINSN_BYTES > uprobe->inode->i_size)
> +		bytes = uprobe->inode->i_size - uprobe->offset;
> +	else
> +		bytes = MAX_UINSN_BYTES;
> +
> +	/* Instruction at the page-boundary; copy bytes in second page */
> +	if (nbytes < bytes) {
> +		if (__copy_insn(mapping, uprobe->insn + nbytes,
> +				bytes - nbytes, uprobe->offset + nbytes))
> +			return -ENOMEM;
> +		bytes = nbytes;
> +	}
> +	return __copy_insn(mapping, uprobe->insn, bytes, uprobe->offset);
> +}

This all made me think why implement read_opcode() again.. I know its
all slightly different, but still.

> +static struct task_struct *uprobes_get_mm_owner(struct mm_struct *mm)
> +{
> +	struct task_struct *tsk;
> +
> +	rcu_read_lock();
> +	tsk = rcu_dereference(mm->owner);
> +	if (tsk)
> +		get_task_struct(tsk);
> +	rcu_read_unlock();
> +	return tsk;
> +}

Naming is somewhat inconsistent, most of your functions have the _uprobe
postfix and now its a uprobes_ prefix all of a sudden.

>  static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
>  {
> -	int ret = 0;
> +	struct task_struct *tsk = uprobes_get_mm_owner(mm);
> +	int ret;
>  
> -	/*TODO: install breakpoint */
> -	if (!ret)
> +	if (!tsk)	/* task is probably exiting; bail-out */
> +		return -ESRCH;
> +
> +	if (!uprobe->copy) {
> +		ret = copy_insn(uprobe, mm->uprobes_vaddr);
> +		if (ret)
> +			goto put_return;
> +		if (is_bkpt_insn(uprobe->insn)) {
> +			print_insert_fail(tsk, mm->uprobes_vaddr,
> +				"breakpoint instruction already exists");
> +			ret = -EEXIST;
> +			goto put_return;
> +		}
> +		ret = analyze_insn(tsk, uprobe);
> +		if (ret) {
> +			print_insert_fail(tsk, mm->uprobes_vaddr,
> +					"instruction type cannot be probed");
> +			goto put_return;
> +		}

If you want to expose this functionality to !root users printing stuff
to dmesg like that isn't a good idea.

> +		uprobe->copy = 1;
> +	}
> +
> +	ret = set_bkpt(tsk, uprobe, mm->uprobes_vaddr);
> +	if (ret < 0)
> +		print_insert_fail(tsk, mm->uprobes_vaddr,
> +					"failed to insert bkpt instruction");
> +	else
>  		atomic_inc(&mm->uprobes_count);
> +
> +put_return:
> +	put_task_struct(tsk);
>  	return ret;
>  }

