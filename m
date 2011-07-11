Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab1GKWiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:38:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20478 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab1GKWip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:38:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6404"; a="102904696"
From: Christine Chan <cschan@codeaurora.org>
To: tglx@linutronix.de
Cc: Christine Chan <cschan@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] timer: use debugobjects to catch deletion of uninitialized timers
Date: Mon, 11 Jul 2011 15:38:16 -0700
Message-Id: <1310423896-4006-1-git-send-email-cschan@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

del_timer_sync() calls debug_object_assert_init to assert that
a timer has been initialized before calling lock_timer_base().
lock_timer_base would spin forever on a NULL(uninit-ed) base. The check is
added to del_timer() to prevent silent failure, even though it would not
get stuck in an infinite loop.

Signed-off-by: Christine Chan <cschan@codeaurora.org>
---
 kernel/timer.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 8cff361..e1733d3 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -480,12 +480,41 @@ static int timer_fixup_free(void *addr, enum debug_obj_state state)
 	}
 }
 
+/*
+ * fixup_assert_init is called when:
+ * - an untracked/uninit-ed object is found
+ */
+static int timer_fixup_assert_init(void *addr, enum debug_obj_state state)
+{
+	struct timer_list *timer = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_NOTAVAILABLE:
+		if (timer->entry.prev == TIMER_ENTRY_STATIC) {
+			/*
+			 * This is not really a fixup. The timer was
+			 * statically initialized. We just make sure that it
+			 * is tracked in the object tracker.
+			 */
+			debug_object_init(timer, &timer_debug_descr);
+			return 0;
+		} else {
+			WARN_ON(1);
+			init_timer(timer);
+			return 1;
+		}
+	default:
+		return 0;
+	}
+}
+
 static struct debug_obj_descr timer_debug_descr = {
-	.name		= "timer_list",
-	.debug_hint	= timer_debug_hint,
-	.fixup_init	= timer_fixup_init,
-	.fixup_activate	= timer_fixup_activate,
-	.fixup_free	= timer_fixup_free,
+	.name			= "timer_list",
+	.debug_hint		= timer_debug_hint,
+	.fixup_init		= timer_fixup_init,
+	.fixup_activate		= timer_fixup_activate,
+	.fixup_free		= timer_fixup_free,
+	.fixup_assert_init	= timer_fixup_assert_init,
 };
 
 static inline void debug_timer_init(struct timer_list *timer)
@@ -508,6 +537,11 @@ static inline void debug_timer_free(struct timer_list *timer)
 	debug_object_free(timer, &timer_debug_descr);
 }
 
+static inline void debug_timer_assert_init(struct timer_list *timer)
+{
+	debug_object_assert_init(timer, &timer_debug_descr);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key);
@@ -531,6 +565,7 @@ EXPORT_SYMBOL_GPL(destroy_timer_on_stack);
 static inline void debug_timer_init(struct timer_list *timer) { }
 static inline void debug_timer_activate(struct timer_list *timer) { }
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
+static inline void debug_timer_assert_init(struct timer_list *timer) { }
 #endif
 
 static inline void debug_init(struct timer_list *timer)
@@ -552,6 +587,11 @@ static inline void debug_deactivate(struct timer_list *timer)
 	trace_timer_cancel(timer);
 }
 
+static inline void debug_assert_init(struct timer_list *timer)
+{
+	debug_timer_assert_init(timer);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key)
@@ -902,6 +942,8 @@ int del_timer(struct timer_list *timer)
 	unsigned long flags;
 	int ret = 0;
 
+	debug_assert_init(timer);
+
 	timer_stats_timer_clear_start_info(timer);
 	if (timer_pending(timer)) {
 		base = lock_timer_base(timer, &flags);
@@ -932,6 +974,8 @@ int try_to_del_timer_sync(struct timer_list *timer)
 	unsigned long flags;
 	int ret = -1;
 
+	debug_assert_init(timer);
+
 	base = lock_timer_base(timer, &flags);
 
 	if (base->running_timer == timer)
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

