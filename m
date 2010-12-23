Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0LWCpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:45:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:45084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0LWCpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:45:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,217,1291622400"; 
   d="scan'208";a="586504854"
Subject: [PATCH 2/2]block cfq: don't use atomic_t for cfq_group
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, vgoyal@redhat.com, jmoyer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 10:45:35 +0800
Message-ID: <1293072335.10593.22.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_group->ref is used with queue_lock hold, the only exception is
cfq_set_request, which looks like a bug to me, so ref doesn't need
to be an atomic and atomic operation is slower.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2010-12-23 10:22:21.000000000 +0800
+++ linux/block/cfq-iosched.c	2010-12-23 10:23:03.000000000 +0800
@@ -209,7 +209,7 @@ struct cfq_group {
 	struct blkio_group blkg;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct hlist_node cfqd_node;
-	atomic_t ref;
+	int ref;
 #endif
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
@@ -1026,7 +1026,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfq
 	 * elevator which will be dropped by either elevator exit
 	 * or cgroup deletion path depending on who is exiting first.
 	 */
-	atomic_set(&cfqg->ref, 1);
+	cfqg->ref = 1;
 
 	/*
 	 * Add group onto cgroup list. It might happen that bdi->dev is
@@ -1071,7 +1071,7 @@ static struct cfq_group *cfq_get_cfqg(st
 
 static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
 {
-	atomic_inc(&cfqg->ref);
+	cfqg->ref++;
 	return cfqg;
 }
 
@@ -1083,7 +1083,7 @@ static void cfq_link_cfqq_cfqg(struct cf
 
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
-	atomic_inc(&cfqq->cfqg->ref);
+	cfqq->cfqg->ref++;
 }
 
 static void cfq_put_cfqg(struct cfq_group *cfqg)
@@ -1091,8 +1091,9 @@ static void cfq_put_cfqg(struct cfq_grou
 	struct cfq_rb_root *st;
 	int i, j;
 
-	BUG_ON(atomic_read(&cfqg->ref) <= 0);
-	if (!atomic_dec_and_test(&cfqg->ref))
+	BUG_ON(cfqg->ref <= 0);
+	cfqg->ref--;
+	if (cfqg->ref)
 		return;
 	for_each_cfqg_st(cfqg, i, j, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
@@ -1200,7 +1201,7 @@ static void cfq_service_tree_add(struct
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 		cfqq->orig_cfqg = cfqq->cfqg;
 		cfqq->cfqg = &cfqd->root_group;
-		atomic_inc(&cfqd->root_group.ref);
+		cfqd->root_group.ref++;
 		group_changed = 1;
 	} else if (!cfqd->cfq_group_isolation
 		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
@@ -3645,6 +3646,7 @@ cfq_set_request(struct request_queue *q,
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
 	unsigned long flags;
+	struct cfq_group *cfqg;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
@@ -3683,12 +3685,13 @@ new_queue:
 
 	cfqq->allocated[rw]++;
 	cfqq->ref++;
+	cfqg = cfq_ref_get_cfqg(cfqq->cfqg);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	rq->elevator_private = cic;
 	rq->elevator_private2 = cfqq;
-	rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
+	rq->elevator_private3 = cfqg;
 	return 0;
 
 queue_fail:
@@ -3886,7 +3889,7 @@ static void *cfq_init_queue(struct reque
 	 * Take a reference to root group which we never drop. This is just
 	 * to make sure that cfq_put_cfqg() does not try to kfree root group
 	 */
-	atomic_set(&cfqg->ref, 1);
+	cfqg->ref = 1;
 	rcu_read_lock();
 	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
 					(void *)cfqd, 0);


