Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0EOSs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 14:48:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58766 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0EOSs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 14:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=N0kih0Z+3GzNgeW3Jtz/SC16WOtKP3zEYb6JgdmKtWYam8hkyLBa+qrvglnj0ww1sy
         9Mhv7EM6LT+0NlU9NzNbSjyFCLe5dna2Io6+p8IJ+1IqFaPXwgNGdlSCt2oNCfSPVQos
         y8Pu4uf/wzOGULtpsV8Ih6ZNn6hUJcouIfmDM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/8] block,ide: simplify bdops->set_capacity() to ->unlock_native_capacity()
Date: Sat, 15 May 2010 20:48:00 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net
References: <1273946974-29131-1-git-send-email-tj@kernel.org> <1273946974-29131-4-git-send-email-tj@kernel.org>
In-Reply-To: <1273946974-29131-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Message-Id: <201005152048.00259.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tejun,

On Saturday 15 May 2010 08:09:29 pm Tejun Heo wrote:
> bdops->set_capacity() is unnecessarily generic.  All that's required
> is a simple one way notification to lower level driver telling it to
> try to unlock native capacity.  There's no reason to pass in target
> capacity or return the new capacity.  The former is always the

This seems to rely on an optimistic assumption that command execution
will always be successful and that no errors on disk or host level can
ever happen..

[ The assumption in question was introduced in the previous patch:

@@ -605,14 +604,11 @@ try_scan:
                        if (bdops->set_capacity &&
                            (disk->flags & GENHD_FL_NATIVE_CAPACITY) == 0) {
                                printk(KERN_CONT "enabling native capacity\n");
-                               capacity = bdops->set_capacity(disk, ~0ULL);
+                               bdops->set_capacity(disk, ~0ULL);
                                disk->flags |= GENHD_FL_NATIVE_CAPACITY;
-                               if (capacity > get_capacity(disk)) {
-                                       set_capacity(disk, capacity);
-                                       check_disk_size_change(disk, bdev);
-                                       bdev->bd_invalidated = 0;
-                               }
-                               goto try_scan;
+                               /* free state and restart */
+                               kfree(state);
+                               goto rescan;

originally if the command execution failed the 'capacity' would be 0 ]

It also seems that the original code could be improved a lot to handle
(very unlikely but not impossible) error situations better..

> inherent native capacity and the latter can be handled via the usual
> device resize / revalidation path.  In fact, the current API is always
> used that way.
> 
> Replace ->set_capacity() with ->unlock_native_capacity() which take
> only @disk and doesn't return anything.  IDE which is the only current
> user of the API is converted accordingly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-disk.c |   40 ++++++++++++++++------------------------
>  drivers/ide/ide-gd.c   |   11 ++++-------
>  fs/partitions/check.c  |    4 ++--
>  include/linux/blkdev.h |    3 +--
>  include/linux/ide.h    |    2 +-
>  5 files changed, 24 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
> index 3b128dc..33d6503 100644
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -407,32 +407,24 @@ static int ide_disk_get_capacity(ide_drive_t *drive)
>  	return 0;
>  }
>  
> -static u64 ide_disk_set_capacity(ide_drive_t *drive, u64 capacity)
> +static void ide_disk_unlock_native_capacity(ide_drive_t *drive)
>  {
> -	u64 set = min(capacity, drive->probed_capacity);
>  	u16 *id = drive->id;
>  	int lba48 = ata_id_lba48_enabled(id);
>  
>  	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 ||
>  	    ata_id_hpa_enabled(id) == 0)
> -		goto out;
> +		return;
>  
>  	/*
>  	 * according to the spec the SET MAX ADDRESS command shall be
>  	 * immediately preceded by a READ NATIVE MAX ADDRESS command
>  	 */
> -	capacity = ide_disk_hpa_get_native_capacity(drive, lba48);
> -	if (capacity == 0)
> -		goto out;
> -
> -	set = ide_disk_hpa_set_capacity(drive, set, lba48);
> -	if (set) {
> -		/* needed for ->resume to disable HPA */
> -		drive->dev_flags |= IDE_DFLAG_NOHPA;
> -		return set;
> -	}
> -out:
> -	return drive->capacity64;
> +	if (!ide_disk_hpa_get_native_capacity(drive, lba48))
> +		return;
> +
> +	if (ide_disk_hpa_set_capacity(drive, drive->probed_capacity, lba48))
> +		drive->dev_flags |= IDE_DFLAG_NOHPA; /* disable HPA on resume */
>  }
>  
>  static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
> @@ -783,13 +775,13 @@ static int ide_disk_set_doorlock(ide_drive_t *drive, struct gendisk *disk,
>  }
>  
>  const struct ide_disk_ops ide_ata_disk_ops = {
> -	.check		= ide_disk_check,
> -	.set_capacity	= ide_disk_set_capacity,
> -	.get_capacity	= ide_disk_get_capacity,
> -	.setup		= ide_disk_setup,
> -	.flush		= ide_disk_flush,
> -	.init_media	= ide_disk_init_media,
> -	.set_doorlock	= ide_disk_set_doorlock,
> -	.do_request	= ide_do_rw_disk,
> -	.ioctl		= ide_disk_ioctl,
> +	.check			= ide_disk_check,
> +	.unlock_native_capacity	= ide_disk_unlock_native_capacity,
> +	.get_capacity		= ide_disk_get_capacity,
> +	.setup			= ide_disk_setup,
> +	.flush			= ide_disk_flush,
> +	.init_media		= ide_disk_init_media,
> +	.set_doorlock		= ide_disk_set_doorlock,
> +	.do_request		= ide_do_rw_disk,
> +	.ioctl			= ide_disk_ioctl,
>  };
> diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
> index c32d839..c102d23 100644
> --- a/drivers/ide/ide-gd.c
> +++ b/drivers/ide/ide-gd.c
> @@ -288,17 +288,14 @@ static int ide_gd_media_changed(struct gendisk *disk)
>  	return ret;
>  }
>  
> -static unsigned long long ide_gd_set_capacity(struct gendisk *disk,
> -					      unsigned long long capacity)
> +static void ide_gd_unlock_native_capacity(struct gendisk *disk)
>  {
>  	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
>  	ide_drive_t *drive = idkp->drive;
>  	const struct ide_disk_ops *disk_ops = drive->disk_ops;
>  
> -	if (disk_ops->set_capacity)
> -		return disk_ops->set_capacity(drive, capacity);
> -
> -	return drive->capacity64;
> +	if (disk_ops->unlock_native_capacity)
> +		disk_ops->unlock_native_capacity(drive);
>  }
>  
>  static int ide_gd_revalidate_disk(struct gendisk *disk)
> @@ -329,7 +326,7 @@ static const struct block_device_operations ide_gd_ops = {
>  	.locked_ioctl		= ide_gd_ioctl,
>  	.getgeo			= ide_gd_getgeo,
>  	.media_changed		= ide_gd_media_changed,
> -	.set_capacity		= ide_gd_set_capacity,
> +	.unlock_native_capacity	= ide_gd_unlock_native_capacity,
>  	.revalidate_disk	= ide_gd_revalidate_disk
>  };
>  
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index 8f01df3..4f1fee0 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -601,10 +601,10 @@ rescan:
>  			       "%s: p%d size %llu exceeds device capacity, ",
>  			       disk->disk_name, p, (unsigned long long) size);
>  
> -			if (bdops->set_capacity &&
> +			if (bdops->unlock_native_capacity &&
>  			    (disk->flags & GENHD_FL_NATIVE_CAPACITY) == 0) {
>  				printk(KERN_CONT "enabling native capacity\n");
> -				bdops->set_capacity(disk, ~0ULL);
> +				bdops->unlock_native_capacity(disk);
>  				disk->flags |= GENHD_FL_NATIVE_CAPACITY;
>  				/* free state and restart */
>  				kfree(state);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 6690e8b..f2a0c33 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1283,8 +1283,7 @@ struct block_device_operations {
>  	int (*direct_access) (struct block_device *, sector_t,
>  						void **, unsigned long *);
>  	int (*media_changed) (struct gendisk *);
> -	unsigned long long (*set_capacity) (struct gendisk *,
> -						unsigned long long);
> +	void (*unlock_native_capacity) (struct gendisk *);
>  	int (*revalidate_disk) (struct gendisk *);
>  	int (*getgeo)(struct block_device *, struct hd_geometry *);
>  	struct module *owner;
> diff --git a/include/linux/ide.h b/include/linux/ide.h
> index 3239d1c..b6d4480 100644
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -362,7 +362,7 @@ struct ide_drive_s;
>  struct ide_disk_ops {
>  	int		(*check)(struct ide_drive_s *, const char *);
>  	int		(*get_capacity)(struct ide_drive_s *);
> -	u64		(*set_capacity)(struct ide_drive_s *, u64);
> +	void		(*unlock_native_capacity)(struct ide_drive_s *);
>  	void		(*setup)(struct ide_drive_s *);
>  	void		(*flush)(struct ide_drive_s *);
>  	int		(*init_media)(struct ide_drive_s *, struct gendisk *);
