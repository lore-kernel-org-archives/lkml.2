Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1K1OVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:21:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1K1OV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:21:28 -0500
Date: Mon, 28 Nov 2011 06:21:11 -0800
From: tip-bot for Christine Chan <cschan@codeaurora.org>
Message-ID: <tip-dc4218bd0fe499fce2896f88101ea42dac1f60fc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, cschan@codeaurora.org,
        tglx@linutronix.de, sboyd@codeaurora.org
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        cschan@codeaurora.org, tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1320724108-20788-4-git-send-email-sboyd@codeaurora.org>
References: <1320724108-20788-4-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debugobjects] timer: Use debugobjects to catch deletion of uninitialized timers
Git-Commit-ID: dc4218bd0fe499fce2896f88101ea42dac1f60fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 28 Nov 2011 06:21:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc4218bd0fe499fce2896f88101ea42dac1f60fc
Gitweb:     http://git.kernel.org/tip/dc4218bd0fe499fce2896f88101ea42dac1f60fc
Author:     Christine Chan <cschan@codeaurora.org>
AuthorDate: Mon, 7 Nov 2011 19:48:28 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Nov 2011 18:49:23 +0100

timer: Use debugobjects to catch deletion of uninitialized timers

del_timer_sync() calls debug_object_assert_init() to assert that
a timer has been initialized before calling lock_timer_base().
lock_timer_base() would spin forever on a NULL(uninit-ed) base.
The check is added to del_timer() to prevent silent failure, even
though it would not get stuck in an infinite loop.

[ sboyd@codeaurora.org: Remove WARN, intialize timer function]

Signed-off-by: Christine Chan <cschan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/1320724108-20788-4-git-send-email-sboyd@codeaurora.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
