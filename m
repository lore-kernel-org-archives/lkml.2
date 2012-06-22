Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab2FVUWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:22:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33938 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FVUWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAKA=qzYYK5KUNsZ1C7Z7BEkqo-7uvn=HYr0N9KLPaLt9ut+MDQ@mail.gmail.com>
References: <CAKA=qzZQ0YkWXpi4gKYe5yFrR9EF3+G1Wq=kWybreLXx7D30oQ@mail.gmail.com>
	<20120307162851.GC13430@redhat.com>
	<4F57AF4A.6080703@kernel.dk>
	<CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
	<CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
	<20120308234016.GA925@redhat.com>
	<CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
	<CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
	<20120621203217.GC14095@redhat.com>
	<CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
	<20120622141211.GB18409@redhat.com>
	<CAKA=qzYYK5KUNsZ1C7Z7BEkqo-7uvn=HYr0N9KLPaLt9ut+MDQ@mail.gmail.com>
Date: Fri, 22 Jun 2012 15:22:01 -0500
Message-ID: <CAKA=qzY+u64vVZmbiH4zp_Fij2zejQBFUSNENKF=PZBT0G7xrQ@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Josh Hunt <joshhunt00@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 3:05 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
> On Fri, Jun 22, 2012 at 9:12 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Thu, Jun 21, 2012 at 04:11:18PM -0500, Josh Hunt wrote:
>>
>> [..]
>>> > say put some logs in select_queue() and see where did it bail out. That
>>>
>>> Well I did add some instrumentation in select_queue, the "keep_queue
>>> st->count:%d, dispatch:%u" line I mentioned above, but I will add more
>>> and retest.
>>
>> Actually before the stall we expired the current queue. That means there
>> is no active queue in cfq now. So keep_queue trace will help only if there
>> is an active queue and we decide to keep that queue.
>>
>>  8,0    0        0  4466.139959742     0  m   N cfq20720 del_from_rr
>>  8,0    0        0  4466.139963653     0  m   N cfq schedule dispatch
>>  8,0    1  1499521  4466.791207736  7570  A   R 7258191 + 8 <- (8,1)
>> 7258128
>>
>> Thing to figure out here is that why cfq is not picking a new queue
>> despite the fact there are pending requests and there is no active
>> queue (hence cfq is not obiviously not seeing that queue).
>>
>>>
>>> I'm attaching a similar run with no stalls when I set slice_idle to 0.
>>
>> At this point I am not sure why slice_idle=0 is not seeing this issue. It
>> does not see to be directly related to idling. Because when stall happens
>> CFQ is not idling on anything. It has expired active queue and for some
>> reason it thinks that I have no more requests to dispatch, so I have
>> nothing to do until a new request comes in.
>>
>> Thanks
>> Vivek
>
> Got some more info. It actually looks like every idle timer fire there
> is some sort of stall:
>
>  8,0    0        0  4807.015613266     0  m   N cfq idle timer fired
>  8,0    0        0  4807.015616897     0  m   N cfq7646
> idle_slice_timer: active queue
>  8,0    0        0  4807.015618853     0  m   N cfq7646
> idle_slice_timer: clear_cfqq_deep
>  8,0    0        0  4807.015620529     0  m   N cfq7646 slice expired t=0
>  8,0    0        0  4807.015622205     0  m   N cfq7646 del timer
>  8,0    0        0  4807.015623323     0  m   N cfq7646 update idle time stats
>  8,0    0        0  4807.015626396     0  m   N cfq7646 sl_used=8
> disp=1 charge=8 iops=0 sect=8
>  8,0    0        0  4807.015627793     0  m   N cfq7646 slice_expired
> del cfqq from rr
>  8,0    0        0  4807.015628910     0  m   N cfq7646 del_from_rr
>  8,0    0        0  4807.015630307     0  m   N cfq7646 slice_expired
> resort_rr_list
>  8,0    0        0  4807.015631983     0  m   N cfq7646 slice_expired
> setting active_queue to NULL
>  8,0    0        0  4807.015633380     0  m   N cfq7646 slice_expired
> setting active_cic to NULL
>  8,0    0   438262  4807.717719091  6076  A   W 1639679 + 8 <- (8,1) 1639616
>  8,0    0   438263  4807.717720767  6076  Q   W 1639679 + 8 [flush-8:0]
>  8,0    0   438264  4807.717727192  6076  G   W 1639679 + 8 [flush-8:0]
>  8,0    0   438265  4807.717730265  6076  P   N [flush-8:0]
>
> You can see in the attached log that it happens every timer fire to some extent.
>
> We get to here in the code:
> static void cfq_idle_slice_timer(unsigned long data)
> {
> ...
>                /*
>                 * Queue depth flag is reset only when the idle didn't succeed
>                 */
>                cfq_clear_cfqq_deep(cfqq);
>                cfq_log_cfqq(cfqd, cfqq, "idle_slice_timer: clear_cfqq_deep");
>        }
> expire:
>        cfq_slice_expired(cfqd, timed_out);
> out_kick:
>        cfq_schedule_dispatch(cfqd);
> out_cont:
>        spin_unlock_irqrestore(cfqd->queue->queue_lock, flags);
> }
>
> and from the traces we are going through cfq_slice_expired() and then
> cfq_schedule_dispatch(), but the schedule_dispatch print is not there,
> which means cfqd->busy_queues is false.
>
> static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
> {
>        if (cfqd->busy_queues) {
>                cfq_log(cfqd, "schedule dispatch");
>                kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
>        }
> }
>
> I'm still going through the traces, but figured I'd pass along this
> info for now. If we're stalling after every timer fire here, then it's
> understandable why I'm not seeing the stalls when I set slice_idle to
> 0.
>
> Will update if I have more. Let me know if there's something else
> you'd like me to instrument.
>
> --
> Josh

It looks like my statement about busy_queues isn't entirely accurate.
I'm seeing this later on in the trace:

  8,0    0        0  4842.798611807     0  m   N cfq idle timer fired
  8,0    0        0  4842.798614600     0  m   N cfq11441
idle_slice_timer: active queue
  8,0    0        0  4842.798616277     0  m   N cfq11441
idle_slice_timer: clear_cfqq_deep
  8,0    0        0  4842.798617674     0  m   N cfq11441 slice expired t=0
  8,0    0        0  4842.798619350     0  m   N cfq11441 del timer
  8,0    0        0  4842.798620747     0  m   N cfq11441 update idle time stats
  8,0    0        0  4842.798624658     0  m   N cfq11441 sl_used=8
disp=2 charge=8 iops=0 sect=16
  8,0    0        0  4842.798625775     0  m   N cfq11441
slice_expired del cfqq from rr
  8,0    0        0  4842.798627172     0  m   N cfq11441 del_from_rr
  8,0    0        0  4842.798628569     0  m   N cfq11441
slice_expired resort_rr_list
  8,0    0        0  4842.798629686     0  m   N cfq11441
slice_expired setting active_queue to NULL
  8,0    0        0  4842.798631083     0  m   N cfq11441
slice_expired setting active_cic to NULL
  8,0    0        0  4842.798632201     0  m   N cfq schedule dispatch
  8,0    1   296335  4842.809550488 11443  A   R 13463743 + 8 <- (8,2) 884848
  8,0    1   296336  4842.809552443 11443  Q   R 13463743 + 8 [cron]

So it is getting called at times.

-- 
Josh
