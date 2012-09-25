Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2IYJAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:00:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab2IYJAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:00:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,481,1344182400"; 
   d="scan'208";a="5912914"
Message-ID: <50617333.9020903@cn.fujitsu.com>
Date: Tue, 25 Sep 2012 17:02:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] workqueue: restructure flush_workqueue() and start
 all flusher at the same time
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com> <20120924203954.GD29689@google.com>
In-Reply-To: <20120924203954.GD29689@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 17:00:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 17:00:46,
	Serialize complete at 2012/09/25 17:00:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 04:39 AM, Tejun Heo wrote:
> 
> I do like the removal of explicit cascading and would have gone that
> direction if this code is just being implemented but I'm quite
> skeptical whether changing over to that now is justifiable.  Flush
> bugs tend to be nasty and often difficult to track down.
> 

Hi, Tejun

I know your attitude, it is OK if you reject it.

It is not possible to remove cascading. If cascading code is
not in flush_workqueue(), it must be in some where else.

If you force overflow to wait for freed color before do flush(which also
force only one flusher for one color), and force the sole flush_workqueue()
to grab ->flush_mutex twice, we can simplify the flush_workqueue().
(see the attached patch, it remove 100 LOC, and the cascading code becomes
only 3 LOC). But these two forcing slow down the caller a little.

(And if you allow to use SRCU(which is only TWO colors), you can remove another
150 LOC. flush_workqueue() will become single line. But it will add some more overhead
in flush_workqueue() because SRCU's readsite is lockless)

Thanks,
Lai

This patch is applied on top of patch7. it replaces patch8~10

 workqueue.c |  168 ++++++++++--------------------------------------------------
 1 file changed, 30 insertions(+), 138 deletions(-)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index be407e1..bff0ae0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -204,15 +204,6 @@ struct cpu_workqueue_struct {
 };
 
 /*
- * Structure used to wait for workqueue flush.
- */
-struct wq_flusher {
-	struct list_head	list;		/* F: list of flushers */
-	int			flush_color;	/* F: flush color waiting for */
-	struct completion	done;		/* flush completion */
-};
-
-/*
  * All cpumasks are assumed to be always set on UP and thus can't be
  * used to determine whether there's something to be done.
  */
@@ -250,9 +241,8 @@ struct workqueue_struct {
 	int			work_color;	/* F: current work color */
 	int			flush_color;	/* F: current flush color */
 	atomic_t		nr_cwqs_to_flush[WORK_NR_COLORS];
-	struct wq_flusher	*first_flusher;	/* F: first flusher */
-	struct list_head	flusher_queue;	/* F: flush waiters */
-	struct list_head	flusher_overflow; /* F: flush overflow list */
+	struct completion	*flusher[WORK_NR_COLORS]; /* F: flusers */
+	wait_queue_head_t	flusher_overflow; /* flush overflow queue */
 
 	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
@@ -1001,7 +991,7 @@ static void wq_dec_flusher_ref(struct workqueue_struct *wq, int color)
 	 * It will handle the rest.
 	 */
 	if (atomic_dec_and_test(&wq->nr_cwqs_to_flush[color]))
-		complete(&wq->first_flusher->done);
+		complete(wq->flusher[color]);
 }
 
 /**
@@ -2540,27 +2530,20 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
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
+	/* this ref is held by previous flusher */
 	atomic_set(&wq->nr_cwqs_to_flush[flush_color], 1);
 
 	for_each_cwq_cpu(cpu, wq) {
@@ -2569,18 +2552,14 @@ static bool workqueue_start_flush(struct workqueue_struct *wq)
 
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
@@ -2595,127 +2574,41 @@ static bool workqueue_start_flush(struct workqueue_struct *wq)
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	struct wq_flusher this_flusher = {
-		.list = LIST_HEAD_INIT(this_flusher.list),
-		.flush_color = -1,
-		.done = COMPLETION_INITIALIZER_ONSTACK(this_flusher.done),
-	};
-	struct wq_flusher *next, *tmp;
-	int flush_color, next_color;
+	DECLARE_COMPLETION(this_flusher);
+	int flush_color;
 
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
 
+overflow:
+	/* handle overflow*/
+	wait_event(wq->flusher_overflow,
+		   work_next_color(wq->work_color) != wq->flush_color);
 	mutex_lock(&wq->flush_mutex);
-
-	/*
-	 * Start-to-wait phase
-	 */
-	flush_color = wq->work_color;
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
+	if (work_next_color(wq->work_color) == wq->flush_color) {
+		mutex_unlock(&wq->flush_mutex);
+		goto overflow;
 	}
 
+	/* start flush */
+	flush_color = wq->work_color;
+	wq->flusher[flush_color] = &this_flusher;
+	workqueue_start_flush(wq);
+	if (flush_color == wq->flush_color)
+		wq_dec_flusher_ref(wq, flush_color);
 	mutex_unlock(&wq->flush_mutex);
 
-	wait_for_completion(&this_flusher.done);
-
-	/*
-	 * Wake-up-and-cascade phase
-	 *
-	 * First flushers are responsible for cascading flushes and
-	 * handling overflow.  Non-first flushers can simply return.
-	 */
-	if (wq->first_flusher != &this_flusher)
-		return;
+	wait_for_completion(&this_flusher);
 
+	/* finish flush */
 	mutex_lock(&wq->flush_mutex);
-
-	BUG_ON(wq->first_flusher != &this_flusher);
-	BUG_ON(!list_empty(&this_flusher.list));
-	BUG_ON(wq->flush_color != this_flusher.flush_color);
-
-	/* complete all the flushers sharing the current flush color */
-	list_for_each_entry_safe(next, tmp, &wq->flusher_queue, list) {
-		if (next->flush_color != wq->flush_color)
-			break;
-		list_del_init(&next->list);
-		complete(&next->done);
-	}
-
-	BUG_ON(!list_empty(&wq->flusher_overflow) &&
-	       wq->flush_color != work_next_color(wq->work_color));
-
-	/* this flush_color is finished, advance by one */
+	BUG_ON(flush_color != wq->flush_color);
+	BUG_ON(wq->flusher[flush_color] != &this_flusher);
+	wq->flusher[flush_color] = NULL;
 	wq->flush_color = work_next_color(wq->flush_color);
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
-		workqueue_start_flush(wq);
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
+	if (wq->work_color != wq->flush_color)
+		 wq_dec_flusher_ref(wq, wq->flush_color);
+	wake_up(&wq->flusher_overflow);
 	mutex_unlock(&wq->flush_mutex);
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -3221,8 +3114,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_init(&wq->flush_mutex);
 	for (color = 0; color < WORK_NR_COLORS; color++)
 		atomic_set(&wq->nr_cwqs_to_flush[color], 0);
-	INIT_LIST_HEAD(&wq->flusher_queue);
-	INIT_LIST_HEAD(&wq->flusher_overflow);
+	init_waitqueue_head(&wq->flusher_overflow);
 
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
