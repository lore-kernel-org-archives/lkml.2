Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab1GKVcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:32:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1GKVcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:32:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=if35+FYGDgs2VPj1D9SGxROId9Jed1zt5hdlABP7DMB8a/bo3nCuY4qxF52Ll6aUN
	W95oWXHkTGjuxSoB3Dz4g==
Date: Mon, 11 Jul 2011 14:31:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/15] writeback: remove writeback_control.more_io
In-Reply-To: <20110607213854.888623315@intel.com>
Message-ID: <alpine.LSU.2.00.1107111408060.13830@sister.anvils>
References: <20110607213236.634026193@intel.com> <20110607213854.888623315@intel.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Wu Fengguang wrote:
> When wbc.more_io was first introduced, it indicates whether there are
> at least one superblock whose s_more_io contains more IO work. Now with
> the per-bdi writeback, it can be replaced with a simple b_more_io test.

This commit, b7a2441f9966fe3e1be960a876ab52e6029ea005 in your branch
for linux-next, seems very reasonable to me.

But bisection, confirmed on x86_64 and ppc64 by patching the effective
(fs-writeback.c) mods into and out of mmotm with that patch reverted,
show it to be responsible for freezes when running my kernel builds
on ext2 on loop on tmpfs swapping test.

flush-7:0 (which is doing writeback to the ext2 filesystem on loop0 on
a 450MB tmpfs file, though I'm using the ext4 driver to run that ext2fs)
seems to get stuck circling around __writeback_inodes_wb(), called from
wb_writeback() from wb_do_writeback() from bdi_writeback_thread().

Other tasks then hang trying to get the spinlock in inode_wb_list_del()
(memory pressure is trying to evict inodes) or __mark_inode_dirty().

I spent a little while trying to understand why,
but couldn't work it out: hope you can do better!

You may want to ask me to try it with ext4 on disk without /dev/loop0
and tmpfs: I can try that later, though it may take me a while to tune
it to produce equivalent memory pressure.

Hugh

> 
> Acked-by: Jan Kara <jack@suse.cz>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c                |    9 ++-------
>  include/linux/writeback.h        |    1 -
>  include/trace/events/ext4.h      |    6 ++----
>  include/trace/events/writeback.h |    5 +----
>  4 files changed, 5 insertions(+), 16 deletions(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-06-08 05:16:56.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-06-08 05:17:13.000000000 +0800
> @@ -560,12 +560,8 @@ static int writeback_sb_inodes(struct su
>  		iput(inode);
>  		cond_resched();
>  		spin_lock(&wb->list_lock);
> -		if (wbc->nr_to_write <= 0) {
> -			wbc->more_io = 1;
> +		if (wbc->nr_to_write <= 0)
>  			return 1;
> -		}
> -		if (!list_empty(&wb->b_more_io))
> -			wbc->more_io = 1;
>  	}
>  	/* b_io is empty */
>  	return 1;
> @@ -708,7 +704,6 @@ static long wb_writeback(struct bdi_writ
>  			wbc.older_than_this = &oldest_jif;
>  		}
>  
> -		wbc.more_io = 0;
>  		wbc.nr_to_write = write_chunk;
>  		wbc.pages_skipped = 0;
>  		wbc.inodes_cleaned = 0;
> @@ -740,7 +735,7 @@ static long wb_writeback(struct bdi_writ
>  		/*
>  		 * No more inodes for IO, bail
>  		 */
> -		if (!wbc.more_io)
> +		if (list_empty(&wb->b_more_io))
>  			break;
>  		/*
>  		 * Nothing written. Wait for some inode to

[ Deleted the rest which is just about removing the more_io bitfield ]

Hugh
