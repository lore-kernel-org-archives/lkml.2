Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1IAFtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 01:49:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1IAFts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 01:49:48 -0400
Date: Thu, 1 Sep 2011 15:49:36 +1000
From: NeilBrown <neilb@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: md related oops triggered in bdev_inode_switch_bdi
Message-ID: <20110901154936.26e35821@notabene.brown>
In-Reply-To: <20110901033056.GA22050@localhost>
References: <20110831162211.2a1fe3fb@notabene.brown>
	<20110901033056.GA22050@localhost>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011 11:30:56 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> Hi Neil,
> 
> > Subject: [PATCH] Avoid dereferencing a 'request_queue' after last close.
> 
> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks.


> 
> with comments below.
> 
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -1430,6 +1430,12 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
> >  		sync_blockdev(bdev);
> >  		kill_bdev(bdev);
> >  	}
> > +	if (!bdev->bd_openers)
> > +		/* ->release can cause the old bdi to disappear,
> > +		 * so must switch it out first
> > +		 */
> > +		bdev_inode_switch_bdi(bdev->bd_inode,
> > +					&default_backing_dev_info);
> >  	if (bdev->bd_contains == bdev) {
> >  		if (disk->fops->release)
> >  			ret = disk->fops->release(disk, mode);
> 
> The bdev_inode_switch_bdi() call can be further moved into the
> previous if block, like this:
> 
>         if (!--bdev->bd_openers) {
>                 WARN_ON_ONCE(bdev->bd_holders);
>                 sync_blockdev(bdev);
>                 kill_bdev(bdev);
> +
> +               /* ->release can cause the old bdi to disappear,
> +                * so must switch it out first
> +                */
> +               bdev_inode_switch_bdi(bdev->bd_inode,
> +                                       &default_backing_dev_info);
>         }

Yes, and obvious improvement now that you have pointed it out - thanks.


> 
> Then it's obvious that kill_bdev() will truncate all inode pages
> and there won't be further interactions with dirty writes.
> 
> Although there are dozens of disk->fops->release functions, however
> it's very unlikely they need to access some inode on top of the disk
> (which is illogical thing).
> 
> So I don't see any problems. It makes sense to push it to next for
> broader test ASAP. Will you do it, or me?

I've just push it into my for-next.  If I heard nothing else by mid next week
I'll push it to Linus

Thanks,
NeilBrown


> 
> Thanks,
> Fengguang

