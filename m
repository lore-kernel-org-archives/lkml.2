Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab0JNMz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:55:29 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53154 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab0JNMz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:55:27 -0400
Message-ID: <4CB6FDB7.5010501@kernel.dk>
Date: Thu, 14 Oct 2010 14:55:19 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <4CB41A27.5080001@kernel.dk> <4CB6FC1C.3050801@jp.fujitsu.com>
In-Reply-To: <4CB6FC1C.3050801@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-14 14:48, Yasuaki Ishimatsu wrote:
> Index: linux-2.6.36-rc7/block/blk-core.c
> ===================================================================
> --- linux-2.6.36-rc7.orig/block/blk-core.c	2010-10-07 05:39:52.000000000 +0900
> +++ linux-2.6.36-rc7/block/blk-core.c	2010-10-14 17:25:43.000000000 +0900
> @@ -66,9 +66,15 @@ static void drive_stat_acct(struct reque
>  	cpu = part_stat_lock();
>  	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
> 
> -	if (!new_io)
> +	if (!new_io) {
> +		if (unlikely(rq->part != part)) {
> +			part_dec_in_flight(rq->part, rw);
> +			part_inc_in_flight(part, rw);
> +			rq->part = part;
> +		}
>  		part_stat_inc(cpu, part, merges[rw]);
> -	else {
> +	} else {
> +		rq->part = part;
>  		part_round_stats(cpu, part);
>  		part_inc_in_flight(part, rw);
>  	}

I was thinking that we'd do away with the lookup always if ->part was
already set. It will probably require a quiscing of IO on partition
table reload, though.

-- 
Jens Axboe

