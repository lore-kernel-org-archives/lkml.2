Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab0GBJZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:25:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34462 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab0GBJZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r6HCA4HyBJl5Y44pGw5EiulT1E1bkNsLSKhOjx3KQF0FKAZAKyV2nZCH7l1izr9lO9
         xwQEm++SIxuyMsnqNYSIz6DmufkKk1iWEDcGg+LP4ZrnuzG8Z/+1PinEgy5XW5UGh2t8
         wGzUPyRyVWemRER75BsI8H5VauEqfePd6Kpec=
Message-ID: <4C2DB084.5040205@gmail.com>
Date: Fri, 02 Jul 2010 11:25:24 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 4/4] async: use workqueue for worker pool
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> <4C2DAEBB.7090607@kernel.org>
In-Reply-To: <4C2DAEBB.7090607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
index 15319d6..52acfc0 100644
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
+	queue_work(system_unbound_wq, &entry->work);
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

