Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2FZXoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:44:09 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:53925 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2FZXoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAKA=qzbBtteDjHiPogCvN5jOSiPrDxx=vn96p02bXUy=6=jAgA@mail.gmail.com>
References: <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
	<20120625133047.GA9394@redhat.com>
	<CAKA=qzbXm7LaDziH=cms1W5X+cwNNRkG0LNFfWKEppr2oht6_w@mail.gmail.com>
	<20120625211850.GC10916@redhat.com>
	<CAKA=qzaU=wKLrprgJ4z32tqqyO6W0+SBcaV=ArWAdKh_9c=Zew@mail.gmail.com>
	<CAKA=qzY+J-Ab8NC-+r1Dw_-giVzC=z8SnxJhSWHF-ud8j3yg6A@mail.gmail.com>
	<20120626125953.GA22557@redhat.com>
	<CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
	<20120626155332.GJ22557@redhat.com>
	<CAKA=qzYoX-1nTZ6QfdD7RhWf=KU7J6tWOJXgt-F+Kz2c3Xn0TQ@mail.gmail.com>
	<20120626205651.GW3869@google.com>
	<CAKA=qzbBtteDjHiPogCvN5jOSiPrDxx=vn96p02bXUy=6=jAgA@mail.gmail.com>
Date: Tue, 26 Jun 2012 18:44:04 -0500
Message-ID: <CAKA=qzaZweeeYUFD2OHDeAO-SQihSvExAZ=ZnXeY5o5sMWpxJg@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Josh Hunt <joshhunt00@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 5:31 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
> On Tue, Jun 26, 2012 at 3:56 PM, Tejun Heo <tj@kernel.org> wrote:
>> Hey,
>>
>> On Tue, Jun 26, 2012 at 03:37:31PM -0500, Josh Hunt wrote:
>>> The print "cfq schedule dispatch: busy_queues:1 rq_queued:1
>>> rq_in_driver:0 rq_in_flight[0]:0 [1]:0" is inside the if to call
>>> kblockd_schedule_work() so it is getting called, but you can see that
>>> we never see the workqueue_queue_work tracepoint being hit.
>>
>> Hmm... looks like the work item is already queued.  Can you please
>> move the "schedule dispatch" message after kblockd_schedule_work() and
>> print its return value too?
>>
>>> Tejun - if you could let me know what other data I should be looking
>>> for/need to enable in the traces I would appreciate it.
>>
>> The trace seems truncated and doesn't contain 9527.XXXX traces.  Can
>> you please resend?
>>
>> Thanks.
>>
>> --
>> tejun
>
> I added the print after the call to kblockd_schedule_work():
>
>           testd-21177 [000]  3285.163208:   8,0    m   N cfq idle timer fired
>           testd-21177 [000]  3285.163215:   8,0    m   N cfq21314S
> idle_slice_timer: active queue
>           testd-21177 [000]  3285.163216:   8,0    m   N cfq21314S
> idle_slice_timer: clear_cfqq_deep
>           testd-21177 [000]  3285.163218:   8,0    m   N cfq21314S
> slice expired t=0
>           testd-21177 [000]  3285.163219:   8,0    m   N cfq21314S del timer
>           testd-21177 [000]  3285.163220:   8,0    m   N cfq21314S
> update idle time stats
>           testd-21177 [000]  3285.163223:   8,0    m   N cfq21314S
> sl_used=8 disp=1 charge=8 iops=0 sect=8
>           testd-21177 [000]  3285.163224:   8,0    m   N cfq21314S
> slice_expired del cfqq from rr - on_rr:1 rb empty:1
>           testd-21177 [000]  3285.163225:   8,0    m   N cfq21314S
> del_from_rr queued[0]:0 queued[1]:0
>           testd-21177 [000]  3285.163226:   8,0    m   N cfq21314S
> slice_expired resort_rr_list
>           testd-21177 [000]  3285.163227:   8,0    m   N cfq21314S
> slice_expired setting active_queue to NULL
>           testd-21177 [000]  3285.163229:   8,0    m   N cfq21314S
> slice_expired setting active_cic to NULL
>           testd-21177 [000]  3285.163230:   8,0    m   N cfq schedule
> dispatch: busy_queues:2 rq_queued:2 rq_in_driver:0 rq_in_flight[0]:0
> [1]:0 ret:0
>        httpmon-18719 [001]  3285.426011:   8,0    A   R 15970647 + 8
> <- (8,2) 3391752
>        httpmon-18719 [001]  3285.426020: block_bio_remap: 8,0 R
> 15970647 + 8 <- (8,2) 3391752
>        httpmon-18719 [001]  3285.426021:   8,0    Q   R 15970647 + 8 [httpmon]
>        httpmon-18719 [001]  3285.426022: block_bio_queue: 8,0 R
> 15970647 + 8 [httpmon]
>        httpmon-18719 [001]  3285.426032:   8,0    G   R 15970647 + 8 [httpmon]
>
> In this case we call kblockd_schedule_work() but ret is 0. So this
> looks like it thinks the work is already scheduled on the cpu? I've
> attached the full log.
>
> Thanks for your help.
> --
> Josh

Looking at the workqueue traces I see:

           testd-21177 [000]  3284.438475: workqueue_queue_work: work
struct=ffff880204d97a48 function=cfq_kick_queue
workqueue=ffff880208e02400 req_cpu=0 cpu=0
           testd-21177 [000]  3284.438476: workqueue_activate_work:
work struct ffff880204d97a48

but do not see a corresponding execute_start/end until:

     kworker/0:1-11    [000]  3286.873905: workqueue_execute_start:
work struct ffff880204d97a48: function cfq_kick_queue
     kworker/0:1-11    [000]  3286.873907: workqueue_execute_end: work
struct ffff880204d97a48

-- 
Josh
