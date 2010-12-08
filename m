Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab0LHHeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:34:10 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:35543 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab0LHHeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:34:08 -0500
X-ASG-Debug-ID: 1291793646-6da313a20001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CFF34E7.2030401@fusionio.com>
Date: Wed, 8 Dec 2010 15:33:59 +0800
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "jmarchan@redhat.com" <jmarchan@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
References: <4CFCB08F.4010509@jp.fujitsu.com> <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com> <4CFDDFC3.2070107@jp.fujitsu.com>
X-ASG-Orig-Subj: Re: [PATCH 1/2] Don't merge different partition's IOs
In-Reply-To: <4CFDDFC3.2070107@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1291793646
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.2964 1.0000 -0.3635
X-Barracuda-Spam-Score: 0.05
X-Barracuda-Spam-Status: No, SCORE=0.05 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=SUBJECT_FUZZY_TION
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.48807
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.41 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-07 15:18, Satoru Takeuchi wrote:
> Hi Linus, Yasuaki,  and Jens
> 
> (2010/12/07 1:08), Linus Torvalds wrote:
>> 2010/12/6 Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>:
>>>
>>> The problem is caused by merging different partition's I/Os. So the patch
>>> check whether a merging bio or request is a same partition as a request or not
>>> by using a partition's start sector and size.
>>
>> I really think this is wrong.
>>
>> We should just carry the partition information around in the req and
>> the bio, and just compare the pointers, rather than compare the range.
>> No need to even dereference the pointers, you should be able to just
>> do
>>
>>     /* don't merge if not on the same partition */
>>     if (bio->part != req->part)
>>        return 0;
>>
>> or something.
>>
>> This is doubly true since the accounting already does that horrible
>> partition lookup: rather than look it up, we should just _set_ it in
>> __generic_make_request(), where I think we already know it since we do
>> that whole blk_partition_remap().
>>
>> So just something like the appended (TOTALLY UNTESTED) perhaps?
>>
>> Note that this should get it right even for overlapping partitions etc.
>>
>>                       Linus
> 
> The problem can occur even if your patches are applied. Think about a case
> like the following.
> 
>   1) There are 2 partition, sda1 and sda2, on sda.
>   2) Open sda and issue an IO to sda2's first sector. Then sda2's in_flight
>      is incremented though you open not sda2 but sda. It is because of
>      partition lookup method. It is based on which partition rq->__sector
>      sector belongs to.
>   3) Issue an IO to sda1's last sector and it merged to the IO issued in
>      step (2) because their part are both sda. In addition, rq->__sector
>      is modified to the sda1's region.
>   4) After completing the IO, sda1's in_flight is decremented and diskstat
>      is corrupted here.
> 
> I think fixing this case is difficult and would cause more complexity.
> 
> I hit on another approach. Although it doesn'tprevent any merge as Linus
> preferred, it can fix the problem anyway. In this idea, in_flight is
> incremented and decremented for the partition which the request belonged
> to in its creation. It has the following merits.

I really would prefer if we fixed up the patchset we ended up reverting.
At least that had a purpose with growing struct request, since we saved
on doing the partition lookups.

-- 
Jens Axboe

