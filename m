Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0DFPac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:30:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab0DFPa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:30:26 -0400
Date: Tue, 6 Apr 2010 11:30:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH 1/3][v3] blkio: Remove per-cfqq nr_sectors as we'll be
	passing
Message-ID: <20100406153019.GD3029@redhat.com>
References: <20100406032630.23464.24685.stgit@austin.mtv.corp.google.com> <20100406033519.23464.66155.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406033519.23464.66155.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 08:36:24PM -0700, Divyesh Shah wrote:
> that info at request dispatch with other stats now. This patch removes the
> existing support for accounting sectors for a blkio_group. This will be added
> back differently in the next two patches.
> 
> Signed-off-by: Divyesh Shah<dpshah@google.com>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
> 
>  block/blk-cgroup.c  |    3 +--
>  block/blk-cgroup.h  |    6 ++----
>  block/cfq-iosched.c |   10 ++--------
>  3 files changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 4b686ad..5be3981 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -56,10 +56,9 @@ struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>  EXPORT_SYMBOL_GPL(cgroup_to_blkio_cgroup);
>  
>  void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> -			unsigned long time, unsigned long sectors)
> +						unsigned long time)
>  {
>  	blkg->time += time;
> -	blkg->sectors += sectors;
>  }
>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_stats);
>  
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 8ccc204..fe44517 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -106,7 +106,7 @@ extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
>  extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
>  						void *key);
>  void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> -			unsigned long time, unsigned long sectors);
> +						unsigned long time);
>  #else
>  struct cgroup;
>  static inline struct blkio_cgroup *
> @@ -123,8 +123,6 @@ blkiocg_del_blkio_group(struct blkio_group *blkg) { return 0; }
>  static inline struct blkio_group *
>  blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
>  static inline void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
> -			unsigned long time, unsigned long sectors)
> -{
> -}
> +						unsigned long time) {}
>  #endif
>  #endif /* _BLK_CGROUP_H */
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index ef1680b..c18e348 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -141,8 +141,6 @@ struct cfq_queue {
>  	struct cfq_queue *new_cfqq;
>  	struct cfq_group *cfqg;
>  	struct cfq_group *orig_cfqg;
> -	/* Sectors dispatched in current dispatch round */
> -	unsigned long nr_sectors;
>  };
>  
>  /*
> @@ -882,8 +880,7 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
>  			slice_used = cfqq->allocated_slice;
>  	}
>  
> -	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u sect=%lu", slice_used,
> -				cfqq->nr_sectors);
> +	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u", slice_used);
>  	return slice_used;
>  }
>  
> @@ -917,8 +914,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
>  
>  	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
>  					st->min_vdisktime);
> -	blkiocg_update_blkio_group_stats(&cfqg->blkg, used_sl,
> -						cfqq->nr_sectors);
> +	blkiocg_update_blkio_group_stats(&cfqg->blkg, used_sl);
>  }
>  
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
> @@ -1524,7 +1520,6 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
>  		cfqq->allocated_slice = 0;
>  		cfqq->slice_end = 0;
>  		cfqq->slice_dispatch = 0;
> -		cfqq->nr_sectors = 0;
>  
>  		cfq_clear_cfqq_wait_request(cfqq);
>  		cfq_clear_cfqq_must_dispatch(cfqq);
> @@ -1869,7 +1864,6 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
>  	elv_dispatch_sort(q, rq);
>  
>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
> -	cfqq->nr_sectors += blk_rq_sectors(rq);
>  }
>  
>  /*
