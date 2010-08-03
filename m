Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0HCOzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:55:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab0HCOzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:55:39 -0400
Subject: Re: [PATCH 2/6] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100711021748.735126772@intel.com>
References: <20100711020656.340075560@intel.com>
	 <20100711021748.735126772@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 03 Aug 2010 16:55:27 +0200
Message-ID: <1280847327.1923.589.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 10:06 +0800, Wu Fengguang wrote:
> 
> CC: Jan Kara <jack@suse.cz>

I can more or less remember this patch, and the result looks good.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |   95 ++++++++++++++----------------------------
>  1 file changed, 33 insertions(+), 62 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c 2010-07-11 08:42:14.000000000 +0800
> +++ linux-next/mm/page-writeback.c      2010-07-11 08:44:49.000000000 +0800
> @@ -253,32 +253,6 @@ static void bdi_writeout_fraction(struct
>         }
>  }
>  
>  static inline void task_dirties_fraction(struct task_struct *tsk,
>                 long *numerator, long *denominator)
>  {
> @@ -469,7 +443,6 @@ get_dirty_limits(unsigned long *pbackgro
>                         bdi_dirty = dirty * bdi->max_ratio / 100;
>  
>                 *pbdi_dirty = bdi_dirty;
>                 task_dirty_limit(current, pbdi_dirty);
>         }
>  }
> @@ -491,7 +464,7 @@ static void balance_dirty_pages(struct a
>         unsigned long bdi_thresh;
>         unsigned long pages_written = 0;
>         unsigned long pause = 1;
> +       int dirty_exceeded;
>         struct backing_dev_info *bdi = mapping->backing_dev_info;
>  
>         for (;;) {
> @@ -510,10 +483,35 @@ static void balance_dirty_pages(struct a
>                 nr_writeback = global_page_state(NR_WRITEBACK) +
>                                global_page_state(NR_WRITEBACK_TEMP);
>  
> +               /*
> +                * In order to avoid the stacked BDI deadlock we need
> +                * to ensure we accurately count the 'dirty' pages when
> +                * the threshold is low.
> +                *
> +                * Otherwise it would be possible to get thresh+n pages
> +                * reported dirty, even though there are thresh-m pages
> +                * actually dirty; with m+n sitting in the percpu
> +                * deltas.
> +                */
> +               if (bdi_thresh < 2*bdi_stat_error(bdi)) {
> +                       bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
> +                       bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
> +               } else {
> +                       bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
> +                       bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> +               }
> +
> +               /*
> +                * The bdi thresh is somehow "soft" limit derived from the
> +                * global "hard" limit. The former helps to prevent heavy IO
> +                * bdi or process from holding back light ones; The latter is
> +                * the last resort safeguard.
> +                */
> +               dirty_exceeded =
> +                       (bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
> +                       || (nr_reclaimable + nr_writeback >= dirty_thresh);
>  
> +               if (!dirty_exceeded)
>                         break;
>  
>                 /*
> @@ -541,34 +539,10 @@ static void balance_dirty_pages(struct a
>                 if (bdi_nr_reclaimable > bdi_thresh) {
>                         writeback_inodes_wb(&bdi->wb, &wbc);
>                         pages_written += write_chunk - wbc.nr_to_write;
>                         trace_wbc_balance_dirty_written(&wbc, bdi);
> +                       if (pages_written >= write_chunk)
> +                               break;          /* We've done our duty */
>                 }
>                 trace_wbc_balance_dirty_wait(&wbc, bdi);
>                 __set_current_state(TASK_INTERRUPTIBLE);
>                 io_schedule_timeout(pause);
> @@ -582,8 +556,7 @@ static void balance_dirty_pages(struct a
>                         pause = HZ / 10;
>         }
>  
> +       if (!dirty_exceeded && bdi->dirty_exceeded)
>                 bdi->dirty_exceeded = 0;
>  
>         if (writeback_in_progress(bdi))
> @@ -598,9 +571,7 @@ static void balance_dirty_pages(struct a
>          * background_thresh, to keep the amount of dirty memory low.
>          */
>         if ((laptop_mode && pages_written) ||
> +           (!laptop_mode && (nr_reclaimable > background_thresh)))
>                 bdi_start_background_writeback(bdi);
>  }
