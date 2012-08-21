Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2HUPGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:06:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2HUPGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:06:33 -0400
Date: Tue, 21 Aug 2012 17:06:18 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: fix inconsistent memory between
 secondary MMU and host
Message-ID: <20120821150618.GJ27696@redhat.com>
References: <503358FF.3030009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503358FF.3030009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:46:39PM +0800, Xiao Guangrong wrote:
> There has a bug in set_pte_at_notify which always set the pte to the
> new page before release the old page in secondary MMU, at this time,
> the process will access on the new page, but the secondary MMU still
> access on the old page, the memory is inconsistent between them
> 
> Below scenario shows the bug more clearly:
> 
> at the beginning: *p = 0, and p is write-protected by KSM or shared with
> parent process
> 
> CPU 0                                       CPU 1
> write 1 to p to trigger COW,
> set_pte_at_notify will be called:
>   *pte = new_page + W; /* The W bit of pte is set */
> 
>                                      *p = 1; /* pte is valid, so no #PF */
> 
>                                      return back to secondary MMU, then
>                                      the secondary MMU read p, but get:
>                                      *p == 0;
> 
>                          /*
>                           * !!!!!!
>                           * the host has already set p to 1, but the secondary
>                           * MMU still get the old value 0
>                           */
> 
>   call mmu_notifier_change_pte to release
>   old page in secondary MMU

The KSM usage of it looks safe because it will only establish readonly
ptes with it.

It seems a problem only for do_wp_page. It wasn't safe to setup
writable ptes with it. I guess we first introduced it for KSM and then
we added it to do_wp_page too by mistake.

The race window is really tiny, it's unlikely it has ever triggered,
however this one seem to be possible so it's slightly more serious
than the other race you recently found (the previous one in the exit
path I think it was impossible to trigger with KVM).

> We can fix it by release old page first, then set the pte to the new
> page.
> 
> Note, the new page will be firstly used in secondary MMU before it is
> mapped into the page table of the process, but this is safe because it
> is protected by the page table lock, there is no race to change the pte
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  include/linux/mmu_notifier.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 1d1b1e1..8c7435a 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -317,8 +317,8 @@ static inline void mmu_notifier_mm_destroy(struct mm_struct *mm)
>  	unsigned long ___address = __address;				\
>  	pte_t ___pte = __pte;						\
>  									\
> -	set_pte_at(___mm, ___address, __ptep, ___pte);			\
>  	mmu_notifier_change_pte(___mm, ___address, ___pte);		\
> +	set_pte_at(___mm, ___address, __ptep, ___pte);			\
>  })

If we establish the spte on the new page, what will happen is the same
race in reverse. The fundamental problem is that the first guy that
writes to the "newpage" (guest or host) won't fault again and so it
will fail to serialize against the PT lock.

CPU0  		    	    	CPU1
				oldpage[1] == 0 (both guest & host)
oldpage[0] = 1
trigger do_wp_page
mmu_notifier_change_pte
spte = newpage + writable
				guest does newpage[1] = 1
				vmexit
				host read oldpage[1] == 0
pte = newpage + writable (too late)

I think the fix is to use ptep_clear_flush_notify whenever
set_pte_at_notify will establish a writable pte/spte. If the pte/spte
established by set_pte_at_notify/change_pte is readonly we don't need
to do the ptep_clear_flush_notify instead because when the host will
write to the page that will fault and serialize against the
PT lock (set_pte_at_notify must always run under the PT lock of course).

How about this:

=====
>From 160a0b1b2be9bf96c45b30d9423f8196ecebe351 Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Tue, 21 Aug 2012 16:48:11 +0200
Subject: [PATCH] mmu_notifier: fix race in set_pte_at_notify usage

Whenever we establish a writable spte with set_pte_at_notify the
ptep_clear_flush before it must be a _notify one that clears the spte
too.

The fundamental problem is that if the primary MMU that writes to the
"newpage" won't fault again if the pte established by
set_pte_at_notify is writable. And so it will fail to serialize
against the PT lock to wait the set_pte_at_notify to finish
updating all secondary MMUs before the write hits the newpage.

CPU0  		    	    	CPU1
				oldpage[1] == 0 (all MMUs)
oldpage[0] = 1
trigger do_wp_page
take PT lock
ptep_clear_flush (secondary MMUs
still have read access to oldpage)
mmu_notifier_change_pte
pte = newpage + writable (primary MMU can write to
newpage)
				host write newpage[1] == 1 (no fault,
				failed to serialize against PT lock)
				vmenter
				guest read oldpage[1] == 0
spte = newpage + writable (too late)

It's safe to use set_pte_at_notify with a ptep_clear_flush (_notify
not) only if we establish a readonly pte with it (like KSM does)
because in that case the write done by the primary MMU will fault and
serialize against the PT lock.

set_pte_at_notify is still worth to use even if we have to do
ptep_clear_flush_notify before it, because it will still avoid the
secondary MMU to trigger secondary MMU page faults to access the new
page (if it has sptes and it's not only a TLB with a TLB miss
implemented by follow_page).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/mmu_notifier.h |    7 +++++++
 mm/memory.c                  |    2 +-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index ee2baf0..cce4e4f 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -75,6 +75,13 @@ struct mmu_notifier_ops {
 	/*
 	 * change_pte is called in cases that pte mapping to page is changed:
 	 * for example, when ksm remaps pte to point to a new shared page.
+	 *
+	 * NOTE: If this method is used to setup a writable pte, it
+	 * must be preceded by a secondary MMU invalidate before the
+	 * pte is established in the primary MMU. That is required to
+	 * avoid the old page won't be still be readable by the
+	 * secondary MMUs after the primary MMU gains write access to
+	 * the newpage.
 	 */
 	void (*change_pte)(struct mmu_notifier *mn,
 			   struct mm_struct *mm,
diff --git a/mm/memory.c b/mm/memory.c
index ec12fc9..88749f3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2720,7 +2720,7 @@ gotten:
 		 * seen in the presence of one thread doing SMC and another
 		 * thread doing COW.
 		 */
-		ptep_clear_flush(vma, address, page_table);
+		ptep_clear_flush_notify(vma, address, page_table);
 		page_add_new_anon_rmap(new_page, vma, address);
 		/*
 		 * We call the notify macro here because, when using secondary
