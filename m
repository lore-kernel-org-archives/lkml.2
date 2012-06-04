Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2FDSnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:43:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2FDSnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:43:02 -0400
Date: Mon, 4 Jun 2012 20:41:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] uprobes: make register/unregister O(n)
Message-ID: <20120604184109.GA24499@redhat.com>
References: <20120604145238.GA6408@redhat.com> <20120604173711.GM24279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604173711.GM24279@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Srikar Dronamraju wrote:
>
> >  again:
> > 	mutex_lock(&mapping->i_mmap_mutex);
> > 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> > 		if (!valid_vma(vma, is_register))
> > 			continue;
> >
> > 		if (!prev) {
> > 			prev = kmalloc(sizeof(struct map_info),
> > 					GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > 			if (!prev) {
> > 				more++;
> > 				continue;
> > 			}
> > 			prev->next = NULL;
> > 		}
> >
> > 		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
> > 			continue;
> >
> > 		info = prev;
> > 		prev = prev->next;
> > 		info->next = curr;
> > 		curr = info;
> >
> > 		info->mm = vma->vm_mm;
> > 		info->vaddr = vma_address(vma, offset);
> > 	}
> > 	mutex_unlock(&mapping->i_mmap_mutex);
> >
> > 	if (!more)
> > 		goto out;
> >
> > 	prev = curr;
> > 	while (curr) {
> > 		mmput(curr->mm);
> > 		curr = curr->next;
> > 	}
> >
> > 	do {
> > 		info = kmalloc(sizeof(struct map_info), GFP_KERNEL);
> > 		if (!info) {
> > 			curr = ERR_PTR(-ENOMEM);
> > 			goto out;
> > 		}
> > 		info->next = prev;
> > 		prev = info;
> > 	} while (--more);
> >
> > 	goto again;
>
> This is more theory
> If the number of vmas in the priority tree keeps increasing in every
> iteration, and the kmalloc(GFP_NOWAIT) fails i.e more is !0, then
> dont we end up in a forever loop?

But this can only hapen if the number of mappings keeps increasing
indefinitely, this is not possible.

And please not that the current code is worse if the number of mappings
grows. In fact it can livelock even if this number is limited. Suppose
you are trying to probe /bin/true and some process does
"while true; do /bin/true; done". It is possible that every time
register_for_each_vma() finds the new mapping because we do not free
the previous entries which refer to the already dead process/mm.


> Cant we just restrict this to just 2 iterations? [And depend on
> uprobe_mmap() to do the necessary if new vmas come in].

Probably yes, we can improve this. But I don't think this is that
easy, we can't rely on vma_prio_tree_foreach's ordering.

> >  out:
>
> > 	while (prev)
> > 		prev = free_map_info(prev);
>
> If we were able to allocate all map_info objects in the first pass but
> the last vma belonged to a mm thats at exit, i.e atomic_inc_non_zero
> returned 0 , then prev is !NULL and more is 0.  Then we seem to clear
> all the map_info objects without even decreasing the mm counts for which
> atomic_inc_non_zero() was successful. Will curr be proper in this case.

Not sure I understand. To simplify, suppose that we have a single mapping
but atomic_inc_non_zero() fails. In this case, yes, prev != NULL but
prev->mm is not valid. We only need to free the "extra" memory and return
curr == NULL (empty list). This is what the loop above does.

We only need mmput(mm) if atomic_inc_non_zero() suceeeds, and in this
case this "mm" should live in "curr" list. If we need more memory, then
build_map_info() does this right after it detects more != 0. Otherwise
the caller should do this.

> Should this while be an if?

But we can have more entries to free? Not only because atomic_inc_non_zero
failed.

> I am sure I am missing something here.

Or me. Thanks for looking!

Oleg.

