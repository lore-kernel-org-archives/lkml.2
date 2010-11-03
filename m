Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0KCX3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:29:05 -0400
Received: from mail.perches.com ([173.55.12.10]:3983 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0KCX3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:29:03 -0400
Subject: [PATCH] CONFIG_EMBEDDED and !CONFIG_PRINTK: remove WARN_ON and
 print_symbol strings
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-arch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 16:29:01 -0700
Message-ID: <1288826941.10236.65.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces text a bit.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-generic/bug.h |   11 +++++++++++
 include/linux/kallsyms.h  |    4 ++++
 kernel/panic.c            |    6 ++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index c2c9ba0..0741436 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -61,12 +61,23 @@ struct bug_entry {
  */
 #ifndef __WARN_TAINT
 #ifndef __ASSEMBLY__
+
+#ifdef CONFIG_PRINTK
 extern void warn_slowpath_fmt(const char *file, const int line,
 		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 extern void warn_slowpath_fmt_taint(const char *file, const int line,
 				    unsigned taint, const char *fmt, ...)
 	__attribute__((format(printf, 4, 5)));
 extern void warn_slowpath_null(const char *file, const int line);
+#else
+static inline void __attribute__((format(printf, 3, 4)))
+warn_slowpath_fmt(const char *file, const int line, const char *fmt, ...) {}
+static inline void __attribute__((format(printf, 4, 5)))
+warn_slowpath_fmt_taint(const char *file, const int line,
+			unsigned taint, const char *fmt, ...) {}
+static inline void warn_slowpath_null(const char *file, const int line) {}
+#endif
+
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index d8e9b3d..2e7e1e9 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -100,12 +100,16 @@ static inline void __check_printsym_format(const char *fmt, ...)
 {
 }
 
+#ifdef CONFIG_PRINTK
 static inline void print_symbol(const char *fmt, unsigned long addr)
 {
 	__check_printsym_format(fmt, "");
 	__print_symbol(fmt, (unsigned long)
 		       __builtin_extract_return_addr((void *)addr));
 }
+#else
+static inline void print_symbol(const char *fmt, unsigned long addr) {}
+#endif
 
 static inline void print_ip_sym(unsigned long ip)
 {
diff --git a/kernel/panic.c b/kernel/panic.c
index 4c13b1a..14d7539 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -357,6 +357,9 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
+
+#ifdef CONFIG_PRINTK
+
 struct slowpath_args {
 	const char *fmt;
 	va_list args;
@@ -413,6 +416,9 @@ void warn_slowpath_null(const char *file, int line)
 			     TAINT_WARN, NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
+
+#endif
+
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR


