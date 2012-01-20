Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2ATB6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:58:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2ATB6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:58:41 -0500
Date: Thu, 19 Jan 2012 20:58:39 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: ndevos@redhat.com
cc: linux-kernel@vger.kernel.org, bmr@redhat.com
Subject: Re: [PATCH] block: Invalidate the cache for a parent block-device
Message-ID: <Pine.LNX.4.64.1201192057540.17908@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This definitely doesn't belong to blkdev_issue_flush.

blkdev_issue_flush is called by filesystems each time they want to 
synchronize hardware disk cache (for example, when committing a journal).

The patch may cause serious performance regressions (each time a 
filesystem commits journal, the patch causes it to walk all buffers in the 
whole-disk device).

You should put this code into fsync_bdev (so that it is called only on 
fsync or BLKFLSBUF) and not to blkdev_issue_flush.

Mikulas

> Executing a BLKFLSBUF-ioctl on a partition flushes the caches for that
> partition but reading data through the parent device will still return
> the old cached data.
> 
> The cache for the block-device is not synced if the block-device is kept
> open (due to a mounted partition, for example). Only when all users for
> the disk have exited, the cache for the disk is made consistent again.
> 
> Calling invalidate_bdev() on the parent block-device in case
> blkdev_issue_flush() was called for a partition fixes this.
> 
> The problem can be worked around by forcing the caches to be flushed
> with either
>         # blockdev --flushbufs ${dev_disk}
> or
>         # echo 3 > /proc/sys/vm/drop_caches
> 
> CC: Bryn M. Reeves <bmr <at> redhat.com>
> Signed-off-by: Niels de Vos <ndevos <at> redhat.com>
> ---
>  block/blk-flush.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 720ad60..e876f8e 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -448,6 +448,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_
> 
>         if (!bio_flagged(bio, BIO_UPTODATE))
>                 ret = -EIO;
> +       else if (bdev != bdev->bd_contains)
> +               /* invalidate parent block_device */
> +               invalidate_bdev(bdev->bd_contains);
> 
>         bio_put(bio);
>         return ret;
> --
> 1.7.6.5
> 
