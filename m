Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1JLQCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:02:06 -0400
Received: from relay2.sgi.com ([192.48.179.30]:44362 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751604Ab1JLQCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:02:04 -0400
Date: Wed, 12 Oct 2011 11:02:02 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] Reduce vm_stat cacheline contention in __vm_enough_memory
Message-ID: <20111012160202.GA18666@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tmpfs I/O throughput testing on UV systems has shown writeback contention
between multiple writer threads (even when each thread writes to a separate
tmpfs mount point).

A large part of this is caused by cacheline contention reading the vm_stat
array in the __vm_enough_memory check.

The attached test patch illustrates a possible avenue for improvement in this
area.  By locally caching the values read from vm_stat (and refreshing the
values after 2 seconds), I was able to improve tmpfs writeback performance from
~300 MB/sec to ~700 MB/sec with 120 threads writing data simultaneously to
files on separate tmpfs mount points (tested on 3.1.0-rc9).

Note that this patch is simply to illustrate the gains that can be made here.
What I'm looking for is some guidance on an acceptable way to accomplish the
task of reducing contention in this area, either by caching these values in a
way similar to the attached patch, or by some other mechanism if this is
unacceptable.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 mm/mmap.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Index: linux/mm/mmap.c
===================================================================
--- linux.orig/mm/mmap.c
+++ linux/mm/mmap.c
@@ -93,6 +93,9 @@ int sysctl_max_map_count __read_mostly =
  */
 struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
 
+#define STAT_UPD_SEC	2
+static unsigned long cfreep, cfilep, cshmemp, cslabr;
+static unsigned long last_update_jif;
 /*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
@@ -122,8 +125,16 @@ int __vm_enough_memory(struct mm_struct
 		return 0;
 
 	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
-		free = global_page_state(NR_FREE_PAGES);
-		free += global_page_state(NR_FILE_PAGES);
+		if (unlikely(last_update_jif == 0) ||
+			((jiffies - last_update_jif) / HZ) >= STAT_UPD_SEC) {
+			last_update_jif = jiffies;
+			cfreep = global_page_state(NR_FREE_PAGES);
+			cfilep = global_page_state(NR_FILE_PAGES);
+			cshmemp = global_page_state(NR_SHMEM);
+			cslabr = global_page_state(NR_SLAB_RECLAIMABLE);
+		}
+		free = cfreep;
+		free += cfilep;
 
 		/*
 		 * shmem pages shouldn't be counted as free in this
@@ -131,7 +142,7 @@ int __vm_enough_memory(struct mm_struct
 		 * that won't affect the overall amount of available
 		 * memory in the system.
 		 */
-		free -= global_page_state(NR_SHMEM);
+		free -= cshmemp;
 
 		free += nr_swap_pages;
 
@@ -141,7 +152,7 @@ int __vm_enough_memory(struct mm_struct
 		 * which are reclaimable, under pressure.  The dentry
 		 * cache and most inode caches should fall into this
 		 */
-		free += global_page_state(NR_SLAB_RECLAIMABLE);
+		free += cslabr;
 
 		/*
 		 * Leave reserved pages. The pages are not for anonymous pages.
