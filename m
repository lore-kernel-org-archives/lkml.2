Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992828Ab2KOHly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:41:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46064 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992762Ab2KOHlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:41:51 -0500
Date: Wed, 14 Nov 2012 23:41:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Robert Richter <robert.richter@amd.com>
cc: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [patch 2/2] oprofile: simplify task handoff
In-Reply-To: <alpine.DEB.2.00.1211142340490.4410@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1211142341290.4410@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1211142340490.4410@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the task handoff notifier is isolated only to oprofile, it no
longer consists of a possible chain of notifiers.  Thus, it's easy to
replace it with a simple linked list when enabled, which is anytime that
the notifier would have been registered.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/oprofile/buffer_sync.c |   68 ++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 45 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -42,24 +42,7 @@ static LIST_HEAD(dead_tasks);
 static cpumask_var_t marked_cpus;
 static DEFINE_SPINLOCK(task_mortuary);
 static void process_task_mortuary(void);
-static ATOMIC_NOTIFIER_HEAD(task_free_notifier);
-
-static int task_handoff_register(struct notifier_block *n)
-{
-	return atomic_notifier_chain_register(&task_free_notifier, n);
-}
-
-static int task_handoff_unregister(struct notifier_block *n)
-{
-	return atomic_notifier_chain_unregister(&task_free_notifier, n);
-}
-
-int profile_handoff_task(struct task_struct *task)
-{
-	int ret;
-	ret = atomic_notifier_call_chain(&task_free_notifier, 0, task);
-	return (ret == NOTIFY_OK) ? 1 : 0;
-}
+static bool task_handoff_enabled __read_mostly;
 
 /* Take ownership of the task struct and place it on the
  * list for processing. Only after two full buffer syncs
@@ -68,15 +51,17 @@ int profile_handoff_task(struct task_struct *task)
  * Can be invoked from softirq via RCU callback due to
  * call_rcu() of the task struct, hence the _irqsave.
  */
-static int
-task_free_notify(struct notifier_block *self, unsigned long val, void *data)
+int profile_handoff_task(struct task_struct *task)
 {
 	unsigned long flags;
-	struct task_struct *task = data;
-	spin_lock_irqsave(&task_mortuary, flags);
-	list_add(&task->tasks, &dying_tasks);
-	spin_unlock_irqrestore(&task_mortuary, flags);
-	return NOTIFY_OK;
+
+	if (task_handoff_enabled) {
+		spin_lock_irqsave(&task_mortuary, flags);
+		list_add(&task->tasks, &dying_tasks);
+		spin_unlock_irqrestore(&task_mortuary, flags);
+		return 1;
+	}
+	return 0;
 }
 
 
@@ -143,10 +128,6 @@ module_load_notify(struct notifier_block *self, unsigned long val, void *data)
 }
 
 
-static struct notifier_block task_free_nb = {
-	.notifier_call	= task_free_notify,
-};
-
 static struct notifier_block task_exit_nb = {
 	.notifier_call	= task_exit_notify,
 };
@@ -173,33 +154,30 @@ int sync_start(void)
 	if (!zalloc_cpumask_var(&marked_cpus, GFP_KERNEL))
 		return -ENOMEM;
 
-	err = task_handoff_register(&task_free_nb);
-	if (err)
-		goto out1;
+	task_handoff_enabled = true;
+	barrier();
 	err = profile_event_register(PROFILE_TASK_EXIT, &task_exit_nb);
 	if (err)
-		goto out2;
+		goto out1;
 	err = profile_event_register(PROFILE_MUNMAP, &munmap_nb);
 	if (err)
-		goto out3;
+		goto out2;
 	err = register_module_notifier(&module_load_nb);
 	if (err)
-		goto out4;
+		goto out3;
 
 	start_cpu_work();
-
-out:
-	return err;
-out4:
-	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
+	return 0;
 out3:
-	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
+	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
 out2:
-	task_handoff_unregister(&task_free_nb);
-	free_all_tasks();
+	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 out1:
+	task_handoff_enabled = false;
+	barrier();
+	free_all_tasks();
 	free_cpumask_var(marked_cpus);
-	goto out;
+	return err;
 }
 
 
@@ -209,7 +187,7 @@ void sync_stop(void)
 	unregister_module_notifier(&module_load_nb);
 	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
-	task_handoff_unregister(&task_free_nb);
+	task_handoff_enabled = false;
 	barrier();			/* do all of the above first */
 
 	flush_cpu_work();
