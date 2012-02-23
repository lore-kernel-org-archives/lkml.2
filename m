Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2BWNFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:05:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38643 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2BWNFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:05:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.70.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120222130659.d75b6f69.akpm@linux-foundation.org>
References: <CAJd=RBALNtedfq+PLPnGKd4i4D0mLiVPdW_7pWWopnSZNC_vqA@mail.gmail.com>
	<20120222130659.d75b6f69.akpm@linux-foundation.org>
Date: Thu, 23 Feb 2012 21:05:41 +0800
Message-ID: <CAJd=RBA53nS70Q7GEeskKFas-hfg4GKmUf=Zut5anSN0P+d1KA@mail.gmail.com>
Subject: Re: [PATCH] mm: hugetlb: bail out unmapping after serving reference page
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 5:06 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Perhaps add a little comment to this explaining what's going on?
>
>
> It would be sufficient to do
>
>        if (ref_page)
>                break;
>
> This is more efficient, and doesn't make people worry about whether
> this value of `page' is the same as the one which
> pte_page(huge_ptep_get()) earlier returned.
>
Hi Andrew

It is re-prepared,

===cut here===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: hugetlb: bail out unmapping after serving reference page

When unmapping given VM range, we could bail out if a reference page is
supplied and is unmapped, which is a minor optimization.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/hugetlb.c	Wed Feb 22 19:34:12 2012
+++ b/mm/hugetlb.c	Thu Feb 23 20:13:06 2012
@@ -2280,6 +2280,10 @@ void __unmap_hugepage_range(struct vm_ar
 		if (pte_dirty(pte))
 			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
+
+		/* Bail out after unmapping reference page if supplied */
+		if (ref_page)
+			break;
 	}
 	spin_unlock(&mm->page_table_lock);
 	flush_tlb_range(vma, start, end);
--


> Why do we evaluate `page' twice inside that loop anyway?  And why do we
> check for huge_pte_none() twice?  It looks all messed up.
>

and a follow-up cleanup also attached.

Thanks
Hillf

===cut here===
From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] mm: hugetlb: cleanup duplicated code in unmapping vm range

When unmapping given VM range, a couple of code duplicate, such as pte_page()
and huge_pte_none(), so a cleanup needed to compact them together.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/hugetlb.c	Thu Feb 23 20:13:06 2012
+++ b/mm/hugetlb.c	Thu Feb 23 20:30:16 2012
@@ -2245,16 +2245,23 @@ void __unmap_hugepage_range(struct vm_ar
 		if (huge_pmd_unshare(mm, &address, ptep))
 			continue;

+		pte = huge_ptep_get(ptep);
+		if (huge_pte_none(pte))
+			continue;
+
+		/*
+		 * HWPoisoned hugepage is already unmapped and dropped reference
+		 */
+		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
+			continue;
+
+		page = pte_page(pte);
 		/*
 		 * If a reference page is supplied, it is because a specific
 		 * page is being unmapped, not a range. Ensure the page we
 		 * are about to unmap is the actual page of interest.
 		 */
 		if (ref_page) {
-			pte = huge_ptep_get(ptep);
-			if (huge_pte_none(pte))
-				continue;
-			page = pte_page(pte);
 			if (page != ref_page)
 				continue;

@@ -2267,16 +2274,6 @@ void __unmap_hugepage_range(struct vm_ar
 		}

 		pte = huge_ptep_get_and_clear(mm, address, ptep);
-		if (huge_pte_none(pte))
-			continue;
-
-		/*
-		 * HWPoisoned hugepage is already unmapped and dropped reference
-		 */
-		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
-			continue;
-
-		page = pte_page(pte);
 		if (pte_dirty(pte))
 			set_page_dirty(page);
 		list_add(&page->lru, &page_list);
--
