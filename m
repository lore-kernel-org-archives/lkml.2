Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0ESBkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:40:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:41258 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab0ESBkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, linux-arch@vger.kernel.org,
       Martin Hicks <mort@sgi.com>
Subject: [PATCH 08/25] kdb: core for kgdb back end (2 of 2)
Date: Tue, 18 May 2010 20:39:18 -0500
Message-Id: <1274233175-3675-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:48.0219 (UTC) FILETIME=[2AB134B0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the hooks and instrumentation into kernel which
live outside the kernel/debug directory, which the kdb core
will call to run commands like lsmod, dmesg, bt etc...

CC: linux-arch@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Martin Hicks <mort@sgi.com>
---
 arch/arm/include/asm/kmap_types.h     |    1 +
 arch/powerpc/include/asm/kmap_types.h |    1 +
 include/asm-generic/kmap_types.h      |    3 +-
 init/main.c                           |    2 +
 kernel/kallsyms.c                     |   21 +++++++++++++++++
 kernel/module.c                       |    4 +++
 kernel/printk.c                       |   16 +++++++++++++
 kernel/sched.c                        |    7 ++++-
 kernel/signal.c                       |   40 +++++++++++++++++++++++++++++++++
 9 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kmap_types.h b/arch/arm/include/asm/kmap_types.h
index c4b2ea3..e51b1e8 100644
--- a/arch/arm/include/asm/kmap_types.h
+++ b/arch/arm/include/asm/kmap_types.h
@@ -20,6 +20,7 @@ enum km_type {
 	KM_SOFTIRQ1,
 	KM_L1_CACHE,
 	KM_L2_CACHE,
+	KM_KDB,
 	KM_TYPE_NR
 };
 
diff --git a/arch/powerpc/include/asm/kmap_types.h b/arch/powerpc/include/asm/kmap_types.h
index 9163695..bca8fdc 100644
--- a/arch/powerpc/include/asm/kmap_types.h
+++ b/arch/powerpc/include/asm/kmap_types.h
@@ -26,6 +26,7 @@ enum km_type {
 	KM_SOFTIRQ1,
 	KM_PPC_SYNC_PAGE,
 	KM_PPC_SYNC_ICACHE,
+	KM_KDB,
 	KM_TYPE_NR
 };
 
diff --git a/include/asm-generic/kmap_types.h b/include/asm-generic/kmap_types.h
index e5f234a..97e807c 100644
--- a/include/asm-generic/kmap_types.h
+++ b/include/asm-generic/kmap_types.h
@@ -28,7 +28,8 @@ KMAP_D(15)	KM_UML_USERCOPY,
 KMAP_D(16)	KM_IRQ_PTE,
 KMAP_D(17)	KM_NMI,
 KMAP_D(18)	KM_NMI_PTE,
-KMAP_D(19)	KM_TYPE_NR
+KMAP_D(19)	KM_KDB,
+KMAP_D(20)	KM_TYPE_NR
 };
 
 #undef KMAP_D
diff --git a/init/main.c b/init/main.c
index 5c85402..3727713 100644
--- a/init/main.c
+++ b/init/main.c
@@ -62,6 +62,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/kdb.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/kmemcheck.h>
@@ -675,6 +676,7 @@ asmlinkage void __init start_kernel(void)
 	buffer_init();
 	key_init();
 	security_init();
+	kdb_init(KDB_INIT_FULL);
 	vfs_caches_init(totalram_pages);
 	signals_init();
 	/* rootfs populating might need page-writeback */
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 13aff29..6f6d091 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/seq_file.h>
 #include <linux/fs.h>
+#include <linux/kdb.h>
 #include <linux/err.h>
 #include <linux/proc_fs.h>
 #include <linux/sched.h>	/* for cond_resched */
@@ -516,6 +517,26 @@ static int kallsyms_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+#ifdef	CONFIG_KGDB_KDB
+const char *kdb_walk_kallsyms(loff_t *pos)
+{
+	static struct kallsym_iter kdb_walk_kallsyms_iter;
+	if (*pos == 0) {
+		memset(&kdb_walk_kallsyms_iter, 0,
+		       sizeof(kdb_walk_kallsyms_iter));
+		reset_iter(&kdb_walk_kallsyms_iter, 0);
+	}
+	while (1) {
+		if (!update_iter(&kdb_walk_kallsyms_iter, *pos))
+			return NULL;
+		++*pos;
+		/* Some debugging symbols have no name.  Ignore them. */
+		if (kdb_walk_kallsyms_iter.name[0])
+			return kdb_walk_kallsyms_iter.name;
+	}
+}
+#endif	/* CONFIG_KGDB_KDB */
+
 static const struct file_operations kallsyms_operations = {
 	.open = kallsyms_open,
 	.read = seq_read,
diff --git a/kernel/module.c b/kernel/module.c
index 1016b75..6e78a34 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -79,6 +79,10 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
+#ifdef CONFIG_KGDB_KDB
+struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
+#endif /* CONFIG_KGDB_KDB */
+
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
diff --git a/kernel/printk.c b/kernel/printk.c
index 75077ad..9213b8b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -413,6 +413,22 @@ SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
 	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
 }
 
+#ifdef	CONFIG_KGDB_KDB
+/* kdb dmesg command needs access to the syslog buffer.  do_syslog()
+ * uses locks so it cannot be used during debugging.  Just tell kdb
+ * where the start and end of the physical and logical logs are.  This
+ * is equivalent to do_syslog(3).
+ */
+void kdb_syslog_data(char *syslog_data[4])
+{
+	syslog_data[0] = log_buf;
+	syslog_data[1] = log_buf + log_buf_len;
+	syslog_data[2] = log_buf + log_end -
+		(logged_chars < log_buf_len ? logged_chars : log_buf_len);
+	syslog_data[3] = log_buf + log_end;
+}
+#endif	/* CONFIG_KGDB_KDB */
+
 /*
  * Call the console drivers on a range of log_buf
  */
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c2a54f..9249f8e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7958,9 +7958,9 @@ void normalize_rt_tasks(void)
 
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-#ifdef CONFIG_IA64
+#if defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB)
 /*
- * These functions are only useful for the IA64 MCA handling.
+ * These functions are only useful for the IA64 MCA handling, or kdb.
  *
  * They can only be called when the whole system has been
  * stopped - every CPU needs to be quiescent, and no scheduling
@@ -7980,6 +7980,9 @@ struct task_struct *curr_task(int cpu)
 	return cpu_curr(cpu);
 }
 
+#endif /* defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB) */
+
+#ifdef CONFIG_IA64
 /**
  * set_curr_task - set the current task for a given cpu.
  * @cpu: the processor in question.
diff --git a/kernel/signal.c b/kernel/signal.c
index dbd7fe0..825a3f2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2735,3 +2735,43 @@ void __init signals_init(void)
 {
 	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
 }
+
+#ifdef CONFIG_KGDB_KDB
+#include <linux/kdb.h>
+/*
+ * kdb_send_sig_info - Allows kdb to send signals without exposing
+ * signal internals.  This function checks if the required locks are
+ * available before calling the main signal code, to avoid kdb
+ * deadlocks.
+ */
+void
+kdb_send_sig_info(struct task_struct *t, struct siginfo *info)
+{
+	static struct task_struct *kdb_prev_t;
+	int sig, new_t;
+	if (!spin_trylock(&t->sighand->siglock)) {
+		kdb_printf("Can't do kill command now.\n"
+			   "The sigmask lock is held somewhere else in "
+			   "kernel, try again later\n");
+		return;
+	}
+	spin_unlock(&t->sighand->siglock);
+	new_t = kdb_prev_t != t;
+	kdb_prev_t = t;
+	if (t->state != TASK_RUNNING && new_t) {
+		kdb_printf("Process is not RUNNING, sending a signal from "
+			   "kdb risks deadlock\n"
+			   "on the run queue locks. "
+			   "The signal has _not_ been sent.\n"
+			   "Reissue the kill command if you want to risk "
+			   "the deadlock.\n");
+		return;
+	}
+	sig = info->si_signo;
+	if (send_sig_info(sig, info, t))
+		kdb_printf("Fail to deliver Signal %d to process %d.\n",
+			   sig, t->pid);
+	else
+		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
+}
+#endif	/* CONFIG_KGDB_KDB */
-- 
1.6.3.3

