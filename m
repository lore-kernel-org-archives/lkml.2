Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1I2JzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:55:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50094 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1I2JzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:55:06 -0400
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: [PATCH v2] vmscan: add barrier to prevent evictable page in unevictable list
Date: Thu, 29 Sep 2011 18:54:45 +0900
Message-Id: <1317290085-3804-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110928081452.GC23535@redhat.com>
References: <20110928081452.GC23535@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When racing between putback_lru_page and shmem_lock with lock=0 happens,
progrom execution order is as follows, but clear_bit in processor #1
could be reordered right before spin_unlock of processor #1.
Then, the page would be stranded on the unevictable list.

spin_lock
SetPageLRU
spin_unlock
                                clear_bit(AS_UNEVICTABLE)
                                spin_lock
                                if PageLRU()
                                        if !test_bit(AS_UNEVICTABLE)
                                        	move evictable list
smp_mb
if !test_bit(AS_UNEVICTABLE)
        move evictable list
                                spin_unlock

But, pagevec_lookup in scan_mapping_unevictable_pages has rcu_read_[un]lock so
it could protect reordering before reaching test_bit(AS_UNEVICTABLE) on processor #1
so this problem never happens. But it's a unexpected side effect and we should
solve this problem properly.

This patch adds a barrier after mapping_clear_unevictable.

side-note: I didn't meet this problem but just found during review.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/shmem.c  |    6 ++++++
 mm/vmscan.c |   11 ++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 2d35772..fa4fa6c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1068,6 +1068,12 @@ int shmem_lock(struct file *file, int lock, struct user_struct *user)
 		user_shm_unlock(inode->i_size, user);
 		info->flags &= ~VM_LOCKED;
 		mapping_clear_unevictable(file->f_mapping);
+		/*
+		 * Ensure that a racing putback_lru_page() can see
+		 * the pages of this mapping are evictable when we
+		 * skip them due to !PageLRU during the scan.
+		 */
+		smp_mb__after_clear_bit();
 		scan_mapping_unevictable_pages(file->f_mapping);
 	}
 	retval = 0;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 23256e8..4480f67 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -634,13 +634,14 @@ redo:
 		lru = LRU_UNEVICTABLE;
 		add_page_to_unevictable_list(page);
 		/*
-		 * When racing with an mlock clearing (page is
-		 * unlocked), make sure that if the other thread does
-		 * not observe our setting of PG_lru and fails
-		 * isolation, we see PG_mlocked cleared below and move
+		 * When racing with an mlock or AS_UNEVICTABLE clearing
+		 * (page is unlocked) make sure that if the other thread
+		 * does not observe our setting of PG_lru and fails
+		 * isolation/check_move_unevictable_page,
+		 * we see PG_mlocked/AS_UNEVICTABLE cleared below and move
 		 * the page back to the evictable list.
 		 *
-		 * The other side is TestClearPageMlocked().
+		 * The other side is TestClearPageMlocked() or shmem_lock().
 		 */
 		smp_mb();
 	}
-- 
1.7.4.1

