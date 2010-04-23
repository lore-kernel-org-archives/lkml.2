Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0DWBKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:10:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46142 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0DWBKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:10:08 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH 4/9] PM: suspend_block: Switch to list of active and inactive suspend blockers
Date: Thu, 22 Apr 2010 18:08:53 -0700
Message-Id: <1271984938-13920-5-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1271984938-13920-4-git-send-email-arve@android.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
 <1271984938-13920-4-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows active suspend blockers to be listed

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 include/linux/suspend_blocker.h |    6 ++-
 kernel/power/suspend_blocker.c  |   85 +++++++++++++++++++++++++++-----------
 2 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/include/linux/suspend_blocker.h b/include/linux/suspend_blocker.h
index 21689cd..1faa433 100755
--- a/include/linux/suspend_blocker.h
+++ b/include/linux/suspend_blocker.h
@@ -16,8 +16,11 @@
 #ifndef _LINUX_SUSPEND_BLOCKER_H
 #define _LINUX_SUSPEND_BLOCKER_H
 
+#include <linux/list.h>
+
 /**
  * struct suspend_blocker - the basic suspend_blocker structure
+ * @link:	List entry for active or inactive list.
  * @flags:	Tracks initialized and active state.
  * @name:	Name used for debugging.
  *
@@ -29,7 +32,8 @@
 
 struct suspend_blocker {
 #ifdef CONFIG_SUSPEND_BLOCKERS
-	atomic_t            flags;
+	struct list_head    link;
+	int                 flags;
 	const char         *name;
 #endif
 };
diff --git a/kernel/power/suspend_blocker.c b/kernel/power/suspend_blocker.c
index 1b345d1..868e8f1 100644
--- a/kernel/power/suspend_blocker.c
+++ b/kernel/power/suspend_blocker.c
@@ -32,9 +32,11 @@ module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
 #define SB_INITIALIZED            (1U << 8)
 #define SB_ACTIVE                 (1U << 9)
 
+static DEFINE_SPINLOCK(list_lock);
 static DEFINE_SPINLOCK(state_lock);
-static atomic_t suspend_block_count;
-static atomic_t current_event_num;
+static LIST_HEAD(inactive_blockers);
+static LIST_HEAD(active_blockers);
+static int current_event_num;
 struct workqueue_struct *suspend_work_queue;
 struct suspend_blocker main_suspend_blocker;
 static suspend_state_t requested_suspend_state = PM_SUSPEND_MEM;
@@ -52,6 +54,14 @@ static bool enable_suspend_blockers;
 			tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec); \
 	} while (0);
 
+static void print_active_blockers_locked(void)
+{
+	struct suspend_blocker *blocker;
+
+	list_for_each_entry(blocker, &active_blockers, link)
+		pr_info("active suspend blocker %s\n", blocker->name);
+}
+
 /**
  * suspend_is_blocked() - Check if suspend should be blocked
  *
@@ -65,7 +75,7 @@ bool suspend_is_blocked(void)
 {
 	if (!enable_suspend_blockers)
 		return 0;
-	return !!atomic_read(&suspend_block_count);
+	return !list_empty(&active_blockers);
 }
 
 static void suspend_worker(struct work_struct *work)
@@ -75,13 +85,13 @@ static void suspend_worker(struct work_struct *work)
 
 	enable_suspend_blockers = true;
 	while (!suspend_is_blocked()) {
-		entry_event_num = atomic_read(&current_event_num);
+		entry_event_num = current_event_num;
 		if (debug_mask & DEBUG_SUSPEND)
 			pr_info("suspend: enter suspend\n");
 		ret = pm_suspend(requested_suspend_state);
 		if (debug_mask & DEBUG_EXIT_SUSPEND)
 			pr_info_time("suspend: exit suspend, ret = %d ", ret);
-		if (atomic_read(&current_event_num) == entry_event_num)
+		if (current_event_num == entry_event_num)
 			pr_info("suspend: pm_suspend returned with no event\n");
 	}
 	enable_suspend_blockers = false;
@@ -98,13 +108,20 @@ static DECLARE_WORK(suspend_work, suspend_worker);
  */
 void suspend_blocker_init(struct suspend_blocker *blocker, const char *name)
 {
+	unsigned long irqflags = 0;
+
 	WARN_ON(!name);
 
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("suspend_blocker_init name=%s\n", name);
 
 	blocker->name = name;
-	atomic_set(&blocker->flags, SB_INITIALIZED);
+	blocker->flags = SB_INITIALIZED;
+	INIT_LIST_HEAD(&blocker->link);
+
+	spin_lock_irqsave(&list_lock, irqflags);
+	list_add(&blocker->link, &inactive_blockers);
+	spin_unlock_irqrestore(&list_lock, irqflags);
 }
 EXPORT_SYMBOL(suspend_blocker_init);
 
@@ -114,15 +131,17 @@ EXPORT_SYMBOL(suspend_blocker_init);
  */
 void suspend_blocker_destroy(struct suspend_blocker *blocker)
 {
-	int flags;
+	unsigned long irqflags;
+	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
+		return;
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("suspend_blocker_destroy name=%s\n", blocker->name);
-	flags = atomic_xchg(&blocker->flags, 0);
-	WARN(!(flags & SB_INITIALIZED), "suspend_blocker_destroy called on "
-					"uninitialized suspend_blocker\n");
-	if (flags == (SB_INITIALIZED | SB_ACTIVE))
-		if (atomic_dec_and_test(&suspend_block_count))
-			queue_work(suspend_work_queue, &suspend_work);
+	spin_lock_irqsave(&list_lock, irqflags);
+	blocker->flags &= ~SB_INITIALIZED;
+	list_del(&blocker->link);
+	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
+		queue_work(suspend_work_queue, &suspend_work);
+	spin_unlock_irqrestore(&list_lock, irqflags);
 }
 EXPORT_SYMBOL(suspend_blocker_destroy);
 
@@ -132,15 +151,20 @@ EXPORT_SYMBOL(suspend_blocker_destroy);
  */
 void suspend_block(struct suspend_blocker *blocker)
 {
-	WARN_ON(!(atomic_read(&blocker->flags) & SB_INITIALIZED));
+	unsigned long irqflags;
+
+	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
+		return;
 
+	spin_lock_irqsave(&list_lock, irqflags);
+	blocker->flags |= SB_ACTIVE;
+	list_del(&blocker->link);
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("suspend_block: %s\n", blocker->name);
-	if (atomic_cmpxchg(&blocker->flags, SB_INITIALIZED,
-	    SB_INITIALIZED | SB_ACTIVE) == SB_INITIALIZED)
-		atomic_inc(&suspend_block_count);
+	list_add(&blocker->link, &active_blockers);
 
-	atomic_inc(&current_event_num);
+	current_event_num++;
+	spin_unlock_irqrestore(&list_lock, irqflags);
 }
 EXPORT_SYMBOL(suspend_block);
 
@@ -152,15 +176,26 @@ EXPORT_SYMBOL(suspend_block);
  */
 void suspend_unblock(struct suspend_blocker *blocker)
 {
-	WARN_ON(!(atomic_read(&blocker->flags) & SB_INITIALIZED));
+	unsigned long irqflags;
+
+	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
+		return;
+
+	spin_lock_irqsave(&list_lock, irqflags);
 
 	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
 		pr_info("suspend_unblock: %s\n", blocker->name);
+	list_del(&blocker->link);
+	list_add(&blocker->link, &inactive_blockers);
 
-	if (atomic_cmpxchg(&blocker->flags, SB_INITIALIZED | SB_ACTIVE,
-	    SB_INITIALIZED) == (SB_INITIALIZED | SB_ACTIVE))
-		if (atomic_dec_and_test(&suspend_block_count))
-			queue_work(suspend_work_queue, &suspend_work);
+	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
+		queue_work(suspend_work_queue, &suspend_work);
+	blocker->flags &= ~(SB_ACTIVE);
+	if (blocker == &main_suspend_blocker) {
+		if (debug_mask & DEBUG_SUSPEND)
+			print_active_blockers_locked();
+	}
+	spin_unlock_irqrestore(&list_lock, irqflags);
 }
 EXPORT_SYMBOL(suspend_unblock);
 
@@ -172,9 +207,9 @@ EXPORT_SYMBOL(suspend_unblock);
  */
 bool suspend_blocker_is_active(struct suspend_blocker *blocker)
 {
-	WARN_ON(!(atomic_read(&blocker->flags) & SB_INITIALIZED));
+	WARN_ON(!(blocker->flags & SB_INITIALIZED));
 
-	return !!(atomic_read(&blocker->flags) & SB_ACTIVE);
+	return !!(blocker->flags & SB_ACTIVE);
 }
 EXPORT_SYMBOL(suspend_blocker_is_active);
 
-- 
1.6.5.1

