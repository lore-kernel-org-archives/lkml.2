Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0FNVj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:39:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:46953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab0FNVj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:26 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/30] workqueue: define masks for work flags and conditionalize STATIC flags
Date: Mon, 14 Jun 2010 23:37:23 +0200
Message-Id: <1276551467-21246-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work flags are about to see more traditional mask handling.  Define
WORK_STRUCT_*_BIT as the bit position constant and redefine
WORK_STRUCT_* as bit masks.  Also, make WORK_STRUCT_STATIC_* flags
conditional

While at it, re-define these constants as enums and use
WORK_STRUCT_STATIC instead of hard-coding 2 in
WORK_DATA_STATIC_INIT().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   29 +++++++++++++++++++++--------
 kernel/workqueue.c        |   12 ++++++------
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index d89cfc1..d60c570 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -22,12 +22,25 @@ typedef void (*work_func_t)(struct work_struct *work);
  */
 #define work_data_bits(work) ((unsigned long *)(&(work)->data))
 
+enum {
+	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
+#ifdef CONFIG_DEBUG_OBJECTS_WORK
+	WORK_STRUCT_STATIC_BIT	= 1,	/* static initializer (debugobjects) */
+#endif
+
+	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+#ifdef CONFIG_DEBUG_OBJECTS_WORK
+	WORK_STRUCT_STATIC	= 1 << WORK_STRUCT_STATIC_BIT,
+#else
+	WORK_STRUCT_STATIC	= 0,
+#endif
+
+	WORK_STRUCT_FLAG_MASK	= 3UL,
+	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
+};
+
 struct work_struct {
 	atomic_long_t data;
-#define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
-#define WORK_STRUCT_STATIC  1		/* static initializer (debugobjects) */
-#define WORK_STRUCT_FLAG_MASK (3UL)
-#define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
 #ifdef CONFIG_LOCKDEP
@@ -36,7 +49,7 @@ struct work_struct {
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
-#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(2)
+#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_STATIC)
 
 struct delayed_work {
 	struct work_struct work;
@@ -98,7 +111,7 @@ extern void __init_work(struct work_struct *work, int onstack);
 extern void destroy_work_on_stack(struct work_struct *work);
 static inline unsigned int work_static(struct work_struct *work)
 {
-	return *work_data_bits(work) & (1 << WORK_STRUCT_STATIC);
+	return *work_data_bits(work) & WORK_STRUCT_STATIC;
 }
 #else
 static inline void __init_work(struct work_struct *work, int onstack) { }
@@ -167,7 +180,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
  * @work: The work item in question
  */
 #define work_pending(work) \
-	test_bit(WORK_STRUCT_PENDING, work_data_bits(work))
+	test_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
 
 /**
  * delayed_work_pending - Find out whether a delayable work item is currently
@@ -182,7 +195,7 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
  * @work: The work item in question
  */
 #define work_clear_pending(work) \
-	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
+	clear_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
 
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 68e4dd8..5c49d76 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -115,7 +115,7 @@ static int work_fixup_activate(void *addr, enum debug_obj_state state)
 		 * statically initialized. We just make sure that it
 		 * is tracked in the object tracker.
 		 */
-		if (test_bit(WORK_STRUCT_STATIC, work_data_bits(work))) {
+		if (test_bit(WORK_STRUCT_STATIC_BIT, work_data_bits(work))) {
 			debug_object_init(work, &work_debug_descr);
 			debug_object_activate(work, &work_debug_descr);
 			return 0;
@@ -232,7 +232,7 @@ static inline void set_wq_data(struct work_struct *work,
 	BUG_ON(!work_pending(work));
 
 	atomic_long_set(&work->data, (unsigned long)cwq | work_static(work) |
-			(1UL << WORK_STRUCT_PENDING) | extra_flags);
+			WORK_STRUCT_PENDING | extra_flags);
 }
 
 /*
@@ -330,7 +330,7 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret = 0;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		__queue_work(cpu, wq, work);
 		ret = 1;
 	}
@@ -380,7 +380,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
@@ -516,7 +516,7 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	 * might deadlock.
 	 */
 	INIT_WORK_ON_STACK(&barr->work, wq_barrier_func);
-	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
+	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 	init_completion(&barr->done);
 
 	debug_work_activate(&barr->work);
@@ -628,7 +628,7 @@ static int try_to_grab_pending(struct work_struct *work)
 	struct cpu_workqueue_struct *cwq;
 	int ret = -1;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
 		return 0;
 
 	/*
-- 
1.6.4.2

