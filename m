Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab0GMGlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:41:51 -0400
Received: from smtp.nokia.com ([192.100.122.233]:42768 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0GMGlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:41:49 -0400
Message-ID: <4C3C0A71.2080407@nokia.com>
Date: Tue, 13 Jul 2010 09:40:49 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "Hunter Adrian (Nokia-MS/Helsinki)" <adrian.hunter@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 4/5] block: Add secure discard
References: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com> <20100707111749.24979.69982.sendpatchset@ahunter-work.research.nokia.com>
In-Reply-To: <20100707111749.24979.69982.sendpatchset@ahunter-work.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2010 06:40:48.0201 (UTC) FILETIME=[54000390:01CB2256]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hunter Adrian (Nokia-MS/Helsinki) wrote:
>>From 1cdd5b576bfafcd53857ed4d37830446e96e8206 Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Wed, 23 Jun 2010 15:41:38 +0300
> Subject: [PATCH 4/5] block: Add secure discard
> 
> Secure discard is the same as discard except that all copies
> of the discarded sectors (perhaps created by garbage collection)
> must also be erased.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>

Christoph will you comment on this patch?  Is it doing what you
asked?

> ---
>  block/blk-core.c        |    5 ++++-
>  block/blk-lib.c         |    6 ++++++
>  block/compat_ioctl.c    |    1 +
>  block/elevator.c        |    6 ++++++
>  block/ioctl.c           |   15 ++++++++++-----
>  include/linux/bio.h     |    2 ++
>  include/linux/blkdev.h  |    7 ++++++-
>  include/linux/fs.h      |    2 ++
>  kernel/trace/blktrace.c |    8 ++++++++
>  9 files changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3c37894..7931081 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1513,7 +1513,10 @@ static inline void __generic_make_request(struct bio *bio)
>  		if (bio_check_eod(bio, nr_sectors))
>  			goto end_io;
>  
> -		if ((bio->bi_rw & REQ_DISCARD) && !blk_queue_discard(q)) {
> +		if ((bio->bi_rw & REQ_DISCARD) &&
> +		    (!blk_queue_discard(q) ||
> +		     ((bio->bi_rw & REQ_SECURE) &&
> +		      !blk_queue_secdiscard(q)))) {
>  			err = -EOPNOTSUPP;
>  			goto end_io;
>  		}
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index e16185b..ba8c0f9 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -50,6 +50,12 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  	if (!blk_queue_discard(q))
>  		return -EOPNOTSUPP;
>  
> +	if (flags & BLKDEV_IFL_SECURE) {
> +		if (!blk_queue_secdiscard(q))
> +			return -EOPNOTSUPP;
> +		type |= DISCARD_SECURE;
> +	}
> +
>  	while (nr_sects && !ret) {
>  		unsigned int max_discard_sectors =
>  			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
> index f26051f..24a146d 100644
> --- a/block/compat_ioctl.c
> +++ b/block/compat_ioctl.c
> @@ -753,6 +753,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  	case BLKFLSBUF:
>  	case BLKROSET:
>  	case BLKDISCARD:
> +	case BLKSECDISCARD:
>  	/*
>  	 * the ones below are implemented in blkdev_locked_ioctl,
>  	 * but we call blkdev_ioctl, which gets the lock for us
> diff --git a/block/elevator.c b/block/elevator.c
> index 816a7c8..ec585c9 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -83,6 +83,12 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
>  		return 0;
>  
>  	/*
> +	 * Don't merge discard requests and secure discard requests
> +	 */
> +	if ((bio->bi_rw & REQ_SECURE) != (rq->bio->bi_rw & REQ_SECURE))
> +		return 0;
> +
> +	/*
>  	 * different data direction or already started, don't merge
>  	 */
>  	if (bio_data_dir(bio) != rq_data_dir(rq))
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 6f3db6f..afcfe48 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -114,8 +114,10 @@ static int blkdev_reread_part(struct block_device *bdev)
>  }
>  
>  static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
> -			     uint64_t len)
> +			     uint64_t len, int secure)
>  {
> +	unsigned long flags = BLKDEV_IFL_WAIT;
> +
>  	if (start & 511)
>  		return -EINVAL;
>  	if (len & 511)
> @@ -125,8 +127,9 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
>  
>  	if (start + len > (bdev->bd_inode->i_size >> 9))
>  		return -EINVAL;
> -	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL,
> -				    BLKDEV_IFL_WAIT);
> +	if (secure)
> +		flags |= BLKDEV_IFL_SECURE;
> +	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
>  }
>  
>  static int put_ushort(unsigned long arg, unsigned short val)
> @@ -226,7 +229,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  		unlock_kernel();
>  		return 0;
>  
> -	case BLKDISCARD: {
> +	case BLKDISCARD:
> +	case BLKSECDISCARD: {
>  		uint64_t range[2];
>  
>  		if (!(mode & FMODE_WRITE))
> @@ -235,7 +239,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
>  			return -EFAULT;
>  
> -		return blk_ioctl_discard(bdev, range[0], range[1]);
> +		return blk_ioctl_discard(bdev, range[0], range[1],
> +					 cmd == BLKSECDISCARD);
>  	}
>  
>  	case HDIO_GETGEO: {
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 4d379c8..147e631 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -176,6 +176,7 @@ enum rq_flag_bits {
>  	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
>  	__REQ_IO_STAT,		/* account I/O stat */
>  	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
> +	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
>  	__REQ_NR_BITS,		/* stops here */
>  };
>  
> @@ -215,6 +216,7 @@ enum rq_flag_bits {
>  #define REQ_INTEGRITY		(1 << __REQ_INTEGRITY)
>  #define REQ_IO_STAT		(1 << __REQ_IO_STAT)
>  #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
> +#define REQ_SECURE		(1 << __REQ_SECURE)
>  
>  /*
>   * upper 16 bits of bi_rw define the io priority of this bio
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 204fbe2..da643f4 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -404,6 +404,7 @@ struct request_queue
>  #define QUEUE_FLAG_DISCARD     16	/* supports DISCARD */
>  #define QUEUE_FLAG_NOXMERGES   17	/* No extended merges */
>  #define QUEUE_FLAG_ADD_RANDOM  18	/* Contributes to random pool */
> +#define QUEUE_FLAG_SECDISCARD  19	/* supports SECDISCARD */
>  
>  #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>  				 (1 << QUEUE_FLAG_CLUSTER) |		\
> @@ -539,6 +540,8 @@ enum {
>  #define blk_queue_stackable(q)	\
>  	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
>  #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
> +#define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
> +	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
>  
>  #define blk_noretry_request(rq) \
>  	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
> @@ -931,10 +934,12 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
>  }
>  enum{
>  	BLKDEV_WAIT,	/* wait for completion */
> -	BLKDEV_BARRIER,	/*issue request with barrier */
> +	BLKDEV_BARRIER,	/* issue request with barrier */
> +	BLKDEV_SECURE,	/* secure discard */
>  };
>  #define BLKDEV_IFL_WAIT		(1 << BLKDEV_WAIT)
>  #define BLKDEV_IFL_BARRIER	(1 << BLKDEV_BARRIER)
> +#define BLKDEV_IFL_SECURE	(1 << BLKDEV_SECURE)
>  extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
>  			unsigned long);
>  extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index dc9d185..2f5df1f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -176,6 +176,7 @@ struct inodes_stat_t {
>   */
>  #define DISCARD_NOBARRIER	(WRITE | REQ_DISCARD)
>  #define DISCARD_BARRIER		(WRITE | REQ_DISCARD | REQ_HARDBARRIER)
> +#define DISCARD_SECURE		(DISCARD_NOBARRIER | REQ_SECURE)
>  
>  #define SEL_IN		1
>  #define SEL_OUT		2
> @@ -318,6 +319,7 @@ struct inodes_stat_t {
>  #define BLKALIGNOFF _IO(0x12,122)
>  #define BLKPBSZGET _IO(0x12,123)
>  #define BLKDISCARDZEROES _IO(0x12,124)
> +#define BLKSECDISCARD _IO(0x12,125)
>  
>  #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
>  #define FIBMAP	   _IO(0x00,1)	/* bmap access */
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 3b4a695..a711b47 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -667,6 +667,9 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
>  	if (rq->cmd_flags & REQ_DISCARD)
>  		rw |= REQ_DISCARD;
>  
> +	if (rq->cmd_flags & REQ_SECURE)
> +		rw |= REQ_SECURE;
> +
>  	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
>  		what |= BLK_TC_ACT(BLK_TC_PC);
>  		__blk_add_trace(bt, 0, blk_rq_bytes(rq), rw,
> @@ -1773,6 +1776,8 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
>  		rwbs[i++] = 'S';
>  	if (rw & REQ_META)
>  		rwbs[i++] = 'M';
> +	if (rw & REQ_SECURE)
> +		rwbs[i++] = 'E';
>  
>  	rwbs[i] = '\0';
>  }
> @@ -1785,6 +1790,9 @@ void blk_fill_rwbs_rq(char *rwbs, struct request *rq)
>  	if (rq->cmd_flags & REQ_DISCARD)
>  		rw |= REQ_DISCARD;
>  
> +	if (rq->cmd_flags & REQ_SECURE)
> +		rw |= REQ_SECURE;
> +
>  	bytes = blk_rq_bytes(rq);
>  
>  	blk_fill_rwbs(rwbs, rw, bytes);

