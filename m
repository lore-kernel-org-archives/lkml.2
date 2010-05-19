Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0ESBoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:44:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:41205 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0ESBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:19 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/7] x86, kgdb, init: Add early and late debug states
Date: Tue, 18 May 2010 20:39:57 -0500
Message-Id: <1274233202-3734-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
References: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:07.0204 (UTC) FILETIME=[36021640:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel debugger can operate well before mm_init(), but the x86
hardware breakpoint code which uses the perf api requires that the
kernel allocators are initialized.

This means the kernel debug core needs to provide an optional arch
specific call back to allow the initialization functions to run after
the kernel has been further initialized.

The kdb shell already had a similar restriction with an early
initialization and late initialization.  The kdb_init() was moved into
the debug core's version of the late init which is called
dbg_late_init();

CC: kgdb-bugreport@lists.sourceforge.net
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c    |   17 ++++++++++-------
 include/linux/kgdb.h      |   14 ++++++++++++++
 init/main.c               |    4 ++--
 kernel/debug/debug_core.c |   16 ++++++++++++++++
 4 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 95b89d4..2b71ec4 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -596,14 +596,15 @@ static struct notifier_block kgdb_notifier = {
  */
 int kgdb_arch_init(void)
 {
+	return register_die_notifier(&kgdb_notifier);
+}
+
+void kgdb_arch_late(void)
+{
 	int i, cpu;
-	int ret;
 	struct perf_event_attr attr;
 	struct perf_event **pevent;
 
-	ret = register_die_notifier(&kgdb_notifier);
-	if (ret != 0)
-		return ret;
 	/*
 	 * Pre-allocate the hw breakpoint structions in the non-atomic
 	 * portion of kgdb because this operation requires mutexs to
@@ -615,12 +616,15 @@ int kgdb_arch_init(void)
 	attr.bp_type = HW_BREAKPOINT_W;
 	attr.disabled = 1;
 	for (i = 0; i < 4; i++) {
+		if (breakinfo[i].pev)
+			continue;
 		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
 		if (IS_ERR(breakinfo[i].pev)) {
-			printk(KERN_ERR "kgdb: Could not allocate hw breakpoints\n");
+			printk(KERN_ERR "kgdb: Could not allocate hw"
+			       "breakpoints\nDisabling the kernel debugger\n");
 			breakinfo[i].pev = NULL;
 			kgdb_arch_exit();
-			return -1;
+			return;
 		}
 		for_each_online_cpu(cpu) {
 			pevent = per_cpu_ptr(breakinfo[i].pev, cpu);
@@ -631,7 +635,6 @@ int kgdb_arch_init(void)
 			}
 		}
 	}
-	return ret;
 }
 
 /**
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6c784ab..9340f34 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -208,6 +208,17 @@ extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
 extern int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle);
 
 /**
+ *	kgdb_arch_late - Perform any architecture specific initalization.
+ *
+ *	This function will handle the late initalization of any
+ *	architecture specific callbacks.  This is an optional function for
+ *	handling things like late initialization of hw breakpoints.  The
+ *	default implementation does nothing.
+ */
+extern void kgdb_arch_late(void);
+
+
+/**
  * struct kgdb_arch - Describe architecture specific values.
  * @gdb_bpt_instr: The instruction to trigger a breakpoint.
  * @flags: Flags for the breakpoint, currently just %KGDB_HW_BREAKPOINT.
@@ -285,7 +296,10 @@ extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
 #define in_dbg_master() \
 	(raw_smp_processor_id() == atomic_read(&kgdb_active))
+extern bool dbg_is_early;
+extern void __init dbg_late_init(void);
 #else /* ! CONFIG_KGDB */
 #define in_dbg_master() (0)
+#define dbg_late_init()
 #endif /* ! CONFIG_KGDB */
 #endif /* _KGDB_H_ */
diff --git a/init/main.c b/init/main.c
index 3727713..22881b5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -62,7 +62,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
-#include <linux/kdb.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/kmemcheck.h>
@@ -676,7 +676,7 @@ asmlinkage void __init start_kernel(void)
 	buffer_init();
 	key_init();
 	security_init();
-	kdb_init(KDB_INIT_FULL);
+	dbg_late_init();
 	vfs_caches_init(totalram_pages);
 	signals_init();
 	/* rootfs populating might need page-writeback */
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 64b5588..5cb7cd1 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -78,6 +78,8 @@ static DEFINE_SPINLOCK(kgdb_registration_lock);
 static int kgdb_con_registered;
 /* determine if kgdb console output should be used */
 static int kgdb_use_con;
+/* Flag for alternate operations for early debugging */
+bool dbg_is_early = true;
 /* Next cpu to become the master debug core */
 int dbg_switch_cpu;
 
@@ -777,11 +779,25 @@ static struct notifier_block kgdb_panic_event_nb = {
        .priority	= INT_MAX,
 };
 
+void __weak kgdb_arch_late(void)
+{
+}
+
+void __init dbg_late_init(void)
+{
+	dbg_is_early = false;
+	if (kgdb_io_module_registered)
+		kgdb_arch_late();
+	kdb_init(KDB_INIT_FULL);
+}
+
 static void kgdb_register_callbacks(void)
 {
 	if (!kgdb_io_module_registered) {
 		kgdb_io_module_registered = 1;
 		kgdb_arch_init();
+		if (!dbg_is_early)
+			kgdb_arch_late();
 		atomic_notifier_chain_register(&panic_notifier_list,
 					       &kgdb_panic_event_nb);
 #ifdef CONFIG_MAGIC_SYSRQ
-- 
1.6.3.3

