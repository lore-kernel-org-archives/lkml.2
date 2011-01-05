Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1AEOJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:09:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1AEOJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:09:32 -0500
Message-ID: <4D247B93.2010900@redhat.com>
Date: Wed, 05 Jan 2011 15:09:23 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
References: <4CFF3DA4.5060705@jp.fujitsu.com> <4CFF9A2C.1070401@fusionio.com> <4D025154.8030400@redhat.com> <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com> <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com> <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com> <4D13810B.8000304@redhat.com> <20101224192916.GB2082@redhat.com> <4D23423A.60707@redhat.com> <4D2342E1.8010405@redhat.com> <4D247984.2030103@fusionio.com>
In-Reply-To: <4D247984.2030103@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 03:00 PM, Jens Axboe wrote:
> On 2011-01-04 16:55, Jerome Marchand wrote:
>> +	} else {
>> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>> +		if (!kref_test_and_get(&part->ref)) {
>> +			/*
>> +			 * The partition is already being removed,
>> +			 * the request will be accounted on the disk only
>> +			 *
>> +			 * We take a reference on disk->part0 although that
>> +			 * partition will never be deleted, so we can treat
>> +			 * it as any other partition.
>> +			 */
>> +			part = &rq->rq_disk->part0;
>> +			kref_get(&part->ref);
>> +		}
> 
> This still doesn't work. So you are inside the if {} block, you know
> what someone has dropped the last reference and the call_rcu() is being
> scheduled. Adding a reference now will not prevent 'part' from going
> away as soon as you do part_stat_unlock().

And what is the problem with that since we don't use 'part' (as returned
by disk_map_sector_rcu()), but disk->part0 instead?

> As per my last email, you
> need a check in the rcu callback to ensure that the ref is 0.
> 
> 

