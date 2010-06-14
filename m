Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0FNVmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:42:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:46945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab0FNVjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:39:23 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 30/30] async: use workqueue for worker pool
Date: Mon, 14 Jun 2010 23:37:47 +0200
Message-Id: <1276551467-21246-31-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:37:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace private worker pool with system_long_wq.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
---
 kernel/async.c |  140 ++++++++-----------------------------------------------
 1 files changed, 21 insertions(+), 119 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 15319d6..c285258 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -49,40 +49,32 @@ asynchronous and synchronous parts of the kernel.
 */
 
 #include <linux/async.h>
-#include <linux/bug.h>
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/kthread.h>
-#include <linux/delay.h>
 #include <linux/slab.h>
 #include <asm/atomic.h>
 
 static async_cookie_t next_cookie = 1;
 
-#define MAX_THREADS	256
 #define MAX_WORK	32768
 
 static LIST_HEAD(async_pending);
 static LIST_HEAD(async_running);
 static DEFINE_SPINLOCK(async_lock);
 
-static int async_enabled = 0;
-
 struct async_entry {
-	struct list_head list;
-	async_cookie_t   cookie;
-	async_func_ptr	 *func;
-	void             *data;
-	struct list_head *running;
+	struct list_head	list;
+	struct work_struct	work;
+	async_cookie_t		cookie;
+	async_func_ptr		*func;
+	void			*data;
+	struct list_head	*running;
 };
 
 static DECLARE_WAIT_QUEUE_HEAD(async_done);
-static DECLARE_WAIT_QUEUE_HEAD(async_new);
 
 static atomic_t entry_count;
-static atomic_t thread_count;
 
 extern int initcall_debug;
 
@@ -117,27 +109,23 @@ static async_cookie_t  lowest_in_progress(struct list_head *running)
 	spin_unlock_irqrestore(&async_lock, flags);
 	return ret;
 }
+
 /*
  * pick the first pending entry and run it
  */
-static void run_one_entry(void)
+static void async_run_entry_fn(struct work_struct *work)
 {
+	struct async_entry *entry =
+		container_of(work, struct async_entry, work);
 	unsigned long flags;
-	struct async_entry *entry;
 	ktime_t calltime, delta, rettime;
 
-	/* 1) pick one task from the pending queue */
-
+	/* 1) move self to the running queue */
 	spin_lock_irqsave(&async_lock, flags);
-	if (list_empty(&async_pending))
-		goto out;
-	entry = list_first_entry(&async_pending, struct async_entry, list);
-
-	/* 2) move it to the running queue */
 	list_move_tail(&entry->list, entry->running);
 	spin_unlock_irqrestore(&async_lock, flags);
 
-	/* 3) run it (and print duration)*/
+	/* 2) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
 			entry->func, task_pid_nr(current));
@@ -153,31 +141,25 @@ static void run_one_entry(void)
 			(long long)ktime_to_ns(delta) >> 10);
 	}
 
-	/* 4) remove it from the running queue */
+	/* 3) remove self from the running queue */
 	spin_lock_irqsave(&async_lock, flags);
 	list_del(&entry->list);
 
-	/* 5) free the entry  */
+	/* 4) free the entry */
 	kfree(entry);
 	atomic_dec(&entry_count);
 
 	spin_unlock_irqrestore(&async_lock, flags);
 
-	/* 6) wake up any waiters. */
+	/* 5) wake up any waiters */
 	wake_up(&async_done);
-	return;
-
-out:
-	spin_unlock_irqrestore(&async_lock, flags);
 }
 
-
 static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
 {
 	struct async_entry *entry;
 	unsigned long flags;
 	async_cookie_t newcookie;
-	
 
 	/* allow irq-off callers */
 	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
@@ -186,7 +168,7 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
 	 * If we're out of memory or if there's too much work
 	 * pending already, we execute synchronously.
 	 */
-	if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
+	if (!entry || atomic_read(&entry_count) > MAX_WORK) {
 		kfree(entry);
 		spin_lock_irqsave(&async_lock, flags);
 		newcookie = next_cookie++;
@@ -196,6 +178,7 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
 		ptr(data, newcookie);
 		return newcookie;
 	}
+	INIT_WORK(&entry->work, async_run_entry_fn);
 	entry->func = ptr;
 	entry->data = data;
 	entry->running = running;
@@ -205,7 +188,10 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
 	list_add_tail(&entry->list, &async_pending);
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
-	wake_up(&async_new);
+
+	/* schedule for execution */
+	queue_work(system_long_wq, &entry->work);
+
 	return newcookie;
 }
 
@@ -312,87 +298,3 @@ void async_synchronize_cookie(async_cookie_t cookie)
 	async_synchronize_cookie_domain(cookie, &async_running);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie);
-
-
-static int async_thread(void *unused)
-{
-	DECLARE_WAITQUEUE(wq, current);
-	add_wait_queue(&async_new, &wq);
-
-	while (!kthread_should_stop()) {
-		int ret = HZ;
-		set_current_state(TASK_INTERRUPTIBLE);
-		/*
-		 * check the list head without lock.. false positives
-		 * are dealt with inside run_one_entry() while holding
-		 * the lock.
-		 */
-		rmb();
-		if (!list_empty(&async_pending))
-			run_one_entry();
-		else
-			ret = schedule_timeout(HZ);
-
-		if (ret == 0) {
-			/*
-			 * we timed out, this means we as thread are redundant.
-			 * we sign off and die, but we to avoid any races there
-			 * is a last-straw check to see if work snuck in.
-			 */
-			atomic_dec(&thread_count);
-			wmb(); /* manager must see our departure first */
-			if (list_empty(&async_pending))
-				break;
-			/*
-			 * woops work came in between us timing out and us
-			 * signing off; we need to stay alive and keep working.
-			 */
-			atomic_inc(&thread_count);
-		}
-	}
-	remove_wait_queue(&async_new, &wq);
-
-	return 0;
-}
-
-static int async_manager_thread(void *unused)
-{
-	DECLARE_WAITQUEUE(wq, current);
-	add_wait_queue(&async_new, &wq);
-
-	while (!kthread_should_stop()) {
-		int tc, ec;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		tc = atomic_read(&thread_count);
-		rmb();
-		ec = atomic_read(&entry_count);
-
-		while (tc < ec && tc < MAX_THREADS) {
-			if (IS_ERR(kthread_run(async_thread, NULL, "async/%i",
-					       tc))) {
-				msleep(100);
-				continue;
-			}
-			atomic_inc(&thread_count);
-			tc++;
-		}
-
-		schedule();
-	}
-	remove_wait_queue(&async_new, &wq);
-
-	return 0;
-}
-
-static int __init async_init(void)
-{
-	async_enabled =
-		!IS_ERR(kthread_run(async_manager_thread, NULL, "async/mgr"));
-
-	WARN_ON(!async_enabled);
-	return 0;
-}
-
-core_initcall(async_init);
-- 
1.6.4.2

