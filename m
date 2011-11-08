Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1KHDsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:48:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64976 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1KHDso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:48:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6523"; a="133253112"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Christine Chan <cschan@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCHv2 3/3] kernel/timer.c: Use debugobjects to catch deletion of uninitialized timers
Date: Mon,  7 Nov 2011 19:48:28 -0800
Message-Id: <1320724108-20788-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320724108-20788-1-git-send-email-sboyd@codeaurora.org>
References: <1320724108-20788-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christine Chan <cschan@codeaurora.org>

del_timer_sync() calls debug_object_assert_init() to assert that
a timer has been initialized before calling lock_timer_base().
lock_timer_base() would spin forever on a NULL(uninit-ed) base.
The check is added to del_timer() to prevent silent failure, even
though it would not get stuck in an infinite loop.

Signed-off-by: Christine Chan <cschan@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[sboyd: Remove WARN, intialize timer function]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/timer.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 317087d..5fc5a76 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -487,12 +487,40 @@ static int timer_fixup_free(void *addr, enum debug_obj_state state)
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
+			setup_timer(timer, stub_timer, 0);
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
@@ -515,6 +543,11 @@ static inline void debug_timer_free(struct timer_list *timer)
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
@@ -538,6 +571,7 @@ EXPORT_SYMBOL_GPL(destroy_timer_on_stack);
 static inline void debug_timer_init(struct timer_list *timer) { }
 static inline void debug_timer_activate(struct timer_list *timer) { }
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
+static inline void debug_timer_assert_init(struct timer_list *timer) { }
 #endif
 
 static inline void debug_init(struct timer_list *timer)
@@ -559,6 +593,11 @@ static inline void debug_deactivate(struct timer_list *timer)
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
@@ -909,6 +948,8 @@ int del_timer(struct timer_list *timer)
 	unsigned long flags;
 	int ret = 0;
 
+	debug_assert_init(timer);
+
 	timer_stats_timer_clear_start_info(timer);
 	if (timer_pending(timer)) {
 		base = lock_timer_base(timer, &flags);
@@ -939,6 +980,8 @@ int try_to_del_timer_sync(struct timer_list *timer)
 	unsigned long flags;
 	int ret = -1;
 
+	debug_assert_init(timer);
+
 	base = lock_timer_base(timer, &flags);
 
 	if (base->running_timer == timer)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

