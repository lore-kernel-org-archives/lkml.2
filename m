Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1HRTm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:42:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1HRTm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:42:56 -0400
Date: Thu, 18 Aug 2011 15:42:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 10/11] VFS: Cache request_queue in struct block_device
Message-ID: <20110818194245.GJ15413@redhat.com>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
 <1312259893-4548-11-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312259893-4548-11-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 09:38:12PM -0700, Andi Kleen wrote:
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

I am really not sure how good a idea it is to stash away another pointer
in bdev (bdev->queue), just because we don't want to dereference a pointer
(bdev->bd_disk->queue). 

Personally I think it is not a very good idea as if we start following
everywhere in the code, it will make things more complicated.

Is the performance gain because of this one less dereference really 
substantial.

Thanks
Vivek
