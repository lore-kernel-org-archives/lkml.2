Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479Ab0EDWem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:34:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49696 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784Ab0EDWeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:34:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 09/13] tty: implement BTM as mutex instead of BKL
Date: Wed,  5 May 2010 00:33:48 +0200
Message-Id: <1273012433-6125-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+z3/YBAyOqhMTV4uIwyClVMLNSHM2iuwN+xa1
 9rKTt5tlwTuIqbJJP6x7pc4h+xbWWBlvy4qMCPZRDk4HVM7J1N
 1hCoERyr1zfQMlEdp6IRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TTY layer now has its own ways to deal with recursive
locking and release-on-sleep for the tty_lock() calls,
meaning that it's safe to replace the Big Kernel Lock
with a subsystem specific Big TTY Mutex (BTM).

This patch for now makes the new behaviour an optional
experimental feature that can be enabled for testing
purposes.

Using a regular mutex here will change the behaviour
when blocked on the BTM from spinning to sleeping,
but that should be visible to the user.

Using the mutex also means that all the BTM is now
covered by lockdep.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/Makefile     |    1 +
 drivers/char/tty_mutex.c  |  100 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    1 +
 include/linux/tty.h       |   19 +++++++++
 kernel/fork.c             |    1 +
 lib/Kconfig.debug         |   10 +++++
 7 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/tty_mutex.c

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index f957edf..74ee3fa 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -9,6 +9,7 @@ FONTMAPFILE = cp437.uni
 
 obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o tty_port.o
 
+obj-$(CONFIG_TTY_MUTEX)		+= tty_mutex.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-y				+= misc.o
diff --git a/drivers/char/tty_mutex.c b/drivers/char/tty_mutex.c
new file mode 100644
index 0000000..51e0852
--- /dev/null
+++ b/drivers/char/tty_mutex.c
@@ -0,0 +1,100 @@
+/*
+ * drivers/char/tty_lock.c
+ */
+#include <linux/tty.h>
+#include <linux/module.h>
+#include <linux/kallsyms.h>
+#include <linux/semaphore.h>
+#include <linux/sched.h>
+
+/*
+ * The 'big kernel semaphore'
+ *
+ * This mutex is taken and released recursively by tty_lock()
+ * and tty_unlock().  It is transparently dropped and reacquired
+ * over schedule().  It is used to protect legacy code that hasn't
+ * been migrated to a proper locking design yet.
+ *
+ * Note: code locked by this semaphore will only be serialized against
+ * other code using the same locking facility. The code guarantees that
+ * the task remains on the same CPU.
+ *
+ * Don't use in new code.
+ */
+static DEFINE_MUTEX(big_tty_mutex);
+
+/*
+ * Re-acquire the kernel semaphore.
+ *
+ * This function is called with preemption off.
+ *
+ * We are executing in schedule() so the code must be extremely careful
+ * about recursion, both due to the down() and due to the enabling of
+ * preemption. schedule() will re-check the preemption flag after
+ * reacquiring the semaphore.
+ */
+int __lockfunc __reacquire_tty_lock(void)
+{
+	struct task_struct *task = current;
+	int saved_tty_lock_depth = task->tty_lock_depth;
+
+	BUG_ON(saved_tty_lock_depth < 0);
+
+	task->tty_lock_depth = -1;
+	preempt_enable_no_resched();
+
+	mutex_lock(&big_tty_mutex);
+
+	preempt_disable();
+	task->tty_lock_depth = saved_tty_lock_depth;
+
+	return 0;
+}
+EXPORT_SYMBOL(__reacquire_tty_lock);
+
+void __lockfunc __release_tty_lock(void)
+{
+	mutex_unlock(&big_tty_mutex);
+}
+EXPORT_SYMBOL(__release_tty_lock);
+
+/*
+ * Getting the big tty mutex.
+ */
+void __lockfunc tty_lock(void)
+{
+	struct task_struct *task = current;
+	int depth = task->tty_lock_depth + 1;
+
+	if (!WARN_ON(depth))
+		mutex_lock(&big_tty_mutex);
+
+	task->tty_lock_depth = depth;
+}
+EXPORT_SYMBOL(tty_lock);
+
+void __lockfunc tty_lock_nested(void)
+{
+	struct task_struct *task = current;
+	int depth = task->tty_lock_depth + 1;
+
+	if (likely(!depth))
+		/*
+		 * No recursion worries - we set up tty_lock_depth _after_
+		 */
+		mutex_lock(&big_tty_mutex);
+
+	task->tty_lock_depth = depth;
+}
+EXPORT_SYMBOL(tty_lock_nested);
+
+void __lockfunc tty_unlock(void)
+{
+	struct task_struct *task = current;
+
+	BUG_ON(task->tty_lock_depth < 0);
+
+	if (likely(--task->tty_lock_depth < 0))
+		mutex_unlock(&big_tty_mutex);
+}
+EXPORT_SYMBOL(tty_unlock);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index b1ed1cd..3c0b4ab 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -114,6 +114,7 @@ extern struct cred init_cred;
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= PF_KTHREAD,					\
 	.lock_depth	= -1,						\
+	.tty_lock_depth	= -1,						\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..5f03259 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1175,6 +1175,7 @@ struct task_struct {
 	unsigned int ptrace;
 
 	int lock_depth;		/* BKL lock depth */
+	int tty_lock_depth;	/* TTY lock depth */
 
 #ifdef CONFIG_SMP
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 60b3d69..1659ba8 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -572,6 +572,7 @@ extern int vt_ioctl(struct tty_struct *tty, struct file *file,
 extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 		     unsigned int cmd, unsigned long arg);
 
+/* tty_mutex.c */
 /* functions for preparation of BKL removal */
 
 /*
@@ -584,6 +585,22 @@ extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
  * be shown to never get called with this held already, it should
  * use tty_lock() instead.
  */ 
+#ifdef CONFIG_TTY_MUTEX
+extern void __lockfunc tty_lock_nested(void) __acquires(tty_lock);
+extern void __lockfunc tty_lock(void) __acquires(tty_lock);
+extern void __lockfunc tty_unlock(void) __releases(tty_lock);
+#define tty_locked()		(current->tty_lock_depth >= 0)
+int __lockfunc __reacquire_tty_lock(void);
+void __lockfunc __release_tty_lock(void);
+#define release_tty_lock(tsk) do {           \
+        if (unlikely((tsk)->tty_lock_depth >= 0))   \
+                __release_tty_lock();        \
+} while (0)
+#define reacquire_tty_lock(tsk) \
+        ((tsk->tty_lock_depth >= 0) ? \
+                __reacquire_tty_lock() : 0 )
+
+#else
 static inline void __lockfunc tty_lock_nested(void) __acquires(kernel_lock)
 {
 	lock_kernel();
@@ -609,6 +626,8 @@ static inline void __release_tty_lock(void)
 #define release_tty_lock(tsk) do { } while (0)
 #define reacquire_tty_lock(tsk) do { } while (0)
 
+#endif
+
 /*
  * mutex_lock_tty - lock a mutex without holding the BTM
  *
diff --git a/kernel/fork.c b/kernel/fork.c
index 44b0791..cf81613 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1064,6 +1064,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	posix_cpu_timers_init(p);
 
 	p->lock_depth = -1;		/* -1 = no lock */
+	p->tty_lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 935248b..0b3e1ad 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -428,6 +428,16 @@ config RT_MUTEX_TESTER
 	help
 	  This option enables a rt-mutex tester.
 
+config TTY_MUTEX
+	bool "Use a mutex instead of BKL for TTY locking"
+	depends on EXPERIMENTAL && SMP
+	help
+	  The TTY subsystem traditionally depends on the big kernel lock
+	  for serialization. Saying Y here replaces the BKL with the Big
+	  TTY Mutex (BTM).
+	  Building a kernel without the BKL is only possible with TTY_MUTEX
+	  enabled.
+
 config DEBUG_SPINLOCK
 	bool "Spinlock and rw-lock debugging: basic checks"
 	depends on DEBUG_KERNEL
-- 
1.7.0.4

