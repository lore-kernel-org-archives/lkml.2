Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0KHHlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:41:32 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:46006 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754025Ab0KHHl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:41:29 -0500
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dio: scale unaligned IO tracking via multiple lists
Date: Mon,  8 Nov 2010 18:40:22 +1100
Message-Id: <1289202023-15102-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289202023-15102-1-git-send-email-david@fromorbit.com>
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To avoid concerns that a single list and lock tracking the unaligned
IOs will not scale appropriately, create multiple lists and locks
and chose them by hashing the unaligned block being zeroed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/direct-io.c |   49 ++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1a69efd..353ac52 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -152,8 +152,28 @@ struct dio_zero_block {
 	atomic_t	ref;		/* reference count */
 };
 
-static DEFINE_SPINLOCK(dio_zero_block_lock);
-static LIST_HEAD(dio_zero_block_list);
+#define DIO_ZERO_BLOCK_NR	37LL
+struct dio_zero_block_head {
+	struct list_head	list;
+	spinlock_t		lock;
+};
+
+static struct dio_zero_block_head dio_zero_blocks[DIO_ZERO_BLOCK_NR];
+#define to_dio_zero_head(zb)	(&dio_zero_blocks[zb % DIO_ZERO_BLOCK_NR])
+
+
+static int __init
+dio_init_zero_block(void)
+{
+	int i;
+
+	for (i = 0; i < DIO_ZERO_BLOCK_NR; i++) {
+		spin_lock_init(&dio_zero_blocks[i].lock);
+		INIT_LIST_HEAD(&dio_zero_blocks[i].list);
+	}
+	return 0;
+}
+subsys_initcall(dio_init_zero_block);
 
 /*
  * Add a filesystem block to the list of blocks we are tracking.
@@ -161,6 +181,7 @@ static LIST_HEAD(dio_zero_block_list);
 static void
 dio_start_zero_block(struct dio *dio, sector_t zero_block)
 {
+	struct dio_zero_block_head *zbh = to_dio_zero_head(zero_block);
 	struct dio_zero_block *zb;
 
 	zb = kmalloc(sizeof(*zb), GFP_NOIO);
@@ -172,9 +193,9 @@ dio_start_zero_block(struct dio *dio, sector_t zero_block)
 	zb->dio = dio;
 	atomic_set(&zb->ref, 1);
 
-	spin_lock(&dio_zero_block_lock);
-	list_add(&zb->dio_list, &dio_zero_block_list);
-	spin_unlock(&dio_zero_block_lock);
+	spin_lock(&zbh->lock);
+	list_add(&zb->dio_list, &zbh->list);
+	spin_unlock(&zbh->lock);
 }
 
 static void
@@ -193,21 +214,22 @@ dio_drop_zero_block(struct dio_zero_block *zb)
 static int
 dio_wait_zero_block(struct dio *dio, sector_t zero_block)
 {
+	struct dio_zero_block_head *zbh = to_dio_zero_head(zero_block);
 	struct dio_zero_block *zb;
 
-	spin_lock(&dio_zero_block_lock);
-	list_for_each_entry(zb, &dio_zero_block_list, dio_list) {
+	spin_lock(&zbh->lock);
+	list_for_each_entry(zb, &zbh->list, dio_list) {
 		if (zb->dio->inode != dio->inode)
 			continue;
 		if (zb->zero_block != zero_block)
 			continue;
 		atomic_inc(&zb->ref);
-		spin_unlock(&dio_zero_block_lock);
+		spin_unlock(&zbh->lock);
 		wait_event(zb->wq, (list_empty(&zb->dio_list)));
 		dio_drop_zero_block(zb);
 		return 1;
 	}
-	spin_unlock(&dio_zero_block_lock);
+	spin_unlock(&zbh->lock);
 	return 0;
 }
 
@@ -216,21 +238,22 @@ dio_wait_zero_block(struct dio *dio, sector_t zero_block)
  */
 static void dio_end_zero_block(struct dio *dio, sector_t zero_block)
 {
+	struct dio_zero_block_head *zbh = to_dio_zero_head(zero_block);
 	struct dio_zero_block *zb;
 
-	spin_lock(&dio_zero_block_lock);
-	list_for_each_entry(zb, &dio_zero_block_list, dio_list) {
+	spin_lock(&zbh->lock);
+	list_for_each_entry(zb, &zbh->list, dio_list) {
 		if (zb->dio->inode != dio->inode)
 			continue;
 		if (zb->zero_block != zero_block)
 			continue;
 		list_del_init(&zb->dio_list);
-		spin_unlock(&dio_zero_block_lock);
+		spin_unlock(&zbh->lock);
 		wake_up(&zb->wq);
 		dio_drop_zero_block(zb);
 		return;
 	}
-	spin_unlock(&dio_zero_block_lock);
+	spin_unlock(&zbh->lock);
 }
 
 /*
-- 
1.7.2.3

