Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1CUGxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 02:53:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:36052 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab1CUGww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 02:52:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,218,1299484800"; 
   d="scan'208";a="615504853"
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task
 plugging
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
In-Reply-To: <4D83639A.3060407@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
	 <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>
	 <20110316173148.GC13562@redhat.com>
	 <1300323609.2337.117.camel@sli10-conroe>  <4D81D7D5.7000806@fusionio.com>
	 <1300430212.2337.141.camel@sli10-conroe> <4D83560E.8000002@fusionio.com>
	 <4D83639A.3060407@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 14:52:48 +0800
Message-ID: <1300690368.2337.148.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 21:52 +0800, Jens Axboe wrote:
> On 2011-03-18 13:54, Jens Axboe wrote:
> > On 2011-03-18 07:36, Shaohua Li wrote:
> >> On Thu, 2011-03-17 at 17:43 +0800, Jens Axboe wrote:
> >>> On 2011-03-17 02:00, Shaohua Li wrote:
> >>>> On Thu, 2011-03-17 at 01:31 +0800, Vivek Goyal wrote:
> >>>>> On Wed, Mar 16, 2011 at 04:18:30PM +0800, Shaohua Li wrote:
> >>>>>> 2011/1/22 Jens Axboe <jaxboe@fusionio.com>:
> >>>>>>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> >>>>>>> ---
> >>>>>>>  block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
> >>>>>>>  block/elevator.c          |    6 +-
> >>>>>>>  include/linux/blk_types.h |    2 +
> >>>>>>>  include/linux/blkdev.h    |   30 ++++
> >>>>>>>  include/linux/elevator.h  |    1 +
> >>>>>>>  include/linux/sched.h     |    6 +
> >>>>>>>  kernel/exit.c             |    1 +
> >>>>>>>  kernel/fork.c             |    3 +
> >>>>>>>  kernel/sched.c            |   11 ++-
> >>>>>>>  9 files changed, 317 insertions(+), 100 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/block/blk-core.c b/block/blk-core.c
> >>>>>>> index 960f12c..42dbfcc 100644
> >>>>>>> --- a/block/blk-core.c
> >>>>>>> +++ b/block/blk-core.c
> >>>>>>> @@ -27,6 +27,7 @@
> >>>>>>>  #include <linux/writeback.h>
> >>>>>>>  #include <linux/task_io_accounting_ops.h>
> >>>>>>>  #include <linux/fault-inject.h>
> >>>>>>> +#include <linux/list_sort.h>
> >>>>>>>
> >>>>>>>  #define CREATE_TRACE_POINTS
> >>>>>>>  #include <trace/events/block.h>
> >>>>>>> @@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
> >>>>>>>
> >>>>>>>        q = container_of(work, struct request_queue, delay_work.work);
> >>>>>>>        spin_lock_irq(q->queue_lock);
> >>>>>>> -       q->request_fn(q);
> >>>>>>> +       __blk_run_queue(q);
> >>>>>>>        spin_unlock_irq(q->queue_lock);
> >>>>>>>  }
> >>>>>> Hi Jens,
> >>>>>> I have some questions about the per-task plugging. Since the request
> >>>>>> list is per-task, and each task delivers its requests at finish flush
> >>>>>> or schedule. But when one cpu delivers requests to global queue, other
> >>>>>> cpus don't know. This seems to have problem. For example:
> >>>>>> 1. get_request_wait() can only flush current task's request list,
> >>>>>> other cpus/tasks might still have a lot of requests, which aren't sent
> >>>>>> to request_queue.
> >>>>>
> >>>>> But very soon these requests will be sent to request queue as soon task
> >>>>> is either scheduled out or task explicitly flushes the plug? So we might
> >>>>> wait a bit longer but that might not matter in general, i guess. 
> >>>> Yes, I understand there is just a bit delay. I don't know how severe it
> >>>> is, but this still could be a problem, especially for fast storage or
> >>>> random I/O. My current tests show slight regression (3% or so) with
> >>>> Jens's for 2.6.39/core branch. I'm still checking if it's caused by the
> >>>> per-task plug, but the per-task plug is highly suspected.
> >>>
> >>> To check this particular case, you can always just bump the request
> >>> limit. What test is showing a slowdown? 
> >> this is a simple multi-threaded seq read. The issue tends to be request
> >> merge related (not verified yet). The merge reduces about 60% with stack
> >> plug from fio reported data. From trace, without stack plug, requests
> >> from different threads get merged. But with it, such merge is impossible
> >> because flush_plug doesn't check merge, I thought we need add it again.
> > 
> > What we could try is have the plug flush insert be
> > ELEVATOR_INSERT_SORT_MERGE and have it lookup potential backmerges.
> > 
> > Here's a quick hack that does that, I have not tested it at all.
> 
> Gave it a quick test spin, as suspected it had a few issues. This one
> seems to work. Can you toss it through that workload and see if it fares
> better?
yes, this fully restores the regression I saw. But I have accounting
issue:
1. The merged request is already accounted when it's added into plug
list
2. drive_stat_acct() is called without any protection in
__make_request(). So there is race for in_flight accounting. The race
exists after stack plug is added, so not because of this issue.
Below is the extra patch I need to do the test.

---
 block/blk-merge.c     |   12 +++++-------
 block/elevator.c      |    9 ++++++---
 drivers/md/dm.c       |    7 ++++---
 fs/partitions/check.c |    3 ++-
 include/linux/genhd.h |   12 ++++++------
 5 files changed, 23 insertions(+), 20 deletions(-)

Index: linux-2.6/block/blk-merge.c
===================================================================
--- linux-2.6.orig/block/blk-merge.c
+++ linux-2.6/block/blk-merge.c
@@ -429,14 +429,12 @@ static int attempt_merge(struct request_
 
 	req->__data_len += blk_rq_bytes(next);
 
-	if (next->cmd_flags & REQ_SORTED) {
-		elv_merge_requests(q, req, next);
+	elv_merge_requests(q, req, next);
 
-		/*
-		 * 'next' is going away, so update stats accordingly
-		 */
-		blk_account_io_merge(next);
-	}
+	/*
+	 * 'next' is going away, so update stats accordingly
+	 */
+	blk_account_io_merge(next);
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
 	if (blk_rq_cpu_valid(next))
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -566,13 +566,16 @@ void elv_merge_requests(struct request_q
 {
 	struct elevator_queue *e = q->elevator;
 
-	if (e->ops->elevator_merge_req_fn)
+	if ((next->cmd_flags & REQ_SORTED) && e->ops->elevator_merge_req_fn)
 		e->ops->elevator_merge_req_fn(q, rq, next);
 
 	elv_rqhash_reposition(q, rq);
-	elv_rqhash_del(q, next);
 
-	q->nr_sorted--;
+	if (next->cmd_flags & REQ_SORTED) {
+		elv_rqhash_del(q, next);
+		q->nr_sorted--;
+	}
+
 	q->last_merge = rq;
 }
 
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -477,7 +477,8 @@ static void start_io_acct(struct dm_io *
 	cpu = part_stat_lock();
 	part_round_stats(cpu, &dm_disk(md)->part0);
 	part_stat_unlock();
-	dm_disk(md)->part0.in_flight[rw] = atomic_inc_return(&md->pending[rw]);
+	atomic_set(&dm_disk(md)->part0.in_flight[rw],
+		atomic_inc_return(&md->pending[rw]));
 }
 
 static void end_io_acct(struct dm_io *io)
@@ -497,8 +498,8 @@ static void end_io_acct(struct dm_io *io
 	 * After this is decremented the bio must not be touched if it is
 	 * a flush.
 	 */
-	dm_disk(md)->part0.in_flight[rw] = pending =
-		atomic_dec_return(&md->pending[rw]);
+	pending = atomic_dec_return(&md->pending[rw]);
+	atomic_set(&dm_disk(md)->part0.in_flight[rw], pending);
 	pending += atomic_read(&md->pending[rw^0x1]);
 
 	/* nudge anyone waiting on suspend queue */
Index: linux-2.6/fs/partitions/check.c
===================================================================
--- linux-2.6.orig/fs/partitions/check.c
+++ linux-2.6/fs/partitions/check.c
@@ -290,7 +290,8 @@ ssize_t part_inflight_show(struct device
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%8u %8u\n", p->in_flight[0], p->in_flight[1]);
+	return sprintf(buf, "%8u %8u\n", atomic_read(&p->in_flight[0]),
+		atomic_read(&p->in_flight[1]));
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
Index: linux-2.6/include/linux/genhd.h
===================================================================
--- linux-2.6.orig/include/linux/genhd.h
+++ linux-2.6/include/linux/genhd.h
@@ -109,7 +109,7 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	int in_flight[2];
+	atomic_t in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats __percpu *dkstats;
 #else
@@ -370,21 +370,21 @@ static inline void free_part_stats(struc
 
 static inline void part_inc_in_flight(struct hd_struct *part, int rw)
 {
-	part->in_flight[rw]++;
+	atomic_inc(&part->in_flight[rw]);
 	if (part->partno)
-		part_to_disk(part)->part0.in_flight[rw]++;
+		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
 }
 
 static inline void part_dec_in_flight(struct hd_struct *part, int rw)
 {
-	part->in_flight[rw]--;
+	atomic_dec(&part->in_flight[rw]);
 	if (part->partno)
-		part_to_disk(part)->part0.in_flight[rw]--;
+		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
 }
 
 static inline int part_in_flight(struct hd_struct *part)
 {
-	return part->in_flight[0] + part->in_flight[1];
+	return atomic_read(&part->in_flight[0]) + atomic_read(&part->in_flight[1]);
 }
 
 static inline struct partition_meta_info *alloc_part_info(struct gendisk *disk)


