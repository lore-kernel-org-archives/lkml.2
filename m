Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0DCB74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:59:56 -0400
Received: from smtp-out.google.com ([74.125.121.35]:15602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab0DCB7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:59:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hgRqySuY9J40fjT5DNMamdhPTinqPbLY901oxvnrbvg4E8KMD7F/D2z+KC3gLRzyR
	32yNTxoLty+FqNK3y6x5w==
MIME-Version: 1.0
In-Reply-To: <20100403015553.30746.86746.stgit@austin.mtv.corp.google.com>
References: <20100403014724.30746.16081.stgit@austin.mtv.corp.google.com> 
	<20100403015553.30746.86746.stgit@austin.mtv.corp.google.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 2 Apr 2010 18:59:18 -0700
Message-ID: <s2xaf41c7c41004021859i84ac7a77h52f0a3e297123036@mail.gmail.com>
Subject: Re: [PATCH 2/3][v2] blkio: Add io controller stats like
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed the v2 tag on this patch. Resending. Apologies for the spam.

On Fri, Apr 2, 2010 at 6:56 PM, Divyesh Shah <dpshah@google.com> wrote:
> - io_service_time (the actual time in ns taken by the dis to service the IO)
> - io_wait_time (the time spent waiting in the IO shceduler queues before
>  getting serviced)
> - io_serviced (number of IOs serviced from this blkio_group)
> - io_service_bytes (Number of bytes served for this cgroup)
>
> These stats are accumulated per operation type helping us to distinguish between
> read and write, and sync and async IO. This patch does not increment any of
> these stats.
>
> Signed-off-by: Divyesh Shah<dpshah@google.com>
> ---
>
>  Documentation/cgroups/blkio-controller.txt |   33 +++++
>  block/blk-cgroup.c                         |  179 +++++++++++++++++++++++++---
>  block/blk-cgroup.h                         |   41 +++++-
>  block/cfq-iosched.c                        |    2
>  4 files changed, 229 insertions(+), 26 deletions(-)
>
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index 630879c..ededdca 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -75,6 +75,9 @@ CONFIG_DEBUG_BLK_CGROUP
>
>  Details of cgroup files
>  =======================
> +Writing an int to any of the stats files (which excludes weight) will result
> +in all stats for that cgroup to be erased.
> +
>  - blkio.weight
>        - Specifies per cgroup weight.
>
> @@ -92,6 +95,36 @@ Details of cgroup files
>          third field specifies the number of sectors transferred by the
>          group to/from the device.
>
> +- blkio.io_service_bytes
> +       - Number of bytes transferred to/from the disk by the group. These
> +         are further divided by the type of operation - read or write, sync
> +         or async. First two fields specify the major and minor number of the
> +         device, third field specifies the operation type and the fourth field
> +         specifies the number of bytes.
> +
> +- blkio.io_serviced
> +       - Number of IOs completed to/from the disk by the group. These
> +         are further divided by the type of operation - read or write, sync
> +         or async. First two fields specify the major and minor number of the
> +         device, third field specifies the operation type and the fourth field
> +         specifies the number of IOs.
> +
> +- blkio.io_service_time
> +       - Total amount of time spent by the device to service the IOs for this
> +         cgroup. This is in nanoseconds to make it meaningful for flash
> +         devices too. This time is further divided by the type of operation -
> +         read or write, sync or async. First two fields specify the major and
> +         minor number of the device, third field specifies the operation type
> +         and the fourth field specifies the io_service_time in ns.
> +
> +- blkio.io_wait_time
> +       - Total amount of time the IO spent waiting in the scheduler queues for
> +         service. This is in nanoseconds to make it meaningful for flash
> +         devices too. This time is further divided by the type of operation -
> +         read or write, sync or async. First two fields specify the major and
> +         minor number of the device, third field specifies the operation type
> +         and the fourth field specifies the io_wait_time in ns.
> +
>  - blkio.dequeue
>        - Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
>          gives the statistics about how many a times a group was dequeued
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 5be3981..cac10b2 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -17,6 +17,8 @@
>  #include <linux/err.h>
>  #include "blk-cgroup.h"
>
> +#define MAX_KEY_LEN 100
> +
>  static DEFINE_SPINLOCK(blkio_list_lock);
>  static LIST_HEAD(blkio_list);
>
> @@ -55,12 +57,15 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>  }
>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>
> -void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> -                                               unsigned long time)
> +void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>  {
> -       blkg->time += time;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&blkg->stats_lock, flags);
> +       blkg->stats.time += time;
> +       spin_unlock_irqrestore(&blkg->stats_lock, flags);
>  }
> -EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_stats);
> +EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
>
>  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>                        struct blkio_group *blkg, void *key, dev_t dev)
> @@ -170,13 +175,119 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>        return 0;
>  }
>
> -#define SHOW_FUNCTION_PER_GROUP(__VAR)                                 \
> +static int
> +blkiocg_reset_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
> +{
> +       struct blkio_cgroup *blkcg;
> +       struct blkio_group *blkg;
> +       struct hlist_node *n;
> +       struct blkio_group_stats *stats;
> +
> +       blkcg = cgroup_to_blkio_cgroup(cgroup);
> +       spin_lock_irq(&blkcg->lock);
> +       hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> +               spin_lock(&blkg->stats_lock);
> +               stats = &blkg->stats;
> +               memset(stats, 0, sizeof(struct blkio_group_stats));
> +               spin_unlock(&blkg->stats_lock);
> +       }
> +       spin_unlock_irq(&blkcg->lock);
> +       return 0;
> +}
> +
> +static void blkio_get_key_name(int type, dev_t dev, char *str, int chars_left)
> +{
> +       snprintf(str, chars_left, "%u:%u", MAJOR(dev), MINOR(dev));
> +       chars_left -= strlen(str);
> +       if (chars_left <= 0) {
> +               printk(KERN_WARNING
> +                       "Possibly incorrect cgroup stat display format");
> +               return;
> +       }
> +       switch (type) {
> +       case IO_READ:
> +               strlcat(str, " Read", chars_left);
> +               break;
> +       case IO_WRITE:
> +               strlcat(str, " Write", chars_left);
> +               break;
> +       case IO_SYNC:
> +               strlcat(str, " Sync", chars_left);
> +               break;
> +       case IO_ASYNC:
> +               strlcat(str, " Async", chars_left);
> +               break;
> +       case IO_TYPE_TOTAL:
> +               strlcat(str, " Total", chars_left);
> +               break;
> +       default:
> +               strlcat(str, " Invalid", chars_left);
> +       }
> +}
> +
> +typedef uint64_t (get_var) (struct blkio_group *, int);
> +
> +static uint64_t blkio_get_typed_stat(struct blkio_group *blkg,
> +               struct cgroup_map_cb *cb, get_var *getvar, dev_t dev)
> +{
> +       uint64_t disk_total;
> +       char key_str[MAX_KEY_LEN];
> +       int type;
> +
> +       for (type = 0; type < IO_TYPE_TOTAL; type++) {
> +               blkio_get_key_name(type, dev, key_str, MAX_KEY_LEN);
> +               cb->fill(cb, key_str, getvar(blkg, type));
> +       }
> +       disk_total = getvar(blkg, IO_READ) + getvar(blkg, IO_WRITE);
> +       blkio_get_key_name(IO_TYPE_TOTAL, dev, key_str, MAX_KEY_LEN);
> +       cb->fill(cb, key_str, disk_total);
> +       return disk_total;
> +}
> +
> +static uint64_t blkio_get_stat(struct blkio_group *blkg,
> +               struct cgroup_map_cb *cb, get_var *getvar, dev_t dev)
> +{
> +       uint64_t var = getvar(blkg, 0);
> +       char str[10];
> +
> +       snprintf(str, 10, "%u:%u", MAJOR(dev), MINOR(dev));
> +       cb->fill(cb, str, var);
> +       return var;
> +}
> +
> +#define GET_STAT_INDEXED(__VAR)                                                \
> +uint64_t blkio_get_##__VAR##_stat(struct blkio_group *blkg, int type)  \
> +{                                                                      \
> +       return blkg->stats.__VAR[type];                                 \
> +}                                                                      \
> +
> +GET_STAT_INDEXED(io_service_bytes);
> +GET_STAT_INDEXED(io_serviced);
> +GET_STAT_INDEXED(io_service_time);
> +GET_STAT_INDEXED(io_wait_time);
> +#undef GET_STAT_INDEXED
> +
> +#define GET_STAT(__VAR)                                                        \
> +uint64_t blkio_get_##__VAR##_stat(struct blkio_group *blkg, int dummy) \
> +{                                                                      \
> +       return blkg->stats.__VAR;                                       \
> +}
> +
> +GET_STAT(time);
> +GET_STAT(sectors);
> +#ifdef CONFIG_DEBUG_BLK_CGROUP
> +GET_STAT(dequeue);
> +#endif
> +#undef GET_STAT
> +
> +#define SHOW_FUNCTION_PER_GROUP(__VAR, get_stats, getvar, show_total)  \
>  static int blkiocg_##__VAR##_read(struct cgroup *cgroup,               \
> -                       struct cftype *cftype, struct seq_file *m)      \
> +               struct cftype *cftype, struct cgroup_map_cb *cb)        \
>  {                                                                      \
>        struct blkio_cgroup *blkcg;                                     \
>        struct blkio_group *blkg;                                       \
>        struct hlist_node *n;                                           \
> +       uint64_t cgroup_total = 0;                                      \
>                                                                        \
>        if (!cgroup_lock_live_group(cgroup))                            \
>                return -ENODEV;                                         \
> @@ -184,19 +295,32 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,          \
>        blkcg = cgroup_to_blkio_cgroup(cgroup);                         \
>        rcu_read_lock();                                                \
>        hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {\
> -               if (blkg->dev)                                          \
> -                       seq_printf(m, "%u:%u %lu\n", MAJOR(blkg->dev),  \
> -                                MINOR(blkg->dev), blkg->__VAR);        \
> +               if (blkg->dev) {                                        \
> +                       spin_lock_irq(&blkg->stats_lock);               \
> +                       cgroup_total += get_stats(blkg, cb, getvar,     \
> +                                               blkg->dev);             \
> +                       spin_unlock_irq(&blkg->stats_lock);             \
> +               }                                                       \
>        }                                                               \
> +       if (show_total)                                                 \
> +               cb->fill(cb, "Total", cgroup_total);                    \
>        rcu_read_unlock();                                              \
>        cgroup_unlock();                                                \
>        return 0;                                                       \
>  }
>
> -SHOW_FUNCTION_PER_GROUP(time);
> -SHOW_FUNCTION_PER_GROUP(sectors);
> +SHOW_FUNCTION_PER_GROUP(time, blkio_get_stat, blkio_get_time_stat, 0);
> +SHOW_FUNCTION_PER_GROUP(sectors, blkio_get_stat, blkio_get_sectors_stat, 0);
> +SHOW_FUNCTION_PER_GROUP(io_service_bytes, blkio_get_typed_stat,
> +                       blkio_get_io_service_bytes_stat, 1);
> +SHOW_FUNCTION_PER_GROUP(io_serviced, blkio_get_typed_stat,
> +                       blkio_get_io_serviced_stat, 1);
> +SHOW_FUNCTION_PER_GROUP(io_service_time, blkio_get_typed_stat,
> +                       blkio_get_io_service_time_stat, 1);
> +SHOW_FUNCTION_PER_GROUP(io_wait_time, blkio_get_typed_stat,
> +                       blkio_get_io_wait_time_stat, 1);
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
> -SHOW_FUNCTION_PER_GROUP(dequeue);
> +SHOW_FUNCTION_PER_GROUP(dequeue, blkio_get_stat, blkio_get_dequeue_stat, 0);
>  #endif
>  #undef SHOW_FUNCTION_PER_GROUP
>
> @@ -204,7 +328,7 @@ SHOW_FUNCTION_PER_GROUP(dequeue);
>  void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
>                        unsigned long dequeue)
>  {
> -       blkg->dequeue += dequeue;
> +       blkg->stats.dequeue += dequeue;
>  }
>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
>  #endif
> @@ -217,16 +341,39 @@ struct cftype blkio_files[] = {
>        },
>        {
>                .name = "time",
> -               .read_seq_string = blkiocg_time_read,
> +               .read_map = blkiocg_time_read,
> +               .write_u64 = blkiocg_reset_write,
>        },
>        {
>                .name = "sectors",
> -               .read_seq_string = blkiocg_sectors_read,
> +               .read_map = blkiocg_sectors_read,
> +               .write_u64 = blkiocg_reset_write,
> +       },
> +       {
> +               .name = "io_service_bytes",
> +               .read_map = blkiocg_io_service_bytes_read,
> +               .write_u64 = blkiocg_reset_write,
> +       },
> +       {
> +               .name = "io_serviced",
> +               .read_map = blkiocg_io_serviced_read,
> +               .write_u64 = blkiocg_reset_write,
> +       },
> +       {
> +               .name = "io_service_time",
> +               .read_map = blkiocg_io_service_time_read,
> +               .write_u64 = blkiocg_reset_write,
> +       },
> +       {
> +               .name = "io_wait_time",
> +               .read_map = blkiocg_io_wait_time_read,
> +               .write_u64 = blkiocg_reset_write,
>        },
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>        {
>                .name = "dequeue",
> -               .read_seq_string = blkiocg_dequeue_read,
> +               .read_map = blkiocg_dequeue_read,
> +               .write_u64 = blkiocg_reset_write,
>        },
>  #endif
>  };
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index fe44517..e8600b0 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -23,6 +23,14 @@ extern struct cgroup_subsys blkio_subsys;
>  #define blkio_subsys_id blkio_subsys.subsys_id
>  #endif
>
> +enum io_type {
> +       IO_READ = 0,
> +       IO_WRITE,
> +       IO_SYNC,
> +       IO_ASYNC,
> +       IO_TYPE_TOTAL
> +};
> +
>  struct blkio_cgroup {
>        struct cgroup_subsys_state css;
>        unsigned int weight;
> @@ -30,6 +38,23 @@ struct blkio_cgroup {
>        struct hlist_head blkg_list;
>  };
>
> +struct blkio_group_stats {
> +       /* total disk time and nr sectors dispatched by this group */
> +       uint64_t time;
> +       uint64_t sectors;
> +       /* Total disk time used by IOs in ns */
> +       uint64_t io_service_time[IO_TYPE_TOTAL];
> +       uint64_t io_service_bytes[IO_TYPE_TOTAL]; /* Total bytes transferred */
> +       /* Total IOs serviced, post merge */
> +       uint64_t io_serviced[IO_TYPE_TOTAL];
> +       /* Total time spent waiting in scheduler queue in ns */
> +       uint64_t io_wait_time[IO_TYPE_TOTAL];
> +#ifdef CONFIG_DEBUG_BLK_CGROUP
> +       /* How many times this group has been removed from service tree */
> +       unsigned long dequeue;
> +#endif
> +};
> +
>  struct blkio_group {
>        /* An rcu protected unique identifier for the group */
>        void *key;
> @@ -38,15 +63,13 @@ struct blkio_group {
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>        /* Store cgroup path */
>        char path[128];
> -       /* How many times this group has been removed from service tree */
> -       unsigned long dequeue;
>  #endif
>        /* The device MKDEV(major, minor), this group has been created for */
> -       dev_t   dev;
> +       dev_t dev;
>
> -       /* total disk time and nr sectors dispatched by this group */
> -       unsigned long time;
> -       unsigned long sectors;
> +       /* Need to serialize the stats in the case of reset/update */
> +       spinlock_t stats_lock;
> +       struct blkio_group_stats stats;
>  };
>
>  typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
> @@ -105,8 +128,8 @@ extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
>  extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
>                                                void *key);
> -void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> -                                               unsigned long time);
> +void blkiocg_update_timeslice_used(struct blkio_group *blkg,
> +                                       unsigned long time);
>  #else
>  struct cgroup;
>  static inline struct blkio_cgroup *
> @@ -122,7 +145,7 @@ blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
>
>  static inline struct blkio_group *
>  blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
> -static inline void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> +static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>                                                unsigned long time) {}
>  #endif
>  #endif /* _BLK_CGROUP_H */
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index c18e348..d91df9f 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -914,7 +914,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>
>        cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
>                                        st->min_vdisktime);
> -       blkiocg_update_blkio_group_stats(&cfqg->blkg, used_sl);
> +       blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
>  }
>
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
>
>
