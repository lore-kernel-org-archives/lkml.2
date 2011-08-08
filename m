Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1HHSXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1HHSXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:23:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>,
        jaxboe@fusionio.com
Subject: Re: [PATCH 10/11] VFS: Cache request_queue in struct block_device
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-11-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 14:22:56 -0400
In-Reply-To: <1312259893-4548-11-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 1 Aug 2011 21:38:12 -0700")
Message-ID: <x494o1rhif3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CC'd Jens.

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> This makes it possible to get from the inode to the request_queue
> with one less cache miss. Used in followon optimization.
>
> The livetime of the pointer is the same as the gendisk.
>
> This assumes that the queue will always stay the same in the
> gendisk while it's visible to block_devices. I think that's safe correct?
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  fs/block_dev.c     |    3 +++
>  include/linux/fs.h |    2 ++
>  2 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index f55aad4..5e07536 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1110,6 +1110,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  	mutex_lock_nested(&bdev->bd_mutex, for_part);
>  	if (!bdev->bd_openers) {
>  		bdev->bd_disk = disk;
> +		bdev->bd_queue = disk->queue;
>  		bdev->bd_contains = bdev;
>  		if (!partno) {
>  			struct backing_dev_info *bdi;
> @@ -1130,6 +1131,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  					disk_put_part(bdev->bd_part);
>  					bdev->bd_part = NULL;
>  					bdev->bd_disk = NULL;
> +					bdev->bd_queue = NULL;
>  					mutex_unlock(&bdev->bd_mutex);
>  					disk_unblock_events(disk);
>  					module_put(disk->fops->owner);
> @@ -1203,6 +1205,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  	disk_put_part(bdev->bd_part);
>  	bdev->bd_disk = NULL;
>  	bdev->bd_part = NULL;
> +	bdev->bd_queue = NULL;
>  	bdev_inode_switch_bdi(bdev->bd_inode, &default_backing_dev_info);
>  	if (bdev != bdev->bd_contains)
>  		__blkdev_put(bdev->bd_contains, mode, 1);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f23bcb7..ea5cb4d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -657,6 +657,7 @@ struct address_space {
>  	 * must be enforced here for CRIS, to let the least significant bit
>  	 * of struct page's "mapping" pointer be used for PAGE_MAPPING_ANON.
>  	 */
> +struct request_queue;
>  
>  struct block_device {
>  	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
> @@ -679,6 +680,7 @@ struct block_device {
>  	unsigned		bd_part_count;
>  	int			bd_invalidated;
>  	struct gendisk *	bd_disk;
> +	struct request_queue *  bd_queue;
>  	struct list_head	bd_list;
>  	/*
>  	 * Private data.  You must have bd_claim'ed the block_device
