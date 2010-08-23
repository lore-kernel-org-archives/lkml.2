Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0HWI2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:28:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:26853 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab0HWI2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:28:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,256,1280732400"; 
   d="scan'208";a="830744647"
Date: Mon, 23 Aug 2010 16:27:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] writeback: write_cache_pages doesn't terminate at
 nr_to_write <= 0
Message-ID: <20100823082747.GB4970@localhost>
References: <1282538620-10824-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282538620-10824-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 02:43:40PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I noticed XFS writeback in 2.6.36-rc1 was much slower than it should have
> been. Enabling writeback tracing showed:
> 
>     flush-253:16-8516  [007] 1342952.351608: wbc_writepage: bdi 253:16: towrt=1024 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
>     flush-253:16-8516  [007] 1342952.351654: wbc_writepage: bdi 253:16: towrt=1023 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
>     flush-253:16-8516  [000] 1342952.369520: wbc_writepage: bdi 253:16: towrt=0 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
>     flush-253:16-8516  [000] 1342952.369542: wbc_writepage: bdi 253:16: towrt=-1 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
>     flush-253:16-8516  [000] 1342952.369549: wbc_writepage: bdi 253:16: towrt=-2 skip=0 mode=0 kupd=0 bgrd=1 reclm=0 cyclic=1 more=0 older=0x0 start=0x0 end=0x0
> 
> Writeback is not terminating in background writeback if ->writepage is
> returning with wbc->nr_to_write == 0, resulting in sub-optimal single page
> writeback on XFS.

The new code looks more simple, and more robust in case ->writepage 
modifies wbc->nr_to_write (as in xfs_vm_writepage).

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang

> Fix the write_cache_pages loop to terminate correctly when this situation
> occurs and so prevent this sub-optimal background writeback pattern. This
> improves sustained sequential buffered write performance from around
> 250MB/s to 750MB/s for a 100GB file on an XFS filesystem on my 8p test VM.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mm/page-writeback.c |   26 ++++++++++----------------
>  1 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 7262aac..f069782 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -984,22 +984,16 @@ continue_unlock:
>  				}
>  			}
>  
> -			if (wbc->nr_to_write > 0) {
> -				if (--wbc->nr_to_write == 0 &&
> -				    wbc->sync_mode == WB_SYNC_NONE) {
> -					/*
> -					 * We stop writing back only if we are
> -					 * not doing integrity sync. In case of
> -					 * integrity sync we have to keep going
> -					 * because someone may be concurrently
> -					 * dirtying pages, and we might have
> -					 * synced a lot of newly appeared dirty
> -					 * pages, but have not synced all of the
> -					 * old dirty pages.
> -					 */
> -					done = 1;
> -					break;
> -				}
> +			/*
> +			 * We stop writing back only if we are not doing
> +			 * integrity sync. In case of integrity sync we have to
> +			 * keep going until we have written all the pages
> +			 * we tagged for writeback prior to entering this loop.
> +			 */
> +			if (--wbc->nr_to_write <= 0 &&
> +			    wbc->sync_mode == WB_SYNC_NONE) {
> +				done = 1;
> +				break;
>  			}
>  		}
>  		pagevec_release(&pvec);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
