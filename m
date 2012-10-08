Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2JHVpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:45:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab2JHVpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:45:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, jmoyer@redhat.com, tj@kernel.org
Subject: [PATCH 7/8] cfq-iosched: Use same scheduling algorithm for groups and queues
Date: Mon,  8 Oct 2012 17:44:59 -0400
Message-Id: <1349732700-2694-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349732700-2694-1-git-send-email-vgoyal@redhat.com>
References: <1349732700-2694-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, finally, this patch introduces the notion of vdisktime for queues
and uses same scheduling algorithm for queues as groups.

It does not merge the two code paths yet, but philosophy of scheduling
is same. Once this gets stablized, then we will require some more
changes to the code to actually share the scheduling code between
queue and groups.

One important change here is mapping of io priority to weights.
prio levels 0-7 are now mapped over weight range as follows.

prio	  0     1    2    3    4   5    6    7
weight	3435  2147 1342  838  524 327  204  128

This basically makes prio to weight mapping exponential using
following.

weight ~= 80 * pow(1.6, (8-prio))

This effectively also means that every prio level gets 1.6 times
of total time on disk as compared to previous one. So difference
between prio 0 and prio7 is around 26 times.

This patch does not treat queue and groups at same level. Existing
scheme of flat hierarchy continues. This series is just preparing CFQ
for more changes.

After this patch, CFQ queues get disk time share in proportion to
their weight.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.h  |    2 +-
 block/cfq-iosched.c |  166 +++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 128 insertions(+), 40 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2459730..95254dd 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -24,7 +24,7 @@
 
 /* CFQ specific, out here for blkcg->cfq_weight */
 #define CFQ_WEIGHT_MIN		10
-#define CFQ_WEIGHT_MAX		1000
+#define CFQ_WEIGHT_MAX		3500
 #define CFQ_WEIGHT_DEFAULT	500
 
 #ifdef CONFIG_BLK_CGROUP
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9ab6b4b..b0316f0 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -67,6 +67,20 @@ static struct kmem_cache *cfq_pool;
 #define sample_valid(samples)	((samples) > 80)
 #define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
 
+/*
+ * Following table maps task prio to weight using approximately following
+ * formula.
+ *
+ * weight ~= 80 * pow(1.6, (8-prio))
+ *
+ * This is basically exponential function with base of 1.6. So every level
+ * of prio gets 60% more time slice than previous level.
+ */
+static unsigned int prio_to_weight[8] = {
+	/* prio 0 */	3435,	2147,	1342,	838,
+	/* prio 4 */	524,	327, 	204, 	128
+};
+
 struct cfq_ttime {
 	unsigned long last_end_request;
 
@@ -105,7 +119,7 @@ struct cfq_queue {
 	/* service_tree member */
 	struct rb_node rb_node;
 	/* service_tree key */
-	unsigned long rb_key;
+	u64 vdisktime;
 	/* prio tree member */
 	struct rb_node p_node;
 	/* prio tree root we belong to, if any */
@@ -355,6 +369,17 @@ struct cfq_data {
 	unsigned long last_delayed_sync;
 };
 
+/*
+ * Map cfqq prio to weights.
+ * Prio 0-7 is mapped to weight range 0 - CFQ_WEIGHT_MAX
+ */
+static inline int cfq_prio_to_weight(unsigned short ioprio)
+{
+	WARN_ON(ioprio >= IOPRIO_BE_NR);
+
+	return prio_to_weight[ioprio];
+}
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *st_for(struct cfq_group *cfqg,
@@ -845,7 +870,6 @@ static inline int cfq_prio_slice(struct cfq_data *cfqd, bool sync,
 	const int base_slice = cfqd->cfq_slice[sync];
 
 	WARN_ON(prio >= IOPRIO_BE_NR);
-
 	return base_slice + (base_slice/CFQ_SLICE_SCALE * (4 - prio));
 }
 
@@ -882,7 +906,7 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
 	return min_vdisktime;
 }
 
-static void update_min_vdisktime(struct cfq_rb_root *st)
+static void update_min_vdisktime_group(struct cfq_rb_root *st)
 {
 	struct cfq_group *cfqg;
 
@@ -893,6 +917,17 @@ static void update_min_vdisktime(struct cfq_rb_root *st)
 	}
 }
 
+static void update_min_vdisktime_queue(struct cfq_rb_root *st)
+{
+	struct cfq_queue *cfqq;
+
+	if (st->left) {
+		cfqq = rb_entry(st->left, struct cfq_queue, rb_node);
+		st->min_vdisktime = max_vdisktime(st->min_vdisktime,
+						  cfqq->vdisktime);
+	}
+}
+
 /*
  * get averaged number of queues of RT/BE priority.
  * average is updated, with a formula that gives more weight to higher numbers,
@@ -1143,6 +1178,11 @@ cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
 	return cfqg->vdisktime - st->min_vdisktime;
 }
+static inline s64
+cfqq_key(struct cfq_rb_root *st, struct cfq_queue *cfqq)
+{
+	return cfqq->vdisktime - st->min_vdisktime;
+}
 
 static void
 __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
@@ -1601,52 +1641,73 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 
 #endif /* GROUP_IOSCHED */
 
-/*
- * The cfqd->service_trees holds all pending cfq_queue's that have
- * requests waiting to be processed. It is sorted in the order that
- * we will service the queues.
- */
-static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-				 bool add_front)
+static u64 calc_st_last_entry_vdisktime(struct cfq_rb_root *st)
 {
-	struct rb_node **p, *parent;
 	struct cfq_queue *__cfqq;
-	unsigned long rb_key;
+	struct rb_node *parent;
+
+	parent = rb_last(&st->rb);
+	if (parent) {
+		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
+		return (__cfqq->vdisktime + CFQ_IDLE_DELAY);
+	} else
+		return st->min_vdisktime;
+}
+
+static u64 calc_cfqq_vdisktime(struct cfq_queue *cfqq, bool add_front,
+			bool new_cfqq, struct cfq_rb_root *old_st)
+{
+
+	unsigned int charge, unaccounted_sl = 0, weight;
 	struct cfq_rb_root *st;
-	int left;
-	bool new_cfqq = RB_EMPTY_NODE(&cfqq->rb_node);
 
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
-	if (!new_cfqq) {
-		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
-		cfqq->service_tree = NULL;
-	}
-	if (!add_front) {
-		rb_key = CFQ_IDLE_DELAY;
-		parent = rb_last(&st->rb);
-		if (parent) {
-			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
-			rb_key += __cfqq->rb_key;
-		} else
-			rb_key += jiffies;
-	} else {
-		rb_key = -HZ;
-		__cfqq = cfq_rb_first(st);
-		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
-	}
+
+	/*
+	 * This queue is being added to the front. This is overriding
+	 * fairness algorithm so charging for disk time does not make
+	 * any difference
+	 */
+	if (add_front)
+		return st->min_vdisktime;
+
+	/* A new queue is being added. Just add it to end of service tree */
+	if (new_cfqq)
+		return calc_st_last_entry_vdisktime(st);
+
+	/*
+	 * A queue is being requeued. If service tree has changed, then
+	 * just put the queue at the end of current entries.
+	 * */
+	if (st != old_st)
+		return calc_st_last_entry_vdisktime(st);
+
+	/*
+	 * A cfqq is being requeued on same st. Charge the amount of slice
+	 * used
+	 */
+	weight = cfq_prio_to_weight(cfqq->ioprio);
+	charge = cfq_cfqq_slice_usage(cfqq, &unaccounted_sl);
+	return cfqq->vdisktime + cfq_scale_slice(charge, weight);
+}
+
+static void __cfq_service_tree_add(struct cfq_queue *cfqq, bool add_front)
+{
+	int left;
+	struct cfq_rb_root *st = cfqq->service_tree;
+	struct rb_node **p, *parent;
+	struct cfq_queue *__cfqq;
+	s64 key = cfqq_key(st, cfqq);
 
 	left = 1;
 	parent = NULL;
-	cfqq->service_tree = st;
 	p = &st->rb.rb_node;
 	while (*p) {
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
-		/*
-		 * sort by key, that represents service time.
-		 */
-		if (time_before(rb_key, __cfqq->rb_key))
+		if (key < cfqq_key(st, __cfqq) ||
+		    ((add_front == true) && key == cfqq_key(st, __cfqq)))
 			p = &parent->rb_left;
 		else {
 			p = &parent->rb_right;
@@ -1657,10 +1718,34 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (left)
 		st->left = &cfqq->rb_node;
 
-	cfqq->rb_key = rb_key;
 	rb_link_node(&cfqq->rb_node, parent, p);
 	rb_insert_color(&cfqq->rb_node, &st->rb);
 	st->count++;
+}
+
+/*
+ * The cfqd->st holds all pending cfq_queue's that have
+ * requests waiting to be processed. It is sorted in the order that
+ * we will service the queues.
+ */
+static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+				 bool add_front)
+{
+	struct cfq_rb_root *st, *old_st;
+	bool new_cfqq = RB_EMPTY_NODE(&cfqq->rb_node);
+
+	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
+	old_st = cfqq->service_tree;
+
+	if (!new_cfqq) {
+		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
+		cfqq->service_tree = NULL;
+	}
+
+	cfqq->vdisktime = calc_cfqq_vdisktime(cfqq, add_front, new_cfqq,
+							old_st);
+	cfqq->service_tree = st;
+	__cfq_service_tree_add(cfqq, add_front);
 	if (add_front || !new_cfqq)
 		return;
 	cfq_group_notify_queue_add(cfqd, cfqq->cfqg);
@@ -2082,6 +2167,7 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *st = st_for(cfqd->serving_group,
 			cfqd->serving_wl_class, cfqd->serving_wl_type);
+	struct cfq_queue *cfqq;
 
 	if (!cfqd->rq_queued)
 		return NULL;
@@ -2091,7 +2177,9 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 		return NULL;
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
-	return cfq_rb_first(st);
+	cfqq = cfq_rb_first(st);
+	update_min_vdisktime_queue(st);
+	return cfqq;
 }
 
 static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
@@ -2574,7 +2662,7 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
 	cfqg = cfq_rb_first_group(st);
-	update_min_vdisktime(st);
+	update_min_vdisktime_group(st);
 	return cfqg;
 }
 
-- 
1.7.7.6

