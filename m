Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab0ESBk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:40:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:41175 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab0ESBkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:13 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 22/25] printk,kdb: capture printk() when in kdb shell
Date: Tue, 18 May 2010 20:39:32 -0500
Message-Id: <1274233175-3675-23-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:00.0204 (UTC) FILETIME=[31D5F8C0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain calls from the kdb shell will call out to printk(), and any of
these calls should get vectored back to the kdb_printf() so that the
kdb pager and processing can be used, as well as to properly channel
I/O to the polled I/O devices.

CC: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/kdb.h         |    3 +++
 kernel/debug/kdb/kdb_bt.c   |    2 ++
 kernel/debug/kdb/kdb_io.c   |   24 ++++++++++++++++++++----
 kernel/debug/kdb/kdb_main.c |    4 ++++
 kernel/printk.c             |    9 +++++++++
 5 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index d72fa39..ccb2b3e 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -78,6 +78,9 @@ typedef enum {
 	KDB_REASON_SSTEP,	/* Single Step trap. - regs valid */
 } kdb_reason_t;
 
+extern int kdb_trap_printk;
+extern int vkdb_printf(const char *fmt, va_list args)
+	    __attribute__ ((format (printf, 1, 0)));
 extern int kdb_printf(const char *, ...)
 	    __attribute__ ((format (printf, 1, 2)));
 typedef int (*kdb_printf_t)(const char *, ...)
diff --git a/kernel/debug/kdb/kdb_bt.c b/kernel/debug/kdb/kdb_bt.c
index 483fa4e..2f62fe8 100644
--- a/kernel/debug/kdb/kdb_bt.c
+++ b/kernel/debug/kdb/kdb_bt.c
@@ -23,6 +23,7 @@ static void kdb_show_stack(struct task_struct *p, void *addr)
 {
 	int old_lvl = console_loglevel;
 	console_loglevel = 15;
+	kdb_trap_printk++;
 	kdb_set_current_task(p);
 	if (addr) {
 		show_stack((struct task_struct *)p, addr);
@@ -36,6 +37,7 @@ static void kdb_show_stack(struct task_struct *p, void *addr)
 		show_stack(p, NULL);
 	}
 	console_loglevel = old_lvl;
+	kdb_trap_printk--;
 }
 
 /*
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 58be7e9..c9b7f4f 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -29,6 +29,7 @@
 #define CMD_BUFLEN 256
 char kdb_prompt_str[CMD_BUFLEN];
 
+int kdb_trap_printk;
 
 static void kgdb_transition_check(char *buffer)
 {
@@ -533,12 +534,12 @@ static int kdb_search_string(char *searched, char *searchfor)
 	return 0;
 }
 
-int kdb_printf(const char *fmt, ...)
+int vkdb_printf(const char *fmt, va_list ap)
 {
-	va_list ap;
 	int diag;
 	int linecount;
 	int logging, saved_loglevel = 0;
+	int saved_trap_printk;
 	int got_printf_lock = 0;
 	int retlen = 0;
 	int fnd, len;
@@ -549,6 +550,9 @@ int kdb_printf(const char *fmt, ...)
 	unsigned long uninitialized_var(flags);
 
 	preempt_disable();
+	saved_trap_printk = kdb_trap_printk;
+	kdb_trap_printk = 0;
+
 	/* Serialize kdb_printf if multiple cpus try to write at once.
 	 * But if any cpu goes recursive in kdb, just print the output,
 	 * even if it is interleaved with any other text.
@@ -575,9 +579,7 @@ int kdb_printf(const char *fmt, ...)
 		next_avail = kdb_buffer;
 		size_avail = sizeof(kdb_buffer);
 	}
-	va_start(ap, fmt);
 	vsnprintf(next_avail, size_avail, fmt, ap);
-	va_end(ap);
 
 	/*
 	 * If kdb_parse() found that the command was cmd xxx | grep yyy
@@ -805,6 +807,20 @@ kdb_print_out:
 	} else {
 		__release(kdb_printf_lock);
 	}
+	kdb_trap_printk = saved_trap_printk;
 	preempt_enable();
 	return retlen;
 }
+
+int kdb_printf(const char *fmt, ...)
+{
+	va_list ap;
+	int r;
+
+	va_start(ap, fmt);
+	r = vkdb_printf(fmt, ap);
+	va_end(ap);
+
+	return r;
+}
+
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index f48d8d7..f1f9309 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1055,7 +1055,9 @@ static void kdb_dumpregs(struct pt_regs *regs)
 {
 	int old_lvl = console_loglevel;
 	console_loglevel = 15;
+	kdb_trap_printk++;
 	show_regs(regs);
+	kdb_trap_printk--;
 	kdb_printf("\n");
 	console_loglevel = old_lvl;
 }
@@ -1822,7 +1824,9 @@ static int kdb_sr(int argc, const char **argv)
 		__sysrq_enabled = 1;
 	}
 
+	kdb_trap_printk++;
 	handle_sysrq(*argv[1], NULL);
+	kdb_trap_printk--;
 
 	return 0;
 }
diff --git a/kernel/printk.c b/kernel/printk.c
index 9213b8b..444b770 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/kdb.h>
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
 #include <linux/syslog.h>
@@ -602,6 +603,14 @@ asmlinkage int printk(const char *fmt, ...)
 	va_list args;
 	int r;
 
+#ifdef CONFIG_KGDB_KDB
+	if (unlikely(kdb_trap_printk)) {
+		va_start(args, fmt);
+		r = vkdb_printf(fmt, args);
+		va_end(args);
+		return r;
+	}
+#endif
 	va_start(args, fmt);
 	r = vprintk(fmt, args);
 	va_end(args);
-- 
1.6.3.3

