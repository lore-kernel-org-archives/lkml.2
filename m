Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1G1FQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:16:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:51288 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1G1FQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 01/11] module.h: split out the EXPORT_SYMBOL for faster compiles
Date: Thu, 28 Jul 2011 01:16:08 -0400
Message-Id: <1311830178-30314-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of files pull in module.h when all they are really
looking for is the basic EXPORT_SYMBOL functionality. The
recent data from Ingo[1] shows that this is one of several
instances that has a significant impact on compile times,
and it should be targeted for factoring out (as done here).

Note that several commonly used header files in include/*
directly include <linux/module.h> themselves (some 34 of them!)
The most commonly used ones of these will have to be made
independent of module.h before the full benefit of this change
can be realized.

We also transition THIS_MODULE from module.h to export.h,
since there are lots of files with subsystem structs that
in turn will have a struct module *owner and only be doing:

	.owner = THIS_MODULE;

and absolutely nothing else modular. So, we also want to have
the THIS_MODULE definition present in the lightweight header.

[1] https://lkml.org/lkml/2011/5/23/76

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/export.h |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/module.h |   68 +------------------------------------
 2 files changed, 90 insertions(+), 67 deletions(-)
 create mode 100644 include/linux/export.h

diff --git a/include/linux/export.h b/include/linux/export.h
new file mode 100644
index 0000000..696c0f4
--- /dev/null
+++ b/include/linux/export.h
@@ -0,0 +1,89 @@
+#ifndef _LINUX_EXPORT_H
+#define _LINUX_EXPORT_H
+/*
+ * Export symbols from the kernel to modules.  Forked from module.h
+ * to reduce the amount of pointless cruft we feed to gcc when only
+ * exporting a simple symbol or two.
+ *
+ * If you feel the need to add #include <linux/foo.h> to this file
+ * then you are doing something wrong and should go away silently.
+ */
+
+/* Some toolchains use a `_' prefix for all user symbols. */
+#ifdef CONFIG_SYMBOL_PREFIX
+#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
+#define MODULE_SYMBOL_PREFIX ""
+#endif
+
+struct kernel_symbol
+{
+	unsigned long value;
+	const char *name;
+};
+
+#ifdef MODULE
+extern struct module __this_module;
+#define THIS_MODULE (&__this_module)
+#else
+#define THIS_MODULE ((struct module *)0)
+#endif
+
+#ifdef CONFIG_MODULES
+
+#ifndef __GENKSYMS__
+#ifdef CONFIG_MODVERSIONS
+/* Mark the CRC weak since genksyms apparently decides not to
+ * generate a checksums for some symbols */
+#define __CRC_SYMBOL(sym, sec)					\
+	extern void *__crc_##sym __attribute__((weak));		\
+	static const unsigned long __kcrctab_##sym		\
+	__used							\
+	__attribute__((section("___kcrctab" sec "+" #sym), unused))	\
+	= (unsigned long) &__crc_##sym;
+#else
+#define __CRC_SYMBOL(sym, sec)
+#endif
+
+/* For every exported symbol, place a struct in the __ksymtab section */
+#define __EXPORT_SYMBOL(sym, sec)				\
+	extern typeof(sym) sym;					\
+	__CRC_SYMBOL(sym, sec)					\
+	static const char __kstrtab_##sym[]			\
+	__attribute__((section("__ksymtab_strings"), aligned(1))) \
+	= MODULE_SYMBOL_PREFIX #sym;				\
+	static const struct kernel_symbol __ksymtab_##sym	\
+	__used							\
+	__attribute__((section("___ksymtab" sec "+" #sym), unused))	\
+	= { (unsigned long)&sym, __kstrtab_##sym }
+
+#define EXPORT_SYMBOL(sym)					\
+	__EXPORT_SYMBOL(sym, "")
+
+#define EXPORT_SYMBOL_GPL(sym)					\
+	__EXPORT_SYMBOL(sym, "_gpl")
+
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)				\
+	__EXPORT_SYMBOL(sym, "_gpl_future")
+
+#ifdef CONFIG_UNUSED_SYMBOLS
+#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
+#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl")
+#else
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
+#endif
+
+#endif	/* __GENKSYMS__ */
+
+#else /* !CONFIG_MODULES... */
+
+#define EXPORT_SYMBOL(sym)
+#define EXPORT_SYMBOL_GPL(sym)
+#define EXPORT_SYMBOL_GPL_FUTURE(sym)
+#define EXPORT_UNUSED_SYMBOL(sym)
+#define EXPORT_UNUSED_SYMBOL_GPL(sym)
+
+#endif /* CONFIG_MODULES */
+
+#endif /* _LINUX_EXPORT_H */
diff --git a/include/linux/module.h b/include/linux/module.h
index 1c30087..bbd77fa 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/tracepoint.h>
+#include <linux/export.h>
 
 #include <linux/percpu.h>
 #include <asm/module.h>
@@ -25,21 +26,8 @@
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
-/* Some toolchains use a `_' prefix for all user symbols. */
-#ifdef CONFIG_SYMBOL_PREFIX
-#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
-#else
-#define MODULE_SYMBOL_PREFIX ""
-#endif
-
 #define MODULE_NAME_LEN MAX_PARAM_PREFIX_LEN
 
-struct kernel_symbol
-{
-	unsigned long value;
-	const char *name;
-};
-
 struct modversion_info
 {
 	unsigned long crc;
@@ -98,11 +86,8 @@ void trim_init_extable(struct module *m);
 extern const struct gtype##_id __mod_##gtype##_table		\
   __attribute__ ((unused, alias(__stringify(name))))
 
-extern struct module __this_module;
-#define THIS_MODULE (&__this_module)
 #else  /* !MODULE */
 #define MODULE_GENERIC_TABLE(gtype,name)
-#define THIS_MODULE ((struct module *)0)
 #endif
 
 /* Generic info of form tag = "info" */
@@ -218,52 +203,6 @@ struct module_use {
 	struct module *source, *target;
 };
 
-#ifndef __GENKSYMS__
-#ifdef CONFIG_MODVERSIONS
-/* Mark the CRC weak since genksyms apparently decides not to
- * generate a checksums for some symbols */
-#define __CRC_SYMBOL(sym, sec)					\
-	extern void *__crc_##sym __attribute__((weak));		\
-	static const unsigned long __kcrctab_##sym		\
-	__used							\
-	__attribute__((section("___kcrctab" sec "+" #sym), unused))	\
-	= (unsigned long) &__crc_##sym;
-#else
-#define __CRC_SYMBOL(sym, sec)
-#endif
-
-/* For every exported symbol, place a struct in the __ksymtab section */
-#define __EXPORT_SYMBOL(sym, sec)				\
-	extern typeof(sym) sym;					\
-	__CRC_SYMBOL(sym, sec)					\
-	static const char __kstrtab_##sym[]			\
-	__attribute__((section("__ksymtab_strings"), aligned(1))) \
-	= MODULE_SYMBOL_PREFIX #sym;                    	\
-	static const struct kernel_symbol __ksymtab_##sym	\
-	__used							\
-	__attribute__((section("___ksymtab" sec "+" #sym), unused))	\
-	= { (unsigned long)&sym, __kstrtab_##sym }
-
-#define EXPORT_SYMBOL(sym)					\
-	__EXPORT_SYMBOL(sym, "")
-
-#define EXPORT_SYMBOL_GPL(sym)					\
-	__EXPORT_SYMBOL(sym, "_gpl")
-
-#define EXPORT_SYMBOL_GPL_FUTURE(sym)				\
-	__EXPORT_SYMBOL(sym, "_gpl_future")
-
-
-#ifdef CONFIG_UNUSED_SYMBOLS
-#define EXPORT_UNUSED_SYMBOL(sym) __EXPORT_SYMBOL(sym, "_unused")
-#define EXPORT_UNUSED_SYMBOL_GPL(sym) __EXPORT_SYMBOL(sym, "_unused_gpl")
-#else
-#define EXPORT_UNUSED_SYMBOL(sym)
-#define EXPORT_UNUSED_SYMBOL_GPL(sym)
-#endif
-
-#endif
-
 enum module_state
 {
 	MODULE_STATE_LIVE,
@@ -584,11 +523,6 @@ extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
 
 #else /* !CONFIG_MODULES... */
-#define EXPORT_SYMBOL(sym)
-#define EXPORT_SYMBOL_GPL(sym)
-#define EXPORT_SYMBOL_GPL_FUTURE(sym)
-#define EXPORT_UNUSED_SYMBOL(sym)
-#define EXPORT_UNUSED_SYMBOL_GPL(sym)
 
 /* Given an address, look for it in the exception tables. */
 static inline const struct exception_table_entry *
-- 
1.7.6

