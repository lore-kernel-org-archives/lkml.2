Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1JMUn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:43:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38147 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1JMUn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:43:28 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: cascardo@holoscopio.com, dan.magenheimer@oracle.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, rcj@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH v2] staging: zcache: remove zcache_direct_reclaim_lock
Date: Thu, 13 Oct 2011 15:42:03 -0500
Message-Id: <1318538523-3976-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
x-cbid: 11101320-6148-0000-0000-0000003D87AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcache_do_preload() currently does a spin_trylock() on the
zcache_direct_reclaim_lock. Holding this lock intends to prevent
shrink_zcache_memory() from evicting zbud pages as a result
of a preload.

However, it also prevents two threads from
executing zcache_do_preload() at the same time.  The first
thread will obtain the lock and the second thread's spin_trylock()
will fail (an aborted preload) causing the page to be either lost
(cleancache) or pushed out to the swap device (frontswap). It
also doesn't ensure that the call to shrink_zcache_memory() is
on the same thread as the call to zcache_do_preload().

Additional, there is no need for this mechanism because all
zcache_do_preload() calls that come down from cleancache already
have PF_MEMALLOC set in the process flags which prevents
direct reclaim in the memory manager. If the zcache_do_preload()
call is done from the frontswap path, we _want_ reclaim to be
done (which it isn't right now).

This patch removes the zcache_direct_reclaim_lock and related
statistics in zcache.

Based on v3.1-rc8

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |   33 ++++++---------------------------
 1 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 462fbc2..995523f 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -962,15 +962,6 @@ out:
 static unsigned long zcache_failed_get_free_pages;
 static unsigned long zcache_failed_alloc;
 static unsigned long zcache_put_to_flush;
-static unsigned long zcache_aborted_preload;
-static unsigned long zcache_aborted_shrink;
-
-/*
- * Ensure that memory allocation requests in zcache don't result
- * in direct reclaim requests via the shrinker, which would cause
- * an infinite loop.  Maybe a GFP flag would be better?
- */
-static DEFINE_SPINLOCK(zcache_direct_reclaim_lock);
 
 /*
  * for now, used named slabs so can easily track usage; later can
@@ -1005,14 +996,12 @@ static int zcache_do_preload(struct tmem_pool *pool)
 	void *page;
 	int ret = -ENOMEM;
 
+	/* ensure no recursion due to direct reclaim */
+	BUG_ON(is_ephemeral(pool) && !(current->flags & PF_MEMALLOC));
 	if (unlikely(zcache_objnode_cache == NULL))
 		goto out;
 	if (unlikely(zcache_obj_cache == NULL))
 		goto out;
-	if (!spin_trylock(&zcache_direct_reclaim_lock)) {
-		zcache_aborted_preload++;
-		goto out;
-	}
 	preempt_disable();
 	kp = &__get_cpu_var(zcache_preloads);
 	while (kp->nr < ARRAY_SIZE(kp->objnodes)) {
@@ -1021,7 +1010,7 @@ static int zcache_do_preload(struct tmem_pool *pool)
 				ZCACHE_GFP_MASK);
 		if (unlikely(objnode == NULL)) {
 			zcache_failed_alloc++;
-			goto unlock_out;
+			goto out;
 		}
 		preempt_disable();
 		kp = &__get_cpu_var(zcache_preloads);
@@ -1034,13 +1023,13 @@ static int zcache_do_preload(struct tmem_pool *pool)
 	obj = kmem_cache_alloc(zcache_obj_cache, ZCACHE_GFP_MASK);
 	if (unlikely(obj == NULL)) {
 		zcache_failed_alloc++;
-		goto unlock_out;
+		goto out;
 	}
 	page = (void *)__get_free_page(ZCACHE_GFP_MASK);
 	if (unlikely(page == NULL)) {
 		zcache_failed_get_free_pages++;
 		kmem_cache_free(zcache_obj_cache, obj);
-		goto unlock_out;
+		goto out;
 	}
 	preempt_disable();
 	kp = &__get_cpu_var(zcache_preloads);
@@ -1053,8 +1042,6 @@ static int zcache_do_preload(struct tmem_pool *pool)
 	else
 		free_page((unsigned long)page);
 	ret = 0;
-unlock_out:
-	spin_unlock(&zcache_direct_reclaim_lock);
 out:
 	return ret;
 }
@@ -1423,8 +1410,6 @@ ZCACHE_SYSFS_RO(evicted_buddied_pages);
 ZCACHE_SYSFS_RO(failed_get_free_pages);
 ZCACHE_SYSFS_RO(failed_alloc);
 ZCACHE_SYSFS_RO(put_to_flush);
-ZCACHE_SYSFS_RO(aborted_preload);
-ZCACHE_SYSFS_RO(aborted_shrink);
 ZCACHE_SYSFS_RO(compress_poor);
 ZCACHE_SYSFS_RO(mean_compress_poor);
 ZCACHE_SYSFS_RO_ATOMIC(zbud_curr_raw_pages);
@@ -1466,8 +1451,6 @@ static struct attribute *zcache_attrs[] = {
 	&zcache_failed_get_free_pages_attr.attr,
 	&zcache_failed_alloc_attr.attr,
 	&zcache_put_to_flush_attr.attr,
-	&zcache_aborted_preload_attr.attr,
-	&zcache_aborted_shrink_attr.attr,
 	&zcache_zbud_unbuddied_list_counts_attr.attr,
 	&zcache_zbud_cumul_chunk_counts_attr.attr,
 	&zcache_zv_curr_dist_counts_attr.attr,
@@ -1507,11 +1490,7 @@ static int shrink_zcache_memory(struct shrinker *shrink,
 		if (!(gfp_mask & __GFP_FS))
 			/* does this case really need to be skipped? */
 			goto out;
-		if (spin_trylock(&zcache_direct_reclaim_lock)) {
-			zbud_evict_pages(nr);
-			spin_unlock(&zcache_direct_reclaim_lock);
-		} else
-			zcache_aborted_shrink++;
+		zbud_evict_pages(nr);
 	}
 	ret = (int)atomic_read(&zcache_zbud_curr_raw_pages);
 out:
-- 
1.7.4.1

