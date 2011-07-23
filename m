Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1GWOpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 10:45:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:50839 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1GWOo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 10:44:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,252,1309762800"; 
   d="scan'208";a="30662837"
Date: Sat, 23 Jul 2011 22:44:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: manual merge of the writeback tree with the vfs
 tree
Message-ID: <20110723144454.GB5946@localhost>
References: <20110718173409.2885649b65937eb7caecf943@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718173409.2885649b65937eb7caecf943@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Jul 18, 2011 at 03:34:09PM +0800, Stephen Rothwell wrote:
> Hi Wu,
> 
> Today's linux-next merge of the writeback tree got a conflict in
> fs/fs-writeback.c between commit dffe5a6c5214 ("superblock: move
> pin_sb_for_writeback() to fs/super.c") from the vfs tree and commits
> f758eeabeb96 ("writeback: split inode_wb_list_lock into
> bdi_writeback.list_lock") and d46db3d58233 ("writeback: make
> writeback_control.nr_to_write straight") from the writeback tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

OK, please. Thank you very much!

Cheers,
Fengguang

> diff --cc fs/fs-writeback.c
> index b8c507c,6d49439..0000000
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@@ -460,6 -480,63 +480,37 @@@ writeback_single_inode(struct inode *in
>   	return ret;
>   }
>   
>  -/*
>  - * For background writeback the caller does not have the sb pinned
>  - * before calling writeback. So make sure that we do pin it, so it doesn't
>  - * go away while we are writing inodes from it.
>  - */
>  -static bool pin_sb_for_writeback(struct super_block *sb)
>  -{
>  -	spin_lock(&sb_lock);
>  -	if (list_empty(&sb->s_instances)) {
>  -		spin_unlock(&sb_lock);
>  -		return false;
>  -	}
>  -
>  -	sb->s_count++;
>  -	spin_unlock(&sb_lock);
>  -
>  -	if (down_read_trylock(&sb->s_umount)) {
>  -		if (sb->s_root)
>  -			return true;
>  -		up_read(&sb->s_umount);
>  -	}
>  -
>  -	put_super(sb);
>  -	return false;
>  -}
>  -
> + static long writeback_chunk_size(struct backing_dev_info *bdi,
> + 				 struct wb_writeback_work *work)
> + {
> + 	long pages;
> + 
> + 	/*
> + 	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
> + 	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
> + 	 * here avoids calling into writeback_inodes_wb() more than once.
> + 	 *
> + 	 * The intended call sequence for WB_SYNC_ALL writeback is:
> + 	 *
> + 	 *      wb_writeback()
> + 	 *          writeback_sb_inodes()       <== called only once
> + 	 *              write_cache_pages()     <== called once for each inode
> + 	 *                   (quickly) tag currently dirty pages
> + 	 *                   (maybe slowly) sync all tagged pages
> + 	 */
> + 	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
> + 		pages = LONG_MAX;
> + 	else {
> + 		pages = min(bdi->avg_write_bandwidth / 2,
> + 			    global_dirty_limit / DIRTY_SCOPE);
> + 		pages = min(pages, work->nr_pages);
> + 		pages = round_down(pages + MIN_WRITEBACK_PAGES,
> + 				   MIN_WRITEBACK_PAGES);
> + 	}
> + 
> + 	return pages;
> + }
> + 
>   /*
>    * Write a portion of b_io inodes which belong to @sb.
>    *
> @@@ -559,40 -643,41 +617,41 @@@ static long __writeback_inodes_wb(struc
>   		struct inode *inode = wb_inode(wb->b_io.prev);
>   		struct super_block *sb = inode->i_sb;
>   
>  -		if (!pin_sb_for_writeback(sb)) {
>  +		if (!grab_super_passive(sb)) {
> - 			requeue_io(inode);
> + 			requeue_io(inode, wb);
>   			continue;
>   		}
> - 		ret = writeback_sb_inodes(sb, wb, wbc, false);
> + 		wrote += writeback_sb_inodes(sb, wb, work);
>   		drop_super(sb);
>   
> - 		if (ret)
> - 			break;
> + 		/* refer to the same tests at the end of writeback_sb_inodes */
> + 		if (wrote) {
> + 			if (time_is_before_jiffies(start_time + HZ / 10UL))
> + 				break;
> + 			if (work->nr_pages <= 0)
> + 				break;
> + 		}
>   	}
> - 	spin_unlock(&inode_wb_list_lock);
>   	/* Leave any unwritten inodes on b_io */
> + 	return wrote;
>   }
>   
> - static void __writeback_inodes_sb(struct super_block *sb,
> - 		struct bdi_writeback *wb, struct writeback_control *wbc)
> + long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages)
>   {
> - 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> + 	struct wb_writeback_work work = {
> + 		.nr_pages	= nr_pages,
> + 		.sync_mode	= WB_SYNC_NONE,
> + 		.range_cyclic	= 1,
> + 	};
>   
> - 	spin_lock(&inode_wb_list_lock);
> - 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
> - 		queue_io(wb, wbc->older_than_this);
> - 	writeback_sb_inodes(sb, wb, wbc, true);
> - 	spin_unlock(&inode_wb_list_lock);
> - }
> + 	spin_lock(&wb->list_lock);
> + 	if (list_empty(&wb->b_io))
> + 		queue_io(wb, NULL);
> + 	__writeback_inodes_wb(wb, &work);
> + 	spin_unlock(&wb->list_lock);
>   
> - /*
> -  * The maximum number of pages to writeout in a single bdi flush/kupdate
> -  * operation.  We do this so we don't hold I_SYNC against an inode for
> -  * enormous amounts of time, which would block a userspace task which has
> -  * been forced to throttle against that inode.  Also, the code reevaluates
> -  * the dirty each time it has written this many pages.
> -  */
> - #define MAX_WRITEBACK_PAGES     1024
> + 	return nr_pages - work.nr_pages;
> + }
>   
>   static inline bool over_bground_thresh(void)
>   {
