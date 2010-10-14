Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0JNMoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:44:39 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38720 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab0JNMoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:44:38 -0400
Message-ID: <4CB6FB30.1000502@kernel.dk>
Date: Thu, 14 Oct 2010 14:44:32 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <20101014150742.F9EC.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101014150742.F9EC.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-14 08:07, KOSAKI Motohiro wrote:
>> @@ -1268,7 +1270,17 @@ static int __make_request(struct request
>>  		 * not touch req->buffer either...
>>  		 */
>>  		req->buffer = bio_data(bio);
>> +		src_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
>>  		req->__sector = bio->bi_sector;
>> +		dst_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
> 
> I think this is wrong. disk_map_sector_rcu() require
> rcu read lock held (see function comment). all other call site take 
> part_stat_lock() before disk_map_sector_rcu() call.

It's called under the queue lock with irqs disabled, which implies a
rcu critical section.

-- 
Jens Axboe

