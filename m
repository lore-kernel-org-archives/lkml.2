Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab1AEViZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:38:25 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:51170 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1AEViY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:38:24 -0500
X-ASG-Debug-ID: 1294263501-71f766440001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D24E4C7.30906@fusionio.com>
Date: Wed, 5 Jan 2011 22:38:15 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jerome Marchand <jmarchan@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
References: <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com> <4D13810B.8000304@redhat.com> <20101224192916.GB2082@redhat.com> <4D23423A.60707@redhat.com> <4D2342E1.8010405@redhat.com> <20110104210011.GB4180@kroah.com> <4D247867.9040502@fusionio.com> <20110105155816.GD2072@kroah.com> <4D24BC88.4090804@fusionio.com> <20110105200825.GA11372@kroah.com>
X-ASG-Orig-Subj: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
In-Reply-To: <20110105200825.GA11372@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294263501
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.41
X-Barracuda-Spam-Status: No, SCORE=0.41 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=SUBJECT_FUZZY_TION
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.51532
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.41 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-05 21:08, Greg KH wrote:
> On Wed, Jan 05, 2011 at 07:46:32PM +0100, Jens Axboe wrote:
>> On 2011-01-05 16:58, Greg KH wrote:
>>> On Wed, Jan 05, 2011 at 02:55:51PM +0100, Jens Axboe wrote:
>>>> On 2011-01-04 22:00, Greg KH wrote:
>>>>> On Tue, Jan 04, 2011 at 04:55:13PM +0100, Jerome Marchand wrote:
>>>>>> Also add a refcount to struct hd_struct to keep the partition in
>>>>>> memory as long as users exist. We use kref_test_and_get() to ensure
>>>>>> we don't add a reference to a partition which is going away.
>>>>>
>>>>> No, don't do this, use a kref correctly and no such function should be
>>>>> needed.
>>>>>
>>>>>> +	} else {
>>>>>> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>>>>>
>>>>> That is the function that should properly increment the reference count
>>>>> on the object.  If the object is "being removed", then it will return
>>>>> NULL and you need to check that.  Do that and you do not need to add:
>>>>
>>>> It doesn't matter if you do it in there of after the fact, since the
>>>> "lock" (RCU) is being held across the call. See my original suggestion
>>>> here:
>>>>
>>>> https://lkml.org/lkml/2010/12/17/275
>>>
>>> Ok, that's fine, just do it without adding that kref function and I have
>>> no objection :)
>>
>> Why? The code is perfectly fine. I originally objected to making an API
>> like this for simple reference counting - seems I was right. Please
>> actually look at the code and use. Alexey asked whether this was a toy
>> API or a real one, I'd like to know that as well. If this is meant just
>> for very basic get/put references, fine, then document that. But then
>> what's the point of having this API in the first place?
> 
> The point is that you shouldn't have to roll your own reference count
> code all over the place, 99% of the time, you should just use the
> debugged, and documented, interface that the kernel provides with the
> kref interface.
> 
> As for it being a "toy", it properly handles a very large majority of
> the kernel reference counting logic today, in a race-free manner, so I
> would not call that a "toy" at all.

Dunno, then perhaps pointless. It's not like the API is saving lots of
typing or easier to use than just atomics, imho.

> Just use it properly.  As this patch series points out, adding this type

By adding pointless locks? Your suggestion of doing the referencing
inside the function being called is moot, since RCU is held off over the
call. The point of the addition to the API is to _not_ grab a reference
if someone has done the final put. We know that the RCU grace period has
not ended, so the kref is valid. But if it is going away _in the future_
after we drop the part lock, then we don't want a reference to it.

So to "use it properly", I would have to slow down a fast path. No
thanks.

> of function to the api is not a good idea, as it will be incorrect when
> used.

The code is fine, the use is fine. I think the only thing we have
established here is that Jerome made the mistake of using the kref API
for this. I'll rewrite that part to handle its own references.

-- 
Jens Axboe

