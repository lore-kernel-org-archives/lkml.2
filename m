Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935124Ab0HFTlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:41:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61750 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935053Ab0HFTlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:41:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH retry] tty: implement BTM as mutex instead of BKL
Date: Fri, 6 Aug 2010 21:40:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100805213528.GA13794@kroah.com> <1281047014-23429-43-git-send-email-gregkh@suse.de>
In-Reply-To: <1281047014-23429-43-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008062140.30555.arnd@arndb.de>
X-Provags-ID: V02:K0:iT/Y7TID9YXwNBuEhhN7Qv2XYW+PA1yraPfSPte2reu
 mg9KhDcV0gIp+HQSkQjpUu4+Zw3lefigpm7YutemGa55Jc+3vl
 yauIsmmISVRf4wi78wqYsRVwDmJnr7CtGJvpGwwHiDV8urKKI5
 dv0HJlzPopW/t7dIlPcIJwDES06qfeODobDSQihyFyjxDFd/Ds
 Mqirl7kljDs+XuOMK5eRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty locking now follows the rules for mutexes, so
we can replace the BKL usage with a new subsystem
wide mutex.

Using a regular mutex here will change the behaviour
when blocked on the BTM from spinning to sleeping,
but that should not be visible to the user.

Using the mutex also means that all the BTM is now
covered by lockdep.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 88d6eac..82d05cc 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -9,6 +9,7 @@ FONTMAPFILE = cp437.uni
 
 obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o tty_port.o
 
+obj-y				+= tty_mutex.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-y				+= misc.o
diff --git a/drivers/char/tty_mutex.c b/drivers/char/tty_mutex.c
new file mode 100644
index 0000000..1336975
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
+ * The 'big tty mutex'
+ *
+ * This mutex is taken and released by tty_lock() and tty_unlock(),
+ * replacing the older big kernel lock.
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
index 98c90df..95526cb 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -575,20 +575,12 @@ extern int vt_ioctl(struct tty_struct *tty, struct file *file,
 extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 		     unsigned int cmd, unsigned long arg);
 
+/* tty_mutex.c */
 /* functions for preparation of BKL removal */
-static inline void tty_lock(void) __acquires(kernel_lock)
-{
-#ifdef CONFIG_LOCK_KERNEL
-	/* kernel_locked is 1 for !CONFIG_LOCK_KERNEL */
-	WARN_ON(kernel_locked());
-#endif
-	lock_kernel();
-}
-static inline void tty_unlock(void) __releases(kernel_lock)
-{
-	unlock_kernel();
-}
-#define tty_locked()		(kernel_locked())
+extern void __lockfunc tty_lock(void) __acquires(tty_lock);
+extern void __lockfunc tty_unlock(void) __releases(tty_lock);
+extern struct task_struct *__big_tty_mutex_owner;
+#define tty_locked()		(current == __big_tty_mutex_owner)
 
 /*
  * wait_event_interruptible_tty -- wait for a condition with the tty lock held
