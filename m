Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab1KUUhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:37:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab1KUUhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:37:50 -0500
Date: Mon, 21 Nov 2011 21:37:42 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: hard throttle 1000+ dd on a slow USB stick
Message-ID: <20111121203742.GD4017@quack.suse.cz>
References: <20111117115914.GA24502@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117115914.GA24502@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-11-11 19:59:14, Wu Fengguang wrote:
> The sleep based balance_dirty_pages() can pause at most MAX_PAUSE=200ms
> on every 1 4KB-page, which means it cannot throttle a task under
> 4KB/200ms=20KB/s. So when there are more than 512 dd writing to a
> 10MB/s USB stick, its bdi dirty pages could grow out of control.
> 
> Even if we can increase MAX_PAUSE, the minimal (task_ratelimit = 1)
> means a limit of 4KB/s.
> 
> They can eventually be safeguarded by the global limit check
> (nr_dirty < dirty_thresh). However if someone is also writing to an
> HDD at the same time, it'll get poor HDD write performance.
> 
> We at least want to maintain good write performance for other devices
> when one device is attacked by some "massive parallel" workload, or
> suffers from slow write bandwidth, or somehow get stalled due to some
> error condition (eg. NFS server not responding).
> 
> For a stalled device, we need to completely block its dirtiers, too,
> before its bdi dirty pages grow all the way up to the global limit and
> leave no space for the other functional devices.
  This is a fundamental question - how much do you allow dirty cache of one
device to grow when other devices are relatively idle? Every choice has
advantages and disadvantages. If you allow device to occupy lot of the
cache, you may later find yourself short on dirtiable memory when other
devices become active. On the other hand allowing more dirty memory can
improve IO pattern and thus writeout speed. So whatever choice we make,
we should explain our choice somewhere in the code and stick to that...

> So change the loop exit condition to
> 
> 	/*
> 	 * Always enforce global dirty limit; also enforce bdi dirty limit
> 	 * if the normal max_pause sleeps cannot keep things under control.
> 	 */
> 	if (nr_dirty < dirty_thresh &&
> 	    (bdi_dirty < bdi_thresh || bdi->dirty_ratelimit > 1))
> 		break;
> 
> which can be further simplified to
> 
> 	if (task_ratelimit)
> 		break;
  Hmm, but if pos_ratio == 0, task_ratelimit is uninitialized... Generally,
I would find it more robust to have there a test directly with numbers of
dirty pages - then it would be independent of whatever changes we make in
ratelimit computations in future. 

								Honza
  
 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-11-17 19:23:57.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-11-17 19:23:59.000000000 +0800
> @@ -1136,14 +1136,11 @@ pause:
>  		__set_current_state(TASK_KILLABLE);
>  		io_schedule_timeout(pause);
>  
> -		dirty_thresh = hard_dirty_limit(dirty_thresh);
>  		/*
> -		 * max-pause area. If dirty exceeded but still within this
> -		 * area, no need to sleep for more than 200ms: (a) 8 pages per
> -		 * 200ms is typically more than enough to curb heavy dirtiers;
> -		 * (b) the pause time limit makes the dirtiers more responsive.
> +		 * This is typically equal to (nr_dirty < dirty_thresh) and can
> +		 * also keep "1000+ dd on a slow USB stick" under control.
>  		 */
> -		if (nr_dirty < dirty_thresh)
> +		if (task_ratelimit)
>  			break;
>  
>  		if (fatal_signal_pending(current))
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
