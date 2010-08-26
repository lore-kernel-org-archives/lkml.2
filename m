Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab0HZA16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:27:58 -0400
Received: from mail.perches.com ([173.55.12.10]:1339 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0HZA14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:27:56 -0400
Subject: [RFC patch 2.6.37+] printk: Remove KBUILD_MODNAME ":" from module
 strings
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 17:27:54 -0700
Message-ID: <1282782474.1839.25.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible for modules that use

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

and pr_<level> to reduce image the format string
and use pr_<level> functions to emit the
module name.

This could reduce total image size by about 200KB.

Of course in a 800MB+ image, 200KB is pretty small.

The general idea is to verify any pr_fmt(prefix)
is KBUILD_MODNAME, have the compiler remove it from
the format, then have pr_<level> functions emit it
using the module name derived from the _RET_IP_
of the caller.

A macro does use gcc's __builtin_strcmp to call
one of 2 different printk_<level> functions, one
that adds the module name, or another that simply
uses the original format string.

The optimizer only stores the string used.

+#define define_kernel_printk_level(level, fmt, ...)			\
+do {									\
+	if (__builtin_strcmp(first_macro_arg(pr_fmt(fmt)),		\
+			     KBUILD_MODNAME ": " fmt))			\
+		level(pr_fmt(fmt), ##__VA_ARGS__);			\
+	else								\
+		level##_with_module(fmt, ##__VA_ARGS__);		\
+} while (0)

Thoughts?
---
 include/linux/kernel.h |  187 ++++++++++++++++++++++++++++++++++++++++--------
 include/linux/module.h |    6 ++
 kernel/module.c        |   17 +++++
 kernel/printk.c        |   68 +++++++++++++++++-
 4 files changed, 247 insertions(+), 31 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2b0a35e..edeb832 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -263,8 +263,45 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
+asmlinkage int printk(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
+asmlinkage int printk_emerg(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_alert(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_crit(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_err(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_warning(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_notice(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_info(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_cont(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_debug(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+
+asmlinkage int printk_emerg_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_alert_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_crit_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_err_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_warning_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_notice_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_info_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_cont_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+asmlinkage int printk_debug_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
 
 extern int __printk_ratelimit(const char *func);
 #define printk_ratelimit() __printk_ratelimit(__func__)
@@ -287,12 +324,84 @@ extern int printk_delay_msec;
 
 void log_buf_kexec_setup(void);
 #else
-static inline int vprintk(const char *s, va_list args)
+static inline int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-static inline int vprintk(const char *s, va_list args) { return 0; }
-static inline int printk(const char *s, ...)
+static inline int vprintk(const char *fmt, va_list args) { return 0; }
+static inline int printk(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int __cold printk(const char *fmt, ...) { return 0; }
+static inline int printk_emerg(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_emerg(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_alert(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_alert(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_crit(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_crit(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_err(cconst char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_err(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_warning(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_warning(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_notice(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_notice(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_info(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
-static inline int __cold printk(const char *s, ...) { return 0; }
+static inline int printk_info(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_cont(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_cont(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_debug(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_debug(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+
+static inline int printk_emerg_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_alert_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_alert_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_crit_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_crit_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_err(cconst char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_err_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_warning_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_warning_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_notice_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_notice_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_info_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_info_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_cont_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_cont_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+static inline int printk_debug_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+static inline int printk_debug_with_module(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2))) { return 0; }
+
 static inline int printk_ratelimit(void) { return 0; }
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
@@ -401,46 +510,64 @@ extern int hex_to_bin(char ch);
 #define pr_fmt(fmt) fmt
 #endif
 
-#define pr_emerg(fmt, ...) \
-        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert(fmt, ...) \
-        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit(fmt, ...) \
-        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err(fmt, ...) \
-        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
-        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define _first_macro_arg(arg1, args...) arg1
+#define first_macro_arg(arg1, args...) _first_macro_arg(arg1)
+
+#ifdef MODULE
+
+#define define_kernel_printk_level(level, fmt, ...)			\
+do {									\
+	if (__builtin_strcmp(first_macro_arg(pr_fmt(fmt)),		\
+			     KBUILD_MODNAME ": " fmt))			\
+		level(pr_fmt(fmt), ##__VA_ARGS__);			\
+	else								\
+		level##_with_module(fmt, ##__VA_ARGS__);		\
+} while (0)
+
+#else
+
+#define define_kernel_printk_level(level, fmt, ...)			\
+	level(pr_fmt(fmt), ##__VA_ARGS__)
+#endif
+
+#define pr_emerg(fmt, ...)				\
+	define_kernel_printk_level(printk_emerg, fmt, ##__VA_ARGS__)
+#define pr_alert(fmt, ...)	\
+	define_kernel_printk_level(printk_alert, fmt, ##__VA_ARGS__)
+#define pr_crit(fmt, ...)	\
+	define_kernel_printk_level(printk_crit, fmt, ##__VA_ARGS__)
+#define pr_err(fmt, ...)	\
+	define_kernel_printk_level(printk_err, fmt, ##__VA_ARGS__)
+#define pr_warning(fmt, ...)	\
+	define_kernel_printk_level(printk_warning, fmt, ##__VA_ARGS__)
 #define pr_warn pr_warning
-#define pr_notice(fmt, ...) \
-        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
-        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_cont(fmt, ...) \
-	printk(KERN_CONT fmt, ##__VA_ARGS__)
+#define pr_notice(fmt, ...)	\
+	define_kernel_printk_level(printk_notice, fmt, ##__VA_ARGS__)
+#define pr_info(fmt, ...)	\
+	define_kernel_printk_level(printk_info, fmt, ##__VA_ARGS__)
+#define pr_cont(fmt, ...)	\
+	define_kernel_printk_level(printk_cont, fmt, ##__VA_ARGS__)
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
-#define pr_devel(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_devel(fmt, ...)	pr_debug(fmt, ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+	({ if (0) pr_debug(fmt, ##__VA_ARGS__); 0; })
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(DEBUG)
-#define pr_debug(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-#elif defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#elif defined(DEBUG)
+#define pr_debug(fmt, ...)	\
+	define_kernel_printk_level(printk_debug, fmt, ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+	({ if (0) printk_debug(pr_fmt(fmt), ##__VA_ARGS__); 0; })
 #endif
-
 /*
  * ratelimited messages with local ratelimit_state,
  * no local ratelimit_state used in the !PRINTK case
diff --git a/include/linux/module.h b/include/linux/module.h
index 8a6b9fd..0db93a8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -540,6 +540,8 @@ const struct exception_table_entry *search_module_extables(unsigned long addr);
 int register_module_notifier(struct notifier_block * nb);
 int unregister_module_notifier(struct notifier_block * nb);
 
+const char *get_module_name(unsigned long addr);
+
 extern void print_modules(void);
 
 extern void module_update_tracepoints(void);
@@ -657,6 +659,10 @@ static inline int unregister_module_notifier(struct notifier_block * nb)
 
 #define module_put_and_exit(code) do_exit(code)
 
+static inline const char *get_module_name(unsigned long addr)
+{
+	return "kernel";
+}
 static inline void print_modules(void)
 {
 }
diff --git a/kernel/module.c b/kernel/module.c
index d0b5f8d..9e40d6c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2926,6 +2926,23 @@ static unsigned long mod_find_symname(struct module *mod, const char *name)
 	return 0;
 }
 
+const char* get_module_name(unsigned long addr)
+{
+	struct module *mod;
+	const char *ret = NULL;
+
+	preempt_disable();
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if (within_module_init(addr, mod) ||
+		    within_module_core(addr, mod)) {
+			ret = (const char *)mod->name;
+			break;
+		}
+	}
+	preempt_enable();
+	return ret;
+}
+
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name)
 {
diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..62332d8 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
@@ -619,6 +620,72 @@ asmlinkage int printk(const char *fmt, ...)
 
 	return r;
 }
+EXPORT_SYMBOL(printk);
+
+#define define_printk_level(func, level)			\
+asmlinkage int func(const char *fmt, ...)			\
+{								\
+	struct va_format vaf;					\
+	va_list args;						\
+	int r;							\
+								\
+	va_start(args, fmt);					\
+								\
+	vaf.fmt = fmt;						\
+	vaf.va = &args;						\
+								\
+	r = printk(level "%pV", &vaf);				\
+								\
+	va_end(args);						\
+								\
+	return r;						\
+}								\
+EXPORT_SYMBOL(func);
+
+#define define_printk_level_with_module(func, level)		\
+asmlinkage int func(const char *fmt, ...)			\
+{								\
+	struct va_format vaf;					\
+	va_list args;						\
+	int r;							\
+	const char *mod_name;					\
+								\
+	va_start(args, fmt);					\
+								\
+	vaf.fmt = fmt;						\
+	vaf.va = &args;						\
+								\
+	if (__builtin_strcmp(level, KERN_CONT) &&		\
+	    (mod_name = get_module_name(_RET_IP_)))		\
+		r = printk(level "%s: %pV", mod_name, &vaf);	\
+	else							\
+		r = printk(level "%pV", &vaf);			\
+								\
+	va_end(args);						\
+								\
+	return r;						\
+}								\
+EXPORT_SYMBOL(func);
+
+define_printk_level(printk_emerg, KERN_EMERG);
+define_printk_level(printk_alert, KERN_ALERT);
+define_printk_level(printk_crit, KERN_CRIT);
+define_printk_level(printk_err, KERN_ERR);
+define_printk_level(printk_warning, KERN_WARNING);
+define_printk_level(printk_notice, KERN_NOTICE);
+define_printk_level(printk_info, KERN_INFO);
+define_printk_level(printk_cont, KERN_CONT);
+define_printk_level(printk_debug, KERN_DEBUG);
+
+define_printk_level_with_module(printk_emerg_with_module, KERN_EMERG);
+define_printk_level_with_module(printk_alert_with_module, KERN_ALERT);
+define_printk_level_with_module(printk_crit_with_module, KERN_CRIT);
+define_printk_level_with_module(printk_err_with_module, KERN_ERR);
+define_printk_level_with_module(printk_warning_with_module, KERN_WARNING);
+define_printk_level_with_module(printk_notice_with_module, KERN_NOTICE);
+define_printk_level_with_module(printk_info_with_module, KERN_INFO);
+define_printk_level_with_module(printk_cont_with_module, KERN_CONT);
+define_printk_level_with_module(printk_debug_with_module, KERN_DEBUG);
 
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int printk_cpu = UINT_MAX;
@@ -820,7 +887,6 @@ out_restore_irqs:
 	preempt_enable();
 	return printed_len;
 }
-EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
 
 #else


