Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1LWNAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:00:47 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61119 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab1LWNAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:00:43 -0500
MIME-Version: 1.0
In-Reply-To: <20111222163604.GB14983@tiehlicka.suse.cz>
References: <CAJd=RBBF=K5hHvEwb6uwZJwS4=jHKBCNYBTJq-pSbJ9j_ZaiaA@mail.gmail.com>
	<20111222163604.GB14983@tiehlicka.suse.cz>
Date: Fri, 23 Dec 2011 21:00:41 +0800
Message-ID: <CAJd=RBBY0sKdtdx9d8KXTchjaN6au0_hvMfE2+9JkdhvJe7eAw@mail.gmail.com>
Subject: Re: [PATCH] mm: hugetlb: undo change to page mapcount in fault handler
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 12:36 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> The changelog is rather cryptic. What about something like:
>

It is included in the following version, thanks.

===CUT HERE===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: hugetlb: undo change to page mapcount in fault handler

Page mapcount should be updated only if we are sure that the page ends
up in the page table otherwise we would leak if we couldn't COW due to
reservations or if idx is out of bounds.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---

--- a/mm/hugetlb.c	Tue Dec 20 21:26:30 2011
+++ b/mm/hugetlb.c	Thu Dec 22 21:29:42 2011
@@ -2509,6 +2509,7 @@ static int hugetlb_no_page(struct mm_str
 {
 	struct hstate *h = hstate_vma(vma);
 	int ret = VM_FAULT_SIGBUS;
+	int anon_rmap = 0;
 	pgoff_t idx;
 	unsigned long size;
 	struct page *page;
@@ -2563,14 +2564,13 @@ retry:
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += blocks_per_huge_page(h);
 			spin_unlock(&inode->i_lock);
-			page_dup_rmap(page);
 		} else {
 			lock_page(page);
 			if (unlikely(anon_vma_prepare(vma))) {
 				ret = VM_FAULT_OOM;
 				goto backout_unlocked;
 			}
-			hugepage_add_new_anon_rmap(page, vma, address);
+			anon_rmap = 1;
 		}
 	} else {
 		/*
@@ -2583,7 +2583,6 @@ retry:
 			      VM_FAULT_SET_HINDEX(h - hstates);
 			goto backout_unlocked;
 		}
-		page_dup_rmap(page);
 	}

 	/*
@@ -2607,6 +2606,10 @@ retry:
 	if (!huge_pte_none(huge_ptep_get(ptep)))
 		goto backout;

+	if (anon_rmap)
+		hugepage_add_new_anon_rmap(page, vma, address);
+	else
+		page_dup_rmap(page);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
