Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab2BGAXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:23:20 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab2BGAWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:22:17 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        Artem.Bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/5] um: a bunch of headers can be killed by using generic-y
Date: Tue,  7 Feb 2012 01:22:48 +0100
Message-Id: <1328574170-2286-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1328574170-2286-1-git-send-email-richard@nod.at>
References: <1328574170-2286-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
[richard@nod.at: Fixed get_current()]
---
 arch/um/include/asm/Kbuild         |    2 +-
 arch/um/include/asm/current.h      |   13 --------
 arch/um/include/asm/delay.h        |   18 -----------
 arch/um/include/asm/io.h           |   57 ------------------------------------
 arch/um/include/asm/mutex.h        |    9 ------
 arch/um/include/asm/param.h        |   20 ------------
 arch/um/include/asm/pci.h          |    6 ----
 arch/um/include/shared/kern_util.h |    2 +-
 arch/um/kernel/process.c           |    4 +-
 arch/x86/um/bugs_32.c              |    2 +-
 10 files changed, 5 insertions(+), 128 deletions(-)
 delete mode 100644 arch/um/include/asm/current.h
 delete mode 100644 arch/um/include/asm/delay.h
 delete mode 100644 arch/um/include/asm/io.h
 delete mode 100644 arch/um/include/asm/mutex.h
 delete mode 100644 arch/um/include/asm/param.h
 delete mode 100644 arch/um/include/asm/pci.h

diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 451f451..8419f5c 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -1,3 +1,3 @@
 generic-y += bug.h cputime.h device.h emergency-restart.h futex.h hardirq.h
 generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
-generic-y += ftrace.h
+generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h
diff --git a/arch/um/include/asm/current.h b/arch/um/include/asm/current.h
deleted file mode 100644
index c2191d9..0000000
--- a/arch/um/include/asm/current.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
- */
-
-#ifndef __UM_CURRENT_H
-#define __UM_CURRENT_H
-
-#include "linux/thread_info.h"
-
-#define current (current_thread_info()->task)
-
-#endif
diff --git a/arch/um/include/asm/delay.h b/arch/um/include/asm/delay.h
deleted file mode 100644
index 8a5576d..0000000
--- a/arch/um/include/asm/delay.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef __UM_DELAY_H
-#define __UM_DELAY_H
-
-/* Undefined on purpose */
-extern void __bad_udelay(void);
-extern void __bad_ndelay(void);
-
-extern void __udelay(unsigned long usecs);
-extern void __ndelay(unsigned long usecs);
-extern void __delay(unsigned long loops);
-
-#define udelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
-	__bad_udelay() : __udelay(n))
-
-#define ndelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
-	__bad_ndelay() : __ndelay(n))
-
-#endif
diff --git a/arch/um/include/asm/io.h b/arch/um/include/asm/io.h
deleted file mode 100644
index 44e8b8c..0000000
--- a/arch/um/include/asm/io.h
+++ /dev/null
@@ -1,57 +0,0 @@
-#ifndef __UM_IO_H
-#define __UM_IO_H
-
-#include "asm/page.h"
-
-#define IO_SPACE_LIMIT 0xdeadbeef /* Sure hope nothing uses this */
-
-static inline int inb(unsigned long i) { return(0); }
-static inline void outb(char c, unsigned long i) { }
-
-/*
- * Change virtual addresses to physical addresses and vv.
- * These are pretty trivial
- */
-static inline unsigned long virt_to_phys(volatile void * address)
-{
-	return __pa((void *) address);
-}
-
-static inline void * phys_to_virt(unsigned long address)
-{
-	return __va(address);
-}
-
-/*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
-
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-static inline void writeb(unsigned char b, volatile void __iomem *addr)
-{
-	*(volatile unsigned char __force *) addr = b;
-}
-static inline void writew(unsigned short b, volatile void __iomem *addr)
-{
-	*(volatile unsigned short __force *) addr = b;
-}
-static inline void writel(unsigned int b, volatile void __iomem *addr)
-{
-	*(volatile unsigned int __force *) addr = b;
-}
-static inline void writeq(unsigned int b, volatile void __iomem *addr)
-{
-	*(volatile unsigned long long __force *) addr = b;
-}
-#define __raw_writeb writeb
-#define __raw_writew writew
-#define __raw_writel writel
-#define __raw_writeq writeq
-
-#endif
diff --git a/arch/um/include/asm/mutex.h b/arch/um/include/asm/mutex.h
deleted file mode 100644
index 458c1f7..0000000
--- a/arch/um/include/asm/mutex.h
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
diff --git a/arch/um/include/asm/param.h b/arch/um/include/asm/param.h
deleted file mode 100644
index e44f4e6..0000000
--- a/arch/um/include/asm/param.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _UM_PARAM_H
-#define _UM_PARAM_H
-
-#define EXEC_PAGESIZE   4096
-
-#ifndef NOGROUP
-#define NOGROUP         (-1)
-#endif
-
-#define MAXHOSTNAMELEN  64      /* max length of hostname */
-
-#ifdef __KERNEL__
-#define HZ CONFIG_HZ
-#define USER_HZ	100	   /* .. some user interfaces are in "ticks" */
-#define CLOCKS_PER_SEC (USER_HZ)  /* frequency at which times() counts */
-#else
-#define HZ 100
-#endif
-
-#endif
diff --git a/arch/um/include/asm/pci.h b/arch/um/include/asm/pci.h
deleted file mode 100644
index b44cf59..0000000
--- a/arch/um/include/asm/pci.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_PCI_H
-#define __UM_PCI_H
-
-#define PCI_DMA_BUS_IS_PHYS     (1)
-
-#endif
diff --git a/arch/um/include/shared/kern_util.h b/arch/um/include/shared/kern_util.h
index 0f14838..d7eccd2 100644
--- a/arch/um/include/shared/kern_util.h
+++ b/arch/um/include/shared/kern_util.h
@@ -48,7 +48,7 @@ extern void do_uml_exitcalls(void);
  * GFP_ATOMIC.
  */
 extern int __cant_sleep(void);
-extern void *get_current(void);
+extern pid_t get_current_pid(void);
 extern int copy_from_user_proc(void *to, void *from, int size);
 extern int cpu(void);
 extern char *uml_strdup(const char *string);
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 69f2490..9376c24 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -126,9 +126,9 @@ void exit_thread(void)
 {
 }
 
-void *get_current(void)
+pid_t get_current_pid(void)
 {
-	return current;
+	return task_pid_nr(current);
 }
 
 /*
diff --git a/arch/x86/um/bugs_32.c b/arch/x86/um/bugs_32.c
index a1fba5f..d5263ee 100644
--- a/arch/x86/um/bugs_32.c
+++ b/arch/x86/um/bugs_32.c
@@ -51,7 +51,7 @@ void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 	 * This is testing for a cmov (0x0f 0x4x) instruction causing a
 	 * SIGILL in init.
 	 */
-	if ((sig != SIGILL) || (TASK_PID(get_current()) != 1))
+	if ((sig != SIGILL) || get_current_pid() != 1)
 		return;
 
 	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2)) {
-- 
1.7.6

