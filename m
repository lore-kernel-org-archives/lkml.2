Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0DVTHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:07:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab0DVTHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:18 -0400
Date: Thu, 22 Apr 2010 21:07:18 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-ID: <20100422190718.GA19286@quack.suse.cz>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <1271731314-5893-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271731314-5893-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-04-10 12:41:53, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If a filesystem writes more than one page in ->writepage, write_cache_pages
> fails to notice this and continues to attempt writeback when wbc->nr_to_write
> has gone negative - this trace was captured from XFS:
> 
> 
>     wbc_writeback_start: towrt=1024
>     wbc_writepage: towrt=1024
>     wbc_writepage: towrt=0
>     wbc_writepage: towrt=-1
>     wbc_writepage: towrt=-5
>     wbc_writepage: towrt=-21
>     wbc_writepage: towrt=-85
> 
> This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> needs to terminate after a certain number of pages are written, not after a
> certain number of calls to ->writepage are made. Make it observe the current
> value of wbc->nr_to_write and treat a value of <= 0 as though it is a either a
> termination condition or a trigger to reset to MAX_WRITEḆACK_PAGES for data
> integrity syncs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/fs-writeback.c                |    9 ---------
>  include/linux/writeback.h        |    9 +++++++++
>  include/trace/events/writeback.h |    1 +
>  mm/page-writeback.c              |   20 +++++++++++++++++++-
>  4 files changed, 29 insertions(+), 10 deletions(-)
> 
  <snip>

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index d45f59e..e22af84 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -917,6 +917,7 @@ continue_unlock:
>  			if (!clear_page_dirty_for_io(page))
>  				goto continue_unlock;
>  
> +			trace_wbc_writepage(wbc);
>  			ret = (*writepage)(page, wbc, data);
>  			if (unlikely(ret)) {
>  				if (ret == AOP_WRITEPAGE_ACTIVATE) {
> @@ -935,7 +936,7 @@ continue_unlock:
>  					done = 1;
>  					break;
>  				}
> - 			}
> +			}
>  
>  			if (nr_to_write > 0) {
>  				nr_to_write--;
> @@ -955,6 +956,23 @@ continue_unlock:
>  					break;
>  				}
>  			}
> +
> +			/*
> +			 * Some filesystems will write multiple pages in
> +			 * ->writepage, so wbc->nr_to_write can change much,
> +			 * much faster than nr_to_write. Check this as an exit
> +			 * condition, or if we are doing a data integrity sync,
> +			 * reset the wbc to MAX_WRITEBACK_PAGES so that such
> +			 * filesystems can do optimal writeout here.
> +			 */
> +			if (wbc->nr_to_write <= 0) {
> +				if (wbc->sync_mode == WB_SYNC_NONE) {
> +					done = 1;
> +					nr_to_write = 0;
> +					break;
> +				}
> +				wbc->nr_to_write = MAX_WRITEBACK_PAGES;
> +			}
  Honestly, this is an ugly hack. I'd rather work towards ignoring
nr_to_write completely in WB_SYNC_ALL mode since it doesn't really make
any sence to say "write me *safely* 5 pages".

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
