Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1I2QS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:18:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1I2QSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:18:55 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=PiVJXPJdrVoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=uxao9uKeMqtKkIm3pf4A:9 a=iO4tlg1U4uBxf7Wso6YA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: [PATCH][RT][RFC] rt: show owner of locks for blocked tasks in task
 dumps
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <clark@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 29 Sep 2011 12:18:53 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317313134.4588.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found this quite helpful in my debugging lately. When doing task
dumps, show the owner of a lock that a task may be blocked on. This is
especially helpful when lockdep is not enabled and we do not know what
task holds what lock. We still have the information of what owner holds
a lock that a task is blocked on.

Due to the sensitive nature of task dumps happening almost anywhere.
Tricks to the raw spinlocks are done to keep the dump from deadlocking.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-mrg.git/kernel/rtmutex.c
===================================================================
--- linux-mrg.git.orig/kernel/rtmutex.c
+++ linux-mrg.git/kernel/rtmutex.c
@@ -1431,3 +1431,51 @@ int rt_mutex_finish_proxy_lock(struct rt
 
 	return ret;
 }
+
+void show_rt_lock_owner(struct task_struct *p)
+{
+	struct rt_mutex_waiter *waiter;
+	struct rt_mutex *lock;
+	struct task_struct *task;
+	unsigned long flags;
+	int locked = 0;
+
+	/*
+	 * This is called by stack dumps, we can't safely take a
+	 * lock. If we fail to get the lock then simply state so
+	 * and bail.
+	 */
+	if (!raw_spin_trylock_irqsave(&p->pi_lock, flags)) {
+		printk (" task pi_lock already held\n");
+		return;
+	}
+	waiter = p->pi_blocked_on;
+	if (!rt_mutex_real_waiter(waiter))
+		goto out;
+
+	/* Keep tasks from disappearing */
+	rcu_read_lock();
+
+	lock = waiter->lock;
+	/*
+	 * Used by task stack traces, try to synchronize but
+	 * don't block (we have the waiter pi_lock). If we fail to
+	 * take the lock, the worse that can happen is the owner changes
+	 * on us.
+	 */
+	if (raw_spin_trylock(&lock->wait_lock))
+		locked = 1;
+
+	task = rt_mutex_owner(lock);
+	if (task)
+		printk(KERN_CONT "  blocked on lock %p owned by %s:%d\n",
+		       lock, task->comm, task->pid);
+	else
+		printk(KERN_CONT "  blocked on lock %p with no owner\n", lock);
+
+	if (locked)
+		raw_spin_unlock(&lock->wait_lock);
+	rcu_read_unlock();
+ out:
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+}
Index: linux-mrg.git/kernel/sched.c
===================================================================
--- linux-mrg.git.orig/kernel/sched.c
+++ linux-mrg.git/kernel/sched.c
@@ -6060,6 +6060,8 @@ void sched_show_task(struct task_struct 
 		(unsigned long)task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
+
+	show_rt_lock_owner(p);
 }
 
 void show_state_filter(unsigned long state_filter)
Index: linux-mrg.git/include/linux/spinlock.h
===================================================================
--- linux-mrg.git.orig/include/linux/spinlock.h
+++ linux-mrg.git/include/linux/spinlock.h
@@ -273,6 +273,8 @@ static inline void do_raw_spin_unlock(ra
 # include <linux/spinlock_rt.h>
 #else /* PREEMPT_RT_FULL */
 
+static inline void show_rt_lock_owner(struct task_struct *p) { }
+
 /*
  * Map the spin_lock functions to the raw variants for PREEMPT_RT=n
  */
Index: linux-mrg.git/include/linux/spinlock_rt.h
===================================================================
--- linux-mrg.git.orig/include/linux/spinlock_rt.h
+++ linux-mrg.git/include/linux/spinlock_rt.h
@@ -26,6 +26,8 @@ extern int __lockfunc rt_spin_trylock_bh
 extern int __lockfunc rt_spin_trylock(spinlock_t *lock);
 extern int atomic_dec_and_spin_lock(atomic_t *atomic, spinlock_t *lock);
 
+extern void show_rt_lock_owner(struct task_struct *p);
+
 /*
  * lockdep-less calls, for derived types like rwlock:
  * (for trylock they can use rt_mutex_trylock() directly.


