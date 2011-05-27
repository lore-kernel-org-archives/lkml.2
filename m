Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1E0QU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:20:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1E0QUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=KALaWVCkuWPgRf3iewqMbpP55+2Pc7lf/K9+wzxX6/cddxYPD3vHb6vc9ol0OOxMNJ
         hbUZadkXZ7EPSsU1FDoQ==
Date: Fri, 27 May 2011 09:20:13 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, snitzer@redhat.com, msb@chromium.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH 3/3] block: Move discard and secure discard flags to
 queue limits
Message-ID: <20110527162013.GR11023@google.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
 <1306464169-4291-4-git-send-email-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306464169-4291-4-git-send-email-martin.petersen@oracle.com>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen (martin.petersen@oracle.com) wrote:
> Whether a device supports discard is currently stored two places:
> max_discard_sectors in the queue limits and the discard request_queue
> flag. Deprecate the queue flag and always use the topology.
> 
> Also move the secure discard flag to the queue limits so it can be
> stacked as well.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/blk-settings.c      |    3 +++
>  drivers/block/brd.c       |    1 -
>  drivers/md/dm-table.c     |    5 -----
>  drivers/mmc/card/queue.c  |    4 +---
>  drivers/mtd/mtd_blkdevs.c |    4 +---
>  drivers/scsi/sd.c         |    3 +--
>  include/linux/blkdev.h    |   21 +++++++++++++--------
>  7 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index f95760d..feb3e40 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -118,6 +118,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->discard_alignment = 0;
>  	lim->discard_misaligned = 0;
>  	lim->discard_zeroes_data = 0;
> +	lim->discard_secure = 0;
>  	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
>  	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
>  	lim->alignment_offset = 0;
> @@ -144,6 +145,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>  	lim->max_hw_sectors = INT_MAX;
>  	lim->max_sectors = BLK_DEF_MAX_SECTORS;
>  	lim->discard_zeroes_data = 1;
> +	lim->discard_secure = 1;
>  	lim->non_rotational = 1;
>  }
>  EXPORT_SYMBOL(blk_set_stacking_limits);
> @@ -570,6 +572,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  
>  	t->cluster &= b->cluster;
>  	t->discard_zeroes_data &= b->discard_zeroes_data;
> +	t->discard_secure &= b->discard_secure;
>  	t->non_rotational &= b->non_rotational;
>  
>  	/* Physical block size a multiple of the logical block size? */
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index b7f51e4..3ade4e1 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -489,7 +489,6 @@ static struct brd_device *brd_alloc(int i)
>  	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
>  	brd->brd_queue->limits.max_discard_sectors = UINT_MAX;
>  	brd->brd_queue->limits.discard_zeroes_data = 1;
> -	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
>  
>  	disk = brd->brd_disk = alloc_disk(1 << part_shift);
>  	if (!disk)
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 35792bf..b5c6a1b 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1185,11 +1185,6 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	 */
>  	q->limits = *limits;
>  
> -	if (!dm_table_supports_discards(t))

You've removed the only caller of dm_table_supports_discards here.
So you should be able to remove it also.

> -		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
> -	else
> -		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
> -
>  	dm_table_set_integrity(t);
>  
>  	/*
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index 9adce86..b5c11a0 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -129,7 +129,6 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
>  	blk_queue_prep_rq(mq->queue, mmc_prep_request);
>  	blk_queue_non_rotational(mq->queue);
>  	if (mmc_can_erase(card)) {
> -		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mq->queue);
>  		mq->queue->limits.max_discard_sectors = UINT_MAX;
>  		if (card->erased_byte == 0)
>  			mq->queue->limits.discard_zeroes_data = 1;
> @@ -140,8 +139,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
>  							card->erase_size << 9;
>  		}
>  		if (mmc_can_secure_erase_trim(card))
> -			queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD,
> -						mq->queue);
> +			mq->queue->limits.discard_secure = 1;
>  	}
>  
>  #ifdef CONFIG_MMC_BLOCK_BOUNCE
> diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
> index a534e1f..5315163 100644
> --- a/drivers/mtd/mtd_blkdevs.c
> +++ b/drivers/mtd/mtd_blkdevs.c
> @@ -408,10 +408,8 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
>  	new->rq->queuedata = new;
>  	blk_queue_logical_block_size(new->rq, tr->blksize);
>  
> -	if (tr->discard) {
> -		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, new->rq);
> +	if (tr->discard)
>  		new->rq->limits.max_discard_sectors = UINT_MAX;
> -	}
>  
>  	gd->queue = new->rq;
>  
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7a5cf28..c958ac5 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -499,7 +499,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
>  
>  	case SD_LBP_DISABLE:
>  		q->limits.max_discard_sectors = 0;
> -		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
> +		max_blocks = 0;
>  		return;
>  
>  	case SD_LBP_UNMAP:
> @@ -521,7 +521,6 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
>  	}
>  
>  	q->limits.max_discard_sectors = max_blocks * (logical_block_size >> 9);
> -	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
>  
>  	sdkp->provisioning_mode = mode;
>  }
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 52a3f4c..42a374f 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -258,7 +258,7 @@ struct queue_limits {
>  	unsigned char		discard_misaligned;
>  	unsigned char		cluster;
>  	unsigned char		discard_zeroes_data;
> -
> +	unsigned char		discard_secure;
>  	unsigned char		non_rotational;
>  };
>  
> @@ -399,10 +399,8 @@ struct request_queue
>  #define QUEUE_FLAG_FAIL_IO     10	/* fake timeout */
>  #define QUEUE_FLAG_STACKABLE   11	/* supports request stacking */
>  #define QUEUE_FLAG_IO_STAT     12	/* do IO stats */
> -#define QUEUE_FLAG_DISCARD     13	/* supports DISCARD */
> -#define QUEUE_FLAG_NOXMERGES   14	/* No extended merges */
> -#define QUEUE_FLAG_ADD_RANDOM  15	/* Contributes to random pool */
> -#define QUEUE_FLAG_SECDISCARD  16	/* supports SECDISCARD */
> +#define QUEUE_FLAG_NOXMERGES   13	/* No extended merges */
> +#define QUEUE_FLAG_ADD_RANDOM  14	/* Contributes to random pool */
>  
>  #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>  				 (1 << QUEUE_FLAG_STACKABLE)	|	\
> @@ -483,9 +481,6 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
>  #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
>  #define blk_queue_stackable(q)	\
>  	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
> -#define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
> -#define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
> -	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
>  
>  #define blk_noretry_request(rq) \
>  	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
> @@ -1033,6 +1028,16 @@ static inline unsigned int blk_queue_nonrot(struct request_queue *q)
>  	return q->limits.non_rotational;
>  }
>  
> +static inline unsigned int blk_queue_discard(struct request_queue *q)
> +{
> +	return !!q->limits.max_discard_sectors;
> +}
> +
> +static inline unsigned int blk_queue_secdiscard(struct request_queue *q)
> +{
> +	return q->limits.discard_secure;
> +}
> +
>  static inline int queue_alignment_offset(struct request_queue *q)
>  {
>  	if (q->limits.misaligned)
> -- 
> 1.7.4.4
> 
