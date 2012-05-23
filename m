Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745Ab2EWBeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:34:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58997 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757913Ab2EWBeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:34:18 -0400
Message-ID: <1337736854.13111.13.camel@joe2Laptop>
Subject: [PATCH] kernel: Shrink embedded kernel, remove WARN strings when
 !CONFIG_PRINTK
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linux-embedded@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-arm-kernel@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 22 May 2012 18:34:14 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN strings are currently always saved in text.
When printk is not enabled, this wastes space.

Don't call or compile slowpath_warn_<foo> when !CONFIG_PRINTK.

This makes an embedded image without printk support ~1% smaller.

x86-32 allnoconfig/embedded:

$ size vmlinux.new vmlinux.old
   text	   data	    bss	    dec	    hex	filename
1180807	 182720	1269372	2632899	 282cc3	vmlinux.new
1198760	 182720	1267948	2649428	 286d54	vmlinux.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-generic/bug.h |   18 +++++++++++++++++-
 kernel/panic.c            |    3 +++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 2520a6e..a16101a 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -59,7 +59,8 @@ struct bug_entry {
  * appear at runtime.  Use the versions with printk format strings
  * to provide better diagnostics.
  */
-#ifndef __WARN_TAINT
+#if !defined(__WARN_TAINT)
+
 #ifndef __ASSEMBLY__
 extern __printf(3, 4)
 void warn_slowpath_fmt(const char *file, const int line,
@@ -70,15 +71,30 @@ void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #endif
+
+#ifdef CONFIG_PRINTK
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
 #define __WARN_printf_taint(taint, arg...)				\
 	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
 #else
+#define __WARN()		do {} while (0)
+#define __WARN_printf(fmt, ...)			\
+do {						\
+	if (0)					\
+		printk(fmt, ##__VA_ARGS__);	\
+} while (0)
+#define __WARN_printf_taint(taint, fmt, ...)	\
+	__WARN_printf(fmt, ##__VA_ARGS__)
+#endif
+
+#else
+
 #define __WARN()		__WARN_TAINT(TAINT_WARN)
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
 #define __WARN_printf_taint(taint, arg...)				\
 	do { printk(arg); __WARN_TAINT(taint); } while (0)
+
 #endif
 
 #ifndef WARN_ON
diff --git a/kernel/panic.c b/kernel/panic.c
index 8ed89a1..bc57785 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -396,6 +396,7 @@ struct slowpath_args {
 	va_list args;
 };
 
+#ifdef CONFIG_PRINTK
 static void warn_slowpath_common(const char *file, int line, void *caller,
 				 unsigned taint, struct slowpath_args *args)
 {
@@ -449,6 +450,8 @@ void warn_slowpath_null(const char *file, int line)
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
 
+#endif
+
 #ifdef CONFIG_CC_STACKPROTECTOR
 
 /*


