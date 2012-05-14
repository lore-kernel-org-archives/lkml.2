Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab2ENQyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:54:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58841 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755885Ab2ENQys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:54:48 -0400
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/4] printk: Separate out log_buf variables and functions
Date: Mon, 14 May 2012 09:54:31 -0700
Message-Id: <f12eb3af19116a8607795ba1e5ced19df0fefc8d.1337013605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <1337013987.29436.16.camel@joe2Laptop>
References: <1337013987.29436.16.camel@joe2Laptop>
In-Reply-To: <76bd4533a88ae2ebf584887d51bf306591d0c01a.1337013604.git.joe@perches.com>
References: <76bd4533a88ae2ebf584887d51bf306591d0c01a.1337013604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some clarity to the printk subsystem by restructuring
the code a bit.

Move the log_buf variables and functions to separate
code and header files.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/Makefile  |    3 +-
 kernel/printk/log_buf.c |  268 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/printk/log_buf.h |   27 +++++
 kernel/printk/printk.c  |  283 ++++-------------------------------------------
 4 files changed, 317 insertions(+), 264 deletions(-)
 create mode 100644 kernel/printk/log_buf.c
 create mode 100644 kernel/printk/log_buf.h

diff --git a/kernel/printk/Makefile b/kernel/printk/Makefile
index 6bae497..2fc9fe7 100644
--- a/kernel/printk/Makefile
+++ b/kernel/printk/Makefile
@@ -1 +1,2 @@
-obj-y				+= printk.o
+obj-y += printk.o
+obj-y += log_buf.o
diff --git a/kernel/printk/log_buf.c b/kernel/printk/log_buf.c
new file mode 100644
index 0000000..b75acf3
--- /dev/null
+++ b/kernel/printk/log_buf.c
@@ -0,0 +1,268 @@
+#include <linux/kernel.h>
+#include <linux/console.h>
+#include <linux/jiffies.h>
+#include <linux/bootmem.h>
+#include <linux/memblock.h>
+#include <linux/kexec.h>
+#include <linux/syslog.h>
+#include <linux/uaccess.h>
+
+#include "log_buf.h"
+
+extern struct semaphore console_sem;
+
+/*
+ * logbuf_lock protects log_buf, log_start, log_end, con_start and logged_chars
+ * It is also used in interesting ways to provide interlocking in
+ * console_unlock();.
+ */
+DEFINE_RAW_SPINLOCK(logbuf_lock);
+
+DECLARE_WAIT_QUEUE_HEAD(log_wait);
+
+/*
+ * These indices into log_buf are not constrained to log_buf_len
+ * they must be masked before subscripting
+ */
+unsigned log_start;		/* next char to be read by syslog() */
+unsigned con_start;		/* next char to be sent to consoles */
+unsigned log_end;		/* most-recently-written-char + 1 */
+
+char __log_buf[__LOG_BUF_LEN];
+char *log_buf = __log_buf;
+int log_buf_len = __LOG_BUF_LEN;
+
+unsigned logged_chars;		/* Number of chars produced since last
+				 * read+clear operation
+				 */
+
+#ifdef CONFIG_KEXEC
+/*
+ * This appends the listed symbols to /proc/vmcoreinfo
+ *
+ * /proc/vmcoreinfo is used by various utiilties, like crash and makedumpfile to
+ * obtain access to symbols that are otherwise very difficult to locate.  These
+ * symbols are specifically used so that utilities can access and extract the
+ * dmesg log from a vmcore file after a crash.
+ */
+void log_buf_kexec_setup(void)
+{
+	VMCOREINFO_SYMBOL(log_buf);
+	VMCOREINFO_SYMBOL(log_end);
+	VMCOREINFO_SYMBOL(log_buf_len);
+	VMCOREINFO_SYMBOL(logged_chars);
+}
+#endif
+
+/* requested log_buf_len from kernel cmdline */
+static unsigned long __initdata new_log_buf_len;
+
+int log_buf_do_syslog(int type, char __user *buf, int len, bool from_file)
+{
+	unsigned i, j, limit, count;
+	int do_clear = 0;
+	char c;
+
+	int error = 0;
+
+	switch (type) {
+	case SYSLOG_ACTION_READ:	/* Read from log */
+		error = -EINVAL;
+		if (!buf || len < 0)
+			goto out;
+		error = 0;
+		if (!len)
+			goto out;
+		if (!access_ok(VERIFY_WRITE, buf, len)) {
+			error = -EFAULT;
+			goto out;
+		}
+		error = wait_event_interruptible(log_wait,
+						 (log_start - log_end));
+		if (error)
+			goto out;
+		i = 0;
+		raw_spin_lock_irq(&logbuf_lock);
+		while (!error && (log_start != log_end) && i < len) {
+			c = LOG_BUF(log_start);
+			log_start++;
+			raw_spin_unlock_irq(&logbuf_lock);
+			error = __put_user(c, buf);
+			buf++;
+			i++;
+			cond_resched();
+			raw_spin_lock_irq(&logbuf_lock);
+		}
+		raw_spin_unlock_irq(&logbuf_lock);
+		if (!error)
+			error = i;
+		break;
+	case SYSLOG_ACTION_READ_CLEAR:	/* Read/clear last kernel messages */
+		do_clear = 1;
+		/* FALL THRU */
+	case SYSLOG_ACTION_READ_ALL:	/* Read last kernel messages */
+		error = -EINVAL;
+		if (!buf || len < 0)
+			goto out;
+		error = 0;
+		if (!len)
+			goto out;
+		if (!access_ok(VERIFY_WRITE, buf, len)) {
+			error = -EFAULT;
+			goto out;
+		}
+		count = len;
+		if (count > log_buf_len)
+			count = log_buf_len;
+		raw_spin_lock_irq(&logbuf_lock);
+		if (count > logged_chars)
+			count = logged_chars;
+		if (do_clear)
+			logged_chars = 0;
+		limit = log_end;
+		/*
+		 * __put_user() could sleep, and while we sleep
+		 * printk() could overwrite the messages
+		 * we try to copy to user space. Therefore
+		 * the messages are copied in reverse. <manfreds>
+		 */
+		for (i = 0; i < count && !error; i++) {
+			j = limit-1-i;
+			if (j + log_buf_len < log_end)
+				break;
+			c = LOG_BUF(j);
+			raw_spin_unlock_irq(&logbuf_lock);
+			error = __put_user(c, &buf[count-1-i]);
+			cond_resched();
+			raw_spin_lock_irq(&logbuf_lock);
+		}
+		raw_spin_unlock_irq(&logbuf_lock);
+		if (error)
+			break;
+		error = i;
+		if (i != count) {
+			int offset = count-error;
+			/* buffer overflow during copy, correct user buffer. */
+			for (i = 0; i < error; i++) {
+				if (__get_user(c, &buf[i+offset]) ||
+				    __put_user(c, &buf[i])) {
+					error = -EFAULT;
+					break;
+				}
+				cond_resched();
+			}
+		}
+		break;
+	case SYSLOG_ACTION_CLEAR:	/* Clear ring buffer */
+		logged_chars = 0;
+		break;
+	case SYSLOG_ACTION_SIZE_UNREAD:	/* Number of chars in the log buffer */
+		error = log_end - log_start;
+		break;
+	case SYSLOG_ACTION_SIZE_BUFFER:	/* Size of the log buffer */
+		error = log_buf_len;
+		break;
+	}
+out:
+	return error;
+}
+
+/* save requested log_buf_len since it's too early to process it */
+static int __init log_buf_len_setup(char *str)
+{
+	unsigned size = memparse(str, &str);
+
+	if (size)
+		size = roundup_pow_of_two(size);
+	if (size > log_buf_len)
+		new_log_buf_len = size;
+
+	return 0;
+}
+early_param("log_buf_len", log_buf_len_setup);
+
+void __init setup_log_buf(int early)
+{
+	unsigned long flags;
+	unsigned start, dest_idx, offset;
+	char *new_log_buf;
+	int free;
+
+	if (!new_log_buf_len)
+		return;
+
+	if (early) {
+		unsigned long mem;
+
+		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
+		if (!mem)
+			return;
+		new_log_buf = __va(mem);
+	} else {
+		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
+	}
+
+	if (unlikely(!new_log_buf)) {
+		pr_err("log_buf_len: %ld bytes not available\n",
+		       new_log_buf_len);
+		return;
+	}
+
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	log_buf_len = new_log_buf_len;
+	log_buf = new_log_buf;
+	new_log_buf_len = 0;
+	free = __LOG_BUF_LEN - log_end;
+
+	offset = start = min(con_start, log_start);
+	dest_idx = 0;
+	while (start != log_end) {
+		unsigned log_idx_mask = start & (__LOG_BUF_LEN - 1);
+
+		log_buf[dest_idx] = __log_buf[log_idx_mask];
+		start++;
+		dest_idx++;
+	}
+	log_start -= offset;
+	con_start -= offset;
+	log_end -= offset;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	pr_info("log_buf_len: %d\n", log_buf_len);
+	pr_info("early log buf free: %d(%d%%)\n",
+		free, (free * 100) / __LOG_BUF_LEN);
+}
+
+void log_buf_emit_char(char c)
+{
+	LOG_BUF(log_end) = c;
+	log_end++;
+	if (log_end - log_start > log_buf_len)
+		log_start = log_end - log_buf_len;
+	if (log_end - con_start > log_buf_len)
+		con_start = log_end - log_buf_len;
+	if (logged_chars < log_buf_len)
+		logged_chars++;
+}
+
+/*
+ * Zap console related locks when oopsing. Only zap at most once
+ * every 10 seconds, to leave time for slow consoles to print a
+ * full oops.
+ */
+void log_buf_zap_locks(void)
+{
+	static unsigned long oops_timestamp;
+
+	if (time_after_eq(jiffies, oops_timestamp) &&
+	    !time_after(jiffies, oops_timestamp + 30 * HZ))
+		return;
+
+	oops_timestamp = jiffies;
+
+	debug_locks_off();
+	/* If a crash is occurring, make sure we can't deadlock */
+	raw_spin_lock_init(&logbuf_lock);
+	/* And make sure that we print immediately */
+	sema_init(&console_sem, 1);
+}
diff --git a/kernel/printk/log_buf.h b/kernel/printk/log_buf.h
new file mode 100644
index 0000000..08ed8ee
--- /dev/null
+++ b/kernel/printk/log_buf.h
@@ -0,0 +1,27 @@
+#ifndef PRINTK_LOG_BUF_H
+#define PRINTK_LOG_BUF_H
+
+#define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
+
+extern unsigned log_start;	/* next char to be read by syslog() */
+extern unsigned con_start;	/* next char to be sent to consoles */
+extern unsigned log_end;	/* most-recently-written-char + 1 */
+extern unsigned logged_chars;	/* Number of chars produced since last
+				 * read+clear operation
+				 */
+
+extern raw_spinlock_t logbuf_lock;
+extern wait_queue_head_t log_wait;
+
+extern char __log_buf[__LOG_BUF_LEN];
+extern char *log_buf;
+extern int log_buf_len;
+
+#define LOG_BUF_MASK (log_buf_len - 1)
+#define LOG_BUF(idx) (log_buf[(idx) & LOG_BUF_MASK])
+
+int log_buf_do_syslog(int type, char __user *buf, int len, bool from_file);
+void log_buf_emit_char(char c);
+void log_buf_zap_locks(void);
+
+#endif
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index d98c094..e90818a 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -15,11 +15,9 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/console.h>
-#include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/nmi.h>
 #include <linux/module.h>
@@ -28,10 +26,7 @@
 #include <linux/delay.h>
 #include <linux/smp.h>
 #include <linux/security.h>
-#include <linux/bootmem.h>
-#include <linux/memblock.h>
 #include <linux/syscalls.h>
-#include <linux/kexec.h>
 #include <linux/kdb.h>
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
@@ -52,8 +47,6 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 {
 }
 
-#define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
-
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
@@ -61,8 +54,6 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
 #define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
 
-DECLARE_WAIT_QUEUE_HEAD(log_wait);
-
 int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
 	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
@@ -82,7 +73,8 @@ EXPORT_SYMBOL(oops_in_progress);
  * provides serialisation for access to the entire console
  * driver system.
  */
-static DEFINE_SEMAPHORE(console_sem);
+DEFINE_SEMAPHORE(console_sem);
+
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
@@ -97,24 +89,6 @@ EXPORT_SYMBOL_GPL(console_drivers);
 static int console_locked, console_suspended;
 
 /*
- * logbuf_lock protects log_buf, log_start, log_end, con_start and logged_chars
- * It is also used in interesting ways to provide interlocking in
- * console_unlock();.
- */
-static DEFINE_RAW_SPINLOCK(logbuf_lock);
-
-#define LOG_BUF_MASK (log_buf_len-1)
-#define LOG_BUF(idx) (log_buf[(idx) & LOG_BUF_MASK])
-
-/*
- * The indices into log_buf are not constrained to log_buf_len - they
- * must be masked before subscripting
- */
-static unsigned log_start;	/* Index into log_buf: next char to be read by syslog() */
-static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
-static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
-
-/*
  * If exclusive_console is non-NULL then only this console is to be printed to.
  */
 static struct console *exclusive_console;
@@ -145,98 +119,9 @@ static int console_may_schedule;
 
 #ifdef CONFIG_PRINTK
 
-static char __log_buf[__LOG_BUF_LEN];
-static char *log_buf = __log_buf;
-static int log_buf_len = __LOG_BUF_LEN;
-static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
-static int saved_console_loglevel = -1;
-
-#ifdef CONFIG_KEXEC
-/*
- * This appends the listed symbols to /proc/vmcoreinfo
- *
- * /proc/vmcoreinfo is used by various utiilties, like crash and makedumpfile to
- * obtain access to symbols that are otherwise very difficult to locate.  These
- * symbols are specifically used so that utilities can access and extract the
- * dmesg log from a vmcore file after a crash.
- */
-void log_buf_kexec_setup(void)
-{
-	VMCOREINFO_SYMBOL(log_buf);
-	VMCOREINFO_SYMBOL(log_end);
-	VMCOREINFO_SYMBOL(log_buf_len);
-	VMCOREINFO_SYMBOL(logged_chars);
-}
-#endif
-
-/* requested log_buf_len from kernel cmdline */
-static unsigned long __initdata new_log_buf_len;
-
-/* save requested log_buf_len since it's too early to process it */
-static int __init log_buf_len_setup(char *str)
-{
-	unsigned size = memparse(str, &str);
-
-	if (size)
-		size = roundup_pow_of_two(size);
-	if (size > log_buf_len)
-		new_log_buf_len = size;
-
-	return 0;
-}
-early_param("log_buf_len", log_buf_len_setup);
-
-void __init setup_log_buf(int early)
-{
-	unsigned long flags;
-	unsigned start, dest_idx, offset;
-	char *new_log_buf;
-	int free;
-
-	if (!new_log_buf_len)
-		return;
-
-	if (early) {
-		unsigned long mem;
-
-		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
-		if (!mem)
-			return;
-		new_log_buf = __va(mem);
-	} else {
-		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
-	}
-
-	if (unlikely(!new_log_buf)) {
-		pr_err("log_buf_len: %ld bytes not available\n",
-			new_log_buf_len);
-		return;
-	}
-
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	log_buf_len = new_log_buf_len;
-	log_buf = new_log_buf;
-	new_log_buf_len = 0;
-	free = __LOG_BUF_LEN - log_end;
-
-	offset = start = min(con_start, log_start);
-	dest_idx = 0;
-	while (start != log_end) {
-		unsigned log_idx_mask = start & (__LOG_BUF_LEN - 1);
-
-		log_buf[dest_idx] = __log_buf[log_idx_mask];
-		start++;
-		dest_idx++;
-	}
-	log_start -= offset;
-	con_start -= offset;
-	log_end -= offset;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+#include "log_buf.h"
 
-	pr_info("log_buf_len: %d\n", log_buf_len);
-	pr_info("early log buf free: %d(%d%%)\n",
-		free, (free * 100) / __LOG_BUF_LEN);
-}
+static int saved_console_loglevel = -1;
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
@@ -332,9 +217,6 @@ static int check_syslog_permissions(int type, bool from_file)
 
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
-	unsigned i, j, limit, count;
-	int do_clear = 0;
-	char c;
 	int error;
 
 	error = check_syslog_permissions(type, from_file);
@@ -350,99 +232,16 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		break;
 	case SYSLOG_ACTION_OPEN:	/* Open log */
 		break;
+
 	case SYSLOG_ACTION_READ:	/* Read from log */
-		error = -EINVAL;
-		if (!buf || len < 0)
-			goto out;
-		error = 0;
-		if (!len)
-			goto out;
-		if (!access_ok(VERIFY_WRITE, buf, len)) {
-			error = -EFAULT;
-			goto out;
-		}
-		error = wait_event_interruptible(log_wait,
-							(log_start - log_end));
-		if (error)
-			goto out;
-		i = 0;
-		raw_spin_lock_irq(&logbuf_lock);
-		while (!error && (log_start != log_end) && i < len) {
-			c = LOG_BUF(log_start);
-			log_start++;
-			raw_spin_unlock_irq(&logbuf_lock);
-			error = __put_user(c,buf);
-			buf++;
-			i++;
-			cond_resched();
-			raw_spin_lock_irq(&logbuf_lock);
-		}
-		raw_spin_unlock_irq(&logbuf_lock);
-		if (!error)
-			error = i;
-		break;
-	/* Read/clear last kernel messages */
-	case SYSLOG_ACTION_READ_CLEAR:
-		do_clear = 1;
-		/* FALL THRU */
-	/* Read last kernel messages */
-	case SYSLOG_ACTION_READ_ALL:
-		error = -EINVAL;
-		if (!buf || len < 0)
-			goto out;
-		error = 0;
-		if (!len)
-			goto out;
-		if (!access_ok(VERIFY_WRITE, buf, len)) {
-			error = -EFAULT;
-			goto out;
-		}
-		count = len;
-		if (count > log_buf_len)
-			count = log_buf_len;
-		raw_spin_lock_irq(&logbuf_lock);
-		if (count > logged_chars)
-			count = logged_chars;
-		if (do_clear)
-			logged_chars = 0;
-		limit = log_end;
-		/*
-		 * __put_user() could sleep, and while we sleep
-		 * printk() could overwrite the messages
-		 * we try to copy to user space. Therefore
-		 * the messages are copied in reverse. <manfreds>
-		 */
-		for (i = 0; i < count && !error; i++) {
-			j = limit-1-i;
-			if (j + log_buf_len < log_end)
-				break;
-			c = LOG_BUF(j);
-			raw_spin_unlock_irq(&logbuf_lock);
-			error = __put_user(c,&buf[count-1-i]);
-			cond_resched();
-			raw_spin_lock_irq(&logbuf_lock);
-		}
-		raw_spin_unlock_irq(&logbuf_lock);
-		if (error)
-			break;
-		error = i;
-		if (i != count) {
-			int offset = count-error;
-			/* buffer overflow during copy, correct user buffer. */
-			for (i = 0; i < error; i++) {
-				if (__get_user(c,&buf[i+offset]) ||
-				    __put_user(c,&buf[i])) {
-					error = -EFAULT;
-					break;
-				}
-				cond_resched();
-			}
-		}
-		break;
-	/* Clear ring buffer */
-	case SYSLOG_ACTION_CLEAR:
-		logged_chars = 0;
+	case SYSLOG_ACTION_READ_CLEAR:	/* Read/clear last kernel messages */
+	case SYSLOG_ACTION_READ_ALL:	/* Read last kernel messages */
+	case SYSLOG_ACTION_CLEAR:	/* Clear ring buffer */
+	case SYSLOG_ACTION_SIZE_UNREAD:	/* Number of chars in the log buffer */
+	case SYSLOG_ACTION_SIZE_BUFFER:	/* Size of the log buffer */
+		error = log_buf_do_syslog(type, buf, len, from_file);
 		break;
+
 	/* Disable logging to console */
 	case SYSLOG_ACTION_CONSOLE_OFF:
 		if (saved_console_loglevel == -1)
@@ -468,14 +267,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		saved_console_loglevel = -1;
 		error = 0;
 		break;
-	/* Number of chars in the log buffer */
-	case SYSLOG_ACTION_SIZE_UNREAD:
-		error = log_end - log_start;
-		break;
-	/* Size of the log buffer */
-	case SYSLOG_ACTION_SIZE_BUFFER:
-		error = log_buf_len;
-		break;
 	default:
 		error = -EINVAL;
 		break;
@@ -664,40 +455,6 @@ static void call_console_drivers(unsigned start, unsigned end)
 	_call_console_drivers(start_print, end, msg_level);
 }
 
-static void emit_log_char(char c)
-{
-	LOG_BUF(log_end) = c;
-	log_end++;
-	if (log_end - log_start > log_buf_len)
-		log_start = log_end - log_buf_len;
-	if (log_end - con_start > log_buf_len)
-		con_start = log_end - log_buf_len;
-	if (logged_chars < log_buf_len)
-		logged_chars++;
-}
-
-/*
- * Zap console related locks when oopsing. Only zap at most once
- * every 10 seconds, to leave time for slow consoles to print a
- * full oops.
- */
-static void zap_locks(void)
-{
-	static unsigned long oops_timestamp;
-
-	if (time_after_eq(jiffies, oops_timestamp) &&
-			!time_after(jiffies, oops_timestamp + 30 * HZ))
-		return;
-
-	oops_timestamp = jiffies;
-
-	debug_locks_off();
-	/* If a crash is occurring, make sure we can't deadlock */
-	raw_spin_lock_init(&logbuf_lock);
-	/* And make sure that we print immediately */
-	sema_init(&console_sem, 1);
-}
-
 #if defined(CONFIG_PRINTK_TIME)
 static bool printk_time = 1;
 #else
@@ -866,7 +623,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
-		zap_locks();
+		log_buf_zap_locks();
 	}
 
 	lockdep_off();
@@ -897,7 +654,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 			plen = 0;
 		default:
 			if (!new_text_line) {
-				emit_log_char('\n');
+				log_buf_emit_char('\n');
 				new_text_line = 1;
 			}
 		}
@@ -916,13 +673,13 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				int i;
 
 				for (i = 0; i < plen; i++)
-					emit_log_char(printk_buf[i]);
+					log_buf_emit_char(printk_buf[i]);
 				printed_len += plen;
 			} else {
 				/* Add log prefix */
-				emit_log_char('<');
-				emit_log_char(current_log_level + '0');
-				emit_log_char('>');
+				log_buf_emit_char('<');
+				log_buf_emit_char(current_log_level + '0');
+				log_buf_emit_char('>');
 				printed_len += 3;
 			}
 
@@ -940,7 +697,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 						nanosec_rem / 1000);
 
 				for (tp = tbuf; tp < tbuf + tlen; tp++)
-					emit_log_char(*tp);
+					log_buf_emit_char(*tp);
 				printed_len += tlen;
 			}
 
@@ -948,7 +705,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				break;
 		}
 
-		emit_log_char(*p);
+		log_buf_emit_char(*p);
 		if (*p == '\n')
 			new_text_line = 1;
 	}
-- 
1.7.8.111.gad25c.dirty

