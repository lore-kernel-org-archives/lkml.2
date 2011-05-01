Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1EAHqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 03:46:12 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39335 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072Ab1EAHqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 03:46:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAEAL0MvU15LHHJgWdsb2JhbACmGBUBARYmJcQuDoVyBJV1hzg
Date: Sun, 1 May 2011 17:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: introduce wbc.for_sync to cover the two
 sync stages
Message-ID: <20110501074603.GC13542@dastard>
References: <20110430223605.034517922@intel.com>
 <20110430224552.227301247@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430224552.227301247@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:36:06AM +0800, Wu Fengguang wrote:
> sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> WB_SYNC_ALL sync. Tag both stages with wbc.for_sync for livelock
> prevention.
> 
> Note that writeback_inodes_sb() is called by not only sync(), they
> are treated the same because the other callers need also need livelock
> prevention.
> 
> Impacts:
> 
> - it changes the order in which pages/inodes are synced to disk. Now in
>   the WB_SYNC_NONE stage, it won't proceed to write the next inode until
>   finished with the current inode.
> 
> - this adds a new field to the writeback trace events and may possibly
>   break some scripts.
.....
> --- linux-next.orig/mm/page-writeback.c	2011-05-01 06:35:16.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-05-01 06:35:17.000000000 +0800
> @@ -892,12 +892,12 @@ int write_cache_pages(struct address_spa
>  			range_whole = 1;
>  		cycled = 1; /* ignore range_cyclic tests */
>  	}
> -	if (wbc->sync_mode == WB_SYNC_ALL)
> +	if (wbc->for_sync)
>  		tag = PAGECACHE_TAG_TOWRITE;
>  	else
>  		tag = PAGECACHE_TAG_DIRTY;
>  retry:
> -	if (wbc->sync_mode == WB_SYNC_ALL)
> +	if (wbc->for_sync)
>  		tag_pages_for_writeback(mapping, index, end);
>  	done_index = index;
>  	while (!done && (index <= end)) {

Doesn't that break anything that uses
filemap_write_and_wait{_range}() or filemap_fdatawrite{_range}()?
e.g. fsync, sync buffered writes, etc? i.e. everything that
currently relies on WB_SYNC_ALL for data integrity writeback is now
b0rken except for sync(1)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
