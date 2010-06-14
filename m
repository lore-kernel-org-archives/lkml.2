Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0FNJ6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:58:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33284 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0FNJ6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iurEpk3vFiizvRfeEg0loWmAvmE75AoI/UQGI7+p2WwvQn9J+ew7AjaSJnWswp3U9T
         5xsdKgH8h5ZVBtEd7Qwnq6saCqEFxJNyiqgrgUysGsS4d375GtE5tad/9AAXNgknX911
         1kwjfToidAKdxSPLZ1/Td3H6B64inf7fd+C0Y=
MIME-Version: 1.0
In-Reply-To: <4C14B5FB.1000909@nokia.com>
References: <4C14AC8D.50702@nokia.com>
	<4C14B5FB.1000909@nokia.com>
Date: Mon, 14 Jun 2010 18:58:20 +0900
X-Google-Sender-Auth: Djz58vgDN9gxFwC-xPpy7C9eWoA
Message-ID: <AANLkTin3YFhsi_2nsOKqweOIcBYeBXHuJDJsXjD1o8mS@mail.gmail.com>
Subject: Re: [PATCH V2 3/4] mmc_block: Add discard and secure discard support
From: Kyungmin Park <kmpark@infradead.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
       "hch@lst.de" <hch@lst.de>, Madhusudhan Chikkature <madhu.cr@ti.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested it and get the same result from my implementation. at current
time no performance improvement.

Thank you,
Kyungmin Park

On Sun, Jun 13, 2010 at 7:42 PM, Adrian Hunter <adrian.hunter@nokia.com> wrote:
> From a86fc83da7c3d4f9f39a267841b8cb73c30ad7ac Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Thu, 3 Jun 2010 10:47:12 +0300
> Subject: [PATCH 3/4] mmc_block: Add discard and secure discard support
>
> Enable MMC to service discard requests.  In the case of SD
> and MMC cards that do not support trim, discards become
> erases.  In the case of cards (MMC) that only allow erases
> in multiples of erase group size, round to the nearest
> completely discarded erase group.
>
> Also implement BLKSECDISCARD using MMC secure erase and
> trim operations.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
> drivers/mmc/card/block.c |  125
> +++++++++++++++++++++++++++++++++++++++++++++-
> drivers/mmc/card/queue.c |   16 +++++-
> 2 files changed, 138 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index cb9fbc8..f7129b3 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -31,6 +31,7 @@
> #include <linux/mutex.h>
> #include <linux/scatterlist.h>
> #include <linux/string_helpers.h>
> +#include <linux/delay.h>
>
> #include <linux/mmc/card.h>
> #include <linux/mmc/host.h>
> @@ -138,9 +139,91 @@ mmc_blk_getgeo(struct block_device *bdev, struct
> hd_geometry *geo)
>        return 0;
> }
>
> +static int mmc_blk_check_eod(struct block_device *bdev, unsigned int from,
> +                            unsigned int nr)
> +{
> +       unsigned int maxsector;
> +
> +       if (!nr)
> +               return 0;
> +
> +       maxsector = bdev->bd_inode->i_size >> 9;
> +       if (maxsector && (maxsector < nr || maxsector - nr < from))
> +               return 1;
> +
> +       return 0;
> +}
> +
> +static int mmc_blk_secure_erase(struct mmc_blk_data *md, unsigned int from,
> +                               unsigned int nr)
> +{
> +       struct mmc_card *card = md->queue.card;
> +       unsigned int arg;
> +       int err;
> +
> +       if (!mmc_can_secure_erase_trim(card))
> +               return -EOPNOTSUPP;
> +
> +       if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
> +               arg = MMC_SECURE_TRIM1_ARG;
> +       else
> +               arg = MMC_SECURE_ERASE_ARG;
> +
> +       mmc_claim_host(card->host);
> +       err = mmc_erase(card, from, nr, arg);
> +       if (!err && arg == MMC_SECURE_TRIM1_ARG)
> +               err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
> +       mmc_release_host(card->host);
> +
> +       return err;
> +}
> +
> +static int mmc_blk_ioctl_secdiscard(struct block_device *bdev, uint64_t
> start,
> +                                uint64_t len)
> +{
> +       struct mmc_blk_data *md = bdev->bd_disk->private_data;
> +       unsigned int from, nr;
> +
> +       if ((start & 511) || (len & 511))
> +               return -EINVAL;
> +
> +       start >>= 9;
> +       len >>= 9;
> +
> +       if (start > UINT_MAX || len > UINT_MAX)
> +               return -EINVAL;
> +
> +       from = start;
> +       nr = len;
> +
> +       if (mmc_blk_check_eod(bdev, from, nr))
> +               return -EINVAL;
> +
> +       if (bdev != bdev->bd_contains)
> +               from += bdev->bd_part->start_sect;
> +
> +       return mmc_blk_secure_erase(md, from, nr);
> +}
> +
> +static int mmc_blk_ioctl(struct block_device *bdev, fmode_t mode,
> +                        unsigned cmd, unsigned long arg)
> +{
> +       uint64_t range[2];
> +
> +       switch (cmd) {
> +       case BLKSECDISCARD:
> +               if (copy_from_user(range, (void __user *)arg,
> sizeof(range)))
> +                       return -EFAULT;
> +
> +               return mmc_blk_ioctl_secdiscard(bdev, range[0], range[1]);
> +       }
> +       return -ENOTTY;
> +}
> +
> static const struct block_device_operations mmc_bdops = {
>        .open                   = mmc_blk_open,
>        .release                = mmc_blk_release,
> +       .ioctl                  = mmc_blk_ioctl,
>        .getgeo                 = mmc_blk_getgeo,
>        .owner                  = THIS_MODULE,
> };
> @@ -242,7 +325,40 @@ static u32 get_card_status(struct mmc_card *card,
> struct request *req)
>        return cmd.resp[0];
> }
>
> -static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> +static int mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request
> *req)
> +{
> +       struct mmc_blk_data *md = mq->data;
> +       struct mmc_card *card = md->queue.card;
> +       unsigned int from, nr, arg;
> +       int err = 0;
> +
> +       mmc_claim_host(card->host);
> +
> +       if (!mmc_can_erase(card)) {
> +               err = -EOPNOTSUPP;
> +               goto out;
> +       }
> +
> +       from = blk_rq_pos(req);
> +       nr = blk_rq_sectors(req);
> +
> +       if (mmc_can_trim(card))
> +               arg = MMC_TRIM_ARG;
> +       else
> +               arg = MMC_ERASE_ARG;
> +
> +       err = mmc_erase(card, from, nr, arg);
> +out:
> +       spin_lock_irq(&md->lock);
> +       __blk_end_request(req, err, blk_rq_bytes(req));
> +       spin_unlock_irq(&md->lock);
> +
> +       mmc_release_host(card->host);
> +
> +       return err ? 0 : 1;
> +}
> +
> +static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
> {
>        struct mmc_blk_data *md = mq->data;
>        struct mmc_card *card = md->queue.card;
> @@ -470,6 +586,13 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq,
> struct request *req)
>        return 0;
> }
>
> +static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> +{
> +       if (blk_discard_rq(req))
> +               return mmc_blk_issue_discard_rq(mq, req);
> +       else
> +               return mmc_blk_issue_rw_rq(mq, req);
> +}
>
> static inline int mmc_blk_readonly(struct mmc_card *card)
> {
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index d6ded24..37f648f 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -30,9 +30,9 @@
> static int mmc_prep_request(struct request_queue *q, struct request *req)
> {
>        /*
> -        * We only like normal block requests.
> +        * We only like normal block requests and discards.
>         */
> -       if (!blk_fs_request(req)) {
> +       if (!blk_fs_request(req) && !blk_discard_rq(req)) {
>                blk_dump_rq_flags(req, "MMC bad request");
>                return BLKPREP_KILL;
>        }
> @@ -130,6 +130,18 @@ int mmc_init_queue(struct mmc_queue *mq, struct
> mmc_card *card, spinlock_t *lock
>        blk_queue_prep_rq(mq->queue, mmc_prep_request);
>        blk_queue_ordered(mq->queue, QUEUE_ORDERED_DRAIN, NULL);
>        queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
> +       if (mmc_can_erase(card)) {
> +               queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mq->queue);
> +               mq->queue->limits.max_discard_sectors = UINT_MAX;
> +               if (card->erased_byte == 0)
> +                       mq->queue->limits.discard_zeroes_data = 1;
> +               if (!mmc_can_trim(card) && is_power_of_2(card->erase_size))
> {
> +                       mq->queue->limits.discard_granularity =
> +                                                       card->erase_size <<
> 9;
> +                       mq->queue->limits.discard_alignment =
> +                                                       card->erase_size <<
> 9;
> +               }
> +       }
>
> #ifdef CONFIG_MMC_BLOCK_BOUNCE
>        if (host->max_hw_segs == 1) {
> --
> 1.6.3.3
>
>
