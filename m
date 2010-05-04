Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513Ab0EDWfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:35:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60423 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934474Ab0EDWfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:35:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 12/13] tty: remove release_tty_lock/reacquire_tty_lock
Date: Wed,  5 May 2010 00:33:51 +0200
Message-Id: <1273012433-6125-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/p7p+oAKZwPJcXDRKEnklY0j4m8tBwZueC6JR
 Xq3narjW33+Ud1SqhSeeaKiz3lVsgyu1Pq1HQSqnWGWoKvwDTu
 2M2mvu6ibGKoNIilttbuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users are nonrecursive now, and we don't call release_tty_lock()
in places where it's not held to start with, so it is safe to
replace it with tty_lock().

Same for reacquire_tty_lock()/tty_unlock().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/tty_ldisc.c |    8 +++---
 drivers/char/tty_mutex.c |   35 ------------------------
 include/linux/tty.h      |   65 ++++++++++++---------------------------------
 kernel/printk.c          |    9 ++++--
 4 files changed, 28 insertions(+), 89 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index c71a94a..0c0e935 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -537,9 +537,9 @@ static int tty_ldisc_halt(struct tty_struct *tty)
 	int ret;
 	clear_bit(TTY_LDISC, &tty->flags);
 	if (tty_locked()) {
-		__release_tty_lock();
+		tty_unlock();
 		ret = cancel_delayed_work_sync(&tty->buf.work);
-		__reacquire_tty_lock();
+		tty_lock();
 	} else {
 		ret = cancel_delayed_work_sync(&tty->buf.work);
 	
@@ -870,9 +870,9 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 */
 
 	tty_ldisc_halt(tty);
-	release_tty_lock(current);
+	tty_unlock();
 	flush_scheduled_work();
-	reacquire_tty_lock(current);
+	tty_lock();
 	mutex_lock_tty_on(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
diff --git a/drivers/char/tty_mutex.c b/drivers/char/tty_mutex.c
index 6bd47e1..5fd3332 100644
--- a/drivers/char/tty_mutex.c
+++ b/drivers/char/tty_mutex.c
@@ -24,41 +24,6 @@
 static DEFINE_MUTEX(big_tty_mutex);
 
 /*
- * Re-acquire the kernel semaphore.
- *
- * This function is called with preemption off.
- *
- * We are executing in schedule() so the code must be extremely careful
- * about recursion, both due to the down() and due to the enabling of
- * preemption. schedule() will re-check the preemption flag after
- * reacquiring the semaphore.
- */
-int __lockfunc __reacquire_tty_lock(void)
-{
-	struct task_struct *task = current;
-	int saved_tty_lock_depth = task->tty_lock_depth;
-
-	BUG_ON(saved_tty_lock_depth < 0);
-
-	task->tty_lock_depth = -1;
-	preempt_enable_no_resched();
-
-	mutex_lock(&big_tty_mutex);
-
-	preempt_disable();
-	task->tty_lock_depth = saved_tty_lock_depth;
-
-	return 0;
-}
-EXPORT_SYMBOL(__reacquire_tty_lock);
-
-void __lockfunc __release_tty_lock(void)
-{
-	mutex_unlock(&big_tty_mutex);
-}
-EXPORT_SYMBOL(__release_tty_lock);
-
-/*
  * Getting the big tty mutex.
  */
 void __lockfunc tty_lock(void)
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 3cf4556..9b76f8b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -580,16 +580,6 @@ extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 extern void __lockfunc tty_lock(void) __acquires(tty_lock);
 extern void __lockfunc tty_unlock(void) __releases(tty_lock);
 #define tty_locked()		(current->tty_lock_depth >= 0)
-int __lockfunc __reacquire_tty_lock(void);
-void __lockfunc __release_tty_lock(void);
-#define release_tty_lock(tsk) do {           \
-        if (unlikely((tsk)->tty_lock_depth >= 0))   \
-                __release_tty_lock();        \
-} while (0)
-#define reacquire_tty_lock(tsk) \
-        ((tsk->tty_lock_depth >= 0) ? \
-                __reacquire_tty_lock() : 0 )
-
 #else
 static inline void tty_lock(void) __acquires(kernel_lock)
 {
@@ -601,17 +591,6 @@ static inline void tty_unlock(void) __releases(kernel_lock)
 	unlock_kernel();
 }
 #define tty_locked()		(kernel_locked())
-static inline int __reacquire_tty_lock(void)
-{
-	return 0;
-}
-static inline void __release_tty_lock(void)
-{
-}
-
-#define release_tty_lock(tsk) do { } while (0)
-#define reacquire_tty_lock(tsk) do { } while (0)
-
 #endif
 
 /*
@@ -642,9 +621,9 @@ static inline void __release_tty_lock(void)
 ({						\
 	if (!mutex_trylock(mutex)) {		\
 		if (tty_locked()) {		\
-			__release_tty_lock();	\
+			tty_unlock();		\
 			mutex_lock(mutex);	\
-			__reacquire_tty_lock();	\
+			tty_lock();		\
 		} else				\
 			mutex_lock(mutex);	\
 	}					\
@@ -652,26 +631,18 @@ static inline void __release_tty_lock(void)
 
 #define mutex_lock_tty_on(mutex)		\
 ({						\
+	WARN_ON(!tty_locked());			\
 	if (!mutex_trylock(mutex)) {		\
-		if (!WARN_ON(!tty_locked())) {	\
-			__release_tty_lock();	\
-			mutex_lock(mutex);	\
-			__reacquire_tty_lock();	\
-		} else				\
-			mutex_lock(mutex);	\
+		tty_unlock();			\
+		mutex_lock(mutex);		\
+		tty_lock();			\
 	}					\
 })
 
 #define mutex_lock_tty_off(mutex)		\
 ({						\
-	if (!mutex_trylock(mutex)) {		\
-		if (WARN_ON(tty_locked())) {	\
-			__release_tty_lock();	\
-			mutex_lock(mutex);	\
-			__reacquire_tty_lock();	\
-		} else				\
-			mutex_lock(mutex);	\
-	}					\
+	WARN_ON(tty_locked());			\
+	mutex_lock(mutex);			\
 })
 
 #define mutex_lock_interruptible_tty(mutex)	\
@@ -679,9 +650,9 @@ static inline void __release_tty_lock(void)
 	int __ret = 0;				\
 	if (!mutex_trylock(mutex)) {		\
 		if (tty_locked()) {		\
-			__release_tty_lock();	\
+			tty_unlock();		\
 			__ret = mutex_lock_interruptible(mutex); \
-			__reacquire_tty_lock();	\
+			tty_lock();		\
 		} else				\
 			__ret = mutex_lock_interruptible(mutex); \
 	}					\
@@ -707,18 +678,18 @@ static inline void __release_tty_lock(void)
 do {									\
 	if (condition)	 						\
 		break;							\
-	release_tty_lock(current);					\
+	tty_unlock();							\
 	__wait_event(wq, condition);					\
-	reacquire_tty_lock(current);					\
+	tty_lock();							\
 } while (0)
 
 #define wait_event_timeout_tty(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
 	if (!(condition)) {						\
-		release_tty_lock(current);				\
+		tty_unlock();						\
 		__wait_event_timeout(wq, condition, __ret);		\
-		reacquire_tty_lock(current);				\
+		tty_lock();						\
 	}								\
 	__ret;								\
 })
@@ -727,9 +698,9 @@ do {									\
 ({									\
 	int __ret = 0;							\
 	if (!(condition)) {						\
-		release_tty_lock(current);				\
+		tty_unlock();						\
 		__wait_event_interruptible(wq, condition, __ret);	\
-		reacquire_tty_lock(current);				\
+		tty_lock();						\
 	}								\
 	__ret;								\
 })
@@ -738,9 +709,9 @@ do {									\
 ({									\
 	long __ret = timeout;						\
 	if (!(condition)) {						\
-		release_tty_lock(current);				\
+		tty_unlock();						\
 		__wait_event_interruptible_timeout(wq, condition, __ret); \
-		reacquire_tty_lock(current);				\
+		tty_lock();						\
 	}								\
 	__ret;								\
 })
diff --git a/kernel/printk.c b/kernel/printk.c
index 30669a3..b9fb322 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -976,9 +976,12 @@ void acquire_console_sem(void)
 		 * it's not clear whether we get the BTM while
 		 * holding console_sem, need to check.
 		 */
-		release_tty_lock(current);
-		down(&console_sem);
-		reacquire_tty_lock(current);
+		if (tty_locked()) {
+			tty_unlock();
+			down(&console_sem);
+			tty_lock();
+		} else
+			down(&console_sem);
 	}
 	if (console_suspended)
 		return;
-- 
1.7.0.4

