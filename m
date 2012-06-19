Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2FSIgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:36:25 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33426 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2FSIgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:36:23 -0400
Message-ID: <4FE039EF.3030809@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:35:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 07/10] zcache: optimize zcache_do_preload
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061908-8256-0000-0000-000002F8C2DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcache_do_preload is called in zcache_put_page where IRQ is disabled, so, need
not care preempt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index c18130f..386906d 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1026,45 +1026,43 @@ static int zcache_do_preload(struct tmem_pool *pool)
 		goto out;
 	if (unlikely(zcache_obj_cache == NULL))
 		goto out;
-	preempt_disable();
+
+	/* IRQ has already been disabled. */
 	kp = &__get_cpu_var(zcache_preloads);
 	while (kp->nr < ARRAY_SIZE(kp->objnodes)) {
-		preempt_enable_no_resched();
 		objnode = kmem_cache_alloc(zcache_objnode_cache,
 				ZCACHE_GFP_MASK);
 		if (unlikely(objnode == NULL)) {
 			zcache_failed_alloc++;
 			goto out;
 		}
-		preempt_disable();
-		kp = &__get_cpu_var(zcache_preloads);
-		if (kp->nr < ARRAY_SIZE(kp->objnodes))
-			kp->objnodes[kp->nr++] = objnode;
-		else
-			kmem_cache_free(zcache_objnode_cache, objnode);
+
+		kp->objnodes[kp->nr++] = objnode;
 	}
-	preempt_enable_no_resched();
+
 	obj = kmem_cache_alloc(zcache_obj_cache, ZCACHE_GFP_MASK);
 	if (unlikely(obj == NULL)) {
 		zcache_failed_alloc++;
 		goto out;
 	}
+
 	page = (void *)__get_free_page(ZCACHE_GFP_MASK);
 	if (unlikely(page == NULL)) {
 		zcache_failed_get_free_pages++;
 		kmem_cache_free(zcache_obj_cache, obj);
 		goto out;
 	}
-	preempt_disable();
-	kp = &__get_cpu_var(zcache_preloads);
+
 	if (kp->obj == NULL)
 		kp->obj = obj;
 	else
 		kmem_cache_free(zcache_obj_cache, obj);
+
 	if (kp->page == NULL)
 		kp->page = page;
 	else
 		free_page((unsigned long)page);
+
 	ret = 0;
 out:
 	return ret;
@@ -1575,7 +1573,6 @@ static int zcache_put_page(int cli_id, int pool_id, struct tmem_oid *oidp,
 				zcache_failed_pers_puts++;
 		}
 		zcache_put_pool(pool);
-		preempt_enable_no_resched();
 	} else {
 		zcache_put_to_flush++;
 		if (atomic_read(&pool->obj_count) > 0)
-- 
1.7.7.6

