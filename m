Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992755Ab2KOHlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:41:50 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52789 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KOHlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:41:49 -0500
Date: Wed, 14 Nov 2012 23:41:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Robert Richter <robert.richter@amd.com>
cc: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [patch 1/2] oprofile: move task handoff to oprofile
Message-ID: <alpine.DEB.2.00.1211142340490.4410@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the discussion surrounding 83dbbdbb3866 ("android, lowmemorykiller:
remove task handoff notifier"), I promised to isolate the task handoff
notifier to oprofile.  The bug that was fixed in that commit occurred
because a task handoff notifier registered before oprofile was not
freeing the task_struct appropriately.  In a chain of multiple possible
notifiers, it's impossible to determine which one was called last to
actually do the freeing, which leads to a task_struct leak.

Oprofile is the only user of the task handoff notifier, so move it to the 
oprofile code so nobody can use it accidently again.  It will be the only
subsystem allowed to use task handoffs.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/oprofile/buffer_sync.c |   18 ++++++++++++++++++
 include/linux/profile.h        |   35 +++++++++++++----------------------
 kernel/profile.c               |   20 --------------------
 3 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -42,6 +42,24 @@ static LIST_HEAD(dead_tasks);
 static cpumask_var_t marked_cpus;
 static DEFINE_SPINLOCK(task_mortuary);
 static void process_task_mortuary(void);
+static ATOMIC_NOTIFIER_HEAD(task_free_notifier);
+
+static int task_handoff_register(struct notifier_block *n)
+{
+	return atomic_notifier_chain_register(&task_free_notifier, n);
+}
+
+static int task_handoff_unregister(struct notifier_block *n)
+{
+	return atomic_notifier_chain_unregister(&task_free_notifier, n);
+}
+
+int profile_handoff_task(struct task_struct *task)
+{
+	int ret;
+	ret = atomic_notifier_call_chain(&task_free_notifier, 0, task);
+	return (ret == NOTIFY_OK) ? 1 : 0;
+}
 
 /* Take ownership of the task struct and place it on the
  * list for processing. Only after two full buffer syncs
diff --git a/include/linux/profile.h b/include/linux/profile.h
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -16,6 +16,7 @@
 struct proc_dir_entry;
 struct pt_regs;
 struct notifier_block;
+struct task_struct;
 
 #if defined(CONFIG_PROFILING) && defined(CONFIG_PROC_FS)
 void create_prof_cpu_mask(struct proc_dir_entry *de);
@@ -36,6 +37,18 @@ enum profile_type {
 	PROFILE_MUNMAP
 };
 
+#if defined(CONFIG_PROFILING) && defined(CONFIG_OPROFILE)
+/* task is dead, free task struct ? Returns 1 if
+ * the task was taken, 0 if the task should be freed.
+ */
+int profile_handoff_task(struct task_struct *task);
+#else
+static inline int profile_handoff_task(struct task_struct *task)
+{
+	return 0;
+}
+#endif /* CONFIG_PROFILING && CONFIG_OPROFILE */
+
 #ifdef CONFIG_PROFILING
 
 extern int prof_on __read_mostly;
@@ -62,23 +75,12 @@ static inline void profile_hit(int type, void *ip)
 		profile_hits(type, ip, 1);
 }
 
-struct task_struct;
-struct mm_struct;
-
 /* task is in do_exit() */
 void profile_task_exit(struct task_struct * task);
 
-/* task is dead, free task struct ? Returns 1 if
- * the task was taken, 0 if the task should be freed.
- */
-int profile_handoff_task(struct task_struct * task);
-
 /* sys_munmap */
 void profile_munmap(unsigned long addr);
 
-int task_handoff_register(struct notifier_block * n);
-int task_handoff_unregister(struct notifier_block * n);
-
 int profile_event_register(enum profile_type, struct notifier_block * n);
 int profile_event_unregister(enum profile_type, struct notifier_block * n);
 
@@ -111,16 +113,6 @@ static inline void profile_hit(int type, void *ip)
 	return;
 }
 
-static inline int task_handoff_register(struct notifier_block * n)
-{
-	return -ENOSYS;
-}
-
-static inline int task_handoff_unregister(struct notifier_block * n)
-{
-	return -ENOSYS;
-}
-
 static inline int profile_event_register(enum profile_type t, struct notifier_block * n)
 {
 	return -ENOSYS;
@@ -132,7 +124,6 @@ static inline int profile_event_unregister(enum profile_type t, struct notifier_
 }
 
 #define profile_task_exit(a) do { } while (0)
-#define profile_handoff_task(a) (0)
 #define profile_munmap(a) do { } while (0)
 
 static inline int register_timer_hook(int (*hook)(struct pt_regs *))
diff --git a/kernel/profile.c b/kernel/profile.c
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -137,7 +137,6 @@ int __ref profile_init(void)
 /* Profile event notifications */
 
 static BLOCKING_NOTIFIER_HEAD(task_exit_notifier);
-static ATOMIC_NOTIFIER_HEAD(task_free_notifier);
 static BLOCKING_NOTIFIER_HEAD(munmap_notifier);
 
 void profile_task_exit(struct task_struct *task)
@@ -145,30 +144,11 @@ void profile_task_exit(struct task_struct *task)
 	blocking_notifier_call_chain(&task_exit_notifier, 0, task);
 }
 
-int profile_handoff_task(struct task_struct *task)
-{
-	int ret;
-	ret = atomic_notifier_call_chain(&task_free_notifier, 0, task);
-	return (ret == NOTIFY_OK) ? 1 : 0;
-}
-
 void profile_munmap(unsigned long addr)
 {
 	blocking_notifier_call_chain(&munmap_notifier, 0, (void *)addr);
 }
 
-int task_handoff_register(struct notifier_block *n)
-{
-	return atomic_notifier_chain_register(&task_free_notifier, n);
-}
-EXPORT_SYMBOL_GPL(task_handoff_register);
-
-int task_handoff_unregister(struct notifier_block *n)
-{
-	return atomic_notifier_chain_unregister(&task_free_notifier, n);
-}
-EXPORT_SYMBOL_GPL(task_handoff_unregister);
-
 int profile_event_register(enum profile_type type, struct notifier_block *n)
 {
 	int err = -EINVAL;
