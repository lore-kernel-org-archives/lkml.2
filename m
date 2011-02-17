Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1BQAb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:31:57 -0500
Received: from smtp-out.google.com ([74.125.121.67]:42296 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1BQAby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SfZWkfHQlzdqCsDBkLHlQrdWMeiw9yCr1V7Jy0IzPO/g8lnvRiffaKdvCsrMfLzWyj
         4Wtl3fWWeBK9AnNsHhHg==
MIME-Version: 1.0
In-Reply-To: <4D539821.1090703@cn.fujitsu.com>
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539821.1090703@cn.fujitsu.com>
From: Justin TerAvest <teravest@google.com>
Date: Wed, 16 Feb 2011 16:31:29 -0800
Message-ID: <AANLkTi=L5gingbYVDZfuDdkCyUKXNhjz8zFg4FLBN+7L@mail.gmail.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling and
 use_hierarchy interface
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

After a quick read,

It's sad that we have to have so many use_hierarchy checks; it seems
like we're asking for bugs, especially in the future when one codepath
gets updated but not the other.

CodingStyle says we should only have one declaration per line.

I feel like there is an implicit assumption that groups and tasks
should not be children of the same parent; that is, a group should
contain only groups, or only tasks, but I don't see this enforced;
there's just and assumption that BE:SYNC is "good enough" for that
comparison. This smells like something that will be tweaked/tuned for
fairness later. :( Why don't we just prevent this from happening?

The clean_up label in chain_alloc() is strange; I don't think the goto
is necessary at all. I found that method generally hard to understand.
It's doing a lot.

It's possible that some of these can't be worked around.


On Wed, Feb 9, 2011 at 11:47 PM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> CFQ group hierarchical scheduling and use_hierarchy interface.
>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/blk-cgroup.c  |   61 +++++-
>  block/blk-cgroup.h  |    3 +
>  block/cfq-iosched.c |  603 +++++++++++++++++++++++++++++++++++++--------------
>  3 files changed, 500 insertions(+), 167 deletions(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 455768a..c55fecd 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -25,7 +25,10 @@
>  static DEFINE_SPINLOCK(blkio_list_lock);
>  static LIST_HEAD(blkio_list);
>
> -struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
> +struct blkio_cgroup blkio_root_cgroup = {
> +       .weight = 2*BLKIO_WEIGHT_DEFAULT,
> +       .use_hierarchy = 0
> +};
>  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
>
>  static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
> @@ -454,6 +457,7 @@ static void __blkiocg_del_blkio_group(struct blkio_group *blkg)
>        blkg->blkcg_id = 0;
>  }
>
> +
>  /*
>  * returns 0 if blkio_group was still on cgroup list. Otherwise returns 1
>  * indicating that blk_group was unhashed by the time we got to it.
> @@ -765,6 +769,12 @@ unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
>  }
>  EXPORT_SYMBOL_GPL(blkcg_get_weight);
>
> +unsigned int blkcg_get_use_hierarchy(struct blkio_cgroup *blkcg)
> +{
> +       return blkcg->use_hierarchy;
> +}
> +EXPORT_SYMBOL_GPL(blkcg_get_use_hierarchy);
> +
>  uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg, dev_t dev)
>  {
>        struct blkio_policy_node *pn;
> @@ -1202,6 +1212,8 @@ static u64 blkiocg_file_read_u64 (struct cgroup *cgrp, struct cftype *cft) {
>                switch(name) {
>                case BLKIO_PROP_weight:
>                        return (u64)blkcg->weight;
> +               case BLKIO_PROP_use_hierarchy:
> +                       return (u64)blkcg->use_hierarchy;
>                }
>                break;
>        default:
> @@ -1210,6 +1222,36 @@ static u64 blkiocg_file_read_u64 (struct cgroup *cgrp, struct cftype *cft) {
>        return 0;
>  }
>
> +static int blkio_use_hierarchy_write(struct cgroup *cgrp, u64 val)
> +{
> +       struct cgroup *parent = cgrp->parent;
> +       struct blkio_cgroup *blkcg, *parent_blkcg = NULL;
> +       int ret = 0;
> +
> +       if (val != 0 && val != 1)
> +               return -EINVAL;
> +
> +       blkcg = cgroup_to_blkio_cgroup(cgrp);
> +       if (parent)
> +               parent_blkcg = cgroup_to_blkio_cgroup(parent);
> +
> +       cgroup_lock();
> +       /*
> +        * If parent's use_hierarchy is set, we can't make any modifications
> +        * in the child subtrees. If it is unset, then the change can occur,
> +        * provided the current cgroup has no children.
> +        */
> +       if (!parent_blkcg || !parent_blkcg->use_hierarchy) {
> +               if (list_empty(&cgrp->children))
> +                       blkcg->use_hierarchy = val;
> +               else
> +                       ret = -EBUSY;
> +       } else
> +               ret = -EINVAL;
> +       cgroup_unlock();
> +       return ret;
> +}
> +
>  static int
>  blkiocg_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
>  {
> @@ -1224,6 +1266,8 @@ blkiocg_file_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
>                switch(name) {
>                case BLKIO_PROP_weight:
>                        return blkio_weight_write(blkcg, val);
> +               case BLKIO_PROP_use_hierarchy:
> +                       return blkio_use_hierarchy_write(cgrp, val);
>                }
>                break;
>        default:
> @@ -1301,6 +1345,13 @@ struct cftype blkio_files[] = {
>                .name = "reset_stats",
>                .write_u64 = blkiocg_reset_stats,
>        },
> +       {
> +               .name = "use_hierarchy",
> +               .private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
> +                                            BLKIO_PROP_use_hierarchy),
> +               .read_u64 = blkiocg_file_read_u64,
> +               .write_u64 = blkiocg_file_write_u64,
> +       },
>  #ifdef CONFIG_BLK_DEV_THROTTLING
>        {
>                .name = "throttle.read_bps_device",
> @@ -1444,7 +1495,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>  static struct cgroup_subsys_state *
>  blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>  {
> -       struct blkio_cgroup *blkcg;
> +       struct blkio_cgroup *blkcg, *parent_blkcg = NULL;
>        struct cgroup *parent = cgroup->parent;
>
>        if (!parent) {
> @@ -1452,6 +1503,7 @@ blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>                goto done;
>        }
>
> +       parent_blkcg = cgroup_to_blkio_cgroup(parent);
>        blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
>        if (!blkcg)
>                return ERR_PTR(-ENOMEM);
> @@ -1462,6 +1514,11 @@ done:
>        INIT_HLIST_HEAD(&blkcg->blkg_list);
>
>        INIT_LIST_HEAD(&blkcg->policy_list);
> +       if (parent)
> +               blkcg->use_hierarchy = parent_blkcg->use_hierarchy;
> +       else
> +               blkcg->use_hierarchy = 0;
> +
>        return &blkcg->css;
>  }
>
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index ea4861b..5b4b351 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -90,6 +90,7 @@ enum blkcg_file_name_prop {
>        BLKIO_PROP_idle_time,
>        BLKIO_PROP_empty_time,
>        BLKIO_PROP_dequeue,
> +       BLKIO_PROP_use_hierarchy,
>  };
>
>  /* cgroup files owned by throttle policy */
> @@ -105,6 +106,7 @@ enum blkcg_file_name_throtl {
>  struct blkio_cgroup {
>        struct cgroup_subsys_state css;
>        unsigned int weight;
> +       bool use_hierarchy;
>        spinlock_t lock;
>        struct hlist_head blkg_list;
>        struct list_head policy_list; /* list of blkio_policy_node */
> @@ -179,6 +181,7 @@ struct blkio_policy_node {
>
>  extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
>                                     dev_t dev);
> +extern unsigned int blkcg_get_use_hierarchy(struct blkio_cgroup *blkcg);
>  extern uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg,
>                                     dev_t dev);
>  extern uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg,
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index aa3eda8..0e21d27 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -110,6 +110,9 @@ struct cfq_entity {
>        u64 vdisktime;
>        bool is_group_entity;
>        unsigned int weight;
> +       struct cfq_entity *parent;
> +       /* Reposition time */
> +       unsigned long reposition_time;
>  };
>
>  /*
> @@ -118,8 +121,6 @@ struct cfq_entity {
>  struct cfq_queue {
>        /* The schedule entity */
>        struct cfq_entity cfqe;
> -       /* Reposition time */
> -       unsigned long reposition_time;
>        /* reference count */
>        int ref;
>        /* various state flags, see below */
> @@ -199,6 +200,9 @@ struct cfq_group {
>        /* number of cfqq currently on this group */
>        int nr_cfqq;
>
> +       /* number of sub cfq groups */
> +       int nr_subgp;
> +
>        /*
>         * Per group busy queus average. Useful for workload slice calc. We
>         * create the array for each prio class but at run time it is used
> @@ -234,10 +238,11 @@ struct cfq_group {
>  */
>  struct cfq_data {
>        struct request_queue *queue;
> -       /* Root service tree for cfq_groups */
> -       struct cfq_rb_root grp_service_tree;
>        struct cfq_group root_group;
>
> +       /* cfq group schedule in flat or hierarchy manner. */
> +       bool use_hierarchy;
> +
>        /*
>         * The priority currently being served
>         */
> @@ -246,6 +251,9 @@ struct cfq_data {
>        unsigned long workload_expires;
>        struct cfq_group *serving_group;
>
> +       /* Service tree for cfq group flat scheduling mode. */
> +       struct cfq_rb_root grp_service_tree;
> +
>        /*
>         * Each priority tree is sorted by next_request position.  These
>         * trees are used when determining if two or more queues are
> @@ -355,8 +363,6 @@ cfqg_of_entity(struct cfq_entity *cfqe)
>  }
>
>
> -static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> -
>  static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
>                                            enum wl_prio_t prio,
>                                            enum wl_type_t type)
> @@ -643,13 +649,50 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
>        return cfqg->busy_queues_avg[rt];
>  }
>
> +static inline unsigned int
> +cfq_group_get_total_weight(struct cfq_group *cfqg)
> +{
> +       int i, j;
> +       struct cfq_rb_root *st;
> +       unsigned int total_weight = 0;
> +
> +       for_each_cfqg_st(cfqg, i, j, st) {
> +               total_weight += st->total_weight;
> +       }
> +
> +       return total_weight;
> +}
> +
>  static inline unsigned
>  cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
> -       struct cfq_rb_root *st = &cfqd->grp_service_tree;
>        struct cfq_entity *cfqe = &cfqg->cfqe;
> +       struct cfq_rb_root *st;
> +       int group_slice = cfq_target_latency;
> +       unsigned int grp_total_weight;
> +       struct cfq_group *p_cfqg;
> +
> +       /*
> +        * Calculate group slice in a hierarchical way.
> +        * Note, the calculation is cross all service trees under a group.
> +        */
> +       do {
> +               if (cfqe->parent) {
> +                       p_cfqg = cfqg_of_entity(cfqe->parent);
> +                       grp_total_weight = cfq_group_get_total_weight(p_cfqg);
> +                       group_slice = group_slice * cfqe->weight /
> +                                       grp_total_weight;
> +               } else {
> +                       /* For top level groups */
> +                       st = cfqe->service_tree;
> +                       group_slice = group_slice * cfqe->weight /
> +                                       st->total_weight;
> +               }
>
> -       return cfq_target_latency * cfqe->weight / st->total_weight;
> +               cfqe = cfqe->parent;
> +       } while (cfqe);
> +
> +       return group_slice;
>  }
>
>  static inline void
> @@ -672,7 +715,8 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>                        /* scale low_slice according to IO priority
>                         * and sync vs async */
>                        unsigned low_slice =
> -                               min(slice, base_low_slice * slice / sync_slice);
> +                               min(slice, base_low_slice * slice /
> +                                   sync_slice);
>                        /* the adapted slice value is scaled to fit all iqs
>                         * into the target latency */
>                        slice = max(slice * group_slice / expect_latency,
> @@ -812,17 +856,6 @@ static struct cfq_entity *cfq_rb_first(struct cfq_rb_root *root)
>        return NULL;
>  }
>
> -static struct cfq_entity *cfq_rb_first_entity(struct cfq_rb_root *root)
> -{
> -       if (!root->left)
> -               root->left = rb_first(&root->rb);
> -
> -       if (root->left)
> -               return rb_entry_entity(root->left);
> -
> -       return NULL;
> -}
> -
>  static void rb_erase_init(struct rb_node *n, struct rb_root *root)
>  {
>        rb_erase(n, root);
> @@ -896,12 +929,15 @@ __cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
>
>        rb_link_node(&cfqe->rb_node, parent, node);
>        rb_insert_color(&cfqe->rb_node, &st->rb);
> +
> +       update_min_vdisktime(st);
>  }
>
>  static void
>  cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
>  {
>        __cfq_entity_service_tree_add(st, cfqe);
> +       cfqe->reposition_time = jiffies;
>        st->count++;
>        st->total_weight += cfqe->weight;
>  }
> @@ -909,34 +945,52 @@ cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
>  static void
>  cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
> -       struct cfq_rb_root *st = &cfqd->grp_service_tree;
>        struct cfq_entity *cfqe = &cfqg->cfqe;
> -       struct cfq_entity *__cfqe;
>        struct rb_node *n;
> +       struct cfq_entity *entity;
> +       struct cfq_rb_root *st;
> +       struct cfq_group *__cfqg;
>
>        cfqg->nr_cfqq++;
> +
>        if (!RB_EMPTY_NODE(&cfqe->rb_node))
>                return;
>
>        /*
> -        * Currently put the group at the end. Later implement something
> -        * so that groups get lesser vtime based on their weights, so that
> -        * if group does not loose all if it was not continously backlogged.
> +        * Enqueue this group and its ancestors onto their service tree.
>         */
> -       n = rb_last(&st->rb);
> -       if (n) {
> -               __cfqe = rb_entry_entity(n);
> -               cfqe->vdisktime = __cfqe->vdisktime + CFQ_IDLE_DELAY;
> -       } else
> -               cfqe->vdisktime = st->min_vdisktime;
> +       while (cfqe) {
> +               if (!RB_EMPTY_NODE(&cfqe->rb_node))
> +                       return;
>
> -       cfq_entity_service_tree_add(st, cfqe);
> +               /*
> +                * Currently put the group at the end. Later implement
> +                * something so that groups get lesser vtime based on
> +                * their weights, so that if group does not loose all
> +                * if it was not continously backlogged.
> +                */
> +               st = cfqe->service_tree;
> +               n = rb_last(&st->rb);
> +               if (n) {
> +                       entity = rb_entry_entity(n);
> +                       cfqe->vdisktime = entity->vdisktime +
> +                               CFQ_IDLE_DELAY;
> +               } else
> +                       cfqe->vdisktime = st->min_vdisktime;
> +
> +               cfq_entity_service_tree_add(st, cfqe);
> +               cfqe = cfqe->parent;
> +               __cfqg = cfqg_of_entity(cfqe);
> +               if (__cfqg)
> +                       __cfqg->nr_subgp++;
> +       }
>  }
>
>  static void
>  __cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
>  {
>        cfq_rb_erase(&cfqe->rb_node, st);
> +       update_min_vdisktime(st);
>  }
>
>  static void
> @@ -945,27 +999,43 @@ cfq_entity_service_tree_del(struct cfq_rb_root *st, struct cfq_entity *cfqe)
>        if (!RB_EMPTY_NODE(&cfqe->rb_node)) {
>                __cfq_entity_service_tree_del(st, cfqe);
>                st->total_weight -= cfqe->weight;
> -               cfqe->service_tree = NULL;
>        }
>  }
>
>  static void
>  cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  {
> -       struct cfq_rb_root *st = &cfqd->grp_service_tree;
>        struct cfq_entity *cfqe = &cfqg->cfqe;
> +       struct cfq_group *__cfqg, *p_cfqg;
>
>        BUG_ON(cfqg->nr_cfqq < 1);
>        cfqg->nr_cfqq--;
>
> -       /* If there are other cfq queues under this group, don't delete it */
> -       if (cfqg->nr_cfqq)
> +       /*
> +        * If there are other cfq queues under this group, or there are other
> +        * cfq groups under this group, don't delete it.
> +        */
> +       if (cfqg->nr_cfqq || cfqg->nr_subgp)
>                return;
>
> -       cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
> -       cfq_entity_service_tree_del(st, cfqe);
> -       cfqg->saved_workload_slice = 0;
> -       cfq_blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
> +       /*
> +        * Dequeue this group and its ancestors from their service
> +        * tree.
> +        */
> +       while (cfqe) {
> +               __cfqg = cfqg_of_entity(cfqe);
> +               p_cfqg = cfqg_of_entity(cfqe->parent);
> +               cfq_entity_service_tree_del(cfqe->service_tree, cfqe);
> +               cfq_blkiocg_update_dequeue_stats(&__cfqg->blkg, 1);
> +               cfq_log_cfqg(cfqd, __cfqg, "del_from_rr group");
> +               __cfqg->saved_workload_slice = 0;
> +               cfqe = cfqe->parent;
> +               if (p_cfqg) {
> +                       p_cfqg->nr_subgp--;
> +                       if (p_cfqg->nr_cfqq || p_cfqg->nr_subgp)
> +                               return;
> +               }
> +       }
>  }
>
>  static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
> @@ -997,7 +1067,6 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
>  static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>                                struct cfq_queue *cfqq)
>  {
> -       struct cfq_rb_root *st = &cfqd->grp_service_tree;
>        unsigned int used_sl, charge;
>        int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
>                        - cfqg->service_tree_idle.count;
> @@ -1011,10 +1080,23 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>        else if (!cfq_cfqq_sync(cfqq) && !nr_sync)
>                charge = cfqq->allocated_slice;
>
> -       /* Can't update vdisktime while group is on service tree */
> -       __cfq_entity_service_tree_del(st, cfqe);
> -       cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
> -       __cfq_entity_service_tree_add(st, cfqe);
> +       /*
> +        * Update the vdisktime on the whole chain.
> +        */
> +       while (cfqe) {
> +               struct cfq_rb_root *st = cfqe->service_tree;
> +
> +               /*
> +                * Can't update vdisktime while group is on service
> +                * tree.
> +                */
> +               __cfq_entity_service_tree_del(st, cfqe);
> +               cfqe->vdisktime += cfq_scale_slice(charge, cfqe);
> +               __cfq_entity_service_tree_add(st, cfqe);
> +               st->count++;
> +               cfqe->reposition_time = jiffies;
> +               cfqe = cfqe->parent;
> +       }
>
>        /* This group is being expired. Save the context */
>        if (time_after(cfqd->workload_expires, jiffies)) {
> @@ -1026,7 +1108,8 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>                cfqg->saved_workload_slice = 0;
>
>        cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu",
> -                    cfqe->vdisktime, st->min_vdisktime);
> +                    cfqg->cfqe.vdisktime,
> +                    cfqg->cfqe.service_tree->min_vdisktime);
>        cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
>                        " sect=%u", used_sl, cfqq->slice_dispatch, charge,
>                        iops_mode(cfqd), cfqq->nr_sectors);
> @@ -1048,35 +1131,27 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
>        cfqg_of_blkg(blkg)->cfqe.weight = weight;
>  }
>
> -static struct cfq_group *
> -cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
> +static void init_cfqe(struct blkio_cgroup *blkcg,
> +                                   struct cfq_group *cfqg)
> +{
> +       struct cfq_entity *cfqe = &cfqg->cfqe;
> +
> +       cfqe->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
> +       RB_CLEAR_NODE(&cfqe->rb_node);
> +       cfqe->is_group_entity = true;
> +       cfqe->parent = NULL;
> +}
> +
> +static void init_cfqg(struct cfq_data *cfqd, struct blkio_cgroup *blkcg,
> +                     struct cfq_group *cfqg)
>  {
> -       struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> -       struct cfq_group *cfqg = NULL;
> -       void *key = cfqd;
>        int i, j;
>        struct cfq_rb_root *st;
> -       struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
>        unsigned int major, minor;
> -
> -       cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> -       if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
> -               sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> -               cfqg->blkg.dev = MKDEV(major, minor);
> -               goto done;
> -       }
> -       if (cfqg || !create)
> -               goto done;
> -
> -       cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC, cfqd->queue->node);
> -       if (!cfqg)
> -               goto done;
> +       struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
>
>        for_each_cfqg_st(cfqg, i, j, st)
>                *st = CFQ_RB_ROOT;
> -       RB_CLEAR_NODE(&cfqg->cfqe.rb_node);
> -
> -       cfqg->cfqe.is_group_entity = true;
>
>        /*
>         * Take the initial reference that will be released on destroy
> @@ -1086,24 +1161,199 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>         */
>        cfqg->ref = 1;
>
> +       /* Add group onto cgroup list */
> +       sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> +       cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
> +                                   MKDEV(major, minor));
> +       /* Initiate group entity */
> +       init_cfqe(blkcg, cfqg);
> +       /* Add group on cfqd list */
> +       hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
> +}
> +
> +static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg);
> +
> +static void uninit_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
> +{
> +       if (!cfq_blkiocg_del_blkio_group(&cfqg->blkg))
> +               cfq_destroy_cfqg(cfqd, cfqg);
> +}
> +
> +static void cfqg_set_parent(struct cfq_data *cfqd, struct cfq_group *cfqg,
> +                           struct cfq_group *p_cfqg)
> +{
> +       struct cfq_entity *cfqe, *p_cfqe;
> +
> +       cfqe = &cfqg->cfqe;
> +
>        /*
> -        * Add group onto cgroup list. It might happen that bdi->dev is
> -        * not initiliazed yet. Initialize this new group without major
> -        * and minor info and this info will be filled in once a new thread
> -        * comes for IO. See code above.
> +        * 1. If use_hierarchy of the CGroup where cfqg's parent stays is not
> +        *    set, we put this cfqg onto global service tree.
> +        * 2. If cfqg is root cfqg, put it onto global service tree.
>         */
> -       if (bdi->dev) {
> -               sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> -               cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
> -                                       MKDEV(major, minor));
> -       } else
> -               cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
> -                                       0);
> +       if (!p_cfqg) {
> +               cfqe->service_tree = &cfqd->grp_service_tree;
> +               cfqe->parent = NULL;
> +               return;
> +       }
>
> -       cfqg->cfqe.weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
> +       p_cfqe = &p_cfqg->cfqe;
>
> -       /* Add group on cfqd list */
> -       hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
> +       cfqe->parent = p_cfqe;
> +
> +       /*
> +        * Currently, just put cfq group entity on "BE:SYNC" workload
> +        * service tree.
> +        */
> +       cfqe->service_tree = service_tree_for(p_cfqg, BE_WORKLOAD,
> +                                                     SYNC_WORKLOAD);
> +       /* child reference */
> +       p_cfqg->ref++;
> +}
> +
> +static struct cfq_group *cfqg_get_parent(struct cfq_group * cfqg)
> +{
> +       struct cfq_entity *cfqe, *p_cfqe;
> +
> +       if (!cfqg)
> +               return NULL;
> +
> +       cfqe = &cfqg->cfqe;
> +       p_cfqe = cfqe->parent;
> +       if (!p_cfqe)
> +               return NULL;
> +
> +       return cfqg_of_entity(p_cfqe);
> +}
> +
> +static struct cfq_group *
> +cfqg_chain_alloc(struct cfq_data *cfqd, struct cgroup *cgroup)
> +{
> +       struct blkio_cgroup *blkcg;
> +       struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
> +       unsigned int major, minor;
> +       struct cfq_group *cfqg, *leaf_cfqg, *child_cfqg, *tmp_cfqg;
> +       void *key = cfqd;
> +
> +       /*
> +        * If CGroup's use_hierarchy is unset, we just need to allocate only
> +        * one CFQ group, and this group will put onto the "grp_service_tree".
> +        * We don't need to check whether the cfqg exists, the caller has
> +        * already checked it.
> +        */
> +       blkcg = cgroup_to_blkio_cgroup(cgroup);
> +       if (!blkcg_get_use_hierarchy(blkcg)) {
> +               cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC,
> +                                   cfqd->queue->node);
> +               if (!cfqg)
> +                       return NULL;
> +
> +               init_cfqg(cfqd, blkcg, cfqg);
> +               cfqg_set_parent(cfqd, cfqg, NULL);
> +               return cfqg;
> +       }
> +
> +       /*
> +        * Allocate the CFQ group chain until we meet the group we'v already
> +        * allocated before, or to the CGroup whose use_hierarchy is not set.
> +        */
> +       leaf_cfqg = NULL;
> +       child_cfqg = NULL;
> +       for (; cgroup != NULL; cgroup = cgroup->parent) {
> +               blkcg = cgroup_to_blkio_cgroup(cgroup);
> +               cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +               if (cfqg) {
> +                       if (!cfqg->blkg.dev && bdi->dev &&
> +                           dev_name(bdi->dev)) {
> +                               sscanf(dev_name(bdi->dev), "%u:%u",
> +                                      &major, &minor);
> +                               cfqg->blkg.dev = MKDEV(major, minor);
> +                       }
> +
> +                       /*
> +                        * Initialization of parent doesn't finish yet, get
> +                        * it done.
> +                        */
> +                       if (child_cfqg) {
> +                               if (blkcg_get_use_hierarchy(blkcg))
> +                                       cfqg_set_parent(cfqd, child_cfqg,
> +                                                       cfqg);
> +                               else
> +                                       cfqg_set_parent(cfqd, child_cfqg,
> +                                                       NULL);
> +                       }
> +
> +                       /* chain has already been built */
> +                       break;
> +               }
> +
> +               /*
> +                * We only allocate a cfqg that the corresponding cgroup's
> +                * use_hierarchy is set.
> +                */
> +               if (blkcg_get_use_hierarchy(blkcg)) {
> +                       cfqg = kzalloc_node(sizeof(*cfqg), GFP_ATOMIC,
> +                                           cfqd->queue->node);
> +                       if (!cfqg)
> +                               goto clean_up;
> +
> +                       if (!leaf_cfqg)
> +                               leaf_cfqg = cfqg;
> +
> +                       init_cfqg(cfqd, blkcg, cfqg);
> +               } else {
> +                       cfqg = NULL;
> +               }
> +
> +               if (child_cfqg)
> +                       cfqg_set_parent(cfqd, child_cfqg, cfqg);
> +
> +               /*
> +                * This CGroup's use_hierarchy isn't set, this means the CFQ
> +                * group chain has been built.
> +                */
> +               if (!blkcg_get_use_hierarchy(blkcg))
> +                       break;
> +
> +               child_cfqg = cfqg;
> +       }
> +
> +       return leaf_cfqg;
> +
> +clean_up:
> +       /* clean up the allocated cfq groups. */
> +       while (leaf_cfqg) {
> +               tmp_cfqg = leaf_cfqg;
> +               leaf_cfqg = cfqg_get_parent(leaf_cfqg);
> +               uninit_cfqg(cfqd, tmp_cfqg);
> +       }
> +
> +       return NULL;
> +}
> +
> +static struct cfq_group *
> +cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
> +{
> +       struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> +       struct cfq_group *cfqg = NULL;
> +       void *key = cfqd;
> +       struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
> +       unsigned int major, minor;
> +
> +       cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +       if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
> +               sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> +               cfqg->blkg.dev = MKDEV(major, minor);
> +               goto done;
> +       }
> +       if (cfqg || !create)
> +               goto done;
> +
> +       /*
> +        * Allocate CFQ group chain to the root group or we meet the CGroup
> +        * with use_hierarchy disabled.
> +        */
> +       cfqg = cfqg_chain_alloc(cfqd, cgroup);
>
>  done:
>        return cfqg;
> @@ -1148,6 +1398,7 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
>  {
>        struct cfq_rb_root *st;
>        int i, j;
> +       struct cfq_group *p_cfqg;
>
>        BUG_ON(cfqg->ref <= 0);
>        cfqg->ref--;
> @@ -1155,6 +1406,22 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
>                return;
>        for_each_cfqg_st(cfqg, i, j, st)
>                BUG_ON(!RB_EMPTY_ROOT(&st->rb));
> +
> +       do {
> +               p_cfqg = cfqg_get_parent(cfqg);
> +               kfree(cfqg);
> +               cfqg = NULL;
> +               /*
> +                * Drop the reference taken by children, if nobody references
> +                * parent group, we need delete the parent also.
> +                */
> +               if (p_cfqg) {
> +                       p_cfqg->ref--;
> +                       if (p_cfqg->ref == 0)
> +                               cfqg = p_cfqg;
> +               }
> +       } while (cfqg);
> +
>        kfree(cfqg);
>  }
>
> @@ -1321,9 +1588,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                         * ioprio.
>                         */
>                        pos_offset = cfq_get_boost(cfqd, cfqq);
> -                       /* Debug purpose, should remove. */
> -                       cfq_log_cfqq(cfqd, cfqq, "pos_offset: %llu",
> -                                    pos_offset);
>                        cfqe->vdisktime = service_tree->min_vdisktime +
>                                                pos_offset;
>                } else
> @@ -1365,9 +1629,8 @@ insert:
>        cfqe->service_tree = service_tree;
>
>        /* Add cfqq onto service tree. */
> +
>        cfq_entity_service_tree_add(service_tree, cfqe);
> -       update_min_vdisktime(service_tree);
> -       cfqq->reposition_time = jiffies;
>        if ((add_front || !new_cfqq) && !group_changed)
>                return;
>        cfq_group_service_tree_add(cfqd, cfqq->cfqg);
> @@ -1810,28 +2073,43 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
>        return cfqq_of_entity(cfq_rb_first(service_tree));
>  }
>
> -static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
> +struct cfq_rb_root *choose_service_tree_forced(struct cfq_group *cfqg)
>  {
> -       struct cfq_group *cfqg;
> -       struct cfq_entity *cfqe;
>        int i, j;
>        struct cfq_rb_root *st;
>
> -       if (!cfqd->rq_queued)
> -               return NULL;
> +       for_each_cfqg_st(cfqg, i, j, st) {
> +               if (st->count != 0)
> +                       return st;
> +       }
>
> -       cfqg = cfq_get_next_cfqg(cfqd);
> -       if (!cfqg)
> +       return NULL;
> +}
> +
> +static struct cfq_entity *
> +cfq_get_next_entity_forced(struct cfq_data *cfqd)
> +{
> +       struct cfq_entity *cfqe;
> +       struct cfq_rb_root *st = &cfqd->grp_service_tree;
> +       struct cfq_group *cfqg;
> +
> +       if (!cfqd->rq_queued)
>                return NULL;
>
> -       for_each_cfqg_st(cfqg, i, j, st) {
> +       do {
>                cfqe = cfq_rb_first(st);
> -               if (cfqe != NULL)
> -                       return cfqq_of_entity(cfqe);
> -       }
> +               if (cfqe && !cfqe->is_group_entity)
> +                       return cfqe;
> +               else if (cfqe && cfqe->is_group_entity)
> +                       cfqg = cfqg_of_entity(cfqe);
> +
> +               st = choose_service_tree_forced(cfqg);
> +       } while (st);
> +
>        return NULL;
>  }
>
> +
>  /*
>  * Get and set a new active qu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
