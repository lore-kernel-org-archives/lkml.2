Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0JLITz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:19:55 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54899 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab0JLITx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:19:53 -0400
Message-ID: <4CB41A27.5080001@kernel.dk>
Date: Tue, 12 Oct 2010 10:19:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com>
In-Reply-To: <4CB40281.1020403@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-12 08:38, Yasuaki Ishimatsu wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> /proc/diskstats would display a strange output as follows.
> 
> $ cat /proc/diskstats |grep sda
>    8       0 sda 90524 7579 102154 20464 0 0 0 0 0 14096 20089
>    8       1 sda1 19085 1352 21841 4209 0 0 0 0 4294967064 15689 4293424691
>                                                 ~~~~~~~~~~
>    8       2 sda2 71252 3624 74891 15950 0 0 0 0 232 23995 1562390
>    8       3 sda3 54 487 2188 92 0 0 0 0 0 88 92
>    8       4 sda4 4 0 8 0 0 0 0 0 0 0 0
>    8       5 sda5 81 2027 2130 138 0 0 0 0 0 87 137
> 
> Its reason is the wrong way of accounting hd_struct->in_flight. When a bio is
> merged into a request belongs to different partition by ELEVATOR_FRONT_MERGE.
> 
> The detailed root cause is as follows.
> 
> Assuming that there are two partition, sda1 and sda2.
> 
> 1. A request for sda2 is in request_queue. Hence sda1's hd_struct->in_flight
>    is 0 and sda2's one is 1.
> 
>         | hd_struct->in_flight
>    ---------------------------
>    sda1 |          0
>    sda2 |          1
>    ---------------------------
> 
> 2. A bio belongs to sda1 is issued and is merged into the request mentioned on
>    step1 by ELEVATOR_BACK_MERGE. The first sector of the request is changed
>    from sda2 region to sda1 region. However the two partition's
>    hd_struct->in_flight are not changed.
> 
>         | hd_struct->in_flight
>    ---------------------------
>    sda1 |          0
>    sda2 |          1
>    ---------------------------
> 
> 3. The request is finished and blk_account_io_done() is called. In this case,
>    sda2's hd_struct->in_flight, not a sda1's one, is decremented.
> 
>         | hd_struct->in_flight
>    ---------------------------
>    sda1 |         -1
>    sda2 |          1
>    ---------------------------
> 
> The patch fixes the problem.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>  block/blk-core.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> Index: linux-2.6.36-rc7/block/blk-core.c
> ===================================================================
> --- linux-2.6.36-rc7.orig/block/blk-core.c	2010-10-07 05:39:52.000000000 +0900
> +++ linux-2.6.36-rc7/block/blk-core.c	2010-10-09 05:53:51.000000000 +0900
> @@ -1202,6 +1202,8 @@ static int __make_request(struct request
>  	const bool unplug = !!(bio->bi_rw & REQ_UNPLUG);
>  	const unsigned long ff = bio->bi_rw & REQ_FAILFAST_MASK;
>  	int rw_flags;
> +	struct hd_struct *src_part;
> +	struct hd_struct *dst_part;
> 
>  	if ((bio->bi_rw & REQ_HARDBARRIER) &&
>  	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
> @@ -1268,7 +1270,17 @@ static int __make_request(struct request
>  		 * not touch req->buffer either...
>  		 */
>  		req->buffer = bio_data(bio);
> +		src_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
>  		req->__sector = bio->bi_sector;
> +		dst_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
> +		if (unlikely(src_part != dst_part)) {
> +			int rw = rq_data_dir(req);
> +
> +			part_stat_lock();
> +			part_dec_in_flight(src_part, rw);
> +			part_inc_in_flight(dst_part, rw);
> +			part_stat_unlock();
> +		}
>  		req->__data_len += bytes;
>  		req->ioprio = ioprio_best(req->ioprio, prio);
>  		if (!blk_rq_cpu_valid(req))

Ugh, this is nasty, and two extra part lookups per IO is definitely
going to hurt.

I would suggest fixing this different - cache the part lookup in the
request. That has the advantage of being faster for the normal case as
well since it'll reduce the number of lookups, plus we can get rid of
some of the blk_do_io_stat() checks, or at least reduce them to checking
for a valid rq->part check.

-- 
Jens Axboe

