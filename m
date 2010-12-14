Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0LNVnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:43:16 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:46173
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672Ab0LNVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:43:14 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK936eK1432N98dNzz1202hzzz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D07E4C0.6050504@am.sony.com>
Date: Tue, 14 Dec 2010 13:42:24 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Chris Mason <chris.mason@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH RFC] reduce runqueue lock contention
References: <20100520204810.GA19188@think>	 <1277114522.1875.469.camel@laptop>  <1277117647.1875.503.camel@laptop>	 <1277125479.1875.510.camel@laptop>  <4D06D968.9070004@am.sony.com> <1292298145.7448.38.camel@marge.simson.net>
In-Reply-To: <1292298145.7448.38.camel@marge.simson.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/10 19:42, Mike Galbraith wrote:
> On Mon, 2010-12-13 at 18:41 -0800, Frank Rowand wrote:
>> On 06/21/10 06:04, Peter Zijlstra wrote:
>>> On Mon, 2010-06-21 at 12:54 +0200, Peter Zijlstra wrote:
>>>>> It looses the ttwu task_running() check, as I must admit I'm not quite
>>>>> sure what it does.. Ingo?
>>>
>>> I think I figured out what its for, its for when p is prev in schedule()
>>> after deactivate_task(), we have to call activate_task() it again, but
>>> we cannot migrate the task because the CPU its on is still referencing
>>> it.
>>
>> I have not been able to make sense of the task_running() check in
>> try_to_wake_up(), even with that clue.  The try_to_wake_up() code in
>> question is:
>>
>>         rq = task_rq_lock(p, &flags);
>>         if (!(p->state & state))
>>                 goto out;
>>
>>         if (p->se.on_rq)
>>                 goto out_running;
>>
>>         cpu = task_cpu(p);
>>         orig_cpu = cpu;
>>
>> #ifdef CONFIG_SMP
>>         if (unlikely(task_running(rq, p)))
>>                 goto out_activate;
>>
>>
>> The relevent code in schedule() executes with the rq lock held (many
>> lines left out to emphasize the key lines):

Additional lines added here to show the function call that Mike pointed out:

>>
>>         raw_spin_lock_irq(&rq->lock);
>>
>>         if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>>
>>                        deactivate_task(rq, prev, DEQUEUE_SLEEP);

           }
           pre_schedule(rq, prev);
           if (unlikely(!rq->nr_running))
                   idle_balance(cpu, rq);

>>
>>         if (likely(prev != next)) {
>>                 rq->curr = next;
>>                 context_switch(rq, prev, next); /* unlocks the rq */
>>         } else
>>                 raw_spin_unlock_irq(&rq->lock);
>>
>>
>> If (p->se.on_rq) can becomes false due to deactivate_task()
>> then task_running() will also become false while the rq lock is still
>> held (either via "rq->curr = next" or via context_switch() updating
>> p->oncpu -- which one matters depends on #ifdef __ARCH_WANT_UNLOCKED_CTXSW).
>>
>> I  haven't been able to find any case where task_running() can be true
>> when (p->se.on_rq) is false, while the rq lock is not being held.  Thus
>> I don't think the branch to out_activate will ever be taken.
>>
>> What am I missing, or is the task_running() test not needed?
> 
> Say the last runnable task passes through schedule(), is deactivated.
> We hit idle_balance(), which drops/retakes rq->lock _before_ the task
> schedules off.  ttwu() can acquire rq->lock in that window, p->se.on_rq
> is false, p->state is true, as is task_current(rq, p).
> 
> We have to check whether the task is still current, but not enqueued,
> lest the wakeup be a noop, and the wakee possibly then sleep forever.

Thanks Mike, that's just the cluebat I needed!

And for the lkml archives, in case anyone has this question again in the
future, with Mike's clue in hand I found another case in this window where
the rq->lock can be dropped then reacquired.  Just before idle_balance()
is called, pre_schedule() is called:

pre_schedule()
   prev->sched_class->pre_schedule(rq, prev)
   [pre_schedule_rt()]
      pull_rt_task(rq)
      pull_rt_task[this_rq]
         for_each_cpu(cpu, this_rq->rd->rto_mask)
            double_lock_balance(this_rq, src_rq)
               raw_spin_unlock(&this_rq->lock)        <-----
               double_rq_lock(this_rq, busiest)

-Frank

