Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424591Ab2LFRMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:12:44 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65243 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946246Ab2LFRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:09:49 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 07/14] printk: let cont_print_text() reuse existing code
Date: Thu,  6 Dec 2012 18:06:04 +0100
Message-Id: <1354813571-11253-8-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functionality of cont_print_text() also exists within
msg_print_text(). The major difference is that cont_print_text()
currently fails to print timestamps for multi-line strings from the
second line on.

In order to be able to use msg_print_text() from cont_print_text(),
create a more general version print_text() that can also be used with
the continuation buffer and has the ability to start at a specific
position within the message and to track that position.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
v2:
- moved an already needed check from a later patch to this patch
- fixed a bug, where a single newline at the end of the buffer might get
  skipped
- realized the utilization of msg_print_text() functionality completely
  different: we now pass lots of parameters instead of restructuring
  struct cont, which results in more readable code
---
 kernel/printk.c | 82 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 36 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 4f3c355..b6c4eae 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -853,10 +853,11 @@ static size_t print_time(u64 ts, char *buf)
 		       (unsigned long)ts, rem_nsec / 1000);
 }
 
-static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
+static size_t print_prefix(u8 facility, u8 level, u64 ts_nsec, bool syslog,
+			   char *buf)
 {
 	size_t len = 0;
-	unsigned int prefix = (msg->facility << 3) | msg->level;
+	unsigned int prefix = (facility << 3) | level;
 
 	if (syslog) {
 		if (buf) {
@@ -872,25 +873,33 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 		}
 	}
 
-	len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
+	len += print_time(ts_nsec, buf ? buf + len : NULL);
 	return len;
 }
 
-static size_t msg_print_text(const struct log *msg, enum log_flags prev,
-			     bool syslog, char *buf, size_t size)
+static size_t print_text(const char *text, size_t text_size, size_t *offset,
+			 enum log_flags flags, enum log_flags prev,
+			 u8 facility, u8 level, u64 ts_nsec, bool syslog,
+			 char *buf, size_t size)
 {
-	const char *text = log_text(msg);
-	size_t text_size = msg->text_len;
 	bool prefix = true;
 	bool newline = true;
 	size_t len = 0;
+	size_t prefix_len = 0;
 
-	if (!(prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
+	if (!(prev & LOG_NEWLINE) && !(flags & LOG_PREFIX))
 		prefix = false;
 
-	if (!(msg->flags & LOG_NEWLINE))
+	if (!(flags & LOG_NEWLINE))
 		newline = false;
 
+	if (offset) {
+		text += *offset;
+		text_size -= *offset;
+		if (*offset)
+			prefix = false;
+	}
+
 	if (!(prev & LOG_NEWLINE) && prefix) {
 		if (buf)
 			buf[len] = '\n';
@@ -909,22 +918,25 @@ static size_t msg_print_text(const struct log *msg, enum log_flags prev,
 			text_len = text_size;
 		}
 
+		if (prefix && !prefix_len)
+			prefix_len = print_prefix(facility, level, ts_nsec,
+						  syslog, NULL);
 		if (buf) {
-			if (print_prefix(msg, syslog, NULL) +
-			    text_len + 1 >= size - len)
+			if (prefix_len + text_len + 1 >= size - len)
 				break;
 
 			if (prefix)
-				len += print_prefix(msg, syslog, buf + len);
+				len += print_prefix(facility, level, ts_nsec,
+						    syslog, buf + len);
 			memcpy(buf + len, text, text_len);
 			len += text_len;
+			if (offset)
+				*offset += text_len + (next ? 1 : 0);
 			if (next || newline)
 				buf[len++] = '\n';
 		} else {
 			/* SYSLOG_ACTION_* buffer size only calculation */
-			if (prefix)
-				len += print_prefix(msg, syslog, NULL);
-			len += text_len;
+			len += prefix_len + text_len;
 			if (next || newline)
 				len++;
 		}
@@ -936,6 +948,15 @@ static size_t msg_print_text(const struct log *msg, enum log_flags prev,
 	return len;
 }
 
+static size_t msg_print_text(const struct log *msg,
+			     enum log_flags prev,
+			     bool syslog, char *buf, size_t size)
+{
+	return print_text(log_text(msg), msg->text_len, NULL, msg->flags, prev,
+			  msg->facility, msg->level, msg->ts_nsec, syslog,
+			  buf, size);
+}
+
 static int syslog_print(char __user *buf, int size)
 {
 	char *text;
@@ -1458,31 +1479,20 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 static size_t cont_print_text(char *text, size_t size)
 {
 	size_t textlen = 0;
-	size_t len;
 
-	if (cont.cons == 0 && (console_prev & LOG_NEWLINE ||
-			       cont.flags & LOG_PREFIX)) {
-		if (!(console_prev & LOG_NEWLINE))
-			text[textlen++] = '\n';
-		textlen += print_time(cont.ts_nsec, text + textlen);
-		size -= textlen;
-	}
-
-	len = cont.len - cont.cons;
-	if (len > 0) {
-		if (len+1 > size)
-			len = size-1;
-		memcpy(text + textlen, cont.buf + cont.cons, len);
-		textlen += len;
-		cont.cons = cont.len;
+	if (cont.len == cont.cons) {
+		/* Not even a newline to print? */
+		if (!(cont.flags & LOG_NEWLINE))
+			goto out;
 	}
 
-	if (cont.flushed) {
-		if (cont.flags & LOG_NEWLINE)
-			text[textlen++] = '\n';
-		/* got everything, release buffer */
+	textlen = print_text(cont.buf, cont.len, &cont.cons, cont.flags,
+			     console_prev, cont.facility, cont.level,
+			     cont.ts_nsec, false, text, size);
+out:
+	if (cont.flushed)
 		cont.len = 0;
-	}
+
 	return textlen;
 }
 
-- 
1.8.0.1.20.g7c65b2e.dirty

