Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab1CMCUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 21:20:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46502 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab1CMCUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 21:20:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LVfJU8RqlIpZMt8/QXXmE2slBLBnREEZed52EDlCG6gyTZZ2hDoFbVKKOFPovWG1x8
         VwEfkqT6IwwdTyysO8dB21irX0j2/TTnHkS6oq1vb+Eb60iWn2C4biGuYFvFHU6o6yYZ
         i9FIS7YXX2MOVy1G/qtE9iRniJD4eC1W9NynY=
Subject: [PATCH] printk: do not mangle valid userspace syslog prefixes
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 13 Mar 2011 03:19:51 +0100
Message-ID: <1299982791.9769.14.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

printk: do not mangle valid userspace syslog prefixes with /dev/kmsg

Log messages passed to the kernel log by using /dev/kmsg or /dev/ttyprintk
might contain a syslog prefix including the syslog facility value.

This makes printk to recognize these headers properly, extract the real log
level from it to use, and add the prefix as a proper prefix to the
log buffer, instead of wrongly printing it as the log message text.

Before:
  $ echo '<14>text' > /dev/kmsg
  $ dmesg -r
  <4>[135159.594810] <14>text

After:
  $ echo '<14>text' > /dev/kmsg
  $ dmesg -r
  <14>[   50.750654] text

Cc: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 printk.c |  138 +++++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 104 insertions(+), 34 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3623152..33284ad 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -515,6 +515,71 @@ static void _call_console_drivers(unsigned start,
 }
 
 /*
+ * Parse the syslog header <[0-9]*>. The decimal value represents 32bit, the
+ * lower 3 bit are the log level, the rest are the log facility. In case
+ * userspace passes usual userspace syslog messages to /dev/kmsg or
+ * /dev/ttyprintk, the log prefix might contain the facility. Printk needs
+ * to extract the correct log level for in-kernel processing, and not mangle
+ * the original value.
+ *
+ * If a prefix is found, the length of the prefix is returned. If 'level' is
+ * passed, it will be filled in with the log level without a possible facility
+ * value. If 'special' is passed, the special printk prefix chars are accepted
+ * and returned. If no valid header is found, 0 is returned and the passed
+ * variables are not touched.
+ */
+static size_t log_prefix(const char *p, unsigned int *level, char *special)
+{
+	unsigned int lev = 0;
+	char sp = '\0';
+	size_t len;
+
+	if (p[0] != '<' || !p[1])
+		return 0;
+	if (p[2] == '>') {
+		/* usual single digit level number or special char */
+		switch (p[1]) {
+		case '0' ... '7':
+			lev = p[1] - '0';
+			break;
+		case 'c': /* KERN_CONT */
+		case 'd': /* KERN_DEFAULT */
+			sp = p[1];
+			break;
+		default:
+			return 0;
+		}
+		len = 3;
+	} else {
+		/* multi digit including the level and facility number */
+		char *endp = NULL;
+
+		if (p[1] < '0' && p[1] > '9')
+			return 0;
+
+		lev = (simple_strtoul(&p[1], &endp, 10) & 7);
+		if (endp == NULL || endp[0] != '>')
+			return 0;
+		len = (endp + 1) - p;
+	}
+
+	/* do not accept special char if not asked for */
+	if (sp && !special)
+		return 0;
+
+	if (special) {
+		*special = sp;
+		/* return special char, do not touch level */
+		if (sp)
+			return len;
+	}
+
+	if (level)
+		*level = lev;
+	return len;
+}
+
+/*
  * Call the console drivers, asking them to write out
  * log_buf[start] to log_buf[end - 1].
  * The console_lock must be held.
@@ -529,13 +594,9 @@ static void call_console_drivers(unsigned start, unsigned end)
 	cur_index = start;
 	start_print = start;
 	while (cur_index != end) {
-		if (msg_level < 0 && ((end - cur_index) > 2) &&
-				LOG_BUF(cur_index + 0) == '<' &&
-				LOG_BUF(cur_index + 1) >= '0' &&
-				LOG_BUF(cur_index + 1) <= '7' &&
-				LOG_BUF(cur_index + 2) == '>') {
-			msg_level = LOG_BUF(cur_index + 1) - '0';
-			cur_index += 3;
+		if (msg_level < 0 && ((end - cur_index) > 2)) {
+			/* strip log prefix */
+			cur_index += log_prefix(&LOG_BUF(cur_index), &msg_level, NULL);
 			start_print = cur_index;
 		}
 		while (cur_index != end) {
@@ -733,6 +794,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	unsigned long flags;
 	int this_cpu;
 	char *p;
+	size_t plen;
+	char special;
 
 	boot_delay_msec();
 	printk_delay();
@@ -773,45 +836,52 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	printed_len += vscnprintf(printk_buf + printed_len,
 				  sizeof(printk_buf) - printed_len, fmt, args);
 
-
 	p = printk_buf;
 
-	/* Do we have a loglevel in the string? */
-	if (p[0] == '<') {
-		unsigned char c = p[1];
-		if (c && p[2] == '>') {
-			switch (c) {
-			case '0' ... '7': /* loglevel */
-				current_log_level = c - '0';
-			/* Fallthrough - make sure we're on a new line */
-			case 'd': /* KERN_DEFAULT */
-				if (!new_text_line) {
-					emit_log_char('\n');
-					new_text_line = 1;
-				}
-			/* Fallthrough - skip the loglevel */
-			case 'c': /* KERN_CONT */
-				p += 3;
-				break;
+	/* Read log level and handle special printk prefix */
+	plen = log_prefix(p, &current_log_level, &special);
+	if (plen) {
+		p += plen;
+
+		switch (special) {
+		case 'c': /* Strip <c> KERN_CONT, continue line */
+			plen = 0;
+			break;
+		case 'd': /* Strip <d> KERN_DEFAULT, start new line */
+			plen = 0;
+		default:
+			if (!new_text_line) {
+				emit_log_char('\n');
+				new_text_line = 1;
 			}
 		}
 	}
 
 	/*
-	 * Copy the output into log_buf.  If the caller didn't provide
-	 * appropriate log level tags, we insert them here
+	 * Copy the output into log_buf. If the caller didn't provide
+	 * the appropriate log prefix, we insert them here
 	 */
-	for ( ; *p; p++) {
+	for (; *p; p++) {
 		if (new_text_line) {
-			/* Always output the token */
-			emit_log_char('<');
-			emit_log_char(current_log_level + '0');
-			emit_log_char('>');
-			printed_len += 3;
 			new_text_line = 0;
 
+			if (plen) {
+				/* Copy original log prefix */
+				int i;
+
+				for (i = 0; i < plen; i++)
+					emit_log_char(printk_buf[i]);
+				printed_len += plen;
+			} else {
+				/* Add log prefix */
+				emit_log_char('<');
+				emit_log_char(current_log_level + '0');
+				emit_log_char('>');
+				printed_len += 3;
+			}
+
 			if (printk_time) {
-				/* Follow the token with the time */
+				/* Add the current time stamp */
 				char tbuf[50], *tp;
 				unsigned tlen;
 				unsigned long long t;


