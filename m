Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab2I2UYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 16:24:49 -0400
Received: from blu0-omc4-s14.blu0.hotmail.com ([65.55.111.153]:30066 "EHLO
	blu0-omc4-s14.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297Ab2I2UYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 16:24:45 -0400
X-Originating-IP: [69.158.129.29]
X-EIP: [TnK5H3OYT5ubq/OyxCYelaJwIF+K+0U6]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP777C44DD0217ABB38501DE97810@phx.gbl>
CC: Denys Vlasenko <vda.linux@googlemail.com>, Helge Deller <deller@gmx.de>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
From: John David Anglin <dave.anglin@bell.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1348839817.2411.19.camel@dabdike.int.hansenpartnership.com>
Content-Type: multipart/mixed; boundary="Apple-Mail-1--871605220"
Subject: Re: parisc: orphaned asm/compat_signal.h file?
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sat, 29 Sep 2012 16:24:25 -0400
References: <CAK1hOcMongS_p5+oiaqE85tEVF8mv+SCm3yb-N=Zqz4Xuz_+WA@mail.gmail.com> <BLU0-SMTP54F29C73A16BAB0885137A979D0@phx.gbl> <1348839817.2411.19.camel@dabdike.int.hansenpartnership.com>
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 29 Sep 2012 20:24:42.0807 (UTC) FILETIME=[75820470:01CD9E80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail-1--871605220
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On 28-Sep-12, at 9:43 AM, James Bottomley wrote:

> On Tue, 2012-09-25 at 19:23 -0400, John David Anglin wrote:
>> On 24-Sep-12, at 8:39 AM, Denys Vlasenko wrote:
>>
>>> Maybe it needs to be removed?
>>
>> Worked for me with 3.5.4.
>
> It's probably time to tidy up all of our asm-generic code and use the
> proper infrastructure.  I thought of doing it when the word-at-a-time
> problem arose, but I forgot about it.


This is a nice cleanup.  I merged the change into my patch against
v3.5.4 for linux-stable.

Had to remove the kvm_para.h hunk because I hit this issue:
https://lkml.org/lkml/2012/6/13/226
Assume this is now fixed.

I also noticed that your cleanup  doesn't remove arch/parisc/include/ 
asm/compat_rt_sigframe.h.
Not exactly an asm-generic issue, but I believe the header is unused.

Dave
--
John David Anglin	dave.anglin@bell.net



--Apple-Mail-1--871605220
Content-Disposition: attachment;
	filename="linux-stable-3.5.4-20120929-4.d.txt"
Content-Type: text/plain; x-unix-mode=0644;
	name="linux-stable-3.5.4-20120929-4.d.txt"
Content-Transfer-Encoding: 7bit

diff --git a/arch/parisc/hpux/wrappers.S b/arch/parisc/hpux/wrappers.S
index 58c53c8..bdcea33 100644
--- a/arch/parisc/hpux/wrappers.S
+++ b/arch/parisc/hpux/wrappers.S
@@ -88,7 +88,7 @@ ENTRY(hpux_fork_wrapper)
 
 	STREG	%r2,-20(%r30)
 	ldo	64(%r30),%r30
-	STREG	%r2,PT_GR19(%r1)	;! save for child
+	STREG	%r2,PT_SYSCALL_RP(%r1)	;! save for child
 	STREG	%r30,PT_GR21(%r1)	;! save for child
 
 	LDREG	PT_GR30(%r1),%r25
@@ -132,7 +132,7 @@ ENTRY(hpux_child_return)
 	bl,n	schedule_tail, %r2
 #endif
 
-	LDREG	TASK_PT_GR19-TASK_SZ_ALGN-128(%r30),%r2
+	LDREG	TASK_PT_SYSCALL_RP-TASK_SZ_ALGN-128(%r30),%r2
 	b fork_return
 	copy %r0,%r28
 ENDPROC(hpux_child_return)
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 4383707..ec37c89 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,4 +1,7 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += pdc.h
-generic-y += word-at-a-time.h
+generic-y += word-at-a-time.h auxvec.h user.h cputime.h emergency-restart.h \
+	  segment.h topology.h vga.h device.h percpu.h hw_irq.h mutex.h \
+	  div64.h irq_regs.h kdebug.h local64.h local.h param.h \
+	  poll.h xor.h
diff --git a/arch/parisc/include/asm/auxvec.h b/arch/parisc/include/asm/auxvec.h
deleted file mode 100644
index 9c3ac4b..0000000
--- a/arch/parisc/include/asm/auxvec.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __ASMPARISC_AUXVEC_H
-#define __ASMPARISC_AUXVEC_H
-
-#endif
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index 9f21ab0..79f694f 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -115,7 +115,9 @@ flush_anon_page(struct vm_area_struct *vma, struct page *page, unsigned long vma
 {
 	if (PageAnon(page)) {
 		flush_tlb_page(vma, vmaddr);
+		preempt_disable();
 		flush_dcache_page_asm(page_to_phys(page), vmaddr);
+		preempt_enable();
 	}
 }
 
diff --git a/arch/parisc/include/asm/compat_rt_sigframe.h b/arch/parisc/include/asm/compat_rt_sigframe.h
deleted file mode 100644
index 81bec28..0000000
--- a/arch/parisc/include/asm/compat_rt_sigframe.h
+++ /dev/null
@@ -1,50 +0,0 @@
-#include<linux/compat.h>
-#include<linux/compat_siginfo.h>
-#include<asm/compat_ucontext.h>
-
-#ifndef _ASM_PARISC_COMPAT_RT_SIGFRAME_H
-#define _ASM_PARISC_COMPAT_RT_SIGFRAME_H
-
-/* In a deft move of uber-hackery, we decide to carry the top half of all
- * 64-bit registers in a non-portable, non-ABI, hidden structure.
- * Userspace can read the hidden structure if it *wants* but is never
- * guaranteed to be in the same place. Infact the uc_sigmask from the 
- * ucontext_t structure may push the hidden register file downards
- */
-struct compat_regfile {
-	/* Upper half of all the 64-bit registers that were truncated
-	   on a copy to a 32-bit userspace */
-	compat_int_t rf_gr[32];
-	compat_int_t rf_iasq[2];
-	compat_int_t rf_iaoq[2];
-	compat_int_t rf_sar;
-};
-
-#define COMPAT_SIGRETURN_TRAMP 4
-#define COMPAT_SIGRESTARTBLOCK_TRAMP 5 
-#define COMPAT_TRAMP_SIZE (COMPAT_SIGRETURN_TRAMP + COMPAT_SIGRESTARTBLOCK_TRAMP)
-
-struct compat_rt_sigframe {
-	/* XXX: Must match trampoline size in arch/parisc/kernel/signal.c 
-	        Secondary to that it must protect the ERESTART_RESTARTBLOCK
-		trampoline we left on the stack (we were bad and didn't 
-		change sp so we could run really fast.) */
-	compat_uint_t tramp[COMPAT_TRAMP_SIZE];
-	compat_siginfo_t info;
-	struct compat_ucontext uc;
-	/* Hidden location of truncated registers, *must* be last. */
-	struct compat_regfile regs; 
-};
-
-/*
- * The 32-bit ABI wants at least 48 bytes for a function call frame:
- * 16 bytes for arg0-arg3, and 32 bytes for magic (the only part of
- * which Linux/parisc uses is sp-20 for the saved return pointer...)
- * Then, the stack pointer must be rounded to a cache line (64 bytes).
- */
-#define SIGFRAME32		64
-#define FUNCTIONCALLFRAME32	48
-#define PARISC_RT_SIGFRAME_SIZE32					\
-	(((sizeof(struct compat_rt_sigframe) + FUNCTIONCALLFRAME32) + SIGFRAME32) & -SIGFRAME32)
-
-#endif
diff --git a/arch/parisc/include/asm/compat_signal.h b/arch/parisc/include/asm/compat_signal.h
deleted file mode 100644
index 6ad02c3..0000000
--- a/arch/parisc/include/asm/compat_signal.h
+++ /dev/null
@@ -1,2 +0,0 @@
-/* Use generic */
-#include <asm-generic/compat_signal.h>
diff --git a/arch/parisc/include/asm/cputime.h b/arch/parisc/include/asm/cputime.h
deleted file mode 100644
index dcdf2fb..0000000
--- a/arch/parisc/include/asm/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __PARISC_CPUTIME_H
-#define __PARISC_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* __PARISC_CPUTIME_H */
diff --git a/arch/parisc/include/asm/device.h b/arch/parisc/include/asm/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/arch/parisc/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/arch/parisc/include/asm/div64.h b/arch/parisc/include/asm/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/arch/parisc/include/asm/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/arch/parisc/include/asm/emergency-restart.h b/arch/parisc/include/asm/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/arch/parisc/include/asm/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/parisc/include/asm/hw_irq.h b/arch/parisc/include/asm/hw_irq.h
deleted file mode 100644
index 6707f7d..0000000
--- a/arch/parisc/include/asm/hw_irq.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_HW_IRQ_H
-#define _ASM_HW_IRQ_H
-
-/*
- *	linux/include/asm/hw_irq.h
- */
-
-#endif
diff --git a/arch/parisc/include/asm/irq_regs.h b/arch/parisc/include/asm/irq_regs.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/parisc/include/asm/irq_regs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/parisc/include/asm/kdebug.h b/arch/parisc/include/asm/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/arch/parisc/include/asm/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/arch/parisc/include/asm/local.h b/arch/parisc/include/asm/local.h
deleted file mode 100644
index c11c530..0000000
--- a/arch/parisc/include/asm/local.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
diff --git a/arch/parisc/include/asm/local64.h b/arch/parisc/include/asm/local64.h
deleted file mode 100644
index 36c93b5..0000000
--- a/arch/parisc/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
diff --git a/arch/parisc/include/asm/mmzone.h b/arch/parisc/include/asm/mmzone.h
index e67eb9c..31835b9 100644
--- a/arch/parisc/include/asm/mmzone.h
+++ b/arch/parisc/include/asm/mmzone.h
@@ -1,9 +1,10 @@
 #ifndef _PARISC_MMZONE_H
 #define _PARISC_MMZONE_H
 
+#define MAX_PHYSMEM_RANGES 8 /* Fix the size for now (current known max is 3) */
+
 #ifdef CONFIG_DISCONTIGMEM
 
-#define MAX_PHYSMEM_RANGES 8 /* Fix the size for now (current known max is 3) */
 extern int npmem_ranges;
 
 struct node_map_data {
@@ -60,7 +61,5 @@ static inline int pfn_valid(int pfn)
 	return 0;
 }
 
-#else /* !CONFIG_DISCONTIGMEM */
-#define MAX_PHYSMEM_RANGES 	1 
 #endif
 #endif /* _PARISC_MMZONE_H */
diff --git a/arch/parisc/include/asm/mutex.h b/arch/parisc/include/asm/mutex.h
deleted file mode 100644
index 458c1f7..0000000
--- a/arch/parisc/include/asm/mutex.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- * Pull in the generic implementation for the mutex fastpath.
- *
- * TODO: implement optimized primitives instead, or leave the generic
- * implementation in place, or pick the atomic_xchg() based generic
- * implementation. (see asm-generic/mutex-xchg.h for details)
- */
-
-#include <asm-generic/mutex-dec.h>
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index 4e0e7db..d9812d8 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -21,15 +21,27 @@
 #include <asm/types.h>
 #include <asm/cache.h>
 
-#define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
-#define copy_page(to,from)      copy_user_page_asm((void *)(to), (void *)(from))
+#define clear_page(page)	clear_page_asm((void *)(page))
+#define copy_page(to,from)	copy_page_asm((void *)(to), (void *)(from))
 
 struct page;
 
-void copy_user_page_asm(void *to, void *from);
+void clear_page_asm(void *page);
+void copy_page_asm(void *to, void *from);
+void clear_user_page(void *vto, unsigned long vaddr, struct page *pg);
 void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
 			   struct page *pg);
-void clear_user_page(void *page, unsigned long vaddr, struct page *pg);
+
+// #define CONFIG_PARISC_TMPALIAS
+
+#ifdef CONFIG_PARISC_TMPALIAS
+void clear_user_highpage(struct page *page, unsigned long vaddr);
+#define clear_user_highpage clear_user_highpage
+struct vm_area_struct;
+void copy_user_highpage(struct page *to, struct page *from,
+	unsigned long vaddr, struct vm_area_struct *vma);
+#define __HAVE_ARCH_COPY_USER_HIGHPAGE
+#endif
 
 /*
  * These are used to make use of C type-checking..
diff --git a/arch/parisc/include/asm/param.h b/arch/parisc/include/asm/param.h
deleted file mode 100644
index 965d454..0000000
--- a/arch/parisc/include/asm/param.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/param.h>
diff --git a/arch/parisc/include/asm/percpu.h b/arch/parisc/include/asm/percpu.h
deleted file mode 100644
index a0dcd19..0000000
--- a/arch/parisc/include/asm/percpu.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _PARISC_PERCPU_H
-#define _PARISC_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif 
-
diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index ee99f23..563724d 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -12,11 +12,10 @@
 
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
+#include <linux/mm_types.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 
-struct vm_area_struct;
-
 /*
  * kern_addr_valid(ADDR) tests if ADDR is pointing to valid kernel
  * memory.  For the return value to be meaningful, ADDR must be >=
@@ -40,7 +39,14 @@ struct vm_area_struct;
         do{                                                     \
                 *(pteptr) = (pteval);                           \
         } while(0)
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
+
+extern void purge_tlb_entries(struct mm_struct *, unsigned long);
+
+#define set_pte_at(mm,addr,ptep, pteval)                        \
+        do{                                                     \
+                set_pte(ptep,pteval);                           \
+                purge_tlb_entries(mm,addr);                     \
+        } while(0)
 
 #endif /* !__ASSEMBLY__ */
 
@@ -462,10 +468,13 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 #ifdef CONFIG_SMP
 	unsigned long new, old;
 
+	/* ??? This might be racy because the page table updates in
+	   entry.S don't use the same lock.  */
 	do {
 		old = pte_val(*ptep);
 		new = pte_val(pte_wrprotect(__pte (old)));
 	} while (cmpxchg((unsigned long *) ptep, old, new) != old);
+	purge_tlb_entries(mm, addr);
 #else
 	pte_t old_pte = *ptep;
 	set_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
diff --git a/arch/parisc/include/asm/poll.h b/arch/parisc/include/asm/poll.h
deleted file mode 100644
index c98509d..0000000
--- a/arch/parisc/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/poll.h>
diff --git a/arch/parisc/include/asm/real.h b/arch/parisc/include/asm/real.h
deleted file mode 100644
index 82acb25..0000000
--- a/arch/parisc/include/asm/real.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#ifndef _PARISC_REAL_H
-#define _PARISC_REAL_H
-
-
-#endif
diff --git a/arch/parisc/include/asm/segment.h b/arch/parisc/include/asm/segment.h
deleted file mode 100644
index 26794dd..0000000
--- a/arch/parisc/include/asm/segment.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __PARISC_SEGMENT_H
-#define __PARISC_SEGMENT_H
-
-/* Only here because we have some old header files that expect it.. */
-
-#endif
diff --git a/arch/parisc/include/asm/topology.h b/arch/parisc/include/asm/topology.h
deleted file mode 100644
index d8133eb..0000000
--- a/arch/parisc/include/asm/topology.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_PARISC_TOPOLOGY_H
-#define _ASM_PARISC_TOPOLOGY_H
-
-#include <asm-generic/topology.h>
-
-#endif /* _ASM_PARISC_TOPOLOGY_H */
diff --git a/arch/parisc/include/asm/user.h b/arch/parisc/include/asm/user.h
deleted file mode 100644
index 8022475..0000000
--- a/arch/parisc/include/asm/user.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* This file should not exist, but lots of generic code still includes
-   it. It's a hangover from old a.out days and the traditional core
-   dump format.  We are ELF-only, and so are our core dumps.  If we
-   need to support HP/UX core format then we'll do it here
-   eventually. */
diff --git a/arch/parisc/include/asm/vga.h b/arch/parisc/include/asm/vga.h
deleted file mode 100644
index 171399a..0000000
--- a/arch/parisc/include/asm/vga.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_PARISC_VGA_H__
-#define __ASM_PARISC_VGA_H__
-
-/* nothing */
-
-#endif /* __ASM_PARISC_VGA_H__ */
diff --git a/arch/parisc/include/asm/xor.h b/arch/parisc/include/asm/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/arch/parisc/include/asm/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/arch/parisc/kernel/asm-offsets.c b/arch/parisc/kernel/asm-offsets.c
index dcd5510..5df1597 100644
--- a/arch/parisc/kernel/asm-offsets.c
+++ b/arch/parisc/kernel/asm-offsets.c
@@ -141,6 +141,7 @@ int main(void)
 	DEFINE(TASK_PT_IAOQ0, offsetof(struct task_struct, thread.regs.iaoq[0]));
 	DEFINE(TASK_PT_IAOQ1, offsetof(struct task_struct, thread.regs.iaoq[1]));
 	DEFINE(TASK_PT_CR27, offsetof(struct task_struct, thread.regs.cr27));
+	DEFINE(TASK_PT_SYSCALL_RP, offsetof(struct task_struct, thread.regs.pad0));
 	DEFINE(TASK_PT_ORIG_R28, offsetof(struct task_struct, thread.regs.orig_r28));
 	DEFINE(TASK_PT_KSP, offsetof(struct task_struct, thread.regs.ksp));
 	DEFINE(TASK_PT_KPC, offsetof(struct task_struct, thread.regs.kpc));
@@ -230,6 +231,7 @@ int main(void)
 	DEFINE(PT_IAOQ0, offsetof(struct pt_regs, iaoq[0]));
 	DEFINE(PT_IAOQ1, offsetof(struct pt_regs, iaoq[1]));
 	DEFINE(PT_CR27, offsetof(struct pt_regs, cr27));
+	DEFINE(PT_SYSCALL_RP, offsetof(struct pt_regs, pad0));
 	DEFINE(PT_ORIG_R28, offsetof(struct pt_regs, orig_r28));
 	DEFINE(PT_KSP, offsetof(struct pt_regs, ksp));
 	DEFINE(PT_KPC, offsetof(struct pt_regs, kpc));
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 9d18189..795d392 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -267,9 +267,11 @@ static inline void
 __flush_cache_page(struct vm_area_struct *vma, unsigned long vmaddr,
 		   unsigned long physaddr)
 {
+	preempt_disable();
 	flush_dcache_page_asm(physaddr, vmaddr);
 	if (vma->vm_flags & VM_EXEC)
 		flush_icache_page_asm(physaddr, vmaddr);
+	preempt_enable();
 }
 
 void flush_dcache_page(struct page *page)
@@ -315,7 +317,7 @@ void flush_dcache_page(struct page *page)
 		flush_tlb_page(mpnt, addr);
 		if (old_addr == 0 || (old_addr & (SHMLBA - 1)) != (addr & (SHMLBA - 1))) {
 			__flush_cache_page(mpnt, addr, page_to_phys(page));
-			if (old_addr)
+			if (old_addr && parisc_requires_coherency())
 				printk(KERN_ERR "INEQUIVALENT ALIASES 0x%lx and 0x%lx in file %s\n", old_addr, addr, mpnt->vm_file ? (char *)mpnt->vm_file->f_path.dentry->d_name.name : "(null)");
 			old_addr = addr;
 		}
@@ -330,17 +332,6 @@ EXPORT_SYMBOL(flush_kernel_dcache_page_asm);
 EXPORT_SYMBOL(flush_data_cache_local);
 EXPORT_SYMBOL(flush_kernel_icache_range_asm);
 
-void clear_user_page_asm(void *page, unsigned long vaddr)
-{
-	unsigned long flags;
-	/* This function is implemented in assembly in pacache.S */
-	extern void __clear_user_page_asm(void *page, unsigned long vaddr);
-
-	purge_tlb_start(flags);
-	__clear_user_page_asm(page, vaddr);
-	purge_tlb_end(flags);
-}
-
 #define FLUSH_THRESHOLD 0x80000 /* 0.5MB */
 int parisc_cache_flush_threshold __read_mostly = FLUSH_THRESHOLD;
 
@@ -374,20 +365,9 @@ void __init parisc_setup_cache_timing(void)
 	printk(KERN_INFO "Setting cache flush threshold to %x (%d CPUs online)\n", parisc_cache_flush_threshold, num_online_cpus());
 }
 
-extern void purge_kernel_dcache_page(unsigned long);
-extern void clear_user_page_asm(void *page, unsigned long vaddr);
-
-void clear_user_page(void *page, unsigned long vaddr, struct page *pg)
-{
-	unsigned long flags;
-
-	purge_kernel_dcache_page((unsigned long)page);
-	purge_tlb_start(flags);
-	pdtlb_kernel(page);
-	purge_tlb_end(flags);
-	clear_user_page_asm(page, vaddr);
-}
-EXPORT_SYMBOL(clear_user_page);
+extern void purge_kernel_dcache_page_asm(unsigned long);
+extern void clear_user_page_asm(void *, unsigned long);
+extern void copy_user_page_asm(void *, void *, unsigned long);
 
 void flush_kernel_dcache_page_addr(void *addr)
 {
@@ -400,11 +380,26 @@ void flush_kernel_dcache_page_addr(void *addr)
 }
 EXPORT_SYMBOL(flush_kernel_dcache_page_addr);
 
+void clear_user_page(void *vto, unsigned long vaddr, struct page *page)
+{
+	clear_page_asm(vto);
+	if (!parisc_requires_coherency())
+		flush_kernel_dcache_page_asm(vto);
+}
+EXPORT_SYMBOL(clear_user_page);
+
 void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
-		    struct page *pg)
+	struct page *pg)
 {
-	/* no coherency needed (all in kmap/kunmap) */
-	copy_user_page_asm(vto, vfrom);
+	/* Copy using kernel mapping.  No coherency is needed
+	   (all in kmap/kunmap) on machines that don't support
+	   non-equivalent aliasing.  However, the `from' page
+	   needs to be flushed before it can be accessed through
+	   the kernel mapping. */
+	preempt_disable();
+	flush_dcache_page_asm(__pa(vfrom), vaddr);
+	preempt_enable();
+	copy_page_asm(vto, vfrom);
 	if (!parisc_requires_coherency())
 		flush_kernel_dcache_page_asm(vto);
 }
@@ -420,6 +415,25 @@ void kunmap_parisc(void *addr)
 EXPORT_SYMBOL(kunmap_parisc);
 #endif
 
+void purge_tlb_entries(struct mm_struct *mm, unsigned long addr)
+{
+	unsigned long flags, sid;
+
+	/* Note: purge_tlb_entries can be called at startup with
+	   no context.  */
+
+	/* Disable preemption while we play with %sr1.  */
+	preempt_disable();
+	sid = mfsp(1);
+	mtsp(mm->context,1);
+	purge_tlb_start(flags);
+	pdtlb(addr);
+	pitlb(addr);
+	purge_tlb_end(flags);
+	mtsp(sid,1);
+	preempt_enable();
+}
+
 void __flush_tlb_range(unsigned long sid, unsigned long start,
 		       unsigned long end)
 {
@@ -459,8 +473,65 @@ void flush_cache_all(void)
 	on_each_cpu(cacheflush_h_tmp_function, NULL, 1);
 }
 
+static inline unsigned long mm_total_size(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+	unsigned long usize = 0;
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		usize += vma->vm_end - vma->vm_start;
+	return usize;
+}
+
+static inline pte_t *get_ptep(pgd_t *pgd, unsigned long addr)
+{
+	pte_t *ptep = NULL;
+
+        if (!pgd_none(*pgd)) {
+                pud_t *pud = pud_offset(pgd, addr);
+                if (!pud_none(*pud)) {
+                        pmd_t *pmd = pmd_offset(pud, addr);
+                        if (!pmd_none(*pmd)) {
+                                ptep = pte_offset_map(pmd, addr);
+                        }
+                }
+        }
+	return ptep;
+}
+
 void flush_cache_mm(struct mm_struct *mm)
 {
+	/* Flushing the whole cache on each cpu takes forever on
+	   rp3440, etc.  So, avoid it if the mm isn't too big.
+	   Note: This approach is faster than a range flush when the
+	   context is current, and it works even when non current.  */
+	if (mm_total_size(mm) < parisc_cache_flush_threshold) {
+		struct vm_area_struct *vma;
+
+		if (mm->context == mfsp(3)) {
+			for (vma = mm->mmap; vma; vma = vma->vm_next) {
+				flush_user_dcache_range_asm(vma->vm_start, vma->vm_end);
+				if(vma->vm_flags & VM_EXEC)
+					flush_user_icache_range_asm(vma->vm_start, vma->vm_end);
+			}
+		} else {
+			pgd_t *pgd = mm->pgd;
+
+			for (vma = mm->mmap; vma; vma = vma->vm_next) {
+				unsigned long addr;
+
+				for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
+					pte_t *ptep = get_ptep(pgd, addr);
+					if (ptep != NULL) {
+						pte_t pte = *ptep;
+						__flush_cache_page(vma, addr, page_to_phys(pte_page(pte)));
+					}
+				}
+			}
+		}
+		return;
+	}
+
 #ifdef CONFIG_SMP
 	flush_cache_all();
 #else
@@ -486,20 +557,34 @@ flush_user_icache_range(unsigned long start, unsigned long end)
 		flush_instruction_cache();
 }
 
-
 void flush_cache_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end)
 {
-	int sr3;
-
 	BUG_ON(!vma->vm_mm->context);
 
-	sr3 = mfsp(3);
-	if (vma->vm_mm->context == sr3) {
-		flush_user_dcache_range(start,end);
-		flush_user_icache_range(start,end);
+	if ((end - start) < parisc_cache_flush_threshold) {
+		if (vma->vm_mm->context == mfsp(3)) {
+			flush_user_dcache_range_asm(start,end);
+			if(vma->vm_flags & VM_EXEC)
+				flush_user_icache_range_asm(start,end);
+		} else {
+			unsigned long addr;
+			pgd_t *pgd = vma->vm_mm->pgd;
+
+			for (addr = start & PAGE_MASK; addr < end; addr += PAGE_SIZE) {
+				pte_t *ptep = get_ptep(pgd, addr);
+				if (ptep != NULL) {
+					pte_t pte = *ptep;
+					flush_cache_page(vma, addr, pte_pfn(pte));
+				}
+			}
+		}
 	} else {
+#ifdef CONFIG_SMP
 		flush_cache_all();
+#else
+		flush_cache_all_local();
+#endif
 	}
 }
 
@@ -512,3 +597,67 @@ flush_cache_page(struct vm_area_struct *vma, unsigned long vmaddr, unsigned long
 	__flush_cache_page(vma, vmaddr, page_to_phys(pfn_to_page(pfn)));
 
 }
+
+#ifdef CONFIG_PARISC_TMPALIAS
+
+void clear_user_highpage(struct page *page, unsigned long vaddr)
+{
+	void *vto;
+	unsigned long flags;
+
+	/* Clear using TMPALIAS region.  The page doesn't need to
+	   be flushed but the kernel mapping needs to be purged.  */
+
+	vto = kmap_atomic(page, KM_USER0);
+
+	/* The PA-RISC 2.0 Architecture book states on page F-6:
+	   "Before a write-capable translation is enabled, *all*
+	   non-equivalently-aliased translations must be removed
+	   from the page table and purged from the TLB.  (Note
+	   that the caches are not required to be flushed at this
+	   time.)  Before any non-equivalent aliased translation
+	   is re-enabled, the virtual address range for the writeable
+	   page (the entire page) must be flushed from the cache,
+	   and the write-capable translation removed from the page
+	   table and purged from the TLB."  */
+
+	purge_kernel_dcache_page_asm((unsigned long)vto);
+	purge_tlb_start(flags);
+	pdtlb_kernel(vto);
+	purge_tlb_end(flags);
+	preempt_disable();
+	clear_user_page_asm(vto, vaddr);
+	preempt_enable();
+
+	pagefault_enable();		/* kunmap_atomic(addr, KM_USER0); */
+}
+
+void copy_user_highpage(struct page *to, struct page *from,
+	unsigned long vaddr, struct vm_area_struct *vma)
+{
+	void *vfrom, *vto;
+	unsigned long flags;
+
+	/* Copy using TMPALIAS region.  This has the advantage
+	   that the `from' page doesn't need to be flushed.  However,
+	   the `to' page must be flushed in copy_user_page_asm since
+	   it can be used to bring in executable code.  */
+
+	vfrom = kmap_atomic(from, KM_USER0);
+	vto = kmap_atomic(to, KM_USER1);
+
+	purge_kernel_dcache_page_asm((unsigned long)vto);
+	purge_tlb_start(flags);
+	pdtlb_kernel(vto);
+	pdtlb_kernel(vfrom);
+	purge_tlb_end(flags);
+	preempt_disable();
+	copy_user_page_asm(vto, vfrom, vaddr);
+	flush_dcache_page_asm(__pa(vto), vaddr);
+	preempt_enable();
+
+	pagefault_enable();		/* kunmap_atomic(addr, KM_USER1); */
+	pagefault_enable();		/* kunmap_atomic(addr, KM_USER0); */
+}
+
+#endif /* CONFIG_PARISC_TMPALIAS */
diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 18670a0..fcef82d 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -483,7 +483,7 @@
 	 * B <-> _PAGE_DMB (memory break)
 	 *
 	 * Then incredible subtlety: The access rights are
-	 * _PAGE_GATEWAY _PAGE_EXEC _PAGE_READ
+	 * _PAGE_GATEWAY, _PAGE_EXEC and _PAGE_WRITE
 	 * See 3-14 of the parisc 2.0 manual
 	 *
 	 * Finally, _PAGE_READ goes in the top bit of PL1 (so we
@@ -493,7 +493,7 @@
 
 	/* PAGE_USER indicates the page can be read with user privileges,
 	 * so deposit X1|11 to PL1|PL2 (remember the upper bit of PL1
-	 * contains _PAGE_READ */
+	 * contains _PAGE_READ) */
 	extrd,u,*=      \pte,_PAGE_USER_BIT+32,1,%r0
 	depdi		7,11,3,\prot
 	/* If we're a gateway page, drop PL2 back to zero for promotion
@@ -1785,9 +1785,9 @@ ENTRY(sys_fork_wrapper)
 	ldo	-16(%r30),%r29		/* Reference param save area */
 #endif
 
-	/* These are call-clobbered registers and therefore
-	   also syscall-clobbered (we hope). */
-	STREG	%r2,PT_GR19(%r1)	/* save for child */
+	STREG	%r2,PT_SYSCALL_RP(%r1)	/* save for child */
+
+	/* WARNING - Clobbers r21, userspace must save! */
 	STREG	%r30,PT_GR21(%r1)
 
 	LDREG	PT_GR30(%r1),%r25
@@ -1817,7 +1817,7 @@ ENTRY(child_return)
 	nop
 
 	LDREG	TI_TASK-THREAD_SZ_ALGN-FRAME_SIZE-FRAME_SIZE(%r30), %r1
-	LDREG	TASK_PT_GR19(%r1),%r2
+	LDREG	TASK_PT_SYSCALL_RP(%r1),%r2
 	b	wrapper_exit
 	copy	%r0,%r28
 ENDPROC(child_return)
@@ -1836,8 +1836,9 @@ ENTRY(sys_clone_wrapper)
 	ldo	-16(%r30),%r29		/* Reference param save area */
 #endif
 
-	/* WARNING - Clobbers r19 and r21, userspace must save these! */
-	STREG	%r2,PT_GR19(%r1)	/* save for child */
+	STREG	%r2,PT_SYSCALL_RP(%r1)	/* save for child */
+
+	/* WARNING - Clobbers r21, userspace must save! */
 	STREG	%r30,PT_GR21(%r1)
 	BL	sys_clone,%r2
 	copy	%r1,%r24
@@ -1860,7 +1861,7 @@ ENTRY(sys_vfork_wrapper)
 	ldo	-16(%r30),%r29		/* Reference param save area */
 #endif
 
-	STREG	%r2,PT_GR19(%r1)	/* save for child */
+	STREG	%r2,PT_SYSCALL_RP(%r1)	/* save for child */
 	STREG	%r30,PT_GR21(%r1)
 
 	BL	sys_vfork,%r2
diff --git a/arch/parisc/kernel/inventory.c b/arch/parisc/kernel/inventory.c
index 08324aa..3295ef4 100644
--- a/arch/parisc/kernel/inventory.c
+++ b/arch/parisc/kernel/inventory.c
@@ -186,12 +186,14 @@ pat_query_module(ulong pcell_loc, ulong mod_index)
 
 	if (status != PDC_OK) {
 		/* no more cell modules or error */
+		kfree(pa_pdc_cell);
 		return status;
 	}
 
 	temp = pa_pdc_cell->cba;
 	dev = alloc_pa_dev(PAT_GET_CBA(temp), &(pa_pdc_cell->mod_path));
 	if (!dev) {
+		kfree(pa_pdc_cell);
 		return PDC_OK;
 	}
 
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index c0b1aff..8094d3e 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -379,14 +379,14 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 static struct irqaction timer_action = {
 	.handler = timer_interrupt,
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
+	.flags = IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
 };
 
 #ifdef CONFIG_SMP
 static struct irqaction ipi_action = {
 	.handler = ipi_interrupt,
 	.name = "IPI",
-	.flags = IRQF_DISABLED | IRQF_PERCPU,
+	.flags = IRQF_PERCPU,
 };
 #endif
 
@@ -410,11 +410,13 @@ void __init init_IRQ(void)
 {
 	local_irq_disable();	/* PARANOID - should already be disabled */
 	mtctl(~0UL, 23);	/* EIRR : clear all pending external intr */
-	claim_cpu_irqs();
 #ifdef CONFIG_SMP
-	if (!cpu_eiem)
+	if (!cpu_eiem) {
+		claim_cpu_irqs();
 		cpu_eiem = EIEM_MASK(IPI_IRQ) | EIEM_MASK(TIMER_IRQ);
+	}
 #else
+	claim_cpu_irqs();
 	cpu_eiem = EIEM_MASK(TIMER_IRQ);
 #endif
         set_eiem(cpu_eiem);	/* EIEM : enable all external intr */
diff --git a/arch/parisc/kernel/pacache.S b/arch/parisc/kernel/pacache.S
index 5d7218a..ed401dd 100644
--- a/arch/parisc/kernel/pacache.S
+++ b/arch/parisc/kernel/pacache.S
@@ -199,7 +199,6 @@ ENTRY(flush_instruction_cache_local)
 	.callinfo NO_CALLS
 	.entry
 
-	mtsp		%r0, %sr1
 	load32		cache_info, %r1
 
 	/* Flush Instruction Cache */
@@ -208,20 +207,46 @@ ENTRY(flush_instruction_cache_local)
 	LDREG		ICACHE_STRIDE(%r1), %arg1
 	LDREG		ICACHE_COUNT(%r1), %arg2
 	LDREG		ICACHE_LOOP(%r1), %arg3
-	rsm             PSW_SM_I, %r22		/* No mmgt ops during loop*/
+	rsm		PSW_SM_I, %r22		/* No mmgt ops during loop*/
 	addib,COND(=)		-1, %arg3, fioneloop	/* Preadjust and test */
 	movb,<,n	%arg3, %r31, fisync	/* If loop < 0, do sync */
 
 fimanyloop:					/* Loop if LOOP >= 2 */
 	addib,COND(>)		-1, %r31, fimanyloop	/* Adjusted inner loop decr */
-	fice            %r0(%sr1, %arg0)
-	fice,m		%arg1(%sr1, %arg0)	/* Last fice and addr adjust */
+	fice            %r0(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)	/* Last fice and addr adjust */
 	movb,tr		%arg3, %r31, fimanyloop	/* Re-init inner loop count */
 	addib,COND(<=),n	-1, %arg2, fisync	/* Outer loop decr */
 
 fioneloop:					/* Loop if LOOP = 1 */
-	addib,COND(>)		-1, %arg2, fioneloop	/* Outer loop count decr */
-	fice,m		%arg1(%sr1, %arg0)	/* Fice for one loop */
+	/* Some implementations may flush with a single fice instruction */
+	cmpib,COND(>>=),n	15, %arg2, fioneloop2
+
+fioneloop1:
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	fice,m		%arg1(%sr4, %arg0)
+	addib,COND(>)	-16, %arg2, fioneloop1
+	fice,m		%arg1(%sr4, %arg0)
+
+	/* Check if done */
+	cmpb,COND(=),n	%arg2, %r0, fisync	/* Predict branch taken */
+
+fioneloop2:
+	addib,COND(>)	-1, %arg2, fioneloop2	/* Outer loop count decr */
+	fice,m		%arg1(%sr4, %arg0)	/* Fice for one loop */
 
 fisync:
 	sync
@@ -240,8 +265,7 @@ ENTRY(flush_data_cache_local)
 	.callinfo NO_CALLS
 	.entry
 
-	mtsp		%r0, %sr1
-	load32 		cache_info, %r1
+	load32		cache_info, %r1
 
 	/* Flush Data Cache */
 
@@ -249,20 +273,46 @@ ENTRY(flush_data_cache_local)
 	LDREG		DCACHE_STRIDE(%r1), %arg1
 	LDREG		DCACHE_COUNT(%r1), %arg2
 	LDREG		DCACHE_LOOP(%r1), %arg3
-	rsm		PSW_SM_I, %r22
+	rsm		PSW_SM_I, %r22		/* No mmgt ops during loop*/
 	addib,COND(=)		-1, %arg3, fdoneloop	/* Preadjust and test */
 	movb,<,n	%arg3, %r31, fdsync	/* If loop < 0, do sync */
 
 fdmanyloop:					/* Loop if LOOP >= 2 */
 	addib,COND(>)		-1, %r31, fdmanyloop	/* Adjusted inner loop decr */
-	fdce		%r0(%sr1, %arg0)
-	fdce,m		%arg1(%sr1, %arg0)	/* Last fdce and addr adjust */
+	fdce		%r0(%arg0)
+	fdce,m		%arg1(%arg0)	/* Last fdce and addr adjust */
 	movb,tr		%arg3, %r31, fdmanyloop	/* Re-init inner loop count */
 	addib,COND(<=),n	-1, %arg2, fdsync	/* Outer loop decr */
 
 fdoneloop:					/* Loop if LOOP = 1 */
-	addib,COND(>)		-1, %arg2, fdoneloop	/* Outer loop count decr */
-	fdce,m		%arg1(%sr1, %arg0)	/* Fdce for one loop */
+	/* Some implementations may flush with a single fdce instruction */
+	cmpib,COND(>>=),n	15, %arg2, fdoneloop2
+
+fdoneloop1:
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	fdce,m		%arg1(%arg0)
+	addib,COND(>)	-16, %arg2, fdoneloop1
+	fdce,m		%arg1(%arg0)
+
+	/* Check if done */
+	cmpb,COND(=),n	%arg2, %r0, fdsync	/* Predict branch taken */
+
+fdoneloop2:
+	addib,COND(>)	-1, %arg2, fdoneloop2	/* Outer loop count decr */
+	fdce,m		%arg1(%arg0)	/* Fdce for one loop */
 
 fdsync:
 	syncdma
@@ -277,7 +327,104 @@ ENDPROC(flush_data_cache_local)
 
 	.align	16
 
-ENTRY(copy_user_page_asm)
+/* Macros to serialize TLB purge operations on SMP.  */
+
+	.macro	tlb_lock	la,flags,tmp
+#ifdef CONFIG_SMP
+	ldil		L%pa_tlb_lock,%r1
+	ldo		R%pa_tlb_lock(%r1),\la
+	rsm		PSW_SM_I,\flags
+1:	LDCW		0(\la),\tmp
+	cmpib,<>,n	0,\tmp,3f
+2:	ldw		0(\la),\tmp
+	cmpb,<>		%r0,\tmp,1b
+	nop
+	b,n		2b
+3:
+#endif
+	.endm
+
+	.macro	tlb_unlock	la,flags,tmp
+#ifdef CONFIG_SMP
+	ldi		1,\tmp
+	stw		\tmp,0(\la)
+	mtsm		\flags
+#endif
+	.endm
+
+/* Clear page using kernel mapping.  */
+
+ENTRY(clear_page_asm)
+	.proc
+	.callinfo NO_CALLS
+	.entry
+
+#ifdef CONFIG_64BIT
+
+	/* Unroll the loop.  */
+	ldi		(PAGE_SIZE / 128), %r1
+
+1:
+	std		%r0, 0(%r26)
+	std		%r0, 8(%r26)
+	std		%r0, 16(%r26)
+	std		%r0, 24(%r26)
+	std		%r0, 32(%r26)
+	std		%r0, 40(%r26)
+	std		%r0, 48(%r26)
+	std		%r0, 56(%r26)
+	std		%r0, 64(%r26)
+	std		%r0, 72(%r26)
+	std		%r0, 80(%r26)
+	std		%r0, 88(%r26)
+	std		%r0, 96(%r26)
+	std		%r0, 104(%r26)
+	std		%r0, 112(%r26)
+	std		%r0, 120(%r26)
+
+	/* Note reverse branch hint for addib is taken.  */
+	addib,COND(>),n	-1, %r1, 1b
+	ldo		128(%r26), %r26
+
+#else
+
+	/*
+	 * Note that until (if) we start saving the full 64-bit register
+	 * values on interrupt, we can't use std on a 32 bit kernel.
+	 */
+	ldi		(PAGE_SIZE / 64), %r1
+
+1:
+	stw		%r0, 0(%r26)
+	stw		%r0, 4(%r26)
+	stw		%r0, 8(%r26)
+	stw		%r0, 12(%r26)
+	stw		%r0, 16(%r26)
+	stw		%r0, 20(%r26)
+	stw		%r0, 24(%r26)
+	stw		%r0, 28(%r26)
+	stw		%r0, 32(%r26)
+	stw		%r0, 36(%r26)
+	stw		%r0, 40(%r26)
+	stw		%r0, 44(%r26)
+	stw		%r0, 48(%r26)
+	stw		%r0, 52(%r26)
+	stw		%r0, 56(%r26)
+	stw		%r0, 60(%r26)
+
+	addib,COND(>),n	-1, %r1, 1b
+	ldo		64(%r26), %r26
+#endif
+	bv		%r0(%r2)
+	nop
+	.exit
+
+	.procend
+ENDPROC(clear_page_asm)
+
+/* Copy page using kernel mapping.  */
+
+ENTRY(copy_page_asm)
 	.proc
 	.callinfo NO_CALLS
 	.entry
@@ -285,18 +432,14 @@ ENTRY(copy_user_page_asm)
 #ifdef CONFIG_64BIT
 	/* PA8x00 CPUs can consume 2 loads or 1 store per cycle.
 	 * Unroll the loop by hand and arrange insn appropriately.
-	 * GCC probably can do this just as well.
+	 * Prefetch doesn't improve performance on rp3440.
+	 * GCC probably can do this just as well...
 	 */
 
-	ldd		0(%r25), %r19
 	ldi		(PAGE_SIZE / 128), %r1
 
-	ldw		64(%r25), %r0		/* prefetch 1 cacheline ahead */
-	ldw		128(%r25), %r0		/* prefetch 2 */
-
-1:	ldd		8(%r25), %r20
-	ldw		192(%r25), %r0		/* prefetch 3 */
-	ldw		256(%r25), %r0		/* prefetch 4 */
+1:	ldd		0(%r25), %r19
+	ldd		8(%r25), %r20
 
 	ldd		16(%r25), %r21
 	ldd		24(%r25), %r22
@@ -330,20 +473,16 @@ ENTRY(copy_user_page_asm)
 
 	ldd		112(%r25), %r21
 	ldd		120(%r25), %r22
+	ldo		128(%r25), %r25
 	std		%r19, 96(%r26)
 	std		%r20, 104(%r26)
 
-	ldo		128(%r25), %r25
 	std		%r21, 112(%r26)
 	std		%r22, 120(%r26)
-	ldo		128(%r26), %r26
 
-	/* conditional branches nullify on forward taken branch, and on
-	 * non-taken backward branch. Note that .+4 is a backwards branch.
-	 * The ldd should only get executed if the branch is taken.
-	 */
-	addib,COND(>),n	-1, %r1, 1b		/* bundle 10 */
-	ldd		0(%r25), %r19		/* start next loads */
+	/* Note reverse branch hint for addib is taken.  */
+	addib,COND(>),n	-1, %r1, 1b
+	ldo		128(%r26), %r26
 
 #else
 
@@ -399,7 +538,7 @@ ENTRY(copy_user_page_asm)
 	.exit
 
 	.procend
-ENDPROC(copy_user_page_asm)
+ENDPROC(copy_page_asm)
 
 /*
  * NOTE: Code in clear_user_page has a hard coded dependency on the
@@ -422,8 +561,6 @@ ENDPROC(copy_user_page_asm)
  *          %r23 physical page (shifted for tlb insert) of "from" translation
  */
 
-#if 0
-
 	/*
 	 * We can't do this since copy_user_page is used to bring in
 	 * file data that might have instructions. Since the data would
@@ -435,6 +572,7 @@ ENDPROC(copy_user_page_asm)
 	 * use it if more information is passed into copy_user_page().
 	 * Have to do some measurements to see if it is worthwhile to
 	 * lobby for such a change.
+	 *
 	 */
 
 ENTRY(copy_user_page_asm)
@@ -442,16 +580,21 @@ ENTRY(copy_user_page_asm)
 	.callinfo NO_CALLS
 	.entry
 
+	/* Convert virtual `to' and `from' addresses to physical addresses.
+	   Move `from' physical address to non shadowed register.  */
 	ldil		L%(__PAGE_OFFSET), %r1
 	sub		%r26, %r1, %r26
-	sub		%r25, %r1, %r23		/* move physical addr into non shadowed reg */
+	sub		%r25, %r1, %r23
 
 	ldil		L%(TMPALIAS_MAP_START), %r28
 	/* FIXME for different page sizes != 4k */
 #ifdef CONFIG_64BIT
-	extrd,u		%r26,56,32, %r26		/* convert phys addr to tlb insert format */
-	extrd,u		%r23,56,32, %r23		/* convert phys addr to tlb insert format */
-	depd		%r24,63,22, %r28		/* Form aliased virtual address 'to' */
+#if (TMPALIAS_MAP_START >= 0x80000000)
+	depdi		0, 31,32, %r28		/* clear any sign extension */
+#endif
+	extrd,u		%r26,56,32, %r26	/* convert phys addr to tlb insert format */
+	extrd,u		%r23,56,32, %r23	/* convert phys addr to tlb insert format */
+	depd		%r24,63,22, %r28	/* Form aliased virtual address 'to' */
 	depdi		0, 63,12, %r28		/* Clear any offset bits */
 	copy		%r28, %r29
 	depdi		1, 41,1, %r29		/* Form aliased virtual address 'from' */
@@ -466,10 +609,76 @@ ENTRY(copy_user_page_asm)
 
 	/* Purge any old translations */
 
+#ifdef CONFIG_PA20
+	pdtlb,l		0(%r28)
+	pdtlb,l		0(%r29)
+#else
+	tlb_lock	%r20,%r21,%r22
 	pdtlb		0(%r28)
 	pdtlb		0(%r29)
+	tlb_unlock	%r20,%r21,%r22
+#endif
 
-	ldi		64, %r1
+#ifdef CONFIG_64BIT
+	/* PA8x00 CPUs can consume 2 loads or 1 store per cycle.
+	 * Unroll the loop by hand and arrange insn appropriately.
+	 * GCC probably can do this just as well.
+	 */
+
+	ldd		0(%r29), %r19
+	ldi		(PAGE_SIZE / 128), %r1
+
+1:	ldd		8(%r29), %r20
+
+	ldd		16(%r29), %r21
+	ldd		24(%r29), %r22
+	std		%r19, 0(%r28)
+	std		%r20, 8(%r28)
+
+	ldd		32(%r29), %r19
+	ldd		40(%r29), %r20
+	std		%r21, 16(%r28)
+	std		%r22, 24(%r28)
+
+	ldd		48(%r29), %r21
+	ldd		56(%r29), %r22
+	std		%r19, 32(%r28)
+	std		%r20, 40(%r28)
+
+	ldd		64(%r29), %r19
+	ldd		72(%r29), %r20
+	std		%r21, 48(%r28)
+	std		%r22, 56(%r28)
+
+	ldd		80(%r29), %r21
+	ldd		88(%r29), %r22
+	std		%r19, 64(%r28)
+	std		%r20, 72(%r28)
+
+	ldd		 96(%r29), %r19
+	ldd		104(%r29), %r20
+	std		%r21, 80(%r28)
+	std		%r22, 88(%r28)
+
+	ldd		112(%r29), %r21
+	ldd		120(%r29), %r22
+	std		%r19, 96(%r28)
+	std		%r20, 104(%r28)
+
+	ldo		128(%r29), %r29
+	std		%r21, 112(%r28)
+	std		%r22, 120(%r28)
+	ldo		128(%r28), %r28
+
+	/* conditional branches nullify on forward taken branch, and on
+	 * non-taken backward branch. Note that .+4 is a backwards branch.
+	 * The ldd should only get executed if the branch is taken.
+	 */
+	addib,COND(>),n	-1, %r1, 1b		/* bundle 10 */
+	ldd		0(%r29), %r19		/* start next loads */
+
+#else
+	ldi		(PAGE_SIZE / 64), %r1
 
 	/*
 	 * This loop is optimized for PCXL/PCXL2 ldw/ldw and stw/stw
@@ -480,9 +689,7 @@ ENTRY(copy_user_page_asm)
 	 * use ldd/std on a 32 bit kernel.
 	 */
 
-
-1:
-	ldw		0(%r29), %r19
+1:	ldw		0(%r29), %r19
 	ldw		4(%r29), %r20
 	ldw		8(%r29), %r21
 	ldw		12(%r29), %r22
@@ -515,8 +722,10 @@ ENTRY(copy_user_page_asm)
 	stw		%r21, 56(%r28)
 	stw		%r22, 60(%r28)
 	ldo		64(%r28), %r28
+
 	addib,COND(>)		-1, %r1,1b
 	ldo		64(%r29), %r29
+#endif
 
 	bv		%r0(%r2)
 	nop
@@ -524,9 +733,8 @@ ENTRY(copy_user_page_asm)
 
 	.procend
 ENDPROC(copy_user_page_asm)
-#endif
 
-ENTRY(__clear_user_page_asm)
+ENTRY(clear_user_page_asm)
 	.proc
 	.callinfo NO_CALLS
 	.entry
@@ -550,7 +758,13 @@ ENTRY(__clear_user_page_asm)
 
 	/* Purge any old translation */
 
+#ifdef CONFIG_PA20
+	pdtlb,l		0(%r28)
+#else
+	tlb_lock	%r20,%r21,%r22
 	pdtlb		0(%r28)
+	tlb_unlock	%r20,%r21,%r22
+#endif
 
 #ifdef CONFIG_64BIT
 	ldi		(PAGE_SIZE / 128), %r1
@@ -580,8 +794,7 @@ ENTRY(__clear_user_page_asm)
 #else	/* ! CONFIG_64BIT */
 	ldi		(PAGE_SIZE / 64), %r1
 
-1:
-	stw		%r0, 0(%r28)
+1:	stw		%r0, 0(%r28)
 	stw		%r0, 4(%r28)
 	stw		%r0, 8(%r28)
 	stw		%r0, 12(%r28)
@@ -606,7 +819,7 @@ ENTRY(__clear_user_page_asm)
 	.exit
 
 	.procend
-ENDPROC(__clear_user_page_asm)
+ENDPROC(clear_user_page_asm)
 
 ENTRY(flush_dcache_page_asm)
 	.proc
@@ -630,7 +843,13 @@ ENTRY(flush_dcache_page_asm)
 
 	/* Purge any old translation */
 
+#ifdef CONFIG_PA20
+	pdtlb,l		0(%r28)
+#else
+	tlb_lock	%r20,%r21,%r22
 	pdtlb		0(%r28)
+	tlb_unlock	%r20,%r21,%r22
+#endif
 
 	ldil		L%dcache_stride, %r1
 	ldw		R%dcache_stride(%r1), %r1
@@ -663,8 +882,17 @@ ENTRY(flush_dcache_page_asm)
 	fdc,m		%r1(%r28)
 
 	sync
+
+#ifdef CONFIG_PA20
+	pdtlb,l		0(%r25)
+#else
+	tlb_lock	%r20,%r21,%r22
+	pdtlb		0(%r25)
+	tlb_unlock	%r20,%r21,%r22
+#endif
+
 	bv		%r0(%r2)
-	pdtlb		(%r25)
+	nop
 	.exit
 
 	.procend
@@ -692,7 +920,13 @@ ENTRY(flush_icache_page_asm)
 
 	/* Purge any old translation */
 
-	pitlb		(%sr4,%r28)
+#ifdef CONFIG_PA20
+	pitlb,l         %r0(%sr4,%r28)
+#else
+	tlb_lock        %r20,%r21,%r22
+	pitlb           (%sr4,%r28)
+	tlb_unlock      %r20,%r21,%r22
+#endif
 
 	ldil		L%icache_stride, %r1
 	ldw		R%icache_stride(%r1), %r1
@@ -727,8 +961,17 @@ ENTRY(flush_icache_page_asm)
 	fic,m		%r1(%sr4,%r28)
 
 	sync
+
+#ifdef CONFIG_PA20
+	pitlb,l         %r0(%sr4,%r25)
+#else
+	tlb_lock        %r20,%r21,%r22
+	pitlb           (%sr4,%r25)
+	tlb_unlock      %r20,%r21,%r22
+#endif
+
 	bv		%r0(%r2)
-	pitlb		(%sr4,%r25)
+	nop
 	.exit
 
 	.procend
@@ -777,7 +1020,7 @@ ENTRY(flush_kernel_dcache_page_asm)
 	.procend
 ENDPROC(flush_kernel_dcache_page_asm)
 
-ENTRY(purge_kernel_dcache_page)
+ENTRY(purge_kernel_dcache_page_asm)
 	.proc
 	.callinfo NO_CALLS
 	.entry
@@ -817,7 +1060,7 @@ ENTRY(purge_kernel_dcache_page)
 	.exit
 
 	.procend
-ENDPROC(purge_kernel_dcache_page)
+ENDPROC(purge_kernel_dcache_page_asm)
 
 ENTRY(flush_user_dcache_range_asm)
 	.proc
diff --git a/arch/parisc/kernel/parisc_ksyms.c b/arch/parisc/kernel/parisc_ksyms.c
index ceec85d..6795dc6 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -157,5 +157,6 @@ extern void _mcount(void);
 EXPORT_SYMBOL(_mcount);
 #endif
 
-/* from pacache.S -- needed for copy_page */
-EXPORT_SYMBOL(copy_user_page_asm);
+/* from pacache.S -- needed for clear/copy_page */
+EXPORT_SYMBOL(clear_page_asm);
+EXPORT_SYMBOL(copy_page_asm);
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index d4b94b3..8c6b6b6 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -48,6 +48,7 @@
 #include <linux/unistd.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
+#include <linux/rcupdate.h>
 
 #include <asm/io.h>
 #include <asm/asm-offsets.h>
@@ -69,8 +70,10 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
+		rcu_idle_enter();
 		while (!need_resched())
 			barrier();
+		rcu_idle_exit();
 		schedule_preempt_disabled();
 		check_pgt_cache();
 	}
@@ -309,7 +312,7 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 		cregs->ksp = (unsigned long)stack
 			+ (pregs->gr[21] & (THREAD_SIZE - 1));
 		cregs->gr[30] = usp;
-		if (p->personality == PER_HPUX) {
+		if (personality(p->personality) == PER_HPUX) {
 #ifdef CONFIG_HPUX
 			cregs->kpc = (unsigned long) &hpux_child_return;
 #else
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 594459b..56e0087 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -308,7 +308,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #if DEBUG_SIG
 	/* Assert that we're flushing in the correct space... */
 	{
-		int sid;
+		unsigned long sid;
 		asm ("mfsp %%sr3,%0" : "=r" (sid));
 		DBG(1,"setup_rt_frame: Flushing 64 bytes at space %#x offset %p\n",
 		       sid, frame->tramp);
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index c9b9322..b3032f9 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -92,11 +92,12 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 {
 	if (len > TASK_SIZE)
 		return -ENOMEM;
-	/* Might want to check for cache aliasing issues for MAP_FIXED case
-	 * like ARM or MIPS ??? --BenH.
-	 */
-	if (flags & MAP_FIXED)
+	if (flags & MAP_FIXED) {
+		if ((flags & MAP_SHARED) &&
+		    (addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1))
+			return -EINVAL;
 		return addr;
+	}
 	if (!addr)
 		addr = TASK_UNMAPPED_BASE;
 
@@ -225,12 +226,12 @@ long parisc_personality(unsigned long personality)
 	long err;
 
 	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
+	    && personality(personality) == PER_LINUX)
+		personality = (personality & ~PER_MASK) | PER_LINUX32;
 
 	err = sys_personality(personality);
-	if (err == PER_LINUX32)
-		err = PER_LINUX;
+	if (personality(err) == PER_LINUX32)
+		err = (err & ~PER_MASK) | PER_LINUX;
 
 	return err;
 }
diff --git a/arch/parisc/kernel/syscall.S b/arch/parisc/kernel/syscall.S
index 82a52b2..837c602 100644
--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -180,9 +180,10 @@ linux_gateway_entry:
 
 	/* Are we being ptraced? */
 	mfctl	%cr30, %r1
-	LDREG	TI_TASK(%r1),%r1
-	ldw	TASK_PTRACE(%r1), %r1
-	bb,<,n	%r1,31,.Ltracesys
+	LDREG   TI_FLAGS(%r1),%r1
+	ldi	(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | _TIF_BLOCKSTEP), %r19
+	and,COND(=) %r19, %r1, %r0
+	b,n	.Ltracesys
 	
 	/* Note!  We cannot use the syscall table that is mapped
 	nearby since the gateway page is mapped execute-only. */
diff --git a/arch/parisc/kernel/time.c b/arch/parisc/kernel/time.c
index 70e105d..4a24ba7 100644
--- a/arch/parisc/kernel/time.c
+++ b/arch/parisc/kernel/time.c
@@ -77,7 +77,7 @@ irqreturn_t __irq_entry timer_interrupt(int irq, void *dev_id)
 
 	cycles_elapsed = now - next_tick;
 
-	if ((cycles_elapsed >> 6) < cpt) {
+	if ((cycles_elapsed >> 7) < cpt) {
 		/* use "cheap" math (add/subtract) instead
 		 * of the more expensive div/mul method
 		 */
diff --git a/arch/parisc/math-emu/cnv_float.h b/arch/parisc/math-emu/cnv_float.h
index 9071e09..37299c7 100644
--- a/arch/parisc/math-emu/cnv_float.h
+++ b/arch/parisc/math-emu/cnv_float.h
@@ -347,16 +347,15 @@
     Sgl_isinexact_to_fix(sgl_value,exponent)
 
 #define Duint_from_sgl_mantissa(sgl_value,exponent,dresultA,dresultB)	\
-  {Sall(sgl_value) <<= SGL_EXP_LENGTH;  /*  left-justify  */		\
+  {unsigned int val = Sall(sgl_value) << SGL_EXP_LENGTH;		\
     if (exponent <= 31) {						\
     	Dintp1(dresultA) = 0;						\
-    	Dintp2(dresultB) = (unsigned)Sall(sgl_value) >> (31 - exponent); \
+    	Dintp2(dresultB) = val >> (31 - exponent);			\
     }									\
     else {								\
-    	Dintp1(dresultA) = Sall(sgl_value) >> (63 - exponent);		\
-    	Dintp2(dresultB) = Sall(sgl_value) << (exponent - 31);		\
+    	Dintp1(dresultA) = val >> (63 - exponent);			\
+    	Dintp2(dresultB) = exponent <= 62 ? val << (exponent - 31) : 0;	\
     }									\
-    Sall(sgl_value) >>= SGL_EXP_LENGTH;  /* return to original */	\
   }
 
 #define Duint_setzero(dresultA,dresultB) 	\
diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index 18162ce..524bf5a 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -175,10 +175,12 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
 	struct mm_struct *mm = tsk->mm;
 	unsigned long acc_type;
 	int fault;
+	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 	if (in_atomic() || !mm)
 		goto no_context;
 
+retry:
 	down_read(&mm->mmap_sem);
 	vma = find_vma_prev(mm, address, &prev_vma);
 	if (!vma || address < vma->vm_start)
@@ -201,7 +203,12 @@ good_area:
 	 * fault.
 	 */
 
-	fault = handle_mm_fault(mm, vma, address, (acc_type & VM_WRITE) ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(mm, vma, address,
+		flags | ((acc_type & VM_WRITE) ? FAULT_FLAG_WRITE : 0));
+
+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+		return;
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		/*
 		 * We hit a shared mapping outside of the file, or some
@@ -214,10 +221,22 @@ good_area:
 			goto bad_area;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR)
-		current->maj_flt++;
-	else
-		current->min_flt++;
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR)
+			current->maj_flt++;
+		else
+			current->min_flt++;
+		if (fault & VM_FAULT_RETRY) {
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+
+			/* No need to up_read(&mm->mmap_sem) as we would
+			 * have already released it in __lock_page_or_retry
+			 * in mm/filemap.c.
+			 */
+
+			goto retry;
+		}
+	}
 	up_read(&mm->mmap_sem);
 	return;
 
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 432d4bb..d6c3472 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -477,14 +477,12 @@ dino_card_setup(struct pci_bus *bus, void __iomem *base_addr)
 	if (ccio_allocate_resource(dino_dev->hba.dev, res, _8MB,
 				F_EXTEND(0xf0000000UL) | _8MB,
 				F_EXTEND(0xffffffffUL) &~ _8MB, _8MB) < 0) {
-		struct list_head *ln, *tmp_ln;
+		struct pci_dev *dev, *tmp;
 
 		printk(KERN_ERR "Dino: cannot attach bus %s\n",
 		       dev_name(bus->bridge));
 		/* kill the bus, we can't do anything with it */
-		list_for_each_safe(ln, tmp_ln, &bus->devices) {
-			struct pci_dev *dev = pci_dev_b(ln);
-
+		list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list) {
 			list_del(&dev->bus_list);
 		}
 			
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 052fa23..5208d2f 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -629,7 +629,7 @@ truncate_pat_collision(struct resource *root, struct resource *new)
 static void
 lba_fixup_bus(struct pci_bus *bus)
 {
-	struct list_head *ln;
+	struct pci_dev *dev;
 #ifdef FBB_SUPPORT
 	u16 status;
 #endif
@@ -710,9 +710,8 @@ lba_fixup_bus(struct pci_bus *bus)
 
 	}
 
-	list_for_each(ln, &bus->devices) {
+	list_for_each_entry(dev, &bus->devices, bus_list) {
 		int i;
-		struct pci_dev *dev = pci_dev_b(ln);
 
 		DBG("lba_fixup_bus() %s\n", pci_name(dev));
 
@@ -770,7 +769,7 @@ lba_fixup_bus(struct pci_bus *bus)
 	}
 
 	/* Lastly enable FBB/PERR/SERR on all devices too */
-	list_for_each(ln, &bus->devices) {
+	list_for_each_entry(dev, &bus->devices, bus_list) {
 		(void) pci_read_config_word(dev, PCI_COMMAND, &status);
 		status |= PCI_COMMAND_PARITY | PCI_COMMAND_SERR | fbb_enable;
 		(void) pci_write_config_word(dev, PCI_COMMAND, status);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index eebd6d5..078a593 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -581,6 +581,7 @@ out_eoi:
 void
 handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
+	struct irqaction *action;
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -588,7 +589,9 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 	if (chip->irq_ack)
 		chip->irq_ack(&desc->irq_data);
 
-	handle_irq_event_percpu(desc, desc->action);
+	action = desc->action;
+	if (action)
+		handle_irq_event_percpu(desc, action);
 
 	if (chip->irq_eoi)
 		chip->irq_eoi(&desc->irq_data);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 671f959..315ec22 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -250,7 +250,7 @@ restart:
 		}
 		h++;
 		pending >>= 1;
-	} while (pending);
+	} while (pending && h >= (struct softirq_action *)0x1000);
 
 	local_irq_disable();
 

--Apple-Mail-1--871605220--
