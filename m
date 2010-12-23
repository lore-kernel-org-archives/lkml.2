Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0LWRET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:04:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab0LWRES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:04:18 -0500
Message-ID: <4D13810B.8000304@redhat.com>
Date: Thu, 23 Dec 2010 18:04:11 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <jaxboe@fusionio.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix accounting bug on cross partition merges
References: <4CFF3AD6.6010904@jp.fujitsu.com> <4CFF3C86.2070504@fusionio.com> <4CFF3DA4.5060705@jp.fujitsu.com> <4CFF9A2C.1070401@fusionio.com> <4D025154.8030400@redhat.com> <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com> <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com> <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com>
In-Reply-To: <20101223153915.GE9502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 04:39 PM, Vivek Goyal wrote:
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 4ce953f..72d12d2 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -64,13 +64,21 @@ static void drive_stat_acct(struct request *rq, int new_io)
>>  		return;
>>  
>>  	cpu = part_stat_lock();
>> -	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>>  
>> -	if (!new_io)
>> +	if (!new_io) {
>> +		part = rq->part;
>>  		part_stat_inc(cpu, part, merges[rw]);
>> -	else {
>> +	} else {
>> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>> +		if(part->partno && !kref_test_and_get(&part->ref))
>> +			/*
> 
> Do we have to check this part->partno both while taking and releasing
> reference. Can't we take one extra reference for disk->part0, at
> alloc_disk_node() time so that it is never freed and only freed when
> disk is going away and gendisk is being freed.
> 
> That way, you don't have to differentiate between disk->part0 and rest
> of the partitions while taking or dropping references.

We could do it in any way, as long as we don't end up trying to free
disk->part0. I choose not to touch part0->ref at all, but we could also
drop all the part->partno test, and get a reference on part0 when we use
it as a backup. I have no strong opinion about a way or an other.

Jerome

> 
> Thanks
> Vivek
