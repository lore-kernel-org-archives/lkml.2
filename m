Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1DERWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:22:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32969 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab1DERWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qE/EwEOG3Du0Gbi5n4X2Pr5ve6WUXH7sRSQO1BC1uaAu46UAvGTY1DoR2qqY1gjYDf
         9jPXK9A25p1Mm4suH/7aimtVSZSAGdsiJMCRuI5J4Jh7RJDmrdPiNqX/2XChgiBZOyo1
         qqjjj4VG3Tqxsf9A5cD0Y9RHN/lUR7OXJSTsI=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] module: Use the binary search for symbols resolution
Date: Tue,  5 Apr 2011 19:22:26 +0200
Message-Id: <1302024146-2608-2-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302024146-2608-1-git-send-email-abogani@kernel.org>
References: <1302024146-2608-1-git-send-email-abogani@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the linker sort the exported symbols and use the binary search for locate them.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 include/asm-generic/vmlinux.lds.h |   43 +++++++++++++++++++++------
 include/linux/module.h            |   12 ++++++-
 init/Kconfig                      |    7 ++++
 kernel/module.c                   |   57 +++++++++++++++++++++++++-----------
 scripts/module-common.lds         |   11 +++++++
 5 files changed, 100 insertions(+), 30 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index fe77e33..b438dd9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -149,6 +149,29 @@
 #define TRACE_SYSCALLS()
 #endif
 
+#ifdef CONFIG_SYMBOLS_BSEARCH
+#define KSYMTAB_SYMBOLS SORT(___ksymtab__*)
+#define KSYMTAB_GPL_SYMBOLS SORT(___ksymtab_gpl__*)
+#define KSYMTAB_UNUSED_SYMBOLS SORT(___ksymtab_unused__*)
+#define KSYMTAB_UNUSED_GPL_SYMBOLS SORT(___ksymtab_unused_gpl__*)
+#define KSYMTAB_GPL_FUTURE_SYMBOLS SORT(___ksymtab_gpl_future__*)
+#define KCRCTAB_SYMBOLS SORT(___kcrctab__*)
+#define KCRCTAB_GPL_SYMBOLS SORT(___kcrctab_gpl__*)
+#define KCRCTAB_UNUSED_SYMBOLS SORT(___kcrctab_unused__*)
+#define KCRCTAB_UNUSED_GPL_SYMBOLS SORT(___kcrctab_unused_gpl__*)
+#define KCRCTAB_GPL_FUTURE_SYMBOLS SORT(___kcrctab_gpl_future__*)
+#else
+#define KSYMTAB_SYMBOLS __ksymtab
+#define KSYMTAB_GPL_SYMBOLS __ksymtab_gpl
+#define KSYMTAB_UNUSED_SYMBOLS __ksymtab_unused
+#define KSYMTAB_UNUSED_GPL_SYMBOLS __ksymtab_unused_gpl
+#define KSYMTAB_GPL_FUTURE_SYMBOLS __ksymtab_gpl_future
+#define KCRCTAB_SYMBOLS __kcrctab
+#define KCRCTAB_GPL_SYMBOLS __kcrctab_gpl
+#define KCRCTAB_UNUSED_SYMBOLS __kcrctab_unused
+#define KCRCTAB_UNUSED_GPL_SYMBOLS __kcrctab_unused_gpl
+#define KCRCTAB_GPL_FUTURE_SYMBOLS __kcrctab_gpl_future
+#endif
 
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
@@ -274,70 +297,70 @@
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
-		*(__ksymtab)						\
+		*(KSYMTAB_SYMBOLS)					\
 		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
-		*(__ksymtab_gpl)					\
+		*(KSYMTAB_GPL_SYMBOLS)					\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
-		*(__ksymtab_unused)					\
+		*(KSYMTAB_UNUSED_SYMBOLS)				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
-		*(__ksymtab_unused_gpl)					\
+		*(KSYMTAB_UNUSED_GPL_SYMBOLS)				\
 		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
-		*(__ksymtab_gpl_future)					\
+		*(KSYMTAB_GPL_FUTURE_SYMBOLS)				\
 		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
-		*(__kcrctab)						\
+		*(KCRCTAB_SYMBOLS)					\
 		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
-		*(__kcrctab_gpl)					\
+		*(KCRCTAB_GPL_SYMBOLS)					\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
-		*(__kcrctab_unused)					\
+		*(KCRCTAB_UNUSED_SYMBOLS)				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
-		*(__kcrctab_unused_gpl)					\
+		*(KCRCTAB_UNUSED_GPL_SYMBOLS)				\
 		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
-		*(__kcrctab_gpl_future)					\
+		*(KCRCTAB_GPL_FUTURE_SYMBOLS)				\
 		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
 	}								\
 									\
diff --git a/include/linux/module.h b/include/linux/module.h
index 5de4204..7ffdb0d 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -215,6 +215,14 @@ struct module_use {
 	struct module *source, *target;
 };
 
+#ifdef CONFIG_SYMBOLS_BSEARCH
+#define __KCRCTAB_SECTION(sym, sec) "___kcrctab" sec "__"#sym
+#define __KSYMTAB_SECTION(sym, sec) "___ksymtab" sec "__"#sym
+#else
+#define __KCRCTAB_SECTION(sym, sec) "__kcrctab" sec
+#define __KSYMTAB_SECTION(sym, sec) "__ksymtab" sec
+#endif
+
 #ifndef __GENKSYMS__
 #ifdef CONFIG_MODVERSIONS
 /* Mark the CRC weak since genksyms apparently decides not to
@@ -223,7 +231,7 @@ struct module_use {
 	extern void *__crc_##sym __attribute__((weak));		\
 	static const unsigned long __kcrctab_##sym		\
 	__used							\
-	__attribute__((section("__kcrctab" sec), unused))	\
+	__attribute__((section(__KCRCTAB_SECTION(sym, sec)), unused)) \
 	= (unsigned long) &__crc_##sym;
 #else
 #define __CRC_SYMBOL(sym, sec)
@@ -238,7 +246,7 @@ struct module_use {
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
 	static const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
-	__attribute__((section("__ksymtab" sec), unused))	\
+	__attribute__((section(__KSYMTAB_SECTION(sym, sec)), unused)) \
 	= { (unsigned long)&sym, __kstrtab_##sym }
 
 #define EXPORT_SYMBOL(sym)					\
diff --git a/init/Kconfig b/init/Kconfig
index be788c0..4809c3e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1354,6 +1354,13 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
+config SYMBOLS_BSEARCH
+	bool "Use the binary search for symbols resolution" if EXPERT
+	default n
+	help
+	  Use binary search for symbols resolution during the kernel
+	  modules loading.  If unsure, say N.
+
 endif # MODULES
 
 config INIT_ALL_POSSIBLE
diff --git a/kernel/module.c b/kernel/module.c
index efa290e..cb3c1f7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -235,6 +235,18 @@ extern const unsigned long __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
+struct find_symbol_arg {
+	/* Input */
+	const char *name;
+	bool gplok;
+	bool warn;
+
+	/* Output */
+	struct module *owner;
+	const unsigned long *crc;
+	const struct kernel_symbol *sym;
+};
+
 static bool each_symbol_in_section(const struct symsearch *arr,
 				   unsigned int arrsize,
 				   struct module *owner,
@@ -243,12 +255,36 @@ static bool each_symbol_in_section(const struct symsearch *arr,
 					      unsigned int symnum, void *data),
 				   void *data)
 {
-	unsigned int i, j;
+	unsigned int j;
+	struct find_symbol_arg *fsa = data;
+	int result;
+#ifdef CONFIG_SYMBOLS_BSEARCH
+	size_t num;
+	int start, end, mid;
+#endif
 
 	for (j = 0; j < arrsize; j++) {
-		for (i = 0; i < arr[j].stop - arr[j].start; i++)
-			if (fn(&arr[j], owner, i, data))
+#ifdef CONFIG_SYMBOLS_BSEARCH
+		num = arr[j].stop - arr[j].start;
+		start = 0, end = num - 1, mid, result;
+		while (start <= end) {
+			mid = (start + end) / 2;
+			result = strcmp(fsa->name, arr[j].start[mid].name);
+			if (result < 0)
+				end = mid - 1;
+			else if (result > 0)
+				start = mid + 1;
+			else
+				if (fn(&arr[j], owner, mid, data))
+					return true;
+		}
+#else
+		for (unsigned int i = 0; i < arr[j].stop - arr[j].start; i++) {
+			result = strcmp(fsa->name, arr[j].start[i].name);
+			if (result == 0 && fn(&arr[j], owner, i, data))
 				return true;
+		}
+#endif
 	}
 
 	return false;
@@ -311,27 +347,12 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
 }
 EXPORT_SYMBOL_GPL(each_symbol);
 
-struct find_symbol_arg {
-	/* Input */
-	const char *name;
-	bool gplok;
-	bool warn;
-
-	/* Output */
-	struct module *owner;
-	const unsigned long *crc;
-	const struct kernel_symbol *sym;
-};
-
 static bool find_symbol_in_section(const struct symsearch *syms,
 				   struct module *owner,
 				   unsigned int symnum, void *data)
 {
 	struct find_symbol_arg *fsa = data;
 
-	if (strcmp(syms->start[symnum].name, fsa->name) != 0)
-		return false;
-
 	if (!fsa->gplok) {
 		if (syms->licence == GPL_ONLY)
 			return false;
diff --git a/scripts/module-common.lds b/scripts/module-common.lds
index 47a1f9a..055a8d5 100644
--- a/scripts/module-common.lds
+++ b/scripts/module-common.lds
@@ -5,4 +5,15 @@
  */
 SECTIONS {
 	/DISCARD/ : { *(.discard) }
+
+	__ksymtab				: { *(SORT(___ksymtab__*)) }
+	__ksymtab_gpl			: { *(SORT(___ksymtab_gpl__*)) }
+	__ksymtab_unused		: { *(SORT(___ksymtab_unused__*)) }
+	__ksymtab_unused_gpl	: { *(SORT(___ksymtab_unused_gpl__*)) }
+	__ksymtab_gpl_future	: { *(SORT(___ksymtab_gpl_future__*)) }
+	__kcrctab				: { *(SORT(___kcrctab__*)) }
+	__kcrctab_gpl			: { *(SORT(___kcrctab_gpl__*)) }
+	__kcrctab_unused		: { *(SORT(___kcrctab_unused__*)) }
+	__kcrctab_unused_gpl	: { *(SORT(___kcrctab_unused_gpl__*)) }
+	__kcrctab_gpl_future	: { *(SORT(___kcrctab_gpl_future__*)) }
 }
-- 
1.7.4.1

