Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0LQTGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:06:18 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:47781 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab0LQTGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:06:17 -0500
X-ASG-Debug-ID: 1292612774-0f2719540001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D0BB4A1.8080305@fusionio.com>
Date: Fri, 17 Dec 2010 20:06:09 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix accounting bug on cross partition merges
References: <4CFCB08F.4010509@jp.fujitsu.com> <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com> <4CFDDFC3.2070107@jp.fujitsu.com> <4CFF34E7.2030401@fusionio.com> <4CFF3AD6.6010904@jp.fujitsu.com> <4CFF3C86.2070504@fusionio.com> <4CFF3DA4.5060705@jp.fujitsu.com> <4CFF9A2C.1070401@fusionio.com> <4D025154.8030400@redhat.com> <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com> <4D0B68AF.80804@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] block: fix accounting bug on cross partition merges
In-Reply-To: <4D0B68AF.80804@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292612774
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.41
X-Barracuda-Spam-Status: No, SCORE=0.41 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=SUBJECT_FUZZY_TION
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.49716
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.41 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-17 14:42, Jerome Marchand wrote:
> 
> /proc/diskstats would display a strange output as follows.

[snip]

This looks a lot better! One comment:

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4ce953f..064921d 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -64,13 +64,16 @@ static void drive_stat_acct(struct request *rq, int new_io)
>  		return;
>  
>  	cpu = part_stat_lock();
> -	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>  
> -	if (!new_io)
> +	if (!new_io) {
> +		part = rq->part;
>  		part_stat_inc(cpu, part, merges[rw]);
> -	else {
> +	} else {
> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>  		part_round_stats(cpu, part);
>  		part_inc_in_flight(part, rw);
> +		kref_get(&part->ref);
> +		rq->part = part;
>  	}
>  
>  	part_stat_unlock();

I don't think this is completely safe. The rcu lock is held due to the
part_stat_lock(), but that only prevents the __delete_partition()
callback from happening. Lets say you have this:

CPU0                                         CPU1
part = disk_map_sector_rcu()
                                             kref_put(part); <- now 0
part_stat_unlock()
                                             __delete_partition();
                                             ...
                                             delete_partition_rcu_cb();
merge, or endio, boom

Now rq has ->part pointing to freed memory, later merges or end
accounting will touch freed memory.

I think we can fix this by just having delete_partition_rcu_rb() check
the reference count and return if non-zero. Since someone holds a
reference to the table, they will drop it and we'll re-schedule the rcu
callback.


-- 
Jens Axboe

