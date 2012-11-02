Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab2KBUIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2KBUIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:08:10 -0400
Date: Fri, 2 Nov 2012 16:08:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Robin Dong <sanbai@taobao.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH 2/2 v5] block/throttle: Add IO submitted information in
 blkio.throttle
Message-ID: <20121102200800.GS3300@redhat.com>
References: <1351848697-26087-1-git-send-email-robin.k.dong@gmail.com>
 <1351848697-26087-2-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351848697-26087-2-git-send-email-robin.k.dong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 05:31:37PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> Currently, if the IO is throttled by io-throttle, the system admin has no idea
> of the situation and can't report it to the real application user about that
> he/she has to do something.
> 
> So this patch adds a new interface named blkio.throttle.io_submitted which
> exposes the number of bios that have been sent into blk-throttle therefore the
> user could calculate the difference from throttle.io_serviced to see how many
> IOs are currently throttled.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> v3 <-- v2:
>  - Use nr-queued[] of struct throtl_grp for stats instaed of adding new blkg_rwstat.
> 
> v4 <-- v3:
>  - Add two new blkg_rwstat arguments to count total bios be sent into blk_throttle.
> 
> v5 <-- v4:
>  - Change name "io_submit_bytes" to "io_submitted_bytes".
> 
>  block/blk-throttle.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 46ddeff..c6391b5 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -46,6 +46,10 @@ struct tg_stats_cpu {
>  	struct blkg_rwstat		service_bytes;
>  	/* total IOs serviced, post merge */
>  	struct blkg_rwstat		serviced;
> +	/* total bytes submitted into blk-throttle */
> +	struct blkg_rwstat		submit_bytes;
> +	/* total IOs submitted into blk-throttle */
> +	struct blkg_rwstat		submitted;
>  };
>  
>  struct throtl_grp {
> @@ -266,6 +270,8 @@ static void throtl_pd_reset_stats(struct blkcg_gq *blkg)
>  
>  		blkg_rwstat_reset(&sc->service_bytes);
>  		blkg_rwstat_reset(&sc->serviced);
> +		blkg_rwstat_reset(&sc->submit_bytes);
> +		blkg_rwstat_reset(&sc->submitted);
>  	}
>  }
>  
> @@ -699,6 +705,30 @@ static void throtl_update_dispatch_stats(struct throtl_grp *tg, u64 bytes,
>  	local_irq_restore(flags);
>  }
>  
> +static void throtl_update_submit_stats(struct throtl_grp *tg, u64 bytes, int rw)
> +{
> +	struct tg_stats_cpu *stats_cpu;
> +	unsigned long flags;
> +
> +	/* If per cpu stats are not allocated yet, don't do any accounting. */
> +	if (tg->stats_cpu == NULL)
> +		return;
> +
> +	/*
> +	 * Disabling interrupts to provide mutual exclusion between two
> +	 * writes on same cpu. It probably is not needed for 64bit. Not
> +	 * optimizing that case yet.
> +	 */
> +	local_irq_save(flags);
> +
> +	stats_cpu = this_cpu_ptr(tg->stats_cpu);
> +
> +	blkg_rwstat_add(&stats_cpu->submitted, rw, 1);
> +	blkg_rwstat_add(&stats_cpu->submit_bytes, rw, bytes);
> +
> +	local_irq_restore(flags);
> +}
> +
>  static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
>  {
>  	bool rw = bio_data_dir(bio);
> @@ -1084,6 +1114,16 @@ static struct cftype throtl_files[] = {
>  		.private = offsetof(struct tg_stats_cpu, serviced),
>  		.read_seq_string = tg_print_cpu_rwstat,
>  	},
> +	{
> +		.name = "throttle.io_submitted_bytes",
> +		.private = offsetof(struct tg_stats_cpu, submit_bytes),
> +		.read_seq_string = tg_print_cpu_rwstat,
> +	},
> +	{
> +		.name = "throttle.io_submitted",
> +		.private = offsetof(struct tg_stats_cpu, submitted),
> +		.read_seq_string = tg_print_cpu_rwstat,
> +	},
>  	{ }	/* terminate */
>  };
>  
> @@ -1128,6 +1168,8 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
>  		if (tg_no_rule_group(tg, rw)) {
>  			throtl_update_dispatch_stats(tg,
>  						     bio->bi_size, bio->bi_rw);
> +			throtl_update_submit_stats(tg,
> +					bio->bi_size, bio->bi_rw);
>  			goto out_unlock_rcu;
>  		}
>  	}
> @@ -1141,6 +1183,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
>  	if (unlikely(!tg))
>  		goto out_unlock;
>  
> +	throtl_update_submit_stats(tg, bio->bi_size, bio->bi_rw);
>  	if (tg->nr_queued[rw]) {
>  		/*
>  		 * There is already another bio queued in same dir. No
> -- 
> 1.7.1
