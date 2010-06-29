Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0F2KWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:22:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:50753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab0F2KWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:22:20 -0400
Date: Tue, 29 Jun 2010 10:21:43 GMT
From: tip-bot for Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, hch@lst.de,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       hch@lst.de, tglx@linutronix.de
In-Reply-To: <20100628121554.GA6605@lst.de>
References: <20100628121554.GA6605@lst.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org>
Git-Commit-ID: 7974891db234467eaf1fec613ec0129cb4ac2332
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 10:21:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7974891db234467eaf1fec613ec0129cb4ac2332
Gitweb:     http://git.kernel.org/tip/7974891db234467eaf1fec613ec0129cb4ac2332
Author:     Christoph Hellwig <hch@lst.de>
AuthorDate: Mon, 28 Jun 2010 14:15:54 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 29 Jun 2010 12:12:59 +0200

x86: Always use irq stacks

IRQ stacks provide much better safety against unexpected stack use from
interrupts, at the minimal downside of slightly higher memory usage.
Enable irq stacks also for the default 8k stack on 32-bit kernels to
minimize the problem of stack overflows through interrupt activity.

This is what the 64-bit kernel and various other architectures already do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
LKML-Reference: <20100628121554.GA6605@lst.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 Documentation/x86/x86_64/kernel-stacks |    6 +++---
 arch/x86/Kconfig.debug                 |    3 +--
 arch/x86/include/asm/irq.h             |   12 +++++-------
 arch/x86/kernel/irq_32.c               |    6 ------
 4 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/Documentation/x86/x86_64/kernel-stacks b/Documentation/x86/x86_64/kernel-stacks
index 5ad65d5..a01eec5 100644
--- a/Documentation/x86/x86_64/kernel-stacks
+++ b/Documentation/x86/x86_64/kernel-stacks
@@ -18,9 +18,9 @@ specialized stacks contain no useful data.  The main CPU stacks are:
   Used for external hardware interrupts.  If this is the first external
   hardware interrupt (i.e. not a nested hardware interrupt) then the
   kernel switches from the current task to the interrupt stack.  Like
-  the split thread and interrupt stacks on i386 (with CONFIG_4KSTACKS),
-  this gives more room for kernel interrupt processing without having
-  to increase the size of every per thread stack.
+  the split thread and interrupt stacks on i386, this gives more room
+  for kernel interrupt processing without having to increase the size
+  of every per thread stack.
 
   The interrupt stack is also used when processing a softirq.
 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 7508508..badda8e 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -128,8 +128,7 @@ config 4KSTACKS
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates
 	  running more threads on a system and also reduces the pressure
-	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
+	  on the VM subsystem for higher order allocations.
 
 config DOUBLEFAULT
 	default y
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 5458380..0bf5b00 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -19,18 +19,16 @@ static inline int irq_canonicalize(int irq)
 # define ARCH_HAS_NMI_WATCHDOG
 #endif
 
-#ifdef CONFIG_4KSTACKS
-  extern void irq_ctx_init(int cpu);
-  extern void irq_ctx_exit(int cpu);
-# define __ARCH_HAS_DO_SOFTIRQ
+#ifdef CONFIG_X86_32
+extern void irq_ctx_init(int cpu);
+extern void irq_ctx_exit(int cpu);
 #else
 # define irq_ctx_init(cpu) do { } while (0)
 # define irq_ctx_exit(cpu) do { } while (0)
-# ifdef CONFIG_X86_64
-#  define __ARCH_HAS_DO_SOFTIRQ
-# endif
 #endif
 
+#define __ARCH_HAS_DO_SOFTIRQ
+
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
 extern void fixup_irqs(void);
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 10709f2..67f5f9f 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -49,7 +49,6 @@ static inline int check_stack_overflow(void) { return 0; }
 static inline void print_stack_overflow(void) { }
 #endif
 
-#ifdef CONFIG_4KSTACKS
 /*
  * per-CPU IRQ handling contexts (thread information and stack)
  */
@@ -187,11 +186,6 @@ asmlinkage void do_softirq(void)
 	local_irq_restore(flags);
 }
 
-#else
-static inline int
-execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
-#endif
-
 bool handle_irq(unsigned irq, struct pt_regs *regs)
 {
 	struct irq_desc *desc;
