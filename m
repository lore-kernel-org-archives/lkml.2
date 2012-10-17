Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2JQGJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:09:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43788 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756233Ab2JQGJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:09:51 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 20/23] printk: Prefix print_time and msg_print_text with printk_
Date: Tue, 16 Oct 2012 23:06:24 -0700
Message-Id: <2ee7da4c3393c1e3e7facd5c14dbc5b657932e2c.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make these static functions global and prefix them with printk_.
Create declarations for these functions in printk_log.h

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c     |   43 ++++++++++++++++++++++++-------------------
 kernel/printk/printk_log.h |    4 ++++
 2 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 875e0dc..cd0d317 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -318,7 +318,7 @@ static bool printk_time;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
-static size_t print_time(u64 ts, char *buf)
+size_t printk_print_time(u64 ts, char *buf)
 {
 	unsigned long rem_nsec;
 
@@ -352,11 +352,11 @@ static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
 		}
 	}
 
-	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
+	len += printk_print_time(msg->ts_nsec, buf ? buf + len : NULL);
 	return len;
 }
 
-static size_t msg_print_text(const struct printk_log *msg,
+size_t printk_msg_print_text(const struct printk_log *msg,
 			     enum printk_log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
@@ -445,8 +445,8 @@ static int syslog_print(char __user *buf, int size)
 
 		skip = syslog_partial;
 		msg = printk_log_from_idx(syslog_idx);
-		n = msg_print_text(msg, syslog_prev, true, text,
-				   PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
+		n = printk_msg_print_text(msg, syslog_prev, true, text,
+					  PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = printk_log_next(syslog_idx);
@@ -512,7 +512,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		while (seq < printk_log_next_seq) {
 			struct printk_log *msg = printk_log_from_idx(idx);
 
-			len += msg_print_text(msg, prev, true, NULL, 0);
+			len += printk_msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
 			idx = printk_log_next(idx);
 			seq++;
@@ -525,7 +525,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		while (len > size && seq < printk_log_next_seq) {
 			struct printk_log *msg = printk_log_from_idx(idx);
 
-			len -= msg_print_text(msg, prev, true, NULL, 0);
+			len -= printk_msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
 			idx = printk_log_next(idx);
 			seq++;
@@ -540,8 +540,8 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			struct printk_log *msg = printk_log_from_idx(idx);
 			int textlen;
 
-			textlen = msg_print_text(msg, prev, true, text,
-						 PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
+			textlen = printk_msg_print_text(msg, prev, true, text,
+							PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
 			if (textlen < 0) {
 				len = textlen;
 				break;
@@ -685,7 +685,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			while (seq < printk_log_next_seq) {
 				struct printk_log *msg = printk_log_from_idx(idx);
 
-				error += msg_print_text(msg, prev, true, NULL, 0);
+				error += printk_msg_print_text(msg, prev, true, NULL, 0);
 				idx = printk_log_next(idx);
 				seq++;
 				prev = msg->flags;
@@ -936,7 +936,7 @@ static size_t cont_print_text(char *text, size_t size)
 	size_t len;
 
 	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
-		textlen += print_time(cont.ts_nsec, text);
+		textlen += printk_print_time(cont.ts_nsec, text);
 		size -= textlen;
 	}
 
@@ -1186,9 +1186,14 @@ static struct cont {
 struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
 u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct printk_log *msg,
+size_t printk_print_time(u64 ts, char *buf) { return 0; }
+size_t printk_msg_print_text(const struct printk_log *msg,
 			     enum printk_log_flags prev,
-			     bool syslog, char *buf, size_t size) { return 0; }
+			     bool syslog, char *buf, size_t size)
+{
+	return 0;
+}
+
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
 #endif /* CONFIG_PRINTK */
@@ -1549,8 +1554,8 @@ skip:
 		}
 
 		level = msg->level;
-		len = msg_print_text(msg, console_prev, false,
-				     text, sizeof(text));
+		len = printk_msg_print_text(msg, console_prev, false,
+					    text, sizeof(text));
 		console_idx = printk_log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
@@ -2104,7 +2109,7 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 		goto out;
 
 	msg = printk_log_from_idx(dumper->cur_idx);
-	l = msg_print_text(msg, 0, syslog, line, size);
+	l = printk_msg_print_text(msg, 0, syslog, line, size);
 
 	dumper->cur_idx = printk_log_next(dumper->cur_idx);
 	dumper->cur_seq++;
@@ -2200,7 +2205,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = printk_log_from_idx(idx);
 
-		l += msg_print_text(msg, prev, true, NULL, 0);
+		l += printk_msg_print_text(msg, prev, true, NULL, 0);
 		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
@@ -2213,7 +2218,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	while (l > size && seq < dumper->next_seq) {
 		struct printk_log *msg = printk_log_from_idx(idx);
 
-		l -= msg_print_text(msg, prev, true, NULL, 0);
+		l -= printk_msg_print_text(msg, prev, true, NULL, 0);
 		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
@@ -2228,7 +2233,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = printk_log_from_idx(idx);
 
-		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
+		l += printk_msg_print_text(msg, prev, syslog, buf + l, size - l);
 		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
diff --git a/kernel/printk/printk_log.h b/kernel/printk/printk_log.h
index a7125d5..6075297 100644
--- a/kernel/printk/printk_log.h
+++ b/kernel/printk/printk_log.h
@@ -115,5 +115,9 @@ void printk_log_store(int facility, int level,
 		      enum printk_log_flags flags, u64 ts_nsec,
 		      const char *dict, u16 dict_len,
 		      const char *text, u16 text_len);
+size_t printk_print_time(u64 ts, char *buf);
+size_t printk_msg_print_text(const struct printk_log *msg,
+			     enum printk_log_flags prev,
+			     bool syslog, char *buf, size_t size);
 
 #endif
-- 
1.7.10.4

