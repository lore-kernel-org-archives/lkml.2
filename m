Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3AHO5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:57:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:18527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab3AHO5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:57:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="188870175"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] libsrp: replace kfifo_init with kfifo_alloc
Date: Tue,  8 Jan 2013 22:57:50 +0800
Message-Id: <1357657073-27352-3-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfifo_init will use a pre-allocated buffer as fifo buffer; the buffer
size is determinted at caller side. While, kfifo will maintain a real
kfifo buffer size(rounddown power of 2 aligned). So, the two size may
not be equal.

So, if max is not power of 2, this code will not work. As it assume the
kfifo is able to hold max elments, but it is able to hold less than max
only.

To be safe, we should use kfifo_alloc instead, though it will not
address this issue. But a later patch to refactor kfifo_alloc to be a
log API will fix it.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/scsi/libsrp.c |   22 ++++++++++------------
 include/scsi/libsrp.h |    1 -
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 0707ecd..63db792 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -50,34 +50,32 @@ static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
 			     struct srp_buf **ring)
 {
 	int i;
+	int ret;
 	struct iu_entry *iue;
 
-	q->pool = kcalloc(max, sizeof(struct iu_entry *), GFP_KERNEL);
+	q->pool = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
 	if (!q->pool)
 		return -ENOMEM;
-	q->items = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
-	if (!q->items)
-		goto free_pool;
+
+	ret = kfifo_alloc(&q->queue, max * sizeof(void *), GFP_KERNEL);
+	if (ret < 0) {
+		kfree(q->pool);
+		return ret;
+	}
 
 	spin_lock_init(&q->lock);
-	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
-	for (i = 0, iue = q->items; i < max; i++) {
+	for (i = 0, iue = q->pool; i < max; i++) {
 		kfifo_in(&q->queue, (void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
 	return 0;
-
-	kfree(q->items);
-free_pool:
-	kfree(q->pool);
-	return -ENOMEM;
 }
 
 static void srp_iu_pool_free(struct srp_queue *q)
 {
-	kfree(q->items);
+	kfifo_free(&q->queue);
 	kfree(q->pool);
 }
 
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
index f4105c9..999b1e7 100644
--- a/include/scsi/libsrp.h
+++ b/include/scsi/libsrp.h
@@ -21,7 +21,6 @@ struct srp_buf {
 
 struct srp_queue {
 	void *pool;
-	void *items;
 	struct kfifo queue;
 	spinlock_t lock;
 };
-- 
1.7.7.6

