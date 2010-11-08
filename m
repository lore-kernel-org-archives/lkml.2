Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0KHHld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:41:33 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:56480 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751789Ab0KHHl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:41:29 -0500
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] dio: add a mempool for the unaligned block structures
Date: Mon,  8 Nov 2010 18:40:23 +1100
Message-Id: <1289202023-15102-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289202023-15102-1-git-send-email-david@fromorbit.com>
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We need the zero block tracking structure allocation to succeed.
Silently failing and potentially allowing data corruption is not an
option. Add a mempool to ensure this allocation will always succeed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/direct-io.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 353ac52..f8d7f6d 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -161,12 +161,22 @@ struct dio_zero_block_head {
 static struct dio_zero_block_head dio_zero_blocks[DIO_ZERO_BLOCK_NR];
 #define to_dio_zero_head(zb)	(&dio_zero_blocks[zb % DIO_ZERO_BLOCK_NR])
 
+/* a small mempool just to guarantee progress. */
+#define DIO_ZERO_BLOCK_ENTRIES	2
+static mempool_t *dio_zero_block_pool;
+
 
 static int __init
 dio_init_zero_block(void)
 {
 	int i;
 
+	dio_zero_block_pool = mempool_create_kmalloc_pool(
+					DIO_ZERO_BLOCK_ENTRIES,
+					sizeof(struct dio_zero_block));
+	if (!dio_zero_block_pool)
+		panic("dio: can't create zero block pool");
+
 	for (i = 0; i < DIO_ZERO_BLOCK_NR; i++) {
 		spin_lock_init(&dio_zero_blocks[i].lock);
 		INIT_LIST_HEAD(&dio_zero_blocks[i].list);
@@ -184,9 +194,7 @@ dio_start_zero_block(struct dio *dio, sector_t zero_block)
 	struct dio_zero_block_head *zbh = to_dio_zero_head(zero_block);
 	struct dio_zero_block *zb;
 
-	zb = kmalloc(sizeof(*zb), GFP_NOIO);
-	if (!zb)
-		return;
+	zb = mempool_alloc(dio_zero_block_pool, GFP_NOIO);
 	INIT_LIST_HEAD(&zb->dio_list);
 	init_waitqueue_head(&zb->wq);
 	zb->zero_block = zero_block;
-- 
1.7.2.3

