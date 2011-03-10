Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1CJAPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:15:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:48269 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1CJAPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:15:42 -0500
Subject: Re: [PATCH 09/16] swim[3]: Convert to bdops->check_events()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org, Laurent Vivier <laurent@lvivier.info>
In-Reply-To: <1299662016-7721-10-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
	 <1299662016-7721-10-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 11:10:25 +1100
Message-ID: <1299715825.22236.445.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 10:13 +0100, Tejun Heo wrote:
> Convert from ->media_changed() to ->check_events().
> 
> Both swim and swim3 buffer media changed state and clear it on
> revalidation.  They will behave correctly with kernel event polling.

No objection. I don't have HW to test at the moment but it looks obvious
enough provided you compiled tested it :

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I'll try to dig HW later.

Cheers,
Ben.
 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Laurent Vivier <laurent@lvivier.info>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  drivers/block/swim.c  |    8 +++++---
>  drivers/block/swim3.c |   11 +++++++----
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/swim.c b/drivers/block/swim.c
> index 75333d0..24a482f 100644
> --- a/drivers/block/swim.c
> +++ b/drivers/block/swim.c
> @@ -741,11 +741,12 @@ static int floppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>  	return 0;
>  }
>  
> -static int floppy_check_change(struct gendisk *disk)
> +static unsigned int floppy_check_events(struct gendisk *disk,
> +					unsigned int clearing)
>  {
>  	struct floppy_state *fs = disk->private_data;
>  
> -	return fs->ejected;
> +	return fs->ejected ? DISK_EVENT_MEDIA_CHANGE : 0;
>  }
>  
>  static int floppy_revalidate(struct gendisk *disk)
> @@ -772,7 +773,7 @@ static const struct block_device_operations floppy_fops = {
>  	.release	 = floppy_release,
>  	.ioctl		 = floppy_ioctl,
>  	.getgeo		 = floppy_getgeo,
> -	.media_changed	 = floppy_check_change,
> +	.check_events	 = floppy_check_events,
>  	.revalidate_disk = floppy_revalidate,
>  };
>  
> @@ -857,6 +858,7 @@ static int __devinit swim_floppy_init(struct swim_priv *swd)
>  		swd->unit[drive].disk->first_minor = drive;
>  		sprintf(swd->unit[drive].disk->disk_name, "fd%d", drive);
>  		swd->unit[drive].disk->fops = &floppy_fops;
> +		swd->unit[drive].disk->events = DISK_EVENT_MEDIA_CHANGE;
>  		swd->unit[drive].disk->private_data = &swd->unit[drive];
>  		swd->unit[drive].disk->queue = swd->queue;
>  		set_capacity(swd->unit[drive].disk, 2880);
> diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
> index bf3a5b8..4c10f56 100644
> --- a/drivers/block/swim3.c
> +++ b/drivers/block/swim3.c
> @@ -250,7 +250,8 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
>  			unsigned int cmd, unsigned long param);
>  static int floppy_open(struct block_device *bdev, fmode_t mode);
>  static int floppy_release(struct gendisk *disk, fmode_t mode);
> -static int floppy_check_change(struct gendisk *disk);
> +static unsigned int floppy_check_events(struct gendisk *disk,
> +					unsigned int clearing);
>  static int floppy_revalidate(struct gendisk *disk);
>  
>  static bool swim3_end_request(int err, unsigned int nr_bytes)
> @@ -975,10 +976,11 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
>  	return 0;
>  }
>  
> -static int floppy_check_change(struct gendisk *disk)
> +static unsigned int floppy_check_events(struct gendisk *disk,
> +					unsigned int clearing)
>  {
>  	struct floppy_state *fs = disk->private_data;
> -	return fs->ejected;
> +	return fs->ejected ? DISK_EVENT_MEDIA_CHANGE : 0;
>  }
>  
>  static int floppy_revalidate(struct gendisk *disk)
> @@ -1025,7 +1027,7 @@ static const struct block_device_operations floppy_fops = {
>  	.open		= floppy_unlocked_open,
>  	.release	= floppy_release,
>  	.ioctl		= floppy_ioctl,
> -	.media_changed	= floppy_check_change,
> +	.check_events	= floppy_check_events,
>  	.revalidate_disk= floppy_revalidate,
>  };
>  
> @@ -1161,6 +1163,7 @@ static int __devinit swim3_attach(struct macio_dev *mdev, const struct of_device
>  	disk->major = FLOPPY_MAJOR;
>  	disk->first_minor = i;
>  	disk->fops = &floppy_fops;
> +	disk->events = DISK_EVENT_MEDIA_CHANGE;
>  	disk->private_data = &floppy_states[i];
>  	disk->queue = swim3_queue;
>  	disk->flags |= GENHD_FL_REMOVABLE;


