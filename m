Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0GGRDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab0GGRDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:03:19 -0400
Date: Wed, 7 Jul 2010 13:03:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
Message-ID: <20100707170312.GK2474@redhat.com>
References: <1278518145-6021-1-git-send-email-czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278518145-6021-1-git-send-email-czoccolo@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 05:55:44PM +0200, Corrado Zoccolo wrote:
> Patch: 8e55063 cfq-iosched: fix corner cases in idling logic
> introduced the possibility of iding even on no-idle requests
> in the no_idle tree, if any previous request in the current slice
> could idle. The implementation had a problem, though:
> - if a queue sent several possibly idling requests and a noidle
>   request as last one in the same time slice, the tree was still
>   marked as idle.
> This patch fixes this misbehaviour, by using a 31-bucket hash to
> keep idling/non-idling status for queues in the noidle tree.
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index eb4086f..596b747 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -216,7 +216,7 @@ struct cfq_data {
>  	enum wl_type_t serving_type;
>  	unsigned long workload_expires;
>  	struct cfq_group *serving_group;
> -	bool noidle_tree_requires_idle;
> +	u32 noidle_tree_requires_idle;
>  
>  	/*
>  	 * Each priority tree is sorted by next_request position.  These
> @@ -2126,7 +2126,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	slice = max_t(unsigned, slice, CFQ_MIN_TT);
>  	cfq_log(cfqd, "workload slice:%d", slice);
>  	cfqd->workload_expires = jiffies + slice;
> -	cfqd->noidle_tree_requires_idle = false;
> +	cfqd->noidle_tree_requires_idle = 0U;
>  }

I think we are keeping this state for too long. IOW, we reset this state
on every service tree expiry. So assume that service tree share is 100ms
and some IO happened initially, for 1ms. Now next queues does WRITE_SYNC
IO for 10ms, in that case we don't have to idle even on SYNC_NOIDLE tree.

I think a better way is to keep track if some other queue has done any
IO on this service tree in last slice_idle period or not. That way the
window we look at is limited to slice_idle and not the whole duration of
service tree slice.

Jeff Moyer implemented this logic in his patches for fixing fsync issue.

Thanks
Vivek


>  
>  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
> @@ -3421,12 +3421,17 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  			cfq_slice_expired(cfqd, 1);
>  		else if (sync && cfqq_empty &&
>  			 !cfq_close_cooperator(cfqd, cfqq)) {
> -			cfqd->noidle_tree_requires_idle |=
> -				!(rq->cmd_flags & REQ_NOIDLE);
> +			u32 bitmask = 1U << (((int)cfqq) % 31);
> +			if (rq->cmd_flags & REQ_NOIDLE)
> +				cfqd->noidle_tree_requires_idle &= ~bitmask;
> +			else
> +				cfqd->noidle_tree_requires_idle |= bitmask;
> +
>  			/*
>  			 * Idling is enabled for SYNC_WORKLOAD.
>  			 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
> -			 * only if we processed at least one !REQ_NOIDLE request
> +			 * only if at least one queue sent !RQ_NOIDLE requests
> +			 * not followed by at least one RQ_NOIDLE request.
>  			 */
>  			if (cfqd->serving_type == SYNC_WORKLOAD
>  			    || cfqd->noidle_tree_requires_idle
> -- 
> 1.6.4.4
