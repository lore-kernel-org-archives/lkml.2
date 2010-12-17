Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0LQWcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:32:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab0LQWcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:32:10 -0500
Date: Fri, 17 Dec 2010 17:32:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix accounting bug on cross partition merges
Message-ID: <20101217223203.GN14502@redhat.com>
References: <4CFF34E7.2030401@fusionio.com>
 <4CFF3AD6.6010904@jp.fujitsu.com>
 <4CFF3C86.2070504@fusionio.com>
 <4CFF3DA4.5060705@jp.fujitsu.com>
 <4CFF9A2C.1070401@fusionio.com>
 <4D025154.8030400@redhat.com>
 <20101210165553.GE31737@redhat.com>
 <4D07D2AC.6000500@fusionio.com>
 <4D0B68AF.80804@redhat.com>
 <4D0BB4A1.8080305@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0BB4A1.8080305@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 08:06:09PM +0100, Jens Axboe wrote:
> On 2010-12-17 14:42, Jerome Marchand wrote:
> > 
> > /proc/diskstats would display a strange output as follows.
> 
> [snip]
> 
> This looks a lot better! One comment:
> 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 4ce953f..064921d 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -64,13 +64,16 @@ static void drive_stat_acct(struct request *rq, int new_io)
> >  		return;
> >  
> >  	cpu = part_stat_lock();
> > -	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
> >  
> > -	if (!new_io)
> > +	if (!new_io) {
> > +		part = rq->part;
> >  		part_stat_inc(cpu, part, merges[rw]);
> > -	else {
> > +	} else {
> > +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
> >  		part_round_stats(cpu, part);
> >  		part_inc_in_flight(part, rw);
> > +		kref_get(&part->ref);
> > +		rq->part = part;
> >  	}
> >  
> >  	part_stat_unlock();
> 
> I don't think this is completely safe. The rcu lock is held due to the
> part_stat_lock(), but that only prevents the __delete_partition()
> callback from happening. Lets say you have this:
> 
> CPU0                                         CPU1
> part = disk_map_sector_rcu()
>                                              kref_put(part); <- now 0
> part_stat_unlock()
>                                              __delete_partition();
>                                              ...
>                                              delete_partition_rcu_cb();
> merge, or endio, boom
> 
> Now rq has ->part pointing to freed memory, later merges or end
> accounting will touch freed memory.
> 
> I think we can fix this by just having delete_partition_rcu_rb() check
> the reference count and return if non-zero. Since someone holds a
> reference to the table, they will drop it and we'll re-schedule the rcu
> callback.

This is interesting. Using RCU with kref(). So even if somebody has done
a kref_put() and this is last reference, but rcu period is not over, somebody
can still go and take reference again and set it to 1 again and then
partition will not be freed as delete_partition_rcu_cb() will find it set.

I guess read shall have to be atomic_read() and struct kref is opaque so
one might have to introduce kref_read() or something like that and
possibly update Documentation/kref.txt for this usage of with RCU. I would
also recommend it to get it reviewed from  Paul McKenney to make sure this
usage of RCU is fine.

Thanks
Vivek
