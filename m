Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0JUCge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:36:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53147 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757082Ab0JUCgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:36:33 -0400
Message-ID: <4CBFA743.1040005@cn.fujitsu.com>
Date: Thu, 21 Oct 2010 10:36:51 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Nauman Rafique <nauman@google.com>, Chad Talbott <ctalbott@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH 3/4] cfq-iosched: Enable both hierarchical mode and flat mode
 for cfq group scheduling
References: <4CBFA64D.6050800@cn.fujitsu.com>
In-Reply-To: <4CBFA64D.6050800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables both hierarchical mode and flat mode for cfq group scheduling.
Users can switch between two modes by using "use_hierarchy" interface in blkio
cgroup.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |  256 +++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 196 insertions(+), 60 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f781e4d..98c9191 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -240,6 +240,9 @@ struct cfq_data {
 	/* cfq group schedule in flat or hierarchy manner. */
 	bool use_hierarchy;
 
+	/* Service tree for cfq group flat scheduling mode. */
+	struct cfq_rb_root grp_service_tree;
+
 	/*
 	 * The priority currently being served
 	 */
@@ -635,10 +638,20 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
 static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct io_sched_entity *queue_entity = &cfqg->queue_se;
-	struct cfq_rb_root *st = queue_entity->st;
+	struct cfq_rb_root *st;
+	unsigned int weight;
+
+	if (cfqd->use_hierarchy) {
+		struct io_sched_entity *queue_entity = &cfqg->queue_se;
+		st = queue_entity->st;
+		weight = queue_entity->weight;
+	} else {
+		struct io_sched_entity *group_entity = &cfqg->group_se;
+		st = &cfqd->grp_service_tree;
+		weight = group_entity->weight;
+	}
 
-	return cfq_target_latency * queue_entity->weight / st->total_weight;
+	return cfq_target_latency * weight / st->total_weight;
 }
 
 static inline void
@@ -932,16 +945,30 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 	cfqg->nr_cfqq++;
 
-	io_sched_entity_add(queue_entity->st, queue_entity);
+	if (cfqd->use_hierarchy) {
+		io_sched_entity_add(queue_entity->st, queue_entity);
 
-	while (group_entity && group_entity->parent) {
+		while (group_entity && group_entity->parent) {
+			if (group_entity->on_st)
+				return;
+			io_sched_entity_add(group_entity->st, group_entity);
+			group_entity = group_entity->parent;
+			__cfqg = cfqg_of_group_entity(group_entity);
+			__cfqg->nr_subgp++;
+		}
+	} else {
 		if (group_entity->on_st)
 			return;
+
+		/*
+		 * For flat mode, all cfq group schedule on the global service
+		 * tree(cfqd->grp_service_tree).
+		 */
 		io_sched_entity_add(group_entity->st, group_entity);
-		group_entity = group_entity->parent;
-		__cfqg = cfqg_of_group_entity(group_entity);
-		__cfqg->nr_subgp++;
+
 	}
+
+
 }
 
 static void io_sched_entity_del(struct io_sched_entity *se)
@@ -975,24 +1002,32 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	if (cfqg->nr_cfqq)
 		return;
 
-	/* dequeue queue se from group */
-	io_sched_entity_del(queue_entity);
+	/* For cfq group hierarchical schuduling case */
+	if (cfqd->use_hierarchy) {
+		/* dequeue queue se from group */
+		io_sched_entity_del(queue_entity);
 
-	if (cfqg->nr_subgp)
-		return;
+		if (cfqg->nr_subgp)
+			return;
 
-	/* prevent from dequeuing root group */
-	while (group_entity && group_entity->parent) {
-		__cfqg = cfqg_of_group_entity(group_entity);
-		p_cfqg = cfqg_of_group_entity(group_entity->parent);
+		/* prevent from dequeuing root group */
+		while (group_entity && group_entity->parent) {
+			__cfqg = cfqg_of_group_entity(group_entity);
+			p_cfqg = cfqg_of_group_entity(group_entity->parent);
+			io_sched_entity_del(group_entity);
+			cfq_blkiocg_update_dequeue_stats(&__cfqg->blkg, 1);
+			cfq_log_cfqg(cfqd, __cfqg, "del_from_rr group");
+			__cfqg->saved_workload_slice = 0;
+			group_entity = group_entity->parent;
+			p_cfqg->nr_subgp--;
+			if (p_cfqg->nr_cfqq || p_cfqg->nr_subgp)
+				return;
+		}
+	} else {
+		cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
 		io_sched_entity_del(group_entity);
-		cfq_blkiocg_update_dequeue_stats(&__cfqg->blkg, 1);
-		cfq_log_cfqg(cfqd, __cfqg, "del_from_rr group");
-		__cfqg->saved_workload_slice = 0;
-		group_entity = group_entity->parent;
-		p_cfqg->nr_subgp--;
-		if (p_cfqg->nr_cfqq || p_cfqg->nr_subgp)
-			return;
+		cfqg->saved_workload_slice = 0;
+		cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 	}
 }
 
@@ -1026,7 +1061,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
 	struct io_sched_entity *group_entity = &cfqg->group_se;
-	struct io_sched_entity *queue_entity = &cfqg->queue_se;
+	struct io_sched_entity *queue_entity;
 	unsigned int used_sl, charge;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
 			- cfqg->service_tree_idle.count;
@@ -1039,25 +1074,33 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 	else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
 		charge = cfqq->allocated_slice;
 
-	/*
-	 *  update queue se's vdisktime.
-	 *  Can't update vdisktime while group is on service tree.
-	 */
-
-	cfq_rb_erase(&queue_entity->rb_node, queue_entity->st);
-	queue_entity->vdisktime += cfq_scale_slice(charge, queue_entity);
-	__io_sched_entity_add(queue_entity->st, queue_entity);
-	if (&queue_entity->rb_node == queue_entity->st->active)
-		queue_entity->st->active = NULL;
-
-	while (group_entity && group_entity->parent) {
+	if (cfqd->use_hierarchy) {
+		/*
+		 *  update queue se's vdisktime.
+		 *  Can't update vdisktime while group is on service tree.
+		 */
+		queue_entity = &cfqg->queue_se;
+		cfq_rb_erase(&queue_entity->rb_node, queue_entity->st);
+		queue_entity->vdisktime += cfq_scale_slice(charge,
+							   queue_entity);
+		__io_sched_entity_add(queue_entity->st, queue_entity);
+		if (&queue_entity->rb_node == queue_entity->st->active)
+			queue_entity->st->active = NULL;
+
+		while (group_entity && group_entity->parent) {
+			cfq_rb_erase(&group_entity->rb_node, group_entity->st);
+			group_entity->vdisktime += cfq_scale_slice(charge,
+								 group_entity);
+			__io_sched_entity_add(group_entity->st, group_entity);
+			if (&group_entity->rb_node == group_entity->st->active)
+				group_entity->st->active = NULL;
+			group_entity = group_entity->parent;
+		}
+	} else {
 		cfq_rb_erase(&group_entity->rb_node, group_entity->st);
 		group_entity->vdisktime += cfq_scale_slice(charge,
 							   group_entity);
 		__io_sched_entity_add(group_entity->st, group_entity);
-		if (&group_entity->rb_node == group_entity->st->active)
-			group_entity->st->active = NULL;
-		group_entity = group_entity->parent;
 	}
 
 	/* This group is being expired. Save the context */
@@ -1125,13 +1168,35 @@ static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfq_put_cfqg(cfqg);
 }
 
-void
-cfq_update_blkio_use_hierarchy(struct blkio_group *blkg, bool val)
+static int cfq_forced_dispatch(struct cfq_data *cfqd);
+
+void cfq_update_blkio_use_hierarchy(struct blkio_group *blkg, bool val)
 {
+	unsigned long flags;
 	struct cfq_group *cfqg;
+	struct cfq_data *cfqd;
+	struct io_sched_entity *group_entity;
+	int nr;
 
+	/* Get root group here */
 	cfqg = cfqg_of_blkg(blkg);
-	cfqg->cfqd->use_hierarchy = val;
+	cfqd = cfqg->cfqd;
+
+	spin_lock_irqsave(cfqd->queue->queue_lock, flags);
+
+	/* Drain all requests */
+	nr = cfq_forced_dispatch(cfqd);
+
+	group_entity = &cfqg->group_se;
+
+	if (!val)
+		group_entity->st = &cfqd->grp_service_tree;
+	else
+		group_entity->st = NULL;
+
+	cfqd->use_hierarchy = val;
+
+	spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
 }
 
 static void init_group_queue_entity(struct blkio_cgroup *blkcg,
@@ -1202,11 +1267,21 @@ static void uninit_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		cfq_destroy_cfqg(cfqd, cfqg);
 }
 
-static void cfqg_set_parent(struct cfq_group *cfqg, struct cfq_group *p_cfqg)
+static void cfqg_set_parent(struct cfq_data *cfqd, struct cfq_group *cfqg,
+			    struct cfq_group *p_cfqg)
 {
-	struct io_sched_entity *group_entity = &cfqg->group_se;
-	struct io_sched_entity *queue_entity = &cfqg->queue_se;
-	struct io_sched_entity *p_group_entity = &p_cfqg->group_se;
+	struct io_sched_entity *group_entity, *queue_entity, *p_group_entity;
+
+	group_entity = &cfqg->group_se;
+
+	if (!p_cfqg) {
+		group_entity->st = &cfqd->grp_service_tree;
+		group_entity->parent = NULL;
+		return;
+	}
+
+	queue_entity = &cfqg->queue_se;
+	p_group_entity = &p_cfqg->group_se;
 
 	group_entity->parent = p_group_entity;
 	group_entity->st = &p_cfqg->grp_service_tree;
@@ -1258,10 +1333,39 @@ int cfqg_chain_alloc(struct cfq_data *cfqd, struct cgroup *cgroup)
 	p_cfqg = cfqg_of_blkg(blkiocg_lookup_group(p_blkcg, key));
 	BUG_ON(p_cfqg == NULL);
 
-	cfqg_set_parent(cfqg, p_cfqg);
+	cfqg_set_parent(cfqd, cfqg, p_cfqg);
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
 static struct cfq_group *
 cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 {
@@ -1281,11 +1385,26 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	if (cfqg || !create)
 		goto done;
 
-	ret = cfqg_chain_alloc(cfqd, cgroup);
-	if (!ret) {
-		cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
-		BUG_ON(cfqg == NULL);
-		goto done;
+	if (!cfqd->use_hierarchy) {
+		/*
+		 * For flat cfq group scheduling, we just need to allocate a
+		 * single cfq group.
+		 */
+		cfqg = cfqg_alloc(cfqd, cgroup);
+		if (!cfqg)
+			goto done;
+		return cfqg;
+	} else {
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
 	}
 done:
 	return cfqg;
@@ -2404,23 +2523,37 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 {
-	struct cfq_group *root_group = &cfqd->root_group;
-	struct cfq_rb_root *st = &root_group->grp_service_tree;
+	struct cfq_rb_root *st;
 	struct cfq_group *cfqg;
 	struct io_sched_entity *se;
 
-	do {
+	if (cfqd->use_hierarchy) {
+		struct cfq_group *root_group = &cfqd->root_group;
+		st = &root_group->grp_service_tree;
+
+		do {
+			se = cfq_rb_first_se(st);
+			if (!se)
+				return NULL;
+			st->active = &se->rb_node;
+			update_min_vdisktime(st);
+			cfqg = cfqg_of_queue_entity(se);
+			if (cfqg)
+				return cfqg;
+			cfqg = cfqg_of_group_entity(se);
+			st = &cfqg->grp_service_tree;
+		} while (1);
+	} else {
+		st = &cfqd->grp_service_tree;
 		se = cfq_rb_first_se(st);
 		if (!se)
 			return NULL;
 		st->active = &se->rb_node;
 		update_min_vdisktime(st);
-		cfqg = cfqg_of_queue_entity(se);
-		if (cfqg)
-			return cfqg;
 		cfqg = cfqg_of_group_entity(se);
-		st = &cfqg->grp_service_tree;
-	} while (1);
+		BUG_ON(!cfqg);
+		return cfqg;
+	}
 }
 
 static void cfq_choose_cfqg(struct cfq_data *cfqd)
@@ -4089,6 +4222,9 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	cfqd->cic_index = i;
 
+	/* Init flat service tree */
+	cfqd->grp_service_tree = CFQ_RB_ROOT;
+
 	/* Init root group */
 	cfqg = &cfqd->root_group;
 	cfqg->cfqd = cfqd;
-- 1.6.5.2 
