Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2DUBRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:17:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35297 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2DUBRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:17:45 -0400
Date: Fri, 20 Apr 2012 18:17:22 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-706276543b699d80f546e45f8b12574e7b18d952@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Switch to relative exception table entries
Git-Commit-ID: 706276543b699d80f546e45f8b12574e7b18d952
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 18:17:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  706276543b699d80f546e45f8b12574e7b18d952
Gitweb:     http://git.kernel.org/tip/706276543b699d80f546e45f8b12574e7b18d952
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 17:12:48 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 17:22:34 -0700

x86, extable: Switch to relative exception table entries

Switch to using relative exception table entries on x86.  On i386,
this has the advantage that the exception table entries don't need to
be relocated; on x86-64 this means the exception table entries take up
only half the space.

In either case, a 32-bit delta is sufficient, as the range of kernel
code addresses is limited.

Since part of the goal is to avoid needing to adjust the entries when
the kernel is relocated, the old trick of using addresses in the NULL
pointer range to indicate uaccess_err no longer works (and unlike RISC
architectures we can't use a flag bit); instead use an delta just
below +2G to indicate these special entries.  The reach is still
limited to a single instruction.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/include/asm/asm.h     |   20 ++++---
 arch/x86/include/asm/uaccess.h |   17 ++++--
 arch/x86/mm/extable.c          |  131 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 146 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 0f15e8a..1c2d247 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -42,26 +42,30 @@
 #ifdef __ASSEMBLY__
 # define _ASM_EXTABLE(from,to)					\
 	.pushsection "__ex_table","a" ;				\
-	_ASM_ALIGN ;						\
-	_ASM_PTR from , to ;					\
+	.balign 8 ;						\
+	.long (from) - . ;					\
+	.long (to) - . ;					\
 	.popsection
 
 # define _ASM_EXTABLE_EX(from,to)				\
 	.pushsection "__ex_table","a" ;				\
-	_ASM_ALIGN ;						\
-	_ASM_PTR from , (to) - (from) ;				\
+	.balign 8 ;						\
+	.long (from) - . ;					\
+	.long (to) - . + 0x7ffffff0 ;				\
 	.popsection
 #else
 # define _ASM_EXTABLE(from,to)					\
 	" .pushsection \"__ex_table\",\"a\"\n"			\
-	_ASM_ALIGN "\n" 					\
-	_ASM_PTR #from "," #to "\n" 				\
+	" .balign 8\n"						\
+	" .long (" #from ") - .\n"				\
+	" .long (" #to ") - .\n"				\
 	" .popsection\n"
 
 # define _ASM_EXTABLE_EX(from,to)				\
 	" .pushsection \"__ex_table\",\"a\"\n"			\
-	_ASM_ALIGN "\n" 					\
-	_ASM_PTR #from ",(" #to ")-(" #from ")\n" 		\
+	" .balign 8\n"						\
+	" .long (" #from ") - .\n"				\
+	" .long (" #to ") - . + 0x7ffffff0\n"			\
 	" .popsection\n"
 #endif
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 4ee59dd..851fe0d 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -79,11 +79,12 @@
 #define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
 
 /*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
+ * The exception table consists of pairs of addresses relative to the
+ * exception table enty itself: the first is the address of an
+ * instruction that is allowed to fault, and the second is the address
+ * at which the program should continue.  No registers are modified,
+ * so it is entirely up to the continuation code to figure out what to
+ * do.
  *
  * All the routines below use bits of fixup code that are out of line
  * with the main instruction path.  This means when everything is well,
@@ -92,10 +93,14 @@
  */
 
 struct exception_table_entry {
-	unsigned long insn, fixup;
+	int insn, fixup;
 };
+/* This is not the generic standard exception_table_entry format */
+#define ARCH_HAS_SORT_EXTABLE
+#define ARCH_HAS_SEARCH_EXTABLE
 
 extern int fixup_exception(struct pt_regs *regs);
+extern int early_fixup_exception(unsigned long *ip);
 
 /*
  * These are the main single-value transfer routines.  They automatically
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 5555675..903ec1e 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -1,11 +1,23 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/sort.h>
 #include <asm/uaccess.h>
 
+static inline unsigned long
+ex_insn_addr(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->insn + x->insn;
+}
+static inline unsigned long
+ex_fixup_addr(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->fixup + x->fixup;
+}
 
 int fixup_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
+	unsigned long new_ip;
 
 #ifdef CONFIG_PNPBIOS
 	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
@@ -23,13 +35,14 @@ int fixup_exception(struct pt_regs *regs)
 
 	fixup = search_exception_tables(regs->ip);
 	if (fixup) {
-		/* If fixup is less than 16, it means uaccess error */
-		if (fixup->fixup < 16) {
+		new_ip = ex_fixup_addr(fixup);
+
+		if (fixup->fixup - fixup->insn >= 0x7ffffff0 - 4) {
+			/* Special hack for uaccess_err */
 			current_thread_info()->uaccess_err = 1;
-			regs->ip += fixup->fixup;
-			return 1;
+			new_ip -= 0x7ffffff0;
 		}
-		regs->ip = fixup->fixup;
+		regs->ip = new_ip;
 		return 1;
 	}
 
@@ -40,15 +53,117 @@ int fixup_exception(struct pt_regs *regs)
 int __init early_fixup_exception(unsigned long *ip)
 {
 	const struct exception_table_entry *fixup;
+	unsigned long new_ip;
 
 	fixup = search_exception_tables(*ip);
 	if (fixup) {
-		if (fixup->fixup < 16)
-			return 0; /* Not supported during early boot */
+		new_ip = ex_fixup_addr(fixup);
+
+		if (fixup->fixup - fixup->insn >= 0x7ffffff0 - 4) {
+			/* uaccess handling not supported during early boot */
+			return 0;
+		}
 
-		*ip = fixup->fixup;
+		*ip = new_ip;
 		return 1;
 	}
 
 	return 0;
 }
+
+/*
+ * Search one exception table for an entry corresponding to the
+ * given instruction address, and return the address of the entry,
+ * or NULL if none is found.
+ * We use a binary search, and thus we assume that the table is
+ * already sorted.
+ */
+const struct exception_table_entry *
+search_extable(const struct exception_table_entry *first,
+	       const struct exception_table_entry *last,
+	       unsigned long value)
+{
+	while (first <= last) {
+		const struct exception_table_entry *mid;
+		unsigned long addr;
+
+		mid = ((last - first) >> 1) + first;
+		addr = ex_insn_addr(mid);
+		if (addr < value)
+			first = mid + 1;
+		else if (addr > value)
+			last = mid - 1;
+		else
+			return mid;
+        }
+        return NULL;
+}
+
+/*
+ * The exception table needs to be sorted so that the binary
+ * search that we use to find entries in it works properly.
+ * This is used both for the kernel exception table and for
+ * the exception tables of modules that get loaded.
+ *
+ */
+static int cmp_ex(const void *a, const void *b)
+{
+	const struct exception_table_entry *x = a, *y = b;
+
+	/*
+	 * This value will always end up fittin in an int, because on
+	 * both i386 and x86-64 the kernel symbol-reachable address
+	 * space is < 2 GiB.
+	 *
+	 * This compare is only valid after normalization.
+	 */
+	return x->insn - y->insn;
+}
+
+void sort_extable(struct exception_table_entry *start,
+		  struct exception_table_entry *finish)
+{
+	struct exception_table_entry *p;
+	int i;
+
+	/* Convert all entries to being relative to the start of the section */
+	i = 0;
+	for (p = start; p < finish; p++) {
+		p->insn += i;
+		i += 4;
+		p->fixup += i;
+		i += 4;
+	}
+
+	sort(start, finish - start, sizeof(struct exception_table_entry),
+	     cmp_ex, NULL);
+
+	/* Denormalize all entries */
+	i = 0;
+	for (p = start; p < finish; p++) {
+		p->insn -= i;
+		i += 4;
+		p->fixup -= i;
+		i += 4;
+	}
+}
+
+#ifdef CONFIG_MODULES
+/*
+ * If the exception table is sorted, any referring to the module init
+ * will be at the beginning or the end.
+ */
+void trim_init_extable(struct module *m)
+{
+	/*trim the beginning*/
+	while (m->num_exentries &&
+	       within_module_init(ex_insn_addr(&m->extable[0]), m)) {
+		m->extable++;
+		m->num_exentries--;
+	}
+	/*trim the end*/
+	while (m->num_exentries &&
+	       within_module_init(ex_insn_addr(&m->extable[m->num_exentries-1]), m))
+		m->num_exentries--;
+}
+#endif /* CONFIG_MODULES */
