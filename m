Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2LLPTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:19:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2LLPTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:19:49 -0500
Message-ID: <50C8A07B.6040508@kernel.dk>
Date: Wed, 12 Dec 2012 16:19:23 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Shaohua Li <shli@kernel.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Read starvation by sync writes
References: <20121210221222.GA25700@quack.suse.cz> <CANejiEW2+iUVnyV0EV2n=vi_+bjX42SkeT9F6EUV5LkwXH4e0g@mail.gmail.com> <20121212101108.GC18885@quack.suse.cz>
In-Reply-To: <20121212101108.GC18885@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-12 11:11, Jan Kara wrote:
> On Wed 12-12-12 10:55:15, Shaohua Li wrote:
>> 2012/12/11 Jan Kara <jack@suse.cz>:
>>>   Hi,
>>>
>>>   I was looking into IO starvation problems where streaming sync writes (in
>>> my case from kjournald but DIO would look the same) starve reads. This is
>>> because reads happen in small chunks and until a request completes we don't
>>> start reading further (reader reads lots of small files) while writers have
>>> plenty of big requests to submit. Both processes end up fighting for IO
>>> requests and writer writes nr_batching 512 KB requests while reader reads
>>> just one 4 KB request or so. Here the effect is magnified by the fact that
>>> the drive has relatively big queue depth so it usually takes longer than
>>> BLK_BATCH_TIME to complete the read request. The net result is it takes
>>> close to two minutes to read files that can be read under a second without
>>> writer load. Without the big drive's queue depth, results are not ideal but
>>> they are bearable - it takes about 20 seconds to do the reading. And for
>>> comparison, when writer and reader are not competing for IO requests (as it
>>> happens when writes are submitted as async), it takes about 2 seconds to
>>> complete reading.
>>>
>>> Simple reproducer is:
>>>
>>> echo 3 >/proc/sys/vm/drop_caches
>>> dd if=/dev/zero of=/tmp/f bs=1M count=10000 &
>>> sleep 30
>>> time cat /etc/* 2>&1 >/dev/null
>>> killall dd
>>> rm /tmp/f
>>>
>>>   The question is how can we fix this? Two quick hacks that come to my mind
>>> are remove timeout from the batching logic (is it that important?) or
>>> further separate request allocation logic so that reads have their own
>>> request pool. More systematic fix would be to change request allocation
>>> logic to always allow at least a fixed number of requests per IOC. What do
>>> people think about this?
>>
>> As long as queue depth > workload iodepth, there is little we can do
>> to prioritize tasks/IOC. Because throttling a task/IOC means queue
>> will be idle. We don't want to idle a queue (especially for SSD), so
>> we always push as more requests as possible to the queue, which
>> will break any prioritization. As far as I know we always have such
>> issue in CFQ for big queue depth disk.
>   Yes, I understand that. But actually big queue depth on its own doesn't
> make the problem really bad (at least for me). When the reader doesn't have
> to wait for free IO requests, it progresses at a reasonable speed. What
> makes it really bad is that big queue depth effectively disallows any use
> of ioc_batching() mode for the reader and thus it blocks in request
> allocation for every single read request unlike writer which always uses
> its full batch (32 requests).

I agree. This isn't about scheduling, we haven't even reached that part
yet. Back when we split the queues into read vs write, this problem
obviously wasn't there. Now we have sync writes and reads, both eating
from the same pool. The io scheduler can impact this a bit by forcing
reads to must allocate (Jan, which io scheduler are you using?). CFQ
does this when it's expecting a request from this process queue.

Back in the day, we used to have one list. To avoid a similar problem,
we reserved the top of the list for reads. With the batching, it's a bit
more complicated. If we make the request allocation (just that, not the
scheduling) be read vs write instead of sync vs async, then we have the
same issue for sync vs buffered writes.

How about something like the below? Due to the nature of sync reads, we
should allow a much longer timeout. The batch is really tailored towards
writes at the moment. Also shrink the batch count, 32 is pretty large...


diff --git a/block/blk-core.c b/block/blk-core.c
index 473015e..f2fcb74 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -792,7 +792,7 @@ static inline int ioc_batching(struct request_queue *q, struct io_context *ioc)
 	 */
 	return ioc->nr_batch_requests == q->nr_batching ||
 		(ioc->nr_batch_requests > 0
-		&& time_before(jiffies, ioc->last_waited + BLK_BATCH_TIME));
+		&& time_before(jiffies, ioc->batch_timeout));
 }
 
 /*
@@ -801,13 +801,18 @@ static inline int ioc_batching(struct request_queue *q, struct io_context *ioc)
  * is the behaviour we want though - once it gets a wakeup it should be given
  * a nice run.
  */
-static void ioc_set_batching(struct request_queue *q, struct io_context *ioc)
+static void ioc_set_batching(struct request_queue *q, struct io_context *ioc,
+			     int rw_flags)
 {
 	if (!ioc || ioc_batching(q, ioc))
 		return;
 
 	ioc->nr_batch_requests = q->nr_batching;
-	ioc->last_waited = jiffies;
+
+	if (rw_flags & REQ_WRITE)
+		ioc->batch_timeout = jiffies + BLK_BATCH_TIME_WRITE;
+	else
+		ioc->batch_timeout = jiffies + BLK_BATCH_TIME_READ;
 }
 
 static void __freed_request(struct request_list *rl, int sync)
@@ -926,7 +931,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 			 * requests, others will be blocked.
 			 */
 			if (!blk_rl_full(rl, is_sync)) {
-				ioc_set_batching(q, ioc);
+				ioc_set_batching(q, ioc, rw_flags);
 				blk_set_rl_full(rl, is_sync);
 			} else {
 				if (may_queue != ELV_MQUEUE_MUST
@@ -1012,7 +1017,7 @@ out:
 	 * ioc may be NULL here, and ioc_batching will be false. That's
 	 * OK, if the queue is under the request limit then requests need
 	 * not count toward the nr_batch_requests limit. There will always
-	 * be some limit enforced by BLK_BATCH_TIME.
+	 * be some limit enforced by BLK_BATCH_TIME_*
 	 */
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
@@ -1109,7 +1114,7 @@ retry:
 	 * to allocate at least one request, and up to a big batch of them
 	 * for a small period time.  See ioc_batching, ioc_set_batching
 	 */
-	ioc_set_batching(q, current->io_context);
+	ioc_set_batching(q, current->io_context, rw_flags);
 
 	spin_lock_irq(q->queue_lock);
 	finish_wait(&rl->wait[is_sync], &wait);
diff --git a/block/blk.h b/block/blk.h
index 47fdfdd..e8761d4 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -4,10 +4,11 @@
 #include <linux/idr.h>
 
 /* Amount of time in which a process may batch requests */
-#define BLK_BATCH_TIME	(HZ/50UL)
+#define BLK_BATCH_TIME_WRITE	(HZ/50UL)
+#define BLK_BATCH_TIME_READ	(2 * HZ)
 
 /* Number of requests a "batching" process may submit */
-#define BLK_BATCH_REQ	32
+#define BLK_BATCH_REQ	16
 
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kobj_type blk_queue_ktype;
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index df38db2..20b02dc 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -108,7 +108,7 @@ struct io_context {
 	 * For request batching
 	 */
 	int nr_batch_requests;     /* Number of requests left in the batch */
-	unsigned long last_waited; /* Time last woken after wait for request */
+	unsigned long batch_timeout;	/* valid until */
 
 	struct radix_tree_root	icq_tree;
 	struct io_cq __rcu	*icq_hint;


-- 
Jens Axboe

