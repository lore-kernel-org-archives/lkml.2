Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1CQJny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:43:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52137 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1CQJnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:43:51 -0400
Message-ID: <4D81D7D5.7000806@fusionio.com>
Date: Thu, 17 Mar 2011 10:43:49 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task  plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>	 <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>	 <20110316173148.GC13562@redhat.com> <1300323609.2337.117.camel@sli10-conroe>
In-Reply-To: <1300323609.2337.117.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-17 02:00, Shaohua Li wrote:
> On Thu, 2011-03-17 at 01:31 +0800, Vivek Goyal wrote:
>> On Wed, Mar 16, 2011 at 04:18:30PM +0800, Shaohua Li wrote:
>>> 2011/1/22 Jens Axboe <jaxboe@fusionio.com>:
>>>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>>>> ---
>>>>  block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
>>>>  block/elevator.c          |    6 +-
>>>>  include/linux/blk_types.h |    2 +
>>>>  include/linux/blkdev.h    |   30 ++++
>>>>  include/linux/elevator.h  |    1 +
>>>>  include/linux/sched.h     |    6 +
>>>>  kernel/exit.c             |    1 +
>>>>  kernel/fork.c             |    3 +
>>>>  kernel/sched.c            |   11 ++-
>>>>  9 files changed, 317 insertions(+), 100 deletions(-)
>>>>
>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>> index 960f12c..42dbfcc 100644
>>>> --- a/block/blk-core.c
>>>> +++ b/block/blk-core.c
>>>> @@ -27,6 +27,7 @@
>>>>  #include <linux/writeback.h>
>>>>  #include <linux/task_io_accounting_ops.h>
>>>>  #include <linux/fault-inject.h>
>>>> +#include <linux/list_sort.h>
>>>>
>>>>  #define CREATE_TRACE_POINTS
>>>>  #include <trace/events/block.h>
>>>> @@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
>>>>
>>>>        q = container_of(work, struct request_queue, delay_work.work);
>>>>        spin_lock_irq(q->queue_lock);
>>>> -       q->request_fn(q);
>>>> +       __blk_run_queue(q);
>>>>        spin_unlock_irq(q->queue_lock);
>>>>  }
>>> Hi Jens,
>>> I have some questions about the per-task plugging. Since the request
>>> list is per-task, and each task delivers its requests at finish flush
>>> or schedule. But when one cpu delivers requests to global queue, other
>>> cpus don't know. This seems to have problem. For example:
>>> 1. get_request_wait() can only flush current task's request list,
>>> other cpus/tasks might still have a lot of requests, which aren't sent
>>> to request_queue.
>>
>> But very soon these requests will be sent to request queue as soon task
>> is either scheduled out or task explicitly flushes the plug? So we might
>> wait a bit longer but that might not matter in general, i guess. 
> Yes, I understand there is just a bit delay. I don't know how severe it
> is, but this still could be a problem, especially for fast storage or
> random I/O. My current tests show slight regression (3% or so) with
> Jens's for 2.6.39/core branch. I'm still checking if it's caused by the
> per-task plug, but the per-task plug is highly suspected.

To check this particular case, you can always just bump the request
limit. What test is showing a slowdown? Like the one that Vivek
discovered, we are going to be adding plugs in more places. I didn't go
crazy with those, wanted to have the infrastructure sane and stable
first.

>>
>> Jens seemed to be suggesting that generally fluser threads are the
>> main cluprit for submitting large amount of IO. They are already per
>> bdi. So probably just maintain a per task limit for flusher threads.
> Yep, flusher is the main spot in my mind. We need call more flush plug
> for flusher thread. 
> 
>> I am not sure what happens to direct reclaim path, AIO deep queue 
>> paths etc.
> direct reclaim path could build deep write queue too. It
> uses .writepage, currently there is no flush plug there. Maybe we need
> add flush plug in shrink_inactive_list too.

If you find and locate these spots, I'd very much appreciate a patch too
:-)

>>> 2. some APIs like blk_delay_work, which call __blk_run_queue() might
>>> not work. because other CPUs might not dispatch their requests to
>>> request queue. So __blk_run_queue will eventually find no requests,
>>> which might stall devices.
>>> Since one cpu doesn't know other cpus' request list, I'm wondering if
>>> there are other similar issues.
>>
>> So again in this case if queue is empty at the time of __blk_run_queue(),
>> then we will probably just experinece little more delay then intended
>> till some task flushes. But should not stall the system?
> not stall the system, but device stalls a little time.

It's not a problem. Say you use blk_delay_work(), that is to delay
something that is already on the queue. Any task plug should be
unrelated. For the request starvation issue, if we had the plug persist
across schedules it would be an issue. But the time frame that a
per-task plugs lives for is very short, it's just submitting the IO.
Flushing those plugs would be detrimental to the problem you want to
solve, which is ensure that those IOs finish faster so that we can
allocate more.

-- 
Jens Axboe

