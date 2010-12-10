Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0LJQ4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:56:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546Ab0LJQ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:56:00 -0500
Date: Fri, 10 Dec 2010 11:55:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
Message-ID: <20101210165553.GE31737@redhat.com>
References: <4CFCB08F.4010509@jp.fujitsu.com>
 <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com>
 <4CFDDFC3.2070107@jp.fujitsu.com>
 <4CFF34E7.2030401@fusionio.com>
 <4CFF3AD6.6010904@jp.fujitsu.com>
 <4CFF3C86.2070504@fusionio.com>
 <4CFF3DA4.5060705@jp.fujitsu.com>
 <4CFF9A2C.1070401@fusionio.com>
 <4D025154.8030400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D025154.8030400@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 05:12:04PM +0100, Jerome Marchand wrote:
> On 12/08/2010 03:46 PM, Jens Axboe wrote:
> > 
> > No, that's not it at all. What I mean (and what was reverted) was
> > caching the partition lookup, and using that for the stats. The problem
> > with that approach turned out to be the elevator queiscing logic not
> > being fully correct. One easier way to fix that would be to reference
> > count the part stats, instead of having to drain the queue.
> > 
> 
> The partition is already deleted in a rcu callback function. If I
> understand RCU correctly, we just need to use rcu_dereference() each time
> we use rq->part. Something like the following *untested* patch.

Jerome,

I don't think that rcu_dereference() is going to solve the problem. The
partition table will be freed as soon as one rcu period is over. So to
make sure partition table is not freed one has to be holding
rcu_read_lock(). It is not a good idea to keep rcu period going till
request finishes so a better idea will to to reference count it.

Thanks
Vivek

> 
> Jerome
> 
> ---
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4ce953f..70d23f9 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -64,13 +64,15 @@ static void drive_stat_acct(struct request *rq, int new_io)
>  		return;
>  
>  	cpu = part_stat_lock();
> -	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>  
> -	if (!new_io)
> +	if (!new_io) {
> +		part = blk_rq_get_part(rq);
>  		part_stat_inc(cpu, part, merges[rw]);
> -	else {
> +	} else {
> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>  		part_round_stats(cpu, part);
>  		part_inc_in_flight(part, rw);
> +		rq->part = part;
>  	}
>  
>  	part_stat_unlock();
> @@ -128,6 +130,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
>  	rq->ref_count = 1;
>  	rq->start_time = jiffies;
>  	set_start_time_ns(rq);
> +	rq->part = NULL;
>  }
>  EXPORT_SYMBOL(blk_rq_init);
>  
> @@ -1776,7 +1784,7 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
>  		int cpu;
>  
>  		cpu = part_stat_lock();
> -		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
> +		part = blk_rq_get_part(req);
>  		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
>  		part_stat_unlock();
>  	}
> @@ -1796,7 +1804,7 @@ static void blk_account_io_done(struct request *req)
>  		int cpu;
>  
>  		cpu = part_stat_lock();
> -		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
> +		part = blk_rq_get_part(req);
>  
>  		part_stat_inc(cpu, part, ios[rw]);
>  		part_stat_add(cpu, part, ticks[rw], duration);
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 77b7c26..0ea5416 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -351,7 +351,7 @@ static void blk_account_io_merge(struct request *req)
>  		int cpu;
>  
>  		cpu = part_stat_lock();
> -		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
> +		part = blk_rq_get_part(req);
>  
>  		part_round_stats(cpu, part);
>  		part_dec_in_flight(part, rq_data_dir(req));
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index aae86fd..00a3b93 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -115,6 +115,7 @@ struct request {
>  	void *elevator_private3;
>  
>  	struct gendisk *rq_disk;
> +	struct hd_struct __rcu *part;
>  	unsigned long start_time;
>  #ifdef CONFIG_BLK_CGROUP
>  	unsigned long long start_time_ns;
> @@ -752,6 +753,12 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
>  	return blk_rq_cur_bytes(rq) >> 9;
>  }
>  
> +static inline struct hd_struct *blk_rq_get_part(const struct request *rq)
> +{
> +	struct hd_struct *part = rcu_dereference(rq->part);
> +	return part;
> +}
> +
>  /*
>   * Request issue related functions.
>   */
