Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2EXWtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:49:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53881 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754411Ab2EXWtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:49:45 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 1/3] printk: Use a non-printable ASCII KERN_<LEVEL> initiator
Date: Thu, 24 May 2012 15:49:31 -0700
Message-Id: <f176ab0dac8b64c9e953e4f938315bfc13445e56.1337899274.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1337899274.git.joe@perches.com>
References: <cover.1337899274.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk uses <.> to denote the message level.
There are thousands of messages in default kernel.

Use ASCII SOH (hex: 01) with no terminator
to save 1 byte per message.

This also means that KERN_CONT could be completely
removed (#defined to "") as it is no longer serves
any real purpose.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |   23 +++++++++++++----------
 kernel/printk.c        |    6 +++---
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1bec2f7..ad76855 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -6,23 +6,26 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-#define KERN_EMERG	"<0>"	/* system is unusable			*/
-#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define KERN_CRIT	"<2>"	/* critical conditions			*/
-#define KERN_ERR	"<3>"	/* error conditions			*/
-#define KERN_WARNING	"<4>"	/* warning conditions			*/
-#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define KERN_INFO	"<6>"	/* informational			*/
-#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
+#define KERN_SOH	"\001"		/* ASCII Start Of Header */
+#define KERN_SOH_ASCII	'\001'
+
+#define KERN_EMERG	KERN_SOH "0"	/* system is unusable */
+#define KERN_ALERT	KERN_SOH "1"	/* action must be taken immediately */
+#define KERN_CRIT	KERN_SOH "2"	/* critical conditions */
+#define KERN_ERR	KERN_SOH "3"	/* error conditions */
+#define KERN_WARNING	KERN_SOH "4"	/* warning conditions */
+#define KERN_NOTICE	KERN_SOH "5"	/* normal but significant condition */
+#define KERN_INFO	KERN_SOH "6"	/* informational */
+#define KERN_DEBUG	KERN_SOH "7"	/* debug-level messages */
 
 /* Use the default kernel loglevel */
-#define KERN_DEFAULT	"<d>"
+#define KERN_DEFAULT	KERN_SOH "d"
 /*
  * Annotation for a "continued" line of log printout (only done after a
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define KERN_CONT	"<c>"
+#define KERN_CONT	KERN_SOH "c"
 
 extern int console_printk[];
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..e96e733 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1329,7 +1329,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	/* strip syslog prefix and extract log level or control flags */
-	if (text[0] == '<' && text[1] && text[2] == '>') {
+	if (text[0] == KERN_SOH_ASCII && text[1]) {
 		switch (text[1]) {
 		case '0' ... '7':
 			if (level == -1)
@@ -1337,8 +1337,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		case 'd':	/* KERN_DEFAULT */
 			prefix = true;
 		case 'c':	/* KERN_CONT */
-			text += 3;
-			text_len -= 3;
+			text += 2;
+			text_len -= 2;
 		}
 	}
 
-- 
1.7.8.111.gad25c.dirty

