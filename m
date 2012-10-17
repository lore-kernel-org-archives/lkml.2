Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2JQGKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:10:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40239 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756270Ab2JQGKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:10:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 21/23] printk: Move functions printk_print_time and printk_msg_print_text
Date: Tue, 16 Oct 2012 23:06:25 -0700
Message-Id: <fda2d6aa0ee7cd0fa72b91f05f747c05f0682f72.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move these functions to printk_log.
Move the static function print_prefix too.
Add "#include <linux/moduleparam.h>" to printk_log.c.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c     |  112 -------------------------------------------
 kernel/printk/printk_log.c |  114 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+), 112 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index cd0d317..343b0ce 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -311,111 +311,6 @@ static int check_syslog_permissions(int type, bool from_file)
 	return 0;
 }
 
-#if defined(CONFIG_PRINTK_TIME)
-static bool printk_time = 1;
-#else
-static bool printk_time;
-#endif
-module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
-
-size_t printk_print_time(u64 ts, char *buf)
-{
-	unsigned long rem_nsec;
-
-	if (!printk_time)
-		return 0;
-
-	if (!buf)
-		return 15;
-
-	rem_nsec = do_div(ts, 1000000000);
-	return sprintf(buf, "[%5lu.%06lu] ",
-		       (unsigned long)ts, rem_nsec / 1000);
-}
-
-static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
-{
-	size_t len = 0;
-	unsigned int prefix = (msg->facility << 3) | msg->level;
-
-	if (syslog) {
-		if (buf) {
-			len += sprintf(buf, "<%u>", prefix);
-		} else {
-			len += 3;
-			if (prefix > 999)
-				len += 3;
-			else if (prefix > 99)
-				len += 2;
-			else if (prefix > 9)
-				len++;
-		}
-	}
-
-	len += printk_print_time(msg->ts_nsec, buf ? buf + len : NULL);
-	return len;
-}
-
-size_t printk_msg_print_text(const struct printk_log *msg,
-			     enum printk_log_flags prev,
-			     bool syslog, char *buf, size_t size)
-{
-	const char *text = printk_log_text(msg);
-	size_t text_size = msg->text_len;
-	bool prefix = true;
-	bool newline = true;
-	size_t len = 0;
-
-	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
-		prefix = false;
-
-	if (msg->flags & LOG_CONT) {
-		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
-			prefix = false;
-
-		if (!(msg->flags & LOG_NEWLINE))
-			newline = false;
-	}
-
-	do {
-		const char *next = memchr(text, '\n', text_size);
-		size_t text_len;
-
-		if (next) {
-			text_len = next - text;
-			next++;
-			text_size -= next - text;
-		} else {
-			text_len = text_size;
-		}
-
-		if (buf) {
-			if (print_prefix(msg, syslog, NULL) +
-			    text_len + 1 >= size - len)
-				break;
-
-			if (prefix)
-				len += print_prefix(msg, syslog, buf + len);
-			memcpy(buf + len, text, text_len);
-			len += text_len;
-			if (next || newline)
-				buf[len++] = '\n';
-		} else {
-			/* SYSLOG_ACTION_* buffer size only calculation */
-			if (prefix)
-				len += print_prefix(msg, syslog, NULL);
-			len += text_len;
-			if (next || newline)
-				len++;
-		}
-
-		prefix = true;
-		text = next;
-	} while (text);
-
-	return len;
-}
-
 static int syslog_print(char __user *buf, int size)
 {
 	char *text;
@@ -1186,13 +1081,6 @@ static struct cont {
 struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
 u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-size_t printk_print_time(u64 ts, char *buf) { return 0; }
-size_t printk_msg_print_text(const struct printk_log *msg,
-			     enum printk_log_flags prev,
-			     bool syslog, char *buf, size_t size)
-{
-	return 0;
-}
 
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
diff --git a/kernel/printk/printk_log.c b/kernel/printk/printk_log.c
index b5c2b8f..d38129c 100644
--- a/kernel/printk/printk_log.c
+++ b/kernel/printk/printk_log.c
@@ -2,6 +2,8 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/kexec.h>
+#include <linux/moduleparam.h>
+#include <linux/stat.h>
 
 #include "printk_log.h"
 
@@ -135,6 +137,111 @@ void printk_log_store(int facility, int level,
 	printk_log_next_seq++;
 }
 
+#if defined(CONFIG_PRINTK_TIME)
+static bool printk_time = 1;
+#else
+static bool printk_time;
+#endif
+module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
+
+size_t printk_print_time(u64 ts, char *buf)
+{
+	unsigned long rem_nsec;
+
+	if (!printk_time)
+		return 0;
+
+	if (!buf)
+		return 15;
+
+	rem_nsec = do_div(ts, 1000000000);
+	return sprintf(buf, "[%5lu.%06lu] ",
+		       (unsigned long)ts, rem_nsec / 1000);
+}
+
+static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
+{
+	size_t len = 0;
+	unsigned int prefix = (msg->facility << 3) | msg->level;
+
+	if (syslog) {
+		if (buf) {
+			len += sprintf(buf, "<%u>", prefix);
+		} else {
+			len += 3;
+			if (prefix > 999)
+				len += 3;
+			else if (prefix > 99)
+				len += 2;
+			else if (prefix > 9)
+				len++;
+		}
+	}
+
+	len += printk_print_time(msg->ts_nsec, buf ? buf + len : NULL);
+	return len;
+}
+
+size_t printk_msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
+			     bool syslog, char *buf, size_t size)
+{
+	const char *text = printk_log_text(msg);
+	size_t text_size = msg->text_len;
+	bool prefix = true;
+	bool newline = true;
+	size_t len = 0;
+
+	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
+		prefix = false;
+
+	if (msg->flags & LOG_CONT) {
+		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
+			prefix = false;
+
+		if (!(msg->flags & LOG_NEWLINE))
+			newline = false;
+	}
+
+	do {
+		const char *next = memchr(text, '\n', text_size);
+		size_t text_len;
+
+		if (next) {
+			text_len = next - text;
+			next++;
+			text_size -= next - text;
+		} else {
+			text_len = text_size;
+		}
+
+		if (buf) {
+			if (print_prefix(msg, syslog, NULL) +
+			    text_len + 1 >= size - len)
+				break;
+
+			if (prefix)
+				len += print_prefix(msg, syslog, buf + len);
+			memcpy(buf + len, text, text_len);
+			len += text_len;
+			if (next || newline)
+				buf[len++] = '\n';
+		} else {
+			/* SYSLOG_ACTION_* buffer size only calculation */
+			if (prefix)
+				len += print_prefix(msg, syslog, NULL);
+			len += text_len;
+			if (next || newline)
+				len++;
+		}
+
+		prefix = true;
+		text = next;
+	} while (text);
+
+	return len;
+}
+
 #else /* CONFIG_PRINTK */
 
 #define LOG_LINE_MAX		0
@@ -145,5 +252,12 @@ u32 printk_log_first_idx;
 u64 printk_log_next_seq;
 struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
 u32 printk_log_next(u32 idx) { return 0; }
+size_t printk_print_time(u64 ts, char *buf) { return 0; }
+size_t printk_msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
+			     bool syslog, char *buf, size_t size)
+{
+	return 0;
+}
 
 #endif /* CONFIG_PRINTK */
-- 
1.7.10.4

