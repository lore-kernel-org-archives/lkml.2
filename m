Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674Ab1JENJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 09:09:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934332Ab1JENJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 09:09:36 -0400
Subject: [PATCH] mm, arch: Complete pagefault_disable abstraction
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 05 Oct 2011 15:09:29 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317820169.6766.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: mm, arch: Complete pagefault_disable abstraction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Oct 05 14:22:37 CEST 2011

Currently we already have pagefault_{disable,enable}() but they're
nothing more than a glorified preempt_{disable,enable}().

For -rt we want to make pagefault_disable() regions preemptible and
for that we need to complete the abstraction, replace the current
in_atomic() tests that are relevant to pagefault_disable() usage with
pagefault_disabled().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/mm/fault.c      |    2 +-
 arch/arm/mm/fault.c        |    2 +-
 arch/avr32/mm/fault.c      |    2 +-
 arch/cris/mm/fault.c       |    2 +-
 arch/frv/mm/fault.c        |    2 +-
 arch/ia64/mm/fault.c       |    2 +-
 arch/m32r/mm/fault.c       |    2 +-
 arch/m68k/mm/fault.c       |    2 +-
 arch/microblaze/mm/fault.c |    2 +-
 arch/mips/mm/fault.c       |    2 +-
 arch/mn10300/mm/fault.c    |    2 +-
 arch/parisc/mm/fault.c     |    2 +-
 arch/powerpc/mm/fault.c    |    2 +-
 arch/s390/mm/fault.c       |    6 ++++--
 arch/score/mm/fault.c      |    2 +-
 arch/sh/mm/fault_32.c      |    2 +-
 arch/sparc/mm/fault_32.c   |    4 ++--
 arch/sparc/mm/fault_64.c   |    2 +-
 arch/tile/mm/fault.c       |    2 +-
 arch/um/kernel/trap.c      |    2 +-
 arch/unicore32/mm/fault.c  |    2 +-
 arch/x86/mm/fault.c        |    2 +-
 arch/xtensa/mm/fault.c     |    2 +-
 include/linux/sched.h      |    6 ++++++
 mm/filemap.c               |    2 +-
 25 files changed, 34 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/alpha/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/alpha/mm/fault.c
+++ linux-2.6/arch/alpha/mm/fault.c
@@ -107,7 +107,7 @@ do_page_fault(unsigned long address, uns
 
 	/* If we're in an interrupt context, or have no user context,
 	   we must not take the fault.  */
-	if (!mm || in_atomic())
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 #ifdef CONFIG_ALPHA_LARGE_VMALLOC
Index: linux-2.6/arch/arm/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/fault.c
+++ linux-2.6/arch/arm/mm/fault.c
@@ -293,7 +293,7 @@ do_page_fault(unsigned long addr, unsign
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 	/*
Index: linux-2.6/arch/avr32/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/avr32/mm/fault.c
+++ linux-2.6/arch/avr32/mm/fault.c
@@ -81,7 +81,7 @@ asmlinkage void do_page_fault(unsigned l
 	 * If we're in an interrupt or have no user context, we must
 	 * not take the fault...
 	 */
-	if (in_atomic() || !mm || regs->sr & SYSREG_BIT(GM))
+	if (!mm || regs->sr & SYSREG_BIT(GM) || pagefault_disabled())
 		goto no_context;
 
 	local_irq_enable();
Index: linux-2.6/arch/cris/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/cris/mm/fault.c
+++ linux-2.6/arch/cris/mm/fault.c
@@ -111,7 +111,7 @@ do_page_fault(unsigned long address, str
 	 * user context, we must not take the fault.
 	 */
 
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/frv/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/frv/mm/fault.c
+++ linux-2.6/arch/frv/mm/fault.c
@@ -79,7 +79,7 @@ asmlinkage void do_page_fault(int datamm
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/ia64/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/ia64/mm/fault.c
+++ linux-2.6/arch/ia64/mm/fault.c
@@ -89,7 +89,7 @@ ia64_do_page_fault (unsigned long addres
 	/*
 	 * If we're in an interrupt or have no user context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 #ifdef CONFIG_VIRTUAL_MEM_MAP
Index: linux-2.6/arch/m32r/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/m32r/mm/fault.c
+++ linux-2.6/arch/m32r/mm/fault.c
@@ -115,7 +115,7 @@ asmlinkage void do_page_fault(struct pt_
 	 * If we're in an interrupt or have no user context or are running in an
 	 * atomic region then we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto bad_area_nosemaphore;
 
 	/* When running in the kernel we expect faults to occur only to
Index: linux-2.6/arch/m68k/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/m68k/mm/fault.c
+++ linux-2.6/arch/m68k/mm/fault.c
@@ -85,7 +85,7 @@ int do_page_fault(struct pt_regs *regs,
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/microblaze/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/microblaze/mm/fault.c
+++ linux-2.6/arch/microblaze/mm/fault.c
@@ -107,7 +107,7 @@ void do_page_fault(struct pt_regs *regs,
 	if ((error_code & 0x13) == 0x13 || (error_code & 0x11) == 0x11)
 		is_write = 0;
 
-	if (unlikely(in_atomic() || !mm)) {
+	if (unlikely(!mm || pagefault_disabled())) {
 		if (kernel_mode(regs))
 			goto bad_area_nosemaphore;
 
Index: linux-2.6/arch/mips/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/mips/mm/fault.c
+++ linux-2.6/arch/mips/mm/fault.c
@@ -88,7 +88,7 @@ asmlinkage void __kprobes do_page_fault(
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto bad_area_nosemaphore;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/mn10300/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/mn10300/mm/fault.c
+++ linux-2.6/arch/mn10300/mm/fault.c
@@ -168,7 +168,7 @@ asmlinkage void do_page_fault(struct pt_
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/parisc/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/parisc/mm/fault.c
+++ linux-2.6/arch/parisc/mm/fault.c
@@ -176,7 +176,7 @@ void do_page_fault(struct pt_regs *regs,
 	unsigned long acc_type;
 	int fault;
 
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/powerpc/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/fault.c
+++ linux-2.6/arch/powerpc/mm/fault.c
@@ -162,7 +162,7 @@ int __kprobes do_page_fault(struct pt_re
 	}
 #endif
 
-	if (in_atomic() || mm == NULL) {
+	if (!mm || pagefault_disabled()) {
 		if (!user_mode(regs))
 			return SIGSEGV;
 		/* in_atomic() in user mode is really bad,
Index: linux-2.6/arch/s390/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/s390/mm/fault.c
+++ linux-2.6/arch/s390/mm/fault.c
@@ -295,7 +295,8 @@ static inline int do_exception(struct pt
 	 * user context.
 	 */
 	fault = VM_FAULT_BADCONTEXT;
-	if (unlikely(!user_space_fault(trans_exc_code) || in_atomic() || !mm))
+	if (unlikely(!user_space_fault(trans_exc_code) ||
+		     !mm || pagefault_disabled()))
 		goto out;
 
 	address = trans_exc_code & __FAIL_ADDR_MASK;
@@ -426,7 +427,8 @@ void __kprobes do_asce_exception(struct
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 
-	if (unlikely(!user_space_fault(trans_exc_code) || in_atomic() || !mm))
+	if (unlikely(!user_space_fault(trans_exc_code) ||
+		     !mm || pagefault_disabled()))
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/score/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/score/mm/fault.c
+++ linux-2.6/arch/score/mm/fault.c
@@ -72,7 +72,7 @@ asmlinkage void do_page_fault(struct pt_
 	* If we're in an interrupt or have no user
 	* context, we must not take the fault..
 	*/
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto bad_area_nosemaphore;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/sh/mm/fault_32.c
===================================================================
--- linux-2.6.orig/arch/sh/mm/fault_32.c
+++ linux-2.6/arch/sh/mm/fault_32.c
@@ -166,7 +166,7 @@ asmlinkage void __kprobes do_page_fault(
 	 * If we're in an interrupt, have no user context or are running
 	 * in an atomic region then we must not take the fault:
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/sparc/mm/fault_32.c
===================================================================
--- linux-2.6.orig/arch/sparc/mm/fault_32.c
+++ linux-2.6/arch/sparc/mm/fault_32.c
@@ -248,8 +248,8 @@ asmlinkage void do_sparc_fault(struct pt
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-        if (in_atomic() || !mm)
-                goto no_context;
+	if (!mm || pagefault_disabled())
+		goto no_context;
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
Index: linux-2.6/arch/sparc/mm/fault_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/mm/fault_64.c
+++ linux-2.6/arch/sparc/mm/fault_64.c
@@ -322,7 +322,7 @@ asmlinkage void __kprobes do_sparc64_fau
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto intr_or_no_mm;
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
Index: linux-2.6/arch/tile/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/tile/mm/fault.c
+++ linux-2.6/arch/tile/mm/fault.c
@@ -346,7 +346,7 @@ static int handle_page_fault(struct pt_r
 	 * If we're in an interrupt, have no user context or are running in an
 	 * atomic region then we must not take the fault.
 	 */
-	if (in_atomic() || !mm) {
+	if (!mm || pagefault_disabled()) {
 		vma = NULL;  /* happy compiler */
 		goto bad_area_nosemaphore;
 	}
Index: linux-2.6/arch/um/kernel/trap.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/trap.c
+++ linux-2.6/arch/um/kernel/trap.c
@@ -37,7 +37,7 @@ int handle_page_fault(unsigned long addr
 	 * If the fault was during atomic operation, don't take the fault, just
 	 * fail.
 	 */
-	if (in_atomic())
+	if (!mm || pagefault_disabled())
 		goto out_nosemaphore;
 
 	down_read(&mm->mmap_sem);
Index: linux-2.6/arch/unicore32/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/unicore32/mm/fault.c
+++ linux-2.6/arch/unicore32/mm/fault.c
@@ -225,7 +225,7 @@ static int do_pf(unsigned long addr, uns
 	 * If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm)
+	if (!mm || pagefault_disabled())
 		goto no_context;
 
 	/*
Index: linux-2.6/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault.c
+++ linux-2.6/arch/x86/mm/fault.c
@@ -1084,7 +1084,7 @@ do_page_fault(struct pt_regs *regs, unsi
 	 * If we're in an interrupt, have no user context or are running
 	 * in an atomic region then we must not take the fault:
 	 */
-	if (unlikely(in_atomic() || !mm)) {
+	if (unlikely(!mm || pagefault_disabled())) {
 		bad_area_nosemaphore(regs, error_code, address);
 		return;
 	}
Index: linux-2.6/arch/xtensa/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/xtensa/mm/fault.c
+++ linux-2.6/arch/xtensa/mm/fault.c
@@ -57,7 +57,7 @@ void do_page_fault(struct pt_regs *regs)
 	/* If we're in an interrupt or have no user
 	 * context, we must not take the fault..
 	 */
-	if (in_atomic() || !mm) {
+	if (!mm || pagefault_disabled()) {
 		bad_page_fault(regs, address, SIGSEGV);
 		return;
 	}
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -91,6 +91,7 @@ struct sched_param {
 #include <linux/latencytop.h>
 #include <linux/cred.h>
 #include <linux/llist.h>
+#include <linux/hardirq.h>
 
 #include <asm/processor.h>
 
@@ -1575,6 +1576,11 @@ struct task_struct {
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
+static inline bool pagefault_disabled(void)
+{
+	return in_atomic();
+}
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -2061,7 +2061,7 @@ size_t iov_iter_copy_from_user_atomic(st
 	char *kaddr;
 	size_t copied;
 
-	BUG_ON(!in_atomic());
+	BUG_ON(!pagefault_disabled());
 	kaddr = kmap_atomic(page, KM_USER0);
 	if (likely(i->nr_segs == 1)) {
 		int left;

