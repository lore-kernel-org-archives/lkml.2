Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2FVUxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 16:53:09 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:64403 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2FVUxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 16:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120622204207.GA22063@redhat.com>
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
Date: Fri, 22 Jun 2012 15:53:05 -0500
Message-ID: <CAKA=qzbycm0cjLyiuKaKkD8sxDm5DvX9WVqSxN2QVT2WZOzU0Q@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Josh Hunt <joshhunt00@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 3:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Jun 22, 2012 at 03:22:01PM -0500, Josh Hunt wrote:
>
> [..]
>> It looks like my statement about busy_queues isn't entirely accurate.
>> I'm seeing this later on in the trace:
>
> Yes it is being called some times. But it is interesting to see that in
> the instance you pasted in last mail, we did not see "schedule_dispatch"
> message.  Are you sure that other requests were queued at that point of
> time and there were busy_queues? You can try printing cfqd->rq_queued
> to verify that.
>
> Also put some message in cfq_select_queue() to see why it did not select
> a new queue before the stall.
>
> Thanks
> Vivek

I think you may be correct that at those points in time there weren't
any busy queues. I do know that there were requests waiting during
this time:

Insert:
  8,0    1   296677  4847.796879805  6076  P   N [flush-8:0]
  8,0    1   296678  4847.796881202  6076  I   W 32800441 + 8 (
2794) [flush-8:0]
  8,0    1        0  4847.796883157     0  m   N cfq5917 insert_request
  8,0    1   296679  4847.796884834  6076  U   N [flush-8:0] 1

Stall (one of many b/t insert and dispatch):
  8,0    1   296851  4852.776942694  8216  U   N [httpdmon] 1
  8,0    1        0  4852.776945488     0  m   N cfq select_queue: !cfqq
  8,0    1        0  4852.776946885     0  m   N cfq select_queue:
cfq_choose_cfqg
  8,0    1        0  4852.776948281     0  m   N cfq select_queue:
setting active queue to new_cfqq:NULL
  8,0    1        0  4852.776950237     0  m   N cfq8216 set_active
wl_prio:0 wl_type:1
  8,0    1        0  4852.776951634     0  m   N cfq8216 del timer
  8,0    1        0  4852.776952751     0  m   N cfq8216 update idle time stats
  8,0    1        0  4852.776954427     0  m   N cfq8216 Idling on
sync. st->count:1
  8,0    1        0  4852.776957780     0  m   N cfq8216 fifo=          (null)
  8,0    1        0  4852.776959456     0  m   N cfq8216 dispatch_insert
  8,0    1        0  4852.776961412     0  m   N cfq8216 remove request
  8,0    1        0  4852.776963647     0  m   N cfq8216 dispatched a request
  8,0    1        0  4852.776965043     0  m   N cfq8216 activate rq, drv=1
  8,0    1   296852  4852.776966161  8216  D   R 13529455 + 8 (
34642) [httpdmon]
  8,0    1        0  4852.777044943     0  m   N cfq8216 Idling on
sync. st->count:1
  8,0    1        0  4852.777046340     0  m   N cfq8216 select_queue:
dispatched and should_idle - keep_queue
  8,0    0   440281  4852.777130150  7284  C   R 13529455 + 8 (  163989) [0]
  8,0    0        0  4852.777145236     0  m   N cfq8216 complete rqnoidle 0
  8,0    0        0  4852.777147471     0  m   N cfq8216 set_slice=100
  8,0    0        0  4852.777149427     0  m   N cfq8216 arm slice timer
  8,0    0        0  4852.777151103     0  m   N cfq8216 Idling on
sync. st->count:1
  8,0    0        0  4852.777153058     0  m   N cfq8216 arm_idle: 8
group_idle: 0
  8,0    0        0  4847.817116995     0  m   N cfq schedule dispatch
  8,0    0        0  4847.817120068     0  m   N cfq7646 select_queue:
timer_pending - keep_queue
  8,0    0        0  4847.824613293     0  m   N cfq idle timer fired
  8,0    0        0  4847.824616366     0  m   N cfq7646
idle_slice_timer: active queue
  8,0    0        0  4847.824617763     0  m   N cfq7646
idle_slice_timer: clear_cfqq_deep
  8,0    0        0  4847.824619439     0  m   N cfq7646 slice expired t=0
  8,0    0        0  4847.824621395     0  m   N cfq7646 del timer
  8,0    0        0  4847.824622792     0  m   N cfq7646 update idle time stats
  8,0    0        0  4847.824625865     0  m   N cfq7646 sl_used=12
disp=3 charge=12 iops=0 sect=24
  8,0    0        0  4847.824627262     0  m   N cfq7646 slice_expired
del cfqq from rr
  8,0    0        0  4847.824628379     0  m   N cfq7646 del_from_rr
  8,0    0        0  4847.824629776     0  m   N cfq7646 slice_expired
resort_rr_list
  8,0    0        0  4847.824631452     0  m   N cfq7646 slice_expired
setting active_queue to NULL
  8,0    0        0  4847.824632849     0  m   N cfq7646 slice_expired
setting active_cic to NULL
  8,0    0        0  4847.824634246     0  m   N cfq schedule dispatch
  8,0    1   296749  4848.309940967  7646  A   R 33545872 + 8 <- (8,4) 2152
  8,0    1   296750  4848.309956053  7646  Q   R 33545872 + 8 [httpdmon]

Dispatch:
  8,0    0        0  4857.832310760     0  m   N cfq5917 activate rq, drv=2
  8,0    0   440336  4857.832312157  7284  D   W 32800441 + 8
(10035430955) [testd]
  8,0    0   440337  4857.832447371  7284  C   W 2076271 + 8 (  687247) [0]
  8,0    0        0  4857.832457987     0  m   N cfq5917 complete rqnoidle 0

In this case you see the schedule dispatch message so there were busy
queues, but for whatever reason nothing gets run. Will keep digging.

-- 
Josh
