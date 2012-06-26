Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab2FZEBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:01:51 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62562 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2FZEBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAKA=qzaU=wKLrprgJ4z32tqqyO6W0+SBcaV=ArWAdKh_9c=Zew@mail.gmail.com>
References: <CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
	<20120622141211.GB18409@redhat.com>
	<CAKA=qzYYK5KUNsZ1C7Z7BEkqo-7uvn=HYr0N9KLPaLt9ut+MDQ@mail.gmail.com>
	<CAKA=qzY+u64vVZmbiH4zp_Fij2zejQBFUSNENKF=PZBT0G7xrQ@mail.gmail.com>
	<20120622204207.GA22063@redhat.com>
	<CAKA=qzbycm0cjLyiuKaKkD8sxDm5DvX9WVqSxN2QVT2WZOzU0Q@mail.gmail.com>
	<CAKA=qza_s6zr+wZzfFTVPSzgPQAov=K63jf-SJOTDcrnDELY5w@mail.gmail.com>
	<CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
	<20120625133047.GA9394@redhat.com>
	<CAKA=qzbXm7LaDziH=cms1W5X+cwNNRkG0LNFfWKEppr2oht6_w@mail.gmail.com>
	<20120625211850.GC10916@redhat.com>
	<CAKA=qzaU=wKLrprgJ4z32tqqyO6W0+SBcaV=ArWAdKh_9c=Zew@mail.gmail.com>
Date: Mon, 25 Jun 2012 23:01:48 -0500
Message-ID: <CAKA=qzY+J-Ab8NC-+r1Dw_-giVzC=z8SnxJhSWHF-ud8j3yg6A@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Josh Hunt <joshhunt00@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 6:05 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
> On Mon, Jun 25, 2012 at 4:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Mon, Jun 25, 2012 at 11:22:32AM -0500, Josh Hunt wrote:
>>> On Mon, Jun 25, 2012 at 8:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> > On Fri, Jun 22, 2012 at 04:34:07PM -0500, Josh Hunt wrote:
>>> >
>>> > [..]
>>> >> Shouldn't the queue stay on the RR list until it is empty?
>>> >
>>> > This does look odd. cfqq should stay on service tree as long as it has
>>> > requests.
>>> >
>>> > Can you attach the full log again. Also make sure that blktrace is not
>>> > dropping any trace events.
>>> >
>>> > In slice_expire() we check following.
>>> >
>>> >        if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
>>> >                cfq_del_cfqq_rr(cfqd, cfqq);
>>> >
>>> > So for some reason RB_EMPTY_ROOT() is returning true. But we must have
>>> > added the request and it should not have been empty.
>>> >
>>> > cfq_insert_request()
>>> >  cfq_add_rq_rb()
>>> >    elv_rb_add()
>>> >
>>> > So may be little more tracing after request addition will help. Just check
>>> > that RB_EMPTY_ROOT() is not true after addition of request and also print
>>> > number of requests queued.
>>> >
>>> > In slice_expired() we can probably put a BUG_ON() which checks following.
>>> >
>>> > BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list) && (cfqq->queued[0] || cfqq->queued[1]));
>>> >
>>> > Thanks
>>> > Vivek
>>>
>>> Vivek
>>>
>>> First off thanks for all the time you've spent helping me on this :)
>>>
>>> I'm attaching the log. I will add more instrumentation based on your
>>> mail and let you know the results.
>>
>> I suspect that cfq5917 are actually two queues. One sync and other async.
>> In latest kernels, trace messages append "A" or "S" in queue name to
>> represent async/sync queue. Why do I think so.
>>
>> - I see that cfq5917 has dispatched both "W" and "R" requests. "R" don't
>>  get queued in sync queues and vice a versa.
>>
>> - Once cfq5917 has preempted cfq5917. A queue can't preempt itself.
>>
>>  8,0    1   296615  4847.030318652  5917  I   R 1572951 + 8 (    2793)
>> [syslogd]
>>  8,0    1        0  4847.030321446     0  m   N cfq5917 insert_request
>>  8,0    1        0  4847.030323122     0  m   N cfq5917 add_to_rr
>>  8,0    1        0  4847.030325636     0  m   N cfq5917 preempt
>>  8,0    1        0  4847.030327033     0  m   N cfq5917 slice expired t=1
>>  8,0    1        0  4847.030328710     0  m   N cfq5917 resid=39
>>  8,0    1        0  4847.030331783     0  m   N cfq5917 sl_used=1 disp=7
>> charge=1 iops=0 sect=96
>>
>> Hence I think that it is just a chance that both sync and async queues
>> have got same cfqq->pid. If you just append anohter character to represent
>> sync and async property of queue, that can cofirm it.
>>
>> Thanks
>> Vivek
>
> You are right about the sync/async queues :) The idea that the queue
> was being deleted with requests still on it was incorrect. I've
> attached an updated log with some more details. It's starting to seem
> like the problem is that the kblockd thread is not kicking the queue.
> I will try and look in that direction some more.
>
> --
> Josh

So this really seems like a problem with kblockd not kicking in. I've
instrumented every path in select_queue and it's not getting hit after
schedule dispatch. Everything seems to stall at that point until a new
request comes in.

In the previous log I attached I see the following:

Insert:
  8,0    1    12593   443.141157429  5853  I   W 2132327 + 8 (
17879) [syslogd]
  8,0    1        0   443.141159385     0  m   N cfq5853A insert_request
  8,0    1        0   443.141160782     0  m   N cfq5853A cfq_add_rq_rb: sync:0
  8,0    1        0   443.141161899     0  m   N cfq5853A add_to_rr
  8,0    1        0   443.141164134     0  m   N cfq7591S Idling on
sync. st->count:1
  8,0    1        0   443.141165810     0  m   N cfq5853A
insert_request: rb_empty_root:0 queued[0]:1 [1]:0
  8,0    1    12594   443.141166928  5853  U   N [syslogd] 1

Stall:
  8,0    0        0   443.677751758     0  m   N cfq idle timer fired
  8,0    0        0   443.677754272     0  m   N cfq7591S
idle_slice_timer: active queue
  8,0    0        0   443.677755949     0  m   N cfq7591S
idle_slice_timer: clear_cfqq_deep
  8,0    0        0   443.677757625     0  m   N cfq7591S slice expired t=0
  8,0    0        0   443.677759301     0  m   N cfq7591S del timer
  8,0    0        0   443.677760698     0  m   N cfq7591S update idle time stats
  8,0    0        0   443.677763212     0  m   N cfq7591S sl_used=13
disp=12 charge=13 iops=0 sect=96
  8,0    0        0   443.677764888     0  m   N cfq7591S
slice_expired del cfqq from rr - on_rr:1 rb empty:1
  8,0    0        0   443.677766285     0  m   N cfq7591S del_from_rr
queued[0]:0 queued[1]:0
  8,0    0        0   443.677767682     0  m   N cfq7591S
slice_expired resort_rr_list
  8,0    0        0   443.677769079     0  m   N cfq7591S
slice_expired setting active_queue to NULL
  8,0    0        0   443.677771314     0  m   N cfq7591S
slice_expired setting active_cic to NULL
  8,0    0        0   443.677772431     0  m   N cfq schedule dispatch
  8,0    1    12761   446.156017951  7591  A   R 2151 + 8 <- (8,1) 2088

Dispatch:
  8,0    0        0   449.232185100     0  m   N cfq5853A dispatched a request
  8,0    1    13089   449.232185938  8053  Q   R 14575511 + 16 [bash]
  8,0    0        0   449.232186776     0  m   N cfq5853A activate rq, drv=1
  8,0    0    52929   449.232188173  7251  D   W 2132327 + 8
(6091030744) [testd]

Here is what I believe is happening. When the idle timer fires it goes
through cfq_idle_slice_timer() at the end of which it calls
cfq_slice_expired() and then cfq_schedule_dispatch(). Everything up to
this point appears to behave correctly based on the traces I've
captured. The only thing which does not work is the kblockd thread
never seems to call cfq_kick_queue(). At this point we're relying on
the kblockd thread to get things going again, but for whatever reason
it does not. This causes us to stall until a new request comes in
which seems to wake everything up until the next time a timer fires.

I do see that kblockd kicks in correctly sometimes:

  8,0    0        0   442.285752298     0  m   N cfq idle timer fired
  8,0    0        0   442.285756209     0  m   N cfq8050S
idle_slice_timer: active queue
  8,0    0        0   442.285758165     0  m   N cfq8050S
idle_slice_timer: clear_cfqq_deep
  8,0    0        0   442.285760120     0  m   N cfq8050S slice expired t=0
  8,0    0        0   442.285762076     0  m   N cfq8050S del timer
  8,0    0        0   442.285763473     0  m   N cfq8050S update idle time stats
  8,0    0        0   442.285766546     0  m   N cfq8050S sl_used=8
disp=1 charge=8 iops=0 sect=8
  8,0    0        0   442.285768222     0  m   N cfq8050S
slice_expired del cfqq from rr - on_rr:1 rb empty:1
  8,0    0        0   442.285769619     0  m   N cfq8050S del_from_rr
queued[0]:0 queued[1]:0
  8,0    0        0   442.285771295     0  m   N cfq8050S
slice_expired resort_rr_list
  8,0    0        0   442.285772692     0  m   N cfq8050S
slice_expired setting active_queue to NULL
  8,0    0        0   442.285774927     0  m   N cfq8050S
slice_expired setting active_cic to NULL
  8,0    0        0   442.285776603     0  m   N cfq schedule dispatch
  8,0    0        0   443.083035229     0  m   N cfq kick queue
  8,0    0        0   443.083038302     0  m   N cfq select_queue: !cfqq

Here you can see schedule dispatch is called and then we see kick
queue, etc. There is still ~800ms b/f the queue is kicked, but at
least it does kick the queue in this instance.

I do not see the stalls when I set slice_idle to 0. With slice_idle
set to 0 we do not traverse the path through cfq_idle_slice_timer(),
and it appears we do not rely on kblockd to get things going for us as
much?

The last kernel where we did not see stalls of this magnitude was
2.6.32. I believe there was some reworking of the workqueue infra
after this point and I'm wondering if this may be causing the issue?

Thoughts?
-- 
Josh
