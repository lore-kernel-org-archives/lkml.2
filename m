Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946365Ab2LFRLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:11:17 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65497 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946351Ab2LFRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:11:09 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 12/14] printk: encode formatting in message flags
Date: Thu,  6 Dec 2012 18:06:09 +0100
Message-Id: <1354813571-11253-13-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the formatting code has to look at the previously printed
message in order to determine the correct layout of the current message.
This is rather tedious. But now, that we centrally track information
about the previous message in log_store(), we can encode the necessary
information to correctly format a message within the current message
flags.

The flags have the following meaning during formatting:

LOG_NOCONT:  Print a newline before the prefix.
LOG_PREFIX:  Print a prefix before the message.
LOG_NEWLINE: Print a newline after the message.

We do not always know in time, whether we should store a message with a
newline at the end or not. However, a missing newline is addressed by a
LOG_NOCONT stored with the next message.

Thus, when logged messages are processed in order without any skips,
we generate an nicely formatted output.

(When there are skips, e. g., the log buffer overflowed before the next
message in sequence was retrieved, the output might end up with a
missing newline and/or header or an additional newline. OTOH, the
current code just silently ignores skipped messages...)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
v2:
- refactored patches
---
 kernel/printk.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 387fc51..fb54e66 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -195,8 +195,9 @@ static int console_may_schedule;
 
 enum log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
-	LOG_NEWLINE	= 2,	/* text ended with a newline */
-	LOG_PREFIX	= 4,	/* text started with a prefix */
+	LOG_NEWLINE	= 2,	/* fragment ends with a newline */
+	LOG_PREFIX	= 4,	/* fragment starts with a prefix */
+	LOG_NOCONT	= 8,	/* previous fragment missed a newline */
 };
 
 struct log {
@@ -330,6 +331,8 @@ static void log_store(struct task_struct *owner, int facility, int level,
 	inferred_level = log_infer_level(owner, facility, -1, flags);
 	if (inferred_level == -1) {
 		flags |= LOG_PREFIX;
+		if (log_last_msg && !(log_last_msg->flags & LOG_NEWLINE))
+			flags |= LOG_NOCONT;
 		if (level == -1)
 			level = default_message_loglevel;
 	} else {
@@ -510,10 +513,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	 * better readable output. 'c' in the record flags mark the first
 	 * fragment of a line, '+' the following.
 	 */
-	if (!(msg->flags & LOG_NEWLINE) && msg->flags & LOG_PREFIX)
-		cont = 'c';
-	else if (!(user->prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
+	if (!(msg->flags & LOG_PREFIX))
 		cont = '+';
+	else if (!(msg->flags & LOG_NEWLINE))
+		cont = 'c';
 
 	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
 		      (msg->facility << 3) | msg->level,
@@ -912,23 +915,17 @@ static size_t print_text(const char *text, size_t text_size, size_t *offset,
 			 u8 facility, u8 level, u64 ts_nsec, bool syslog,
 			 char *buf, size_t size)
 {
-	bool prefix = true;
-	bool newline = true;
+	bool prefix = flags & LOG_PREFIX;
+	bool newline = flags & LOG_NEWLINE;
 	size_t len = 0;
 	size_t prefix_len = 0;
 
-	if (!(prev & LOG_NEWLINE) && !(flags & LOG_PREFIX))
-		prefix = false;
-
-	if (!(flags & LOG_NEWLINE))
-		newline = false;
-
 	if (offset) {
 		text += *offset;
 		text_size -= *offset;
 	}
 
-	if (!(prev & LOG_NEWLINE) && prefix) {
+	if (flags & LOG_NOCONT) {
 		if (buf)
 			buf[len] = '\n';
 		len++;
@@ -1535,6 +1532,12 @@ static size_t cont_print_text(char *text, size_t size)
 				 cont.flags) == -1)
 		flags |= LOG_PREFIX;
 
+	/* Translate flags for printing */
+	if (console_printed_flags & LOG_NEWLINE)
+		flags |= LOG_PREFIX;
+	else if (flags & LOG_PREFIX)
+		flags |= LOG_NOCONT;
+
 	textlen = print_text(cont.buf, cont.len, &cont.cons, flags,
 			     console_printed_flags, cont.facility, cont.level,
 			     cont.ts_nsec, false, text, size);
@@ -2160,8 +2163,13 @@ skip:
 		 * another logged message), then force a break in the output.
 		 */
 		if (console_printed_seq == 0 ||
-		    console_printed_seq + 1 != console_seq)
+		    console_printed_seq + 1 != console_seq) {
 			msg->flags |= LOG_PREFIX;
+			if (console_printed_flags & LOG_NEWLINE)
+				msg->flags &= ~LOG_NOCONT;
+			else
+				msg->flags |= LOG_NOCONT;
+		}
 
 		level = msg->level;
 		len = msg_print_text(msg, console_printed_flags, false,
-- 
1.8.0.1.20.g7c65b2e.dirty

