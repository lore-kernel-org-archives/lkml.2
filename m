Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab2FASIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:08:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab2FASIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:08:30 -0400
Date: Fri, 1 Jun 2012 19:20:55 +0200
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
Message-ID: <20120601172055.GA24798@redhat.com>
References: <20120530165757.GA8077@redhat.com> <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins> <20120530173717.GM15587@linux.vnet.ibm.com> <1338400142.28384.12.camel@twins> <1338400450.28384.16.camel@twins> <20120531185339.GA28057@redhat.com> <20120601155312.GA20265@redhat.com> <20120601163315.GJ24279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601163315.GJ24279@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-06-01 17:53:12]:
>
> > But. Doesn't this mean we can greatly simplify register_for_each_vma()
> > and make it O(n) ?
> >
> > Unless I missed something, we can simply create the list of
> > mm/vaddr structures under ->i_mmap_mutex (vma_prio_tree_foreach), then
> > register_for_each_vma() can process the list and that is all.
>
>
> If I remember correctly, we cannot allocate the list elements under
> i_mmap_mutex. We dont know how many list elements to allocate.
>
> This is what Peter had to say : https://lkml.org/lkml/2011/6/27/72
>
> "Because we try to take i_mmap_mutex during reclaim, trying to unmap
> pages. So suppose we do an allocation while holding i_mmap_mutex, find
> there's no free memory, try and unmap a page in order to free it, and
> we're stuck."

Yes, try_to_unmap.

But. What do you think about the pseudo-code below? Only to illustrate
the approach, the code is not complete.

In the "likely" case we do vma_prio_tree_foreach() twice, this is
better than the current quadratic behaviour.

Oleg.

struct map_info {
	struct map_info *next;
	struct mm_struct *mm;
	loff_t vaddr;
};

static struct map_info *
build_map_info_list(struct address_space *mapping, loff_t offset,
							bool is_register)
{
	struct map_info *prev = NULL;
	struct map_info *curr;
	int more;

again:
	more = 0;
	curr = NULL;
	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
		struct map_info *info = prev;

		if (!valid_vma(vma, is_register))
			continue;

		if (!info) {
			more++;
			continue;
		}

		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
			contunue;

		prev = info->next;

		info->mm = vma->vm_mm;
		info->vaddr = vma_address(vma, offset);

		info->next = curr;
		curr = info;
	}

	if (!more) {
		while (prev) {
			map_info *tmp = prev;
			prev = prev->next;
			kfree(tmp);
		}

		return curr;
	}

	prev = curr;

	while (curr) {
		mmput(curr->mm);
		curr = curr->next;
	}

	while (more--) {
		struct map_info *info = kmalloc(...);
		if (!info)
			return ERR_PTR(-ENOMEM);	// MEMORY LEAK
		info->next = prev;
		prev = info;
	}

	goto again;
}

