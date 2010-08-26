Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0HZRfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:35:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50290 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab0HZRfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:35:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E6+1PrJexSsYc6uc2RKwmef5K1unw7MQvVPYYHvvmah9J5h08YaB/7APqP3cJKapVB
         8TPs5iL+dAxfkZ1WGPrQN/Yq0lSf2vdVgKSmOcG5tfZZ779OAhS7k7aJ/b8q+zzruZMz
         9TkpbKHnsLT3M3JonmQlwR1C4Sq5czdbtrC0g=
Date: Fri, 27 Aug 2010 02:35:34 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: Record if the congestion was unnecessary
Message-ID: <20100826173534.GC6873@barrios-desktop>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <1282835656-5638-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282835656-5638-3-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:14:15PM +0100, Mel Gorman wrote:
> If congestion_wait() is called when there is no congestion, the caller
> will wait for the full timeout. This can cause unreasonable and
> unnecessary stalls. There are a number of potential modifications that
> could be made to wake sleepers but this patch measures how serious the
> problem is. It keeps count of how many congested BDIs there are. If
> congestion_wait() is called with no BDIs congested, the tracepoint will
> record that the wait was unnecessary.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  include/trace/events/writeback.h |   11 ++++++++---
>  mm/backing-dev.c                 |   15 ++++++++++++---
>  2 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index e3bee61..03bb04b 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -155,19 +155,24 @@ DEFINE_WBC_EVENT(wbc_writepage);
>  
>  TRACE_EVENT(writeback_congest_waited,
>  
> -	TP_PROTO(unsigned int usec_delayed),
> +	TP_PROTO(unsigned int usec_delayed, bool unnecessary),
>  
> -	TP_ARGS(usec_delayed),
> +	TP_ARGS(usec_delayed, unnecessary),
>  
>  	TP_STRUCT__entry(
>  		__field(	unsigned int,	usec_delayed	)
> +		__field(	unsigned int,	unnecessary	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->usec_delayed	= usec_delayed;
> +		__entry->unnecessary	= unnecessary;
>  	),
>  
> -	TP_printk("usec_delayed=%u", __entry->usec_delayed)
> +	TP_printk("usec_delayed=%u unnecessary=%d",
> +		__entry->usec_delayed,
> +		__entry->unnecessary
> +	)
>  );
>  
>  #endif /* _TRACE_WRITEBACK_H */
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 7ae33e2..a49167f 100644
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

Hmm.. Now congestion_wait's semantics "wait for _a_ backing_dev to become uncongested"
But this seems to consider whole backing dev. Is your intention? or Am I missing now?

-- 
Kind regards,
Minchan Kim
