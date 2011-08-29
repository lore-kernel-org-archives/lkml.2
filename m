Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1H2XXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:23:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:31507 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab1H2XXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="46259901"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/11] DIO: Use a slab cache for struct dio
Date: Mon, 29 Aug 2011 16:23:15 -0700
Message-Id: <1314660202-661-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314660202-661-1-git-send-email-andi@firstfloor.org>
References: <1314660202-661-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

A direct slab call is slightly faster than kmalloc and can be better cached
per CPU. It also avoids rounding to the next kmalloc slab.

In addition this enforces cache line alignment for struct dio to avoid
any false sharing.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8f23db3..e91ac83 100644
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
 
 static void __inode_dio_wait(struct inode *inode)
 {
@@ -330,7 +332,7 @@ static void dio_bio_end_aio(struct bio *bio, int error)
 
 	if (remaining == 0) {
 		dio_complete(dio, dio->iocb->ki_pos, 0, true);
-		kfree(dio);
+		kmem_cache_free(dio_cache, dio);
 	}
 }
 
@@ -1178,7 +1180,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 
 	if (ret2 == 0) {
 		ret = dio_complete(dio, offset, ret, false);
-		kfree(dio);
+		kmem_cache_free(dio_cache, dio);
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
 
@@ -1254,7 +1256,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (rw == READ && end == offset)
 		return 0;
 
-	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
+	dio = kmem_cache_alloc(dio_cache, GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;
@@ -1278,7 +1280,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 							      end - 1);
 			if (retval) {
 				mutex_unlock(&inode->i_mutex);
-				kfree(dio);
+				kmem_cache_free(dio_cache, dio);
 				goto out;
 			}
 		}
@@ -1306,3 +1308,10 @@ out:
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

