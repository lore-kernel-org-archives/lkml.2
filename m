Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0DWBLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:11:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48107 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0DWBKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:10:14 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 6/9] PM: suspend_block: Add suspend_blocker stats
Date: Thu, 22 Apr 2010 18:08:55 -0700
Message-Id: <1271984938-13920-7-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1271984938-13920-6-git-send-email-arve@android.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
 <1271984938-13920-4-git-send-email-arve@android.com>
 <1271984938-13920-5-git-send-email-arve@android.com>
 <1271984938-13920-6-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report suspend block stats in /sys/kernel/debug/suspend_blockers.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 include/linux/suspend_blocker.h |   21 ++++-
 kernel/power/Kconfig            |    7 ++
 kernel/power/power.h            |    6 +-
 kernel/power/suspend.c          |    4 +-
 kernel/power/suspend_blocker.c  |  190 +++++++++++++++++++++++++++++++++++++--
 5 files changed, 218 insertions(+), 10 deletions(-)

diff --git a/include/linux/suspend_blocker.h b/include/linux/suspend_blocker.h
index 1faa433..3bb8a6a 100755
--- a/include/linux/suspend_blocker.h
+++ b/include/linux/suspend_blocker.h
@@ -17,12 +17,21 @@
 #define _LINUX_SUSPEND_BLOCKER_H
 
 #include <linux/list.h>
+#include <linux/ktime.h>
 
 /**
  * struct suspend_blocker - the basic suspend_blocker structure
  * @link:	List entry for active or inactive list.
- * @flags:	Tracks initialized and active state.
+ * @flags:	Tracks initialized, active and stats state.
  * @name:	Name used for debugging.
+ * @count:	Number of times this blocker has been deacivated
+ * @wakeup_count: Number of times this blocker was the first to block suspend
+ *		after resume.
+ * @total_time:	Total time this suspend blocker has prevented suspend.
+ * @prevent_suspend_time: Time this suspend blocker has prevented suspend while
+ *		user-space requested suspend.
+ * @max_time:	Max time this suspend blocker has been continuously active
+ * @last_time:	Monotonic clock when the active state last changed.
  *
  * When a suspend_blocker is active it prevents the system from entering
  * suspend.
@@ -35,6 +44,16 @@ struct suspend_blocker {
 	struct list_head    link;
 	int                 flags;
 	const char         *name;
+#ifdef CONFIG_SUSPEND_BLOCKER_STATS
+	struct {
+		int             count;
+		int             wakeup_count;
+		ktime_t         total_time;
+		ktime_t         prevent_suspend_time;
+		ktime_t         max_time;
+		ktime_t         last_time;
+	} stat;
+#endif
 #endif
 };
 
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 1ac50ee..3fa2d33 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -141,6 +141,13 @@ config SUSPEND_BLOCKERS
 	  state through /sys/power/state, the requested sleep state will be
 	  entered when no suspend blockers are active.
 
+config SUSPEND_BLOCKER_STATS
+	bool "Suspend block stats"
+	depends on SUSPEND_BLOCKERS
+	default y
+	---help---
+	  Report suspend block stats in /sys/kernel/debug/suspend_blockers
+
 config USER_SUSPEND_BLOCKERS
 	bool "Userspace suspend blockers"
 	depends on SUSPEND_BLOCKERS
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 9b468d7..75b8849 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -240,4 +240,8 @@ static inline void suspend_thaw_processes(void)
 /* kernel/power/suspend_block.c */
 extern int request_suspend_state(suspend_state_t state);
 extern bool request_suspend_valid_state(suspend_state_t state);
-
+#ifdef CONFIG_SUSPEND_BLOCKER_STATS
+void about_to_enter_suspend(void);
+#else
+static inline void about_to_enter_suspend(void) {}
+#endif
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index dc42006..6d327ea 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -159,8 +159,10 @@ static int suspend_enter(suspend_state_t state)
 
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
-		if (!suspend_is_blocked() && !suspend_test(TEST_CORE))
+		if (!suspend_is_blocked() && !suspend_test(TEST_CORE)) {
+			about_to_enter_suspend();
 			error = suspend_ops->enter(state);
+		}
 		sysdev_resume();
 	}
 
diff --git a/kernel/power/suspend_blocker.c b/kernel/power/suspend_blocker.c
index 047e910..08d18c2 100644
--- a/kernel/power/suspend_blocker.c
+++ b/kernel/power/suspend_blocker.c
@@ -32,6 +32,7 @@ module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
 
 #define SB_INITIALIZED            (1U << 8)
 #define SB_ACTIVE                 (1U << 9)
+#define SB_PREVENTING_SUSPEND     (1U << 10)
 
 static DEFINE_SPINLOCK(list_lock);
 static DEFINE_SPINLOCK(state_lock);
@@ -42,6 +43,7 @@ struct workqueue_struct *suspend_work_queue;
 struct suspend_blocker main_suspend_blocker;
 static suspend_state_t requested_suspend_state = PM_SUSPEND_MEM;
 static bool enable_suspend_blockers;
+static struct suspend_blocker unknown_wakeup;
 static struct dentry *suspend_blocker_stats_dentry;
 
 #define pr_info_time(fmt, args...) \
@@ -56,6 +58,153 @@ static struct dentry *suspend_blocker_stats_dentry;
 			tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec); \
 	} while (0);
 
+#ifdef CONFIG_SUSPEND_BLOCKER_STATS
+static struct suspend_blocker deleted_suspend_blockers;
+static ktime_t last_sleep_time_update;
+static bool wait_for_wakeup;
+
+static int print_blocker_stat(struct seq_file *m,
+			      struct suspend_blocker *blocker)
+{
+	int lock_count = blocker->stat.count;
+	ktime_t active_time = ktime_set(0, 0);
+	ktime_t total_time = blocker->stat.total_time;
+	ktime_t max_time = blocker->stat.max_time;
+	ktime_t prevent_suspend_time = blocker->stat.prevent_suspend_time;
+	if (blocker->flags & SB_ACTIVE) {
+		ktime_t now, add_time;
+		now = ktime_get();
+		add_time = ktime_sub(now, blocker->stat.last_time);
+		lock_count++;
+		active_time = add_time;
+		total_time = ktime_add(total_time, add_time);
+		if (blocker->flags & SB_PREVENTING_SUSPEND)
+			prevent_suspend_time = ktime_add(prevent_suspend_time,
+					ktime_sub(now, last_sleep_time_update));
+		if (add_time.tv64 > max_time.tv64)
+			max_time = add_time;
+	}
+
+	return seq_printf(m, "\"%s\"\t%d\t%d\t%lld\t%lld\t%lld\t%lld\t%lld\n",
+		       blocker->name, lock_count, blocker->stat.wakeup_count,
+		       ktime_to_ns(active_time), ktime_to_ns(total_time),
+		       ktime_to_ns(prevent_suspend_time), ktime_to_ns(max_time),
+		       ktime_to_ns(blocker->stat.last_time));
+}
+
+
+static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
+{
+	unsigned long irqflags;
+	struct suspend_blocker *blocker;
+
+	seq_puts(m, "name\tcount\twake_count\tactive_since"
+		 "\ttotal_time\tsleep_time\tmax_time\tlast_change\n");
+	spin_lock_irqsave(&list_lock, irqflags);
+	list_for_each_entry(blocker, &inactive_blockers, link)
+		print_blocker_stat(m, blocker);
+	list_for_each_entry(blocker, &active_blockers, link)
+		print_blocker_stat(m, blocker);
+	spin_unlock_irqrestore(&list_lock, irqflags);
+	return 0;
+}
+
+static void suspend_blocker_stat_init_locked(struct suspend_blocker *blocker)
+{
+	blocker->stat.count = 0;
+	blocker->stat.wakeup_count = 0;
+	blocker->stat.total_time = ktime_set(0, 0);
+	blocker->stat.prevent_suspend_time = ktime_set(0, 0);
+	blocker->stat.max_time = ktime_set(0, 0);
+	blocker->stat.last_time = ktime_set(0, 0);
+}
+
+static void suspend_blocker_stat_destroy_locked(struct suspend_blocker *bl)
+{
+	if (!bl->stat.count)
+		return;
+	deleted_suspend_blockers.stat.count += bl->stat.count;
+	deleted_suspend_blockers.stat.total_time = ktime_add(
+		deleted_suspend_blockers.stat.total_time, bl->stat.total_time);
+	deleted_suspend_blockers.stat.prevent_suspend_time = ktime_add(
+		deleted_suspend_blockers.stat.prevent_suspend_time,
+		bl->stat.prevent_suspend_time);
+	deleted_suspend_blockers.stat.max_time = ktime_add(
+		deleted_suspend_blockers.stat.max_time, bl->stat.max_time);
+}
+
+static void suspend_unblock_stat_locked(struct suspend_blocker *blocker)
+{
+	ktime_t duration;
+	ktime_t now;
+	if (!(blocker->flags & SB_ACTIVE))
+		return;
+	now = ktime_get();
+	blocker->stat.count++;
+	duration = ktime_sub(now, blocker->stat.last_time);
+	blocker->stat.total_time =
+		ktime_add(blocker->stat.total_time, duration);
+	if (ktime_to_ns(duration) > ktime_to_ns(blocker->stat.max_time))
+		blocker->stat.max_time = duration;
+	blocker->stat.last_time = ktime_get();
+	if (blocker->flags & SB_PREVENTING_SUSPEND) {
+		duration = ktime_sub(now, last_sleep_time_update);
+		blocker->stat.prevent_suspend_time = ktime_add(
+			blocker->stat.prevent_suspend_time, duration);
+		blocker->flags &= ~SB_PREVENTING_SUSPEND;
+	}
+}
+
+static void suspend_block_stat_locked(struct suspend_blocker *blocker)
+{
+	if (wait_for_wakeup) {
+		if (debug_mask & DEBUG_WAKEUP)
+			pr_info("wakeup suspend blocker: %s\n", blocker->name);
+		wait_for_wakeup = false;
+		blocker->stat.wakeup_count++;
+	}
+	if (!(blocker->flags & SB_ACTIVE))
+		blocker->stat.last_time = ktime_get();
+}
+
+static void update_sleep_wait_stats_locked(bool done)
+{
+	struct suspend_blocker *blocker;
+	ktime_t now, elapsed, add;
+
+	now = ktime_get();
+	elapsed = ktime_sub(now, last_sleep_time_update);
+	list_for_each_entry(blocker, &active_blockers, link) {
+		if (blocker->flags & SB_PREVENTING_SUSPEND) {
+			add = elapsed;
+			blocker->stat.prevent_suspend_time = ktime_add(
+				blocker->stat.prevent_suspend_time, add);
+		}
+		if (done)
+			blocker->flags &= ~SB_PREVENTING_SUSPEND;
+		else
+			blocker->flags |= SB_PREVENTING_SUSPEND;
+	}
+	last_sleep_time_update = now;
+}
+
+void about_to_enter_suspend(void)
+{
+	wait_for_wakeup = true;
+}
+
+#else
+
+static inline void suspend_blocker_stat_init_locked(
+					struct suspend_blocker *blocker) {}
+static inline void suspend_blocker_stat_destroy_locked(
+					struct suspend_blocker *blocker) {}
+static inline void suspend_block_stat_locked(
+					struct suspend_blocker *blocker) {}
+static inline void suspend_unblock_stat_locked(
+					struct suspend_blocker *blocker) {}
+static inline void update_sleep_wait_stats_locked(bool done) {}
+
 static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
 {
 	unsigned long irqflags;
@@ -71,6 +220,8 @@ static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
 	return 0;
 }
 
+#endif
+
 static void print_active_blockers_locked(void)
 {
 	struct suspend_blocker *blocker;
@@ -101,16 +252,26 @@ static void suspend_worker(struct work_struct *work)
 	int entry_event_num;
 
 	enable_suspend_blockers = true;
-	while (!suspend_is_blocked()) {
-		entry_event_num = current_event_num;
+
+	if (suspend_is_blocked()) {
+		if (debug_mask & DEBUG_SUSPEND)
+			pr_info("suspend: abort suspend\n");
+		goto abort;
+	}
+
+	entry_event_num = current_event_num;
+	if (debug_mask & DEBUG_SUSPEND)
+		pr_info("suspend: enter suspend\n");
+	ret = pm_suspend(requested_suspend_state);
+	if (debug_mask & DEBUG_EXIT_SUSPEND)
+		pr_info_time("suspend: exit suspend, ret = %d ", ret);
+	if (current_event_num == entry_event_num) {
 		if (debug_mask & DEBUG_SUSPEND)
-			pr_info("suspend: enter suspend\n");
-		ret = pm_suspend(requested_suspend_state);
-		if (debug_mask & DEBUG_EXIT_SUSPEND)
-			pr_info_time("suspend: exit suspend, ret = %d ", ret);
-		if (current_event_num == entry_event_num)
 			pr_info("suspend: pm_suspend returned with no event\n");
+		suspend_block(&unknown_wakeup);
+		suspend_unblock(&unknown_wakeup);
 	}
+abort:
 	enable_suspend_blockers = false;
 }
 static DECLARE_WORK(suspend_work, suspend_worker);
@@ -137,6 +298,7 @@ void suspend_blocker_init(struct suspend_blocker *blocker, const char *name)
 	INIT_LIST_HEAD(&blocker->link);
 
 	spin_lock_irqsave(&list_lock, irqflags);
+	suspend_blocker_stat_init_locked(blocker);
 	list_add(&blocker->link, &inactive_blockers);
 	spin_unlock_irqrestore(&list_lock, irqflags);
 }
@@ -154,6 +316,7 @@ void suspend_blocker_destroy(struct suspend_blocker *blocker)
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("suspend_blocker_destroy name=%s\n", blocker->name);
 	spin_lock_irqsave(&list_lock, irqflags);
+	suspend_blocker_stat_destroy_locked(blocker);
 	blocker->flags &= ~SB_INITIALIZED;
 	list_del(&blocker->link);
 	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
@@ -174,6 +337,7 @@ void suspend_block(struct suspend_blocker *blocker)
 		return;
 
 	spin_lock_irqsave(&list_lock, irqflags);
+	suspend_block_stat_locked(blocker);
 	blocker->flags |= SB_ACTIVE;
 	list_del(&blocker->link);
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
@@ -181,6 +345,10 @@ void suspend_block(struct suspend_blocker *blocker)
 	list_add(&blocker->link, &active_blockers);
 
 	current_event_num++;
+	if (blocker == &main_suspend_blocker)
+		update_sleep_wait_stats_locked(true);
+	else if (!suspend_blocker_is_active(&main_suspend_blocker))
+		update_sleep_wait_stats_locked(false);
 	spin_unlock_irqrestore(&list_lock, irqflags);
 }
 EXPORT_SYMBOL(suspend_block);
@@ -200,6 +368,8 @@ void suspend_unblock(struct suspend_blocker *blocker)
 
 	spin_lock_irqsave(&list_lock, irqflags);
 
+	suspend_unblock_stat_locked(blocker);
+
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("suspend_unblock: %s\n", blocker->name);
 	list_del(&blocker->link);
@@ -211,6 +381,7 @@ void suspend_unblock(struct suspend_blocker *blocker)
 	if (blocker == &main_suspend_blocker) {
 		if (debug_mask & DEBUG_SUSPEND)
 			print_active_blockers_locked();
+		update_sleep_wait_stats_locked(false);
 	}
 	spin_unlock_irqrestore(&list_lock, irqflags);
 }
@@ -278,6 +449,11 @@ static int __init suspend_block_init(void)
 
 	suspend_blocker_init(&main_suspend_blocker, "main");
 	suspend_block(&main_suspend_blocker);
+	suspend_blocker_init(&unknown_wakeup, "unknown_wakeups");
+#ifdef CONFIG_SUSPEND_BLOCKER_STATS
+	suspend_blocker_init(&deleted_suspend_blockers,
+				"deleted_suspend_blockers");
+#endif
 	return 0;
 }
 
-- 
1.6.5.1

