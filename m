Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2KMXRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:17:46 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63752 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2KMXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:17:45 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 07/12] printk: let cont_print_text() reuse existing code
Date: Wed, 14 Nov 2012 00:13:04 +0100
Message-Id: <1352848389-23114-8-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functionality of cont_print_text() also exists within
msg_print_text(). The only difference is that cont_print_text()
currently fails to print timestamps for multi-line strings from the
second line on.

In order to be able to use msg_print_text() from cont_print_text(),
create a more general version msg_print_text_from() with the ability to
start at a specific position within the message and to track the
position.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/printk.c | 54 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 988a8f5..7a961d4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -876,8 +876,9 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 	return len;
 }
 
-static size_t msg_print_text(const struct log *msg, enum log_flags prev,
-			     bool syslog, char *buf, size_t size)
+static size_t msg_print_text_from(const struct log *msg, size_t *from,
+				  enum log_flags prev,
+				  bool syslog, char *buf, size_t size)
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
@@ -891,6 +892,13 @@ static size_t msg_print_text(const struct log *msg, enum log_flags prev,
 	if (!(msg->flags & LOG_NEWLINE))
 		newline = false;
 
+	if (from) {
+		text += *from;
+		text_size -= *from;
+		if (*from)
+			prefix = false;
+	}
+
 	if (!(prev & LOG_NEWLINE) && prefix) {
 		if (buf)
 			buf[len] = '\n';
@@ -933,9 +941,23 @@ static size_t msg_print_text(const struct log *msg, enum log_flags prev,
 		text = next;
 	} while (text);
 
+	if (from) {
+		if (text)
+			*from = text - log_text(msg);
+		else
+			*from = msg->text_len;
+	}
+
 	return len;
 }
 
+static size_t msg_print_text(const struct log *msg,
+			     enum log_flags prev,
+			     bool syslog, char *buf, size_t size)
+{
+	return msg_print_text_from(msg, NULL, prev, syslog, buf, size);
+}
+
 static int syslog_print(char __user *buf, int size)
 {
 	char *text;
@@ -1452,32 +1474,12 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 
 static size_t cont_print_text(char *text, size_t size)
 {
-	size_t textlen = 0;
-	size_t len;
+	size_t textlen = msg_print_text_from(&cont.msg, &cont.cons,
+					     console_prev, false, text, size);
 
-	if (cont.cons == 0 && (console_prev & LOG_NEWLINE ||
-			       cont.msg.flags & LOG_PREFIX)) {
-		if (!(console_prev & LOG_NEWLINE))
-			text[textlen++] = '\n';
-		textlen += print_time(cont.msg.ts_nsec, text + textlen);
-		size -= textlen;
-	}
-
-	len = cont.msg.text_len - cont.cons;
-	if (len > 0) {
-		if (len+1 > size)
-			len = size-1;
-		memcpy(text + textlen, cont.buf + cont.cons, len);
-		textlen += len;
-		cont.cons = cont.msg.text_len;
-	}
-
-	if (cont.flushed) {
-		if (cont.msg.flags & LOG_NEWLINE)
-			text[textlen++] = '\n';
-		/* got everything, release buffer */
+	if (cont.flushed)
 		cont.msg.text_len = 0;
-	}
+
 	return textlen;
 }
 
-- 
1.8.0.316.g291341c.dirty

