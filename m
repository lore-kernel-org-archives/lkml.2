Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0LMBoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 20:44:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756540Ab0LMBow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:44:52 -0500
Message-ID: <4D057AAA.6020800@cn.fujitsu.com>
Date: Mon, 13 Dec 2010 09:45:14 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] cfq-iosched: Add flat mode and switch between two modes
 by "use_hierarchy"
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D01C6AB.9040807@cn.fujitsu.com>
In-Reply-To: <4D01C6AB.9040807@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:44:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:44:51,
	Serialize complete at 2010-12-13 09:44:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add flat CFQ group scheduling mode and switch between two modes 
by "use_hierarchy". Currently, It works when there's only root
group available.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c  |    2 +-
 block/cfq-iosched.c |  357 +++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 276 insertions(+), 83 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9747ebb..baa286b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -27,7 +27,7 @@ static LIST_HEAD(blkio_list);
 
 struct blkio_cgroup blkio_root_cgroup = {
 		.weight = 2*BLKIO_WEIGHT_DEFAULT,
-		.use_hierarchy = 1,
+		.use_hierarchy = 0,
 	};
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 08323f5..cbd23f6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -241,6 +241,9 @@ struct cfq_data {
 	/* cfq group schedule in flat or hierarchy manner. */
 	bool use_hierarchy;
 
+	/* Service tree for cfq group flat scheduling mode. */
+	struct cfq_rb_root flat_service_tree;
+
 	/*
 	 * The priority currently being served
 	 */
@@ -647,12 +650,16 @@ cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	struct cfq_entity *cfqe = &cfqg->cfqe;
 	struct cfq_rb_root *st = cfqe->service_tree;
 
-	if (st)
-		return cfq_target_latency * cfqe->weight
-			/ st->total_weight;
-	else
-		/* If this is the root group, give it a full slice. */
-		return cfq_target_latency;
+	if (cfqd->use_hierarchy) {
+		if (st)
+			return cfq_target_latency * cfqe->weight
+				/ st->total_weight;
+		else
+			/* If this is the root group, give it a full slice. */
+			return cfq_target_latency;
+	} else {
+		return cfq_target_latency * cfqe->weight / st->total_weight;
+	}
 }
 
 static inline void
@@ -915,24 +922,50 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	/*
 	 * Root group doesn't belongs to any service
 	 */
-	if (cfqg == &cfqd->root_group)
+	if (cfqd->use_hierarchy && cfqg == &cfqd->root_group)
 		return;
 
 	if (!RB_EMPTY_NODE(&cfqe->rb_node))
 		return;
 
-	/*
-	 * Enqueue this group and its ancestors onto their service tree.
-	 */
-	while (cfqe && cfqe->parent) {
+	if (cfqd->use_hierarchy) {
+		/*
+		 * Enqueue this group and its ancestors onto their service
+		 * tree.
+		 */
+		while (cfqe && cfqe->parent) {
+			if (!RB_EMPTY_NODE(&cfqe->rb_node))
+				return;
+
+			/*
+			 * Currently put the group at the end. Later implement
+			 * something so that groups get lesser vtime based on
+			 * their weights, so that if group does not loose all
+			 * if it was not continously backlogged.
+			 */
+			st = cfqe->service_tree;
+			n = rb_last(&st->rb);
+			if (n) {
+				entity = rb_entry_entity(n);
+				cfqe->vdisktime = entity->vdisktime +
+					CFQ_IDLE_DELAY;
+			} else
+				cfqe->vdisktime = st->min_vdisktime;
+
+			cfq_entity_service_tree_add(st, cfqe);
+			cfqe = cfqe->parent;
+			__cfqg = cfqg_of_entity(cfqe);
+			__cfqg->nr_subgp++;
+		}
+	} else {
 		if (!RB_EMPTY_NODE(&cfqe->rb_node))
 			return;
 
 		/*
 		 * Currently put the group at the end. Later implement
-		 * something so that groups get lesser vtime based on their
-		 * weights, so that if group does not loose all if it was not
-		 * continously backlogged.
+		 * something so that groups get lesser vtime based on
+		 * their weights, so that if group does not loose all
+		 * if it was not continously backlogged.
 		 */
 		st = cfqe->service_tree;
 		n = rb_last(&st->rb);
@@ -943,10 +976,11 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		} else
 			cfqe->vdisktime = st->min_vdisktime;
 
-		cfq_entity_service_tree_add(st, cfqe);
-		cfqe = cfqe->parent;
-		__cfqg = cfqg_of_entity(cfqe);
-		__cfqg->nr_subgp++;
+		/*
+		 * For flat mode, all cfq groups schedule on the global service
+		 * tree(cfqd->flat_service_tree).
+		 */
+		cfq_entity_service_tree_add(cfqe->service_tree, cfqe);
 	}
 }
 
@@ -975,35 +1009,46 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	BUG_ON(cfqg->nr_cfqq < 1);
 	cfqg->nr_cfqq--;
 
-	/*
-	 * Root group doesn't belongs to any service
-	 */
-	if (cfqg == &cfqd->root_group)
-		return;
-
 	/* If there are other cfq queues under this group, don't delete it */
 	if (cfqg->nr_cfqq)
 		return;
 
-	/* If child group exists, don't dequeue it */
-	if (cfqg->nr_subgp)
-		return;
 
-	/*
-	 * Dequeue this group and its ancestors from their service tree.
-	 */
-	while (cfqe && cfqe->parent) {
-		__cfqg = cfqg_of_entity(cfqe);
-		p_cfqg = cfqg_of_entity(cfqe->parent);
-		cfq_entity_service_tree_del(cfqe->service_tree, cfqe);
-		cfq_blkiocg_update_dequeue_stats(&__cfqg->blkg, 1);
-		cfq_log_cfqg(cfqd, __cfqg, "del_from_rr group");
-		__cfqg->saved_workload_slice = 0;
-		cfqe = cfqe->parent;
-		p_cfqg->nr_subgp--;
-		if (p_cfqg->nr_cfqq || p_cfqg->nr_subgp)
+	if (cfqd->use_hierarchy) {
+		/*
+		 * Root group doesn't belongs to any service
+		 */
+		if (cfqg == &cfqd->root_group)
+			return;
+
+		/* If child group exists, don't dequeue it */
+		if (cfqg->nr_subgp)
 			return;
+
+		/*
+		 * Dequeue this group and its ancestors from their service
+		 * tree.
+		 */
+		while (cfqe && cfqe->parent) {
+			__cfqg = cfqg_of_entity(cfqe);
+			p_cfqg = cfqg_of_entity(cfqe->parent);
+			cfq_entity_service_tree_del(cfqe->service_tree, cfqe);
+			cfq_blkiocg_update_dequeue_stats(&__cfqg->blkg, 1);
+			cfq_log_cfqg(cfqd, __cfqg, "del_from_rr group");
+			__cfqg->saved_workload_slice = 0;
+			cfqe = cfqe->parent;
+			p_cfqg->nr_subgp--;
+			if (p_cfqg->nr_cfqq || p_cfqg->nr_subgp)
+				return;
+		}
+	} else {
+		/* Dequeued from flat service tree. */
+		cfq_entity_service_tree_del(cfqe->service_tree, cfqe);
+		cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
+		cfqg->saved_workload_slice = 0;
+		cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 	}
+
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
@@ -1048,19 +1093,31 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
 		charge = cfqq->allocated_slice;
 
-	/*
-	 * Update the vdisktime on the whole chain.
-	 */
-	while (cfqe && cfqe->parent) {
-		struct cfq_rb_root *st = cfqe->service_tree;
+	if (cfqd->use_hierarchy) {
+		/*
+		 * Update the vdisktime on the whole chain.
+		 */
+		while (cfqe && cfqe->parent) {
+			struct cfq_rb_root *st = cfqe->service_tree;
 
-		/* Can't update vdisktime while group is on service tree */
-		__cfq_entity_service_tree_del(st, cfqe);
+			/*
+			 * Can't update vdisktime while group is on service
+			 * tree.
+			 */
+			__cfq_entity_service_tree_del(st, cfqe);
+			cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
+			__cfq_entity_service_tree_add(st, cfqe);
+			st->count++;
+			cfqe->reposition_time = jiffies;
+			cfqe = cfqe->parent;
+		}
+	} else {
+		/* For flat mode, just charge its self */
+		__cfq_entity_service_tree_del(cfqe->service_tree, cfqe);
 		cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
-		__cfq_entity_service_tree_add(st, cfqe);
-		st->count++;
+		__cfq_entity_service_tree_add(cfqe->service_tree, cfqe);
+		cfqe->service_tree->count++;
 		cfqe->reposition_time = jiffies;
-		cfqe = cfqe->parent;
 	}
 
 
@@ -1097,13 +1154,36 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 	cfqg_of_blkg(blkg)->cfqe.weight = weight;
 }
 
+static int cfq_forced_dispatch(struct cfq_data *cfqd);
+
 void
 cfq_update_blkio_use_hierarchy(struct blkio_group *blkg, bool val)
 {
+	unsigned long flags;
 	struct cfq_group *cfqg;
+	struct cfq_data *cfqd;
+	struct cfq_entity *cfqe;
+	int nr;
 
+	/* Get root group here */
 	cfqg = cfqg_of_blkg(blkg);
+	cfqd = cfqg->cfqd;
+
+	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+
+	/* Drain all requests */
+	nr = cfq_forced_dispatch(cfqd);
+
+	cfqe = &cfqg->cfqe;
+
+	if (!val)
+		cfqe->service_tree = &cfqd->flat_service_tree;
+	else
+		cfqe->service_tree = NULL;
+
 	cfqg->cfqd->use_hierarchy = val;
+
+	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
 static void init_cfqe(struct blkio_cgroup *blkcg,
@@ -1164,6 +1244,12 @@ static void cfqg_set_parent(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfqe = &cfqg->cfqe;
 
+	if (!p_cfqg) {
+		cfqe->service_tree = &cfqd->flat_service_tree;
+		cfqe->parent = NULL;
+		return;
+	}
+
 	p_cfqe = &p_cfqg->cfqe;
 
 	cfqe->parent = p_cfqe;
@@ -1223,6 +1309,36 @@ int cfqg_chain_alloc(struct cfq_data *cfqd, struct cgroup *cgroup)
 	return 0;
 }
 
+static struct cfq_group *cfqg_alloc(struct cfq_data *cfqd,
+				    struct cgroup *cgroup)
+{
+	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
+	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
+	unsigned int major, minor;
+	struct cfq_group *cfqg;
+	void *key = cfqd;
+
+	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+	if (cfqg) {
+		if (!cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
+			sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+			cfqg->blkg.dev = MKDEV(major, minor);
+		}
+		return cfqg;
+	}
+
+	cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
+	if (!cfqg)
+		return NULL;
+
+	init_cfqg(cfqd, blkcg, cfqg);
+
+	cfqg_set_parent(cfqd, cfqg, NULL);
+
+	return cfqg;
+}
+
+
 static struct cfq_group *
 cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 {
@@ -1242,15 +1358,23 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	if (cfqg || !create)
 		goto done;
 
-	/*
-	 * For hierarchical cfq group scheduling, we need to allocate
-	 * the whole cfq group chain.
-	 */
-	ret = cfqg_chain_alloc(cfqd, cgroup);
-	if (!ret) {
-		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
-		BUG_ON(cfqg == NULL);
-		goto done;
+	if (cfqd->use_hierarchy) {
+		/*
+		 * For hierarchical cfq group scheduling, we need to allocate
+		 * the whole cfq group chain.
+		 */
+		ret = cfqg_chain_alloc(cfqd, cgroup);
+		if (!ret) {
+			cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
+			BUG_ON(cfqg == NULL);
+			goto done;
+		}
+	} else {
+		/*
+		 * For flat cfq group scheduling, we just need to allocate a
+		 * single cfq group.
+		 */
+		cfqg = cfqg_alloc(cfqd, cgroup);
 	}
 
 done:
@@ -2484,6 +2608,24 @@ struct cfq_entity *choose_serving_entity(struct cfq_data *cfqd,
 
 	return cfq_rb_first(service_tree);
 }
+
+
+static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
+{
+	struct cfq_rb_root *st = &cfqd->flat_service_tree;
+	struct cfq_group *cfqg;
+	struct cfq_entity *cfqe;
+
+	if (RB_EMPTY_ROOT(&st->rb))
+		return NULL;
+
+	cfqe = cfq_rb_first(st);
+	cfqg = cfqg_of_entity(cfqe);
+	BUG_ON(!cfqg);
+	return cfqg;
+}
+
+
 /*
  * Select a queue for service. If we have a current active queue,
  * check whether to continue servicing it, or retrieve and set a new one.
@@ -2592,22 +2734,41 @@ new_queue:
 	 * Current queue expired. Check if we have to switch to a new
 	 * service tree
 	 */
-	cfqg = &cfqd->root_group;
 
-	if (!new_cfqq) {
-		do {
-			entity = choose_serving_entity(cfqd, cfqg);
-			if (entity && !entity->is_group_entity) {
-				/* This is the CFQ queue that should run */
-				new_cfqq = cfqq_of_entity(entity);
-				cfqd->serving_group = cfqg;
-				set_workload_expire(cfqd, cfqg);
-				break;
-			} else if (entity && entity->is_group_entity) {
-				/* Continue to lookup in this CFQ group */
-				cfqg = cfqg_of_entity(entity);
-			}
-		} while (entity && entity->is_group_entity);
+	if (cfqd->use_hierarchy) {
+		cfqg = &cfqd->root_group;
+
+		if (!new_cfqq) {
+			do {
+				entity = choose_serving_entity(cfqd, cfqg);
+				if (entity && !entity->is_group_entity) {
+					/*
+					 *  This is the CFQ queue that should
+					 *  run.
+					 */
+					new_cfqq = cfqq_of_entity(entity);
+					cfqd->serving_group = cfqg;
+					set_workload_expire(cfqd, cfqg);
+					break;
+				} else if (entity && entity->is_group_entity) {
+					/*
+					 * Continue to lookup in this CFQ
+					 * group.
+					 */
+					cfqg = cfqg_of_entity(entity);
+				}
+			} while (entity && entity->is_group_entity);
+		}
+	} else {
+		/* Select a CFQ group from flat service tree. */
+		cfqg = cfq_get_next_cfqg(cfqd);
+		cfqd->serving_group = cfqg;
+		entity = choose_serving_entity(cfqd, cfqg);
+		if (entity) {
+			BUG_ON(entity->is_group_entity);
+			new_cfqq = cfqq_of_entity(entity);
+			set_workload_expire(cfqd, cfqg);
+		}
 	}
 
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
@@ -2631,6 +2792,28 @@ static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	return dispatched;
 }
 
+static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
+{
+	struct cfq_group *cfqg;
+	struct cfq_entity *cfqe;
+	int i, j;
+	struct cfq_rb_root *st;
+
+	if (!cfqd->rq_queued)
+		return NULL;
+
+	cfqg = cfq_get_next_cfqg(cfqd);
+	if (!cfqg)
+		return NULL;
+
+	for_each_cfqg_st(cfqg, i, j, st) {
+		cfqe = cfq_rb_first(st);
+		if (cfqe != NULL)
+			return cfqq_of_entity(cfqe);
+	}
+	return NULL;
+}
+
 /*
  * Drain our current requests. Used for barriers and when switching
  * io schedulers on-the-fly.
@@ -2644,16 +2827,26 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 
 	/* Expire the timeslice of the current active queue first */
 	cfq_slice_expired(cfqd, 0);
-	while ((entity = cfq_get_next_entity_forced(cfqd, root)) != NULL) {
-		BUG_ON(entity->is_group_entity);
-		cfqq = cfqq_of_entity(entity);
-		__cfq_set_active_queue(cfqd, cfqq);
-		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+
+	if (cfqd->use_hierarchy) {
+		while ((entity =
+			cfq_get_next_entity_forced(cfqd, root)) != NULL) {
+			BUG_ON(entity->is_group_entity);
+			cfqq = cfqq_of_entity(entity);
+			__cfq_set_active_queue(cfqd, cfqq);
+			dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+		}
+	} else {
+		while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
+			__cfq_set_active_queue(cfqd, cfqq);
+			dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+		}
 	}
 
 	BUG_ON(cfqd->busy_queues);
 
 	cfq_log(cfqd, "forced_dispatch=%d", dispatched);
+
 	return dispatched;
 }
 
@@ -4190,7 +4383,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	/* Give preference to root group over other groups */
 	cfqg->cfqe.weight = 2*BLKIO_WEIGHT_DEFAULT;
 	cfqg->cfqe.is_group_entity = true;
-	cfqg->cfqe.parent = NULL;
+	cfqg_set_parent(cfqd, cfqg, NULL);
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
@@ -4244,8 +4437,8 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_group_isolation = 0;
 	cfqd->hw_tag = -1;
 
-	/* hierarchical scheduling for cfq group by default */
-	cfqd->use_hierarchy = 1;
+	/* flat scheduling for cfq group by default */
+	cfqd->use_hierarchy = 0;
 
 	/*
 	 * we optimistically start assuming sync ops weren't delayed in last
-- 
1.6.5.2





