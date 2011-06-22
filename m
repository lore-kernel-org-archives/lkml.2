Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab1FVTUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:20:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:38457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504Ab1FVTUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,407,1304319600"; 
   d="scan'208";a="16980949"
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dehrenberg@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/6] DIO: Use a slab cache for struct dio
Date: Wed, 22 Jun 2011 12:18:40 -0700
Message-Id: <1308770322-22565-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
References: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

A direct slab call is slightly faster than kmalloc and can be better cached
per CPU. It also avoids rounding to the next kmalloc slab.

In addition this enforces cache line alignment for struct dio to avoid
any false sharing.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 03deca3..49dbd06 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -140,7 +140,9 @@ struct dio {
 	 * wish that they not be zeroed.
 	 */
 	struct page *pages[DIO_PAGES];	/* page buffer */	
-};
+} ____cacheline_aligned_in_smp;
+
+static struct kmem_cache *dio_cache __read_mostly;
 
 /*
  * How many pages are in the queue?
@@ -288,7 +290,7 @@ static void dio_bio_end_aio(struct bio *bio, int error)
 
 	if (remaining == 0) {
 		dio_complete(dio, dio->iocb->ki_pos, 0, true);
-		kfree(dio);
+		kmem_cache_free(dio_cache, dio);
 	}
 }
 
@@ -1139,7 +1141,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 
 	if (ret2 == 0) {
 		ret = dio_complete(dio, offset, ret, false);
-		kfree(dio);
+		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
 
@@ -1210,7 +1212,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		}
 	}
 
-	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
+	dio = kmem_cache_alloc(dio_cache, GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;
@@ -1235,7 +1237,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 							      end - 1);
 			if (retval) {
 				mutex_unlock(&inode->i_mutex);
-				kfree(dio);
+				kmem_cache_free(dio_cache, dio);
 				goto out;
 			}
 		}
@@ -1264,3 +1266,10 @@ out:
 	return retval;
 }
 EXPORT_SYMBOL(__blockdev_direct_IO);
+
+static __init int dio_init(void)
+{
+	dio_cache = KMEM_CACHE(dio, SLAB_PANIC);
+	return 0;
+}
+module_init(dio_init)
-- 
1.7.4.4

