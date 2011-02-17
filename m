Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab1BQRCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:02:39 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:33886 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab1BQRCg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 17 Feb 2011 12:02:36 -0500
Message-Id: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 17 Feb 2011 17:03:26 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86-64: use relative 32-bit pointers in exception
	 tables
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert exception table pointers from absolute 64-bit to relative 32-
bit ones, thus shrinking the table size by half. Rather than providing
an x86-64-specific extable implementation, generalize the common one
to deal with different ways of storing the pointers, which will allow
ia64's custom implementation to be dropped subsequently.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>

---
 arch/Kconfig                   |    3 ++
 arch/x86/Kconfig               |    1 
 arch/x86/include/asm/asm.h     |    8 +++---
 arch/x86/include/asm/uaccess.h |   17 --------------
 arch/x86/mm/extable.c          |    8 ++++--
 include/asm-generic/extable.h  |   49 +++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/uaccess.h  |   21 -----------------
 lib/extable.c                  |   39 ++++++++++++++++++++++++++------
 8 files changed, 96 insertions(+), 50 deletions(-)

--- 2.6.38-rc5-extable.orig/arch/Kconfig
+++ 2.6.38-rc5-extable/arch/Kconfig
@@ -61,6 +61,9 @@ config OPTPROBES
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
 
+config EXTABLE_RELATIVE_POINTERS
+	bool
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
--- 2.6.38-rc5-extable.orig/arch/x86/Kconfig
+++ 2.6.38-rc5-extable/arch/x86/Kconfig
@@ -11,6 +11,7 @@ config X86_32
 
 config X86_64
 	def_bool 64BIT
+	select EXTABLE_RELATIVE_POINTERS
 
 ### Arch settings
 config X86
--- 2.6.38-rc5-extable.orig/arch/x86/include/asm/asm.h
+++ 2.6.38-rc5-extable/arch/x86/include/asm/asm.h
@@ -41,14 +41,14 @@
 #ifdef __ASSEMBLY__
 # define _ASM_EXTABLE(from,to)	    \
 	__ASM_EX_SEC ;		    \
-	_ASM_ALIGN ;		    \
-	_ASM_PTR from , to ;	    \
+	.balign 4 ;		    \
+	.long from __ASM_SEL(,-.), to __ASM_SEL(,-.) ; \
 	.previous
 #else
 # define _ASM_EXTABLE(from,to) \
 	__ASM_EX_SEC	\
-	_ASM_ALIGN "\n" \
-	_ASM_PTR #from "," #to "\n" \
+	" .balign 4\n" \
+	" .long " #from __ASM_SEL(,-.) "," #to __ASM_SEL(,-.) "\n" \
 	" .previous\n"
 #endif
 
--- 2.6.38-rc5-extable.orig/arch/x86/include/asm/uaccess.h
+++ 2.6.38-rc5-extable/arch/x86/include/asm/uaccess.h
@@ -79,22 +79,7 @@
  */
 #define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
 
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path.  This means when everything is well,
- * we don't even have to jump over them.  Further, they do not intrude
- * on our cache or tlb entries.
- */
-
-struct exception_table_entry {
-	unsigned long insn, fixup;
-};
+#include <asm-generic/extable.h>
 
 extern int fixup_exception(struct pt_regs *regs);
 
--- 2.6.38-rc5-extable.orig/arch/x86/mm/extable.c
+++ 2.6.38-rc5-extable/arch/x86/mm/extable.c
@@ -23,13 +23,15 @@ int fixup_exception(struct pt_regs *regs
 
 	fixup = search_exception_tables(regs->ip);
 	if (fixup) {
+		unsigned long addr = ex_fixup(fixup);
+
 		/* If fixup is less than 16, it means uaccess error */
-		if (fixup->fixup < 16) {
+		if (addr < 16) {
 			current_thread_info()->uaccess_err = -EFAULT;
-			regs->ip += fixup->fixup;
+			regs->ip += addr;
 			return 1;
 		}
-		regs->ip = fixup->fixup;
+		regs->ip = addr;
 		return 1;
 	}
 
--- /dev/null
+++ 2.6.38-rc5-extable/include/asm-generic/extable.h
@@ -0,0 +1,49 @@
+#ifndef __ASM_GENERIC_EXTABLE_H
+#define __ASM_GENERIC_EXTABLE_H
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+
+struct exception_table_entry
+{
+#ifdef CONFIG_EXTABLE_RELATIVE_POINTERS
+	s32 insn_off, fixup_off;
+#else
+	unsigned long insn, fixup;
+#endif
+};
+
+#ifdef CONFIG_EXTABLE_RELATIVE_POINTERS
+#define EX_FIELD(ptr, field) \
+	((unsigned long)&(ptr)->field##_off + (ptr)->field##_off)
+#else
+#define EX_FIELD(ptr, field) (ptr)->field
+#endif
+
+static inline unsigned long ex_insn(const struct exception_table_entry *x)
+{
+	return EX_FIELD(x, insn);
+}
+#define ex_insn ex_insn /* until all architectures have this accessor */
+
+static inline unsigned long ex_fixup(const struct exception_table_entry *x)
+{
+	return EX_FIELD(x, fixup);
+}
+
+#undef EX_FIELD
+
+/* Returns 0 if exception not found and fixup otherwise.  */
+extern unsigned long search_exception_table(unsigned long);
+
+#endif /* __ASM_GENERIC_EXTABLE_H */
--- 2.6.38-rc5-extable.orig/include/asm-generic/uaccess.h
+++ 2.6.38-rc5-extable/include/asm-generic/uaccess.h
@@ -50,26 +50,7 @@ static inline int __access_ok(unsigned l
 }
 #endif
 
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path.  This means when everything is well,
- * we don't even have to jump over them.  Further, they do not intrude
- * on our cache or tlb entries.
- */
-
-struct exception_table_entry
-{
-	unsigned long insn, fixup;
-};
-
-/* Returns 0 if exception not found and fixup otherwise.  */
-extern unsigned long search_exception_table(unsigned long);
+#include "extable.h"
 
 /*
  * architectures with an MMU should override these two
--- 2.6.38-rc5-extable.orig/lib/extable.c
+++ 2.6.38-rc5-extable/lib/extable.c
@@ -14,6 +14,10 @@
 #include <linux/sort.h>
 #include <asm/uaccess.h>
 
+#ifndef ex_insn /* until all architectures have this accessor */
+#define ex_insn(x) (x)->insn
+#endif
+
 #ifndef ARCH_HAS_SORT_EXTABLE
 /*
  * The exception table needs to be sorted so that the binary
@@ -24,20 +28,38 @@
 static int cmp_ex(const void *a, const void *b)
 {
 	const struct exception_table_entry *x = a, *y = b;
+	unsigned long xinsn = ex_insn(x);
+	unsigned long yinsn = ex_insn(y);
 
 	/* avoid overflow */
-	if (x->insn > y->insn)
+	if (xinsn > yinsn)
 		return 1;
-	if (x->insn < y->insn)
+	if (xinsn < yinsn)
 		return -1;
 	return 0;
 }
 
+#ifdef CONFIG_EXTABLE_RELATIVE_POINTERS
+static void swap_ex(void *a, void *b, int size)
+{
+	struct exception_table_entry *x = a, *y = b, tmp;
+	long delta = b - a;
+
+	tmp = *x;
+	x->insn_off = y->insn_off + delta;
+	x->fixup_off = y->fixup_off + delta;
+	y->insn_off = tmp.insn_off - delta;
+	y->fixup_off = tmp.fixup_off - delta;
+}
+#else
+#define swap_ex NULL
+#endif
+
 void sort_extable(struct exception_table_entry *start,
 		  struct exception_table_entry *finish)
 {
 	sort(start, finish - start, sizeof(struct exception_table_entry),
-	     cmp_ex, NULL);
+	     cmp_ex, swap_ex);
 }
 
 #ifdef CONFIG_MODULES
@@ -48,13 +70,15 @@ void sort_extable(struct exception_table
 void trim_init_extable(struct module *m)
 {
 	/*trim the beginning*/
-	while (m->num_exentries && within_module_init(m->extable[0].insn, m)) {
+	while (m->num_exentries &&
+	       within_module_init(ex_insn(m->extable), m)) {
 		m->extable++;
 		m->num_exentries--;
 	}
 	/*trim the end*/
 	while (m->num_exentries &&
-		within_module_init(m->extable[m->num_exentries-1].insn, m))
+	       within_module_init(ex_insn(m->extable + m->num_exentries - 1),
+				  m))
 		m->num_exentries--;
 }
 #endif /* CONFIG_MODULES */
@@ -68,6 +92,7 @@ void trim_init_extable(struct module *m)
  * We use a binary search, and thus we assume that the table is
  * already sorted.
  */
+#include <linux/kallsyms.h>//temp
 const struct exception_table_entry *
 search_extable(const struct exception_table_entry *first,
 	       const struct exception_table_entry *last,
@@ -81,9 +106,9 @@ search_extable(const struct exception_ta
 		 * careful, the distance between value and insn
 		 * can be larger than MAX_LONG:
 		 */
-		if (mid->insn < value)
+		if (ex_insn(mid) < value)
 			first = mid + 1;
-		else if (mid->insn > value)
+		else if (ex_insn(mid) > value)
 			last = mid - 1;
 		else
 			return mid;


