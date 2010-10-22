Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab0JVU6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:58:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:36319 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0JVU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:57:07 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 04/11] kdb: Allow kernel loadable modules to add kdb shell functions
Date: Fri, 22 Oct 2010 15:56:24 -0500
Message-Id: <1287780991-7476-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Oct 2010 20:56:50.0987 (UTC) FILETIME=[A653EFB0:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow kernel modules to dynamically add a command to the
kdb shell the kdb_register, kdb_register_repeat, kdb_unregister, and
kdb_printf need to be exported as GPL symbols.

Any kernel module that adds a dynamic kdb shell function should only
need to include linux/kdb.h.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kdb.h            |   43 ++++++++++++++++++++++++++++++++++++++++
 kernel/debug/kdb/kdb_io.c      |    2 +-
 kernel/debug/kdb/kdb_main.c    |    4 +++
 kernel/debug/kdb/kdb_private.h |   39 ------------------------------------
 4 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index ea6e524..deda197 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -28,6 +28,41 @@ extern int kdb_poll_idx;
 extern int kdb_initial_cpu;
 extern atomic_t kdb_event;
 
+/* Types and messages used for dynamically added kdb shell commands */
+
+#define KDB_MAXARGS    16 /* Maximum number of arguments to a function  */
+
+typedef enum {
+	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
+	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
+	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
+} kdb_repeat_t;
+
+typedef int (*kdb_func_t)(int, const char **);
+
+/* KDB return codes from a command or internal kdb function */
+#define KDB_NOTFOUND	(-1)
+#define KDB_ARGCOUNT	(-2)
+#define KDB_BADWIDTH	(-3)
+#define KDB_BADRADIX	(-4)
+#define KDB_NOTENV	(-5)
+#define KDB_NOENVVALUE	(-6)
+#define KDB_NOTIMP	(-7)
+#define KDB_ENVFULL	(-8)
+#define KDB_ENVBUFFULL	(-9)
+#define KDB_TOOMANYBPT	(-10)
+#define KDB_TOOMANYDBREGS (-11)
+#define KDB_DUPBPT	(-12)
+#define KDB_BPTNOTFOUND	(-13)
+#define KDB_BADMODE	(-14)
+#define KDB_BADINT	(-15)
+#define KDB_INVADDRFMT  (-16)
+#define KDB_BADREG      (-17)
+#define KDB_BADCPUNUM   (-18)
+#define KDB_BADLENGTH	(-19)
+#define KDB_NOBP	(-20)
+#define KDB_BADADDR	(-21)
+
 /*
  * kdb_diemsg
  *
@@ -105,9 +140,17 @@ int kdb_process_cpu(const struct task_struct *p)
 /* kdb access to register set for stack dumping */
 extern struct pt_regs *kdb_current_regs;
 
+/* Dynamic kdb shell command registration */
+extern int kdb_register(char *, kdb_func_t, char *, char *, short);
+extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
+			       short, kdb_repeat_t);
+extern int kdb_unregister(char *);
 #else /* ! CONFIG_KGDB_KDB */
 #define kdb_printf(...)
 #define kdb_init(x)
+#define kdb_register(...)
+#define kdb_register_repeat(...)
+#define kdb_uregister(x)
 #endif	/* CONFIG_KGDB_KDB */
 enum {
 	KDB_NOT_INITIALIZED,
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index c9b7f4f..96fdaac 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -823,4 +823,4 @@ int kdb_printf(const char *fmt, ...)
 
 	return r;
 }
-
+EXPORT_SYMBOL_GPL(kdb_printf);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index caf057a..5448990 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2783,6 +2783,8 @@ int kdb_register_repeat(char *cmd,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kdb_register_repeat);
+
 
 /*
  * kdb_register - Compatibility register function for commands that do
@@ -2805,6 +2807,7 @@ int kdb_register(char *cmd,
 	return kdb_register_repeat(cmd, func, usage, help, minlen,
 				   KDB_REPEAT_NONE);
 }
+EXPORT_SYMBOL_GPL(kdb_register);
 
 /*
  * kdb_unregister - This function is used to unregister a kernel
@@ -2833,6 +2836,7 @@ int kdb_unregister(char *cmd)
 	/* Couldn't find it.  */
 	return 1;
 }
+EXPORT_SYMBOL_GPL(kdb_unregister);
 
 /* Initialize the kdb command table. */
 static void __init kdb_inittab(void)
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index be775f7..1921e6e 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -15,29 +15,6 @@
 #include <linux/kgdb.h>
 #include "../debug_core.h"
 
-/* Kernel Debugger Error codes.  Must not overlap with command codes. */
-#define KDB_NOTFOUND	(-1)
-#define KDB_ARGCOUNT	(-2)
-#define KDB_BADWIDTH	(-3)
-#define KDB_BADRADIX	(-4)
-#define KDB_NOTENV	(-5)
-#define KDB_NOENVVALUE	(-6)
-#define KDB_NOTIMP	(-7)
-#define KDB_ENVFULL	(-8)
-#define KDB_ENVBUFFULL	(-9)
-#define KDB_TOOMANYBPT	(-10)
-#define KDB_TOOMANYDBREGS (-11)
-#define KDB_DUPBPT	(-12)
-#define KDB_BPTNOTFOUND	(-13)
-#define KDB_BADMODE	(-14)
-#define KDB_BADINT	(-15)
-#define KDB_INVADDRFMT  (-16)
-#define KDB_BADREG      (-17)
-#define KDB_BADCPUNUM   (-18)
-#define KDB_BADLENGTH	(-19)
-#define KDB_NOBP	(-20)
-#define KDB_BADADDR	(-21)
-
 /* Kernel Debugger Command codes.  Must not overlap with error codes. */
 #define KDB_CMD_GO	(-1001)
 #define KDB_CMD_CPU	(-1002)
@@ -93,17 +70,6 @@
  */
 #define KDB_MAXBPT	16
 
-/* Maximum number of arguments to a function  */
-#define KDB_MAXARGS    16
-
-typedef enum {
-	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
-	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
-	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
-} kdb_repeat_t;
-
-typedef int (*kdb_func_t)(int, const char **);
-
 /* Symbol table format returned by kallsyms. */
 typedef struct __ksymtab {
 		unsigned long value;	/* Address of symbol */
@@ -123,11 +89,6 @@ extern int kallsyms_symbol_next(char *prefix_name, int flag);
 extern int kallsyms_symbol_complete(char *prefix_name, int max_len);
 
 /* Exported Symbols for kernel loadable modules to use. */
-extern int kdb_register(char *, kdb_func_t, char *, char *, short);
-extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
-			       short, kdb_repeat_t);
-extern int kdb_unregister(char *);
-
 extern int kdb_getarea_size(void *, unsigned long, size_t);
 extern int kdb_putarea_size(unsigned long, void *, size_t);
 
-- 
1.6.3.3

