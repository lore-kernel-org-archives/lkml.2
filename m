Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0DHCWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:22:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52599 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0DHCWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:22:21 -0400
Message-ID: <4BBD3DB9.8090006@cn.fujitsu.com>
Date: Thu, 08 Apr 2010 10:21:45 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Divyesh Shah <dpshah@google.com>
CC: jens.axboe@oracle.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       nauman@google.com, ctalbott@google.com
Subject: Re: [PATCH][v3.1] blkio: Add io controller stats like
References: <20100406232533.25602.46349.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100406232533.25602.46349.stgit@austin.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divyesh Shah wrote:
> - io_service_time (the total time between request dispatch and completion for
>   all IOs in the cgroup)
> - io_wait_time (the total time spent waiting by all IOs in this cgroup in the IO
>   scheduler queues before getting serviced)
> - io_serviced (number of IOs serviced from this blkio_group)
> - io_service_bytes (Number of bytes served for this cgroup)
> 
> These stats are accumulated per operation type helping us to distinguish between
> read and write, and sync and async IO. This patch does not increment any of
> these stats.
> 
> Changelog from v3:
> o renamed blkiocg_reset_write to blkiocg_reset_stats
> o more clarification in the documentation on io_service_time and io_wait_time.
> 
> Signed-off-by: Divyesh Shah<dpshah@google.com>

Hi Divyesh,

Jens has already applied previous patchset to for-2.6.35 branch, so v3 patchset
and this patch have conflicts with for-2.6.35 branch. I think it's better to make
new patch on top of for-2.6.35.

Thanks,
Gui

> ---
> 
>  Documentation/cgroups/blkio-controller.txt |   48 ++++++++
>  block/blk-cgroup.c                         |  166 +++++++++++++++++++++++++---
>  block/blk-cgroup.h                         |   60 ++++++++--
>  block/cfq-iosched.c                        |    3 -
>  4 files changed, 247 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index 630879c..ed04fe9 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -77,7 +77,6 @@ Details of cgroup files
>  =======================
>  - blkio.weight
>  	- Specifies per cgroup weight.
> -
>  	  Currently allowed range of weights is from 100 to 1000.
>  
>  - blkio.time
> @@ -92,6 +91,49 @@ Details of cgroup files
>  	  third field specifies the number of sectors transferred by the
>  	  group to/from the device.
>  
> +- blkio.io_service_bytes
> +	- Number of bytes transferred to/from the disk by the group. These
> +	  are further divided by the type of operation - read or write, sync
> +	  or async. First two fields specify the major and minor number of the
> +	  device, third field specifies the operation type and the fourth field
> +	  specifies the number of bytes.
> +
> +- blkio.io_serviced
> +	- Number of IOs completed to/from the disk by the group. These
> +	  are further divided by the type of operation - read or write, sync
> +	  or async. First two fields specify the major and minor number of the
> +	  device, third field specifies the operation type and the fourth field
> +	  specifies the number of IOs.
> +
> +- blkio.io_service_time
> +	- Total amount of time between request dispatch and request completion
> +	  for the IOs done by this cgroup. This is in nanoseconds to make it
> +	  meaningful for flash devices too. For devices with queue depth of 1,
> +	  this time represents the actual service time. When queue_depth > 1,
> +	  that is no longer true as requests may be served out of order. This
> +	  may cause the service time for a given IO to include the service time
> +	  of multiple IOs when served out of order which may result in total
> +	  io_service_time > actual time elapsed. This time is further divided by
> +	  the type of operation - read or write, sync or async. First two fields
> +	  specify the major and minor number of the device, third field
> +	  specifies the operation type and the fourth field specifies the
> +	  io_service_time in ns.
> +
> +- blkio.io_wait_time
> +	- Total amount of time the IOs for this cgroup spent waiting in the
> +	  scheduler queues for service. This can be greater than the total time
> +	  elapsed since it is cumulative io_wait_time for all IOs. It is not a
> +	  measure of total time the cgroup spent waiting but rather a measure of
> +	  the wait_time for its individual IOs. For devices with queue_depth > 1
> +	  this metric does not include the time spent waiting for service once
> +	  the IO is dispatched to the device but till it actually gets serviced
> +	  (there might be a time lag here due to re-ordering of requests by the
> +	  device). This is in nanoseconds to make it meaningful for flash
> +	  devices too. This time is further divided by the type of operation -
> +	  read or write, sync or async. First two fields specify the major and
> +	  minor number of the device, third field specifies the operation type
> +	  and the fourth field specifies the io_wait_time in ns.
> +
>  - blkio.dequeue
>  	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
>  	  gives the statistics about how many a times a group was dequeued
> @@ -99,6 +141,10 @@ Details of cgroup files
>  	  and minor number of the device and third field specifies the number
>  	  of times a group was dequeued from a particular device.
>  
> +- blkio.reset_stats
> +	- Writing an int to this file will result in resetting all the stats
> +	  for that cgroup.
> +
>  CFQ sysfs tunable
>  =================
>  /sys/block/<disk>/queue/iosched/group_isolation
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 5be3981..5849a63 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -17,6 +17,8 @@
>  #include <linux/err.h>
>  #include "blk-cgroup.h"
>  
> +#define MAX_KEY_LEN 100
> +
>  static DEFINE_SPINLOCK(blkio_list_lock);
>  static LIST_HEAD(blkio_list);
>  
> @@ -55,12 +57,21 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>  }
>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>  
> -void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> -						unsigned long time)
> +void blkio_group_init(struct blkio_group *blkg)
> +{
> +	spin_lock_init(&blkg->stats_lock);
> +}
> +EXPORT_SYMBOL_GPL(blkio_group_init);
> +
> +void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>  {
> -	blkg->time += time;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&blkg->stats_lock, flags);
> +	blkg->stats.time += time;
> +	spin_unlock_irqrestore(&blkg->stats_lock, flags);
>  }
> -EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_stats);
> +EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
>  
>  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  			struct blkio_group *blkg, void *key, dev_t dev)
> @@ -170,13 +181,107 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>  	return 0;
>  }
>  
> -#define SHOW_FUNCTION_PER_GROUP(__VAR)					\
> +static int
> +blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
> +{
> +	struct blkio_cgroup *blkcg;
> +	struct blkio_group *blkg;
> +	struct hlist_node *n;
> +	struct blkio_group_stats *stats;
> +
> +	blkcg = cgroup_to_blkio_cgroup(cgroup);
> +	spin_lock_irq(&blkcg->lock);
> +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
> +		spin_lock(&blkg->stats_lock);
> +		stats = &blkg->stats;
> +		memset(stats, 0, sizeof(struct blkio_group_stats));
> +		spin_unlock(&blkg->stats_lock);
> +	}
> +	spin_unlock_irq(&blkcg->lock);
> +	return 0;
> +}
> +
> +static void blkio_get_key_name(enum stat_sub_type type, dev_t dev, char *str,
> +				int chars_left, bool diskname_only)
> +{
> +	snprintf(str, chars_left, "%d:%d", MAJOR(dev), MINOR(dev));
> +	chars_left -= strlen(str);
> +	if (chars_left <= 0) {
> +		printk(KERN_WARNING
> +			"Possibly incorrect cgroup stat display format");
> +		return;
> +	}
> +	if (diskname_only)
> +		return;
> +	switch (type) {
> +	case BLKIO_STAT_READ:
> +		strlcat(str, " Read", chars_left);
> +		break;
> +	case BLKIO_STAT_WRITE:
> +		strlcat(str, " Write", chars_left);
> +		break;
> +	case BLKIO_STAT_SYNC:
> +		strlcat(str, " Sync", chars_left);
> +		break;
> +	case BLKIO_STAT_ASYNC:
> +		strlcat(str, " Async", chars_left);
> +		break;
> +	case BLKIO_STAT_TOTAL:
> +		strlcat(str, " Total", chars_left);
> +		break;
> +	default:
> +		strlcat(str, " Invalid", chars_left);
> +	}
> +}
> +
> +static uint64_t blkio_fill_stat(char *str, int chars_left, uint64_t val,
> +				struct cgroup_map_cb *cb, dev_t dev)
> +{
> +	blkio_get_key_name(0, dev, str, chars_left, true);
> +	cb->fill(cb, str, val);
> +	return val;
> +}
> +
> +/* This should be called with blkg->stats_lock held */
> +static uint64_t blkio_get_stat(struct blkio_group *blkg,
> +		struct cgroup_map_cb *cb, dev_t dev, enum stat_type type)
> +{
> +	uint64_t disk_total;
> +	char key_str[MAX_KEY_LEN];
> +	enum stat_sub_type sub_type;
> +
> +	if (type == BLKIO_STAT_TIME)
> +		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
> +					blkg->stats.time, cb, dev);
> +	if (type == BLKIO_STAT_SECTORS)
> +		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
> +					blkg->stats.sectors, cb, dev);
> +#ifdef CONFIG_DEBUG_BLK_CGROUP
> +	if (type == BLKIO_STAT_DEQUEUE)
> +		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
> +					blkg->stats.dequeue, cb, dev);
> +#endif
> +
> +	for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
> +			sub_type++) {
> +		blkio_get_key_name(sub_type, dev, key_str, MAX_KEY_LEN, false);
> +		cb->fill(cb, key_str, blkg->stats.stat_arr[type][sub_type]);
> +	}
> +	disk_total = blkg->stats.stat_arr[type][BLKIO_STAT_READ] +
> +			blkg->stats.stat_arr[type][BLKIO_STAT_WRITE];
> +	blkio_get_key_name(BLKIO_STAT_TOTAL, dev, key_str, MAX_KEY_LEN, false);
> +	cb->fill(cb, key_str, disk_total);
> +	return disk_total;
> +}
> +
> +#define SHOW_FUNCTION_PER_GROUP(__VAR, type, show_total)		\
>  static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
> -			struct cftype *cftype, struct seq_file *m)	\
> +		struct cftype *cftype, struct cgroup_map_cb *cb)	\
>  {									\
>  	struct blkio_cgroup *blkcg;					\
>  	struct blkio_group *blkg;					\
>  	struct hlist_node *n;						\
> +	uint64_t cgroup_total = 0;					\
>  									\
>  	if (!cgroup_lock_live_group(cgroup))				\
>  		return -ENODEV;						\
> @@ -184,19 +289,28 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
>  	blkcg = cgroup_to_blkio_cgroup(cgroup);				\
>  	rcu_read_lock();						\
>  	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {\
> -		if (blkg->dev)						\
> -			seq_printf(m, "%u:%u %lu\n", MAJOR(blkg->dev),	\
> -				 MINOR(blkg->dev), blkg->__VAR);	\
> +		if (blkg->dev) {					\
> +			spin_lock_irq(&blkg->stats_lock);		\
> +			cgroup_total += blkio_get_stat(blkg, cb,	\
> +						blkg->dev, type);	\
> +			spin_unlock_irq(&blkg->stats_lock);		\
> +		}							\
>  	}								\
> +	if (show_total)							\
> +		cb->fill(cb, "Total", cgroup_total);			\
>  	rcu_read_unlock();						\
>  	cgroup_unlock();						\
>  	return 0;							\
>  }
>  
> -SHOW_FUNCTION_PER_GROUP(time);
> -SHOW_FUNCTION_PER_GROUP(sectors);
> +SHOW_FUNCTION_PER_GROUP(time, BLKIO_STAT_TIME, 0);
> +SHOW_FUNCTION_PER_GROUP(sectors, BLKIO_STAT_SECTORS, 0);
> +SHOW_FUNCTION_PER_GROUP(io_service_bytes, BLKIO_STAT_SERVICE_BYTES, 1);
> +SHOW_FUNCTION_PER_GROUP(io_serviced, BLKIO_STAT_SERVICED, 1);
> +SHOW_FUNCTION_PER_GROUP(io_service_time, BLKIO_STAT_SERVICE_TIME, 1);
> +SHOW_FUNCTION_PER_GROUP(io_wait_time, BLKIO_STAT_WAIT_TIME, 1);
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
> -SHOW_FUNCTION_PER_GROUP(dequeue);
> +SHOW_FUNCTION_PER_GROUP(dequeue, BLKIO_STAT_DEQUEUE, 0);
>  #endif
>  #undef SHOW_FUNCTION_PER_GROUP
>  
> @@ -204,7 +318,7 @@ SHOW_FUNCTION_PER_GROUP(dequeue);
>  void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
>  			unsigned long dequeue)
>  {
> -	blkg->dequeue += dequeue;
> +	blkg->stats.dequeue += dequeue;
>  }
>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
>  #endif
> @@ -217,16 +331,36 @@ struct cftype blkio_files[] = {
>  	},
>  	{
>  		.name = "time",
> -		.read_seq_string = blkiocg_time_read,
> +		.read_map = blkiocg_time_read,
>  	},
>  	{
>  		.name = "sectors",
> -		.read_seq_string = blkiocg_sectors_read,
> +		.read_map = blkiocg_sectors_read,
> +	},
> +	{
> +		.name = "io_service_bytes",
> +		.read_map = blkiocg_io_service_bytes_read,
> +	},
> +	{
> +		.name = "io_serviced",
> +		.read_map = blkiocg_io_serviced_read,
> +	},
> +	{
> +		.name = "io_service_time",
> +		.read_map = blkiocg_io_service_time_read,
> +	},
> +	{
> +		.name = "io_wait_time",
> +		.read_map = blkiocg_io_wait_time_read,
> +	},
> +	{
> +		.name = "reset_stats",
> +		.write_u64 = blkiocg_reset_stats,
>  	},
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>         {
>  		.name = "dequeue",
> -		.read_seq_string = blkiocg_dequeue_read,
> +		.read_map = blkiocg_dequeue_read,
>         },
>  #endif
>  };
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index fe44517..a4bc4bb 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -23,6 +23,33 @@ extern struct cgroup_subsys blkio_subsys;
>  #define blkio_subsys_id blkio_subsys.subsys_id
>  #endif
>  
> +enum stat_type {
> +	/* Total time spent (in ns) between request dispatch to the driver and
> +	 * request completion for IOs doen by this cgroup. This may not be
> +	 * accurate when NCQ is turned on. */
> +	BLKIO_STAT_SERVICE_TIME = 0,
> +	/* Total bytes transferred */
> +	BLKIO_STAT_SERVICE_BYTES,
> +	/* Total IOs serviced, post merge */
> +	BLKIO_STAT_SERVICED,
> +	/* Total time spent waiting in scheduler queue in ns */
> +	BLKIO_STAT_WAIT_TIME,
> +	/* All the single valued stats go below this */
> +	BLKIO_STAT_TIME,
> +	BLKIO_STAT_SECTORS,
> +#ifdef CONFIG_DEBUG_BLK_CGROUP
> +	BLKIO_STAT_DEQUEUE
> +#endif
> +};
> +
> +enum stat_sub_type {
> +	BLKIO_STAT_READ = 0,
> +	BLKIO_STAT_WRITE,
> +	BLKIO_STAT_SYNC,
> +	BLKIO_STAT_ASYNC,
> +	BLKIO_STAT_TOTAL
> +};
> +
>  struct blkio_cgroup {
>  	struct cgroup_subsys_state css;
>  	unsigned int weight;
> @@ -30,6 +57,17 @@ struct blkio_cgroup {
>  	struct hlist_head blkg_list;
>  };
>  
> +struct blkio_group_stats {
> +	/* total disk time and nr sectors dispatched by this group */
> +	uint64_t time;
> +	uint64_t sectors;
> +	uint64_t stat_arr[BLKIO_STAT_WAIT_TIME + 1][BLKIO_STAT_TOTAL];
> +#ifdef CONFIG_DEBUG_BLK_CGROUP
> +	/* How many times this group has been removed from service tree */
> +	unsigned long dequeue;
> +#endif
> +};
> +
>  struct blkio_group {
>  	/* An rcu protected unique identifier for the group */
>  	void *key;
> @@ -38,15 +76,13 @@ struct blkio_group {
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>  	/* Store cgroup path */
>  	char path[128];
> -	/* How many times this group has been removed from service tree */
> -	unsigned long dequeue;
>  #endif
>  	/* The device MKDEV(major, minor), this group has been created for */
> -	dev_t   dev;
> +	dev_t dev;
>  
> -	/* total disk time and nr sectors dispatched by this group */
> -	unsigned long time;
> -	unsigned long sectors;
> +	/* Need to serialize the stats in the case of reset/update */
> +	spinlock_t stats_lock;
> +	struct blkio_group_stats stats;
>  };
>  
>  typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
> @@ -105,24 +141,24 @@ extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
>  extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
>  						void *key);
> -void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> -						unsigned long time);
> +void blkio_group_init(struct blkio_group *blkg);
> +void blkiocg_update_timeslice_used(struct blkio_group *blkg,
> +					unsigned long time);
>  #else
>  struct cgroup;
>  static inline struct blkio_cgroup *
>  cgroup_to_blkio_cgroup(struct cgroup *cgroup) { return NULL; }
>  
> +static inline void blkio_group_init(struct blkio_group *blkg) {}
>  static inline void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
> -			struct blkio_group *blkg, void *key, dev_t dev)
> -{
> -}
> +			struct blkio_group *blkg, void *key, dev_t dev) {}
>  
>  static inline int
>  blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
>  
>  static inline struct blkio_group *
>  blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
> -static inline void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> +static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>  						unsigned long time) {}
>  #endif
>  #endif /* _BLK_CGROUP_H */
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index c18e348..cf11548 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -914,7 +914,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>  
>  	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
>  					st->min_vdisktime);
> -	blkiocg_update_blkio_group_stats(&cfqg->blkg, used_sl);
> +	blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
>  }
>  
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
> @@ -954,6 +954,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  	for_each_cfqg_st(cfqg, i, j, st)
>  		*st = CFQ_RB_ROOT;
>  	RB_CLEAR_NODE(&cfqg->rb_node);
> +	blkio_group_init(&cfqg->blkg);
>  
>  	/*
>  	 * Take the initial reference that will be released on destroy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

-- 
Regards
Gui Jianfeng

