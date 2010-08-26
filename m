Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0HZRiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:38:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59032 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0HZRiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cCDA64l2i1gvQx08M2lL3BpmADbstIIioG0XJbCyj0r1nYY9bRZ53wSLgdeRXVMEXX
         NLI44btSUorl2iM3xFjb+NytiGDnSJvxzAev1RH+hCe5FLF/w/vgdxnr4KHKprYG/BYn
         SBaFhytWyUaGC515VDIyRpmOPvIj4wWSLjivE=
Date: Fri, 27 Aug 2010 02:38:43 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] writeback: Do not congestion sleep when there are
 no congested BDIs
Message-ID: <20100826173843.GD6873@barrios-desktop>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <1282835656-5638-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282835656-5638-4-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:14:16PM +0100, Mel Gorman wrote:
> If congestion_wait() is called with no BDIs congested, the caller will
> sleep for the full timeout and this is an unnecessary sleep. This patch
> checks if there are BDIs congested. If so, it goes to sleep as normal.
> If not, it calls cond_resched() to ensure the caller is not hogging the
> CPU longer than its quota but otherwise will not sleep.
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
>  mm/backing-dev.c |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index a49167f..6abe860 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c

Function's decripton should be changed since we don't wait next write any more. 

> @@ -767,13 +767,21 @@ long congestion_wait(int sync, long timeout)
>  	DEFINE_WAIT(wait);
>  	wait_queue_head_t *wqh = &congestion_wqh[sync];
>  
> -	/* Check if this call to congestion_wait was necessary */
> -	if (atomic_read(&nr_bdi_congested[sync]) == 0)
> +	/*
> +	 * If there is no congestion, there is no point sleeping on the queue.
> +	 * This call was unecessary but in case we are spinning due to a bad
> +	 * caller, at least call cond_reched() and sleep if our CPU quota
> +	 * has expired
> +	 */
> +	if (atomic_read(&nr_bdi_congested[sync]) == 0) {
>  		unnecessary = true;
> -
> -	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
> -	ret = io_schedule_timeout(timeout);
> -	finish_wait(wqh, &wait);
> +		cond_resched();
> +		ret = 0;

"ret = timeout" is more proper as considering io_schedule_timeout's return value.

> +	} else {
> +		prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
> +		ret = io_schedule_timeout(timeout);
> +		finish_wait(wqh, &wait);
> +	}
>  
>  	trace_writeback_congest_waited(jiffies_to_usecs(jiffies - start),
>  			unnecessary);
> -- 
> 1.7.1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

-- 
Kind regards,
Minchan Kim
