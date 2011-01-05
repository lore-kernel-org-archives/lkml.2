Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab1AEORw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:17:52 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:48354 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1AEORv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:17:51 -0500
X-ASG-Debug-ID: 1294237070-71f7602d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D247D89.3090700@fusionio.com>
Date: Wed, 5 Jan 2011 15:17:45 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
References: <4CFF3DA4.5060705@jp.fujitsu.com> <4CFF9A2C.1070401@fusionio.com> <4D025154.8030400@redhat.com> <20101210165553.GE31737@redhat.com> <4D07D2AC.6000500@fusionio.com> <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com> <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com> <4D13810B.8000304@redhat.com> <20101224192916.GB2082@redhat.com> <4D23423A.60707@redhat.com> <4D2342E1.8010405@redhat.com> <4D247984.2030103@fusionio.com> <4D247B93.2010900@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
In-Reply-To: <4D247B93.2010900@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294237070
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.41
X-Barracuda-Spam-Status: No, SCORE=0.41 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=SUBJECT_FUZZY_TION
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.51502
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.41 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-05 15:09, Jerome Marchand wrote:
> On 01/05/2011 03:00 PM, Jens Axboe wrote:
>> On 2011-01-04 16:55, Jerome Marchand wrote:
>>> +	} else {
>>> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>>> +		if (!kref_test_and_get(&part->ref)) {
>>> +			/*
>>> +			 * The partition is already being removed,
>>> +			 * the request will be accounted on the disk only
>>> +			 *
>>> +			 * We take a reference on disk->part0 although that
>>> +			 * partition will never be deleted, so we can treat
>>> +			 * it as any other partition.
>>> +			 */
>>> +			part = &rq->rq_disk->part0;
>>> +			kref_get(&part->ref);
>>> +		}
>>
>> This still doesn't work. So you are inside the if {} block, you know
>> what someone has dropped the last reference and the call_rcu() is being
>> scheduled. Adding a reference now will not prevent 'part' from going
>> away as soon as you do part_stat_unlock().
> 
> And what is the problem with that since we don't use 'part' (as returned
> by disk_map_sector_rcu()), but disk->part0 instead?

Ugh, I'm the one who's blind now. part0 is indeed fine, I didn't read
that carefully enough.

So I think your patch looks safe now, I don't see any holes in it.
Whether we move the kref to inside the lookup or not, that doesn't
change anything wrt using an atomic_inc_not_zero(). Can you resend 1/2
with the manual barriers removed?

-- 
Jens Axboe

