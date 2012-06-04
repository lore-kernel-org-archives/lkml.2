Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2FDRlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:41:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44771 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2FDRlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:41:14 -0400
Date: Mon, 4 Jun 2012 23:07:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] uprobes: make register/unregister O(n)
Message-ID: <20120604173711.GM24279@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120604145238.GA6408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120604145238.GA6408@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060417-5806-0000-0000-000015DE1DA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I read this code a few times, but I still think I am getting confused
about few scenarios.

So please correct me.

> struct map_info {
> 	struct map_info *next;
> 	struct mm_struct *mm;
> 	loff_t vaddr;
> };
> 
> static inline struct map_info *free_map_info(struct map_info *info)
> {
> 	struct map_info *next = info->next;
> 	kfree(info);
> 	return next;
> }
> 
> static struct map_info *
> build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
> {
> 	unsigned long pgoff = offset >> PAGE_SHIFT;
> 	struct prio_tree_iter iter;
> 	struct vm_area_struct *vma;
> 	struct map_info *curr = NULL;
> 	struct map_info *prev = NULL;
> 	struct map_info *info;
> 	int more = 0;
> 
>  again:
> 	mutex_lock(&mapping->i_mmap_mutex);
> 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> 		if (!valid_vma(vma, is_register))
> 			continue;
> 
> 		if (!prev) {
> 			prev = kmalloc(sizeof(struct map_info),
> 					GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
> 			if (!prev) {
> 				more++;
> 				continue;
> 			}
> 			prev->next = NULL;
> 		}
> 
> 		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
> 			continue;
> 
> 		info = prev;
> 		prev = prev->next;
> 		info->next = curr;
> 		curr = info;
> 
> 		info->mm = vma->vm_mm;
> 		info->vaddr = vma_address(vma, offset);
> 	}
> 	mutex_unlock(&mapping->i_mmap_mutex);
> 
> 	if (!more)
> 		goto out;
> 
> 	prev = curr;
> 	while (curr) {
> 		mmput(curr->mm);
> 		curr = curr->next;
> 	}
> 
> 	do {
> 		info = kmalloc(sizeof(struct map_info), GFP_KERNEL);
> 		if (!info) {
> 			curr = ERR_PTR(-ENOMEM);
> 			goto out;
> 		}
> 		info->next = prev;
> 		prev = info;
> 	} while (--more);
> 
> 	goto again;

This is more theory
If the number of vmas in the priority tree keeps increasing in every
iteration, and the kmalloc(GFP_NOWAIT) fails i.e more is !0, then
dont we end up in a forever loop?

Cant we just restrict this to just 2 iterations? [And depend on
uprobe_mmap() to do the necessary if new vmas come in].

>  out:

> 	while (prev)
> 		prev = free_map_info(prev);

If we were able to allocate all map_info objects in the first pass but
the last vma belonged to a mm thats at exit, i.e atomic_inc_non_zero
returned 0 , then prev is !NULL and more is 0.  Then we seem to clear
all the map_info objects without even decreasing the mm counts for which
atomic_inc_non_zero() was successful. Will curr be proper in this case.

Should this while be an if?

I am sure I am missing something here. Probably I should take a look
again. 

> 	return curr;
> }
> 
> static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
> {
> 	struct map_info *info;
> 	int err = 0;
> 
> 	info = build_map_info(uprobe->inode->i_mapping,
> 					uprobe->offset, is_register);
> 	if (IS_ERR(info))
> 		return PTR_ERR(info);
> 
> 	while (info) {
> 		struct mm_struct *mm = info->mm;
> 		struct vm_area_struct *vma;
> 		loff_t vaddr;
> 
> 		if (err)
> 			goto free;
> 
> 		down_write(&mm->mmap_sem);
> 		vma = find_vma(mm, (unsigned long)info->vaddr);
> 		if (!vma || !valid_vma(vma, is_register))
> 			goto unlock;
> 
> 		vaddr = vma_address(vma, uprobe->offset);
> 		if (vma->vm_file->f_mapping->host != uprobe->inode ||
> 						vaddr != info->vaddr)
> 			goto unlock;
> 
> 		if (is_register) {
> 			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
> 			/*
> 			 * We can race against uprobe_register(), see the
> 			 * comment near uprobe_hash().
> 			 */
> 			if (err == -EEXIST)
> 				err = 0;
> 		} else {
> 			remove_breakpoint(uprobe, mm, info->vaddr);
> 		}
>  unlock:
> 		up_write(&mm->mmap_sem);
>  free:
> 		mmput(mm);
> 		info = free_map_info(info);
> 	}
> 
> 	return err;
> }
> 

