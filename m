Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab1IZNQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 09:16:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:38910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1IZNQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 09:16:00 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 3/26]   Uprobes: register/unregister
 probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 26 Sep 2011 15:15:00 +0200
In-Reply-To: <20110920120022.25326.35868.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
	 <20110920120022.25326.35868.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317042900.1763.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 17:30 +0530, Srikar Dronamraju wrote:

> +static struct vma_info *__find_next_vma_info(struct list_head *head,
> +			loff_t offset, struct address_space *mapping,
> +			struct vma_info *vi)
> +{
> +	struct prio_tree_iter iter;
> +	struct vm_area_struct *vma;
> +	struct vma_info *tmpvi;
> +	loff_t vaddr;
> +	unsigned long pgoff = offset >> PAGE_SHIFT;
> +	int existing_vma;
> +
> +	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> +		if (!vma || !valid_vma(vma))
> +			return NULL;
> +
> +		existing_vma = 0;
> +		vaddr = vma->vm_start + offset;
> +		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> +		list_for_each_entry(tmpvi, head, probe_list) {
> +			if (tmpvi->mm == vma->vm_mm && tmpvi->vaddr == vaddr) {
> +				existing_vma = 1;
> +				break;
> +			}
> +		}
> +		if (!existing_vma &&
> +				atomic_inc_not_zero(&vma->vm_mm->mm_users)) {
> +			vi->mm = vma->vm_mm;
> +			vi->vaddr = vaddr;
> +			list_add(&vi->probe_list, head);
> +			return vi;

The the sole purpose of actually having that list is the above linear
was to test if we've already had this one?

Does that really matter? After all, if the probe is already installed
installing it again will return with -EEXIST, which should be easy
enough to deal with.

> +		}
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * Iterate in the rmap prio tree  and find a vma where a probe has not
> + * yet been inserted.
> + */
> +static struct vma_info *find_next_vma_info(struct list_head *head,
> +			loff_t offset, struct address_space *mapping)
> +{
> +	struct vma_info *vi, *retvi;
> +	vi = kzalloc(sizeof(struct vma_info), GFP_KERNEL);
> +	if (!vi)
> +		return ERR_PTR(-ENOMEM);
> +
> +	INIT_LIST_HEAD(&vi->probe_list);

weird place for the INIT_LIST_HEAD, I would have expected it near where
the rest of vi is initialized, although it looks to be superfluous
anyway, since list_add() can handle an uninitialized entry.


> +	mutex_lock(&mapping->i_mmap_mutex);
> +	retvi = __find_next_vma_info(head, offset, mapping, vi);
> +	mutex_unlock(&mapping->i_mmap_mutex);
> +
> +	if (!retvi)
> +		kfree(vi);
> +	return retvi;
> +}
> +
> +static int __register_uprobe(struct inode *inode, loff_t offset,
> +				struct uprobe *uprobe)
> +{
> +	struct list_head try_list;
> +	struct vm_area_struct *vma;
> +	struct address_space *mapping;
> +	struct vma_info *vi, *tmpvi;
> +	struct mm_struct *mm;
> +	int ret = 0;
> +
> +	mapping = inode->i_mapping;
> +	INIT_LIST_HEAD(&try_list);
> +	while ((vi = find_next_vma_info(&try_list, offset,
> +							mapping)) != NULL) {
> +		if (IS_ERR(vi)) {
> +			ret = -ENOMEM;
> +			break;
> +		}

Here we hold neither i_mmap_mutex nor mmap_sem, so everything can change
under our feet. See below..

> +		mm = vi->mm;
> +		down_read(&mm->mmap_sem);
> +		vma = find_vma(mm, (unsigned long) vi->vaddr);
> +		if (!vma || !valid_vma(vma)) {

No validation if its indeed the same vma you found earlier? At the very
least we should validate the vma returned from find_vma() is indeed a
mapping of the inode we're after and that the offset is still to be
found at vaddr.

> +			list_del(&vi->probe_list);
> +			kfree(vi);
> +			up_read(&mm->mmap_sem);
> +			mmput(mm);
> +			continue;
> +		}
> +		ret = install_breakpoint(mm);
> +		if (ret && (ret != -ESRCH || ret != -EEXIST)) {
> +			up_read(&mm->mmap_sem);
> +			mmput(mm);
> +			break;
> +		}

Right, so you already deal with -EEXIST, so why do we need that list at
all then?

Aah, its to make fwd progress, without it we would keep retrying the
same vma over and over,.. hmm?

> +		ret = 0;
> +		up_read(&mm->mmap_sem);
> +		mmput(mm);
> +	}
> +	list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
> +		list_del(&vi->probe_list);
> +		kfree(vi);
> +	}
> +	return ret;
> +}

