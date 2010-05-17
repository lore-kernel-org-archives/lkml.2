Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0EQXVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:21:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab0EQXVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:21:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=NHgtHWJOd2O6i1DXwFlhfDvmTkRtgRjmRaMSxbT9bln9Dikjnn5xnR56C4saQA2sb
	vNOK3+cHLuh2w8bLur7ng==
Date: Mon, 17 May 2010 16:20:52 -0700
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 07/10] generic rwsem: implement down_read_critical() /
	up_read_critical()
Message-ID: <20100517232052.GB30847@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com> <1274135154-24082-8-git-send-email-walken@google.com> <alpine.LFD.2.00.1005171532430.4195@i5.linux-foundation.org> <20100517231331.GA30847@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517231331.GA30847@google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add down_read_critical() / up_read_critical() API.

down_read_critical() is similar to down_read() with the following changes:
- when the rwsem is read owned with queued writers, down_read_critical()
  callers are allowed to acquire the rwsem for read without queueing;
- when the rwsem is write owned, down_read_critical() callers get queued in
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
