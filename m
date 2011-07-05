Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab1GERkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:40:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48409 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1GERkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:40:10 -0400
Subject: Re: [RFC] [PATCH] x86: Make copy_from_user_nmi() a library function
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110705172215.GE4590@erda.amd.com>
References: <COL116-W380DF5357514E3CC28BB66A38F0@phx.gbl>
	 <4DD5046F.3000807@us.ibm.com> <4DD53BC8.2010208@hotmail.com>
	 <20110607105259.GE20052@erda.amd.com> <4DEE2F09.6090803@hotmail.com>
	 <20110607171822.GI20052@erda.amd.com> <20110607172413.GJ20052@erda.amd.com>
	 <20110705172215.GE4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 19:40:01 +0200
Message-ID: <1309887601.3282.269.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 19:22 +0200, Robert Richter wrote:
> Ingo, Peter,
> 
> what about this patch? Any opinion? This one should be against
> tip/perf/core now. 

Ah, thanks for the reminder, yeah, took it with EXPORT_SYMBOL_GPL.

---
Subject: x86: Make copy_from_user_nmi() a library function
From: Robert Richter <robert.richter@amd.com>
Date: Tue, 7 Jun 2011 11:49:55 +0200

copy_from_user_nmi() is used in oprofile and perf. Moving it to other
library functions like copy_from_user(). As this is x86 code for 32
and 64 bits, create a new file usercopy.c for unified code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110607172413.GJ20052@erda.amd.com
---
 arch/x86/include/asm/uaccess.h   |    3 ++
 arch/x86/kernel/cpu/perf_event.c |   35 -------------------------------
 arch/x86/lib/Makefile            |    2 -
 arch/x86/lib/usercopy.c          |   43 +++++++++++++++++++++++++++++++++++++++
 arch/x86/oprofile/backtrace.c    |   39 -----------------------------------
 5 files changed, 48 insertions(+), 74 deletions(-)
 create mode 100644 arch/x86/lib/usercopy.c

Index: linux-2.6/arch/x86/include/asm/uaccess.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/uaccess.h
+++ linux-2.6/arch/x86/include/asm/uaccess.h
@@ -555,6 +555,9 @@ struct __large_struct { unsigned long bu
 
 #endif /* CONFIG_X86_WP_WORKS_OK */
 
+extern unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -22,7 +22,6 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
-#include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
 
@@ -67,40 +66,6 @@ enum extra_reg_type {
 	EXTRA_REG_MAX		/* number of entries needed */
 };
 
-/*
- * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
- */
-static unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long offset, addr = (unsigned long)from;
-	unsigned long size, len = 0;
-	struct page *page;
-	void *map;
-	int ret;
-
-	do {
-		ret = __get_user_pages_fast(addr, 1, 0, &page);
-		if (!ret)
-			break;
-
-		offset = addr & (PAGE_SIZE - 1);
-		size = min(PAGE_SIZE - offset, n - len);
-
-		map = kmap_atomic(page);
-		memcpy(to, map+offset, size);
-		kunmap_atomic(map);
-		put_page(page);
-
-		len  += size;
-		to   += size;
-		addr += size;
-
-	} while (len < n);
-
-	return len;
-}
-
 struct event_constraint {
 	union {
 		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
Index: linux-2.6/arch/x86/lib/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/lib/Makefile
+++ linux-2.6/arch/x86/lib/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
-lib-y += usercopy_$(BITS).o getuser.o putuser.o
+lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
Index: linux-2.6/arch/x86/lib/usercopy.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/lib/usercopy.c
@@ -0,0 +1,43 @@
+/*
+ * User address space access functions.
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/highmem.h>
+#include <linux/module.h>
+
+/*
+ * best effort, GUP based copy_from_user() that is NMI-safe
+ */
+unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long offset, addr = (unsigned long)from;
+	unsigned long size, len = 0;
+	struct page *page;
+	void *map;
+	int ret;
+
+	do {
+		ret = __get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret)
+			break;
+
+		offset = addr & (PAGE_SIZE - 1);
+		size = min(PAGE_SIZE - offset, n - len);
+
+		map = kmap_atomic(page);
+		memcpy(to, map+offset, size);
+		kunmap_atomic(map);
+		put_page(page);
+
+		len  += size;
+		to   += size;
+		addr += size;
+
+	} while (len < n);
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(copy_from_user_nmi);
Index: linux-2.6/arch/x86/oprofile/backtrace.c
===================================================================
--- linux-2.6.orig/arch/x86/oprofile/backtrace.c
+++ linux-2.6/arch/x86/oprofile/backtrace.c
@@ -12,10 +12,9 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/compat.h>
-#include <linux/highmem.h>
+#include <linux/uaccess.h>
 
 #include <asm/ptrace.h>
-#include <asm/uaccess.h>
 #include <asm/stacktrace.h>
 
 static int backtrace_stack(void *data, char *name)
@@ -38,42 +37,6 @@ static struct stacktrace_ops backtrace_o
 	.walk_stack	= print_context_stack,
 };
 
-/* from arch/x86/kernel/cpu/perf_event.c: */
-
-/*
- * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
- */
-static unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long offset, addr = (unsigned long)from;
-	unsigned long size, len = 0;
-	struct page *page;
-	void *map;
-	int ret;
-
-	do {
-		ret = __get_user_pages_fast(addr, 1, 0, &page);
-		if (!ret)
-			break;
-
-		offset = addr & (PAGE_SIZE - 1);
-		size = min(PAGE_SIZE - offset, n - len);
-
-		map = kmap_atomic(page);
-		memcpy(to, map+offset, size);
-		kunmap_atomic(map);
-		put_page(page);
-
-		len  += size;
-		to   += size;
-		addr += size;
-
-	} while (len < n);
-
-	return len;
-}
-
 #ifdef CONFIG_COMPAT
 static struct stack_frame_ia32 *
 dump_user_backtrace_32(struct stack_frame_ia32 *head)

