Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1ASNnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 08:43:40 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49499 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab1ASNnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 08:43:39 -0500
Message-ID: <4D36EA84.1000605@kernel.dk>
Date: Wed, 19 Jan 2011 06:43:32 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] blktrace: Don't output messages if NOTIFY isn't set.
References: <x491v4a5hzq.fsf@segfault.boston.devel.redhat.com> <1295406590-7320-1-git-send-email-tm@tao.ma> <4D367873.90805@kernel.dk> <4D367FFF.2020505@tao.ma>
In-Reply-To: <4D367FFF.2020505@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-18 23:09, Tao Ma wrote:
> On 01/19/2011 01:36 PM, Jens Axboe wrote:
>> On 2011-01-18 20:09, Tao Ma wrote:
>>> Hi Jeff,
>>> On 01/18/2011 11:50 PM, Jeff Moyer wrote:
>>>> Tao Ma<tm@tao.ma>   writes:
>>>>
>>>>> +	/*
>>>>> +	 * If the user does specify some action masks, don't send any note
>>>>> +	 * message to the trace so that it won't pollute what the user really
>>>>> +	 * want to see.
>>>>> +	 */
>>>>> +	if (bt->act_mask != (u16) -1)
>>>>> +		return;
>>>>> +
>>>>
>>>> I think you want to check for the BLK_TC_NOTIFY bit.
>>> I was thinking of this, but actually there is no way for the user to set this flag.
>>> At least from blktrace(8), -a doesn't have any flags like NOTIFY. So if the user
>>> set any flag, NOTIFY will be cleared. So it does work. Thanks.
>>>
>>> Here is the updated patch.
>>>
>>>  From 8693c19f165b09f60d5c26aed369d79a79e144ba Mon Sep 17 00:00:00 2001
>>> From: Tao Ma<boyu.mt@taobao.com>
>>> Date: Wed, 19 Jan 2011 10:51:44 +0800
>>> Subject: [PATCH v2] blktrace: Don't output messages if NOTIFY isn't set.
>>>
>>> Now if we enable blktrace, cfq has too many messages output to the
>>> trace buffer. It is fine if we don't specify any action mask.
>>> But if I do like this:
>>> blktrace /dev/sdb -a issue -a complete -o - | blkparse -i -
>>> I only want to see 'D' and 'C', while with the following command
>>> dd if=/mnt/ocfs2/test of=/dev/null bs=4k count=1 iflag=direct
>>>
>>> I will get(with a 2.6.37 vanilla kernel):
>>>    8,16   0        0     0.000000000     0  m   N cfq3805 alloced
>>>    8,16   0        0     0.000004126     0  m   N cfq3805 insert_request
>>>    8,16   0        0     0.000004884     0  m   N cfq3805 add_to_rr
>>>    8,16   0        0     0.000008417     0  m   N cfq workload slice:300
>>>    8,16   0        0     0.000009557     0  m   N cfq3805 set_active wl_prio:0 wl_type:2
>>>    8,16   0        0     0.000010640     0  m   N cfq3805 fifo=          (null)
>>>    8,16   0        0     0.000011193     0  m   N cfq3805 dispatch_insert
>>>    8,16   0        0     0.000012221     0  m   N cfq3805 dispatched a request
>>>    8,16   0        0     0.000012802     0  m   N cfq3805 activate rq, drv=1
>>>    8,16   0        1     0.000013181  3805  D   R 114759 + 8 [dd]
>>>    8,16   0        2     0.000164244     0  C   R 114759 + 8 [0]
>>>    8,16   0        0     0.000167997     0  m   N cfq3805 complete rqnoidle 0
>>>    8,16   0        0     0.000168782     0  m   N cfq3805 set_slice=100
>>>    8,16   0        0     0.000169874     0  m   N cfq3805 arm_idle: 8 group_idle: 0
>>>    8,16   0        0     0.000170189     0  m   N cfq schedule dispatch
>>>    8,16   0        0     0.000397938     0  m   N cfq3805 slice expired t=0
>>>    8,16   0        0     0.000399763     0  m   N cfq3805 sl_used=1 disp=1 charge=1 iops=0 sect=8
>>>    8,16   0        0     0.000400227     0  m   N cfq3805 del_from_rr
>>>    8,16   0        0     0.000400882     0  m   N cfq3805 put_queue
>>>
>>> See, there are 19 lines while I only need 2. I don't think it is
>>> appropriate for a user.
>>>
>>> So this patch will disable any messages if the BLK_TC_NOTIFY isn't set.
>>> Now the output for the same command will look like:
>>>    8,16   0        1     0.000000000  4908  D   R 114759 + 8 [dd]
>>>    8,16   0        2     0.000146827     0  C   R 114759 + 8 [0]
>>>
>>> Yes, it is what I want to see.
>>>
>>> Cc: Jens Axboe<axboe@kernel.dk>
>>> Cc: Steven Rostedt<rostedt@goodmis.org>
>>> Cc: Jeff Moyer<jmoyer@redhat.com>
>>> Signed-off-by: Tao Ma<boyu.mt@taobao.com>
>>> ---
>>>   kernel/trace/blktrace.c |    7 +++++++
>>>   1 files changed, 7 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
>>> index 153562d..d95721f 100644
>>> --- a/kernel/trace/blktrace.c
>>> +++ b/kernel/trace/blktrace.c
>>> @@ -138,6 +138,13 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
>>>   		     !blk_tracer_enabled))
>>>   		return;
>>>
>>> +	/*
>>> +	 * If the BLK_TC_NOTIFY action mask isn't set, don't send any note
>>> +	 * message to the trace.
>>> +	 */
>>> +	if (!(bt->act_mask&  BLK_TC_NOTIFY))
>>> +		return;
>>> +
>>>   	local_irq_save(flags);
>>>   	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
>>>   	va_start(args, fmt);
>>
>> Hmm, it should only mask messages, not task/timestamp notifies. This
>> will mask all of them.
> uh, yes, that's the reason why I put the check in __trace_note_message, 
> not in trace_note. trace_note_time and trace_note_tsk will handle 
> time/task issue and then call trace_note with the appropriate action 
> mask. Do I miss something here?

You did, I missed that. Patch looks fine then, I'll queue it up. Thanks!

-- 
Jens Axboe

