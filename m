Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1CRGhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 02:37:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:20550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186Ab1CRGg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 02:36:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,204,1299484800"; 
   d="scan'208";a="614538697"
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task
 plugging
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
In-Reply-To: <4D81D7D5.7000806@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
	 <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
	 <20110316173148.GC13562@redhat.com>
	 <1300323609.2337.117.camel@sli10-conroe>  <4D81D7D5.7000806@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Mar 2011 14:36:52 +0800
Message-ID: <1300430212.2337.141.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 17:43 +0800, Jens Axboe wrote:
> On 2011-03-17 02:00, Shaohua Li wrote:
> > On Thu, 2011-03-17 at 01:31 +0800, Vivek Goyal wrote:
> >> On Wed, Mar 16, 2011 at 04:18:30PM +0800, Shaohua Li wrote:
> >>> 2011/1/22 Jens Axboe <jaxboe@fusionio.com>:
> >>>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> >>>> ---
> >>>>  block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
> >>>>  block/elevator.c          |    6 +-
> >>>>  include/linux/blk_types.h |    2 +
> >>>>  include/linux/blkdev.h    |   30 ++++
> >>>>  include/linux/elevator.h  |    1 +
> >>>>  include/linux/sched.h     |    6 +
> >>>>  kernel/exit.c             |    1 +
> >>>>  kernel/fork.c             |    3 +
> >>>>  kernel/sched.c            |   11 ++-
> >>>>  9 files changed, 317 insertions(+), 100 deletions(-)
> >>>>
> >>>> diff --git a/block/blk-core.c b/block/blk-core.c
> >>>> index 960f12c..42dbfcc 100644
> >>>> --- a/block/blk-core.c
> >>>> +++ b/block/blk-core.c
> >>>> @@ -27,6 +27,7 @@
> >>>>  #include <linux/writeback.h>
> >>>>  #include <linux/task_io_accounting_ops.h>
> >>>>  #include <linux/fault-inject.h>
> >>>> +#include <linux/list_sort.h>
> >>>>
> >>>>  #define CREATE_TRACE_POINTS
> >>>>  #include <trace/events/block.h>
> >>>> @@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
> >>>>
> >>>>        q = container_of(work, struct request_queue, delay_work.work);
> >>>>        spin_lock_irq(q->queue_lock);
> >>>> -       q->request_fn(q);
> >>>> +       __blk_run_queue(q);
> >>>>        spin_unlock_irq(q->queue_lock);
> >>>>  }
> >>> Hi Jens,
> >>> I have some questions about the per-task plugging. Since the request
> >>> list is per-task, and each task delivers its requests at finish flush
> >>> or schedule. But when one cpu delivers requests to global queue, other
> >>> cpus don't know. This seems to have problem. For example:
> >>> 1. get_request_wait() can only flush current task's request list,
> >>> other cpus/tasks might still have a lot of requests, which aren't sent
> >>> to request_queue.
> >>
> >> But very soon these requests will be sent to request queue as soon task
> >> is either scheduled out or task explicitly flushes the plug? So we might
> >> wait a bit longer but that might not matter in general, i guess. 
> > Yes, I understand there is just a bit delay. I don't know how severe it
> > is, but this still could be a problem, especially for fast storage or
> > random I/O. My current tests show slight regression (3% or so) with
> > Jens's for 2.6.39/core branch. I'm still checking if it's caused by the
> > per-task plug, but the per-task plug is highly suspected.
> 
> To check this particular case, you can always just bump the request
> limit. What test is showing a slowdown? 
this is a simple multi-threaded seq read. The issue tends to be request
merge related (not verified yet). The merge reduces about 60% with stack
plug from fio reported data. From trace, without stack plug, requests
from different threads get merged. But with it, such merge is impossible
because flush_plug doesn't check merge, I thought we need add it again.

Thanks,
Shaohua

