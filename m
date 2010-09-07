Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0IGP0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:26:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41789 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab0IGPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v5CQ6nPODE1c4C33EAlX2UXXQAParZHSHnp8WnoHH6fflY7odaPFQx+w3Ob8R31woe
         FSkgYtQyRnx1LnEwWk+n0/yz5vP4BXpz1sATRe4ThZr4F2fgDXTTSSxN/8EUDpetfZL+
         Nc1P2LA81rMVviUbA1+KelqFGJmaKnoeAQUTQ=
Date: Wed, 8 Sep 2010 00:25:33 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 03/10] writeback: Do not congestion sleep if there are
 no congested BDIs or significant writeback
Message-ID: <20100907152533.GB4620@barrios-desktop>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283770053-18833-4-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:47:26AM +0100, Mel Gorman wrote:
> If congestion_wait() is called with no BDIs congested, the caller will sleep
> for the full timeout and this may be an unnecessary sleep. This patch adds
> a wait_iff_congested() that checks congestion and only sleeps if a BDI is
> congested or if there is a significant amount of writeback going on in an
> interesting zone. Else, it calls cond_resched() to ensure the caller is
> not hogging the CPU longer than its quota but otherwise will not sleep.
> 
> This is aimed at reducing some of the major desktop stalls reported during
> IO. For example, while kswapd is operating, it calls congestion_wait()
> but it could just have been reclaiming clean page cache pages with no
> congestion. Without this patch, it would sleep for a full timeout but after
> this patch, it'll just call schedule() if it has been on the CPU too long.
> Similar logic applies to direct reclaimers that are not making enough
> progress.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  include/linux/backing-dev.h      |    2 +-
>  include/trace/events/writeback.h |    7 ++++
>  mm/backing-dev.c                 |   66 ++++++++++++++++++++++++++++++++++++-
>  mm/page_alloc.c                  |    4 +-
>  mm/vmscan.c                      |   26 ++++++++++++--
>  5 files changed, 96 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 35b0074..f1b402a 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -285,7 +285,7 @@ enum {
>  void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
>  void set_bdi_congested(struct backing_dev_info *bdi, int sync);
>  long congestion_wait(int sync, long timeout);
> -
> +long wait_iff_congested(struct zone *zone, int sync, long timeout);
>  
>  static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
>  {
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 275d477..eeaf1f5 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -181,6 +181,13 @@ DEFINE_EVENT(writeback_congest_waited_template, writeback_congestion_wait,
>  	TP_ARGS(usec_timeout, usec_delayed)
>  );
>  
> +DEFINE_EVENT(writeback_congest_waited_template, writeback_wait_iff_congested,
> +
> +	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
> +
> +	TP_ARGS(usec_timeout, usec_delayed)
> +);
> +
>  #endif /* _TRACE_WRITEBACK_H */
>  
>  /* This part must be outside protection */
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 298975a..94b5433 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -724,6 +724,7 @@ static wait_queue_head_t congestion_wqh[2] = {
>  		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
>  		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
>  	};
> +static atomic_t nr_bdi_congested[2];
>  
>  void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
>  {
> @@ -731,7 +732,8 @@ void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
>  	wait_queue_head_t *wqh = &congestion_wqh[sync];
>  
>  	bit = sync ? BDI_sync_congested : BDI_async_congested;
> -	clear_bit(bit, &bdi->state);
> +	if (test_and_clear_bit(bit, &bdi->state))
> +		atomic_dec(&nr_bdi_congested[sync]);
>  	smp_mb__after_clear_bit();
>  	if (waitqueue_active(wqh))
>  		wake_up(wqh);
> @@ -743,7 +745,8 @@ void set_bdi_congested(struct backing_dev_info *bdi, int sync)
>  	enum bdi_state bit;
>  
>  	bit = sync ? BDI_sync_congested : BDI_async_congested;
> -	set_bit(bit, &bdi->state);
> +	if (!test_and_set_bit(bit, &bdi->state))
> +		atomic_inc(&nr_bdi_congested[sync]);
>  }
>  EXPORT_SYMBOL(set_bdi_congested);
>  
> @@ -774,3 +777,62 @@ long congestion_wait(int sync, long timeout)
>  }
>  EXPORT_SYMBOL(congestion_wait);
>  
> +/**
> + * congestion_wait - wait for a backing_dev to become uncongested
      wait_iff_congested

> + * @zone: A zone to consider the number of being being written back from
> + * @sync: SYNC or ASYNC IO
> + * @timeout: timeout in jiffies
> + *
> + * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
> + * write congestion.  If no backing_devs are congested then the number of
> + * writeback pages in the zone are checked and compared to the inactive
> + * list. If there is no sigificant writeback or congestion, there is no point
                                                and 

> + * in sleeping but cond_resched() is called in case the current process has
> + * consumed its CPU quota.
> + */
> +long wait_iff_congested(struct zone *zone, int sync, long timeout)
> +{
> +	long ret;
> +	unsigned long start = jiffies;
> +	DEFINE_WAIT(wait);
> +	wait_queue_head_t *wqh = &congestion_wqh[sync];
> +
> +	/*
> +	 * If there is no congestion, check the amount of writeback. If there
> +	 * is no significant writeback and no congestion, just cond_resched
> +	 */
> +	if (atomic_read(&nr_bdi_congested[sync]) == 0) {
> +		unsigned long inactive, writeback;
> +
> +		inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
> +				zone_page_state(zone, NR_INACTIVE_ANON);
> +		writeback = zone_page_state(zone, NR_WRITEBACK);
> +
> +		/*
> +		 * If less than half the inactive list is being written back,
> +		 * reclaim might as well continue
> +		 */
> +		if (writeback < inactive / 2) {

I am not sure this is best.

1. Without considering various speed class storage, could we fix it as half of inactive?
2. Isn't there any writeback throttling on above layer? Do we care of it in here?

Just out of curiosity. 

-- 
Kind regards,
Minchan Kim
