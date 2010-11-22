Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0KVXuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:50:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:34598 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871Ab0KVXuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:50:10 -0500
Date: Tue, 23 Nov 2010 10:50:00 +1100
From: Neil Brown <neilb@suse.de>
To: djwong@us.ibm.com
Cc: linux-raid@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md: Call blk_queue_flush() to establish flush/fua
 support
Message-ID: <20101123105000.331b40f8@notabene.brown>
In-Reply-To: <20101122232208.GU14383@tux1.beaverton.ibm.com>
References: <20101122232208.GU14383@tux1.beaverton.ibm.com>
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 15:22:08 -0800
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> Before 2.6.37, the md layer had a mechanism for catching I/Os with the barrier
> flag set, and translating the barrier into barriers for all the underlying
> devices.  With 2.6.37, I/O barriers have become plain old flushes, and the md
> code was updated to reflect this.  However, one piece was left out -- the md
> layer does not tell the block layer that it supports flushes or FUA access at
> all, which results in md silently dropping flush requests.
> 
> Since the support already seems there, just add this one piece of bookkeeping
> to restore the ability to flush writes through md.

I would rather just unconditionally call
   blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);

I don't think there is much to be gained by trying to track exactly what the
underlying devices support, and as the devices can change, that is racy
anyway.

Thoughts?

NeilBrown




> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/md/md.c |   25 ++++++++++++++++++++++++-
>  1 files changed, 24 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 324a366..a52d7be 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -356,6 +356,21 @@ EXPORT_SYMBOL(mddev_congested);
>  /*
>   * Generic flush handling for md
>   */
> +static void evaluate_flush_capability(mddev_t *mddev)
> +{
> +	mdk_rdev_t *rdev;
> +	unsigned int flush = REQ_FLUSH | REQ_FUA;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(rdev, &mddev->disks, same_set) {
> +		if (rdev->raid_disk < 0)
> +			continue;
> +		flush &= rdev->bdev->bd_disk->queue->flush_flags;
> +	}
> +	rcu_read_unlock();
> +
> +	blk_queue_flush(mddev->queue, flush);
> +}
>  
>  static void md_end_flush(struct bio *bio, int err)
>  {
> @@ -1885,6 +1900,8 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
>  	/* May as well allow recovery to be retried once */
>  	mddev->recovery_disabled = 0;
>  
> +	evaluate_flush_capability(mddev);
> +
>  	return 0;
>  
>   fail:
> @@ -1903,17 +1920,23 @@ static void md_delayed_delete(struct work_struct *ws)
>  static void unbind_rdev_from_array(mdk_rdev_t * rdev)
>  {
>  	char b[BDEVNAME_SIZE];
> +	mddev_t *mddev;
> +
>  	if (!rdev->mddev) {
>  		MD_BUG();
>  		return;
>  	}
> -	bd_release_from_disk(rdev->bdev, rdev->mddev->gendisk);
> +	mddev = rdev->mddev;
> +	bd_release_from_disk(rdev->bdev, mddev->gendisk);
>  	list_del_rcu(&rdev->same_set);
>  	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
>  	rdev->mddev = NULL;
>  	sysfs_remove_link(&rdev->kobj, "block");
>  	sysfs_put(rdev->sysfs_state);
>  	rdev->sysfs_state = NULL;
> +
> +	evaluate_flush_capability(mddev);
> +
>  	/* We need to delay this, otherwise we can deadlock when
>  	 * writing to 'remove' to "dev/state".  We also need
>  	 * to delay it due to rcu usage.

