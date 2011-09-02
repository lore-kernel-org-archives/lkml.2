Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1IBMlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:41:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55082 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1IBMlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:41:40 -0400
Subject: [RFC][PATCH -rt] spinlock: frob debug bits
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 02 Sep 2011 14:41:33 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314967293.1301.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure this is actually worth it, but since I wrote it I thought I
might as well send it out. Didn't actually need it. Once I frobbed the
printk stuff to work again there were plenty error to point out what
gone wrong.

---
Subject: spinlock: frob debug bits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Sep 02 14:29:30 CEST 2011

gets more debug on a spinlock lockup, but also destroys all lock
debugging.. you win some, you loose some..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-3h4nzmhbik02u9xp9logjrv4@git.kernel.org
---
 lib/spinlock_debug.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

Index: linux-2.6/lib/spinlock_debug.c
===================================================================
--- linux-2.6.orig/lib/spinlock_debug.c
+++ linux-2.6/lib/spinlock_debug.c
@@ -54,7 +54,7 @@ static void spin_bug(raw_spinlock_t *loc
 {
 	struct task_struct *owner = NULL;
 
-	if (!debug_locks_off())
+	if (unlikely(!debug_locks))
 		return;
 
 	if (lock->owner && lock->owner != SPINLOCK_OWNER_INIT)
@@ -69,6 +69,11 @@ static void spin_bug(raw_spinlock_t *loc
 		owner ? task_pid_nr(owner) : -1,
 		lock->owner_cpu);
 	dump_stack();
+	debug_show_all_locks();
+#ifdef CONFIG_SMP
+	trigger_all_cpu_backtrace();
+#endif
+	debug_locks_off();
 }
 
 #define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond)) spin_bug(lock, msg)
@@ -112,17 +117,7 @@ static void __spin_lock_debug(raw_spinlo
 			__delay(1);
 		}
 		/* lockup suspected: */
-		if (print_once) {
-			print_once = 0;
-			printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
-					"%s/%d, %p\n",
-				raw_smp_processor_id(), current->comm,
-				task_pid_nr(current), lock);
-			dump_stack();
-#ifdef CONFIG_SMP
-			trigger_all_cpu_backtrace();
-#endif
-		}
+		SPIN_BUG_ON(1, lock, "timeout");
 	}
 }
 

