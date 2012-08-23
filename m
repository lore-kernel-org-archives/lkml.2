Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030556Ab2HWPed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:34:33 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58209 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab2HWPdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:33:47 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 2/2] Revert "staging: zcache: optimize zcache_do_preload"
Date: Thu, 23 Aug 2012 10:33:11 -0500
Message-Id: <1345735991-6995-3-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082315-5806-0000-0000-000018B8096F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 79c0d92c5b6175c1462fbe38bf44180f325aa478.

This commit is resulting  memory corruption in the cleancache case

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reported-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 8a335b9..4f92d87 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1034,43 +1034,45 @@ static int zcache_do_preload(struct tmem_pool *pool)
 		goto out;
 	if (unlikely(zcache_obj_cache == NULL))
 		goto out;
-
-	/* IRQ has already been disabled. */
+	preempt_disable();
 	kp = &__get_cpu_var(zcache_preloads);
 	while (kp->nr < ARRAY_SIZE(kp->objnodes)) {
+		preempt_enable_no_resched();
 		objnode = kmem_cache_alloc(zcache_objnode_cache,
 				ZCACHE_GFP_MASK);
 		if (unlikely(objnode == NULL)) {
 			zcache_failed_alloc++;
 			goto out;
 		}
-
-		kp->objnodes[kp->nr++] = objnode;
+		preempt_disable();
+		kp = &__get_cpu_var(zcache_preloads);
+		if (kp->nr < ARRAY_SIZE(kp->objnodes))
+			kp->objnodes[kp->nr++] = objnode;
+		else
+			kmem_cache_free(zcache_objnode_cache, objnode);
 	}
-
+	preempt_enable_no_resched();
 	obj = kmem_cache_alloc(zcache_obj_cache, ZCACHE_GFP_MASK);
 	if (unlikely(obj == NULL)) {
 		zcache_failed_alloc++;
 		goto out;
 	}
-
 	page = (void *)__get_free_page(ZCACHE_GFP_MASK);
 	if (unlikely(page == NULL)) {
 		zcache_failed_get_free_pages++;
 		kmem_cache_free(zcache_obj_cache, obj);
 		goto out;
 	}
-
+	preempt_disable();
+	kp = &__get_cpu_var(zcache_preloads);
 	if (kp->obj == NULL)
 		kp->obj = obj;
 	else
 		kmem_cache_free(zcache_obj_cache, obj);
-
 	if (kp->page == NULL)
 		kp->page = page;
 	else
 		free_page((unsigned long)page);
-
 	ret = 0;
 out:
 	return ret;
@@ -1581,6 +1583,7 @@ static int zcache_put_page(int cli_id, int pool_id, struct tmem_oid *oidp,
 				zcache_failed_pers_puts++;
 		}
 		zcache_put_pool(pool);
+		preempt_enable_no_resched();
 	} else {
 		zcache_put_to_flush++;
 		if (atomic_read(&pool->obj_count) > 0)
-- 
1.7.9.5

