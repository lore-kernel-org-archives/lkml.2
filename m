Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1CRMzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:55:06 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:44505 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505Ab1CRMyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:54:45 -0400
X-ASG-Debug-ID: 1300452883-01de284cf884c30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D83560E.8000002@fusionio.com>
Date: Fri, 18 Mar 2011 13:54:38 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task  plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>	 <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>	 <20110316173148.GC13562@redhat.com>	 <1300323609.2337.117.camel@sli10-conroe>  <4D81D7D5.7000806@fusionio.com> <1300430212.2337.141.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [PATCH 04/10] block: initial patch for on-stack per-task  plugging
In-Reply-To: <1300430212.2337.141.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300452883
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58254
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-18 07:36, Shaohua Li wrote:
> On Thu, 2011-03-17 at 17:43 +0800, Jens Axboe wrote:
>> On 2011-03-17 02:00, Shaohua Li wrote:
>>> On Thu, 2011-03-17 at 01:31 +0800, Vivek Goyal wrote:
>>>> On Wed, Mar 16, 2011 at 04:18:30PM +0800, Shaohua Li wrote:
>>>>> 2011/1/22 Jens Axboe <jaxboe@fusionio.com>:
>>>>>> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>>>>>> ---
>>>>>>  block/blk-core.c          |  357 ++++++++++++++++++++++++++++++++------------
>>>>>>  block/elevator.c          |    6 +-
>>>>>>  include/linux/blk_types.h |    2 +
>>>>>>  include/linux/blkdev.h    |   30 ++++
>>>>>>  include/linux/elevator.h  |    1 +
>>>>>>  include/linux/sched.h     |    6 +
>>>>>>  kernel/exit.c             |    1 +
>>>>>>  kernel/fork.c             |    3 +
>>>>>>  kernel/sched.c            |   11 ++-
>>>>>>  9 files changed, 317 insertions(+), 100 deletions(-)
>>>>>>
>>>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>>>> index 960f12c..42dbfcc 100644
>>>>>> --- a/block/blk-core.c
>>>>>> +++ b/block/blk-core.c
>>>>>> @@ -27,6 +27,7 @@
>>>>>>  #include <linux/writeback.h>
>>>>>>  #include <linux/task_io_accounting_ops.h>
>>>>>>  #include <linux/fault-inject.h>
>>>>>> +#include <linux/list_sort.h>
>>>>>>
>>>>>>  #define CREATE_TRACE_POINTS
>>>>>>  #include <trace/events/block.h>
>>>>>> @@ -213,7 +214,7 @@ static void blk_delay_work(struct work_struct *work)
>>>>>>
>>>>>>        q = container_of(work, struct request_queue, delay_work.work);
>>>>>>        spin_lock_irq(q->queue_lock);
>>>>>> -       q->request_fn(q);
>>>>>> +       __blk_run_queue(q);
>>>>>>        spin_unlock_irq(q->queue_lock);
>>>>>>  }
>>>>> Hi Jens,
>>>>> I have some questions about the per-task plugging. Since the request
>>>>> list is per-task, and each task delivers its requests at finish flush
>>>>> or schedule. But when one cpu delivers requests to global queue, other
>>>>> cpus don't know. This seems to have problem. For example:
>>>>> 1. get_request_wait() can only flush current task's request list,
>>>>> other cpus/tasks might still have a lot of requests, which aren't sent
>>>>> to request_queue.
>>>>
>>>> But very soon these requests will be sent to request queue as soon task
>>>> is either scheduled out or task explicitly flushes the plug? So we might
>>>> wait a bit longer but that might not matter in general, i guess. 
>>> Yes, I understand there is just a bit delay. I don't know how severe it
>>> is, but this still could be a problem, especially for fast storage or
>>> random I/O. My current tests show slight regression (3% or so) with
>>> Jens's for 2.6.39/core branch. I'm still checking if it's caused by the
>>> per-task plug, but the per-task plug is highly suspected.
>>
>> To check this particular case, you can always just bump the request
>> limit. What test is showing a slowdown? 
> this is a simple multi-threaded seq read. The issue tends to be request
> merge related (not verified yet). The merge reduces about 60% with stack
> plug from fio reported data. From trace, without stack plug, requests
> from different threads get merged. But with it, such merge is impossible
> because flush_plug doesn't check merge, I thought we need add it again.

What we could try is have the plug flush insert be
ELEVATOR_INSERT_SORT_MERGE and have it lookup potential backmerges.

Here's a quick hack that does that, I have not tested it at all.

diff --git a/block/blk-core.c b/block/blk-core.c
index e1fcf7a..5256932 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2685,7 +2685,7 @@ static void flush_plug_list(struct blk_plug *plug)
 		/*
 		 * rq is already accounted, so use raw insert
 		 */
-		__elv_add_request(q, rq, ELEVATOR_INSERT_SORT);
+		__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
 	}
 
 	if (q) {
diff --git a/block/blk-merge.c b/block/blk-merge.c
index ea85e20..cfcc37c 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -465,3 +465,9 @@ int attempt_front_merge(struct request_queue *q, struct request *rq)
 
 	return 0;
 }
+
+int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
+			  struct request *next)
+{
+	return attempt_merge(q, rq, next);
+}
diff --git a/block/blk.h b/block/blk.h
index 49d21af..c8db371 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -103,6 +103,8 @@ int ll_front_merge_fn(struct request_queue *q, struct request *req,
 		      struct bio *bio);
 int attempt_back_merge(struct request_queue *q, struct request *rq);
 int attempt_front_merge(struct request_queue *q, struct request *rq);
+int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
+				struct request *next);
 void blk_recalc_rq_segments(struct request *rq);
 void blk_rq_set_mixed_merge(struct request *rq);
 
diff --git a/block/elevator.c b/block/elevator.c
index 542ce82..f493e18 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -521,6 +521,33 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 	return ELEVATOR_NO_MERGE;
 }
 
+/*
+ * Returns true if we merged, false otherwise
+ */
+static bool elv_attempt_insert_merge(struct request_queue *q,
+				     struct request *rq)
+{
+	struct request *__rq;
+
+	if (blk_queue_nomerges(q) || blk_queue_noxmerges(q))
+		return false;
+
+	/*
+	 * First try one-hit cache.
+	 */
+	if (q->last_merge && blk_attempt_req_merge(q, rq, q->last_merge))
+		return true;
+
+	/*
+	 * See if our hash lookup can find a potential backmerge.
+	 */
+	__rq = elv_rqhash_find(q, blk_rq_pos(rq));
+	if (__rq && blk_attempt_req_merge(q, rq, __rq))
+		return true;
+
+	return false;
+}
+
 void elv_merged_request(struct request_queue *q, struct request *rq, int type)
 {
 	struct elevator_queue *e = q->elevator;
@@ -647,6 +674,9 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		__blk_run_queue(q, false);
 		break;
 
+	case ELEVATOR_INSERT_SORT_MERGE:
+		if (elv_attempt_insert_merge(q, rq))
+			break;
 	case ELEVATOR_INSERT_SORT:
 		BUG_ON(rq->cmd_type != REQ_TYPE_FS &&
 		       !(rq->cmd_flags & REQ_DISCARD));
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index ec6f72b..d93efcc445 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -166,6 +166,7 @@ extern struct request *elv_rb_find(struct rb_root *, sector_t);
 #define ELEVATOR_INSERT_SORT	3
 #define ELEVATOR_INSERT_REQUEUE	4
 #define ELEVATOR_INSERT_FLUSH	5
+#define ELEVATOR_INSERT_SORT_MERGE	6
 
 /*
  * return values from elevator_may_queue_fn


-- 
Jens Axboe

