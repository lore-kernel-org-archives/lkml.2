Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1GAPUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:20:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41195 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1GAPUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:20:12 -0400
Date: Fri, 1 Jul 2011 17:20:05 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Shaohua <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] writeback: bdi write bandwidth estimation
Message-ID: <20110701152005.GA13445@thinkpad>
References: <20110629145245.835998321@intel.com>
 <20110629145553.906668553@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629145553.906668553@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:52:48PM +0800, Wu Fengguang wrote:
> The estimation value will start from 100MB/s and adapt to the real
> bandwidth in seconds.
> 
> It tries to update the bandwidth only when disk is fully utilized.
> Any inactive period of more than one second will be skipped.
> 
> The estimated bandwidth will be reflecting how fast the device can
> writeout when _fully utilized_, and won't drop to 0 when it goes idle.
> The value will remain constant at disk idle time. At busy write time, if
> not considering fluctuations, it will also remain high unless be knocked
> down by possible concurrent reads that compete for the disk time and
> bandwidth with async writes.
> 
> The estimation is not done purely in the flusher because there is no
> guarantee for write_cache_pages() to return timely to update bandwidth.
> 
> The bdi->avg_write_bandwidth smoothing is very effective for filtering
> out sudden spikes, however may be a little biased in long term.
> 
> The overheads are low because the bdi bandwidth update only occurs at
> 200ms intervals.
> 
> The 200ms update interval is suitable, becuase it's not possible to get
> the real bandwidth for the instance at all, due to large fluctuations.
> 
> The NFS commits can be as large as seconds worth of data. One XFS
> completion may be as large as half second worth of data if we are going
> to increase the write chunk to half second worth of data. In ext4,
> fluctuations with time period of around 5 seconds is observed. And there
> is another pattern of irregular periods of up to 20 seconds on SSD tests.
> 
> That's why we are not only doing the estimation at 200ms intervals, but
> also averaging them over a period of 3 seconds and then go further to do
> another level of smoothing in avg_write_bandwidth.
> 
> CC: Li Shaohua <shaohua.li@intel.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---

...

Another small time nitpick.

> +
> +static void bdi_update_bandwidth(struct backing_dev_info *bdi,
> +				 unsigned long start_time)
> +{
> +	if (jiffies - bdi->bw_time_stamp <= MAX_PAUSE + MAX_PAUSE / 10)

	if (time_is_after_eq_jiffies(bdi->bw_time_stamp + MAX_PAUSE +
						MAX_PAUSE / 10)

> +		return;
> +	if (spin_trylock(&bdi->wb.list_lock)) {
> +		__bdi_update_bandwidth(bdi, start_time);
> +		spin_unlock(&bdi->wb.list_lock);
> +	}
> +}
> +
>  /*
>   * balance_dirty_pages() must be called by processes which are generating dirty
>   * data.  It looks at the number of dirty pages in the machine and will force
> @@ -491,6 +569,7 @@ static void balance_dirty_pages(struct a
>  	unsigned long pause = 1;
>  	bool dirty_exceeded = false;
>  	struct backing_dev_info *bdi = mapping->backing_dev_info;
> +	unsigned long start_time = jiffies;
>  
>  	for (;;) {
>  		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> @@ -545,6 +624,8 @@ static void balance_dirty_pages(struct a
>  		if (!bdi->dirty_exceeded)
>  			bdi->dirty_exceeded = 1;
>  
> +		bdi_update_bandwidth(bdi, start_time);
> +
>  		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
>  		 * Unstable writes are a feature of certain networked
>  		 * filesystems (i.e. NFS) in which data may have been
> 
> 

-Andrea
