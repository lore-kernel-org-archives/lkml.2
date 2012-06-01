Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656Ab2FASdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:33:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760Ab2FASdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:33:05 -0400
Date: Fri, 1 Jun 2012 20:31:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
	is_swbp_insn() == T
Message-ID: <20120601183113.GA31771@redhat.com>
References: <20120530165757.GA8077@redhat.com> <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins> <20120530173717.GM15587@linux.vnet.ibm.com> <1338400142.28384.12.camel@twins> <1338400450.28384.16.camel@twins> <20120531185339.GA28057@redhat.com> <20120601155312.GA20265@redhat.com> <20120601163315.GJ24279@linux.vnet.ibm.com> <20120601172055.GA24798@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601172055.GA24798@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Oleg Nesterov wrote:
>
> But. What do you think about the pseudo-code below? Only to illustrate
> the approach, the code is not complete.
>
> In the "likely" case we do vma_prio_tree_foreach() twice, this is
> better than the current quadratic behaviour.

See the "full" version. Untested of course, most probably has bugs,
but hopefully close enough.

What do you think?

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
			more++;
			continue;
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

	while (more--) {
		info = kmalloc(sizeof(struct map_info), GFP_KERNEL);
		if (!info) {
			curr = ERR_PTR(-ENOMEM);
			goto out;
		}
		info->next = prev;
		prev = info;
	}

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

