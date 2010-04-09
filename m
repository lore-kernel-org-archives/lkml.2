Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0DIOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab0DIOQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:16:23 -0400
Date: Fri, 9 Apr 2010 10:16:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH] blkio: Changes to IO controller additional stats
	patches
Message-ID: <20100409141616.GD27573@redhat.com>
References: <20100409032635.24936.21960.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409032635.24936.21960.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 08:27:48PM -0700, Divyesh Shah wrote:
> that include some minor fixes and addresses all comments.
> 
> Changelog: (most based on Vivek Goyal's comments)
> o renamed blkiocg_reset_write to blkiocg_reset_stats
> o more clarification in the documentation on io_service_time and io_wait_time
> o Initialize blkg->stats_lock
> o rename io_add_stat to blkio_add_stat and declare it static
> o use bool for direction and sync
> o derive direction and sync info from existing rq methods
> o use 12 for major:minor string length
> o define io_service_time better to cover the NCQ case
> o add a separate reset_stats interface
> o make the indexed stats a 2d array to simplify macro and function pointer code
> o blkio.time now exports in jiffies as before
> o Added stats description in patch description and
>   Documentation/cgroup/blkio-controller.txt
> o Prefix all stats functions with blkio and make them static as applicable
> o replace IO_TYPE_MAX with IO_TYPE_TOTAL
> o Moved #define constant to top of blk-cgroup.c
> o Pass dev_t around instead of char *
> o Add note to documentation file about resetting stats
> o use BLK_CGROUP_MODULE in addition to BLK_CGROUP config option in #ifdef
>   statements
> o Avoid struct request specific knowledge in blk-cgroup. blk-cgroup.h now has
>   rq_direction() and rq_sync() functions which are used by CFQ and when using
>   io-controller at a higher level, bio_* functions can be added.
> 
> Signed-off-by: Divyesh Shah<dpshah@google.com>
> ---

Thanks Divyesh.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> 
>  Documentation/cgroups/blkio-controller.txt |   48 +++++++
>  block/blk-cgroup.c                         |  190 +++++++++++++---------------
>  block/blk-cgroup.h                         |   64 ++++++---
>  block/cfq-iosched.c                        |    8 +
>  include/linux/blkdev.h                     |   18 +++
>  5 files changed, 198 insertions(+), 130 deletions(-)
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
> index 9af7257..6797df5 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -18,6 +18,8 @@
>  #include <linux/blkdev.h>
>  #include "blk-cgroup.h"
>  
> +#define MAX_KEY_LEN 100
> +
>  static DEFINE_SPINLOCK(blkio_list_lock);
>  static LIST_HEAD(blkio_list);
>  
> @@ -56,24 +58,27 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>  }
>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>  
> +void blkio_group_init(struct blkio_group *blkg)
> +{
> +	spin_lock_init(&blkg->stats_lock);
> +}
> +EXPORT_SYMBOL_GPL(blkio_group_init);
> +
>  /*
>   * Add to the appropriate stat variable depending on the request type.
>   * This should be called with the blkg->stats_lock held.
>   */
> -void io_add_stat(uint64_t *stat, uint64_t add, unsigned int flags)
> +static void blkio_add_stat(uint64_t *stat, uint64_t add, bool direction,
> +				bool sync)
>  {
> -	if (flags & REQ_RW)
> -		stat[IO_WRITE] += add;
> +	if (direction)
> +		stat[BLKIO_STAT_WRITE] += add;
>  	else
> -		stat[IO_READ] += add;
> -	/*
> -	 * Everywhere in the block layer, an IO is treated as sync if it is a
> -	 * read or a SYNC write. We follow the same norm.
> -	 */
> -	if (!(flags & REQ_RW) || flags & REQ_RW_SYNC)
> -		stat[IO_SYNC] += add;
> +		stat[BLKIO_STAT_READ] += add;
> +	if (sync)
> +		stat[BLKIO_STAT_SYNC] += add;
>  	else
> -		stat[IO_ASYNC] += add;
> +		stat[BLKIO_STAT_ASYNC] += add;
>  }
>  
>  void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
> @@ -86,23 +91,25 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
>  }
>  EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
>  
> -void blkiocg_update_request_dispatch_stats(struct blkio_group *blkg,
> -						struct request *rq)
> +void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
> +				uint64_t bytes, bool direction, bool sync)
>  {
>  	struct blkio_group_stats *stats;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&blkg->stats_lock, flags);
>  	stats = &blkg->stats;
> -	stats->sectors += blk_rq_sectors(rq);
> -	io_add_stat(stats->io_serviced, 1, rq->cmd_flags);
> -	io_add_stat(stats->io_service_bytes, blk_rq_sectors(rq) << 9,
> -			rq->cmd_flags);
> +	stats->sectors += bytes >> 9;
> +	blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICED], 1, direction,
> +			sync);
> +	blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_BYTES], bytes,
> +			direction, sync);
>  	spin_unlock_irqrestore(&blkg->stats_lock, flags);
>  }
> +EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
>  
> -void blkiocg_update_request_completion_stats(struct blkio_group *blkg,
> -						struct request *rq)
> +void blkiocg_update_completion_stats(struct blkio_group *blkg,
> +	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
>  {
>  	struct blkio_group_stats *stats;
>  	unsigned long flags;
> @@ -110,16 +117,15 @@ void blkiocg_update_request_completion_stats(struct blkio_group *blkg,
>  
>  	spin_lock_irqsave(&blkg->stats_lock, flags);
>  	stats = &blkg->stats;
> -	if (time_after64(now, rq->io_start_time_ns))
> -		io_add_stat(stats->io_service_time, now - rq->io_start_time_ns,
> -				rq->cmd_flags);
> -	if (time_after64(rq->io_start_time_ns, rq->start_time_ns))
> -		io_add_stat(stats->io_wait_time,
> -				rq->io_start_time_ns - rq->start_time_ns,
> -				rq->cmd_flags);
> +	if (time_after64(now, io_start_time))
> +		blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_TIME],
> +				now - io_start_time, direction, sync);
> +	if (time_after64(io_start_time, start_time))
> +		blkio_add_stat(stats->stat_arr[BLKIO_STAT_WAIT_TIME],
> +				io_start_time - start_time, direction, sync);
>  	spin_unlock_irqrestore(&blkg->stats_lock, flags);
>  }
> -EXPORT_SYMBOL_GPL(blkiocg_update_request_completion_stats);
> +EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
>  
>  void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  			struct blkio_group *blkg, void *key, dev_t dev)
> @@ -230,7 +236,7 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>  }
>  
>  static int
> -blkiocg_reset_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
> +blkiocg_reset_stats(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>  {
>  	struct blkio_cgroup *blkcg;
>  	struct blkio_group *blkg;
> @@ -249,29 +255,32 @@ blkiocg_reset_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>  	return 0;
>  }
>  
> -void get_key_name(int type, char *disk_id, char *str, int chars_left)
> +static void blkio_get_key_name(enum stat_sub_type type, dev_t dev, char *str,
> +				int chars_left, bool diskname_only)
>  {
> -	strlcpy(str, disk_id, chars_left);
> +	snprintf(str, chars_left, "%d:%d", MAJOR(dev), MINOR(dev));
>  	chars_left -= strlen(str);
>  	if (chars_left <= 0) {
>  		printk(KERN_WARNING
>  			"Possibly incorrect cgroup stat display format");
>  		return;
>  	}
> +	if (diskname_only)
> +		return;
>  	switch (type) {
> -	case IO_READ:
> +	case BLKIO_STAT_READ:
>  		strlcat(str, " Read", chars_left);
>  		break;
> -	case IO_WRITE:
> +	case BLKIO_STAT_WRITE:
>  		strlcat(str, " Write", chars_left);
>  		break;
> -	case IO_SYNC:
> +	case BLKIO_STAT_SYNC:
>  		strlcat(str, " Sync", chars_left);
>  		break;
> -	case IO_ASYNC:
> +	case BLKIO_STAT_ASYNC:
>  		strlcat(str, " Async", chars_left);
>  		break;
> -	case IO_TYPE_MAX:
> +	case BLKIO_STAT_TOTAL:
>  		strlcat(str, " Total", chars_left);
>  		break;
>  	default:
> @@ -279,63 +288,47 @@ void get_key_name(int type, char *disk_id, char *str, int chars_left)
>  	}
>  }
>  
> -typedef uint64_t (get_var) (struct blkio_group *, int);
> +static uint64_t blkio_fill_stat(char *str, int chars_left, uint64_t val,
> +				struct cgroup_map_cb *cb, dev_t dev)
> +{
> +	blkio_get_key_name(0, dev, str, chars_left, true);
> +	cb->fill(cb, str, val);
> +	return val;
> +}
>  
> -#define MAX_KEY_LEN 100
> -uint64_t get_typed_stat(struct blkio_group *blkg, struct cgroup_map_cb *cb,
> -		get_var *getvar, char *disk_id)
> +/* This should be called with blkg->stats_lock held */
> +static uint64_t blkio_get_stat(struct blkio_group *blkg,
> +		struct cgroup_map_cb *cb, dev_t dev, enum stat_type type)
>  {
>  	uint64_t disk_total;
>  	char key_str[MAX_KEY_LEN];
> -	int type;
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
>  
> -	for (type = 0; type < IO_TYPE_MAX; type++) {
> -		get_key_name(type, disk_id, key_str, MAX_KEY_LEN);
> -		cb->fill(cb, key_str, getvar(blkg, type));
> +	for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
> +			sub_type++) {
> +		blkio_get_key_name(sub_type, dev, key_str, MAX_KEY_LEN, false);
> +		cb->fill(cb, key_str, blkg->stats.stat_arr[type][sub_type]);
>  	}
> -	disk_total = getvar(blkg, IO_READ) + getvar(blkg, IO_WRITE);
> -	get_key_name(IO_TYPE_MAX, disk_id, key_str, MAX_KEY_LEN);
> +	disk_total = blkg->stats.stat_arr[type][BLKIO_STAT_READ] +
> +			blkg->stats.stat_arr[type][BLKIO_STAT_WRITE];
> +	blkio_get_key_name(BLKIO_STAT_TOTAL, dev, key_str, MAX_KEY_LEN, false);
>  	cb->fill(cb, key_str, disk_total);
>  	return disk_total;
>  }
>  
> -uint64_t get_stat(struct blkio_group *blkg, struct cgroup_map_cb *cb,
> -		get_var *getvar, char *disk_id)
> -{
> -	uint64_t var = getvar(blkg, 0);
> -	cb->fill(cb, disk_id, var);
> -	return var;
> -}
> -
> -#define GET_STAT_INDEXED(__VAR)						\
> -uint64_t get_##__VAR##_stat(struct blkio_group *blkg, int type)		\
> -{									\
> -	return blkg->stats.__VAR[type];					\
> -}									\
> -
> -GET_STAT_INDEXED(io_service_bytes);
> -GET_STAT_INDEXED(io_serviced);
> -GET_STAT_INDEXED(io_service_time);
> -GET_STAT_INDEXED(io_wait_time);
> -#undef GET_STAT_INDEXED
> -
> -#define GET_STAT(__VAR, __CONV)						\
> -uint64_t get_##__VAR##_stat(struct blkio_group *blkg, int dummy)	\
> -{									\
> -	uint64_t data = blkg->stats.__VAR;				\
> -	if (__CONV)							\
> -		data = (uint64_t)jiffies_to_msecs(data) * NSEC_PER_MSEC;\
> -	return data;							\
> -}
> -
> -GET_STAT(time, 1);
> -GET_STAT(sectors, 0);
> -#ifdef CONFIG_DEBUG_BLK_CGROUP
> -GET_STAT(dequeue, 0);
> -#endif
> -#undef GET_STAT
> -
> -#define SHOW_FUNCTION_PER_GROUP(__VAR, get_stats, getvar, show_total)	\
> +#define SHOW_FUNCTION_PER_GROUP(__VAR, type, show_total)		\
>  static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
>  		struct cftype *cftype, struct cgroup_map_cb *cb)	\
>  {									\
> @@ -343,7 +336,6 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
>  	struct blkio_group *blkg;					\
>  	struct hlist_node *n;						\
>  	uint64_t cgroup_total = 0;					\
> -	char disk_id[10];						\
>  									\
>  	if (!cgroup_lock_live_group(cgroup))				\
>  		return -ENODEV;						\
> @@ -353,10 +345,8 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
>  	hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {\
>  		if (blkg->dev) {					\
>  			spin_lock_irq(&blkg->stats_lock);		\
> -			snprintf(disk_id, 10, "%u:%u", MAJOR(blkg->dev),\
> -					MINOR(blkg->dev));		\
> -			cgroup_total += get_stats(blkg, cb, getvar,	\
> -						disk_id);		\
> +			cgroup_total += blkio_get_stat(blkg, cb,	\
> +						blkg->dev, type);	\
>  			spin_unlock_irq(&blkg->stats_lock);		\
>  		}							\
>  	}								\
> @@ -367,16 +357,14 @@ static int blkiocg_##__VAR##_read(struct cgroup *cgroup,		\
>  	return 0;							\
>  }
>  
> -SHOW_FUNCTION_PER_GROUP(time, get_stat, get_time_stat, 0);
> -SHOW_FUNCTION_PER_GROUP(sectors, get_stat, get_sectors_stat, 0);
> -SHOW_FUNCTION_PER_GROUP(io_service_bytes, get_typed_stat,
> -			get_io_service_bytes_stat, 1);
> -SHOW_FUNCTION_PER_GROUP(io_serviced, get_typed_stat, get_io_serviced_stat, 1);
> -SHOW_FUNCTION_PER_GROUP(io_service_time, get_typed_stat,
> -			get_io_service_time_stat, 1);
> -SHOW_FUNCTION_PER_GROUP(io_wait_time, get_typed_stat, get_io_wait_time_stat, 1);
> +SHOW_FUNCTION_PER_GROUP(time, BLKIO_STAT_TIME, 0);
> +SHOW_FUNCTION_PER_GROUP(sectors, BLKIO_STAT_SECTORS, 0);
> +SHOW_FUNCTION_PER_GROUP(io_service_bytes, BLKIO_STAT_SERVICE_BYTES, 1);
> +SHOW_FUNCTION_PER_GROUP(io_serviced, BLKIO_STAT_SERVICED, 1);
> +SHOW_FUNCTION_PER_GROUP(io_service_time, BLKIO_STAT_SERVICE_TIME, 1);
> +SHOW_FUNCTION_PER_GROUP(io_wait_time, BLKIO_STAT_WAIT_TIME, 1);
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
> -SHOW_FUNCTION_PER_GROUP(dequeue, get_stat, get_dequeue_stat, 0);
> +SHOW_FUNCTION_PER_GROUP(dequeue, BLKIO_STAT_DEQUEUE, 0);
>  #endif
>  #undef SHOW_FUNCTION_PER_GROUP
>  
> @@ -398,32 +386,30 @@ struct cftype blkio_files[] = {
>  	{
>  		.name = "time",
>  		.read_map = blkiocg_time_read,
> -		.write_u64 = blkiocg_reset_write,
>  	},
>  	{
>  		.name = "sectors",
>  		.read_map = blkiocg_sectors_read,
> -		.write_u64 = blkiocg_reset_write,
>  	},
>  	{
>  		.name = "io_service_bytes",
>  		.read_map = blkiocg_io_service_bytes_read,
> -		.write_u64 = blkiocg_reset_write,
>  	},
>  	{
>  		.name = "io_serviced",
>  		.read_map = blkiocg_io_serviced_read,
> -		.write_u64 = blkiocg_reset_write,
>  	},
>  	{
>  		.name = "io_service_time",
>  		.read_map = blkiocg_io_service_time_read,
> -		.write_u64 = blkiocg_reset_write,
>  	},
>  	{
>  		.name = "io_wait_time",
>  		.read_map = blkiocg_io_wait_time_read,
> -		.write_u64 = blkiocg_reset_write,
> +	},
> +	{
> +		.name = "reset_stats",
> +		.write_u64 = blkiocg_reset_stats,
>  	},
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>         {
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 80010ef..b22e553 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -23,12 +23,31 @@ extern struct cgroup_subsys blkio_subsys;
>  #define blkio_subsys_id blkio_subsys.subsys_id
>  #endif
>  
> -enum io_type {
> -	IO_READ = 0,
> -	IO_WRITE,
> -	IO_SYNC,
> -	IO_ASYNC,
> -	IO_TYPE_MAX
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
>  };
>  
>  struct blkio_cgroup {
> @@ -42,13 +61,7 @@ struct blkio_group_stats {
>  	/* total disk time and nr sectors dispatched by this group */
>  	uint64_t time;
>  	uint64_t sectors;
> -	/* Total disk time used by IOs in ns */
> -	uint64_t io_service_time[IO_TYPE_MAX];
> -	uint64_t io_service_bytes[IO_TYPE_MAX]; /* Total bytes transferred */
> -	/* Total IOs serviced, post merge */
> -	uint64_t io_serviced[IO_TYPE_MAX];
> -	/* Total time spent waiting in scheduler queue in ns */
> -	uint64_t io_wait_time[IO_TYPE_MAX];
> +	uint64_t stat_arr[BLKIO_STAT_WAIT_TIME + 1][BLKIO_STAT_TOTAL];
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>  	/* How many times this group has been removed from service tree */
>  	unsigned long dequeue;
> @@ -65,7 +78,7 @@ struct blkio_group {
>  	char path[128];
>  #endif
>  	/* The device MKDEV(major, minor), this group has been created for */
> -	dev_t   dev;
> +	dev_t dev;
>  
>  	/* Need to serialize the stats in the case of reset/update */
>  	spinlock_t stats_lock;
> @@ -128,21 +141,21 @@ extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
>  extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
>  						void *key);
> +void blkio_group_init(struct blkio_group *blkg);
>  void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>  					unsigned long time);
> -void blkiocg_update_request_dispatch_stats(struct blkio_group *blkg,
> -						struct request *rq);
> -void blkiocg_update_request_completion_stats(struct blkio_group *blkg,
> -						struct request *rq);
> +void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
> +						bool direction, bool sync);
> +void blkiocg_update_completion_stats(struct blkio_group *blkg,
> +	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync);
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
> @@ -151,9 +164,10 @@ static inline struct blkio_group *
>  blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
>  static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
>  						unsigned long time) {}
> -static inline void blkiocg_update_request_dispatch_stats(
> -		struct blkio_group *blkg, struct request *rq) {}
> -static inline void blkiocg_update_request_completion_stats(
> -		struct blkio_group *blkg, struct request *rq) {}
> +static inline void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
> +				uint64_t bytes, bool direction, bool sync) {}
> +static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
> +		uint64_t start_time, uint64_t io_start_time, bool direction,
> +		bool sync) {}
>  #endif
>  #endif /* _BLK_CGROUP_H */
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 42028e7..5617ae0 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -955,6 +955,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  	for_each_cfqg_st(cfqg, i, j, st)
>  		*st = CFQ_RB_ROOT;
>  	RB_CLEAR_NODE(&cfqg->rb_node);
> +	blkio_group_init(&cfqg->blkg);
>  
>  	/*
>  	 * Take the initial reference that will be released on destroy
> @@ -1865,7 +1866,8 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
>  	elv_dispatch_sort(q, rq);
>  
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
> -	blkiocg_update_request_dispatch_stats(&cfqq->cfqg->blkg, rq);
> +	blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
> +					rq_data_dir(rq), rq_is_sync(rq));
>  }
>  
>  /*
> @@ -3286,7 +3288,9 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  	WARN_ON(!cfqq->dispatched);
>  	cfqd->rq_in_driver--;
>  	cfqq->dispatched--;
> -	blkiocg_update_request_completion_stats(&cfqq->cfqg->blkg, rq);
> +	blkiocg_update_completion_stats(&cfqq->cfqg->blkg, rq_start_time_ns(rq),
> +			rq_io_start_time_ns(rq), rq_data_dir(rq),
> +			rq_is_sync(rq));
>  
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f3fff8b..d483c49 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1209,9 +1209,27 @@ static inline void set_io_start_time_ns(struct request *req)
>  {
>  	req->io_start_time_ns = sched_clock();
>  }
> +
> +static inline uint64_t rq_start_time_ns(struct request *req)
> +{
> +        return req->start_time_ns;
> +}
> +
> +static inline uint64_t rq_io_start_time_ns(struct request *req)
> +{
> +        return req->io_start_time_ns;
> +}
>  #else
>  static inline void set_start_time_ns(struct request *req) {}
>  static inline void set_io_start_time_ns(struct request *req) {}
> +static inline uint64_t rq_start_time_ns(struct request *req)
> +{
> +	return 0;
> +}
> +static inline uint64_t rq_io_start_time_ns(struct request *req)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #define MODULE_ALIAS_BLOCKDEV(major,minor) \
