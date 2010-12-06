Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0LFWGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:06:52 -0500
Received: from mail.perches.com ([173.55.12.10]:2333 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab0LFWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/29] kernel/panic.c: Update warn_slowpath to use %pV
Date: Mon,  6 Dec 2010 14:05:13 -0800
Message-Id: <345027d59c242352e7f9dcc319f3a97a21b9dfbe.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace struct slowpath_args with struct va_format.
Add KERN_WARNING to output.
Remove space after pointer in panic declaration.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/panic.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 4c13b1a..8943c8f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -56,7 +56,7 @@ EXPORT_SYMBOL(panic_blink);
  *
  *	This function never returns.
  */
-NORET_TYPE void panic(const char * fmt, ...)
+NORET_TYPE void panic(const char *fmt, ...)
 {
 	static char buf[1024];
 	va_list args;
@@ -357,13 +357,9 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-struct slowpath_args {
-	const char *fmt;
-	va_list args;
-};
 
 static void warn_slowpath_common(const char *file, int line, void *caller,
-				 unsigned taint, struct slowpath_args *args)
+				 unsigned taint, struct va_format *vaf)
 {
 	const char *board;
 
@@ -372,10 +368,8 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 	board = dmi_get_system_info(DMI_PRODUCT_NAME);
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
-
-	if (args)
-		vprintk(args->fmt, args->args);
-
+	if (vaf)
+		printk(KERN_WARNING "%pV", vaf);
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
@@ -384,26 +378,28 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 
 void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
 {
-	struct slowpath_args args;
-
-	args.fmt = fmt;
-	va_start(args.args, fmt);
+	struct va_format vaf;
+	va_list va;
+	va_start(va, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &va;
 	warn_slowpath_common(file, line, __builtin_return_address(0),
-			     TAINT_WARN, &args);
-	va_end(args.args);
+			     TAINT_WARN, &vaf);
+	va_end(va);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
 
 void warn_slowpath_fmt_taint(const char *file, int line,
 			     unsigned taint, const char *fmt, ...)
 {
-	struct slowpath_args args;
-
-	args.fmt = fmt;
-	va_start(args.args, fmt);
+	struct va_format vaf;
+	va_list va;
+	va_start(va, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &va;
 	warn_slowpath_common(file, line, __builtin_return_address(0),
-			     taint, &args);
-	va_end(args.args);
+			     taint, &vaf);
+	va_end(va);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt_taint);
 
-- 
1.7.3.2.245.g03276.dirty

