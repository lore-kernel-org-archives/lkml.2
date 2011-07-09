Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1GIUzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 16:55:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62092 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab1GIUzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 16:55:16 -0400
From: Dmitry Fink <dmitry.fink@palm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Fink <dmitry.fink@palm.com>
Subject: [PATCH] mmap: Fix and tidy up overcommit page arithmetic
Date: Sat,  9 Jul 2011 13:55:07 -0700
Message-Id: <1310244907-10144-1-git-send-email-dmitry.fink@palm.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310244149-9885-1-git-send-email-dmitry.fink@palm.com>
References: <1310244149-9885-1-git-send-email-dmitry.fink@palm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- shmem pages are not immediately available, but they are not
potentially available either, even if we swap them out, they will
just relocate from memory into swap, total amount of immediate and
potentially available memory is not going to be affected, so we
shouldn't count them as potentially free in the first place.

- nr_free_pages() is not an expensive operation anymore, there is
no need to split the decision making in two halves and repeat code.

Signed-off-by: Dmitry Fink <dmitry.fink@palm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
---
 mm/mmap.c  |   33 ++++++++++++---------------------
 mm/nommu.c |   33 ++++++++++++---------------------
 2 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index d49736f..b6ed22e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -122,9 +122,16 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		return 0;
 
 	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
-		unsigned long n;
+		free = global_page_state(NR_FREE_PAGES);
+		free += global_page_state(NR_FILE_PAGES);
+
+		/* shmem pages shouldn't be counted as free in this
+		 * case, they can't be purged, only swapped out, and
+		 * that won't affect the overall amount of available
+		 * memory in the system.
+		 */
+		free -= global_page_state(NR_SHMEM);
 
-		free = global_page_state(NR_FILE_PAGES);
 		free += nr_swap_pages;
 
 		/*
@@ -136,34 +143,18 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		free += global_page_state(NR_SLAB_RECLAIMABLE);
 
 		/*
-		 * Leave the last 3% for root
-		 */
-		if (!cap_sys_admin)
-			free -= free / 32;
-
-		if (free > pages)
-			return 0;
-
-		/*
-		 * nr_free_pages() is very expensive on large systems,
-		 * only call if we're about to fail.
-		 */
-		n = nr_free_pages();
-
-		/*
 		 * Leave reserved pages. The pages are not for anonymous pages.
 		 */
-		if (n <= totalreserve_pages)
+		if (free <= totalreserve_pages)
 			goto error;
 		else
-			n -= totalreserve_pages;
+			free -= totalreserve_pages;
 
 		/*
 		 * Leave the last 3% for root
 		 */
 		if (!cap_sys_admin)
-			n -= n / 32;
-		free += n;
+			free -= free / 32;
 
 		if (free > pages)
 			return 0;
diff --git a/mm/nommu.c b/mm/nommu.c
index 9edc897..54017d7 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1885,9 +1885,16 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		return 0;
 
 	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
-		unsigned long n;
+		free = global_page_state(NR_FREE_PAGES);
+		free += global_page_state(NR_FILE_PAGES);
+
+		/* shmem pages shouldn't be counted as free in this
+		 * case, they can't be purged, only swapped out, and
+		 * that won't affect the overall amount of available
+		 * memory in the system.
+		 */
+		free -= global_page_state(NR_SHMEM);
 
-		free = global_page_state(NR_FILE_PAGES);
 		free += nr_swap_pages;
 
 		/*
@@ -1899,34 +1906,18 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 		free += global_page_state(NR_SLAB_RECLAIMABLE);
 
 		/*
-		 * Leave the last 3% for root
-		 */
-		if (!cap_sys_admin)
-			free -= free / 32;
-
-		if (free > pages)
-			return 0;
-
-		/*
-		 * nr_free_pages() is very expensive on large systems,
-		 * only call if we're about to fail.
-		 */
-		n = nr_free_pages();
-
-		/*
 		 * Leave reserved pages. The pages are not for anonymous pages.
 		 */
-		if (n <= totalreserve_pages)
+		if (free <= totalreserve_pages)
 			goto error;
 		else
-			n -= totalreserve_pages;
+			free -= totalreserve_pages;
 
 		/*
 		 * Leave the last 3% for root
 		 */
 		if (!cap_sys_admin)
-			n -= n / 32;
-		free += n;
+			free -= free / 32;
 
 		if (free > pages)
 			return 0;
-- 
1.7.6

