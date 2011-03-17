Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1CQJkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:40:12 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45228 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab1CQJjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:39:52 -0400
Message-ID: <4D81D6E4.6050505@fusionio.com>
Date: Thu, 17 Mar 2011 10:39:48 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task  plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-5-git-send-email-jaxboe@fusionio.com> <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
In-Reply-To: <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-16 09:18, Shaohua Li wrote:
> 2011/1/22 Jens Axboe <jaxboe@fusionio.com>:
>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>> ---
>>  block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
>>  block/elevator.c          |    6 +-
>>  include/linux/blk_types.h |    2 +
>>  include/linux/blkdev.h    |   30 ++++
>>  include/linux/elevator.h  |    1 +
>>  include/linux/sched.h     |    6 +
>>  kernel/exit.c             |    1 +
>>  kernel/fork.c             |    3 +
>>  kernel/sched.c            |   11 ++-
>>  9 files changed, 317 insertions(+), 100 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 960f12c..42dbfcc 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -27,6 +27,7 @@
>>  #include <linux/writeback.h>
>>  #include <linux/task_io_accounting_ops.h>
>>  #include <linux/fault-inject.h>
>> +#include <linux/list_sort.h>
>>
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/block.h>
>> @@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
>>
>>        q = container_of(work, struct request_queue, delay_work.work);
>>        spin_lock_irq(q->queue_lock);
>> -       q->request_fn(q);
>> +       __blk_run_queue(q);
>>        spin_unlock_irq(q->queue_lock);
>>  }
> Hi Jens,
> I have some questions about the per-task plugging. Since the request
> list is per-task, and each task delivers its requests at finish flush
> or schedule. But when one cpu delivers requests to global queue, other
> cpus don't know. This seems to have problem. For example:
> 1. get_request_wait() can only flush current task's request list,
> other cpus/tasks might still have a lot of requests, which aren't sent
> to request_queue. your ioc-rq-alloc branch is for this, right? Will it
> be pushed to 2.6.39 too? I'm wondering if we should limit per-task
> queue length. If there are enough requests there, we force a flush
> plug.

Any task plug is by definition short lived, since it only persists while
someone is submitting IO or if the task ends up blocking. It's not like
right now where a plug can persist for some time.

I don't plan on submitting the ioc-rq-alloc for 2.6.39, it needs more
work. I think we'll end up dropping the limits completely and just
ensuring that the flusher thread doesn't push out too much.

> 2. some APIs like blk_delay_work, which call __blk_run_queue() might
> not work. because other CPUs might not dispatch their requests to
> request queue. So __blk_run_queue will eventually find no requests,
> which might stall devices.
> Since one cpu doesn't know other cpus' request list, I'm wondering if
> there are other similar issues.

If you call blk_run_queue(), it's to kick something of that you
submitted (and that should already be on the queue). So I don't think
this is an issue.

-- 
Jens Axboe

