Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1D1IQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:16:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:42978 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab1D1IQY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 28 Apr 2011 04:16:24 -0400
Message-Id: <4DB93EC3020000780003E95F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 28 Apr 2011 09:17:39 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2 2/3, resend] x86-64: use relative 32-bit pointers
	 in exception tables
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

v2: Adjust arch/x86/kernel/test_nx.c (leading to some tests no longer
    getting run on x86-64) and indent some pre-processor directives.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>

---
 arch/Kconfig                   |    3 ++
 arch/x86/Kconfig               |    1 
 arch/x86/include/asm/asm.h     |    8 +++---
 arch/x86/include/asm/uaccess.h |   17 --------------
 arch/x86/kernel/test_nx.c      |   48 ++++++++++++++++++++++++----------------
 arch/x86/mm/extable.c          |    8 ++++--
 include/asm-generic/extable.h  |   49 +++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/uaccess.h  |   21 -----------------
 lib/extable.c                  |   39 ++++++++++++++++++++++++++------
 9 files changed, 125 insertions(+), 69 deletions(-)

--- 2.6.39-rc5-extable.orig/arch/Kconfig
+++ 2.6.39-rc5-extable/arch/Kconfig
@@ -61,6 +61,9 @@ config OPTPROBES
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
 
+config EXTABLE_RELATIVE_POINTERS
+	bool
+
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
 	help
--- 2.6.39-rc5-extable.orig/arch/x86/Kconfig
+++ 2.6.39-rc5-extable/arch/x86/Kconfig
@@ -11,6 +11,7 @@ config X86_32
 
 config X86_64
 	def_bool 64BIT
+	select EXTABLE_RELATIVE_POINTERS
 
 ### Arch settings
 config X86
--- 2.6.39-rc5-extable.orig/arch/x86/include/asm/asm.h
+++ 2.6.39-rc5-extable/arch/x86/include/asm/asm.h
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
 
--- 2.6.39-rc5-extable.orig/arch/x86/include/asm/uaccess.h
+++ 2.6.39-rc5-extable/arch/x86/include/asm/uaccess.h
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
 
--- 2.6.39-rc5-extable.orig/arch/x86/kernel/test_nx.c
+++ 2.6.39-rc5-extable/arch/x86/kernel/test_nx.c
@@ -42,7 +42,7 @@ extern int rodata_test_data;
  * and walks the exception table of the module, looking for a magic
  * marker and replaces it with a specific function.
  */
-static void fudze_exception_table(void *marker, void *new)
+static bool fudze_exception_table(void *marker, void *new)
 {
 	struct module *mod = THIS_MODULE;
 	struct exception_table_entry *extable;
@@ -56,10 +56,22 @@ static void fudze_exception_table(void *
 	if (mod->num_exentries > 1) {
 		printk(KERN_ERR "test_nx: too many exception table entries!\n");
 		printk(KERN_ERR "test_nx: test results are not reliable.\n");
-		return;
+		return false;
 	}
 	extable = (struct exception_table_entry *)mod->extable;
+#ifdef CONFIG_EXTABLE_RELATIVE_POINTERS
+	{
+		long off = (long)new - (long)&extable->insn_off;
+
+		if ((typeof(extable->insn_off))off != off)
+			return false;
+		extable->insn_off = off;
+		BUG_ON(ex_insn(extable) != (unsigned long)new);
+	}
+#else
 	extable[0].insn = (unsigned long)new;
+#endif
+	return true;
 }
 
 
@@ -77,12 +89,15 @@ void foo_label(void);
  * that would give us more than 1 exception table entry.
  * This in turn would break the assumptions above.
  */
-static noinline int test_address(void *address)
+static noinline int test_address(void *address, const char *what)
 {
 	unsigned long result;
 
 	/* Set up an exception table entry for our address */
-	fudze_exception_table(&foo_label, address);
+	if (!fudze_exception_table(&foo_label, address)) {
+		pr_warn("test_nx: %s test not performed\n", what);
+		return -ENOSYS;
+	}
 	result = 1;
 	asm volatile(
 		"foo_label:\n"
@@ -97,10 +112,13 @@ static noinline int test_address(void *a
 		: [fake_code] "r" (address), [zero] "r" (0UL), "0" (result)
 	);
 	/* change the exception table back for the next round */
-	fudze_exception_table(address, &foo_label);
+	if (!fudze_exception_table(address, &foo_label))
+		BUG();
 
-	if (result)
+	if (result) {
+		pr_err("test_nx: %s is executable\n", what);
 		return -ENODEV;
+	}
 	return 0;
 }
 
@@ -118,10 +136,8 @@ static int test_NX(void)
 	printk(KERN_INFO "Testing NX protection\n");
 
 	/* Test 1: check if the stack is not executable */
-	if (test_address(&stackcode)) {
-		printk(KERN_ERR "test_nx: stack was executable\n");
+	if (test_address(&stackcode, "stack"))
 		ret = -ENODEV;
-	}
 
 
 	/* Test 2: Check if the heap is executable */
@@ -130,10 +146,8 @@ static int test_NX(void)
 		return -ENOMEM;
 	heap[0] = 0xC3; /* opcode for "ret" */
 
-	if (test_address(heap)) {
-		printk(KERN_ERR "test_nx: heap was executable\n");
+	if (test_address(heap, "heap"))
 		ret = -ENODEV;
-	}
 	kfree(heap);
 
 	/*
@@ -147,18 +161,14 @@ static int test_NX(void)
 	if (rodata_test_data != 0xC3) {
 		printk(KERN_ERR "test_nx: .rodata marker has invalid value\n");
 		ret = -ENODEV;
-	} else if (test_address(&rodata_test_data)) {
-		printk(KERN_ERR "test_nx: .rodata section is executable\n");
+	} else if (test_address(&rodata_test_data, ".rodata section"))
 		ret = -ENODEV;
-	}
 #endif
 
-#if 0
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
 	/* Test 4: Check if the .data section of a module is executable */
-	if (test_address(&test_data)) {
-		printk(KERN_ERR "test_nx: .data section is executable\n");
+	if (test_address(&test_data, ".data section"))
 		ret = -ENODEV;
-	}
 
 #endif
 	return 0;
--- 2.6.39-rc5-extable.orig/arch/x86/mm/extable.c
+++ 2.6.39-rc5-extable/arch/x86/mm/extable.c
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
+++ 2.6.39-rc5-extable/include/asm-generic/extable.h
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
+# define EX_FIELD(ptr, field) \
+	((unsigned long)&(ptr)->field##_off + (ptr)->field##_off)
+#else
+# define EX_FIELD(ptr, field) (ptr)->field
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
--- 2.6.39-rc5-extable.orig/include/asm-generic/uaccess.h
+++ 2.6.39-rc5-extable/include/asm-generic/uaccess.h
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
--- 2.6.39-rc5-extable.orig/lib/extable.c
+++ 2.6.39-rc5-extable/lib/extable.c
@@ -14,6 +14,10 @@
 #include <linux/sort.h>
 #include <asm/uaccess.h>
 
+#ifndef ex_insn /* until all architectures have this accessor */
+# define ex_insn(x) (x)->insn
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
+# define swap_ex NULL
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


