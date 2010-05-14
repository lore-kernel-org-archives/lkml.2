Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0ENEMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:12:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52482 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0ENELj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:11:39 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
       Len Brown <len.brown@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 5/8] PM: suspend_block: Add suspend_blocker stats
Date: Thu, 13 May 2010 21:11:10 -0700
Message-Id: <1273810273-3039-6-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1273810273-3039-5-git-send-email-arve@android.com>
References: <1273810273-3039-1-git-send-email-arve@android.com>
 <1273810273-3039-2-git-send-email-arve@android.com>
 <1273810273-3039-3-git-send-email-arve@android.com>
 <1273810273-3039-4-git-send-email-arve@android.com>
 <1273810273-3039-5-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report suspend block stats in /sys/kernel/debug/suspend_blockers.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 include/linux/suspend_blocker.h      |   27 +++++-
 kernel/power/Kconfig                 |    8 ++
 kernel/power/opportunistic_suspend.c |  200 +++++++++++++++++++++++++++++++++-
 kernel/power/power.h                 |    5 +
 kernel/power/suspend.c               |    4 +-
 5 files changed, 239 insertions(+), 5 deletions(-)

diff --git a/include/linux/suspend_blocker.h b/include/linux/suspend_blocker.h
index 8788302..256af15 100755
--- a/include/linux/suspend_blocker.h
+++ b/include/linux/suspend_blocker.h
@@ -17,11 +17,35 @@
 #define _LINUX_SUSPEND_BLOCKER_H
 
 #include <linux/list.h>
+#include <linux/ktime.h>
+
+/**
+ * struct suspend_blocker_stats - statistics for a suspend blocker
+ *
+ * @count: Number of times this blocker has been deacivated.
+ * @wakeup_count: Number of times this blocker was the first to block suspend
+ *	after resume.
+ * @total_time: Total time this suspend blocker has prevented suspend.
+ * @prevent_suspend_time: Time this suspend blocker has prevented suspend while
+ *	user-space requested suspend.
+ * @max_time: Max time this suspend blocker has been continuously active.
+ * @last_time: Monotonic clock when the active state last changed.
+ */
+struct suspend_blocker_stats {
+#ifdef CONFIG_SUSPEND_BLOCKER_STATS
+	unsigned int count;
+	unsigned int wakeup_count;
+	ktime_t total_time;
+	ktime_t prevent_suspend_time;
+	ktime_t max_time;
+	ktime_t last_time;
+#endif
+};
 
 /**
  * struct suspend_blocker - the basic suspend_blocker structure
  * @link: List entry for active or inactive list.
- * @flags: Tracks initialized and active state.
+ * @flags: Tracks initialized and active state and statistics.
  * @name: Suspend blocker name used for debugging.
  *
  * When a suspend_blocker is active it prevents the system from entering
@@ -34,6 +58,7 @@ struct suspend_blocker {
 	struct list_head link;
 	int flags;
 	const char *name;
+	struct suspend_blocker_stats stat;
 #endif
 };
 
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 2e665cd..16a2570 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -146,6 +146,14 @@ config OPPORTUNISTIC_SUSPEND
 	  determines the sleep state the system will be put into when there are
 	  no active suspend blockers.
 
+config SUSPEND_BLOCKER_STATS
+	bool "Suspend blockers statistics"
+	depends on OPPORTUNISTIC_SUSPEND
+	default y
+	---help---
+	  Use /sys/kernel/debug/suspend_blockers to report suspend blockers
+	  statistics.
+
 config USER_SUSPEND_BLOCKERS
 	bool "User space suspend blockers"
 	depends on OPPORTUNISTIC_SUSPEND
diff --git a/kernel/power/opportunistic_suspend.c b/kernel/power/opportunistic_suspend.c
index c2dad76..3f0153d 100644
--- a/kernel/power/opportunistic_suspend.c
+++ b/kernel/power/opportunistic_suspend.c
@@ -35,6 +35,7 @@ module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
 
 #define SB_INITIALIZED            (1U << 8)
 #define SB_ACTIVE                 (1U << 9)
+#define SB_PREVENTING_SUSPEND     (1U << 10)
 
 DEFINE_SUSPEND_BLOCKER(main_suspend_blocker, main);
 
@@ -45,6 +46,118 @@ static LIST_HEAD(active_blockers);
 static int current_event_num;
 static suspend_state_t requested_suspend_state = PM_SUSPEND_MEM;
 static bool enable_suspend_blockers;
+static DEFINE_SUSPEND_BLOCKER(unknown_wakeup, unknown_wakeups);
+
+#ifdef CONFIG_SUSPEND_BLOCKER_STATS
+static struct suspend_blocker_stats dropped_suspend_blockers;
+static ktime_t last_sleep_time_update;
+static bool wait_for_wakeup;
+
+static void suspend_blocker_stat_init(struct suspend_blocker_stats *stat)
+{
+	stat->count = 0;
+	stat->wakeup_count = 0;
+	stat->total_time = ktime_set(0, 0);
+	stat->prevent_suspend_time = ktime_set(0, 0);
+	stat->max_time = ktime_set(0, 0);
+	stat->last_time = ktime_set(0, 0);
+}
+
+static void init_dropped_suspend_blockers(void)
+{
+	suspend_blocker_stat_init(&dropped_suspend_blockers);
+}
+
+static void suspend_blocker_stat_drop(struct suspend_blocker_stats *stat)
+{
+	if (!stat->count)
+		return;
+
+	dropped_suspend_blockers.count += stat->count;
+	dropped_suspend_blockers.total_time = ktime_add(
+		dropped_suspend_blockers.total_time, stat->total_time);
+	dropped_suspend_blockers.prevent_suspend_time = ktime_add(
+		dropped_suspend_blockers.prevent_suspend_time,
+		stat->prevent_suspend_time);
+	dropped_suspend_blockers.max_time = ktime_add(
+		dropped_suspend_blockers.max_time, stat->max_time);
+}
+
+static void suspend_unblock_stat(struct suspend_blocker *blocker)
+{
+	struct suspend_blocker_stats *stat = &blocker->stat;
+	ktime_t duration;
+	ktime_t now;
+
+	if (!(blocker->flags & SB_ACTIVE))
+		return;
+
+	now = ktime_get();
+	stat->count++;
+	duration = ktime_sub(now, stat->last_time);
+	stat->total_time = ktime_add(stat->total_time, duration);
+	if (ktime_to_ns(duration) > ktime_to_ns(stat->max_time))
+		stat->max_time = duration;
+
+	stat->last_time = ktime_get();
+	if (blocker->flags & SB_PREVENTING_SUSPEND) {
+		duration = ktime_sub(now, last_sleep_time_update);
+		stat->prevent_suspend_time = ktime_add(
+			stat->prevent_suspend_time, duration);
+		blocker->flags &= ~SB_PREVENTING_SUSPEND;
+	}
+}
+
+static void suspend_block_stat(struct suspend_blocker *blocker)
+{
+	if (wait_for_wakeup) {
+		if (debug_mask & DEBUG_WAKEUP)
+			pr_info("wakeup suspend blocker: %s\n", blocker->name);
+
+		wait_for_wakeup = false;
+		blocker->stat.wakeup_count++;
+	}
+	if (!(blocker->flags & SB_ACTIVE))
+		blocker->stat.last_time = ktime_get();
+}
+
+static void update_sleep_wait_stats(bool done)
+{
+	struct suspend_blocker *blocker;
+	ktime_t now, elapsed, add;
+
+	now = ktime_get();
+	elapsed = ktime_sub(now, last_sleep_time_update);
+	list_for_each_entry(blocker, &active_blockers, link) {
+		struct suspend_blocker_stats *stat = &blocker->stat;
+
+		if (blocker->flags & SB_PREVENTING_SUSPEND) {
+			add = elapsed;
+			stat->prevent_suspend_time = ktime_add(
+				stat->prevent_suspend_time, add);
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
+#else /* !CONFIG_SUSPEND_BLOCKER_STATS */
+
+static inline void init_dropped_suspend_blockers(void) {}
+static inline void suspend_blocker_stat_init(struct suspend_blocker_stats *s) {}
+static inline void suspend_blocker_stat_drop(struct suspend_blocker_stats *s) {}
+static inline void suspend_unblock_stat(struct suspend_blocker *blocker) {}
+static inline void suspend_block_stat(struct suspend_blocker *blocker) {}
+static inline void update_sleep_wait_stats(bool done) {}
+#endif /* !CONFIG_SUSPEND_BLOCKER_STATS */
 
 #define pr_info_time(fmt, args...) \
 	do { \
@@ -103,7 +216,8 @@ static void suspend_worker(struct work_struct *work)
 	if (current_event_num == entry_event_num) {
 		if (debug_mask & DEBUG_SUSPEND)
 			pr_info("PM: pm_suspend() returned with no event\n");
-		queue_work(pm_wq, work);
+		suspend_block(&unknown_wakeup);
+		suspend_unblock(&unknown_wakeup);
 	}
 
 abort:
@@ -127,6 +241,8 @@ void suspend_blocker_register(struct suspend_blocker *blocker)
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("%s: Registering %s\n", __func__, blocker->name);
 
+	suspend_blocker_stat_init(&blocker->stat);
+
 	blocker->flags = SB_INITIALIZED;
 	INIT_LIST_HEAD(&blocker->link);
 
@@ -164,6 +280,10 @@ void suspend_blocker_unregister(struct suspend_blocker *blocker)
 		return;
 
 	spin_lock_irqsave(&list_lock, irqflags);
+
+	suspend_unblock_stat(blocker);
+	suspend_blocker_stat_drop(&blocker->stat);
+
 	blocker->flags &= ~SB_INITIALIZED;
 	list_del(&blocker->link);
 	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
@@ -193,11 +313,18 @@ void suspend_block(struct suspend_blocker *blocker)
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("%s: %s\n", __func__, blocker->name);
 
+	suspend_block_stat(blocker);
+
 	blocker->flags |= SB_ACTIVE;
 	list_move(&blocker->link, &active_blockers);
 
 	current_event_num++;
 
+	if (blocker == &main_suspend_blocker)
+		update_sleep_wait_stats(true);
+	else if (!suspend_blocker_is_active(&main_suspend_blocker))
+		update_sleep_wait_stats(false);
+
 	spin_unlock_irqrestore(&list_lock, irqflags);
 }
 EXPORT_SYMBOL(suspend_block);
@@ -222,13 +349,19 @@ void suspend_unblock(struct suspend_blocker *blocker)
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("%s: %s\n", __func__, blocker->name);
 
+	suspend_unblock_stat(blocker);
+
 	list_move(&blocker->link, &inactive_blockers);
 	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
 		queue_work(pm_wq, &suspend_work);
 	blocker->flags &= ~(SB_ACTIVE);
 
-	if ((debug_mask & DEBUG_SUSPEND) && blocker == &main_suspend_blocker)
-		print_active_suspend_blockers();
+	if (blocker == &main_suspend_blocker) {
+		if (debug_mask & DEBUG_SUSPEND)
+			print_active_suspend_blockers();
+
+		update_sleep_wait_stats(false);
+	}
 
 	spin_unlock_irqrestore(&list_lock, irqflags);
 }
@@ -283,10 +416,69 @@ void __init opportunistic_suspend_init(void)
 {
 	suspend_blocker_register(&main_suspend_blocker);
 	suspend_block(&main_suspend_blocker);
+	suspend_blocker_register(&unknown_wakeup);
+	init_dropped_suspend_blockers();
 }
 
 static struct dentry *suspend_blocker_stats_dentry;
 
+#ifdef CONFIG_SUSPEND_BLOCKER_STATS
+static int print_blocker_stats(struct seq_file *m, const char *name,
+				struct suspend_blocker_stats *stat, int flags)
+{
+	int lock_count = stat->count;
+	ktime_t active_time = ktime_set(0, 0);
+	ktime_t total_time = stat->total_time;
+	ktime_t max_time = stat->max_time;
+	ktime_t prevent_suspend_time = stat->prevent_suspend_time;
+
+	if (flags & SB_ACTIVE) {
+		ktime_t now, add_time;
+
+		now = ktime_get();
+		add_time = ktime_sub(now, stat->last_time);
+		lock_count++;
+		active_time = add_time;
+		total_time = ktime_add(total_time, add_time);
+		if (flags & SB_PREVENTING_SUSPEND)
+			prevent_suspend_time = ktime_add(prevent_suspend_time,
+					ktime_sub(now, last_sleep_time_update));
+		if (add_time.tv64 > max_time.tv64)
+			max_time = add_time;
+	}
+
+	return seq_printf(m, "\"%s\"\t%d\t%d\t%lld\t%lld\t%lld\t%lld\t%lld\n",
+			name, lock_count, stat->wakeup_count,
+			ktime_to_ns(active_time), ktime_to_ns(total_time),
+			ktime_to_ns(prevent_suspend_time),
+			ktime_to_ns(max_time),
+			ktime_to_ns(stat->last_time));
+}
+
+static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
+{
+	unsigned long irqflags;
+	struct suspend_blocker *blocker;
+
+	seq_puts(m, "name\tcount\twake_count\tactive_since"
+		 "\ttotal_time\tsleep_time\tmax_time\tlast_change\n");
+
+	spin_lock_irqsave(&list_lock, irqflags);
+	list_for_each_entry(blocker, &active_blockers, link)
+		print_blocker_stats(m,
+				blocker->name, &blocker->stat, blocker->flags);
+
+	list_for_each_entry(blocker, &inactive_blockers, link)
+		print_blocker_stats(m,
+				blocker->name, &blocker->stat, blocker->flags);
+
+	print_blocker_stats(m, "deleted", &dropped_suspend_blockers, 0);
+	spin_unlock_irqrestore(&list_lock, irqflags);
+	return 0;
+}
+
+#else
+
 static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
 {
 	unsigned long irqflags;
@@ -302,6 +494,8 @@ static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
 	return 0;
 }
 
+#endif
+
 static int suspend_blocker_stats_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, suspend_blocker_stats_show, NULL);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 2e9cfd5..e13c975 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -245,3 +245,8 @@ extern void __init opportunistic_suspend_init(void);
 #else
 static inline void opportunistic_suspend_init(void) {}
 #endif
+#ifdef CONFIG_SUSPEND_BLOCKER_STATS
+void about_to_enter_suspend(void);
+#else
+static inline void about_to_enter_suspend(void) {}
+#endif
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 9eb3876..df694e7 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -158,8 +158,10 @@ static int suspend_enter(suspend_state_t state)
 
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
-		if (!suspend_is_blocked() && !suspend_test(TEST_CORE))
+		if (!suspend_is_blocked() && !suspend_test(TEST_CORE)) {
+			about_to_enter_suspend();
 			error = suspend_ops->enter(state);
+		}
 		sysdev_resume();
 	}
 
-- 
1.6.5.1

