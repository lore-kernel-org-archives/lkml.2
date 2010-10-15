Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0JOHaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:30:11 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46076 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0JOHaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:30:09 -0400
Message-ID: <4CB802FE.2040801@kernel.dk>
Date: Fri, 15 Oct 2010 09:30:06 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <20101014150742.F9EC.A69D9226@jp.fujitsu.com> <4CB6FB30.1000502@kernel.dk> <20101014233041.GJ2447@linux.vnet.ibm.com>
In-Reply-To: <20101014233041.GJ2447@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-15 01:30, Paul E. McKenney wrote:
> On Thu, Oct 14, 2010 at 02:44:32PM +0200, Jens Axboe wrote:
>> On 2010-10-14 08:07, KOSAKI Motohiro wrote:
>>>> @@ -1268,7 +1270,17 @@ static int __make_request(struct request
>>>>  		 * not touch req->buffer either...
>>>>  		 */
>>>>  		req->buffer = bio_data(bio);
>>>> +		src_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
>>>>  		req->__sector = bio->bi_sector;
>>>> +		dst_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
>>>
>>> I think this is wrong. disk_map_sector_rcu() require
>>> rcu read lock held (see function comment). all other call site take 
>>> part_stat_lock() before disk_map_sector_rcu() call.
>>
>> It's called under the queue lock with irqs disabled, which implies a
>> rcu critical section.
> 
> Having irqs disabled does imply an rcu_read_lock_sched() or an
> rcu_read_lock_bh(), but not an rcu_read_lock(), especially if
> CONFIG_PREEMPT_RCU.
> 
> So an explicit rcu_read_lock() does seem to be needed here.

Thanks Paul, I stand corrected. The final patch will be vastly
different, but it's surely worth keeping in mind.


-- 
Jens Axboe

