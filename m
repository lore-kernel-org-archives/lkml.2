Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1HCTlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:41:22 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:54004 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab1HCTlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:41:17 -0400
Subject: [PATCH] CFQ: clarify code touching 'cic_index' a bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 03 Aug 2011 21:41:12 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.3 (3.1.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312400476.22854.1.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 block/cfq-iosched.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..601a24c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3948,39 +3948,38 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	kfree(cfqd);
 }
 
-static int cfq_alloc_cic_index(void)
+static int cfq_alloc_cic_index(int *cic_index)
 {
-	int index, error;
+	int error;
 
 	do {
 		if (!ida_pre_get(&cic_index_ida, GFP_KERNEL))
 			return -ENOMEM;
 
 		spin_lock(&cic_index_lock);
-		error = ida_get_new(&cic_index_ida, &index);
+		error = ida_get_new(&cic_index_ida, cic_index);
 		spin_unlock(&cic_index_lock);
 		if (error && error != -EAGAIN)
 			return error;
 	} while (error);
 
-	return index;
+	return 0;
 }
 
 static void *cfq_init_queue(struct request_queue *q)
 {
 	struct cfq_data *cfqd;
-	int i, j;
+	int i, j, cic_index;
 	struct cfq_group *cfqg;
 	struct cfq_rb_root *st;
 
-	i = cfq_alloc_cic_index();
-	if (i < 0)
+	if (cfq_alloc_cic_index(&cic_index))
 		return NULL;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd) {
 		spin_lock(&cic_index_lock);
-		ida_remove(&cic_index_ida, i);
+		ida_remove(&cic_index_ida, cic_index);
 		spin_unlock(&cic_index_lock);
 		return NULL;
 	}
@@ -3989,7 +3988,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * Don't need take queue_lock in the routine, since we are
 	 * initializing the ioscheduler, and nobody is using cfqd
 	 */
-	cfqd->cic_index = i;
+	cfqd->cic_index = cic_index;
 
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
-- 
1.7.6



