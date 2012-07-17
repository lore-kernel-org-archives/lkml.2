Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2GQG1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:27:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:16552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab2GQG1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:27:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="178484121"
Date: Tue, 17 Jul 2012 14:27:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] vfs: Make sys_sync writeout also block device inodes
Message-ID: <20120717062734.GA6698@localhost>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
 <1341326734-29881-7-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341326734-29881-7-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

I got this error for !CONFIG_BLOCK builds:

fs/sync.c:110:2: error: implicit declaration of function 'iterate_bdevs' [-Werror=implicit-function-declaration]

Thanks,
Fengguang

On Tue, Jul 03, 2012 at 04:45:32PM +0200, Jan Kara wrote:
> In case block device does not have filesystem mounted on it, sys_sync will just
> ignore it and doesn't writeout its dirty pages. This is because writeback code
> avoids writing inodes from superblock without backing device and
> blockdev_superblock is such a superblock.  Since it's unexpected that sync
> doesn't writeout dirty data for block devices be nice to users and change the
> behavior to do so. So now we iterate over all block devices on blockdev_super
> instead of iterating over all superblocks when syncing block devices.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/sync.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/sync.c b/fs/sync.c
> index 867bf78..ea6e818 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -85,10 +85,14 @@ static void sync_fs_one_sb(struct super_block *sb, void *arg)
>  		sb->s_op->sync_fs(sb, *(int *)arg);
>  }
>  
> -static void sync_blkdev_one_sb(struct super_block *sb, void *arg)
> +static void flush_one_bdev(struct block_device *bdev, void *arg)
>  {
> -	if (!(sb->s_flags & MS_RDONLY))
> -		__sync_blockdev(sb->s_bdev, *(int *)arg);
> +	__sync_blockdev(bdev, 0);
> +}
> +
> +static void sync_one_bdev(struct block_device *bdev, void *arg)
> +{
> +	sync_blockdev(bdev);
>  }
>  
>  /*
> @@ -102,10 +106,10 @@ SYSCALL_DEFINE0(sync)
>  	wakeup_flusher_threads(0, WB_REASON_SYNC);
>  	iterate_supers(writeback_inodes_one_sb, NULL);
>  	iterate_supers(sync_fs_one_sb, &nowait);
> -	iterate_supers(sync_blkdev_one_sb, &nowait);
> +	iterate_bdevs(flush_one_bdev, NULL);
>  	iterate_supers(sync_inodes_one_sb, NULL);
>  	iterate_supers(sync_fs_one_sb, &wait);
> -	iterate_supers(sync_blkdev_one_sb, &wait);
> +	iterate_bdevs(sync_one_bdev, NULL);
>  	if (unlikely(laptop_mode))
>  		laptop_sync_completion();
>  	return 0;
> @@ -121,10 +125,10 @@ static void do_sync_work(struct work_struct *work)
>  	 */
>  	iterate_supers(sync_inodes_one_sb, &nowait);
>  	iterate_supers(sync_fs_one_sb, &nowait);
> -	iterate_supers(sync_blkdev_one_sb, &nowait);
> +	iterate_bdevs(flush_one_bdev, NULL);
>  	iterate_supers(sync_inodes_one_sb, &nowait);
>  	iterate_supers(sync_fs_one_sb, &nowait);
> -	iterate_supers(sync_blkdev_one_sb, &nowait);
> +	iterate_bdevs(flush_one_bdev, NULL);
>  	printk("Emergency Sync complete\n");
>  	kfree(work);
>  }
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
