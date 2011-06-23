Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab1FWLlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:41:35 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33333 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759254Ab1FWLle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:41:34 -0400
Message-ID: <4E03266C.50408@kernel.dk>
Date: Thu, 23 Jun 2011 13:41:32 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] sched: Separate the scheduler entry for preemption
References: <20110622174659.496793734@linutronix.de> <20110622174918.813258321@linutronix.de> <20110622184328.GA6475@infradead.org> <4E0245A1.3090903@kernel.dk> <alpine.LFD.2.02.1106222211140.11814@ionos>
In-Reply-To: <alpine.LFD.2.02.1106222211140.11814@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-22 22:15, Thomas Gleixner wrote:
> On Wed, 22 Jun 2011, Jens Axboe wrote:
> 
>> On 2011-06-22 20:43, Christoph Hellwig wrote:
>>> On Wed, Jun 22, 2011 at 05:52:13PM -0000, Thomas Gleixner wrote:
>>>> Block-IO and workqueues call into notifier functions from the
>>>> scheduler core code with interrupts and preemption disabled. These
>>>> calls should be made before entering the scheduler core.
>>>>
>>>> To simplify this, separate the scheduler core code into
>>>> __schedule(). __schedule() is directly called from the places which
>>>> set PREEMPT_ACTIVE and from schedule(). This allows us to add the work
>>>> checks into schedule(), so they are only called when a task voluntary
>>>> goes to sleep.
>>>
>>> I don't think that works.  We'll need to flush the block requests even
>>> for an involuntary schedule.
>>
>> Yep, doing it just for voluntary schedule() is pointless, since the
>> caller should just do the flushing on his own. The whole point of the
>> sched hook was to ensure that involuntary schedules flushed it.
> 
> I guess we talk about different things here. The involuntary is when

Seems to be the trend for this patchset, why stop now? :-)

> you are preempted, which keeps state unchanged and the current code
> already excludes that case.
> 
> If you block on a mutex, semaphore, completion or whatever that's a
> different thing. That code calls schedule() not __schedule() and that
> will flush your stuff as it does now.

OK, thanks for the clarification. You are right, the original kernel did
not flush on eg preempt and that wasn't the intent either. The intent
was to flush on block only. So behaviour remains identical.

-- 
Jens Axboe

