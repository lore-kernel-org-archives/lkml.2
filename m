Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0GDHax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 03:30:53 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54358 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0GDHaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 03:30:52 -0400
Date: Sun, 4 Jul 2010 09:30:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/6] block: push down BKL into .locked_ioctl
Message-ID: <20100704073050.GA31823@merkur.ravnborg.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278193640-24223-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 8a549db..1f70aec 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -57,6 +57,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/miscdevice.h>
>  #include <linux/freezer.h>
> +#include <linux/smp_lock.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -2762,10 +2763,12 @@ out_mem:
>  static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd, unsigned long arg)
>  {
>  	struct pktcdvd_device *pd = bdev->bd_disk->private_data;
> +	int ret;
>  
>  	VPRINTK("pkt_ioctl: cmd %x, dev %d:%d\n", cmd,
>  		MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
>  
> +	lock_kernel();
>  	switch (cmd) {
>  	case CDROMEJECT:
>  		/*
> @@ -2783,12 +2786,14 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
>  	case CDROM_LAST_WRITTEN:
>  	case CDROM_SEND_PACKET:
>  	case SCSI_IOCTL_SEND_COMMAND:
> -		return __blkdev_driver_ioctl(pd->bdev, mode, cmd, arg);
> +		ret = __blkdev_driver_ioctl(pd->bdev, mode, cmd, arg);
> +		break;
>  
>  	default:
>  		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
> -		return -ENOTTY;
> +		ret = -ENOTTY;
>  	}
> +	unlock_kernel();
>  
>  	return 0;
>  }
You are loosing the return result here in the two error situations above.
Initialise ret to 0 and return ret seems the easy way to do it.

The rest looked ok - I only looked at the patches.

	Sam
