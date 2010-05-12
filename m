Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0ELDXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:23:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42714 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab0ELDWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:22:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=wDdtpYcVC0ptlodJ8GkLAFdts+emnHbwJe0/5mqszI9uRjq9CPBiv4eT9b2sBsEfJ
	T1ZY271Ullssi5bHhGayw==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 09/12] generic rwsem: implement down_read_unfair
Date: Tue, 11 May 2010 20:20:59 -0700
Message-Id: <1273634462-2672-10-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273634462-2672-1-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add down_read_unfair() API.

This is similar to down_read() with the following changes:
- when the rwsem is read owned with queued writers, down_read_unfair() callers
  are allowed to acquire the rwsem for read without queueing;
- when the rwsem is write owned, down_read_unfair() callers get queued in
  front of threads trying to acquire the rwsem by other means.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 include/linux/rwsem-spinlock.h |   10 +++++++++-
 include/linux/rwsem.h          |   10 ++++++++++
 kernel/rwsem.c                 |   17 +++++++++++++++++
 lib/rwsem-spinlock.c           |   10 +++++++---
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index bdfcc25..dc849d9 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -60,7 +60,15 @@ do {								\
 	__init_rwsem((sem), #sem, &__key);			\
 } while (0)
 
-extern void __down_read(struct rw_semaphore *sem);
+#define __HAVE_DOWN_READ_UNFAIR
+
+static inline void __down_read(struct rw_semaphore *sem)
+	{ __down_read_internal(sem, 0); }
+
+static inline void __sched __down_read_unfair(struct rw_semaphore *sem)
+	{ __down_read_internal(sem, 1);	}
+
+extern void __down_read_internal(struct rw_semaphore *sem, int unfair);
 extern int __down_read_trylock(struct rw_semaphore *sem);
 extern void __down_write(struct rw_semaphore *sem);
 extern void __down_write_nested(struct rw_semaphore *sem, int subclass);
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index efd348f..365e47b 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -28,6 +28,16 @@ struct rw_semaphore;
 extern void down_read(struct rw_semaphore *sem);
 
 /*
+ * lock for reading - skip waiting writers
+ */
+#ifdef __HAVE_DOWN_READ_UNFAIR
+extern void down_read_unfair(struct rw_semaphore *sem);
+#else
+static inline void down_read_unfair(struct rw_semaphore *sem)
+	{ down_read(sem); }
+#endif
+
+/*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
 extern int down_read_trylock(struct rw_semaphore *sem);
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index cae050b..0cef726 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -26,6 +26,23 @@ void __sched down_read(struct rw_semaphore *sem)
 
 EXPORT_SYMBOL(down_read);
 
+#ifdef __HAVE_DOWN_READ_UNFAIR
+
+/*
+ * lock for reading - skip waiting writers
+ */
+void __sched down_read_unfair(struct rw_semaphore *sem)
+{
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read_unfair);
+}
+
+EXPORT_SYMBOL(down_read_unfair);
+
+#endif
+
 /*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */
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

