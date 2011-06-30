Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1F3T4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:56:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1F3T4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:56:15 -0400
Date: Thu, 30 Jun 2011 21:56:09 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Shaohua <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] writeback: bdi write bandwidth estimation
Message-ID: <20110630195609.GA9722@quack.suse.cz>
References: <20110629145245.835998321@intel.com>
 <20110629145553.906668553@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629145553.906668553@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Wed 29-06-11 22:52:48, Wu Fengguang wrote:
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
  I was thinking about your formulas and also observing how it behaves when
writeback happens while the disk is loaded with other load as well (e.g.
grep -r of a large tree or cp from another partition).

I agree that some kind of averaging is needed. But how we average depends
on what do we need the number for. My thoughts were that there is not such
a thing as *the* write bandwidth since that depends on the background load
on the disk and also type of writes we do (sequential, random) as you noted
as well. What writeback needs to estimate in fact is "how fast can we write
this bulk of data?". Since we should ultimately size dirty limits and other
writeback tunables so that the bulk of data can be written in order of
seconds (but maybe much slower because of background load) I agree with
your first choice that we should measure written pages in a window of
several seconds - so your choice of 3 seconds is OK - but this number
should have a reasoning attached to it in a comment (something like my
elaborate above ;)

Now to your second level of smoothing - is it really useful? We already
average over several second window so that should really eliminate big
spikes comming from bumpy IO completion from storage (NFS might be a
separate question but we talked about that already). Your second level
of smoothing just spreads the window even further but if you find that
necessary, why not make the window larger in the first place? Also my
observations of avg-bandwidth and bandwidth when there's some background
read load (e.g. from grep) shows that in this case both bandwidth and
avg-bandwidth fluctuate +-10%. Finally, as I reasoned above, we are
interested in how much we can write in coming say 2 seconds so I don't see
a big point smoothing the value too much (I'd even say it's undesirable).
What do you think?

Some code related comments are below:

> --- linux-next.orig/fs/fs-writeback.c	2011-06-23 10:31:40.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-06-29 16:23:05.000000000 +0800
> @@ -693,6 +693,16 @@ static inline bool over_bground_thresh(v
>  }
>  
>  /*
> + * Called under wb->list_lock. If there are multiple wb per bdi,
> + * only the flusher working on the first wb should do it.
> + */
> +static void wb_update_bandwidth(struct bdi_writeback *wb,
> +				unsigned long start_time)
> +{
> +	__bdi_update_bandwidth(wb->bdi, start_time);
> +}
> +
> +/*
>   * Explicit flushing or periodic writeback of "old" data.
>   *
>   * Define "old": the first time one of an inode's pages is dirtied, we mark the
> @@ -710,6 +720,7 @@ static inline bool over_bground_thresh(v
>  static long wb_writeback(struct bdi_writeback *wb,
>  			 struct wb_writeback_work *work)
>  {
> +	unsigned long wb_start = jiffies;
>  	long nr_pages = work->nr_pages;
>  	unsigned long oldest_jif;
>  	struct inode *inode;
> @@ -758,6 +769,8 @@ static long wb_writeback(struct bdi_writ
>  			progress = __writeback_inodes_wb(wb, work);
>  		trace_writeback_written(wb->bdi, work);
>  
> +		wb_update_bandwidth(wb, wb_start);
> +
>  		/*
>  		 * Did we write something? Try for more
>  		 *
> --- linux-next.orig/include/linux/backing-dev.h	2011-06-23 10:31:40.000000000 +0800
> +++ linux-next/include/linux/backing-dev.h	2011-06-29 16:23:05.000000000 +0800
> @@ -73,6 +73,11 @@ struct backing_dev_info {
>  
>  	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
>  
> +	unsigned long bw_time_stamp;
> +	unsigned long written_stamp;
> +	unsigned long write_bandwidth;
> +	unsigned long avg_write_bandwidth;
> +
  Some comments on what these are would be useful.

>  	struct prop_local_percpu completions;
>  	int dirty_exceeded;
>  
> --- linux-next.orig/mm/page-writeback.c	2011-06-23 10:31:40.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-06-29 16:23:44.000000000 +0800
> @@ -37,6 +37,11 @@
>  #include <trace/events/writeback.h>
>  
>  /*
> + * Sleep at most 200ms at a time in balance_dirty_pages().
> + */
> +#define MAX_PAUSE	max(HZ/5, 1)
  You use this for ratelimiting updates of bdi bandwidth. So we should
really have a separate (and properly commented) constant for it.

> +static void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
> +				       unsigned long elapsed,
> +				       unsigned long written)
> +{
> +	const unsigned long period = roundup_pow_of_two(3 * HZ);
> +	unsigned long avg = bdi->avg_write_bandwidth;
> +	unsigned long old = bdi->write_bandwidth;
> +	unsigned long cur;
> +	u64 bw;
> +
> +	bw = written - bdi->written_stamp;
> +	bw *= HZ;
> +	if (unlikely(elapsed > period / 2)) {
> +		do_div(bw, elapsed);
> +		elapsed = period / 2;
> +		bw *= elapsed;
> +	}
  What is the rationale behind this condition? Why cannot we just use 
written/elapsed when we have long enough period? Have you observed some
problems with it (I estimate bandwidth in my patches like:
static void update_bdi_throughput(struct backing_dev_info *bdi,
                                unsigned long written, unsigned long time)
{
       unsigned int deltams = jiffies_to_msecs(time - bdi->start_jiffies);

       written -= bdi->start_written;
       if (deltams > WINDOW_MS) {
               /* Add 1 to avoid 0 result */
               bdi->pages_per_s = 1 + ((u64)written) * MSEC_PER_SEC / deltams;
               return;
       }
       bdi->pages_per_s = 1 +
               (((u64)bdi->pages_per_s) * (WINDOW_MS - deltams) +
                ((u64)written) * MSEC_PER_SEC) / WINDOW_MS;
}

and I didn't observe any problems with it. Plus you need some comment
explaining how you compute the throughput. I have something like:
/*
 * When the throughput is computed, we consider an imaginary WINDOW_MS
 * miliseconds long window. In this window, we know that it took 'deltams'
 * miliseconds to write 'written' pages and for the rest of the window we
 * assume number of pages corresponding to the throughput we previously
 * computed to have been written. Thus we obtain total number of pages
 * written in the imaginary window and from it new throughput.
 */

> +	bw += (u64)bdi->write_bandwidth * (period - elapsed);
> +	cur = bw >> ilog2(period);
> +
> +	/*
> +	 * one more level of smoothing, for filtering out sudden spikes
> +	 */
> +	if (avg > old && old > cur)
> +		avg -= (avg - old) >> 3;
> +
> +	if (avg < old && old < cur)
> +		avg += (old - avg) >> 3;
> +
> +	bdi->write_bandwidth = cur;
> +	bdi->avg_write_bandwidth = avg;
> +}
> +
> +void __bdi_update_bandwidth(struct backing_dev_info *bdi,
> +			    unsigned long start_time)
> +{
> +	unsigned long now = jiffies;
> +	unsigned long elapsed = now - bdi->bw_time_stamp;
> +	unsigned long written;
> +
> +	/*
> +	 * rate-limit, only update once every 200ms.
> +	 */
> +	if (elapsed < MAX_PAUSE)
> +		return;
> +
> +	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]);
> +
> +	/*
> +	 * Skip quiet periods when disk bandwidth is under-utilized.
> +	 * (at least 1s idle time between two flusher runs)
> +	 */
> +	if (elapsed > HZ && time_before(bdi->bw_time_stamp, start_time))
> +		goto snapshot;
  Cannot we just explicitely stamp the written_stamp and bw_time_stamp at
the beginning of wb_writeback and be done with it? We wouldn't have to
pass the time stamps, keep them in wb_writeback() and balance_dirty_pages()
etc.

> +
> +	bdi_update_write_bandwidth(bdi, elapsed, written);
> +
> +snapshot:
> +	bdi->written_stamp = written;
> +	bdi->bw_time_stamp = now;
> +}
> +
> +static void bdi_update_bandwidth(struct backing_dev_info *bdi,
> +				 unsigned long start_time)
> +{
> +	if (jiffies - bdi->bw_time_stamp <= MAX_PAUSE + MAX_PAUSE / 10)
> +		return;
> +	if (spin_trylock(&bdi->wb.list_lock)) {
  I'm not sure this is a good idea - list_lock could be quite busy which
would possibly quite delay updates of bandwidth. I'd just unconditionally
take it.

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

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
