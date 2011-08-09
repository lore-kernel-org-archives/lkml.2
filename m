Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1HIPvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab1HIPvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:51:44 -0400
Date: Tue, 9 Aug 2011 11:50:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: dirty rate control
Message-ID: <20110809155046.GD6482@redhat.com>
References: <20110806084447.388624428@intel.com>
 <20110806094526.878435971@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806094526.878435971@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 04:44:50PM +0800, Wu Fengguang wrote:

[..]
> +/*
> + * Maintain bdi->dirty_ratelimit, the base throttle bandwidth.
> + *
> + * Normal bdi tasks will be curbed at or below it in long term.
> + * Obviously it should be around (write_bw / N) when there are N dd tasks.
> + */

Hi Fengguang,

So IIUC, bdi->dirty_ratelimit is the dynmically adjusted desired rate
limit (based on postion ratio, dirty_bw and write_bw). But this seems
to be overall bdi limit and does not seem to take into account the
number of tasks doing IO to that bdi (as your comment suggests). So
it probably will track write_bw as opposed to write_bw/N. What am
I missing?

Thanks
Vivek


> +static void bdi_update_dirty_ratelimit(struct backing_dev_info *bdi,
> +				       unsigned long thresh,
> +				       unsigned long dirty,
> +				       unsigned long bdi_thresh,
> +				       unsigned long bdi_dirty,
> +				       unsigned long dirtied,
> +				       unsigned long elapsed)
> +{
> +	unsigned long bw = bdi->dirty_ratelimit;
> +	unsigned long dirty_bw;
> +	unsigned long pos_bw;
> +	unsigned long ref_bw;
> +	unsigned long long pos_ratio;
> +
> +	/*
> +	 * The dirty rate will match the writeback rate in long term, except
> +	 * when dirty pages are truncated by userspace or re-dirtied by FS.
> +	 */
> +	dirty_bw = (dirtied - bdi->dirtied_stamp) * HZ / elapsed;
> +
> +	pos_ratio = bdi_position_ratio(bdi, thresh, dirty,
> +				       bdi_thresh, bdi_dirty);
> +	/*
> +	 * pos_bw reflects each dd's dirty rate enforced for the past 200ms.
> +	 */
> +	pos_bw = bw * pos_ratio >> BANDWIDTH_CALC_SHIFT;
> +	pos_bw++;  /* this avoids bdi->dirty_ratelimit get stuck in 0 */
> +
> +	/*
> +	 * ref_bw = pos_bw * write_bw / dirty_bw
> +	 *
> +	 * It's a linear estimation of the "balanced" throttle bandwidth.
> +	 */
> +	pos_ratio *= bdi->avg_write_bandwidth;
> +	do_div(pos_ratio, dirty_bw | 1);
> +	ref_bw = bw * pos_ratio >> BANDWIDTH_CALC_SHIFT;
> +
> +	/*
> +	 * dirty_ratelimit will follow ref_bw/pos_bw conservatively iff they
> +	 * are on the same side of dirty_ratelimit. Which not only makes it
> +	 * more stable, but also is essential for preventing it being driven
> +	 * away by possible systematic errors in ref_bw.
> +	 */
> +	if (pos_bw < bw) {
> +		if (ref_bw < bw)
> +			bw = max(ref_bw, pos_bw);
> +	} else {
> +		if (ref_bw > bw)
> +			bw = min(ref_bw, pos_bw);
> +	}
> +
> +	bdi->dirty_ratelimit = bw;
> +}
> +
>  void __bdi_update_bandwidth(struct backing_dev_info *bdi,
>  			    unsigned long thresh,
>  			    unsigned long dirty,
> @@ -745,6 +805,7 @@ void __bdi_update_bandwidth(struct backi
>  {
>  	unsigned long now = jiffies;
>  	unsigned long elapsed = now - bdi->bw_time_stamp;
> +	unsigned long dirtied;
>  	unsigned long written;
>  
>  	/*
> @@ -753,6 +814,7 @@ void __bdi_update_bandwidth(struct backi
>  	if (elapsed < BANDWIDTH_INTERVAL)
>  		return;
>  
> +	dirtied = percpu_counter_read(&bdi->bdi_stat[BDI_DIRTIED]);
>  	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]);
>  
>  	/*
> @@ -762,12 +824,15 @@ void __bdi_update_bandwidth(struct backi
>  	if (elapsed > HZ && time_before(bdi->bw_time_stamp, start_time))
>  		goto snapshot;
>  
> -	if (thresh)
> +	if (thresh) {
>  		global_update_bandwidth(thresh, dirty, now);
> -
> +		bdi_update_dirty_ratelimit(bdi, thresh, dirty, bdi_thresh,
> +					   bdi_dirty, dirtied, elapsed);
> +	}
>  	bdi_update_write_bandwidth(bdi, elapsed, written);
>  
>  snapshot:
> +	bdi->dirtied_stamp = dirtied;
>  	bdi->written_stamp = written;
>  	bdi->bw_time_stamp = now;
>  }
> 
