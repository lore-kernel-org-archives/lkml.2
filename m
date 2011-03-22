Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1CVUdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:33:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1CVUdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:33:49 -0400
Date: Tue, 22 Mar 2011 16:33:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Lina Lu <lulina_nuaa@foxmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-throttle: Reset group slice when limits are changed
Message-ID: <20110322203319.GL3757@redhat.com>
References: <20110315175456.GC2587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315175456.GC2587@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 01:54:56PM -0400, Vivek Goyal wrote:
> Lina reported that if throttle limits are initially very high and then
> dropped, then no new bio might be dispatched for a long time. And the
> reason being that after dropping the limits we don't reset the existing
> slice and do the rate calculation with new low rate and account the bios
> dispatched at high rate. To fix it, reset the slice upon rate change.

Hi Jens,

Can you please apply this patch too.

Thanks
Vivek

> 
> https://lkml.org/lkml/2011/3/10/298
> 
> Another problem with very high limit is that we never queued the
> bio on throtl service tree. That means we kept on extending the
> group slice but never trimmed it. Fix that also by regulary
> trimming the slice even if bio is not being queued up.
> 
> Reported-by: Lina Lu <lulina_nuaa@foxmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-throttle.c |   25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-block/block/blk-throttle.c
> ===================================================================
> --- linux-2.6-block.orig/block/blk-throttle.c	2011-03-15 13:37:04.122389034 -0400
> +++ linux-2.6-block/block/blk-throttle.c	2011-03-15 13:37:26.328370086 -0400
> @@ -756,6 +756,15 @@ static void throtl_process_limit_change(
>  			" riops=%u wiops=%u", tg->bps[READ], tg->bps[WRITE],
>  			tg->iops[READ], tg->iops[WRITE]);
>  
> +		/*
> +		 * Restart the slices for both READ and WRITES. It
> +		 * might happen that a group's limit are dropped
> +		 * suddenly and we don't want to account recently
> +		 * dispatched IO with new low rate
> +		 */
> +		throtl_start_new_slice(td, tg, 0);
> +		throtl_start_new_slice(td, tg, 1);
> +
>  		if (throtl_tg_on_rr(tg))
>  			tg_update_disptime(td, tg);
>  	}
> @@ -821,7 +830,8 @@ throtl_schedule_delayed_work(struct thro
>  
>  	struct delayed_work *dwork = &td->throtl_work;
>  
> -	if (total_nr_queued(td) > 0) {
> +	/* schedule work if limits changed even if no bio is queued */
> +	if (total_nr_queued(td) > 0 || td->limits_changed) {
>  		/*
>  		 * We might have a work scheduled to be executed in future.
>  		 * Cancel that and schedule a new one.
> @@ -1002,6 +1012,19 @@ int blk_throtl_bio(struct request_queue 
>  	/* Bio is with-in rate limit of group */
>  	if (tg_may_dispatch(td, tg, bio, NULL)) {
>  		throtl_charge_bio(tg, bio);
> +
> +		/*
> +		 * We need to trim slice even when bios are not being queued
> +		 * otherwise it might happen that a bio is not queued for
> +		 * a long time and slice keeps on extending and trim is not
> +		 * called for a long time. Now if limits are reduced suddenly
> +		 * we take into account all the IO dispatched so far at new
> +		 * low rate and * newly queued IO gets a really long dispatch
> +		 * time.
> +		 *
> +		 * So keep on trimming slice even if bio is not queued.
> +		 */
> +		throtl_trim_slice(td, tg, rw);
>  		goto out;
>  	}
>  
