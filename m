Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab2IZEq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 00:46:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62109 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2IZEqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 00:46:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,487,1344182400"; 
   d="scan'208";a="5917528"
Message-ID: <5062893B.70908@cn.fujitsu.com>
Date: Wed, 26 Sep 2012 12:48:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] workqueue: restructure flush_workqueue() and start
 all flusher at the same time
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com> <20120924203954.GD29689@google.com> <50617333.9020903@cn.fujitsu.com> <20120925202427.GM16296@google.com>
In-Reply-To: <20120925202427.GM16296@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/26 12:47:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/26 12:47:00,
	Serialize complete at 2012/09/26 12:47:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 04:24 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Tue, Sep 25, 2012 at 05:02:43PM +0800, Lai Jiangshan wrote:
>> It is not possible to remove cascading. If cascading code is
>> not in flush_workqueue(), it must be in some where else.
> 
> Yeah, sure, I liked that it didn't have to be done explicitly as a
> separate step.
> 
>> If you force overflow to wait for freed color before do flush(which also
>> force only one flusher for one color), and force the sole flush_workqueue()
>> to grab ->flush_mutex twice, we can simplify the flush_workqueue().
>> (see the attached patch, it remove 100 LOC, and the cascading code becomes
>> only 3 LOC). But these two forcing slow down the caller a little.
> 
> Hmmm... so, that's a lot simpler.  flush_workqueue() isn't a super-hot
> code path and I don't think grabbing mutex twice is too big a deal.  I
> haven't actually reviewed the code but if it can be much simpler and
> thus easier to understand and verify, I might go for that.

I updated it. it is attached, it forces flush_workqueue() to grab mutex twice(no other forcing).
overflow queue is implemented in a different way. This new algorithm may become our choice
likely, please review this one.

> 
>> (And if you allow to use SRCU(which is only TWO colors), you can remove another
>> 150 LOC. flush_workqueue() will become single line. But it will add some more overhead
>> in flush_workqueue() because SRCU's readsite is lockless)
> 
> I'm not really following how SRCU would factor into this but
> supporting multiple colors was something explicitly requested by
> Linus.  The initial implementation was a lot simpler which supported
> only two colors.  Linus was worried that the high possibility of
> flusher clustering could lead to chaining of latencies.
> 

I did not know this history, thank you.

But the number of colors is not essential.
"Does the algorithm chain flushers" is essential.

If we can have multiple flushers for each color. It is not chained.
If we have only one flusher for one color. It is chained. Even we have multiple
color, it is still partially chained(image we have very high frequent flush_workqueue()).

The initial implementation of flush_workqueue() is "chained" algorithm.
The initial implementation of SRCU is also "chained" algorithm.
but the current SRCU which was implemented by me is not "chained"
(I don't propose to use SRCU for flush_workqueue(), I just discuss it)

The simple version of flush_workqueue() which I sent yesterday is "chained",
because it forces overflow flushers wait for free color and forces only one
flusher for one color.

Since "not chaining" is important/essential. I sent a new draft implement today.
it uses multiple queues, one for each color(like SRCU).
this version is also simple, it remove 90 LOC.

Thanks,
Lai

This patch is still applied on top of patch7. it replaces patch8~10

 workqueue.c |  152 ++++++++++++--------------------diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index be407e1..00f02ba 100644

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -208,7 +208,6 @@ struct cpu_workqueue_struct {
  */
 struct wq_flusher {
 	struct list_head	list;		/* F: list of flushers */
-	int			flush_color;	/* F: flush color waiting for */
 	struct completion	done;		/* flush completion */
 };
 
@@ -250,9 +249,7 @@ struct workqueue_struct {
 	int			work_color;	/* F: current work color */
 	int			flush_color;	/* F: current flush color */
 	atomic_t		nr_cwqs_to_flush[WORK_NR_COLORS];
-	struct wq_flusher	*first_flusher;	/* F: first flusher */
-	struct list_head	flusher_queue;	/* F: flush waiters */
-	struct list_head	flusher_overflow; /* F: flush overflow list */
+	struct list_head	flusher[WORK_NR_COLORS]; /* F: flushers */
 
 	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
@@ -1000,8 +997,11 @@ static void wq_dec_flusher_ref(struct workqueue_struct *wq, int color)
 	 * If this was the last reference, wake up the first flusher.
 	 * It will handle the rest.
 	 */
-	if (atomic_dec_and_test(&wq->nr_cwqs_to_flush[color]))
-		complete(&wq->first_flusher->done);
+	if (atomic_dec_and_test(&wq->nr_cwqs_to_flush[color])) {
+		BUG_ON(color != wq->flush_color);
+		complete(&list_first_entry(&wq->flusher[color],
+					   struct wq_flusher, list)->done);
+	}
 }
 
 /**
@@ -2540,27 +2540,20 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
  * becomes new flush_color and work_color is advanced by one.
  * All cwq's work_color are set to new work_color(advanced by one).
  *
- * The caller should have initialized @wq->first_flusher prior to
- * calling this function.
- *
  * CONTEXT:
  * mutex_lock(wq->flush_mutex).
- *
- * RETURNS:
- * %true if there's some cwqs to flush.  %false otherwise.
  */
-static bool workqueue_start_flush(struct workqueue_struct *wq)
+static void workqueue_start_flush(struct workqueue_struct *wq)
 {
 	int flush_color = wq->work_color;
 	int next_color = work_next_color(wq->work_color);
-	bool wait = false;
 	unsigned int cpu;
 
 	BUG_ON(next_color == wq->flush_color);
 	wq->work_color = next_color;
 
 	BUG_ON(atomic_read(&wq->nr_cwqs_to_flush[flush_color]));
-	/* this ref is held by first flusher */
+	/* this ref is held by the first flusher of previous color */
 	atomic_set(&wq->nr_cwqs_to_flush[flush_color], 1);
 
 	for_each_cwq_cpu(cpu, wq) {
@@ -2569,18 +2562,14 @@ static bool workqueue_start_flush(struct workqueue_struct *wq)
 
 		spin_lock_irq(&gcwq->lock);
 
-		if (cwq->nr_in_flight[flush_color]) {
+		if (cwq->nr_in_flight[flush_color])
 			atomic_inc(&wq->nr_cwqs_to_flush[flush_color]);
-			wait = true;
-		}
 
 		BUG_ON(next_color != work_next_color(cwq->work_color));
 		cwq->work_color = next_color;
 
 		spin_unlock_irq(&gcwq->lock);
 	}
-
-	return wait;
 }
 
 /**
@@ -2597,7 +2586,6 @@ void flush_workqueue(struct workqueue_struct *wq)
 {
 	struct wq_flusher this_flusher = {
 		.list = LIST_HEAD_INIT(this_flusher.list),
-		.flush_color = -1,
 		.done = COMPLETION_INITIALIZER_ONSTACK(this_flusher.done),
 	};
 	struct wq_flusher *next, *tmp;
@@ -2607,115 +2595,39 @@ void flush_workqueue(struct workqueue_struct *wq)
 	lock_map_release(&wq->lockdep_map);
 
 	mutex_lock(&wq->flush_mutex);
-
-	/*
-	 * Start-to-wait phase
-	 */
+	/* prepare to wait */
 	flush_color = wq->work_color;
-	next_color = work_next_color(wq->work_color);
-
-	if (next_color != wq->flush_color) {
-		/* Color space is not full */
-		BUG_ON(!list_empty(&wq->flusher_overflow));
-		this_flusher.flush_color = flush_color;
-
-		if (!wq->first_flusher) {
-			/* no flush in progress, become the first flusher */
-			BUG_ON(wq->flush_color != flush_color);
-
-			wq->first_flusher = &this_flusher;
-
-			if (!workqueue_start_flush(wq)) {
-				/* nothing to flush, done */
-				wq_dec_flusher_ref(wq, flush_color);
-				wq->flush_color = next_color;
-				wq->first_flusher = NULL;
-				goto out_unlock;
-			}
-
-			wq_dec_flusher_ref(wq, flush_color);
-		} else {
-			/* wait in queue */
-			BUG_ON(wq->flush_color == this_flusher.flush_color);
-			list_add_tail(&this_flusher.list, &wq->flusher_queue);
-			workqueue_start_flush(wq);
-		}
-	} else {
-		/*
-		 * Oops, color space is full, wait on overflow queue.
-		 * The next flush completion will assign us
-		 * flush_color and transfer to flusher_queue.
-		 */
-		list_add_tail(&this_flusher.list, &wq->flusher_overflow);
-	}
-
+	next_color = work_next_color(flush_color);
+	list_add_tail(&this_flusher.list, &wq->flusher[flush_color]);
+	/* is color enough ? */
+	if (next_color != wq->flush_color)
+		workqueue_start_flush(wq);
+	/* itself is the tip flusher */
+	if (flush_color == wq->flush_color)
+		wq_dec_flusher_ref(wq, flush_color);
 	mutex_unlock(&wq->flush_mutex);
 
 	wait_for_completion(&this_flusher.done);
-
-	/*
-	 * Wake-up-and-cascade phase
-	 *
-	 * First flushers are responsible for cascading flushes and
-	 * handling overflow.  Non-first flushers can simply return.
-	 */
-	if (wq->first_flusher != &this_flusher)
+	/* is it the first flusher of the color? */
+	if (unlikely(list_empty(&this_flusher.list)))
 		return;
 
 	mutex_lock(&wq->flush_mutex);
-
-	BUG_ON(wq->first_flusher != &this_flusher);
-	BUG_ON(!list_empty(&this_flusher.list));
-	BUG_ON(wq->flush_color != this_flusher.flush_color);
-
+	BUG_ON(flush_color != wq->flush_color);
+	list_del_init(&this_flusher.list);
 	/* complete all the flushers sharing the current flush color */
-	list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
-		if (next->flush_color != wq->flush_color)
-			break;
+	list_for_each_entry_safe(next, tmp, &wq->flusher[flush_color], list) {
 		list_del_init(&next->list);
 		complete(&next->done);
 	}
-
-	BUG_ON(!list_empty(&wq->flusher_overflow) &&
-	       wq->flush_color != work_next_color(wq->work_color));
-
 	/* this flush_color is finished, advance by one */
-	wq->flush_color = work_next_color(wq->flush_color);
-
-	/* one color has been freed, handle overflow queue */
-	if (!list_empty(&wq->flusher_overflow)) {
-		/*
-		 * Assign the same color to all overflowed
-		 * flushers, advance work_color and append to
-		 * flusher_queue.  This is the start-to-wait
-		 * phase for these overflowed flushers.
-		 */
-		list_for_each_entry(tmp, &wq->flusher_overflow, list)
-			tmp->flush_color = wq->work_color;
-
-		list_splice_tail_init(&wq->flusher_overflow,
-				      &wq->flusher_queue);
+	wq->flush_color = next_color;
+	/* start flush for overflowed flushers */
+	if (!list_empty(&wq->flusher[wq->work_color]))
 		workqueue_start_flush(wq);
-	}
-
-	if (list_empty(&wq->flusher_queue)) {
-		BUG_ON(wq->flush_color != wq->work_color);
-		wq->first_flusher = NULL;
-		goto out_unlock;
-	}
-
-	/*
-	 * Need to flush more colors.  Make the next flusher
-	 * the new first flusher and arm it.
-	 */
-	BUG_ON(wq->flush_color == wq->work_color);
-	BUG_ON(wq->flush_color != next->flush_color);
-
-	list_del_init(&next->list);
-	wq->first_flusher = next;
-	wq_dec_flusher_ref(wq, wq->flush_color);
-
-out_unlock:
+	/* arm next flusher */
+	if (wq->work_color != wq->flush_color)
+		wq_dec_flusher_ref(wq, next_color);
 	mutex_unlock(&wq->flush_mutex);
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -3219,10 +3131,10 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
-	for (color = 0; color < WORK_NR_COLORS; color++)
+	for (color = 0; color < WORK_NR_COLORS; color++) {
 		atomic_set(&wq->nr_cwqs_to_flush[color], 0);
-	INIT_LIST_HEAD(&wq->flusher_queue);
-	INIT_LIST_HEAD(&wq->flusher_overflow);
+		INIT_LIST_HEAD(&wq->flusher[color]);
+	}
 
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);----------------------------
 1 file changed, 32 insertions(+), 120 deletions(-)
