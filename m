Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2KVTKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:10:05 -0500
Received: from dupo.coraid.com ([208.71.232.133]:60593 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932098Ab2KVTKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:10:02 -0500
Message-Id: <f72f2210c8897c62ea53061c3e7fb40d3419eddc.1353518444.git.ecashin@coraid.com>
In-Reply-To: <cover.1353518444.git.ecashin@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 2/8] aoe: remove vestigial request queue allocation
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 21 Nov 2012 19:56:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the aoe driver was an I/O request handler, it was a
make_request-style block driver.  Even so, there was a problem
where sysfs expected a request queue to exist, so one was
provided in commit 7135a71b19be1fa, "aoe: allocate unused
request_queue for sysfs".

During the transition to the request-handler style, a patch was
merged that was based on a driver without the noop queue, and the
noop queue remained in place after the patch was merged, even
though a new functional queue was introduced by the patch,
allocated through blk_init_queue.

The user impact is a memory leak proportional to the number of
AoE targets discovered.  This patch removes the memory leak and
cleans up vestiges of the old do-nothing queue from the
aoeblk_gdalloc function.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 7ba0fcf..57ac72c 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -278,18 +278,12 @@ aoeblk_gdalloc(void *vp)
 	if (q == NULL) {
 		pr_err("aoe: cannot allocate block queue for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
-		mempool_destroy(mp);
-		goto err_disk;
+		goto err_mempool;
 	}
 
-	d->blkq = blk_alloc_queue(GFP_KERNEL);
-	if (!d->blkq)
-		goto err_mempool;
-	d->blkq->backing_dev_info.name = "aoe";
-	if (bdi_init(&d->blkq->backing_dev_info))
-		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
-	blk_queue_max_hw_sectors(d->blkq, BLK_DEF_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
+	q->backing_dev_info.name = "aoe";
 	q->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
 	d->bufpool = mp;
 	d->blkq = gd->queue = q;
@@ -314,11 +308,8 @@ aoeblk_gdalloc(void *vp)
 	aoedisk_add_sysfs(d);
 	return;
 
-err_blkq:
-	blk_cleanup_queue(d->blkq);
-	d->blkq = NULL;
 err_mempool:
-	mempool_destroy(d->bufpool);
+	mempool_destroy(mp);
 err_disk:
 	put_disk(gd);
 err:
-- 
1.7.1

