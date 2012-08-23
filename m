Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab2HWPdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:33:51 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58296 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2HWPdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:33:49 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 1/2] Revert "staging: zcache: cleanup zcache_do_preload and zcache_put_page"
Date: Thu, 23 Aug 2012 10:33:10 -0500
Message-Id: <1345735991-6995-2-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082315-5806-0000-0000-000018B80997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b71f3bcc5ab5e76a22d7ad82b3795602fcf0e0af.

This commit is resulting  memory corruption in the cleancache case

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reported-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |   37 +++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index c214977..8a335b9 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1048,24 +1048,29 @@ static int zcache_do_preload(struct tmem_pool *pool)
 		kp->objnodes[kp->nr++] = objnode;
 	}
 
-	if (!kp->obj) {
-		obj = kmem_cache_alloc(zcache_obj_cache, ZCACHE_GFP_MASK);
-		if (unlikely(obj == NULL)) {
-			zcache_failed_alloc++;
-			goto out;
-		}
-		kp->obj = obj;
+	obj = kmem_cache_alloc(zcache_obj_cache, ZCACHE_GFP_MASK);
+	if (unlikely(obj == NULL)) {
+		zcache_failed_alloc++;
+		goto out;
 	}
 
-	if (!kp->page) {
-		page = (void *)__get_free_page(ZCACHE_GFP_MASK);
-		if (unlikely(page == NULL)) {
-			zcache_failed_get_free_pages++;
-			goto out;
-		}
-		kp->page =  page;
+	page = (void *)__get_free_page(ZCACHE_GFP_MASK);
+	if (unlikely(page == NULL)) {
+		zcache_failed_get_free_pages++;
+		kmem_cache_free(zcache_obj_cache, obj);
+		goto out;
 	}
 
+	if (kp->obj == NULL)
+		kp->obj = obj;
+	else
+		kmem_cache_free(zcache_obj_cache, obj);
+
+	if (kp->page == NULL)
+		kp->page = page;
+	else
+		free_page((unsigned long)page);
+
 	ret = 0;
 out:
 	return ret;
@@ -1575,14 +1580,14 @@ static int zcache_put_page(int cli_id, int pool_id, struct tmem_oid *oidp,
 			else
 				zcache_failed_pers_puts++;
 		}
+		zcache_put_pool(pool);
 	} else {
 		zcache_put_to_flush++;
 		if (atomic_read(&pool->obj_count) > 0)
 			/* the put fails whether the flush succeeds or not */
 			(void)tmem_flush_page(pool, oidp, index);
+		zcache_put_pool(pool);
 	}
-
-	zcache_put_pool(pool);
 out:
 	return ret;
 }
-- 
1.7.9.5

