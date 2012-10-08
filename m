Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2JHVrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:47:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab2JHVpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:45:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, jmoyer@redhat.com, tj@kernel.org
Subject: [PATCH 4/8] cfq-iosched: Put new queue at the end of servie tree always
Date: Mon,  8 Oct 2012 17:44:56 -0400
Message-Id: <1349732700-2694-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349732700-2694-1-git-send-email-vgoyal@redhat.com>
References: <1349732700-2694-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cfq does round robin among cfqq and allocates bigger slices
to higher prio queue. But it also does additional logic of putting
higher priority queues ahead of lower priority queues in the service
tree. cfq_slice_offset() determines the postion of a queue in the
service tree.

I think it was done so that higher prio queues can get even higher
share of disk. Other advantage of it could be trying to provide service
differentiation on SSD where we don't idle on queues. So instead of
trying to provide bigger slice lenght for higher prio queue, one can
try to schedule the queue more number of times.

I don't think in practice it will work very well and reason being that
there are not many queues on service tree. As we don't idle, we dispatch
the request and expire the queue. So if queue depth is 32, ideally you
need to have more than 32 cfqq doing IO (assuming each queue dipatches
one read and waits for it to finish). And after that one can hope to
see some service differentiaton and that too very unpredictable. So
I would not count on it and rather keep it simple that on SSD we don't
get ioprio differentiation.

Even after we move to vdisktime logic, one can introduce above kind
of appriximations where higher prio/weight queue is not put at the
end but instead we give it some vdisktime boost.

So this patch puts every new queue at the end of service tree by
default. Existing queues get their position in the tree depending
on how much slice did they use recently and what's their prio/weight.

This patch only introduces the functionality of adding queues at
the end of service tree. Later patches will introduce the functionality
of determining vdisktime (hence position in service tree) based on
slice used and weight.

If a queue is being requeued, then it will already be on service tree
and we can't determine the rb_key of last element using cfq_rb_last().
So we always remove the queue from service tree first.

This is just an intermediate patch to show clearly how I am chaning
existing functionality. Did not want to lump it together with bigger
patches.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   49 ++++++++++++++++---------------------------------
 1 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 58f1bdc..7136ede 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1139,16 +1139,6 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	return cfq_choose_req(cfqd, next, prev, blk_rq_pos(last));
 }
 
-static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
-				      struct cfq_queue *cfqq)
-{
-	/*
-	 * just an approximation, should be ok.
-	 */
-	return (cfqq->cfqg->nr_cfqq - 1) * (cfq_prio_slice(cfqd, 1, 0) -
-		       cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
-}
-
 static inline s64
 cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
@@ -1628,41 +1618,34 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	bool new_cfqq = RB_EMPTY_NODE(&cfqq->rb_node);
 
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
-	if (cfq_class_idle(cfqq)) {
+	if (!new_cfqq) {
+		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
+		cfqq->service_tree = NULL;
+	}
+	if (!add_front) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&st->rb);
-		if (parent && parent != &cfqq->rb_node) {
+		if (parent) {
 			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 			rb_key += __cfqq->rb_key;
 		} else
 			rb_key += jiffies;
-	} else if (!add_front) {
-		/*
-		 * Get our rb key offset. Subtract any residual slice
-		 * value carried from last service. A negative resid
-		 * count indicates slice overrun, and this should position
-		 * the next service time further away in the tree.
-		 */
-		rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
-		rb_key -= cfqq->slice_resid;
-		cfqq->slice_resid = 0;
+		if (!cfq_class_idle(cfqq)) {
+			/*
+			 * Subtract any residual slice * value carried from
+			 * last service. A negative resid count indicates
+			 * slice overrun, and this should position
+			 * the next service time further away in the tree.
+			 */
+			rb_key -= cfqq->slice_resid;
+			cfqq->slice_resid = 0;
+		}
 	} else {
 		rb_key = -HZ;
 		__cfqq = cfq_rb_first(st);
 		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
 	}
 
-	if (!new_cfqq) {
-		/*
-		 * same position, nothing more to do
-		 */
-		if (rb_key == cfqq->rb_key && cfqq->service_tree == st)
-			return;
-
-		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
-		cfqq->service_tree = NULL;
-	}
-
 	left = 1;
 	parent = NULL;
 	cfqq->service_tree = st;
-- 
1.7.7.6

