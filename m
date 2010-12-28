Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0L1Cun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 21:50:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:44155 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab0L1Cum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 21:50:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,237,1291622400"; 
   d="scan'208";a="587670372"
Subject: Re: [PATCH 3/6 v3] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
From: Shaohua Li <shaohua.li@intel.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
In-Reply-To: <4D185374.6090300@cn.fujitsu.com>
References: <4D180ECE.4000305@cn.fujitsu.com>
	 <4D185374.6090300@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 10:50:39 +0800
Message-ID: <1293504639.10593.39.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-27 at 16:51 +0800, Gui Jianfeng wrote:
> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
> group scheduling on the same service tree.
Haven't read the whole series yet. Looks this changes a lot of logic
even without cgroup support. Did you have test if this changes both
performance and latency in some mixed workloads?

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |  211 ++++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 158 insertions(+), 53 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index a2553c0..b598798 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -100,10 +100,7 @@ struct cfq_entity {
>         struct cfq_rb_root *service_tree;
>         /* service_tree member */
>         struct rb_node rb_node;
> -       /* service_tree key, represent the position on the tree */
> -       unsigned long rb_key;
> -
> -       /* group service_tree key */
> +       /* service_tree key */
>         u64 vdisktime;
>         bool is_group_entity;
>         unsigned int weight;
> @@ -115,6 +112,8 @@ struct cfq_entity {
>  struct cfq_queue {
>         /* The schedule entity */
>         struct cfq_entity cfqe;
> +       /* Reposition time */
> +       unsigned long reposition_time;
>         /* reference count */
>         atomic_t ref;
>         /* various state flags, see below */
> @@ -313,6 +312,24 @@ struct cfq_data {
>         struct rcu_head rcu;
>  };
> 
> +/*
> + * Map io priority(7 ~ 0) to io weight(100 ~ 1000) as follows
> + *     prio       0    1     2    3    4    5    6     7
> + *     weight  1000  868   740  612  484  356  228   100
> + */
> +static inline unsigned int cfq_prio_to_weight(unsigned short ioprio)
> +{
> +       unsigned int step;
> +
> +       BUG_ON(ioprio >= IOPRIO_BE_NR);
> +
> +       step = (BLKIO_WEIGHT_MAX - BLKIO_WEIGHT_MIN) / (IOPRIO_BE_NR - 1);
> +       if (ioprio == 0)
> +               return BLKIO_WEIGHT_MAX;
> +
> +       return BLKIO_WEIGHT_MIN + (IOPRIO_BE_NR - ioprio - 1) * step;
> +}
> +
>  static inline struct cfq_queue *
>  cfqq_of_entity(struct cfq_entity *cfqe)
>  {
> @@ -841,16 +858,6 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>         return cfq_choose_req(cfqd, next, prev, blk_rq_pos(last));
>  }
> 
> -static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
> -                                     struct cfq_queue *cfqq)
> -{
> -       /*
> -        * just an approximation, should be ok.
> -        */
> -       return (cfqq->cfqg->nr_cfqq - 1) * (cfq_prio_slice(cfqd, 1, 0) -
> -                      cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
> -}
> -
>  static inline s64
>  entity_key(struct cfq_rb_root *st, struct cfq_entity *entity)
>  {
> @@ -1199,6 +1206,16 @@ static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
> 
>  #endif /* GROUP_IOSCHED */
> 
> +static inline u64 cfq_get_boost(struct cfq_data *cfqd,
> +                                struct cfq_entity *cfqe)
> +{
> +       u64 d = cfqd->cfq_slice[1] << CFQ_SERVICE_SHIFT;
> +
> +       d = d * BLKIO_WEIGHT_DEFAULT;
> +       do_div(d, BLKIO_WEIGHT_MAX - cfqe->weight + BLKIO_WEIGHT_MIN);
> +       return d;
> +}
don't consider sync/async here? for group, we don't have such issue, but
we need boost sync otherwise.
> +
>  /*
>   * The cfqd->service_trees holds all pending cfq_queue's that have
>   * requests waiting to be processed. It is sorted in the order that
> @@ -1210,13 +1227,14 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>         struct cfq_entity *cfqe;
>         struct rb_node **p, *parent;
>         struct cfq_entity *__cfqe;
> -       unsigned long rb_key;
> -       struct cfq_rb_root *service_tree;
> +       struct cfq_rb_root *service_tree, *orig_st;
>         int left;
>         int new_cfqq = 1;
>         int group_changed = 0;
> +       s64 key;
> 
>         cfqe = &cfqq->cfqe;
> +       orig_st = cfqe->service_tree;
> 
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
>         if (!cfqd->cfq_group_isolation
> @@ -1224,8 +1242,15 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>             && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
>                 /* Move this cfq to root group */
>                 cfq_log_cfqq(cfqd, cfqq, "moving to root group");
> -               if (!RB_EMPTY_NODE(&cfqe->rb_node))
> +               if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
>                         cfq_group_service_tree_del(cfqd, cfqq->cfqg);
> +                       /*
> +                        * Group changed, dequeue this CFQ queue from the
> +                        * original service tree.
> +                        */
> +                       cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> +                       orig_st->total_weight -= cfqe->weight;
> +               }
>                 cfqq->orig_cfqg = cfqq->cfqg;
>                 cfqq->cfqg = &cfqd->root_group;
>                 atomic_inc(&cfqd->root_group.ref);
> @@ -1234,8 +1259,15 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                    && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
>                 /* cfqq is sequential now needs to go to its original group */
>                 BUG_ON(cfqq->cfqg != &cfqd->root_group);
> -               if (!RB_EMPTY_NODE(&cfqe->rb_node))
> +               if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
>                         cfq_group_service_tree_del(cfqd, cfqq->cfqg);
> +                       /*
> +                        * Group changed, dequeue this CFQ queue from the
> +                        * original service tree.
> +                        */
> +                       cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> +                       orig_st->total_weight -= cfqe->weight;
> +               }
>                 cfq_put_cfqg(cfqq->cfqg);
>                 cfqq->cfqg = cfqq->orig_cfqg;
>                 cfqq->orig_cfqg = NULL;
> @@ -1246,47 +1278,71 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> 
>         service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
>                                                 cfqq_type(cfqq));
> +       /*
> +        * For the time being, put the newly added CFQ queue at the end of the
> +        * service tree.
> +        */
so this should be fixed later? please mark it as a todo.
> +       if (RB_EMPTY_NODE(&cfqe->rb_node)) {
> +               /*
> +                * If this CFQ queue moves to another group, the original
> +                * vdisktime makes no sense any more, reset the vdisktime
> +                * here.
> +                */
> +               parent = rb_last(&service_tree->rb);
> +               if (parent) {
> +                       u64 boost;
> +                       s64 __vdisktime;
> +
> +                       __cfqe = rb_entry_entity(parent);
> +                       cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
> +
> +                       /* Give some vdisktime boost according to its weight */
> +                       boost = cfq_get_boost(cfqd, cfqe);
> +                       __vdisktime = cfqe->vdisktime - boost;
> +                       if (__vdisktime > service_tree->min_vdisktime)
> +                               cfqe->vdisktime = __vdisktime;
> +                       else
> +                               cfqe->vdisktime = service_tree->min_vdisktime;
> +               } else
> +                       cfqe->vdisktime = service_tree->min_vdisktime;
> +
> +               goto insert;
> +       }
> +       /*
> +        * Ok, we get here, this CFQ queue is on the service tree, dequeue it
> +        * firstly.
> +        */
> +       cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> +       orig_st->total_weight -= cfqe->weight;
> +
> +       new_cfqq = 0;
> +
>         if (cfq_class_idle(cfqq)) {
> -               rb_key = CFQ_IDLE_DELAY;
>                 parent = rb_last(&service_tree->rb);
>                 if (parent && parent != &cfqe->rb_node) {
>                         __cfqe = rb_entry(parent, struct cfq_entity, rb_node);
> -                       rb_key += __cfqe->rb_key;
> +                       cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
>                 } else
> -                       rb_key += jiffies;
> +                       cfqe->vdisktime = service_tree->min_vdisktime;
>         } else if (!add_front) {
>                 /*
> -                * Get our rb key offset. Subtract any residual slice
> -                * value carried from last service. A negative resid
> -                * count indicates slice overrun, and this should position
> -                * the next service time further away in the tree.
> -                */
> -               rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
> -               rb_key -= cfqq->slice_resid;
> -               cfqq->slice_resid = 0;
> -       } else {
> -               rb_key = -HZ;
> -               __cfqe = cfq_rb_first(service_tree);
> -               rb_key += __cfqe ? __cfqe->rb_key : jiffies;
> -       }
> -
> -       if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
> -               new_cfqq = 0;
> -               /*
> -                * same position, nothing more to do
> +                * We charge the CFQ queue by the time this queue runs, and
> +                * repsition it on the service tree.
>                  */
> -               if (rb_key == cfqe->rb_key &&
> -                   cfqe->service_tree == service_tree)
> -                       return;
> +               unsigned int used_sl;
> 
> -               cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> -               cfqe->service_tree = NULL;
> +               used_sl = cfq_cfqq_slice_usage(cfqq);
> +               cfqe->vdisktime += cfq_scale_slice(used_sl, cfqe);
cfqq->slice_resid could be > 0 or < 0, and the queue can be boosted or
penalized. Looks the logic is completely removed. This exists in current
cfq group too, I wonder why?

> +       } else {
> +               cfqe->vdisktime = service_tree->min_vdisktime;
>         }
> 
> +insert:
>         left = 1;
>         parent = NULL;
>         cfqe->service_tree = service_tree;
>         p = &service_tree->rb.rb_node;
> +       key = entity_key(service_tree, cfqe);
>         while (*p) {
>                 struct rb_node **n;
> 
> @@ -1296,7 +1352,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                 /*
>                  * sort by key, that represents service time.
>                  */
> -               if (time_before(rb_key, __cfqe->rb_key))
> +               if (key < entity_key(service_tree, __cfqe))
>                         n = &(*p)->rb_left;
>                 else {
>                         n = &(*p)->rb_right;
> @@ -1309,10 +1365,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>         if (left)
>                 service_tree->left = &cfqe->rb_node;
> 
> -       cfqe->rb_key = rb_key;
>         rb_link_node(&cfqe->rb_node, parent, p);
>         rb_insert_color(&cfqe->rb_node, &service_tree->rb);
> +       update_min_vdisktime(service_tree);
>         service_tree->count++;
> +       service_tree->total_weight += cfqe->weight;
> +       cfqq->reposition_time = jiffies;
>         if ((add_front || !new_cfqq) && !group_changed)
>                 return;
>         cfq_group_service_tree_add(cfqd, cfqq->cfqg);
> @@ -1414,14 +1472,18 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
>         struct cfq_entity *cfqe;
> +       struct cfq_rb_root *service_tree;
> +
>         cfq_log_cfqq(cfqd, cfqq, "del_from_rr");
>         BUG_ON(!cfq_cfqq_on_rr(cfqq));
>         cfq_clear_cfqq_on_rr(cfqq);
> 
>         cfqe = &cfqq->cfqe;
> +       service_tree = cfqe->service_tree;
> 
>         if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
>                 cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> +               service_tree->total_weight -= cfqe->weight;
>                 cfqe->service_tree = NULL;
>         }
>         if (cfqq->p_root) {
> @@ -2120,23 +2182,35 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
>         }
>  }
> 
> +/*
> + * The time when a CFQ queue is put onto a service tree is recoreded in
> + * cfqq->reposition_time. Currently, we check the first priority CFQ queues
> + * on each service tree, and select the workload type that contain the lowest
> + * reposition_time CFQ queue among them.
> + */
>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>                                 struct cfq_group *cfqg, enum wl_prio_t prio)
>  {
>         struct cfq_entity *cfqe;
> +       struct cfq_queue *cfqq;
> +       unsigned long lowest_start_time;
>         int i;
> -       bool key_valid = false;
> -       unsigned long lowest_key = 0;
> +       bool time_valid = false;
>         enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
> 
> +       /*
> +        * TODO: We may take io priority into account when choosing a workload
> +        * type. But for the time being just make use of reposition_time only.
> +        */
not just priority, original rb_key considers sys/async too.
>         for (i = 0; i <= SYNC_WORKLOAD; ++i) {
> -               /* select the one with lowest rb_key */
>                 cfqe = cfq_rb_first(service_tree_for(cfqg, prio, i));
> -               if (cfqe &&
> -                   (!key_valid || time_before(cfqe->rb_key, lowest_key))) {
> -                       lowest_key = cfqe->rb_key;
> +               cfqq = cfqq_of_entity(cfqe);
> +               if (cfqe && (!time_valid ||
> +                            time_before(cfqq->reposition_time,
> +                                        lowest_start_time))) {
> +                       lowest_start_time = cfqq->reposition_time;
>                         cur_best = i;
> -                       key_valid = true;
> +                       time_valid = true;
>                 }
>         }

Thanks,
Shaohua

