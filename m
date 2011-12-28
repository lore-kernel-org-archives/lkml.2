Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1L1Pm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 10:42:29 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60350 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1L1PmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 10:42:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6572"; a="148187448"
From: "Yaniv Gardi" <ygardi@codeaurora.org>
To: "'Kyungmin Park'" <kmpark@infradead.org>
Cc: <linux-mmc@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1324992782-1004-1-git-send-email-ygardi@codeaurora.org>	<1324992782-1004-2-git-send-email-ygardi@codeaurora.org> <CAH9JG2Uan6-EUmJo8gtGFEWUN-JKvtNnbZxYGqsXg49qEVpPtQ@mail.gmail.com>
In-Reply-To: <CAH9JG2Uan6-EUmJo8gtGFEWUN-JKvtNnbZxYGqsXg49qEVpPtQ@mail.gmail.com>
Subject: RE: [PATCH V2] mmc: card: IOCTL support for Sanitize feature of eMMC v4.5
Date: Wed, 28 Dec 2011 17:42:13 +0200
Message-ID: <000301ccc577$466a8d70$d33fa850$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AczEnxgYgW9M6/SOQ9eVFyW/ATnC9wA2BWxA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

Probably I will split this patch into 2 dependent uploads.
Thanks,
Yaniv

= > -----Original Message-----
= > From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
= > owner@vger.kernel.org] On Behalf Of Kyungmin Park
= > Sent: Tuesday, December 27, 2011 3:54 PM
= > To: Yaniv Gardi
= > Cc: linux-mmc@vger.kernel.org; linux-arm-msm@vger.kernel.org; open
= > list
= > Subject: Re: [PATCH V2] mmc: card: IOCTL support for Sanitize feature
= > of eMMC v4.5
= > 
= > Hi Yaniv,
= > 
= > You maybe split the patch into block and mmc parts.
= > Please see the comments inlined.
= > 
= > Thank you,
= > Kyungmin Park
= > 
= > On Tue, Dec 27, 2011 at 10:33 PM, Yaniv Gardi <ygardi@codeaurora.org>
= > wrote:
= > > Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
= > >
= > > ---
= > >  block/blk-core.c          |   15 ++++++++++--
= > >  block/blk-lib.c           |   44
= > +++++++++++++++++++++++++++++++++++++++
= > >  block/blk-merge.c         |    6 +++++
= > >  block/elevator.c          |    8 ++++++-
= > >  block/ioctl.c             |    9 ++++++++
= > >  drivers/mmc/card/block.c  |   50
= > ++++++++++++++++++++++++++++++++++++--------
= > >  drivers/mmc/card/queue.c  |    7 +++++-
= > >  include/linux/blk_types.h |    7 ++++-
= > >  include/linux/blkdev.h    |    3 ++
= > >  include/linux/fs.h        |    1 +
= > >  include/linux/mmc/card.h  |    7 ++++++
= > >  kernel/trace/blktrace.c   |    2 +
= > >  12 files changed, 143 insertions(+), 16 deletions(-)
= > >
= > > diff --git a/block/blk-core.c b/block/blk-core.c
= > > index e6c05a9..e3512a4 100644
= > > --- a/block/blk-core.c
= > > +++ b/block/blk-core.c
= > > @@ -1544,7 +1544,7 @@ generic_make_request_checks(struct bio *bio)
= > >                goto end_io;
= > >        }
= > >
= > > -       if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
= > > +       if (unlikely(!(bio->bi_rw & (REQ_DISCARD | REQ_SANITIZE))
= > &&
= > >                     nr_sectors > queue_max_hw_sectors(q))) {
= > >                printk(KERN_ERR "bio too big device %s (%u > %u)\n",
= > >                       bdevname(bio->bi_bdev, b),
= > > @@ -1592,6 +1592,14 @@ generic_make_request_checks(struct bio *bio)
= > >                goto end_io;
= > >        }
= > >
= > > +       if ((bio->bi_rw & REQ_SANITIZE) &&
= > > +           (!blk_queue_sanitize(q))) {
= > > +               pr_err("%s - SANITIZE request but queue "
= > > +                      "doesn't support sanitize", __func__);
= > > +               err = -EOPNOTSUPP;
= > > +               goto end_io;
= > > +       }
= > > +
= > >        if (blk_throtl_bio(q, bio))
= > >                return false;   /* throttled, will be resubmitted
= > later */
= > >
= > > @@ -1697,7 +1705,8 @@ void submit_bio(int rw, struct bio *bio)
= > >         * If it's a regular read/write or a barrier with data
= > attached,
= > >         * go through the normal accounting stuff before submission.
= > >         */
= > > -       if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
= > > +       if (bio_has_data(bio) &&
= > > +           (!(rw & (REQ_DISCARD | REQ_SANITIZE)))) {
= > >                if (rw & WRITE) {
= > >                        count_vm_events(PGPGOUT, count);
= > >                } else {
= > > @@ -1743,7 +1752,7 @@ EXPORT_SYMBOL(submit_bio);
= > >  */
= > >  int blk_rq_check_limits(struct request_queue *q, struct request
= > *rq)
= > >  {
= > > -       if (rq->cmd_flags & REQ_DISCARD)
= > > +       if ((rq->cmd_flags & REQ_DISCARD) || (rq->cmd_flags &
= > REQ_SANITIZE))
= > (rq->cmd_flags & (REQ_DISCARD | REA_SANITIZE))?
= > >                return 0;
= > >
= > >        if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
= > > diff --git a/block/blk-lib.c b/block/blk-lib.c
= > > index 2b461b4..76ed930 100644
= > > --- a/block/blk-lib.c
= > > +++ b/block/blk-lib.c
= > > @@ -114,6 +114,50 @@ int blkdev_issue_discard(struct block_device
= > *bdev, sector_t sector,
= > >  }
= > >  EXPORT_SYMBOL(blkdev_issue_discard);
= > >
= > > +int blkdev_issue_sanitize(struct block_device *bdev, gfp_t
= > gfp_mask)
= > > +{
= > > +       DECLARE_COMPLETION_ONSTACK(wait);
= > > +       struct request_queue *q = bdev_get_queue(bdev);
= > > +       int type = REQ_WRITE | REQ_SANITIZE;
= > > +
= > > +       struct bio_batch bb;
= > > +       struct bio *bio;
= > > +       int ret = 0;
= > > +
= > > +       if (!q)
= > > +               return -ENXIO;
= > > +
= > > +       bio = bio_alloc(gfp_mask, 1);
= > > +       if (!bio)
= > > +               return -ENOMEM;
= > > +
= > > +       if (!blk_queue_sanitize(q)) {
= > > +               pr_err("%s - card doesn't support sanitize",
= > __func__);
= > You should add the bio_free-like at here?
= > > +               return -EOPNOTSUPP;
= > > +       }
= > > +
= > > +       atomic_set(&bb.done, 1);
= > > +       bb.flags = 1 << BIO_UPTODATE;
= > > +       bb.wait = &wait;
= > > +
= > > +       bio->bi_end_io = bio_batch_end_io;
= > > +       bio->bi_bdev = bdev;
= > > +       bio->bi_private = &bb;
= > > +
= > > +       atomic_inc(&bb.done);
= > > +       submit_bio(type, bio);
= > > +
= > > +       /* Wait for bios in-flight */
= > > +       if (!atomic_dec_and_test(&bb.done))
= > > +               wait_for_completion(&wait);
= > > +
= > > +       if (!test_bit(BIO_UPTODATE, &bb.flags))
= > > +               ret = -EIO;
= > > +
= > > +       return ret;
= > > +}
= > > +EXPORT_SYMBOL(blkdev_issue_sanitize);
= > > +
= > >  /**
= > >  * blkdev_issue_zeroout - generate number of zero filed write bios
= > >  * @bdev:      blockdev to issue
= > > diff --git a/block/blk-merge.c b/block/blk-merge.c
= > > index cfcc37c..f3ed15b 100644
= > > --- a/block/blk-merge.c
= > > +++ b/block/blk-merge.c
= > > @@ -383,6 +383,12 @@ static int attempt_merge(struct request_queue
= > *q, struct request *req,
= > >                return 0;
= > >
= > >        /*
= > > +        * Don't merge file system requests and sanitize requests
= > > +        */
= > > +       if ((req->cmd_flags & REQ_SANITIZE) != (next->cmd_flags &
= > REQ_SANITIZE))
= > > +               return 0;
= > > +
= > > +       /*
= > >         * not contiguous
= > >         */
= > >        if (blk_rq_pos(req) + blk_rq_sectors(req) !=
= > blk_rq_pos(next))
= > > diff --git a/block/elevator.c b/block/elevator.c
= > > index 99838f4..4255dd9 100644
= > > --- a/block/elevator.c
= > > +++ b/block/elevator.c
= > > @@ -88,6 +88,12 @@ int elv_rq_merge_ok(struct request *rq, struct
= > bio *bio)
= > >                return 0;
= > >
= > >        /*
= > > +        * Don't merge sanitize requests
= > > +        */
= > > +       if ((bio->bi_rw & REQ_SANITIZE) != (rq->bio->bi_rw &
= > REQ_SANITIZE))
= > > +               return 0;
= > > +
= > > +       /*
= > >         * different data direction or already started, don't merge
= > >         */
= > >        if (bio_data_dir(bio) != rq_data_dir(rq))
= > > @@ -647,7 +653,7 @@ void __elv_add_request(struct request_queue *q,
= > struct request *rq, int where)
= > >        if (rq->cmd_flags & REQ_SOFTBARRIER) {
= > >                /* barriers are scheduling boundary, update
= > end_sector */
= > >                if (rq->cmd_type == REQ_TYPE_FS ||
= > > -                   (rq->cmd_flags & REQ_DISCARD)) {
= > > +                   (rq->cmd_flags & (REQ_DISCARD | REQ_SANITIZE)))
= > {
= > >                        q->end_sector = rq_end_sector(rq);
= > >                        q->boundary_rq = rq;
= > >                }
= > > diff --git a/block/ioctl.c b/block/ioctl.c
= > > index ca939fc..112215d 100644
= > > --- a/block/ioctl.c
= > > +++ b/block/ioctl.c
= > > @@ -132,6 +132,11 @@ static int blk_ioctl_discard(struct
= > block_device *bdev, uint64_t start,
= > >        return blkdev_issue_discard(bdev, start, len, GFP_KERNEL,
= > flags);
= > >  }
= > >
= > > +static int blk_ioctl_sanitize(struct block_device *bdev)
= > > +{
= > > +       return blkdev_issue_sanitize(bdev, GFP_KERNEL);
= > > +}
= > > +
= > >  static int put_ushort(unsigned long arg, unsigned short val)
= > >  {
= > >        return put_user(val, (unsigned short __user *)arg);
= > > @@ -216,6 +221,10 @@ int blkdev_ioctl(struct block_device *bdev,
= > fmode_t mode, unsigned cmd,
= > >                set_device_ro(bdev, n);
= > >                return 0;
= > >
= > > +       case BLKSANITIZE:
= > > +               ret = blk_ioctl_sanitize(bdev);
= > > +                       break;
= > > +
= > >        case BLKDISCARD:
= > >        case BLKSECDISCARD: {
= > >                uint64_t range[2];
= > > diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
= > > index 0c959c9..06561b9 100644
= > > --- a/drivers/mmc/card/block.c
= > > +++ b/drivers/mmc/card/block.c
= > > @@ -868,18 +868,11 @@ static int mmc_blk_issue_secdiscard_rq(struct
= > mmc_queue *mq,
= > >        unsigned int from, nr, arg;
= > >        int err = 0, type = MMC_BLK_SECDISCARD;
= > >
= > > -       if (!(mmc_can_secure_erase_trim(card) ||
= > mmc_can_sanitize(card))) {
= > > +       if (!(mmc_can_secure_erase_trim(card))) {
= > >                err = -EOPNOTSUPP;
= > >                goto out;
= > >        }
= > >
= > > -       /* The sanitize operation is supported at v4.5 only */
= > > -       if (mmc_can_sanitize(card)) {
= > > -               err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
= > > -                               EXT_CSD_SANITIZE_START, 1, 0);
= > > -               goto out;
= > > -       }
= > > -
= > >        from = blk_rq_pos(req);
= > >        nr = blk_rq_sectors(req);
= > >
= > > @@ -922,6 +915,40 @@ out:
= > >        return err ? 0 : 1;
= > >  }
= > >
= > > +int mmc_blk_issue_sanitize_rq(struct mmc_queue *mq,
= > > +                              struct request *req)
= > > +{
= > > +       struct mmc_blk_data *md = mq->data;
= > > +       struct mmc_card *card = md->queue.card;
= > > +       int err = 0;
= > > +
= > > +       if (!(mmc_can_sanitize(card))) {
= > > +               pr_err("%s: SANITIZE is not supported", __func__);
= > > +               err = -EOPNOTSUPP;
= > > +               goto out;
= > > +       }
= > > +
= > > +       pr_debug("%s: SANITIZE is supported", __func__);
= > > +
= > > +       mmc_sd_card_set_sanitize_in_progress(card);
= > > +
= > > +       err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
= > > +                                        EXT_CSD_SANITIZE_START, 1,
= > 0);
= > > +
= > > +       if (err)
= > > +               pr_err("%s: mmcblk: mmc_switch() failed. err=%d\n",
= > > +                      __func__, err);
= > > +
= > > +       mmc_sd_card_set_sanitize_completed(card);
= > > +
= > > +out:
= > > +       spin_lock_irq(&md->lock);
= > > +       __blk_end_request(req, err, blk_rq_bytes(req));
= > > +       spin_unlock_irq(&md->lock);
= > > +
= > > +       return err ? 0 : 1;
= > > +}
= > > +
= > >  static int mmc_blk_issue_flush(struct mmc_queue *mq, struct
= > request *req)
= > >  {
= > >        struct mmc_blk_data *md = mq->data;
= > > @@ -1379,7 +1406,12 @@ static int mmc_blk_issue_rq(struct mmc_queue
= > *mq, struct request *req)
= > >                goto out;
= > >        }
= > >
= > > -       if (req && req->cmd_flags & REQ_DISCARD) {
= > > +       if (req && req->cmd_flags & REQ_SANITIZE) {
= > > +               /* complete ongoing async transfer before issuing
= > discard */
= > > +               if (card->host && card->host->areq)
= > > +                       mmc_blk_issue_rw_rq(mq, NULL);
= > > +               ret = mmc_blk_issue_sanitize_rq(mq, req);
= > > +       } else if (req && req->cmd_flags & REQ_DISCARD) {
= > >                /* complete ongoing async transfer before issuing
= > discard */
= > >                if (card->host->areq)
= > >                        mmc_blk_issue_rw_rq(mq, NULL);
= > > diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
= > > index dcad59c..642a80d 100644
= > > --- a/drivers/mmc/card/queue.c
= > > +++ b/drivers/mmc/card/queue.c
= > > @@ -140,7 +140,7 @@ static void mmc_queue_setup_discard(struct
= > request_queue *q,
= > >        /* granularity must not be greater than max. discard */
= > >        if (card->pref_erase > max_discard)
= > >                q->limits.discard_granularity = 0;
= > > -       if (mmc_can_secure_erase_trim(card) ||
= > mmc_can_sanitize(card))
= > > +       if (mmc_can_secure_erase_trim(card))
= > >                queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
= > Please add the QUEUE_FLAG_SANITIZE at here as other.
= > >  }
= > >
= > > @@ -181,6 +181,11 @@ int mmc_init_queue(struct mmc_queue *mq,
= > struct mmc_card *card,
= > >        if (mmc_can_erase(card))
= > >                mmc_queue_setup_discard(mq->queue, card);
= > >
= > > +       if (mmc_can_sanitize(card))
= > > +               queue_flag_set_unlocked(QUEUE_FLAG_SANITIZE, mq-
= > >queue);
= > > +       else
= > > +               pr_info("%s - card doesn't support sanitize",
= > __func__);
= > Please move to it as above
= > > +
= > >  #ifdef CONFIG_MMC_BLOCK_BOUNCE
= > >        if (host->max_segs == 1) {
= > >                unsigned int bouncesz;
= > > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
= > > index 4053cbd..826c724 100644
= > > --- a/include/linux/blk_types.h
= > > +++ b/include/linux/blk_types.h
= > > @@ -150,6 +150,7 @@ enum rq_flag_bits {
= > >        __REQ_FLUSH_SEQ,        /* request for flush sequence */
= > >        __REQ_IO_STAT,          /* account I/O stat */
= > >        __REQ_MIXED_MERGE,      /* merge of different types, fail
= > separately */
= > > +       __REQ_SANITIZE,         /* sanitize */
= > >        __REQ_NR_BITS,          /* stops here */
= > >  };
= > >
= > > @@ -161,13 +162,15 @@ enum rq_flag_bits {
= > >  #define REQ_META               (1 << __REQ_META)
= > >  #define REQ_PRIO               (1 << __REQ_PRIO)
= > >  #define REQ_DISCARD            (1 << __REQ_DISCARD)
= > > +#define REQ_SANITIZE           (1 << __REQ_SANITIZE)
= > >  #define REQ_NOIDLE             (1 << __REQ_NOIDLE)
= > >
= > >  #define REQ_FAILFAST_MASK \
= > >        (REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
= > REQ_FAILFAST_DRIVER)
= > >  #define REQ_COMMON_MASK \
= > >        (REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META |
= > REQ_PRIO | \
= > > -        REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA |
= > REQ_SECURE)
= > > +        REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA |
= > REQ_SECURE | \
= > > +        REQ_SANITIZE)
= > >  #define REQ_CLONE_MASK         REQ_COMMON_MASK
= > >
= > >  #define REQ_RAHEAD             (1 << __REQ_RAHEAD)
= > > @@ -192,4 +195,4 @@ enum rq_flag_bits {
= > >  #define REQ_MIXED_MERGE                (1 << __REQ_MIXED_MERGE)
= > >  #define REQ_SECURE             (1 << __REQ_SECURE)
= > >
= > > -#endif /* __LINUX_BLK_TYPES_H */
= > > +#endif /* __LINUX_REQ__TYPES_H */
= > Why do you change this one?
= > > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
= > > index 7084318..1197c31 100644
= > > --- a/include/linux/blkdev.h
= > > +++ b/include/linux/blkdev.h
= > > @@ -423,6 +423,7 @@ struct request_queue {
= > >  #define QUEUE_FLAG_ADD_RANDOM  16      /* Contributes to random
= > pool */
= > >  #define QUEUE_FLAG_SECDISCARD  17      /* supports SECDISCARD */
= > >  #define QUEUE_FLAG_SAME_FORCE  18      /* force complete on same
= > CPU */
= > > +#define QUEUE_FLAG_SANITIZE    19      /* supports SANITIZE */
= > >
= > >  #define QUEUE_FLAG_DEFAULT     ((1 << QUEUE_FLAG_IO_STAT) |
= >      \
= > >                                 (1 << QUEUE_FLAG_STACKABLE)    |
= >     \
= > > @@ -506,6 +507,7 @@ static inline void queue_flag_clear(unsigned
= > int flag, struct request_queue *q)
= > >  #define blk_queue_stackable(q) \
= > >        test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
= > >  #define blk_queue_discard(q)   test_bit(QUEUE_FLAG_DISCARD, &(q)-
= > >queue_flags)
= > > +#define blk_queue_sanitize(q)  test_bit(QUEUE_FLAG_SANITIZE, &(q)-
= > >queue_flags)
= > >  #define blk_queue_secdiscard(q)        (blk_queue_discard(q) && \
= > >        test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
= > >
= > > @@ -955,6 +957,7 @@ static inline struct request
= > *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
= > >  extern int blkdev_issue_flush(struct block_device *, gfp_t,
= > sector_t *);
= > >  extern int blkdev_issue_discard(struct block_device *bdev,
= > sector_t sector,
= > >                sector_t nr_sects, gfp_t gfp_mask, unsigned long
= > flags);
= > > +extern int blkdev_issue_sanitize(struct block_device *bdev, gfp_t
= > gfp_mask);
= > >  extern int blkdev_issue_zeroout(struct block_device *bdev,
= > sector_t sector,
= > >                        sector_t nr_sects, gfp_t gfp_mask);
= > >  static inline int sb_issue_discard(struct super_block *sb,
= > sector_t block,
= > > diff --git a/include/linux/fs.h b/include/linux/fs.h
= > > index 057434a..3680eef 100644
= > > --- a/include/linux/fs.h
= > > +++ b/include/linux/fs.h
= > > @@ -319,6 +319,7 @@ struct inodes_stat_t {
= > >  #define BLKPBSZGET _IO(0x12,123)
= > >  #define BLKDISCARDZEROES _IO(0x12,124)
= > >  #define BLKSECDISCARD _IO(0x12,125)
= > > +#define BLKSANITIZE _IO(0x12, 126)
= > >
= > >  #define BMAP_IOCTL 1           /* obsolete - kept for
= > compatibility */
= > >  #define FIBMAP    _IO(0x00,1)  /* bmap access */
= > > diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
= > > index 9478a6b..0890e9c 100644
= > > --- a/include/linux/mmc/card.h
= > > +++ b/include/linux/mmc/card.h
= > > @@ -236,6 +236,9 @@ struct mmc_card {
= > >  #define MMC_POWEROFF_SHORT             2
= > >  #define MMC_POWEROFF_LONG              3
= > >
= > > +/* card is in sanitize progress */
= > > +#define MMC_STATE_SANITIZE_IN_PROGRESS (1<<9)
= > > +
= > >        unsigned int            erase_size;     /* erase size in
= > sectors */
= > >        unsigned int            erase_shift;    /* if erase unit is
= > power 2 */
= > >        unsigned int            pref_erase;     /* in sectors */
= > > @@ -388,6 +391,10 @@ static inline void __maybe_unused
= > remove_quirk(struct mmc_card *card, int data)
= > >  #define mmc_card_set_ddr_mode(c) ((c)->state |=
= > MMC_STATE_HIGHSPEED_DDR)
= > >  #define mmc_card_set_uhs(c) ((c)->state |=
= > MMC_STATE_ULTRAHIGHSPEED)
= > >  #define mmc_sd_card_set_uhs(c) ((c)->state |=
= > MMC_STATE_ULTRAHIGHSPEED)
= > > +#define mmc_sd_card_set_sanitize_in_progress(c) ((c)->state |= \
= > > +               MMC_STATE_SANITIZE_IN_PROGRESS)
= > > +#define mmc_sd_card_set_sanitize_completed(c) ((c)->state &= \
= > > +               ~MMC_STATE_SANITIZE_IN_PROGRESS)
= > >  #define mmc_card_set_ext_capacity(c) ((c)->state |= MMC_CARD_SDXC)
= > >  #define mmc_card_set_removed(c) ((c)->state |= MMC_CARD_REMOVED)
= > >
= > > diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
= > > index 16fc34a..2c2efc6 100644
= > > --- a/kernel/trace/blktrace.c
= > > +++ b/kernel/trace/blktrace.c
= > > @@ -1802,6 +1802,8 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int
= > bytes)
= > >                rwbs[i++] = 'W';
= > >        else if (rw & REQ_DISCARD)
= > >                rwbs[i++] = 'D';
= > > +       else if (rw & REQ_SANITIZE)
= > > +               rwbs[i++] = 'Z';
= > >        else if (bytes)
= > >                rwbs[i++] = 'R';
= > >        else
= > > --
= > > 1.7.6
= > > --
= > > Sent by a consultant of the Qualcomm Innovation Center, Inc.
= > > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
= > Forum
= > > --
= > > To unsubscribe from this list: send the line "unsubscribe linux-
= > mmc" in
= > > the body of a message to majordomo@vger.kernel.org
= > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-mmc"
= > in
= > the body of a message to majordomo@vger.kernel.org
= > More majordomo info at  http://vger.kernel.org/majordomo-info.html

