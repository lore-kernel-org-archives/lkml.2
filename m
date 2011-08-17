Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1HQNNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:13:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1HQNNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:13:43 -0400
Date: Wed, 17 Aug 2011 15:13:31 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Lukas Czerner <lczerner@redhat.com>
cc: linux-kernel@vger.kernel.org, achender@linux.vnet.ibm.com,
        Jens Axboe <jaxboe@fusionio.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] loop: add discard support for loop devices
In-Reply-To: <1313063143-14473-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1108171511070.3699@dhcp-27-109.brq.redhat.com>
References: <1313063143-14473-1-git-send-email-lczerner@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011, Lukas Czerner wrote:

> This commit adds discard support for loop devices. Discard is usually
> supported by SSD and thinly provisioned devices as a method for
> reclaiming unused space. This is no different than trying to reclaim
> back space which is not used by the file system on the image, but it
> still occupies space on the host file system.
> 
> We can do the reclamation on file system which does support hole
> punching. So when discard request gets to the loop driver we can
> translate that to punch a hole to the underlying file, hence reclaim
> the free space.
> 
> This is very useful for trimming down the size of the image to only what
> is really used by the file system on that image. Fstrim may be used for
> that purpose.
> 
> It has been tested on ext4, xfs and btrfs with the image file systems
> ext4, ext3, xfs and btrfs. ext4, or ext6 image on ext4 file system has
> some problems but it seems that ext4 punch hole implementation is
> somewhat flawed and it is unrelated to this commit.
> 
> Also this is a very good method of validating file systems punch hole
> implementation.
> 
> Note that when encryption is used, discard support is disabled, because
> using it might leak some information useful for possible attacker.

Adding linux-fsdevel@vger.kernel.org cc.

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> CC: Jens Axboe <jaxboe@fusionio.com>
> ---
>  drivers/block/loop.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 54 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 76c8da7..a6d6873 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -75,6 +75,7 @@
>  #include <linux/kthread.h>
>  #include <linux/splice.h>
>  #include <linux/sysfs.h>
> +#include <linux/falloc.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -484,6 +485,29 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
>  			}
>  		}
>  
> +		/*
> +		 * We use punch hole to reclaim the free space used by the
> +		 * image a.k.a. discard. However we do support discard if
> +		 * encryption is enabled, because it may give an attacker
> +		 * useful information.
> +		 */
> +		if (bio->bi_rw & REQ_DISCARD) {
> +			struct file *file = lo->lo_backing_file;
> +			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
> +
> +			if ((!file->f_op->fallocate) ||
> +			    lo->lo_encrypt_key_size) {
> +				ret = -EOPNOTSUPP;
> +				goto out;
> +			}
> +			ret = file->f_op->fallocate(file, mode, pos,
> +						    bio->bi_size);
> +			if (unlikely(ret && ret != -EINVAL &&
> +				     ret != -EOPNOTSUPP))
> +				ret = -EIO;
> +			goto out;
> +		}
> +
>  		ret = lo_send(lo, bio, pos);
>  
>  		if ((bio->bi_rw & REQ_FUA) && !ret) {
> @@ -814,6 +838,35 @@ static void loop_sysfs_exit(struct loop_device *lo)
>  			   &loop_attribute_group);
>  }
>  
> +static void loop_config_discard(struct loop_device *lo)
> +{
> +	struct file *file = lo->lo_backing_file;
> +	struct inode *inode = file->f_mapping->host;
> +	struct request_queue *q = lo->lo_queue;
> +
> +	/*
> +	 * We use punch hole to reclaim the free space used by the
> +	 * image a.k.a. discard. However we do support discard if
> +	 * encryption is enabled, because it may give an attacker
> +	 * useful information.
> +	 */
> +	if ((!file->f_op->fallocate) ||
> +	    lo->lo_encrypt_key_size) {
> +		q->limits.discard_granularity = 0;
> +		q->limits.discard_alignment = 0;
> +		q->limits.max_discard_sectors = 0;
> +		q->limits.discard_zeroes_data = 0;
> +		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
> +		return;
> +	}
> +
> +	q->limits.discard_granularity = inode->i_sb->s_blocksize;
> +	q->limits.discard_alignment = inode->i_sb->s_blocksize;
> +	q->limits.max_discard_sectors = UINT_MAX >> 9;
> +	q->limits.discard_zeroes_data = 1;
> +	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
> +}
> +
>  static int loop_set_fd(struct loop_device *lo, fmode_t mode,
>  		       struct block_device *bdev, unsigned int arg)
>  {
> @@ -1113,6 +1166,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
>  		       info->lo_encrypt_key_size);
>  		lo->lo_key_owner = uid;
>  	}	
> +	loop_config_discard(lo);
>  
>  	return 0;
>  }
> 

-- 
