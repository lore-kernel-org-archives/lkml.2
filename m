Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1C0KpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 06:45:20 -0400
Received: from relay.parallels.com ([195.214.232.42]:44575 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab1C0KpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 06:45:18 -0400
Subject: [PATCH] async: fix compiler warning in initcall_debug code
To: <linux-kernel@vger.kernel.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Date: Sun, 27 Mar 2011 14:45:08 +0400
Message-ID: <20110327104508.28272.97614.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compiler warning about uninitialized ktime_t variable:

CC      kernel/async.o
kernel/async.c: In function ‘async_synchronize_cookie_domain’:
kernel/async.c:270:10: warning: ‘starttime.tv64’ may be used uninitialized in this function
kernel/async.c: In function ‘async_run_entry_fn’:
kernel/async.c:122:10: warning: ‘calltime.tv64’ may be used uninitialized in this function

It always initialized before usage bacause initcall_debug cannot be turned off.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 kernel/async.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index cd9dbb9..3d8220a 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -119,7 +119,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	struct async_entry *entry =
 		container_of(work, struct async_entry, work);
 	unsigned long flags;
-	ktime_t calltime, delta, rettime;
+	ktime_t uninitialized_var(time);
 
 	/* 1) move self to the running queue */
 	spin_lock_irqsave(&async_lock, flags);
@@ -130,16 +130,17 @@ static void async_run_entry_fn(struct work_struct *work)
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk("calling  %lli_%pF @ %i\n", (long long)entry->cookie,
 			entry->func, task_pid_nr(current));
-		calltime = ktime_get();
+		time = ktime_get();
 	}
+
 	entry->func(entry->data, entry->cookie);
+
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
+		time = ktime_sub(ktime_get(), time);
 		printk("initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
-			(long long)ktime_to_ns(delta) >> 10);
+			(long long)ktime_to_ns(time) >> 10);
 	}
 
 	/* 3) remove self from the running queue */
@@ -267,22 +268,20 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 void async_synchronize_cookie_domain(async_cookie_t cookie,
 				     struct list_head *running)
 {
-	ktime_t starttime, delta, endtime;
+	ktime_t uninitialized_var(time);
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		printk("async_waiting @ %i\n", task_pid_nr(current));
-		starttime = ktime_get();
+		time = ktime_get();
 	}
 
 	wait_event(async_done, lowest_in_progress(running) >= cookie);
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		endtime = ktime_get();
-		delta = ktime_sub(endtime, starttime);
-
+		time = ktime_sub(ktime_get(), time);
 		printk("async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
-			(long long)ktime_to_ns(delta) >> 10);
+			(long long)ktime_to_ns(time) >> 10);
 	}
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie_domain);

