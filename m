Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0HYI6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:58:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:52640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab0HYI6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:58:13 -0400
Message-ID: <4C74D9E4.5070403@kernel.org>
Date: Wed, 25 Aug 2010 10:52:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] workqueue: fix cwq->nr_active underflow
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 08:58:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cwq->nr_active is used to keep track of how many work items are active
for the cpu workqueue, where 'active' is defined as either pending on
global worklist or executing.  This is used to implement the
max_active limit and workqueue freezing.  If a work item is queued
after nr_active has already reached max_active, the work item doesn't
increment nr_active and is put on the delayed queue and gets activated
later as previous active work items retire.

try_to_grab_pending() which is used in the cancellation path
unconditionally decremented nr_active whether the work item being
cancelled is currently active or delayed, so cancelling a delayed work
item makes nr_active underflow.  This breaks max_active enforcement
and triggers BUG_ON() in destroy_workqueue() later on.

This patch fixes this bug by adding a flag WORK_STRUCT_DELAYED, which
is set while a work item in on the delayed list and making
try_to_grab_pending() decrement nr_active iff the work item is
currently active.

The addition of the flag enlarges cwq alignment to 256 bytes which is
getting a bit too large.  It's scheduled to be reduced back to 128
bytes by merging WORK_STRUCT_PENDING and WORK_STRUCT_CWQ in the next
devel cycle.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
---
Johannes, although I don't have your confirmation yet, my simple test
case confirms the bug and fix, so I'm pushing it out.  Please let me
know if you can confirm the fix.

Thanks.

 include/linux/workqueue.h |   16 +++++++++-------
 kernel/workqueue.c        |   30 ++++++++++++++++++++----------
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index c959666..f11100f 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -25,18 +25,20 @@ typedef void (*work_func_t)(struct work_struct *work);

 enum {
 	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
-	WORK_STRUCT_CWQ_BIT	= 1,	/* data points to cwq */
-	WORK_STRUCT_LINKED_BIT	= 2,	/* next work is linked to this one */
+	WORK_STRUCT_DELAYED_BIT	= 1,	/* work item is delayed */
+	WORK_STRUCT_CWQ_BIT	= 2,	/* data points to cwq */
+	WORK_STRUCT_LINKED_BIT	= 3,	/* next work is linked to this one */
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
-	WORK_STRUCT_STATIC_BIT	= 3,	/* static initializer (debugobjects) */
-	WORK_STRUCT_COLOR_SHIFT	= 4,	/* color for workqueue flushing */
+	WORK_STRUCT_STATIC_BIT	= 4,	/* static initializer (debugobjects) */
+	WORK_STRUCT_COLOR_SHIFT	= 5,	/* color for workqueue flushing */
 #else
-	WORK_STRUCT_COLOR_SHIFT	= 3,	/* color for workqueue flushing */
+	WORK_STRUCT_COLOR_SHIFT	= 4,	/* color for workqueue flushing */
 #endif

 	WORK_STRUCT_COLOR_BITS	= 4,

 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+	WORK_STRUCT_DELAYED	= 1 << WORK_STRUCT_DELAYED_BIT,
 	WORK_STRUCT_CWQ		= 1 << WORK_STRUCT_CWQ_BIT,
 	WORK_STRUCT_LINKED	= 1 << WORK_STRUCT_LINKED_BIT,
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
@@ -59,8 +61,8 @@ enum {

 	/*
 	 * Reserve 7 bits off of cwq pointer w/ debugobjects turned
-	 * off.  This makes cwqs aligned to 128 bytes which isn't too
-	 * excessive while allowing 15 workqueue flush colors.
+	 * off.  This makes cwqs aligned to 256 bytes and allows 15
+	 * workqueue flush colors.
 	 */
 	WORK_STRUCT_FLAG_BITS	= WORK_STRUCT_COLOR_SHIFT +
 				  WORK_STRUCT_COLOR_BITS,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 362b50d..a2dccfc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -941,6 +941,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
+	unsigned int work_flags;
 	unsigned long flags;

 	debug_work_activate(work);
@@ -990,14 +991,17 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	BUG_ON(!list_empty(&work->entry));

 	cwq->nr_in_flight[cwq->work_color]++;
+	work_flags = work_color_to_flags(cwq->work_color);

 	if (likely(cwq->nr_active < cwq->max_active)) {
 		cwq->nr_active++;
 		worklist = gcwq_determine_ins_pos(gcwq, cwq);
-	} else
+	} else {
+		work_flags |= WORK_STRUCT_DELAYED;
 		worklist = &cwq->delayed_works;
+	}

-	insert_work(cwq, work, worklist, work_color_to_flags(cwq->work_color));
+	insert_work(cwq, work, worklist, work_flags);

 	spin_unlock_irqrestore(&gcwq->lock, flags);
 }
@@ -1666,6 +1670,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);

 	move_linked_works(work, pos, NULL);
+	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
 	cwq->nr_active++;
 }

@@ -1673,6 +1678,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
  * @color: color of work which left the queue
+ * @delayed: for a delayed work
  *
  * A work either has completed or is removed from pending queue,
  * decrement nr_in_flight of its cwq and handle workqueue flushing.
@@ -1680,19 +1686,22 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
  * CONTEXT:
  * spin_lock_irq(gcwq->lock).
  */
-static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
+static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
+				 bool delayed)
 {
 	/* ignore uncolored works */
 	if (color == WORK_NO_COLOR)
 		return;

 	cwq->nr_in_flight[color]--;
-	cwq->nr_active--;

-	if (!list_empty(&cwq->delayed_works)) {
-		/* one down, submit a delayed one */
-		if (cwq->nr_active < cwq->max_active)
-			cwq_activate_first_delayed(cwq);
+	if (!delayed) {
+		cwq->nr_active--;
+		if (!list_empty(&cwq->delayed_works)) {
+			/* one down, submit a delayed one */
+			if (cwq->nr_active < cwq->max_active)
+				cwq_activate_first_delayed(cwq);
+		}
 	}

 	/* is flush in progress and are we at the flushing tip? */
@@ -1823,7 +1832,7 @@ __acquires(&gcwq->lock)
 	hlist_del_init(&worker->hentry);
 	worker->current_work = NULL;
 	worker->current_cwq = NULL;
-	cwq_dec_nr_in_flight(cwq, work_color);
+	cwq_dec_nr_in_flight(cwq, work_color, false);
 }

 /**
@@ -2388,7 +2397,8 @@ static int try_to_grab_pending(struct work_struct *work)
 			debug_work_deactivate(work);
 			list_del_init(&work->entry);
 			cwq_dec_nr_in_flight(get_work_cwq(work),
-					     get_work_color(work));
+				get_work_color(work),
+				*work_data_bits(work) & WORK_STRUCT_DELAYED);
 			ret = 1;
 		}
 	}
-- 
1.7.1

