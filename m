Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab0JVU6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:58:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:36318 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab0JVU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:57:07 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 07/11] kdb,kgdb: fix sparse fixups
Date: Fri, 22 Oct 2010 15:56:27 -0500
Message-Id: <1287780991-7476-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Oct 2010 20:56:53.0424 (UTC) FILETIME=[A7C7CB00:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:

kdb_main.c:328:5: warning: symbol 'kdbgetu64arg' was not declared. Should it be static?
kgdboc.c:246:12: warning: symbol 'kgdboc_early_init' was not declared. Should it be static?
kgdb.c:652:26: warning: incorrect type in argument 1 (different address spaces)
kgdb.c:652:26:    expected void const *ptr
kgdb.c:652:26:    got struct perf_event *[noderef] <asn:3>*pev

The one in kgdb.c required the (void * __force) because of the return
code from register_wide_hw_breakpoint looking like:

        return (void __percpu __force *)ERR_PTR(err);

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c         |    2 +-
 drivers/serial/kgdboc.c        |    2 +-
 include/linux/kdb.h            |    8 ++++++++
 kernel/debug/kdb/kdb_private.h |    9 +--------
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 497f973..101bf22 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -649,7 +649,7 @@ void kgdb_arch_late(void)
 		if (breakinfo[i].pev)
 			continue;
 		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
-		if (IS_ERR(breakinfo[i].pev)) {
+		if (IS_ERR((void * __force)breakinfo[i].pev)) {
 			printk(KERN_ERR "kgdb: Could not allocate hw"
 			       "breakpoints\nDisabling the kernel debugger\n");
 			breakinfo[i].pev = NULL;
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 39f9a1a..d4b711c 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -243,7 +243,7 @@ static struct kgdb_io kgdboc_io_ops = {
 
 #ifdef CONFIG_KGDB_SERIAL_CONSOLE
 /* This is only available if kgdboc is a built in for early debugging */
-int __init kgdboc_early_init(char *opt)
+static int __init kgdboc_early_init(char *opt)
 {
 	/* save the first character of the config string because the
 	 * init routine can destroy it.
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index deda197..aadff7c 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -139,6 +139,14 @@ int kdb_process_cpu(const struct task_struct *p)
 
 /* kdb access to register set for stack dumping */
 extern struct pt_regs *kdb_current_regs;
+#ifdef CONFIG_KALLSYMS
+extern const char *kdb_walk_kallsyms(loff_t *pos);
+#else /* ! CONFIG_KALLSYMS */
+static inline const char *kdb_walk_kallsyms(loff_t *pos)
+{
+	return NULL;
+}
+#endif /* ! CONFIG_KALLSYMS */
 
 /* Dynamic kdb shell command registration */
 extern int kdb_register(char *, kdb_func_t, char *, char *, short);
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 1921e6e..35d69ed 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -105,6 +105,7 @@ extern int kdb_getword(unsigned long *, unsigned long, size_t);
 extern int kdb_putword(unsigned long, unsigned long, size_t);
 
 extern int kdbgetularg(const char *, unsigned long *);
+extern int kdbgetu64arg(const char *, u64 *);
 extern char *kdbgetenv(const char *);
 extern int kdbgetaddrarg(int, const char **, int*, unsigned long *,
 			 long *, char **);
@@ -216,14 +217,6 @@ extern void kdb_ps1(const struct task_struct *p);
 extern void kdb_print_nameval(const char *name, unsigned long val);
 extern void kdb_send_sig_info(struct task_struct *p, struct siginfo *info);
 extern void kdb_meminfo_proc_show(void);
-#ifdef CONFIG_KALLSYMS
-extern const char *kdb_walk_kallsyms(loff_t *pos);
-#else /* ! CONFIG_KALLSYMS */
-static inline const char *kdb_walk_kallsyms(loff_t *pos)
-{
-	return NULL;
-}
-#endif /* ! CONFIG_KALLSYMS */
 extern char *kdb_getstr(char *, size_t, char *);
 
 /* Defines for kdb_symbol_print */
-- 
1.6.3.3

