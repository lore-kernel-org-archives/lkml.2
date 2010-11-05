Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0KETiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:38:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:54267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0KETiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:38:20 -0400
Date: Sat, 6 Nov 2010 06:37:22 +1100
From: Neil Brown <neilb@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, drbd-dev@lists.linbit.com
Subject: Re: [PATCH] block: read i_size with i_size_read()
Message-ID: <20101106063722.1170cc12@nbeee.brown>
In-Reply-To: <1288985241-3515-1-git-send-email-snitzer@redhat.com>
References: <1288985241-3515-1-git-send-email-snitzer@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Nov 2010 15:27:21 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> Convert direct reads of an inode's i_size to using i_size_read().
> 
> i_size_{read,write} use a seqcount to protect reads from accessing
> incomple writes.  Concurrent i_size_write()s require mutual exclussion
> to protect the seqcount that is used by i_size_{read,write}.  But
> i_size_read() callers do not need to use additional locking.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: drbd-dev@lists.linbit.com

MD bits
  Acked-by: NeilBrown <neilb@suse.de>

It is of course OK to read i_size when you hold the appropriate mutex,
but we don't in any of these cases.

Thanks,
NeilBrown


> ---
>  block/blk-core.c              |    4 ++--
>  block/compat_ioctl.c          |    4 ++--
>  block/ioctl.c                 |    6 +++---
>  drivers/block/drbd/drbd_int.h |    2 +-
>  drivers/md/md.c               |   18 +++++++++---------
>  5 files changed, 17 insertions(+), 17 deletions(-)
> 
> NOTE: I stopped short of fixing drbd and nbd to use revalidate_disk
> and/or i_size_write.  I also have no intention of auditing all the
> direct i_size readers/writers in fs/, maybe others will have an
> interest.
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index f0834e2..17fcb83 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1351,7 +1351,7 @@ static void handle_bad_sector(struct bio *bio)
>  			bdevname(bio->bi_bdev, b),
>  			bio->bi_rw,
>  			(unsigned long long)bio->bi_sector +
> bio_sectors(bio),
> -			(long long)(bio->bi_bdev->bd_inode->i_size
> >> 9));
> +			(long
> long)(i_size_read(bio->bi_bdev->bd_inode) >> 9)); 
>  	set_bit(BIO_EOF, &bio->bi_flags);
>  }
> @@ -1404,7 +1404,7 @@ static inline int bio_check_eod(struct bio
> *bio, unsigned int nr_sectors) return 0;
>  
>  	/* Test device or partition size, when known. */
> -	maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
> +	maxsector = i_size_read(bio->bi_bdev->bd_inode) >> 9;
>  	if (maxsector) {
>  		sector_t sector = bio->bi_sector;
>  
> diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
> index 119f07b..58c6ee5 100644
> --- a/block/compat_ioctl.c
> +++ b/block/compat_ioctl.c
> @@ -744,13 +744,13 @@ long compat_blkdev_ioctl(struct file *file,
> unsigned cmd, unsigned long arg) bdi->ra_pages = (arg * 512) /
> PAGE_CACHE_SIZE; return 0;
>  	case BLKGETSIZE:
> -		size = bdev->bd_inode->i_size;
> +		size = i_size_read(bdev->bd_inode);
>  		if ((size >> 9) > ~0UL)
>  			return -EFBIG;
>  		return compat_put_ulong(arg, size >> 9);
>  
>  	case BLKGETSIZE64_32:
> -		return compat_put_u64(arg, bdev->bd_inode->i_size);
> +		return compat_put_u64(arg,
> i_size_read(bdev->bd_inode)); 
>  	case BLKTRACESETUP32:
>  	case BLKTRACESTART: /* compatible */
> diff --git a/block/ioctl.c b/block/ioctl.c
> index d724ceb..38aa194 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -125,7 +125,7 @@ static int blk_ioctl_discard(struct block_device
> *bdev, uint64_t start, start >>= 9;
>  	len >>= 9;
>  
> -	if (start + len > (bdev->bd_inode->i_size >> 9))
> +	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
>  		return -EINVAL;
>  	if (secure)
>  		flags |= BLKDEV_DISCARD_SECURE;
> @@ -307,12 +307,12 @@ int blkdev_ioctl(struct block_device *bdev,
> fmode_t mode, unsigned cmd, ret = blkdev_reread_part(bdev);
>  		break;
>  	case BLKGETSIZE:
> -		size = bdev->bd_inode->i_size;
> +		size = i_size_read(bdev->bd_inode);
>  		if ((size >> 9) > ~0UL)
>  			return -EFBIG;
>  		return put_ulong(arg, size >> 9);
>  	case BLKGETSIZE64:
> -		return put_u64(arg, bdev->bd_inode->i_size);
> +		return put_u64(arg, i_size_read(bdev->bd_inode));
>  	case BLKTRACESTART:
>  	case BLKTRACESTOP:
>  	case BLKTRACESETUP:
> diff --git a/drivers/block/drbd/drbd_int.h
> b/drivers/block/drbd/drbd_int.h index 9bdcf43..2637f49 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -1874,7 +1874,7 @@ static inline sector_t
> drbd_md_last_sector(struct drbd_backing_dev *bdev) static inline
> sector_t drbd_get_capacity(struct block_device *bdev) {
>  	/* return bdev ? get_capacity(bdev->bd_disk) : 0; */
> -	return bdev ? bdev->bd_inode->i_size >> 9 : 0;
> +	return bdev ? i_size_read(bdev->bd_inode) >> 9 : 0;
>  }
>  
>  /**
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4e957f3..02607b1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -706,7 +706,7 @@ static struct mdk_personality *find_pers(int
> level, char *clevel) /* return the offset of the super block in
> 512byte sectors */ static inline sector_t calc_dev_sboffset(struct
> block_device *bdev) {
> -	sector_t num_sectors = bdev->bd_inode->i_size / 512;
> +	sector_t num_sectors = i_size_read(bdev->bd_inode) / 512;
>  	return MD_NEW_SIZE_SECTORS(num_sectors);
>  }
>  
> @@ -1386,7 +1386,7 @@ static int super_1_load(mdk_rdev_t *rdev,
> mdk_rdev_t *refdev, int minor_version) */
>  	switch(minor_version) {
>  	case 0:
> -		sb_start = rdev->bdev->bd_inode->i_size >> 9;
> +		sb_start = i_size_read(rdev->bdev->bd_inode) >> 9;
>  		sb_start -= 8*2;
>  		sb_start &= ~(sector_t)(4*2-1);
>  		break;
> @@ -1472,7 +1472,7 @@ static int super_1_load(mdk_rdev_t *rdev,
> mdk_rdev_t *refdev, int minor_version) ret = 0;
>  	}
>  	if (minor_version)
> -		rdev->sectors = (rdev->bdev->bd_inode->i_size >> 9) -
> +		rdev->sectors = (i_size_read(rdev->bdev->bd_inode)
> >> 9) - le64_to_cpu(sb->data_offset);
>  	else
>  		rdev->sectors = rdev->sb_start;
> @@ -1680,7 +1680,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev,
> sector_t num_sectors) return 0; /* component must fit device */
>  	if (rdev->sb_start < rdev->data_offset) {
>  		/* minor versions 1 and 2; superblock before data */
> -		max_sectors = rdev->bdev->bd_inode->i_size >> 9;
> +		max_sectors = i_size_read(rdev->bdev->bd_inode) >> 9;
>  		max_sectors -= rdev->data_offset;
>  		if (!num_sectors || num_sectors > max_sectors)
>  			num_sectors = max_sectors;
> @@ -1690,7 +1690,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev,
> sector_t num_sectors) } else {
>  		/* minor version 0; superblock after data */
>  		sector_t sb_start;
> -		sb_start = (rdev->bdev->bd_inode->i_size >> 9) - 8*2;
> +		sb_start = (i_size_read(rdev->bdev->bd_inode) >> 9)
> - 8*2; sb_start &= ~(sector_t)(4*2 - 1);
>  		max_sectors = rdev->sectors + sb_start -
> rdev->sb_start; if (!num_sectors || num_sectors > max_sectors)
> @@ -2584,7 +2584,7 @@ rdev_size_store(mdk_rdev_t *rdev, const char
> *buf, size_t len) if (!sectors)
>  				return -EBUSY;
>  		} else if (!sectors)
> -			sectors = (rdev->bdev->bd_inode->i_size >>
> 9) -
> +			sectors = (i_size_read(rdev->bdev->bd_inode)
> >> 9) - rdev->data_offset;
>  	}
>  	if (sectors < my_mddev->dev_sectors)
> @@ -2797,7 +2797,7 @@ static mdk_rdev_t *md_import_device(dev_t
> newdev, int super_format, int super_mi 
>  	kobject_init(&rdev->kobj, &rdev_ktype);
>  
> -	size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
> +	size = i_size_read(rdev->bdev->bd_inode) >> BLOCK_SIZE_BITS;
>  	if (!size) {
>  		printk(KERN_WARNING 
>  			"md: %s has zero or unknown size, marking
> faulty!\n", @@ -5235,7 +5235,7 @@ static int add_new_disk(mddev_t *
> mddev, mdu_disk_info_t *info) 
>  		if (!mddev->persistent) {
>  			printk(KERN_INFO "md: nonpersistent
> superblock ...\n");
> -			rdev->sb_start =
> rdev->bdev->bd_inode->i_size / 512;
> +			rdev->sb_start =
> i_size_read(rdev->bdev->bd_inode) / 512; } else 
>  			rdev->sb_start =
> calc_dev_sboffset(rdev->bdev); rdev->sectors = rdev->sb_start;
> @@ -5306,7 +5306,7 @@ static int hot_add_disk(mddev_t * mddev, dev_t
> dev) if (mddev->persistent)
>  		rdev->sb_start = calc_dev_sboffset(rdev->bdev);
>  	else
> -		rdev->sb_start = rdev->bdev->bd_inode->i_size / 512;
> +		rdev->sb_start = i_size_read(rdev->bdev->bd_inode) /
> 512; 
>  	rdev->sectors = rdev->sb_start;
>  

