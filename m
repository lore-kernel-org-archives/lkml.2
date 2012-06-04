Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709Ab2FDOtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:49:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40724 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2FDOti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:49:38 -0400
MIME-Version: 1.0
In-Reply-To: <1338820911-4733-2-git-send-email-glorioustao@gmail.com>
References: <1338820911-4733-1-git-send-email-glorioustao@gmail.com> <1338820911-4733-2-git-send-email-glorioustao@gmail.com>
From: Tao Guo <glorioustao@gmail.com>
Date: Mon, 4 Jun 2012 22:49:17 +0800
Message-ID: <CAAV8rn+4_STiq0MRZWZb2Hi1_1o+PHNx2+uoymK1TSqKLbQGAg@mail.gmail.com>
Subject: Re: [PATCH 2/2] umem: fix up unplugging
To: linux-kernel@vger.kernel.org
Cc: Tao Guo <glorioustao@gmail.com>, Tao Guo <Tao.Guo@emc.com>,
        Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to fix a regression introduced by 7eaceaccab5f40
("block: remove per-queueplugging").

-Tao

On Mon, Jun 4, 2012 at 10:41 PM, Tao Guo <glorioustao@gmail.com> wrote:
> In that patch, Jens removed the whole mm_unplug_device()
> function, which used to be the trigger to make umem start to work.
>
> We need to implement unplugging to make umem start to work, or I/O
> will never be triggered.
>
> Signed-off-by: Tao Guo <Tao.Guo@emc.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: <stable@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/block/umem.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/umem.c b/drivers/block/umem.c
> index aa27120..89cc9a6 100644
> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -513,6 +513,15 @@ static void process_page(unsigned long data)
>        }
>  }
>
> +static void mm_unplug(struct blk_plug_cb *cb)
> +{
> +       struct cardinfo *card = cb->q->queuedata;
> +
> +       spin_lock_irq(&card->lock);
> +       activate(card);
> +       spin_unlock_irq(&card->lock);
> +}
> +
>  static void mm_make_request(struct request_queue *q, struct bio *bio)
>  {
>        struct cardinfo *card = q->queuedata;
> @@ -523,6 +532,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
>        *card->biotail = bio;
>        bio->bi_next = NULL;
>        card->biotail = &bio->bi_next;
> +       if (bio->bi_rw & REQ_SYNC || !blk_check_plugged(q, mm_unplug))
> +               activate(card);
>        spin_unlock_irq(&card->lock);
>
>        return;
> --
> 1.7.7.6
>
