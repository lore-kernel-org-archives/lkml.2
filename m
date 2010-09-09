Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab0IICtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 22:49:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46470 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0IICtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 22:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kCgjRdkbW9m6D6NoIRZCFZiNwM7Lsw63k9FXr93aQTpIKzN1EY2E5j2H2S8i8fU52M
         OBw2LKUSWAYNhn5X8N6Ogm0ZamOeQHm0WrpsRFYf4/J/hugzVPS5dYPR/s0lIe8Wq0qX
         I3jF9hn9JDLhRHl4pT+uh6MPUa73dvAdxwj0Q=
MIME-Version: 1.0
In-Reply-To: <1283964637-28246-1-git-send-email-ccross@android.com>
References: <AANLkTinUNpWsu=AY+1EeG8xznPaESL8XnjGo7613yoMt@mail.gmail.com>
	<1283964637-28246-1-git-send-email-ccross@android.com>
Date: Thu, 9 Sep 2010 10:49:40 +0800
Message-ID: <AANLkTi=qyKCYuZ4esATV1ArBb_GrpqRW7bwdJnZnonVe@mail.gmail.com>
Subject: Re: [PATCH] mmc_block: Allow more than 8 partitions per card
From: Lei Wen <adrian.wenl@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: Olof Johansson <olof@lixom.net>, Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mandeep Baines <msb@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 12:50 AM, Colin Cross <ccross@android.com> wrote:
> Set the GENHD_FL_EXT_DEVT flag, which will allocate minor numbers
> in major 259 for partitions past disk->minors.
>
> Also remove the use of disk_devt to determine devidx from md->disk.
> md->disk->first_minor is always initialized from devidx and can
> always be used to recover it.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/mmc/card/block.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index d545f79..07d8eb0 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -87,11 +87,7 @@ static void mmc_blk_put(struct mmc_blk_data *md)
>        mutex_lock(&open_lock);
>        md->usage--;
>        if (md->usage == 0) {
> -               int devmaj = MAJOR(disk_devt(md->disk));
> -               int devidx = MINOR(disk_devt(md->disk)) >> MMC_SHIFT;
> -
> -               if (!devmaj)
> -                       devidx = md->disk->first_minor >> MMC_SHIFT;
> +               int devidx = md->disk->first_minor >> MMC_SHIFT;
>
>                blk_cleanup_queue(md->queue.queue);
>
> @@ -607,6 +603,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
>        md->disk->private_data = md;
>        md->disk->queue = md->queue.queue;
>        md->disk->driverfs_dev = &card->dev;
> +       md->disk->flags = GENHD_FL_EXT_DEVT;
>
>        /*
>         * As discussed on lkml, GENHD_FL_REMOVABLE should:
> --
> 1.7.1
>

Looks good to me.
Acked-by: Lei Wen <leiwen@marvell.com>
