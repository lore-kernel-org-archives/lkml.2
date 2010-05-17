Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0EQW1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:27:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25693 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab0EQW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=RixUET+XC39TE14xfiBp5kHCvmCAkupFGyV2bjM5QpNODNm4NPhSvIUp857NEV8u1
	/n6VvQjLQdo1bUyjjiq6w==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 07/10] generic rwsem: implement down_read_critical() / up_read_critical()
Date: Mon, 17 May 2010 15:25:51 -0700
Message-Id: <1274135154-24082-8-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274135154-24082-1-git-send-email-walken@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add down_read_critical() / up_read_critical() API.

down_read_critical() is similar to down_read() with the following changes:
- when the rwsem is read owned with queued writers, down_read_unfair() callers
  are allowed to acquire the rwsem for read without queueing;
- when the rwsem is write owned, down_read_unfair() callers get queued in
  front of threads trying to acquire the rwsem by other means.
- caller can't sleep until releasing lock with up_read_critical(),
  and preemption is disabled for that time.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 include/linux/rwsem-spinlock.h |   10 +++++++++-
 include/linux/rwsem.h          |   12 ++++++++++++
 kernel/rwsem.c                 |   35 +++++++++++++++++++++++++++++++++++
 lib/rwsem-spinlock.c           |   10 +++++++---
 4 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index bdfcc25..67631c3 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -60,7 +60,9 @@ do {								\
 	__init_rwsem((sem), #sem, &__key);			\
 } while (0)
 
-extern void __down_read(struct rw_semaphore *sem);
+#define __HAVE_DOWN_READ_UNFAIR
+
+extern void __down_read_internal(struct rw_semaphore *sem, int unfair);
 extern int __down_read_trylock(struct rw_semaphore *sem);
 extern void __down_write(struct rw_semaphore *sem);
 extern void __down_write_nested(struct rw_semaphore *sem, int subclass);
@@ -70,5 +72,11 @@ extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
 extern int rwsem_is_locked(struct rw_semaphore *sem);
 
+static inline void __down_read(struct rw_semaphore *sem)
+	{ __down_read_internal(sem, 0); }
+
+static inline void __down_read_unfair(struct rw_semaphore *sem)
+	{ __down_read_internal(sem, 1); }
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index efd348f..76fd8f4 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -28,6 +28,13 @@ struct rw_semaphore;
 extern void down_read(struct rw_semaphore *sem);
 
 /*
+ * lock for reading in critical section
+ *
+ * locker skips waiting threads, but can't block until up_read_critical()
+ */
+extern void down_read_critical(struct rw_semaphore *sem);
+
+/*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
 extern int down_read_trylock(struct rw_semaphore *sem);
@@ -48,6 +55,11 @@ extern int down_write_trylock(struct rw_semaphore *sem);
 extern void up_read(struct rw_semaphore *sem);
 
 /*
+ * release a read lock acquired with down_read_critical()
+ */
+extern void up_read_critical(struct rw_semaphore *sem);
+
+/*
  * release a write lock
  */
 extern void up_write(struct rw_semaphore *sem);
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index cae050b..7c34174 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -13,6 +13,10 @@
 #include <asm/system.h>
 #include <asm/atomic.h>
 
+#ifndef __HAVE_DOWN_READ_UNFAIR
+# define __down_read_unfair(sem) __down_read(sem)
+#endif
+
 /*
  * lock for reading
  */
@@ -27,6 +31,23 @@ void __sched down_read(struct rw_semaphore *sem)
 EXPORT_SYMBOL(down_read);
 
 /*
+ * lock for reading in critical section
+ *
+ * locker skips waiting threads, but can't block until up_read_critical()
+ */
+void __sched down_read_critical(struct rw_semaphore *sem)
+{
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read_unfair);
+
+	preempt_disable();
+}
+
+EXPORT_SYMBOL(down_read_critical);
+
+/*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
 int down_read_trylock(struct rw_semaphore *sem)
@@ -80,6 +101,20 @@ void up_read(struct rw_semaphore *sem)
 EXPORT_SYMBOL(up_read);
 
 /*
+ * release a read lock acquired with down_read_critical()
+ */
+void up_read_critical(struct rw_semaphore *sem)
+{
+	rwsem_release(&sem->dep_map, 1, _RET_IP_);
+
+	__up_read(sem);
+
+	preempt_enable();
+}
+
+EXPORT_SYMBOL(up_read_critical);
+
+/*
  * release a write lock
  */
 void up_write(struct rw_semaphore *sem)
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index ffc9fc7..b2fd5fb 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -139,7 +139,7 @@ __rwsem_wake_one_writer(struct rw_semaphore *sem)
 /*
  * get a read lock on the semaphore
  */
-void __sched __down_read(struct rw_semaphore *sem)
+void __sched __down_read_internal(struct rw_semaphore *sem, int unfair)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
@@ -147,7 +147,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 
 	spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
+	if (sem->activity >= 0 && (unfair || list_empty(&sem->wait_list))) {
 		/* granted */
 		sem->activity++;
 		spin_unlock_irqrestore(&sem->wait_lock, flags);
@@ -162,7 +162,11 @@ void __sched __down_read(struct rw_semaphore *sem)
 	waiter.flags = RWSEM_WAITING_FOR_READ;
 	get_task_struct(tsk);
 
-	list_add_tail(&waiter.list, &sem->wait_list);
+	if (unfair) {
+		list_add(&waiter.list, &sem->wait_list);
+	} else {
+		list_add_tail(&waiter.list, &sem->wait_list);
+	}
 
 	/* we don't need to touch the semaphore struct anymore */
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
-- 
1.7.0.1

