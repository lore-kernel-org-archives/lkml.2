Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0C2GJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 02:09:56 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55998 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab0C2GJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 02:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=q6JvQ0Y2NJzKdNMGpaqy7gihNRwRyIftXF8Fy/6cEnfh8Ue75Nte3PbUI0/q1W43s2
         +Vu+EfKCNCq8f/91UwVChdElZCVKxKg5sLp0175Pnx6tn97tbGccTRIO7YplokWqxAMf
         MFvuH7+LiApZxL+9cXl7QDRYzQriKlSwUMOVM=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/6] blkdev: optimize discard payload utilization
Date: Mon, 29 Mar 2010 10:09:25 +0400
Message-Id: <1269842965-4700-7-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269842965-4700-6-git-send-email-dmonakhov@openvz.org>
References: <1269842965-4700-1-git-send-email-dmonakhov@openvz.org>
 <1269842965-4700-2-git-send-email-dmonakhov@openvz.org>
 <1269842965-4700-3-git-send-email-dmonakhov@openvz.org>
 <1269842965-4700-4-git-send-email-dmonakhov@openvz.org>
 <1269842965-4700-5-git-send-email-dmonakhov@openvz.org>
 <1269842965-4700-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently each discard bio require one page as payload storage
But only one sector is actually used. Let's share allocated page
with several requests. A bad thing about implementation is that
it use global spinlock. But we may easily to switch to per-cpu
buckets if it becomes a bottleneck.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 5326d91..ffa07ee 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -9,6 +9,8 @@
 
 #include "blk.h"
 
+static DEFINE_SPINLOCK(payload_mem_lock);
+
 struct bio_batch
 {
 	atomic_t 		done;
@@ -135,15 +137,48 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
 
 static int add_discard_payload(struct bio *bio, gfp_t gfp_mask, int len)
 {
+	static struct page *cur_page = NULL;
+	static int cur_offset = 0;
 	struct page *page;
+	int offset;
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-
-	page = alloc_page(gfp_mask | __GFP_ZERO);
-	if (!page)
+again:
+	spin_lock(&payload_mem_lock);
+	if (cur_offset + len > PAGE_SIZE)
+		/* There is no more space in the page */
+		if (cur_page) {
+			put_page(cur_page);
+			cur_page = NULL;
+			cur_offset = 0;
+		}
+	if (!cur_page) {
+		spin_unlock(&payload_mem_lock);
+		page = alloc_page(gfp_mask | __GFP_ZERO);
+		if (!page)
 			return -ENOMEM;
-	if (bio_add_pc_page(q, bio, page, len, 0) < len)
-		BUG();
+
+		spin_lock(&payload_mem_lock);
+		/*
+		 * Check cur_page one more time after we reacquired the lock.
+		 * Because it may be changed by other task.
+		 */
+		if (cur_page) {
+			spin_unlock(&payload_mem_lock);
+			put_page(page);
+			goto again;
+		} else
+			cur_page = page;
+	}
+	page = cur_page;
 	get_page(page);
+	offset = cur_offset;
+	cur_offset += len;
+
+	spin_unlock(&payload_mem_lock);
+
+	if (bio_add_pc_page(q, bio, page, len, offset) < len)
+		BUG();
+
 	return 0;
 }
 
-- 
1.6.6.1

