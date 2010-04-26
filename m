Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0DZRSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0DZRSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:18:43 -0400
Date: Mon, 26 Apr 2010 13:18:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] blk-cgroup: config options re-arrangement
Message-ID: <20100426171830.GC3372@redhat.com>
References: <20100422223705.GI3228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422223705.GI3228@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 06:37:05PM -0400, Vivek Goyal wrote:
> This patch fixes few usability and configurability issues.
> 
> o All the cgroup based controller options are configurable from
>   "Genral Setup/Control Group Support/" menu. blkio is the only exception.
>   Hence make this option visible in above menu and make it configurable from
>   there to bring it inline with rest of the cgroup based controllers.
> 

Hi Jens,

Do you have any concerns with this patch? If not, can you please include
it.

Thanks
Vivek

> o Get rid of CONFIG_DEBUG_CFQ_IOSCHED.
> 
>   This option currently does two things.
> 
>   - Enable printing of cgroup paths in blktrace
>   - Enables CONFIG_DEBUG_BLK_CGROUP, which in turn displays additional stat
>     files in cgroup.
> 
>   If we are using group scheduling, blktrace data is of not really much use
>   if cgroup information is not present. To get this data, currently one has to
>   also enable CONFIG_DEBUG_CFQ_IOSCHED, which in turn brings the overhead of
>   all the additional debug stat files which is not desired.
> 
>   Hence, this patch moves printing of cgroup paths under
>   CONFIG_CFQ_GROUP_IOSCHED.
> 
>   This allows us to get rid of CONFIG_DEBUG_CFQ_IOSCHED completely. Now all
>   the debug stat files are controlled only by CONFIG_DEBUG_BLK_CGROUP which
>   can be enabled through config menu.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/cgroups/blkio-controller.txt |   35 ++++++++++++----------------
>  block/Kconfig                              |   23 ------------------
>  block/Kconfig.iosched                      |   16 ++++--------
>  block/blk-cgroup.c                         |    2 -
>  block/blk-cgroup.h                         |   14 +++++-----
>  block/cfq-iosched.c                        |    2 +-
>  init/Kconfig                               |   27 +++++++++++++++++++++
>  7 files changed, 55 insertions(+), 64 deletions(-)
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index d422b41..48e0b21 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -17,6 +17,9 @@ HOWTO
>  You can do a very simple testing of running two dd threads in two different
>  cgroups. Here is what you can do.
>  
> +- Enable Block IO controller
> +	CONFIG_BLK_CGROUP=y
> +
>  - Enable group scheduling in CFQ
>  	CONFIG_CFQ_GROUP_IOSCHED=y
>  
> @@ -54,24 +57,16 @@ cgroups. Here is what you can do.
>  
>  Various user visible config options
>  ===================================
> -CONFIG_CFQ_GROUP_IOSCHED
> -	- Enables group scheduling in CFQ. Currently only 1 level of group
> -	  creation is allowed.
> -
> -CONFIG_DEBUG_CFQ_IOSCHED
> -	- Enables some debugging messages in blktrace. Also creates extra
> -	  cgroup file blkio.dequeue.
> -
> -Config options selected automatically
> -=====================================
> -These config options are not user visible and are selected/deselected
> -automatically based on IO scheduler configuration.
> -
>  CONFIG_BLK_CGROUP
> -	- Block IO controller. Selected by CONFIG_CFQ_GROUP_IOSCHED.
> +	- Block IO controller.
>  
>  CONFIG_DEBUG_BLK_CGROUP
> -	- Debug help. Selected by CONFIG_DEBUG_CFQ_IOSCHED.
> +	- Debug help. Right now some additional stats file show up in cgroup
> +	  if this option is enabled.
> +
> +CONFIG_CFQ_GROUP_IOSCHED
> +	- Enables group scheduling in CFQ. Currently only 1 level of group
> +	  creation is allowed.
>  
>  Details of cgroup files
>  =======================
> @@ -174,13 +169,13 @@ Details of cgroup files
>  	  write, sync or async.
>  
>  - blkio.avg_queue_size
> -	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y.
> +	- Debugging aid only enabled if CONFIG_DEBUG_BLK_CGROUP=y.
>  	  The average queue size for this cgroup over the entire time of this
>  	  cgroup's existence. Queue size samples are taken each time one of the
>  	  queues of this cgroup gets a timeslice.
>  
>  - blkio.group_wait_time
> -	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y.
> +	- Debugging aid only enabled if CONFIG_DEBUG_BLK_CGROUP=y.
>  	  This is the amount of time the cgroup had to wait since it became busy
>  	  (i.e., went from 0 to 1 request queued) to get a timeslice for one of
>  	  its queues. This is different from the io_wait_time which is the
> @@ -191,7 +186,7 @@ Details of cgroup files
>  	  got a timeslice and will not include the current delta.
>  
>  - blkio.empty_time
> -	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y.
> +	- Debugging aid only enabled if CONFIG_DEBUG_BLK_CGROUP=y.
>  	  This is the amount of time a cgroup spends without any pending
>  	  requests when not being served, i.e., it does not include any time
>  	  spent idling for one of the queues of the cgroup. This is in
> @@ -200,7 +195,7 @@ Details of cgroup files
>  	  time it had a pending request and will not include the current delta.
>  
>  - blkio.idle_time
> -	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y.
> +	- Debugging aid only enabled if CONFIG_DEBUG_BLK_CGROUP=y.
>  	  This is the amount of time spent by the IO scheduler idling for a
>  	  given cgroup in anticipation of a better request than the exising ones
>  	  from other queues/cgroups. This is in nanoseconds. If this is read
> @@ -209,7 +204,7 @@ Details of cgroup files
>  	  the current delta.
>  
>  - blkio.dequeue
> -	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
> +	- Debugging aid only enabled if CONFIG_DEBUG_BLK_CGROUP=y. This
>  	  gives the statistics about how many a times a group was dequeued
>  	  from service tree of the device. First two fields specify the major
>  	  and minor number of the device and third field specifies the number
> diff --git a/block/Kconfig b/block/Kconfig
> index f9e89f4..9be0b56 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -77,29 +77,6 @@ config BLK_DEV_INTEGRITY
>  	T10/SCSI Data Integrity Field or the T13/ATA External Path
>  	Protection.  If in doubt, say N.
>  
> -config BLK_CGROUP
> -	tristate "Block cgroup support"
> -	depends on CGROUPS
> -	depends on CFQ_GROUP_IOSCHED
> -	default n
> -	---help---
> -	Generic block IO controller cgroup interface. This is the common
> -	cgroup interface which should be used by various IO controlling
> -	policies.
> -
> -	Currently, CFQ IO scheduler uses it to recognize task groups and
> -	control disk bandwidth allocation (proportional time slice allocation)
> -	to such task groups.
> -
> -config DEBUG_BLK_CGROUP
> -	bool
> -	depends on BLK_CGROUP
> -	default n
> -	---help---
> -	Enable some debugging help. Currently it stores the cgroup path
> -	in the blk group which can be used by cfq for tracing various
> -	group related activity.
> -
>  endif # BLOCK
>  
>  config BLOCK_COMPAT
> diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
> index fc71cf0..3199b76 100644
> --- a/block/Kconfig.iosched
> +++ b/block/Kconfig.iosched
> @@ -23,7 +23,8 @@ config IOSCHED_DEADLINE
>  
>  config IOSCHED_CFQ
>  	tristate "CFQ I/O scheduler"
> -	select BLK_CGROUP if CFQ_GROUP_IOSCHED
> +	# If BLK_CGROUP is a module, CFQ has to be built as module.
> +	depends on (BLK_CGROUP=m && m) || !BLK_CGROUP || BLK_CGROUP=y
>  	default y
>  	---help---
>  	  The CFQ I/O scheduler tries to distribute bandwidth equally
> @@ -33,22 +34,15 @@ config IOSCHED_CFQ
>  
>  	  This is the default I/O scheduler.
>  
> +	  Note: If BLK_CGROUP=m, then CFQ can be built only as module.
> +
>  config CFQ_GROUP_IOSCHED
>  	bool "CFQ Group Scheduling support"
> -	depends on IOSCHED_CFQ && CGROUPS
> +	depends on IOSCHED_CFQ && BLK_CGROUP
>  	default n
>  	---help---
>  	  Enable group IO scheduling in CFQ.
>  
> -config DEBUG_CFQ_IOSCHED
> -	bool "Debug CFQ Scheduling"
> -	depends on CFQ_GROUP_IOSCHED
> -	select DEBUG_BLK_CGROUP
> -	default n
> -	---help---
> -	  Enable CFQ IO scheduling debugging in CFQ. Currently it makes
> -	  blktrace output more verbose.
> -
>  choice
>  	prompt "Default I/O scheduler"
>  	default DEFAULT_CFQ
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 83930f6..92d3b74 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -348,10 +348,8 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
>  	blkg->blkcg_id = css_id(&blkcg->css);
>  	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
>  	spin_unlock_irqrestore(&blkcg->lock, flags);
> -#ifdef CONFIG_DEBUG_BLK_CGROUP
>  	/* Need to take css reference ? */
>  	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
> -#endif
>  	blkg->dev = dev;
>  }
>  EXPORT_SYMBOL_GPL(blkiocg_add_blkio_group);
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 2c956a0..8a357f1 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -108,10 +108,8 @@ struct blkio_group {
>  	void *key;
>  	struct hlist_node blkcg_node;
>  	unsigned short blkcg_id;
> -#ifdef CONFIG_DEBUG_BLK_CGROUP
>  	/* Store cgroup path */
>  	char path[128];
> -#endif
>  	/* The device MKDEV(major, minor), this group has been created for */
>  	dev_t dev;
>  
> @@ -147,6 +145,11 @@ struct blkio_policy_type {
>  extern void blkio_policy_register(struct blkio_policy_type *);
>  extern void blkio_policy_unregister(struct blkio_policy_type *);
>  
> +static inline char *blkg_path(struct blkio_group *blkg)
> +{
> +	return blkg->path;
> +}
> +
>  #else
>  
>  struct blkio_group {
> @@ -158,6 +161,8 @@ struct blkio_policy_type {
>  static inline void blkio_policy_register(struct blkio_policy_type *blkiop) { }
>  static inline void blkio_policy_unregister(struct blkio_policy_type *blkiop) { }
>  
> +static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
> +
>  #endif
>  
>  #define BLKIO_WEIGHT_MIN	100
> @@ -165,10 +170,6 @@ static inline void blkio_policy_unregister(struct blkio_policy_type *blkiop) { }
>  #define BLKIO_WEIGHT_DEFAULT	500
>  
>  #ifdef CONFIG_DEBUG_BLK_CGROUP
> -static inline char *blkg_path(struct blkio_group *blkg)
> -{
> -	return blkg->path;
> -}
>  void blkiocg_update_avg_queue_size_stats(struct blkio_group *blkg);
>  void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
>  				unsigned long dequeue);
> @@ -197,7 +198,6 @@ BLKG_FLAG_FNS(idling)
>  BLKG_FLAG_FNS(empty)
>  #undef BLKG_FLAG_FNS
>  #else
> -static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
>  static inline void blkiocg_update_avg_queue_size_stats(
>  						struct blkio_group *blkg) {}
>  static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d5927b5..5fa0e98 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -345,7 +345,7 @@ CFQ_CFQQ_FNS(deep);
>  CFQ_CFQQ_FNS(wait_busy);
>  #undef CFQ_CFQQ_FNS
>  
> -#ifdef CONFIG_DEBUG_CFQ_IOSCHED
> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
>  #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
>  	blk_add_trace_msg((cfqd)->queue, "cfq%d%c %s " fmt, (cfqq)->pid, \
>  			cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
> diff --git a/init/Kconfig b/init/Kconfig
> index eb77e8c..087c14f 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -612,6 +612,33 @@ config RT_GROUP_SCHED
>  
>  endif #CGROUP_SCHED
>  
> +config BLK_CGROUP
> +	tristate "Block IO controller"
> +	depends on CGROUPS && BLOCK
> +	default n
> +	---help---
> +	Generic block IO controller cgroup interface. This is the common
> +	cgroup interface which should be used by various IO controlling
> +	policies.
> +
> +	Currently, CFQ IO scheduler uses it to recognize task groups and
> +	control disk bandwidth allocation (proportional time slice allocation)
> +	to such task groups.
> +
> +	This option only enables generic Block IO controller infrastructure.
> +	One needs to also enable actual IO controlling logic in CFQ for it
> +	to take effect. (CONFIG_CFQ_GROUP_IOSCHED=y).
> +
> +	See Documentation/cgroups/blkio-controller.txt for more information.
> +
> +config DEBUG_BLK_CGROUP
> +	bool "Enable Block IO controller debugging"
> +	depends on BLK_CGROUP
> +	default n
> +	---help---
> +	Enable some debugging help. Currently it exports additional stat
> +	files in a cgroup which can be useful for debugging.
> +
>  endif # CGROUPS
>  
>  config MM_OWNER
> -- 
> 1.6.2.5
> 
