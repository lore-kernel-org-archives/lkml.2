Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762732Ab2FVVeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:34:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57722 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2FVVeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAKA=qza_s6zr+wZzfFTVPSzgPQAov=K63jf-SJOTDcrnDELY5w@mail.gmail.com>
References: <CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
	<CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
	<20120308234016.GA925@redhat.com>
	<CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
	<CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
	<20120621203217.GC14095@redhat.com>
	<CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
	<20120622141211.GB18409@redhat.com>
	<CAKA=qzYYK5KUNsZ1C7Z7BEkqo-7uvn=HYr0N9KLPaLt9ut+MDQ@mail.gmail.com>
	<CAKA=qzY+u64vVZmbiH4zp_Fij2zejQBFUSNENKF=PZBT0G7xrQ@mail.gmail.com>
	<20120622204207.GA22063@redhat.com>
	<CAKA=qzbycm0cjLyiuKaKkD8sxDm5DvX9WVqSxN2QVT2WZOzU0Q@mail.gmail.com>
	<CAKA=qza_s6zr+wZzfFTVPSzgPQAov=K63jf-SJOTDcrnDELY5w@mail.gmail.com>
Date: Fri, 22 Jun 2012 16:34:07 -0500
Message-ID: <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Josh Hunt <joshhunt00@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 3:57 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
> On Fri, Jun 22, 2012 at 3:53 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
>> On Fri, Jun 22, 2012 at 3:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> On Fri, Jun 22, 2012 at 03:22:01PM -0500, Josh Hunt wrote:
>>>
>>> [..]
>>>> It looks like my statement about busy_queues isn't entirely accurate.
>>>> I'm seeing this later on in the trace:
>>>
>>> Yes it is being called some times. But it is interesting to see that in
>>> the instance you pasted in last mail, we did not see "schedule_dispatch"
>>> message.  Are you sure that other requests were queued at that point of
>>> time and there were busy_queues? You can try printing cfqd->rq_queued
>>> to verify that.
>>>
>>> Also put some message in cfq_select_queue() to see why it did not select
>>> a new queue before the stall.
>>>
>>> Thanks
>>> Vivek
>>
>> I think you may be correct that at those points in time there weren't
>> any busy queues. I do know that there were requests waiting during
>> this time:
>
> Sorry. Please disregard the prev mail. Looks like I must have scrolled
> my buffer while pasting in the traces... Here's what I meant to send:
>
> Insert:
>  8,0    1   296677  4847.796879805  6076  P   N [flush-8:0]
>  8,0    1   296678  4847.796881202  6076  I   W 32800441 + 8 (
> 2794) [flush-8:0]
>  8,0    1        0  4847.796883157     0  m   N cfq5917 insert_request
>  8,0    1   296679  4847.796884834  6076  U   N [flush-8:0] 1
>  8,0    1   296680  4847.796901037  6076  A   R 32499249 + 8 <- (8,3) 11534424
>  8,0    1   296681  4847.796902154  6076  Q   R 32499249 + 8 [flush-8:0]
>  8,0    1   296682  4847.796904389  6076  G   R 32499249 + 8 [flush-8:0]
>  8,0    1   296683  4847.796906066  6076  I   R 32499249 + 8 (
> 1677) [flush-8:0]
>  8,0    1        0  4847.796907462     0  m   N cfq6076 insert_request
>  8,0    1        0  4847.796908859     0  m   N cfq6076 add_to_rr
>
>
> Stall:
>  8,0    1        0  4847.816870313     0  m   N cfq7646 insert_request
>  8,0    1        0  4847.816873665     0  m   N cfq7646 del timer
>  8,0    1        0  4847.816874783     0  m   N cfq7646 update idle time stats
>  8,0    1        0  4847.816876738     0  m   N cfq7646 select_queue:
> active requests/not expired - keep_queue
>  8,0    1        0  4847.816878414     0  m   N cfq7646 Idling on
> sync. st->count:1
>  8,0    1        0  4847.816879811     0  m   N cfq7646 dispatch_insert
>  8,0    1        0  4847.816882046     0  m   N cfq7646 remove request
>  8,0    1        0  4847.816884002     0  m   N cfq7646 dispatched a request
>  8,0    1        0  4847.816885399     0  m   N cfq7646 activate rq, drv=1
>  8,0    1   296748  4847.816887075  7646  D   R 32499241 + 8 (
> 20115) [httpdmon]
>  8,0    1        0  4847.816945463     0  m   N cfq7646 Idling on
> sync. st->count:1
>  8,0    1        0  4847.816946580     0  m   N cfq7646 select_queue:
> dispatched and should_idle - keep_queue
>  8,0    1        0  4847.816948536     0  m   N cfq7646 Idling on
> sync. st->count:1
>  8,0    1        0  4847.816949653     0  m   N cfq7646 select_queue:
> dispatched and should_idle - keep_queue
>  8,0    0   440261  4847.817104144  7284  C   R 32499241 + 8 (  217069) [0]
>  8,0    0        0  4847.817110290     0  m   N cfq7646 complete rqnoidle 0
>  8,0    0        0  4847.817112525     0  m   N cfq7646 arm slice timer
>  8,0    0        0  4847.817113922     0  m   N cfq7646 Idling on
> sync. st->count:1
>  8,0    0        0  4847.817115878     0  m   N cfq7646 arm_idle: 8
> group_idle: 0
>  8,0    0        0  4847.817116995     0  m   N cfq schedule dispatch
>  8,0    0        0  4847.817120068     0  m   N cfq7646 select_queue:
> timer_pending - keep_queue
>  8,0    0        0  4847.824613293     0  m   N cfq idle timer fired
>  8,0    0        0  4847.824616366     0  m   N cfq7646
> idle_slice_timer: active queue
>  8,0    0        0  4847.824617763     0  m   N cfq7646
> idle_slice_timer: clear_cfqq_deep
>  8,0    0        0  4847.824619439     0  m   N cfq7646 slice expired t=0
>  8,0    0        0  4847.824621395     0  m   N cfq7646 del timer
>  8,0    0        0  4847.824622792     0  m   N cfq7646 update idle time stats
>  8,0    0        0  4847.824625865     0  m   N cfq7646 sl_used=12
> disp=3 charge=12 iops=0 sect=24
>  8,0    0        0  4847.824627262     0  m   N cfq7646 slice_expired
> del cfqq from rr
>  8,0    0        0  4847.824628379     0  m   N cfq7646 del_from_rr
>  8,0    0        0  4847.824629776     0  m   N cfq7646 slice_expired
> resort_rr_list
>  8,0    0        0  4847.824631452     0  m   N cfq7646 slice_expired
> setting active_queue to NULL
>  8,0    0        0  4847.824632849     0  m   N cfq7646 slice_expired
> setting active_cic to NULL
>  8,0    0        0  4847.824634246     0  m   N cfq schedule dispatch
>  8,0    1   296749  4848.309940967  7646  A   R 33545872 + 8 <- (8,4) 2152
>
> Dispatch:
>  8,0    0        0  4857.832309642     0  m   N cfq5917 dispatched a request
>  8,0    0        0  4857.832310760     0  m   N cfq5917 activate rq, drv=2
>  8,0    0   440336  4857.832312157  7284  D   W 32800441 + 8
> (10035430955) [testd]
>  8,0    0   440337  4857.832447371  7284  C   W 2076271 + 8 (  687247) [0]
>  8,0    0        0  4857.832457987     0  m   N cfq5917 complete rqnoidle 0
>
> --
> Josh

This doesn't seem right to me, but I could be misunderstanding
something. The stall I pasted in the previous mail shows an insert to
cfq5917:

>  8,0    1   296678  4847.796881202  6076  I   W 32800441 + 8 (
> 2794) [flush-8:0]
>  8,0    1        0  4847.796883157     0  m   N cfq5917 insert_request

I then grepped my previously attached log file for changes to rr for
this queue from the time of the insert to the dispatch:

  8,0    1        0  4847.030323122     0  m   N cfq5917 add_to_rr
  8,0    1        0  4847.030333459     0  m   N cfq5917 slice_expired
resort_rr_list
  8,0    1        0  4847.797539953     0  m   N cfq5917 slice_expired
del cfqq from rr
  8,0    1        0  4847.797541070     0  m   N cfq5917 del_from_rr
  8,0    1        0  4847.797542467     0  m   N cfq5917 slice_expired
resort_rr_list
  8,0    1        0  4847.802484220     0  m   N cfq5917 add_to_rr
  8,0    0        0  4847.808710791     0  m   N cfq5917 slice_expired
del cfqq from rr
  8,0    0        0  4847.808711908     0  m   N cfq5917 del_from_rr
  8,0    0        0  4847.808713305     0  m   N cfq5917 slice_expired
resort_rr_list
  8,0    1        0  4847.809024801     0  m   N cfq5917 add_to_rr
  8,0    1        0  4847.810320233     0  m   N cfq5917 slice_expired
del cfqq from rr
  8,0    1        0  4847.810321351     0  m   N cfq5917 del_from_rr
  8,0    1        0  4847.810322748     0  m   N cfq5917 slice_expired
resort_rr_list
  8,0    1        0  4847.810447905     0  m   N cfq5917 add_to_rr
  8,0    1        0  4847.812490649     0  m   N cfq5917 slice_expired
del cfqq from rr
  8,0    1        0  4847.812492046     0  m   N cfq5917 del_from_rr
  8,0    1        0  4847.812493442     0  m   N cfq5917 slice_expired
resort_rr_list
  8,0    1        0  4852.819290238     0  m   N cfq5917 slice_expired
resort_rr_list
  8,0    0        0  4857.832506038     0  m   N cfq5917 slice_expired
del cfqq from rr
  8,0    0        0  4857.832507156     0  m   N cfq5917 del_from_rr
  8,0    0        0  4857.832508553     0  m   N cfq5917 slice_expired
resort_rr_list
  8,0    1        0  4857.832548782     0  m   N cfq5917 add_to_rr
  8,0    0        0  4857.832843796     0  m   N cfq5917 slice_expired
del cfqq from rr
  8,0    0        0  4857.832844913     0  m   N cfq5917 del_from_rr
  8,0    0        0  4857.832846310     0  m   N cfq5917 slice_expired
resort_rr_list
  8,0    1        0  4857.833060306     0  m   N cfq5917 add_to_rr

Here's the dispatch for the request above:
>  8,0    0        0  4857.832310760     0  m   N cfq5917 activate rq, drv=2
>  8,0    0   440336  4857.832312157  7284  D   W 32800441 + 8
> (10035430955) [testd]

Shouldn't the queue stay on the RR list until it is empty?
-- 
Josh
