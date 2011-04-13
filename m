Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab1DMLXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 07:23:31 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:58684 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420Ab1DMLXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:23:30 -0400
X-ASG-Debug-ID: 1302693808-03d6a5652ca12c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA587AF.2040308@fusionio.com>
Date: Wed, 13 Apr 2011 13:23:27 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        Dave Chinner <david@fromorbit.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110411223623.4278fad1@notabene.brown>	 <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org>	 <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard>	 <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard>	 <4DA44C86.3090305@fusionio.com> <20110412133117.GE31057@dastard>	 <4DA45790.2010109@fusionio.com> <20110412143452.GH31057@dastard>	 <20110413070827.11b2a71d@notabene.brown>	 <BANLkTikBEJa7bJJoLFU7NoiEgOjVHVG08A@mail.gmail.com> <1302693122.2035.20.camel@laptop>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <1302693122.2035.20.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302693808
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60729
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-13 13:12, Peter Zijlstra wrote:
> On Tue, 2011-04-12 at 19:23 -0700, Linus Torvalds wrote:
>>  kernel/sched.c |   20 ++++++++++----------
>>  1 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 48013633d792..a187c3fe027b 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -4111,20 +4111,20 @@ need_resched:
>>                                         try_to_wake_up_local(to_wakeup);
>>                         }
>>                         deactivate_task(rq, prev, DEQUEUE_SLEEP);
>> +
>> +                       /*
>> +                        * If we are going to sleep and we have plugged IO queued, make
>> +                        * sure to submit it to avoid deadlocks.
>> +                        */
>> +                       if (blk_needs_flush_plug(prev)) {
>> +                               raw_spin_unlock(&rq->lock);
>> +                               blk_flush_plug(prev);
>> +                               raw_spin_lock(&rq->lock);
>> +                       }
>>                 }
>>                 switch_count = &prev->nvcsw;
>>         }
>>  
>> -       /*
>> -        * If we are going to sleep and we have plugged IO queued, make
>> -        * sure to submit it to avoid deadlocks.
>> -        */
>> -       if (prev->state != TASK_RUNNING && blk_needs_flush_plug(prev)) {
>> -               raw_spin_unlock(&rq->lock);
>> -               blk_flush_plug(prev);
>> -               raw_spin_lock(&rq->lock);
>> -       }
>> -
>>         pre_schedule(rq, prev);
>>  
>>         if (unlikely(!rq->nr_running)) 
> 
> Right, that cures the preemption problem. The reason I suggested placing
> it where it was is that I'd like to keep all things that release
> rq->lock in the middle of schedule() in one place, but I guess we can
> cure that with some extra comments.

We definitely only want to do it on going to sleep, not preempt events.
So if you are fine with this change, then lets please do that.

Linus, I've got a few other things queued up in the area, I'll add this
and send them off soon. Or feel free to add this one yourself, since you
already did it.


-- 
Jens Axboe

