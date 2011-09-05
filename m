Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1IEPGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 11:06:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:41399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1IEPGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 11:06:13 -0400
Subject: Re: [PATCH 02/18] writeback: dirty position control
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 05 Sep 2011 17:05:57 +0200
In-Reply-To: <20110904020914.848566742@intel.com>
References: <20110904015305.367445271@intel.com>
	 <20110904020914.848566742@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315235157.3191.6.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 09:53 +0800, Wu Fengguang wrote:
> @@ -591,6 +790,7 @@ static void global_update_bandwidth(unsi
>  
>  void __bdi_update_bandwidth(struct backing_dev_info *bdi,
>                             unsigned long thresh,
> +                           unsigned long bg_thresh,
>                             unsigned long dirty,
>                             unsigned long bdi_thresh,
>                             unsigned long bdi_dirty,
> @@ -627,6 +827,7 @@ snapshot:
>  
>  static void bdi_update_bandwidth(struct backing_dev_info *bdi,
>                                  unsigned long thresh,
> +                                unsigned long bg_thresh,
>                                  unsigned long dirty,
>                                  unsigned long bdi_thresh,
>                                  unsigned long bdi_dirty,
> @@ -635,8 +836,8 @@ static void bdi_update_bandwidth(struct 
>         if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
>                 return;
>         spin_lock(&bdi->wb.list_lock);
> -       __bdi_update_bandwidth(bdi, thresh, dirty, bdi_thresh, bdi_dirty,
> -                              start_time);
> +       __bdi_update_bandwidth(bdi, thresh, bg_thresh, dirty,
> +                              bdi_thresh, bdi_dirty, start_time);
>         spin_unlock(&bdi->wb.list_lock);
>  }
>  
> @@ -677,7 +878,8 @@ static void balance_dirty_pages(struct a
>                  * catch-up. This avoids (excessively) small writeouts
>                  * when the bdi limits are ramping up.
>                  */
> -               if (nr_dirty <= (background_thresh + dirty_thresh) / 2)
> +               if (nr_dirty <= dirty_freerun_ceiling(dirty_thresh,
> +                                                     background_thresh))
>                         break;
>  
>                 bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
> @@ -721,8 +923,9 @@ static void balance_dirty_pages(struct a
>                 if (!bdi->dirty_exceeded)
>                         bdi->dirty_exceeded = 1;
>  
> -               bdi_update_bandwidth(bdi, dirty_thresh, nr_dirty,
> -                                    bdi_thresh, bdi_dirty, start_time);
> +               bdi_update_bandwidth(bdi, dirty_thresh, background_thresh,
> +                                    nr_dirty, bdi_thresh, bdi_dirty,
> +                                    start_time);
>  
>                 /* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
>                  * Unstable writes are a feature of certain networked
> --- linux-next.orig/fs/fs-writeback.c   2011-08-26 15:57:18.000000000 +0800
> +++ linux-next/fs/fs-writeback.c        2011-08-26 15:57:20.000000000 +0800
> @@ -675,7 +675,7 @@ static inline bool over_bground_thresh(v
>  static void wb_update_bandwidth(struct bdi_writeback *wb,
>                                 unsigned long start_time)
>  {
> -       __bdi_update_bandwidth(wb->bdi, 0, 0, 0, 0, start_time);
> +       __bdi_update_bandwidth(wb->bdi, 0, 0, 0, 0, 0, start_time);
>  }
>  
>  /*
> --- linux-next.orig/include/linux/writeback.h   2011-08-26 15:57:18.000000000 +0800
> +++ linux-next/include/linux/writeback.h        2011-08-26 15:57:20.000000000 +0800
> @@ -141,6 +141,7 @@ unsigned long bdi_dirty_limit(struct bac
>  
>  void __bdi_update_bandwidth(struct backing_dev_info *bdi,
>                             unsigned long thresh,
> +                           unsigned long bg_thresh,
>                             unsigned long dirty,
>                             unsigned long bdi_thresh,
>                             unsigned long bdi_dirty,


All this function signature muck doesn't seem immediately relevant to
the introduction of bdi_position_ratio() since the new function isn't
actually used.
