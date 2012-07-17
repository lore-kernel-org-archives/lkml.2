Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2GQKsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:48:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1991 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2GQKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:48:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6774"; a="209039052"
Message-ID: <fd821a78c2594b9d4b88ea265ad1fea6.squirrel@www.codeaurora.org>
In-Reply-To: <de2877051419248f40fca47db1fffbbc.squirrel@www.codeaurora.org>
References: <1340872367-16206-1-git-send-email-ygardi@codeaurora.org>
    <1340872367-16206-2-git-send-email-ygardi@codeaurora.org>
    <de2877051419248f40fca47db1fffbbc.squirrel@www.codeaurora.org>
Date: Tue, 17 Jul 2012 03:48:27 -0700 (PDT)
Subject: Re: [PATCH RESEND v7 1/2] block: ioctl support for sanitize in     
      eMMC 4.5
From: "Yaniv Gardi" <ygardi@codeaurora.org>
To: merez@codeaurora.org
Cc: "Yaniv Gardi" <ygardi@codeaurora.org>, linux-mmc@vger.kernel.org,
        merez@codeaurora.org, linux-arm-msm@vger.kernel.org,
        "open list" <linux-kernel@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.d>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Can you approve this patch?

Thanks,
Yaniv
> Looks good to me.
> Reviewed-by: Maya Erez <merez@codeaurora.org>
>
> On Thu, June 28, 2012 1:32 am, Yaniv Gardi wrote:
>> Adding a new ioctl to support sanitize operation in eMMC
>> cards version 4.5.
>> The sanitize ioctl support helps performing this operation
>> via user application.
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  block/blk-core.c          |   15 ++++++++++--
>>  block/blk-lib.c           |   51
>> +++++++++++++++++++++++++++++++++++++++++++++
>>  block/blk-merge.c         |    4 +++
>>  block/elevator.c          |    2 +-
>>  block/ioctl.c             |    9 ++++++++
>>  include/linux/blk_types.h |    5 +++-
>>  include/linux/blkdev.h    |    3 ++
>>  include/linux/fs.h        |    1 +
>>  kernel/trace/blktrace.c   |    2 +
>>  9 files changed, 87 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 3c923a7..4a56102b 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1641,7 +1641,7 @@ generic_make_request_checks(struct bio *bio)
>>  		goto end_io;
>>  	}
>>
>> -	if (unlikely(!(bio->bi_rw & REQ_DISCARD) &&
>> +	if (unlikely(!(bio->bi_rw & (REQ_DISCARD | REQ_SANITIZE)) &&
>>  		     nr_sectors > queue_max_hw_sectors(q))) {
>>  		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
>>  		       bdevname(bio->bi_bdev, b),
>> @@ -1689,6 +1689,14 @@ generic_make_request_checks(struct bio *bio)
>>  		goto end_io;
>>  	}
>>
>> +	if ((bio->bi_rw & REQ_SANITIZE) &&
>> +	    (!blk_queue_sanitize(q))) {
>> +		pr_info("%s - got a SANITIZE request but the queue "
>> +		       "doesn't support sanitize requests", __func__);
>> +		err = -EOPNOTSUPP;
>> +		goto end_io;
>> +	}
>> +
>>  	if (blk_throtl_bio(q, bio))
>>  		return false;	/* throttled, will be resubmitted later */
>>
>> @@ -1794,7 +1802,8 @@ void submit_bio(int rw, struct bio *bio)
>>  	 * If it's a regular read/write or a barrier with data attached,
>>  	 * go through the normal accounting stuff before submission.
>>  	 */
>> -	if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
>> +	if (bio_has_data(bio) &&
>> +	    (!(rw & (REQ_DISCARD | REQ_SANITIZE)))) {
>>  		if (rw & WRITE) {
>>  			count_vm_events(PGPGOUT, count);
>>  		} else {
>> @@ -1840,7 +1849,7 @@ EXPORT_SYMBOL(submit_bio);
>>   */
>>  int blk_rq_check_limits(struct request_queue *q, struct request *rq)
>>  {
>> -	if (rq->cmd_flags & REQ_DISCARD)
>> +	if (rq->cmd_flags & (REQ_DISCARD | REQ_SANITIZE))
>>  		return 0;
>>
>>  	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>> index 2b461b4..280d63e 100644
>> --- a/block/blk-lib.c
>> +++ b/block/blk-lib.c
>> @@ -115,6 +115,57 @@ int blkdev_issue_discard(struct block_device *bdev,
>> sector_t sector,
>>  EXPORT_SYMBOL(blkdev_issue_discard);
>>
>>  /**
>> + * blkdev_issue_sanitize - queue a sanitize request
>> + * @bdev:	blockdev to issue sanitize for
>> + * @gfp_mask:	memory allocation flags (for bio_alloc)
>> + *
>> + * Description:
>> + *    Issue a sanitize request for the specified block device
>> + */
>> +int blkdev_issue_sanitize(struct block_device *bdev, gfp_t gfp_mask)
>> +{
>> +	DECLARE_COMPLETION_ONSTACK(wait);
>> +	struct request_queue *q = bdev_get_queue(bdev);
>> +	int type = REQ_WRITE | REQ_SANITIZE;
>> +	struct bio_batch bb;
>> +	struct bio *bio;
>> +	int ret = 0;
>> +
>> +	if (!q)
>> +		return -ENXIO;
>> +
>> +	if (!blk_queue_sanitize(q)) {
>> +		pr_err("%s - card doesn't support sanitize", __func__);
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	bio = bio_alloc(gfp_mask, 1);
>> +	if (!bio)
>> +		return -ENOMEM;
>> +
>> +	atomic_set(&bb.done, 1);
>> +	bb.flags = 1 << BIO_UPTODATE;
>> +	bb.wait = &wait;
>> +
>> +	bio->bi_end_io = bio_batch_end_io;
>> +	bio->bi_bdev = bdev;
>> +	bio->bi_private = &bb;
>> +
>> +	atomic_inc(&bb.done);
>> +	submit_bio(type, bio);
>> +
>> +	/* Wait for bios in-flight */
>> +	if (!atomic_dec_and_test(&bb.done))
>> +		wait_for_completion(&wait);
>> +
>> +	if (!test_bit(BIO_UPTODATE, &bb.flags))
>> +		ret = -EIO;
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(blkdev_issue_sanitize);
>> +
>> +/**
>>   * blkdev_issue_zeroout - generate number of zero filed write bios
>>   * @bdev:	blockdev to issue
>>   * @sector:	start sector
>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>> index 160035f..7e24772 100644
>> --- a/block/blk-merge.c
>> +++ b/block/blk-merge.c
>> @@ -477,6 +477,10 @@ bool blk_rq_merge_ok(struct request *rq, struct bio
>> *bio)
>>  	if (!rq_mergeable(rq))
>>  		return false;
>>
>> +	/* don't merge file system requests and sanitize requests */
>> +	if ((req->cmd_flags & REQ_SANITIZE) != (next->cmd_flags &
>> REQ_SANITIZE))
>> +		return false;
>> +
>>  	/* don't merge file system requests and discard requests */
>>  	if ((bio->bi_rw & REQ_DISCARD) != (rq->bio->bi_rw & REQ_DISCARD))
>>  		return false;
>> diff --git a/block/elevator.c b/block/elevator.c
>> index 6a55d41..91f1de1 100644
>> --- a/block/elevator.c
>> +++ b/block/elevator.c
>> @@ -563,7 +563,7 @@ void __elv_add_request(struct request_queue *q,
>> struct
>> request *rq, int where)
>>  	if (rq->cmd_flags & REQ_SOFTBARRIER) {
>>  		/* barriers are scheduling boundary, update end_sector */
>>  		if (rq->cmd_type == REQ_TYPE_FS ||
>> -		    (rq->cmd_flags & REQ_DISCARD)) {
>> +		    (rq->cmd_flags & (REQ_DISCARD | REQ_SANITIZE))) {
>>  			q->end_sector = rq_end_sector(rq);
>>  			q->boundary_rq = rq;
>>  		}
>> diff --git a/block/ioctl.c b/block/ioctl.c
>> index ba15b2d..dd76ba0 100644
>> --- a/block/ioctl.c
>> +++ b/block/ioctl.c
>> @@ -132,6 +132,11 @@ static int blk_ioctl_discard(struct block_device
>> *bdev, uint64_t start,
>>  	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
>>  }
>>
>> +static int blk_ioctl_sanitize(struct block_device *bdev)
>> +{
>> +	return blkdev_issue_sanitize(bdev, GFP_KERNEL);
>> +}
>> +
>>  static int put_ushort(unsigned long arg, unsigned short val)
>>  {
>>  	return put_user(val, (unsigned short __user *)arg);
>> @@ -234,6 +239,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t
>> mode, unsigned cmd,
>>  		set_device_ro(bdev, n);
>>  		return 0;
>>
>> +	case BLKSANITIZE:
>> +		ret = blk_ioctl_sanitize(bdev);
>> +		break;
>> +
>>  	case BLKDISCARD:
>>  	case BLKSECDISCARD: {
>>  		uint64_t range[2];
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 0edb65d..e58e0db 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -160,6 +160,7 @@ enum rq_flag_bits {
>>  	__REQ_FLUSH_SEQ,	/* request for flush sequence */
>>  	__REQ_IO_STAT,		/* account I/O stat */
>>  	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
>> +	__REQ_SANITIZE,		/* sanitize */
>>  	__REQ_NR_BITS,		/* stops here */
>>  };
>>
>> @@ -171,13 +172,15 @@ enum rq_flag_bits {
>>  #define REQ_META		(1 << __REQ_META)
>>  #define REQ_PRIO		(1 << __REQ_PRIO)
>>  #define REQ_DISCARD		(1 << __REQ_DISCARD)
>> +#define REQ_SANITIZE		(1 << __REQ_SANITIZE)
>>  #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
>>
>>  #define REQ_FAILFAST_MASK \
>>  	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
>>  #define REQ_COMMON_MASK \
>>  	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
>> -	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
>> +	 REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE | \
>> +	 REQ_SANITIZE)
>>  #define REQ_CLONE_MASK		REQ_COMMON_MASK
>>
>>  #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index ba43f40..1db6c91 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -438,6 +438,7 @@ struct request_queue {
>>  #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
>>  #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
>>  #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
>> +#define QUEUE_FLAG_SANITIZE    19	/* supports SANITIZE */
>>
>>  #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>>  				 (1 << QUEUE_FLAG_STACKABLE)	|	\
>> @@ -518,6 +519,7 @@ static inline void queue_flag_clear(unsigned int
>> flag,
>> struct request_queue *q)
>>  #define blk_queue_stackable(q)	\
>>  	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
>>  #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD,
>> &(q)->queue_flags)
>> +#define blk_queue_sanitize(q)	test_bit(QUEUE_FLAG_SANITIZE,
>> &(q)->queue_flags)
>>  #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
>>  	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
>>
>> @@ -971,6 +973,7 @@ static inline struct request
>> *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
>>  extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t
>> *);
>>  extern int blkdev_issue_discard(struct block_device *bdev, sector_t
>> sector,
>>  		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
>> +extern int blkdev_issue_sanitize(struct block_device *bdev, gfp_t
>> gfp_mask);
>>  extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t
>> sector,
>>  			sector_t nr_sects, gfp_t gfp_mask);
>>  static inline int sb_issue_discard(struct super_block *sb, sector_t
>> block,
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index b0a6d44..167c450 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -333,6 +333,7 @@ struct inodes_stat_t {
>>  #define BLKDISCARDZEROES _IO(0x12,124)
>>  #define BLKSECDISCARD _IO(0x12,125)
>>  #define BLKROTATIONAL _IO(0x12,126)
>> +#define BLKSANITIZE _IO(0x12, 127)
>>
>>  #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
>>  #define FIBMAP	   _IO(0x00,1)	/* bmap access */
>> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
>> index c0bd030..06f7940 100644
>> --- a/kernel/trace/blktrace.c
>> +++ b/kernel/trace/blktrace.c
>> @@ -1788,6 +1788,8 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
>>  		rwbs[i++] = 'W';
>>  	else if (rw & REQ_DISCARD)
>>  		rwbs[i++] = 'D';
>> +	else if (rw & REQ_SANITIZE)
>> +		rwbs[i++] = 'Z';
>>  	else if (bytes)
>>  		rwbs[i++] = 'R';
>>  	else
>> --
>> 1.7.6
>> --
>> Sent by a consultant of the Qualcomm Innovation Center, Inc.
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> Forum
>>
>
>
> --
> Sent by consultant of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Yaniv Gardi
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum


