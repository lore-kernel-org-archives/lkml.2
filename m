Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2IDMoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999Ab2IDMoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:44:38 -0400
Date: Tue, 4 Sep 2012 08:44:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block/throttle: Call throtl_update_dispatch_stats with
 throtl_grp directly.
Message-ID: <20120904124431.GA13768@redhat.com>
References: <1346389703-2927-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346389703-2927-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 01:08:23PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> All callers of throtl_update_dispatch_stats uses tg_to_blkg and then
> in this function we use blkg_to_tg again to change it back. So remove
> all these useless conversion and use throtl_grp directly to call
> throtl_update_dispatch_stats.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---

Simple. Looks good.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

>  block/blk-throttle.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index e287c19..1588c2d 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -675,10 +675,9 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
>  	return 0;
>  }
>  
> -static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
> +static void throtl_update_dispatch_stats(struct throtl_grp *tg, u64 bytes,
>  					 int rw)
>  {
> -	struct throtl_grp *tg = blkg_to_tg(blkg);
>  	struct tg_stats_cpu *stats_cpu;
>  	unsigned long flags;
>  
> @@ -709,7 +708,7 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
>  	tg->bytes_disp[rw] += bio->bi_size;
>  	tg->io_disp[rw]++;
>  
> -	throtl_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size, bio->bi_rw);
> +	throtl_update_dispatch_stats(tg, bio->bi_size, bio->bi_rw);
>  }
>  
>  static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
> @@ -1133,7 +1132,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
>  	tg = throtl_lookup_tg(td, blkcg);
>  	if (tg) {
>  		if (tg_no_rule_group(tg, rw)) {
> -			throtl_update_dispatch_stats(tg_to_blkg(tg),
> +			throtl_update_dispatch_stats(tg,
>  						     bio->bi_size, bio->bi_rw);
>  			goto out_unlock_rcu;
>  		}
> -- 
> 1.7.0.4
