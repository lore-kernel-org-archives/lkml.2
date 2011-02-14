Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1BNXdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:33:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:54188 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1BNXdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:33:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VzyVioL/Vq5XqIh4TTn/D+0HWSSJHPC9OLOIwUjKJ3LxBlxQAa74hAmaoOlncOl/D+
         OA2+wZfUiJ+RRiNH+eJQ==
MIME-Version: 1.0
In-Reply-To: <4D539804.9090308@cn.fujitsu.com>
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539804.9090308@cn.fujitsu.com>
From: Justin TerAvest <teravest@google.com>
Date: Mon, 14 Feb 2011 15:32:49 -0800
Message-ID: <AANLkTimi=7_CEJy2m6Dhcy-aszXKBBL0fbC8mbD9JLOP@mail.gmail.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight for
 CFQ queue
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 11:47 PM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Introduce vdisktime and io weight for CFQ queue scheduling. Currently, io priority
> maps to a range [100,1000]. It also gets rid of cfq_slice_offset() logic and makes
> use the same scheduling algorithm as CFQ group does. This helps for CFQ queue and
> group scheduling on the same service tree.

Hi Gui,
I have a couple of questions inline.

Thanks,
Justin

>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |  219 +++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 167 insertions(+), 52 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index f3a126e..41cef2e 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -39,6 +39,13 @@ static const int cfq_hist_divisor = 4;
>  */
>  #define CFQ_IDLE_DELAY         (HZ / 5)
>
> +/*
> + * The base boosting value.
> + */
> +#define CFQ_BOOST_SYNC_BASE          (HZ / 10)
> +#define CFQ_BOOST_ASYNC_BASE          (HZ / 25)
> +
> +
>  /*
>  * below this threshold, we consider thinktime immediate
>  */
> @@ -99,10 +106,7 @@ struct cfq_entity {
>        struct cfq_rb_root *service_tree;
>        /* service_tree member */
>        struct rb_node rb_node;
> -       /* service_tree key, represent the position on the tree */
> -       unsigned long rb_key;
> -
> -       /* group service_tree key */
> +       /* service_tree key */
>        u64 vdisktime;
>        bool is_group_entity;
>        unsigned int weight;
> @@ -114,6 +118,8 @@ struct cfq_entity {
>  struct cfq_queue {
>        /* The schedule entity */
>        struct cfq_entity cfqe;
> +       /* Reposition time */
> +       unsigned long reposition_time;

Can this be addition time or something else instead? This is set, even
when we are not repositioning among service trees.

>        /* reference count */
>        int ref;
>        /* various state flags, see below */
> @@ -312,6 +318,24 @@ struct cfq_data {
>        struct rcu_head rcu;
>  };
>
> +/*
> + * Map io priority(7 ~ 0) to io weight(100 ~ 1000) as follows
> + *     prio       0    1     2    3    4    5    6     7
> + *     weight  1000  868   740  612  484  356  228   100
> + */
> +static inline unsigned int cfq_prio_to_weight(unsigned short ioprio)
> +{
> +       unsigned int step;
> +
> +       BUG_ON(ioprio >= IOPRIO_BE_NR);
> +
> +       step = (BLKIO_WEIGHT_MAX - BLKIO_WEIGHT_MIN) / (IOPRIO_BE_NR - 1);
> +       if (ioprio == 0)
> +               return BLKIO_WEIGHT_MAX;
> +
> +       return BLKIO_WEIGHT_MIN + (IOPRIO_BE_NR - ioprio - 1) * step;
> +}
> +
>  static inline struct cfq_queue *
>  cfqq_of_entity(struct cfq_entity *cfqe)
>  {
> @@ -840,16 +864,6 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>        return cfq_choose_req(cfqd, next, prev, blk_rq_pos(last));
>  }
>
> -static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
> -                                     struct cfq_queue *cfqq)
> -{
> -       /*
> -        * just an approximation, should be ok.
> -        */
> -       return (cfqq->cfqg->nr_cfqq - 1) * (cfq_prio_slice(cfqd, 1, 0) -
> -                      cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
> -}
> -
>  static inline s64
>  entity_key(struct cfq_rb_root *st, struct cfq_entity *entity)
>  {
> @@ -1199,6 +1213,21 @@ static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
>
>  #endif /* GROUP_IOSCHED */
>
> +static inline u64 cfq_get_boost(struct cfq_data *cfqd,
> +                                struct cfq_queue *cfqq)
> +{
> +       u64 d;
> +
> +       if (cfq_cfqq_sync(cfqq))
> +               d = CFQ_BOOST_SYNC_BASE << CFQ_SERVICE_SHIFT;
> +       else
> +               d = CFQ_BOOST_ASYNC_BASE << CFQ_SERVICE_SHIFT;
> +
> +       d = d * BLKIO_WEIGHT_DEFAULT;
> +       do_div(d, cfqq->cfqe.weight);
> +       return d;
> +}

The logic for cfq_get_boost() looks a lot like cfq_scale_slice().
Instead of duplicating code, can't it just be
u64 d;
if (cfq_cfqq_sync(cfqq))
        return cfq_scale_slice(CFQ_BOOST_SYNC_BASE, cfqq->cfqe);
else
        return cfq_scale_slice(CFQ_BOOST_ASYNC_BASE, cfqq->cfqe);


> +
>  /*
>  * The cfqd->service_trees holds all pending cfq_queue's that have
>  * requests waiting to be processed. It is sorted in the order that
> @@ -1210,13 +1239,14 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>        struct cfq_entity *cfqe;
>        struct rb_node **p, *parent;
>        struct cfq_entity *__cfqe;
> -       unsigned long rb_key;
> -       struct cfq_rb_root *service_tree;
> +       struct cfq_rb_root *service_tree, *orig_st;
>        int left;
>        int new_cfqq = 1;
>        int group_changed = 0;
> +       s64 key;
>
>        cfqe = &cfqq->cfqe;
> +       orig_st = cfqe->service_tree;
>
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
>        if (!cfqd->cfq_group_isolation
> @@ -1224,8 +1254,15 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>            && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
>                /* Move this cfq to root group */
>                cfq_log_cfqq(cfqd, cfqq, "moving to root group");
> -               if (!RB_EMPTY_NODE(&cfqe->rb_node))
> +               if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
>                        cfq_group_service_tree_del(cfqd, cfqq->cfqg);
> +                       /*
> +                        * Group changed, dequeue this CFQ queue from the
> +                        * original service tree.
> +                        */
> +                       cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> +                       orig_st->total_weight -= cfqe->weight;
> +               }
>                cfqq->orig_cfqg = cfqq->cfqg;
>                cfqq->cfqg = &cfqd->root_group;
>                cfqd->root_group.ref++;
> @@ -1234,8 +1271,15 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
>                /* cfqq is sequential now needs to go to its original group */
>                BUG_ON(cfqq->cfqg != &cfqd->root_group);
> -               if (!RB_EMPTY_NODE(&cfqe->rb_node))
> +               if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
>                        cfq_group_service_tree_del(cfqd, cfqq->cfqg);
> +                       /*
> +                        * Group changed, dequeue this CFQ queue from the
> +                        * original service tree.
> +                        */
> +                       cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> +                       orig_st->total_weight -= cfqe->weight;
> +               }
>                cfq_put_cfqg(cfqq->cfqg);
>                cfqq->cfqg = cfqq->orig_cfqg;
>                cfqq->orig_cfqg = NULL;
> @@ -1246,47 +1290,68 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>
>        service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
>                                                cfqq_type(cfqq));
> +       if (RB_EMPTY_NODE(&cfqe->rb_node)) {
> +               /*
> +                * If this CFQ queue moves to another group, the original
> +                * vdisktime makes no sense any more, reset the vdisktime
> +                * here.
> +                */
> +               parent = rb_last(&service_tree->rb);
> +               if (parent) {
> +                       u64 pos_offset;
> +
> +                       /*
> +                        * Estimate the position according to its weight and
> +                        * ioprio.
> +                        */
> +                       pos_offset = cfq_get_boost(cfqd, cfqq);
> +                       /* Debug purpose, should remove. */
> +                       cfq_log_cfqq(cfqd, cfqq, "pos_offset: %llu",
> +                                    pos_offset);
> +                       cfqe->vdisktime = service_tree->min_vdisktime +
> +                                               pos_offset;
> +               } else
> +                       cfqe->vdisktime = service_tree->min_vdisktime;
> +
> +               goto insert;
> +       }
> +
> +       /*
> +        * Ok, we get here, this CFQ queue is on the service tree, dequeue it
> +        * firstly.
> +        */
> +       cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> +       orig_st->total_weight -= cfqe->weight;
> +
> +       new_cfqq = 0;
> +
>        if (cfq_class_idle(cfqq)) {
> -               rb_key = CFQ_IDLE_DELAY;
>                parent = rb_last(&service_tree->rb);
>                if (parent && parent != &cfqe->rb_node) {
>                        __cfqe = rb_entry(parent, struct cfq_entity, rb_node);
> -                       rb_key += __cfqe->rb_key;
> +                       cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
>                } else
> -                       rb_key += jiffies;
> +                       cfqe->vdisktime = service_tree->min_vdisktime;
>        } else if (!add_front) {
>                /*
> -                * Get our rb key offset. Subtract any residual slice
> -                * value carried from last service. A negative resid
> -                * count indicates slice overrun, and this should position
> -                * the next service time further away in the tree.
> +                * We charge the CFQ queue by the time this queue runs, and
> +                * repsition it on the service tree.
>                 */
> -               rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
> -               rb_key -= cfqq->slice_resid;
> +               unsigned int used_sl;
> +
> +               used_sl = cfq_cfqq_slice_usage(cfqq);
> +               cfqe->vdisktime += cfq_scale_slice(used_sl, cfqe);
>                cfqq->slice_resid = 0;
>        } else {
> -               rb_key = -HZ;
> -               __cfqe = cfq_rb_first(service_tree);
> -               rb_key += __cfqe ? __cfqe->rb_key : jiffies;
> -       }
> -
> -       if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
> -               new_cfqq = 0;
> -               /*
> -                * same position, nothing more to do
> -                */
> -               if (rb_key == cfqe->rb_key &&
> -                   cfqe->service_tree == service_tree)
> -                       return;
> -
> -               cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> -               cfqe->service_tree = NULL;
> +               cfqe->vdisktime = service_tree->min_vdisktime;
>        }
>
> +insert:
>        left = 1;
>        parent = NULL;
>        cfqe->service_tree = service_tree;
>        p = &service_tree->rb.rb_node;
> +       key = entity_key(service_tree, cfqe);
>        while (*p) {
>                struct rb_node **n;
>
> @@ -1296,7 +1361,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                /*
>                 * sort by key, that represents service time.
>                 */
> -               if (time_before(rb_key, __cfqe->rb_key))
> +               if (key < entity_key(service_tree, __cfqe))
>                        n = &(*p)->rb_left;
>                else {
>                        n = &(*p)->rb_right;
> @@ -1309,10 +1374,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>        if (left)
>                service_tree->left = &cfqe->rb_node;
>
> -       cfqe->rb_key = rb_key;
>        rb_link_node(&cfqe->rb_node, parent, p);
>        rb_insert_color(&cfqe->rb_node, &service_tree->rb);
> +       update_min_vdisktime(service_tree);
>        service_tree->count++;
> +       service_tree->total_weight += cfqe->weight;

I'm confused by this line. Why are we doing some adjustment for cfqe
weight that we weren't doing previously? I think
cfq_group_service_tree_add below will still do the total_weight
adjustment.

> +       cfqq->reposition_time = jiffies;
>        if ((add_front || !new_cfqq) && !group_changed)
>                return;
>        cfq_group_service_tree_add(cfqd, cfqq->cfqg);
> @@ -1414,14 +1481,18 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
>        struct cfq_entity *cfqe;
> +       struct cfq_rb_root *service_tree;
> +
>        cfq_log_cfqq(cfqd, cfqq, "del_from_rr");
>        BUG_ON(!cfq_cfqq_on_rr(cfqq));
>        cfq_clear_cfqq_on_rr(cfqq);
>
>        cfqe = &cfqq->cfqe;
> +       service_tree = cfqe->service_tree;
>
>        if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
>                cfq_rb_erase(&cfqe->rb_node, cfqe->service_tree);
> +               service_tree->total_weight -= cfqe->weight;
>                cfqe->service_tree = NULL;
>        }
>        if (cfqq->p_root) {
> @@ -2120,23 +2191,36 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
>        }
>  }
>
> +/*
> + * The time when a CFQ queue is put onto a service tree is recoreded in
> + * cfqq->reposition_time. Currently, we check the first priority CFQ queues
> + * on each service tree, and select the workload type that contains the lowest
> + * reposition_time CFQ queue among them.
> + */
>  static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
>                                struct cfq_group *cfqg, enum wl_prio_t prio)
>  {
>        struct cfq_entity *cfqe;
> +       struct cfq_queue *cfqq;
> +       unsigned long lowest_start_time;
>        int i;
> -       bool key_valid = false;
> -       unsigned long lowest_key = 0;
> +       bool time_valid = false;
>        enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
>
> +       /*
> +        * TODO: We may take io priority and io class into account when
> +        * choosing a workload type. But for the time being just make use of
> +        * reposition_time only.
> +        */
>        for (i = 0; i <= SYNC_WORKLOAD; ++i) {
> -               /* select the one with lowest rb_key */
>                cfqe = cfq_rb_first(service_tree_for(cfqg, prio, i));
> -               if (cfqe &&
> -                   (!key_valid || time_before(cfqe->rb_key, lowest_key))) {
> -                       lowest_key = cfqe->rb_key;
> +               cfqq = cfqq_of_entity(cfqe);
> +               if (cfqe && (!time_valid ||
> +                            time_before(cfqq->reposition_time,
> +                                        lowest_start_time))) {
> +                       lowest_start_time = cfqq->reposition_time;
>                        cur_best = i;
> -                       key_valid = true;
> +                       time_valid = true;
>                }
>        }
>
> @@ -2808,10 +2892,13 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
>  {
>        struct task_struct *tsk = current;
>        int ioprio_class;
> +       struct cfq_entity *cfqe;
>
>        if (!cfq_cfqq_prio_changed(cfqq))
>                return;
>
> +       cfqe = &cfqq->cfqe;
> +
>        ioprio_class = IOPRIO_PRIO_CLASS(ioc->ioprio);
>        switch (ioprio_class) {
>        default:
> @@ -2838,6 +2925,17 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
>                break;
>        }
>
> +       if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
> +               /*
> +                * If this CFQ entity is already on service tree, we need to
> +                * adjust service tree's total weight accordingly.
> +                */
> +               cfqe->service_tree->total_weight -= cfqe->weight;
> +               cfqe->weight = cfq_prio_to_weight(cfqq->ioprio);
> +               cfqe->service_tree->total_weight += cfqe->weight;
> +       } else
> +               cfqe->weight = cfq_prio_to_weight(cfqq->ioprio);
> +
>        /*
>         * keep track of original prio settings in case we have to temporarily
>         * elevate the priority of this queue
> @@ -3572,6 +3670,9 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  */
>  static void cfq_prio_boost(struct cfq_queue *cfqq)
>  {
> +       struct cfq_entity *cfqe;
> +
> +       cfqe = &cfqq->cfqe;
>        if (has_fs_excl()) {
>                /*
>                 * boost idle prio on transactions that would lock out other
> @@ -3588,6 +3689,20 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
>                cfqq->ioprio_class = cfqq->org_ioprio_class;
>                cfqq->ioprio = cfqq->org_ioprio;
>        }
> +
> +       /*
> +        * update the io weight if io priority gets changed.
> +        */
> +       if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
> +               /*
> +                * If this CFQ entity is already on service tree, we need to
> +                * adjust service tree's total weight accordingly.
> +                */
> +               cfqe->service_tree->total_weight -= cfqe->weight;
> +               cfqe->weight = cfq_prio_to_weight(cfqq->ioprio);
> +               cfqe->service_tree->total_weight += cfqe->weight;
> +       } else
> +               cfqe->weight = cfq_prio_to_weight(cfqq->ioprio);
>  }
>
>  static inline int __cfq_may_queue(struct cfq_queue *cfqq)
> --
> 1.7.1
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
