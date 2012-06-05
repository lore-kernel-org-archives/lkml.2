Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587Ab2FEJrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:47:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44789 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753536Ab2FEJq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:46:58 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Subject: [PATCH 1/8] printk: Add generic functions to find KERN_<LEVEL> headers
Date: Tue,  5 Jun 2012 02:46:30 -0700
Message-Id: <354d508293a299e53abfbd086990fe85282677d8.1338889066.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current form of a KERN_<LEVEL> is "<.>".

Add printk_get_level and printk_skip_level functions
to handle these formats.

These functions centralize tests of KERN_<LEVEL> so a future
modification can change the KERN_<LEVEL> style and shorten
the number of bytes consumed by these headers.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |   26 ++++++++++++++++++++++++++
 kernel/printk.c        |   13 ++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1bec2f7..6e12e1f 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -24,6 +24,32 @@ extern const char linux_proc_banner[];
  */
 #define KERN_CONT	"<c>"
 
+static inline int printk_get_level(const char *buffer)
+{
+	if (buffer[0] == '<' && buffer[1] && buffer[2] == '>') {
+		switch (buffer[1]) {
+		case '0' ... '7':
+		case 'd':	/* KERN_DEFAULT */
+		case 'c':	/* KERN_CONT */
+			return buffer[1];
+		}
+	}
+	return 0;
+}
+
+static inline const char *printk_skip_level(const char *buffer)
+{
+	if (printk_get_level(buffer)) {
+		switch (buffer[1]) {
+		case '0' ... '7':
+		case 'd':	/* KERN_DEFAULT */
+		case 'c':	/* KERN_CONT */
+			return buffer + 3;
+		}
+	}
+	return buffer;
+}
+
 extern int console_printk[];
 
 #define console_loglevel (console_printk[0])
diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..7cce9c5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1267,6 +1267,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	static char cont_buf[LOG_LINE_MAX];
 	static size_t cont_len;
 	static int cont_level;
+	int kern_level;
 	static struct task_struct *cont_task;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
@@ -1329,17 +1330,19 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	/* strip syslog prefix and extract log level or control flags */
-	if (text[0] == '<' && text[1] && text[2] == '>') {
-		switch (text[1]) {
+	kern_level = printk_get_level(text);
+	if (kern_level) {
+		const char *end_of_header = printk_skip_level(text);
+		switch (kern_level) {
 		case '0' ... '7':
 			if (level == -1)
-				level = text[1] - '0';
+				level = kern_level - '0';
 		case 'd':	/* KERN_DEFAULT */
 			prefix = true;
 		case 'c':	/* KERN_CONT */
-			text += 3;
-			text_len -= 3;
 		}
+		text_len -=  end_of_header - text;
+		text = end_of_header;
 	}
 
 	if (level == -1)
-- 
1.7.8.111.gad25c.dirty

