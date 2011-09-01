Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab1IADbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 23:31:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:4095 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab1IADa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 23:30:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="44000399"
Date: Thu, 1 Sep 2011 11:30:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: md related oops triggered in bdev_inode_switch_bdi
Message-ID: <20110901033056.GA22050@localhost>
References: <20110831162211.2a1fe3fb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831162211.2a1fe3fb@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

> Subject: [PATCH] Avoid dereferencing a 'request_queue' after last close.

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

with comments below.

> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1430,6 +1430,12 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  		sync_blockdev(bdev);
>  		kill_bdev(bdev);
>  	}
> +	if (!bdev->bd_openers)
> +		/* ->release can cause the old bdi to disappear,
> +		 * so must switch it out first
> +		 */
> +		bdev_inode_switch_bdi(bdev->bd_inode,
> +					&default_backing_dev_info);
>  	if (bdev->bd_contains == bdev) {
>  		if (disk->fops->release)
>  			ret = disk->fops->release(disk, mode);

The bdev_inode_switch_bdi() call can be further moved into the
previous if block, like this:

        if (!--bdev->bd_openers) {
                WARN_ON_ONCE(bdev->bd_holders);
                sync_blockdev(bdev);
                kill_bdev(bdev);
+
+               /* ->release can cause the old bdi to disappear,
+                * so must switch it out first
+                */
+               bdev_inode_switch_bdi(bdev->bd_inode,
+                                       &default_backing_dev_info);
        }

Then it's obvious that kill_bdev() will truncate all inode pages
and there won't be further interactions with dirty writes.

Although there are dozens of disk->fops->release functions, however
it's very unlikely they need to access some inode on top of the disk
(which is illogical thing).

So I don't see any problems. It makes sense to push it to next for
broader test ASAP. Will you do it, or me?

Thanks,
Fengguang
