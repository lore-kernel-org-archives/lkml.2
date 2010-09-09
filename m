Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0IIHzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:55:25 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40869 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0IIHzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:55:21 -0400
Message-ID: <4C8892D0.4070303@nokia.com>
Date: Thu, 09 Sep 2010 10:54:56 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Olof Johansson <olof@lixom.net>, Kay Sievers <kay.sievers@vrfy.org>,
        Lei Wen <adrian.wenl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mandeep Baines <msb@chromium.org>
Subject: Re: [PATCH] mmc_block: Allow more than 8 partitions per card
References: <AANLkTinUNpWsu=AY+1EeG8xznPaESL8XnjGo7613yoMt@mail.gmail.com> <1283964637-28246-1-git-send-email-ccross@android.com>
In-Reply-To: <1283964637-28246-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2010 07:54:56.0840 (UTC) FILETIME=[4B8DF480:01CB4FF4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Colin Cross wrote:
> Set the GENHD_FL_EXT_DEVT flag, which will allocate minor numbers
> in major 259 for partitions past disk->minors.
> 
> Also remove the use of disk_devt to determine devidx from md->disk.
> md->disk->first_minor is always initialized from devidx and can
> always be used to recover it.

Yeah, but it is a bit weird.  It seems to me that devidx should just
be a member of struct mmc_blk_data.

Doesn't look like devidx is cleared in all the error paths out of
mmc_blk_alloc() either, if you want something else to do ;-)

> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/mmc/card/block.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index d545f79..07d8eb0 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -87,11 +87,7 @@ static void mmc_blk_put(struct mmc_blk_data *md)
>  	mutex_lock(&open_lock);
>  	md->usage--;
>  	if (md->usage == 0) {
> -		int devmaj = MAJOR(disk_devt(md->disk));
> -		int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
> -
> -		if (!devmaj)
> -			devidx = md->disk->first_minor >> MMC_SHIFT;
> +		int devidx = md->disk->first_minor >> MMC_SHIFT;
>  
>  		blk_cleanup_queue(md->queue.queue);
>  
> @@ -607,6 +603,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
>  	md->disk->private_data = md;
>  	md->disk->queue = md->queue.queue;
>  	md->disk->driverfs_dev = &card->dev;
> +	md->disk->flags = GENHD_FL_EXT_DEVT;
>  
>  	/*
>  	 * As discussed on lkml, GENHD_FL_REMOVABLE should:

