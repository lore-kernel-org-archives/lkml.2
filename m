Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1CQDTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:19:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:25332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab1CQDT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,197,1299484800"; 
   d="scan'208";a="898106389"
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task
 plugging
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <1300323609.2337.117.camel@sli10-conroe>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
	 <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
	 <20110316173148.GC13562@redhat.com>
	 <1300323609.2337.117.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 11:19:27 +0800
Message-ID: <1300331967.2337.127.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 09:00 +0800, Shaohua Li wrote:
> On Thu, 2011-03-17 at 01:31 +0800, Vivek Goyal wrote:
> > On Wed, Mar 16, 2011 at 04:18:30PM +0800, Shaohua Li wrote:
> > > 2011/1/22 Jens Axboe <jaxboe@fusionio.com>:
> > > > Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> > > > ---
> > > >  block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
> > > >  block/elevator.c          |    6 +-
> > > >  include/linux/blk_types.h |    2 +
> > > >  include/linux/blkdev.h    |   30 ++++
> > > >  include/linux/elevator.h  |    1 +
> > > >  include/linux/sched.h     |    6 +
> > > >  kernel/exit.c             |    1 +
> > > >  kernel/fork.c             |    3 +
> > > >  kernel/sched.c            |   11 ++-
> > > >  9 files changed, 317 insertions(+), 100 deletions(-)
> > > >
> > > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > > index 960f12c..42dbfcc 100644
> > > > --- a/block/blk-core.c
> > > > +++ b/block/blk-core.c
> > > > @@ -27,6 +27,7 @@
> > > >  #include <linux/writeback.h>
> > > >  #include <linux/task_io_accounting_ops.h>
> > > >  #include <linux/fault-inject.h>
> > > > +#include <linux/list_sort.h>
> > > >
> > > >  #define CREATE_TRACE_POINTS
> > > >  #include <trace/events/block.h>
> > > > @@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
> > > >
> > > >        q = container_of(work, struct request_queue, delay_work.work);
> > > >        spin_lock_irq(q->queue_lock);
> > > > -       q->request_fn(q);
> > > > +       __blk_run_queue(q);
> > > >        spin_unlock_irq(q->queue_lock);
> > > >  }
> > > Hi Jens,
> > > I have some questions about the per-task plugging. Since the request
> > > list is per-task, and each task delivers its requests at finish flush
> > > or schedule. But when one cpu delivers requests to global queue, other
> > > cpus don't know. This seems to have problem. For example:
> > > 1. get_request_wait() can only flush current task's request list,
> > > other cpus/tasks might still have a lot of requests, which aren't sent
> > > to request_queue.
> > 
> > But very soon these requests will be sent to request queue as soon task
> > is either scheduled out or task explicitly flushes the plug? So we might
> > wait a bit longer but that might not matter in general, i guess. 
> Yes, I understand there is just a bit delay. I don't know how severe it
> is, but this still could be a problem, especially for fast storage or
> random I/O. My current tests show slight regression (3% or so) with
> Jens's for 2.6.39/core branch. I'm still checking if it's caused by the
> per-task plug, but the per-task plug is highly suspected.
> 
> > > your ioc-rq-alloc branch is for this, right? Will it
> > > be pushed to 2.6.39 too? I'm wondering if we should limit per-task
> > > queue length. If there are enough requests there, we force a flush
> > > plug.
> > 
> > That's the idea jens had. But then came the question of maintaining
> > data structures per task per disk. That makes it complicated.
> > 
> > Even if we move the accounting out of request queue and do it say at
> > bdi, ideally we shall to do per task per bdi accounting.
> > 
> > Jens seemed to be suggesting that generally fluser threads are the
> > main cluprit for submitting large amount of IO. They are already per
> > bdi. So probably just maintain a per task limit for flusher threads.
> Yep, flusher is the main spot in my mind. We need call more flush plug
> for flusher thread. 
> 
> > I am not sure what happens to direct reclaim path, AIO deep queue 
> > paths etc.
> direct reclaim path could build deep write queue too. It
> uses .writepage, currently there is no flush plug there. Maybe we need
> add flush plug in shrink_inactive_list too.
> 
> > > 2. some APIs like blk_delay_work, which call __blk_run_queue() might
> > > not work. because other CPUs might not dispatch their requests to
> > > request queue. So __blk_run_queue will eventually find no requests,
> > > which might stall devices.
> > > Since one cpu doesn't know other cpus' request list, I'm wondering if
> > > there are other similar issues.
> > 
> > So again in this case if queue is empty at the time of __blk_run_queue(),
> > then we will probably just experinece little more delay then intended
> > till some task flushes. But should not stall the system?
> not stall the system, but device stalls a little time.
Jens,
I need below patch to recover a ffsb fsync workload, which has about 30%
regression with stack plug. 
I guess the reason is WRITE_SYNC_PLUG doesn't work now, so if a context
hasn't blk_plug, we lose previous plug (request merge). This suggests
all places we use WRITE_SYNC_PLUG before (for example, kjournald) should
have a blk_plug context.

Thanks,
Shaohua


diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index cc0ede1..24b7ac2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1039,11 +1039,17 @@ static int __writepage(struct page *page, struct writeback_control *wbc,
 int generic_writepages(struct address_space *mapping,
 		       struct writeback_control *wbc)
 {
+	struct blk_plug plug;
+	int ret;
+
 	/* deal with chardevs and other special file */
 	if (!mapping->a_ops->writepage)
 		return 0;
 
-	return write_cache_pages(mapping, wbc, __writepage, mapping);
+	blk_start_plug(&plug);
+	ret = write_cache_pages(mapping, wbc, __writepage, mapping);
+	blk_finish_plug(&plug);
+	return ret;
 }
 
 EXPORT_SYMBOL(generic_writepages);


