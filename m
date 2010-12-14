Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab0LNUrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:47:20 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:38534 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759737Ab0LNUrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:47:19 -0500
X-ASG-Debug-ID: 1292358321-6da39f7d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D07D2AC.6000500@fusionio.com>
Date: Tue, 14 Dec 2010 21:25:16 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jerome Marchand <jmarchan@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
References: <4CFCB08F.4010509@jp.fujitsu.com> <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com> <4CFDDFC3.2070107@jp.fujitsu.com> <4CFF34E7.2030401@fusionio.com> <4CFF3AD6.6010904@jp.fujitsu.com> <4CFF3C86.2070504@fusionio.com> <4CFF3DA4.5060705@jp.fujitsu.com> <4CFF9A2C.1070401@fusionio.com> <4D025154.8030400@redhat.com> <20101210165553.GE31737@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 1/2] Don't merge different partition's IOs
In-Reply-To: <20101210165553.GE31737@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292358321
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4866 1.0000 0.0000
X-Barracuda-Spam-Score: 0.41
X-Barracuda-Spam-Status: No, SCORE=0.41 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=SUBJECT_FUZZY_TION
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.49434
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.41 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-10 17:55, Vivek Goyal wrote:
> On Fri, Dec 10, 2010 at 05:12:04PM +0100, Jerome Marchand wrote:
>> On 12/08/2010 03:46 PM, Jens Axboe wrote:
>>>
>>> No, that's not it at all. What I mean (and what was reverted) was
>>> caching the partition lookup, and using that for the stats. The problem
>>> with that approach turned out to be the elevator queiscing logic not
>>> being fully correct. One easier way to fix that would be to reference
>>> count the part stats, instead of having to drain the queue.
>>>
>>
>> The partition is already deleted in a rcu callback function. If I
>> understand RCU correctly, we just need to use rcu_dereference() each time
>> we use rq->part. Something like the following *untested* patch.
> 
> Jerome,
> 
> I don't think that rcu_dereference() is going to solve the problem. The
> partition table will be freed as soon as one rcu period is over. So to
> make sure partition table is not freed one has to be holding
> rcu_read_lock(). It is not a good idea to keep rcu period going till
> request finishes so a better idea will to to reference count it.

Exactly. The only change you would do to partition handling is ensure
that each io grabs a reference to it and drops it at the end. You need
not even do that in the core bits outside each IO, we just need to
ensure that the partition struct persists in memory even if it is no
longer the valid partition table. The rcu call to free the memory would
happen when the ref drops to zero.

What Vivek says it completely correct, and rcu_dereference() would only
help if you also had rcu_read_lock() over each IO. That is not feasible
at all.


-- 
Jens Axboe

