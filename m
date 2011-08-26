Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1HZMFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:05:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:7283 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1HZMFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:05:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42707650"
Date: Fri, 26 Aug 2011 20:05:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] writeback: dirty ratelimit - think time
 compensation
Message-ID: <20110826120543.GA26666@localhost>
References: <20110826113813.895522398@intel.com>
 <20110826114619.531760091@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826114619.531760091@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -		pause = (HZ * pages_dirtied) / (task_ratelimit | 1);
> +		period = (HZ * pages_dirtied) / (task_ratelimit | 1);
> +		pause = current->dirty_paused_when + period - now;
> +		/*
> +		 * For less than 1s think time (ext3/4 may block the dirtier
> +		 * for up to 800ms from time to time on 1-HDD; so does xfs,
> +		 * however at much less frequency), try to compensate it in
> +		 * future periods by updating the virtual time; otherwise just
> +		 * do a reset, as it may be a light dirtier.
> +		 */
> +		if (unlikely(pause <= 0)) {
> +			if (pause < -HZ) {
> +				current->dirty_paused_when = now;
> +				current->nr_dirtied = 0;
> +			} else if (period) {
> +				current->dirty_paused_when += period;
> +				current->nr_dirtied = 0;
> +			}

> +			pause = 1; /* avoid resetting nr_dirtied_pause below */

Note: the above comment is only effective with the planned max pause
time adaption patch.

Thanks,
Fengguang

> +			break;
> +		}
>  		pause = min(pause, (long)MAX_PAUSE);
>  
>  pause:
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		io_schedule_timeout(pause);
>  
> +		current->dirty_paused_when = now + pause;
> +		current->nr_dirtied = 0;
> +
>  		dirty_thresh = hard_dirty_limit(dirty_thresh);
>  		/*
>  		 * max-pause area. If dirty exceeded but still within this
> @@ -1017,7 +1046,6 @@ pause:
>  	if (!dirty_exceeded && bdi->dirty_exceeded)
>  		bdi->dirty_exceeded = 0;
>  
> -	current->nr_dirtied = 0;
>  	current->nr_dirtied_pause = dirty_poll_interval(nr_dirty, dirty_thresh);
>  
>  	if (writeback_in_progress(bdi))
> --- linux-next.orig/kernel/fork.c	2011-08-16 08:50:41.000000000 +0800
> +++ linux-next/kernel/fork.c	2011-08-16 08:54:13.000000000 +0800
> @@ -1303,6 +1303,7 @@ static struct task_struct *copy_process(
>  
>  	p->nr_dirtied = 0;
>  	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
> +	p->dirty_paused_when = 0;
>  
>  	/*
>  	 * Ok, make it visible to the rest of the system.
> 
