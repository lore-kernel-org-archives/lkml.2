Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab0LERae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:30:34 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60513 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0LERa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:30:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=urvxUt+xvi1T27DASa1N4C4PCvxFa3JSFK9sXaEufCNdlWq67i557TdYVnTABPm4PQ
         eSoo+yDqudKtIEj+nRrNzk7Sof2JhPVZ85rf+lcr38QHDavLE/iLafirD+tZfS5DF0us
         o9uhk/ioZF4s6ZK3jk+D2GUwmp2td4L5c8ODs=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH v4 7/7] Prevent activation of page in madvise_dontneed
Date: Mon,  6 Dec 2010 02:29:15 +0900
Message-Id: <ca25c4e33beceeb3a96e8437671e5e0a188602fa.1291568905.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1291568905.git.minchan.kim@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1291568905.git.minchan.kim@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now zap_pte_range alwayas activates pages which are pte_young &&
!VM_SequentialReadHint(vma). But in case of calling MADV_DONTNEED,
it's unnecessary since the page wouldn't use any more.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hughd@google.com>

Changelog since v3:
 - Change variable name - suggested by Johannes
 - Union ignore_references with zap_details - suggested by Hugh

Changelog since v2:
 - remove unnecessary description

Changelog since v1:
 - change word from promote to activate
 - add activate argument to zap_pte_range and family function
---
 include/linux/mm.h |    4 +++-
 mm/madvise.c       |    6 +++---
 mm/memory.c        |    5 ++++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6522ae4..e57190f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -771,12 +771,14 @@ struct zap_details {
 	pgoff_t last_index;			/* Highest page->index to unmap */
 	spinlock_t *i_mmap_lock;		/* For unmap_mapping_range: */
 	unsigned long truncate_count;		/* Compare vm_truncate_count */
+	bool ignore_references;			/* For page activation */
 };
 
 #define __ZAP_DETAILS_INITIALIZER(name) \
                 { .nonlinear_vma = NULL \
 		, .check_mapping = NULL \
-		, .i_mmap_lock = NULL }
+		, .i_mmap_lock = NULL	\
+		, .ignore_references = false }
 
 #define DEFINE_ZAP_DETAILS(name)		\
 	struct zap_details name = __ZAP_DETAILS_INITIALIZER(name)
diff --git a/mm/madvise.c b/mm/madvise.c
index bfa17aa..8e7aba3 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -163,6 +163,7 @@ static long madvise_dontneed(struct vm_area_struct * vma,
 			     unsigned long start, unsigned long end)
 {
 	DEFINE_ZAP_DETAILS(details);
+	details.ignore_references = true;
 
 	*prev = vma;
 	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
@@ -173,10 +174,9 @@ static long madvise_dontneed(struct vm_area_struct * vma,
 		details.last_index = ULONG_MAX;
 
 		zap_page_range(vma, start, end - start, &details);
-	} else {
-
+	} else
 		zap_page_range(vma, start, end - start, &details);
-	}
+
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index c0879bb..44d87e1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -897,6 +897,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	pte_t *pte;
 	spinlock_t *ptl;
 	int rss[NR_MM_COUNTERS];
+	bool ignore_references = details->ignore_references;
 
 	init_rss_vec(rss);
 
@@ -952,7 +953,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				if (pte_dirty(ptent))
 					set_page_dirty(page);
 				if (pte_young(ptent) &&
-				    likely(!VM_SequentialReadHint(vma)))
+				    likely(!VM_SequentialReadHint(vma)) &&
+					!ignore_references)
 					mark_page_accessed(page);
 				rss[MM_FILEPAGES]--;
 			}
@@ -1218,6 +1220,7 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	DEFINE_ZAP_DETAILS(details);
+	details.ignore_references = true;
 	if (address < vma->vm_start || address + size > vma->vm_end ||
 	    		!(vma->vm_flags & VM_PFNMAP))
 		return -1;
-- 
1.7.0.4

