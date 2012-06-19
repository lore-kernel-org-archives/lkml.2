Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2FSIhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:37:00 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36367 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2FSIg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:36:57 -0400
Message-ID: <4FE03A1E.5070400@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:36:46 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 08/10] zcache: cleanup zcache_do_preload and zcache_put_page
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061908-2674-0000-0000-000004F27CDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the code for zcache_do_preload and zcache_put_page

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |   37 ++++++++++++++-------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 386906d..2ee55c4 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1040,29 +1040,24 @@ static int zcache_do_preload(struct tmem_pool *pool)
 		kp->objnodes[kp->nr++] = objnode;
 	}

-	obj = kmem_cache_alloc(zcache_obj_cache, ZCACHE_GFP_MASK);
-	if (unlikely(obj == NULL)) {
-		zcache_failed_alloc++;
-		goto out;
+	if (!kp->obj) {
+		obj = kmem_cache_alloc(zcache_obj_cache, ZCACHE_GFP_MASK);
+		if (unlikely(obj == NULL)) {
+			zcache_failed_alloc++;
+			goto out;
+		}
+		kp->obj = obj;
 	}

-	page = (void *)__get_free_page(ZCACHE_GFP_MASK);
-	if (unlikely(page == NULL)) {
-		zcache_failed_get_free_pages++;
-		kmem_cache_free(zcache_obj_cache, obj);
-		goto out;
+	if (!kp->page) {
+		page = (void *)__get_free_page(ZCACHE_GFP_MASK);
+		if (unlikely(page == NULL)) {
+			zcache_failed_get_free_pages++;
+			goto out;
+		}
+		kp->page =  page;
 	}

-	if (kp->obj == NULL)
-		kp->obj = obj;
-	else
-		kmem_cache_free(zcache_obj_cache, obj);
-
-	if (kp->page == NULL)
-		kp->page = page;
-	else
-		free_page((unsigned long)page);
-
 	ret = 0;
 out:
 	return ret;
@@ -1572,14 +1567,14 @@ static int zcache_put_page(int cli_id, int pool_id, struct tmem_oid *oidp,
 			else
 				zcache_failed_pers_puts++;
 		}
-		zcache_put_pool(pool);
 	} else {
 		zcache_put_to_flush++;
 		if (atomic_read(&pool->obj_count) > 0)
 			/* the put fails whether the flush succeeds or not */
 			(void)tmem_flush_page(pool, oidp, index);
-		zcache_put_pool(pool);
 	}
+
+	zcache_put_pool(pool);
 out:
 	return ret;
 }
-- 
1.7.7.6

