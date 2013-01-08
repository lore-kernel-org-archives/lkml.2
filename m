Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab3AHO6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:58:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:18527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab3AHO5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:57:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="188870178"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        iscsi list <open-iscsi@googlegroups.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] libiscsi: replace kfifo_init with kfifo_alloc
Date: Tue,  8 Jan 2013 22:57:51 +0800
Message-Id: <1357657073-27352-4-git-send-email-yuanhan.liu@linux.intel.com>
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

Besides that, I refactored the code a bit with the style used in
libsrp.c: allocated items once by kcalloc.

Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: iscsi list <open-iscsi@googlegroups.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/scsi/libiscsi.c |   59 ++++++++++++++++++++++++-----------------------
 include/scsi/libiscsi.h |    4 +-
 2 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..8e60f1f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2485,51 +2485,52 @@ EXPORT_SYMBOL_GPL(iscsi_eh_recover_target);
 int
 iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 {
-	int i, num_arrays = 1;
-
-	memset(q, 0, sizeof(*q));
+	int i;
+	int ret;
+	void *item;
 
-	q->max = max;
+	ret = -ENOMEM;
+	q->pool = kcalloc(max, item_size, GFP_KERNEL);
+	if (!q->pool)
+		goto err_out;
 
-	/* If the user passed an items pointer, he wants a copy of
-	 * the array. */
-	if (items)
-		num_arrays++;
-	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
-	if (q->pool == NULL)
-		return -ENOMEM;
+	ret = kfifo_alloc(&q->queue, max * sizeof(void *), GFP_KERNEL);
+	if (ret < 0)
+		goto free_pool;
 
-	kfifo_init(&q->queue, (void*)q->pool, max * sizeof(void*));
-
-	for (i = 0; i < max; i++) {
-		q->pool[i] = kzalloc(item_size, GFP_KERNEL);
-		if (q->pool[i] == NULL) {
-			q->max = i;
-			goto enomem;
+	q->items_ptr = NULL;
+	/* If the user passed an items pointer, he wants a copy of the array */
+	if (items) {
+		q->items_ptr = kcalloc(max, sizeof(void *), GFP_KERNEL);
+		if (!q->items_ptr) {
+			ret = -ENOMEM;
+			goto free_fifo;
 		}
-		kfifo_in(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		*items = q->items_ptr;
 	}
 
-	if (items) {
-		*items = q->pool + max;
-		memcpy(*items, q->pool, max * sizeof(void *));
+	for (i = 0, item = q->pool; i < max; i++, item += item_size) {
+		kfifo_in(&q->queue, &item, sizeof(void *));
+		if (q->items_ptr)
+			q->items_ptr[i] = item;
 	}
 
 	return 0;
 
-enomem:
-	iscsi_pool_free(q);
-	return -ENOMEM;
+free_fifo:
+	kfifo_free(&q->queue);
+free_pool:
+	kfree(q->pool);
+err_out:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_init);
 
 void iscsi_pool_free(struct iscsi_pool *q)
 {
-	int i;
-
-	for (i = 0; i < q->max; i++)
-		kfree(q->pool[i]);
 	kfree(q->pool);
+	kfree(q->items_ptr);
+	kfifo_free(&q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 6e33386..c4262c6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -231,8 +231,8 @@ struct iscsi_conn {
 
 struct iscsi_pool {
 	struct kfifo		queue;		/* FIFO Queue */
-	void			**pool;		/* Pool of elements */
-	int			max;		/* Max number of elements */
+	void			*pool;		/* Pool of elements */
+	void			**items_ptr;	/* element pointers */
 };
 
 /* Session's states */
-- 
1.7.7.6

