Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1H1Mvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 08:51:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53753 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1H1Mvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 08:51:35 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] spinlock_debug: print owner on spinlock lockup
Date: Sun, 28 Aug 2011 21:53:35 +0900
Message-Id: <1314536015-10981-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SPIN_BUG_ON is triggered, the lock owner information is reported.
But it is omitted when spinlock lockup is detected.

This information is useful especially on the architectures which don't
implement trigger_all_cpu_backtrace() that is called just after detecting
lockup.  So report it and also avoid message format duplication.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 lib/spinlock_debug.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 4755b98..5f3eacd 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -49,13 +49,10 @@ void __rwlock_init(rwlock_t *lock, const char *name,
 
 EXPORT_SYMBOL(__rwlock_init);
 
-static void spin_bug(raw_spinlock_t *lock, const char *msg)
+static void spin_dump(raw_spinlock_t *lock, const char *msg)
 {
 	struct task_struct *owner = NULL;
 
-	if (!debug_locks_off())
-		return;
-
 	if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT)
 		owner = lock->owner;
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
@@ -70,6 +67,14 @@ static void spin_bug(raw_spinlock_t *lock, const char *msg)
 	dump_stack();
 }
 
+static void spin_bug(raw_spinlock_t *lock, const char *msg)
+{
+	if (!debug_locks_off())
+		return;
+
+	spin_dump(lock, msg);
+}
+
 #define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond)) spin_bug(lock, msg)
 
 static inline void
@@ -113,11 +118,7 @@ static void __spin_lock_debug(raw_spinlock_t *lock)
 		/* lockup suspected: */
 		if (print_once) {
 			print_once = 0;
-			printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
-					"%s/%d, %p\n",
-				raw_smp_processor_id(), current->comm,
-				task_pid_nr(current), lock);
-			dump_stack();
+			spin_dump(lock, "lockup");
 #ifdef CONFIG_SMP
 			trigger_all_cpu_backtrace();
 #endif
-- 
1.7.4.4

