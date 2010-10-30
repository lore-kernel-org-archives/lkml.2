Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0J3VLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:11:51 -0400
Received: from mail.perches.com ([173.55.12.10]:3795 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab0J3VJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:46 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/39] kernel/panic.c: Update warn_slowpath to use %pV
Date: Sat, 30 Oct 2010 14:08:48 -0700
Message-Id: <a248d4218c15c48e0ae8c5b130f3c0828223b94d.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
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
1.7.3.1.g432b3.dirty

