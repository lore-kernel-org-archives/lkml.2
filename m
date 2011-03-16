Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1CPRcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:32:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1CPRb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:31:57 -0400
Date: Wed, 16 Mar 2011 13:31:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        hch@infradead.org, jmoyer@redhat.com, shaohua.li@intel.com
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task plugging
Message-ID: <20110316173148.GC13562@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
 <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 04:18:30PM +0800, Shaohua Li wrote:
> 2011/1/22 Jens Axboe <jaxboe@fusionio.com>:
> > Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> > ---
> >  block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
> >  block/elevator.c          |    6 +-
> >  include/linux/blk_types.h |    2 +
> >  include/linux/blkdev.h    |   30 ++++
> >  include/linux/elevator.h  |    1 +
> >  include/linux/sched.h     |    6 +
> >  kernel/exit.c             |    1 +
> >  kernel/fork.c             |    3 +
> >  kernel/sched.c            |   11 ++-
> >  9 files changed, 317 insertions(+), 100 deletions(-)
> >
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 960f12c..42dbfcc 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/writeback.h>
> >  #include <linux/task_io_accounting_ops.h>
> >  #include <linux/fault-inject.h>
> > +#include <linux/list_sort.h>
> >
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/block.h>
> > @@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
> >
> >        q = container_of(work, struct request_queue, delay_work.work);
> >        spin_lock_irq(q->queue_lock);
> > -       q->request_fn(q);
> > +       __blk_run_queue(q);
> >        spin_unlock_irq(q->queue_lock);
> >  }
> Hi Jens,
> I have some questions about the per-task plugging. Since the request
> list is per-task, and each task delivers its requests at finish flush
> or schedule. But when one cpu delivers requests to global queue, other
> cpus don't know. This seems to have problem. For example:
> 1. get_request_wait() can only flush current task's request list,
> other cpus/tasks might still have a lot of requests, which aren't sent
> to request_queue.

But very soon these requests will be sent to request queue as soon task
is either scheduled out or task explicitly flushes the plug? So we might
wait a bit longer but that might not matter in general, i guess. 

> your ioc-rq-alloc branch is for this, right? Will it
> be pushed to 2.6.39 too? I'm wondering if we should limit per-task
> queue length. If there are enough requests there, we force a flush
> plug.

That's the idea jens had. But then came the question of maintaining
data structures per task per disk. That makes it complicated.

Even if we move the accounting out of request queue and do it say at
bdi, ideally we shall to do per task per bdi accounting.

Jens seemed to be suggesting that generally fluser threads are the
main cluprit for submitting large amount of IO. They are already per
bdi. So probably just maintain a per task limit for flusher threads.

I am not sure what happens to direct reclaim path, AIO deep queue 
paths etc.
  
> 2. some APIs like blk_delay_work, which call __blk_run_queue() might
> not work. because other CPUs might not dispatch their requests to
> request queue. So __blk_run_queue will eventually find no requests,
> which might stall devices.
> Since one cpu doesn't know other cpus' request list, I'm wondering if
> there are other similar issues.

So again in this case if queue is empty at the time of __blk_run_queue(),
then we will probably just experinece little more delay then intended
till some task flushes. But should not stall the system?

Thanks
Vivek
