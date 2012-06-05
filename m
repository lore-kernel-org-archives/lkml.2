Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab2FEJsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:48:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59732 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932197Ab2FEJsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:48:00 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Subject: [PATCH 7/8] printk: Convert the format for KERN_<LEVEL> to a 2 byte pattern
Date: Tue,  5 Jun 2012 02:46:36 -0700
Message-Id: <af33e630ed9281ae38f5b0e2ce15d09637ca93ab.1338889067.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of "<.>", use an ASCII SOH for the KERN_<LEVEL>
prefix initiator.

This saves 1 byte per printk, thousands of bytes in a normal kernel.

No output changes are produced as vprintk_emit converts these
uses to "<.>".

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kern_levels.h |   25 ++++++++++++++-----------
 include/linux/printk.h      |    4 ++--
 kernel/printk.c             |    3 ++-
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/kern_levels.h b/include/linux/kern_levels.h
index 337e56f..8c719a9 100644
--- a/include/linux/kern_levels.h
+++ b/include/linux/kern_levels.h
@@ -1,22 +1,25 @@
 #ifndef __KERN_LEVELS_H__
 #define __KERN_LEVELS_H__
 
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
+
+#define KERN_DEFAULT	KERN_SOH "d"	/* the default kernel loglevel */
 
-/* Use the default kernel loglevel */
-#define KERN_DEFAULT	"<d>"
 /*
  * Annotation for a "continued" line of log printout (only done after a
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define KERN_CONT	"<c>"
+#define KERN_CONT	KERN_SOH "c"
 
 #endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index fea2de3..93a231f 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -9,7 +9,7 @@ extern const char linux_proc_banner[];
 
 static inline int printk_get_level(const char *buffer)
 {
-	if (buffer[0] == '<' && buffer[1] && buffer[2] == '>') {
+	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
 		switch (buffer[1]) {
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
@@ -27,7 +27,7 @@ static inline const char *printk_skip_level(const char *buffer)
 		case '0' ... '7':
 		case 'd':	/* KERN_DEFAULT */
 		case 'c':	/* KERN_CONT */
-			return buffer + 3;
+			return buffer + 2;
 		}
 	}
 	return buffer;
diff --git a/kernel/printk.c b/kernel/printk.c
index 7cce9c5..5cd73f7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1340,9 +1340,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 		case 'd':	/* KERN_DEFAULT */
 			prefix = true;
 		case 'c':	/* KERN_CONT */
+			break;
 		}
 		text_len -=  end_of_header - text;
-		text = end_of_header;
+		text = (char *)end_of_header;
 	}
 
 	if (level == -1)
-- 
1.7.8.111.gad25c.dirty

