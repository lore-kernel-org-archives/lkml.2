Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0LIJKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:10:24 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:12236 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755227Ab0LIJKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:10:20 -0500
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 04:10:20 EST
From: Octavian Purdila <opurdila@ixiacom.com>
To: linux-kernel@vger.kernel.org
Cc: Octavian Purdila <opurdila@ixiacom.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] perf: add "wait" event
Date: Thu,  9 Dec 2010 10:54:44 +0200
Message-Id: <1291884884-4346-1-git-send-email-opurdila@ixiacom.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 09 Dec 2010 08:55:06.0589 (UTC) FILETIME=[C6B930D0:01CB977E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new event which counts the number of times a task is
waiting (via sleeping) for an event. It hooks into event_wait,
wait_completion, sleep_on and cond_sched.

It is useful for identifying expensive wait operations such as
synchronize_rcu(). The patch was developed from a previous one which
counted sync-rcu operations, but this approach seems better since it
is less intrusive and more generic.

Signed-off-by: Octavian Purdila <opurdila@ixiacom.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h     |    1 +
 kernel/sched.c                 |    3 +++
 kernel/wait.c                  |    5 +++++
 tools/perf/util/parse-events.c |    2 ++
 4 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..427522d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -105,6 +105,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_WAIT			= 9,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
diff --git a/kernel/sched.c b/kernel/sched.c
index aa14a56..d8ddbad 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4248,6 +4248,7 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 			}
 			__set_current_state(state);
 			spin_unlock_irq(&x->wait.lock);
+			perf_sw_event(PERF_COUNT_SW_WAIT, 1, 1, NULL, 0);
 			timeout = schedule_timeout(timeout);
 			spin_lock_irq(&x->wait.lock);
 		} while (!x->done && timeout);
@@ -4428,6 +4429,7 @@ sleep_on_common(wait_queue_head_t *q, int state, long timeout)
 	spin_lock_irqsave(&q->lock, flags);
 	__add_wait_queue(q, &wait);
 	spin_unlock(&q->lock);
+	perf_sw_event(PERF_COUNT_SW_WAIT, 1, 1, NULL, 0);
 	timeout = schedule_timeout(timeout);
 	spin_lock_irq(&q->lock);
 	__remove_wait_queue(q, &wait);
@@ -5186,6 +5188,7 @@ static inline int should_resched(void)
 static void __cond_resched(void)
 {
 	add_preempt_count(PREEMPT_ACTIVE);
+	perf_sw_event(PERF_COUNT_SW_WAIT, 1, 1, NULL, 0);
 	schedule();
 	sub_preempt_count(PREEMPT_ACTIVE);
 }
diff --git a/kernel/wait.c b/kernel/wait.c
index b0310eb..3774de3 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/wait.h>
 #include <linux/hash.h>
+#include <linux/perf_event.h>
 
 void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *key)
 {
@@ -69,6 +70,8 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
 
+	perf_sw_event(PERF_COUNT_SW_WAIT, 1, 1, NULL, 0);
+
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
@@ -83,6 +86,8 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
 
+	perf_sw_event(PERF_COUNT_SW_WAIT, 1, 1, NULL, 0);
+
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4af5bd5..8387297 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -51,6 +51,7 @@ static struct event_symbol event_symbols[] = {
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
   { CSW(ALIGNMENT_FAULTS),	"alignment-faults",	""		},
   { CSW(EMULATION_FAULTS),	"emulation-faults",	""		},
+  { CSW(WAIT),			"wait",			""		},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
@@ -81,6 +82,7 @@ static const char *sw_event_names[] = {
 	"major-faults",
 	"alignment-faults",
 	"emulation-faults",
+	"wait",
 };
 
 #define MAX_ALIASES 8
-- 
1.7.1

