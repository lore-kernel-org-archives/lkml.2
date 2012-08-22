Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab2HVJ2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:28:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:34564 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861Ab2HVJ2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:28:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="136766803"
Date: Wed, 22 Aug 2012 17:28:51 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] block: embed bdevname in struct block_device
Message-ID: <20120822092851.GJ2570@yliu-dev.sh.intel.com>
References: <1344854040-15334-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344854040-15334-1-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 06:33:59PM +0800, Yuanhan Liu wrote:
> Embed block device name in struct block_device, thus we can replace
> the following code:
> 	char b[BDEVNAME_SIZE];
> 	printk(KERN_XXX "...%s..\n", bdevname(bdev, b);
> 
> with a much simpler and less stack usage version:
> 	printk(KERN_XXX "...%s..\n", bdev->bd_name);
> 
> This is a RFC version, which I just included one sample with this change
> appiled. If this patch makes sense to you, I will file more patches to
> apply this change.

ping... (though it's a trivial RFC patch)


Thanks,
Yuanhan Liu
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  fs/block_dev.c     |    2 ++
>  include/linux/fs.h |    3 ++-
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 1e51919..5e796e58 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1213,6 +1213,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
>  			}
>  			bd_set_size(bdev, (loff_t)bdev->bd_part->nr_sects << 9);
>  		}
> +
> +		disk_name(bdev->bd_disk, bdev->bd_part->partno, bdev->bd_name);
>  	} else {
>  		if (bdev->bd_contains == bdev) {
>  			ret = 0;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index aa11047..98ea89d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -689,6 +689,7 @@ struct address_space {
>  	 */
>  struct request_queue;
>  
> +#define BDEVNAME_SIZE	32	/* Largest string for a blockdev identifier */
>  struct block_device {
>  	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
>  	int			bd_openers;
> @@ -724,6 +725,7 @@ struct block_device {
>  	int			bd_fsfreeze_count;
>  	/* Mutex for freeze */
>  	struct mutex		bd_fsfreeze_mutex;
> +	char 			bd_name[BDEVNAME_SIZE];
>  };
>  
>  /*
> @@ -2323,7 +2325,6 @@ static inline void unregister_chrdev(unsigned int major, const char *name)
>  }
>  
>  /* fs/block_dev.c */
> -#define BDEVNAME_SIZE	32	/* Largest string for a blockdev identifier */
>  #define BDEVT_SIZE	10	/* Largest string for MAJ:MIN for blkdev */
>  
>  #ifdef CONFIG_BLOCK
> -- 
> 1.7.7.6
