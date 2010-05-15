Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0EOVA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:00:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60866 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab0EOVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:00:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 10/10] tty: implement BTM as mutex instead of BKL
Date: Sat, 15 May 2010 22:59:56 +0200
Message-Id: <1273957196-13768-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273957196-13768-1-git-send-email-arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1967MQM7nj0YdPwCKrD1o3INPAYkpL4IX7vwQl
 4YOWNa+sO1VIK0hr2aK0XT/Ov6kC9EANt2nHvI0jXzrlzwnChD
 KGtBLvBZvn105A2WG91yQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty locking now follows the rules for mutexes, so
we can replace the BKL usage with a new subsystem
wide mutex.

This patch for now makes the new behaviour an optional
experimental feature that can be enabled for testing
purposes.

Using a regular mutex here will change the behaviour
when blocked on the BTM from spinning to sleeping,
but that should not be visible to the user.

Using the mutex also means that all the BTM is now
covered by lockdep.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/Makefile    |    1 +
 drivers/char/tty_mutex.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/tty.h      |    8 +++++++
 lib/Kconfig.debug        |   10 +++++++++
 4 files changed, 66 insertions(+), 0 deletions(-)
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
index 0000000..f66dfdf
--- /dev/null
+++ b/drivers/char/tty_mutex.c
@@ -0,0 +1,47 @@
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
+ * The 'big tty semaphore'
+ *
+ * This mutex is taken and released by tty_lock() and tty_unlock(),
+ * replacing the older big kernel mutex.
+ * It can no longer be taken recursively, and does not get
+ * released implicitly while sleeping.
+ *
+ * Don't use in new code.
+ */
+static DEFINE_MUTEX(big_tty_mutex);
+struct task_struct *__big_tty_mutex_owner;
+EXPORT_SYMBOL_GPL(__big_tty_mutex_owner);
+
+/*
+ * Getting the big tty mutex.
+ */
+void __lockfunc tty_lock(void)
+{
+	struct task_struct *task = current;
+
+	WARN_ON(__big_tty_mutex_owner == task);
+
+	mutex_lock(&big_tty_mutex);
+	__big_tty_mutex_owner = task;
+}
+EXPORT_SYMBOL(tty_lock);
+
+void __lockfunc tty_unlock(void)
+{
+	struct task_struct *task = current;
+
+	WARN_ON(__big_tty_mutex_owner != task);
+	__big_tty_mutex_owner = NULL;
+
+	mutex_unlock(&big_tty_mutex);
+}
+EXPORT_SYMBOL(tty_unlock);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index b227616..d8d90f6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -573,7 +573,14 @@ extern int vt_ioctl(struct tty_struct *tty, struct file *file,
 extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 		     unsigned int cmd, unsigned long arg);
 
+/* tty_mutex.c */
 /* functions for preparation of BKL removal */
+#ifdef CONFIG_TTY_MUTEX
+extern void __lockfunc tty_lock(void) __acquires(tty_lock);
+extern void __lockfunc tty_unlock(void) __releases(tty_lock);
+extern struct task_struct *__big_tty_mutex_owner;
+#define tty_locked()		(current == __big_tty_mutex_owner)
+#else
 static inline void tty_lock(void) __acquires(kernel_lock)
 {
 	WARN_ON(kernel_locked());
@@ -584,6 +591,7 @@ static inline void tty_unlock(void) __releases(kernel_lock)
 	unlock_kernel();
 }
 #define tty_locked()		(kernel_locked())
+#endif
 
 /*
  * wait_event_interruptible_tty -- wait for a condition with the tty lock held
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

