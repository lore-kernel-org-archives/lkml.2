Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1B1XDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:03:05 -0500
Received: from mail.digium.com ([216.207.245.2]:56221 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab1B1XDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:03:03 -0500
X-Greylist: delayed 1354 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 18:03:03 EST
Date: Mon, 28 Feb 2011 16:41:24 -0600
From: Russ Meyerriecks <rmeyerriecks@digium.com>
To: akpm@linux-foundation.org
Cc: sruffell@digium.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/dmapool.c: Do not create/destroy sysfs file while
	holding pools_lock
Message-ID: <20110228224124.GA31769@blackmagic.digium.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaun Ruffell <sruffell@digium.com>

Eliminates a circular lock dependency reported by lockdep. When reading the
"pools" file from a PCI device via sysfs, the s_active lock is acquired before
the pools_lock. When unloading the driver and destroying the pool, pools_lock
is acquired before the s_active lock.

 cat/12016 is trying to acquire lock:
  (pools_lock){+.+.+.}, at: [<c04ef113>] show_pools+0x43/0x140

 but task is already holding lock:
  (s_active#82){++++.+}, at: [<c0554e1b>] sysfs_read_file+0xab/0x160

 which lock already depends on the new lock.

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Russ Meyerriecks <rmeyerriecks@digium.com>
---
 mm/dmapool.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 03bf3bb..d693872 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -174,21 +174,28 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 	init_waitqueue_head(&retval->waitq);
 
 	if (dev) {
-		int ret;
+		int first_pool;
 
 		mutex_lock(&pools_lock);
 		if (list_empty(&dev->dma_pools))
-			ret = device_create_file(dev, &dev_attr_pools);
+			first_pool = 1;
 		else
-			ret = 0;
+			first_pool = 0;
 		/* note:  not currently insisting "name" be unique */
-		if (!ret)
-			list_add(&retval->pools, &dev->dma_pools);
-		else {
-			kfree(retval);
-			retval = NULL;
-		}
+		list_add(&retval->pools, &dev->dma_pools);
 		mutex_unlock(&pools_lock);
+
+		if (first_pool) {
+			int ret;
+			ret = device_create_file(dev, &dev_attr_pools);
+			if (ret) {
+				mutex_lock(&pools_lock);
+				list_del(&retval->pools);
+				mutex_unlock(&pools_lock);
+				kfree(retval);
+				retval = NULL;
+			}
+		}
 	} else
 		INIT_LIST_HEAD(&retval->pools);
 
@@ -263,12 +270,19 @@ static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
  */
 void dma_pool_destroy(struct dma_pool *pool)
 {
+	int last_pool;
+
 	mutex_lock(&pools_lock);
 	list_del(&pool->pools);
 	if (pool->dev && list_empty(&pool->dev->dma_pools))
-		device_remove_file(pool->dev, &dev_attr_pools);
+		last_pool = 1;
+	else
+		last_pool = 0;
 	mutex_unlock(&pools_lock);
 
+	if (last_pool)
+		device_remove_file(pool->dev, &dev_attr_pools);
+
 	while (!list_empty(&pool->page_list)) {
 		struct dma_page *page;
 		page = list_entry(pool->page_list.next,
-- 
1.7.2.1

