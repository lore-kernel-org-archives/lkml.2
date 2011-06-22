Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab1FVAFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:05:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594Ab1FVAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:05:23 -0400
Date: Tue, 21 Jun 2011 17:04:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] writeback: introduce smoothed global dirty limit
Message-Id: <20110621170444.541cb240.akpm@linux-foundation.org>
In-Reply-To: <20110619150510.246140117@intel.com>
References: <20110619150108.691351746@intel.com>
	<20110619150510.246140117@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011 23:01:11 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> The start of a heavy weight application (ie. KVM) may instantly knock
> down determine_dirtyable_memory() and hence the global/bdi dirty
> thresholds.
> 
> So introduce global_dirty_limit for tracking the global dirty threshold
> with policies
> 
> - follow downwards slowly
> - follow up in one shot
> 
> global_dirty_limit can effectively mask out the impact of sudden drop of
> dirtyable memory. It will be used in the next patch for two new type of
> dirty limits.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  include/linux/writeback.h |    2 +
>  mm/page-writeback.c       |   41 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> --- linux-next.orig/include/linux/writeback.h	2011-06-19 22:56:18.000000000 +0800
> +++ linux-next/include/linux/writeback.h	2011-06-19 22:59:29.000000000 +0800
> @@ -88,6 +88,8 @@ static inline void laptop_sync_completio
>  #endif
>  void throttle_vm_writeout(gfp_t gfp_mask);
>  
> +extern unsigned long global_dirty_limit;
> +
>  /* These are exported to sysctl. */
>  extern int dirty_background_ratio;
>  extern unsigned long dirty_background_bytes;
> --- linux-next.orig/mm/page-writeback.c	2011-06-19 22:56:18.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-06-19 22:59:29.000000000 +0800
> @@ -116,6 +116,7 @@ EXPORT_SYMBOL(laptop_mode);
>  
>  /* End of sysctl-exported parameters */
>  
> +unsigned long global_dirty_limit;
>  
>  /*
>   * Scale the writeback cache size proportional to the relative writeout speeds.
> @@ -510,6 +511,43 @@ static void bdi_update_write_bandwidth(s
>  	bdi->avg_write_bandwidth = avg;
>  }
>  
> +static void update_dirty_limit(unsigned long thresh,
> +				 unsigned long dirty)
> +{
> +	unsigned long limit = global_dirty_limit;
> +
> +	if (limit < thresh) {
> +		limit = thresh;
> +		goto update;
> +	}
> +
> +	if (limit > thresh &&
> +	    limit > dirty) {
> +		limit -= (limit - max(thresh, dirty)) >> 5;
> +		goto update;
> +	}
> +	return;
> +update:
> +	global_dirty_limit = limit;
> +}

Are
you
using
a
30
column
monitor
over
there?


This function is just crazy.  It compares various things, applies
limits, churns them all together with magic constants and does it all
in a refreshingly documentation-free manner.

How the heck is anyone supposed to understand what you were thinking
when you typed it in?

Please, write for an audience.

> +static void global_update_bandwidth(unsigned long thresh,
> +				    unsigned long dirty,
> +				    unsigned long now)
> +{
> +	static DEFINE_SPINLOCK(dirty_lock);
> +
> +	if (now - default_backing_dev_info.bw_time_stamp < MAX_PAUSE)
> +		return;
> +
> +	spin_lock(&dirty_lock);
> +	if (now - default_backing_dev_info.bw_time_stamp >= MAX_PAUSE) {
> +		update_dirty_limit(thresh, dirty);
> +		default_backing_dev_info.bw_time_stamp = now;
> +	}
> +	spin_unlock(&dirty_lock);
> +}

Why is it playing with default_backing_dev_info?  That's only there to
support filesystems which were too old-and-slack to implement
backing-devs properly and it really shouldn't exist at all.

