Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920Ab0L2Ghs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 01:37:48 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:62494 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0L2Ghr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 01:37:47 -0500
Date: Tue, 28 Dec 2010 23:37:44 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCH 11/16] xsysace: convert to bdops->check_events()
Message-ID: <20101229063744.GB8172@angua.secretlab.ca>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
 <1293557352-10592-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293557352-10592-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 06:29:07PM +0100, Tejun Heo wrote:
> Convert from ->media_changed() to ->check_events().
> 
> xsysace buffers media changed state and clears it on revalidation.  It
> will behave correctly with kernel event polling.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

> ---
>  drivers/block/xsysace.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index 829161e..16a2fa9 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -867,12 +867,12 @@ static void ace_request(struct request_queue * q)
>  	}
>  }
>  
> -static int ace_media_changed(struct gendisk *gd)
> +static unsigned int ace_check_events(struct gendisk *gd, unsigned int clearing)
>  {
>  	struct ace_device *ace = gd->private_data;
> -	dev_dbg(ace->dev, "ace_media_changed(): %i\n", ace->media_change);
> +	dev_dbg(ace->dev, "ace_check_events(): %i\n", ace->media_change);
>  
> -	return ace->media_change;
> +	return ace->media_change ? DISK_EVENT_MEDIA_CHANGE : 0;
>  }
>  
>  static int ace_revalidate_disk(struct gendisk *gd)
> @@ -953,7 +953,7 @@ static const struct block_device_operations ace_fops = {
>  	.owner = THIS_MODULE,
>  	.open = ace_open,
>  	.release = ace_release,
> -	.media_changed = ace_media_changed,
> +	.check_events = ace_check_events,
>  	.revalidate_disk = ace_revalidate_disk,
>  	.getgeo = ace_getgeo,
>  };
> @@ -1005,6 +1005,7 @@ static int __devinit ace_setup(struct ace_device *ace)
>  	ace->gd->major = ace_major;
>  	ace->gd->first_minor = ace->id * ACE_NUM_MINORS;
>  	ace->gd->fops = &ace_fops;
> +	ace->gd->events = DISK_EVENT_MEDIA_CHANGE;
>  	ace->gd->queue = ace->queue;
>  	ace->gd->private_data = ace;
>  	snprintf(ace->gd->disk_name, 32, "xs%c", ace->id + 'a');
> -- 
> 1.7.1
> 
