Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2GZO26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:28:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64952 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2GZO24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:28:56 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 5/7] kdb: Remove KDB_REPEAT_NONE flag
Date: Thu, 26 Jul 2012 07:26:29 -0700
Message-Id: <1343312791-9138-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120726142514.GA32158@lizard>
References: <20120726142514.GA32158@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now treat KDB_REPEAT_* as flags, there is no need to
pass KDB_REPEAT_NONE. It's just the default behaviour when no
flags are specified.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/kdb.h         |    1 -
 kernel/debug/kdb/kdb_bp.c   |    6 ++---
 kernel/debug/kdb/kdb_main.c |   59 +++++++++++++++++++++----------------------
 kernel/trace/trace_kdb.c    |    2 +-
 4 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 0a047f9..d39d41d 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -33,7 +33,6 @@ extern atomic_t kdb_event;
 #define KDB_MAXARGS    16 /* Maximum number of arguments to a function  */
 
 typedef enum {
-	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
 	KDB_REPEAT_NO_ARGS	= 0x1, /* Repeat the command w/o arguments */
 	KDB_REPEAT_WITH_ARGS	= 0x2, /* Repeat the command w/ its arguments */
 } kdb_cmdflags_t;
diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index d2cb80d..928e9e9 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -553,11 +553,11 @@ void __init kdb_initbptab(void)
 		kdb_register_flags("bph", kdb_bp, "[<vaddr>]",
 		"[datar [length]|dataw [length]]   Set hw brk", 0, KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("bc", kdb_bc, "<bpnum>",
-		"Clear Breakpoint", 0, KDB_REPEAT_NONE);
+		"Clear Breakpoint", 0, 0);
 	kdb_register_flags("be", kdb_bc, "<bpnum>",
-		"Enable Breakpoint", 0, KDB_REPEAT_NONE);
+		"Enable Breakpoint", 0, 0);
 	kdb_register_flags("bd", kdb_bc, "<bpnum>",
-		"Disable Breakpoint", 0, KDB_REPEAT_NONE);
+		"Disable Breakpoint", 0, 0);
 
 	kdb_register_flags("ss", kdb_ss, "",
 		"Single Step", 1, KDB_REPEAT_NO_ARGS);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index c7d023a..21e58fb 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2761,7 +2761,7 @@ EXPORT_SYMBOL_GPL(kdb_register_flags);
 /*
  * kdb_register - Compatibility register function for commands that do
  *	not need to specify a repeat state.  Equivalent to
- *	kdb_register_flags with KDB_REPEAT_NONE.
+ *	kdb_register_flags with flags set to 0.
  * Inputs:
  *	cmd	Command name
  *	func	Function to execute the command
@@ -2776,8 +2776,7 @@ int kdb_register(char *cmd,
 	     char *help,
 	     short minlen)
 {
-	return kdb_register_flags(cmd, func, usage, help, minlen,
-				  KDB_REPEAT_NONE);
+	return kdb_register_flags(cmd, func, usage, help, minlen, 0);
 }
 EXPORT_SYMBOL_GPL(kdb_register);
 
@@ -2831,66 +2830,66 @@ static void __init kdb_inittab(void)
 	kdb_register_flags("mm", kdb_mm, "<vaddr> <contents>",
 	  "Modify Memory Contents", 0, KDB_REPEAT_NO_ARGS);
 	kdb_register_flags("go", kdb_go, "[<vaddr>]",
-	  "Continue Execution", 1, KDB_REPEAT_NONE);
+	  "Continue Execution", 1, 0);
 	kdb_register_flags("rd", kdb_rd, "",
-	  "Display Registers", 0, KDB_REPEAT_NONE);
+	  "Display Registers", 0, 0);
 	kdb_register_flags("rm", kdb_rm, "<reg> <contents>",
-	  "Modify Registers", 0, KDB_REPEAT_NONE);
+	  "Modify Registers", 0, 0);
 	kdb_register_flags("ef", kdb_ef, "<vaddr>",
-	  "Display exception frame", 0, KDB_REPEAT_NONE);
+	  "Display exception frame", 0, 0);
 	kdb_register_flags("bt", kdb_bt, "[<vaddr>]",
-	  "Stack traceback", 1, KDB_REPEAT_NONE);
+	  "Stack traceback", 1, 0);
 	kdb_register_flags("btp", kdb_bt, "<pid>",
-	  "Display stack for process <pid>", 0, KDB_REPEAT_NONE);
+	  "Display stack for process <pid>", 0, 0);
 	kdb_register_flags("bta", kdb_bt, "[DRSTCZEUIMA]",
-	  "Display stack all processes", 0, KDB_REPEAT_NONE);
+	  "Display stack all processes", 0, 0);
 	kdb_register_flags("btc", kdb_bt, "",
-	  "Backtrace current process on each cpu", 0, KDB_REPEAT_NONE);
+	  "Backtrace current process on each cpu", 0, 0);
 	kdb_register_flags("btt", kdb_bt, "<vaddr>",
 	  "Backtrace process given its struct task address", 0,
-			    KDB_REPEAT_NONE);
+			    0);
 	kdb_register_flags("ll", kdb_ll, "<first-element> <linkoffset> <cmd>",
-	  "Execute cmd for each element in linked list", 0, KDB_REPEAT_NONE);
+	  "Execute cmd for each element in linked list", 0, 0);
 	kdb_register_flags("env", kdb_env, "",
-	  "Show environment variables", 0, KDB_REPEAT_NONE);
+	  "Show environment variables", 0, 0);
 	kdb_register_flags("set", kdb_set, "",
-	  "Set environment variables", 0, KDB_REPEAT_NONE);
+	  "Set environment variables", 0, 0);
 	kdb_register_flags("help", kdb_help, "",
-	  "Display Help Message", 1, KDB_REPEAT_NONE);
+	  "Display Help Message", 1, 0);
 	kdb_register_flags("?", kdb_help, "",
-	  "Display Help Message", 0, KDB_REPEAT_NONE);
+	  "Display Help Message", 0, 0);
 	kdb_register_flags("cpu", kdb_cpu, "<cpunum>",
-	  "Switch to new cpu", 0, KDB_REPEAT_NONE);
+	  "Switch to new cpu", 0, 0);
 	kdb_register_flags("kgdb", kdb_kgdb, "",
-	  "Enter kgdb mode", 0, KDB_REPEAT_NONE);
+	  "Enter kgdb mode", 0, 0);
 	kdb_register_flags("ps", kdb_ps, "[<flags>|A]",
-	  "Display active task list", 0, KDB_REPEAT_NONE);
+	  "Display active task list", 0, 0);
 	kdb_register_flags("pid", kdb_pid, "<pidnum>",
-	  "Switch to another task", 0, KDB_REPEAT_NONE);
+	  "Switch to another task", 0, 0);
 	kdb_register_flags("reboot", kdb_reboot, "",
-	  "Reboot the machine immediately", 0, KDB_REPEAT_NONE);
+	  "Reboot the machine immediately", 0, 0);
 #if defined(CONFIG_MODULES)
 	kdb_register_flags("lsmod", kdb_lsmod, "",
-	  "List loaded kernel modules", 0, KDB_REPEAT_NONE);
+	  "List loaded kernel modules", 0, 0);
 #endif
 #if defined(CONFIG_MAGIC_SYSRQ)
 	kdb_register_flags("sr", kdb_sr, "<key>",
-	  "Magic SysRq key", 0, KDB_REPEAT_NONE);
+	  "Magic SysRq key", 0, 0);
 #endif
 #if defined(CONFIG_PRINTK)
 	kdb_register_flags("dmesg", kdb_dmesg, "[lines]",
-	  "Display syslog buffer", 0, KDB_REPEAT_NONE);
+	  "Display syslog buffer", 0, 0);
 #endif
 	kdb_register_flags("defcmd", kdb_defcmd, "name \"usage\" \"help\"",
-	  "Define a set of commands, down to endefcmd", 0, KDB_REPEAT_NONE);
+	  "Define a set of commands, down to endefcmd", 0, 0);
 	kdb_register_flags("kill", kdb_kill, "<-signal> <pid>",
-	  "Send a signal to a process", 0, KDB_REPEAT_NONE);
+	  "Send a signal to a process", 0, 0);
 	kdb_register_flags("summary", kdb_summary, "",
-	  "Summarize the system", 4, KDB_REPEAT_NONE);
+	  "Summarize the system", 4, 0);
 	kdb_register_flags("per_cpu", kdb_per_cpu, "<sym> [<bytes>] [<cpu>]",
-	  "Display per_cpu variables", 3, KDB_REPEAT_NONE);
+	  "Display per_cpu variables", 3, 0);
 	kdb_register_flags("grephelp", kdb_grep_help, "",
-	  "Display help on | grep", 0, KDB_REPEAT_NONE);
+	  "Display help on | grep", 0, 0);
 }
 
 /* Execute any commands defined in kdb_cmds.  */
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index e9db346..1b68177 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -128,7 +128,7 @@ static int kdb_ftdump(int argc, const char **argv)
 static __init int kdb_ftrace_register(void)
 {
 	kdb_register_flags("ftdump", kdb_ftdump, "[skip_#lines] [cpu]",
-			    "Dump ftrace log", 0, KDB_REPEAT_NONE);
+			    "Dump ftrace log", 0, 0);
 	return 0;
 }
 
-- 
1.7.10.4

