Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab0LXT32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 14:29:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab0LXT31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 14:29:27 -0500
Date: Fri, 24 Dec 2010 14:29:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix accounting bug on cross partition merges
Message-ID: <20101224192916.GB2082@redhat.com>
References: <4CFF3DA4.5060705@jp.fujitsu.com>
 <4CFF9A2C.1070401@fusionio.com>
 <4D025154.8030400@redhat.com>
 <20101210165553.GE31737@redhat.com>
 <4D07D2AC.6000500@fusionio.com>
 <4D0B68AF.80804@redhat.com>
 <4D0BB4A1.8080305@fusionio.com>
 <4D13664C.3020500@redhat.com>
 <20101223153915.GE9502@redhat.com>
 <4D13810B.8000304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D13810B.8000304@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 06:04:11PM +0100, Jerome Marchand wrote:
> On 12/23/2010 04:39 PM, Vivek Goyal wrote:
> >> diff --git a/block/blk-core.c b/block/blk-core.c
> >> index 4ce953f..72d12d2 100644
> >> --- a/block/blk-core.c
> >> +++ b/block/blk-core.c
> >> @@ -64,13 +64,21 @@ static void drive_stat_acct(struct request *rq, int new_io)
> >>  		return;
> >>  
> >>  	cpu = part_stat_lock();
> >> -	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
> >>  
> >> -	if (!new_io)
> >> +	if (!new_io) {
> >> +		part = rq->part;
> >>  		part_stat_inc(cpu, part, merges[rw]);
> >> -	else {
> >> +	} else {
> >> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
> >> +		if(part->partno && !kref_test_and_get(&part->ref))
> >> +			/*
> > 
> > Do we have to check this part->partno both while taking and releasing
> > reference. Can't we take one extra reference for disk->part0, at
> > alloc_disk_node() time so that it is never freed and only freed when
> > disk is going away and gendisk is being freed.
> > 
> > That way, you don't have to differentiate between disk->part0 and rest
> > of the partitions while taking or dropping references.
> 
> We could do it in any way, as long as we don't end up trying to free
> disk->part0. I choose not to touch part0->ref at all, but we could also
> drop all the part->partno test, and get a reference on part0 when we use
> it as a backup. I have no strong opinion about a way or an other.

Ok, I personally like taking an extra reference to disk->part0 and put
a proper comment there so that at rest of the places we don't try to
differentiate between part0 and other partitions. 

Having said that I am not too concerned about it. It is just one of the
minor details. So post the new version of patch after testing.

Thanks
Vivek
