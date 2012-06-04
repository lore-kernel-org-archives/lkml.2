Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab2FDOzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:55:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2FDOy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:54:58 -0400
Date: Mon, 4 Jun 2012 16:52:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] uprobes: make register/unregister O(n)
Message-ID: <20120604145238.GA6408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On top of "[PATCH 0/3] uprobes: misc minor changes".

Peter, I forgot about your patch initially, so I am re-sending it
as 3/3 on top of 1-2. Hopefully you do not mind but I can rebase
1-2 on top of your change.

It is not easy to read 1/3, so I attached the resulting code below,
to simplify the review.

Oleg.

struct map_info {
	struct map_info *next;
	struct mm_struct *mm;
	loff_t vaddr;
};

static inline struct map_info *free_map_info(struct map_info *info)
{
	struct map_info *next = info->next;
	kfree(info);
	return next;
}

static struct map_info *
build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
{
	unsigned long pgoff = offset >> PAGE_SHIFT;
	struct prio_tree_iter iter;
	struct vm_area_struct *vma;
	struct map_info *curr = NULL;
	struct map_info *prev = NULL;
	struct map_info *info;
	int more = 0;

 again:
	mutex_lock(&mapping->i_mmap_mutex);
	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
		if (!valid_vma(vma, is_register))
			continue;

		if (!prev) {
			prev = kmalloc(sizeof(struct map_info),
					GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
			if (!prev) {
				more++;
				continue;
			}
			prev->next = NULL;
		}

		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
			continue;

		info = prev;
		prev = prev->next;
		info->next = curr;
		curr = info;

		info->mm = vma->vm_mm;
		info->vaddr = vma_address(vma, offset);
	}
	mutex_unlock(&mapping->i_mmap_mutex);

	if (!more)
		goto out;

	prev = curr;
	while (curr) {
		mmput(curr->mm);
		curr = curr->next;
	}

	do {
		info = kmalloc(sizeof(struct map_info), GFP_KERNEL);
		if (!info) {
			curr = ERR_PTR(-ENOMEM);
			goto out;
		}
		info->next = prev;
		prev = info;
	} while (--more);

	goto again;
 out:
	while (prev)
		prev = free_map_info(prev);
	return curr;
}

static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
{
	struct map_info *info;
	int err = 0;

	info = build_map_info(uprobe->inode->i_mapping,
					uprobe->offset, is_register);
	if (IS_ERR(info))
		return PTR_ERR(info);

	while (info) {
		struct mm_struct *mm = info->mm;
		struct vm_area_struct *vma;
		loff_t vaddr;

		if (err)
			goto free;

		down_write(&mm->mmap_sem);
		vma = find_vma(mm, (unsigned long)info->vaddr);
		if (!vma || !valid_vma(vma, is_register))
			goto unlock;

		vaddr = vma_address(vma, uprobe->offset);
		if (vma->vm_file->f_mapping->host != uprobe->inode ||
						vaddr != info->vaddr)
			goto unlock;

		if (is_register) {
			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
			/*
			 * We can race against uprobe_register(), see the
			 * comment near uprobe_hash().
			 */
			if (err == -EEXIST)
				err = 0;
		} else {
			remove_breakpoint(uprobe, mm, info->vaddr);
		}
 unlock:
		up_write(&mm->mmap_sem);
 free:
		mmput(mm);
		info = free_map_info(info);
	}

	return err;
}

