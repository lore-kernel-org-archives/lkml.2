Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0IJQZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:25:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab0IJQZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:25:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/17] Fix CRIS irqflags
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, starvik@axis.com,
        jesper.nilsson@axis.com, linux-cris-kernel@axis.com
Date: Fri, 10 Sep 2010 17:25:14 +0100
Message-ID: <20100910162514.20817.76835.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100910162407.20817.34359.stgit@warthog.procyon.org.uk>
References: <20100910162407.20817.34359.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This (sub)patch is separated out for reviewing purposes.  Once ACK'd it will
need to be rolled into the main patch.

Cc: starvik@axis.com
Cc: jesper.nilsson@axis.com
Cc: linux-cris-kernel@axis.com
---

 arch/cris/include/arch-v10/arch/irqflags.h |   45 +++++++++++++++++++++++++++
 arch/cris/include/arch-v10/arch/system.h   |   16 ----------
 arch/cris/include/arch-v32/arch/irqflags.h |   46 ++++++++++++++++++++++++++++
 arch/cris/include/arch-v32/arch/system.h   |   22 -------------
 arch/cris/include/asm/irqflags.h           |    1 +
 arch/cris/include/asm/system.h             |    1 +
 6 files changed, 93 insertions(+), 38 deletions(-)
 create mode 100644 arch/cris/include/arch-v10/arch/irqflags.h
 create mode 100644 arch/cris/include/arch-v32/arch/irqflags.h
 create mode 100644 arch/cris/include/asm/irqflags.h

diff --git a/arch/cris/include/arch-v10/arch/irqflags.h b/arch/cris/include/arch-v10/arch/irqflags.h
new file mode 100644
index 0000000..75ef189
--- /dev/null
+++ b/arch/cris/include/arch-v10/arch/irqflags.h
@@ -0,0 +1,45 @@
+#ifndef __ASM_CRIS_ARCH_IRQFLAGS_H
+#define __ASM_CRIS_ARCH_IRQFLAGS_H
+
+#include <linux/types.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile("move $ccr,%0" : "=rm" (flags) : : "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile("di" : : : "memory");
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	asm volatile("ei" : : : "memory");
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	arch_local_irq_disable();
+	return flags;
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile("move %0,$ccr" : : "rm" (flags) : "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & (1 << 5));
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* __ASM_CRIS_ARCH_IRQFLAGS_H */
diff --git a/arch/cris/include/arch-v10/arch/system.h b/arch/cris/include/arch-v10/arch/system.h
index 4a9cd36..935fde3 100644
--- a/arch/cris/include/arch-v10/arch/system.h
+++ b/arch/cris/include/arch-v10/arch/system.h
@@ -44,20 +44,4 @@ static inline unsigned long _get_base(char * addr)
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
-/* interrupt control.. */
-#define local_save_flags(x)	__asm__ __volatile__ ("move $ccr,%0" : "=rm" (x) : : "memory");
-#define local_irq_restore(x) 	__asm__ __volatile__ ("move %0,$ccr" : : "rm" (x) : "memory");
-#define local_irq_disable() 	__asm__ __volatile__ ( "di" : : :"memory");
-#define local_irq_enable()	__asm__ __volatile__ ( "ei" : : :"memory");
-
-#define irqs_disabled()			\
-({					\
-	unsigned long flags;		\
-	local_save_flags(flags);	\
-	!(flags & (1<<5));		\
-})
-
-/* For spinlocks etc */
-#define local_irq_save(x) __asm__ __volatile__ ("move $ccr,%0\n\tdi" : "=rm" (x) : : "memory");
-
 #endif
diff --git a/arch/cris/include/arch-v32/arch/irqflags.h b/arch/cris/include/arch-v32/arch/irqflags.h
new file mode 100644
index 0000000..041851f
--- /dev/null
+++ b/arch/cris/include/arch-v32/arch/irqflags.h
@@ -0,0 +1,46 @@
+#ifndef __ASM_CRIS_ARCH_IRQFLAGS_H
+#define __ASM_CRIS_ARCH_IRQFLAGS_H
+
+#include <linux/types.h>
+#include <arch/ptrace.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile("move $ccs,%0" : "=rm" (flags) : : "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile("di" : : : "memory");
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	asm volatile("ei" : : : "memory");
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	arch_local_irq_disable();
+	return flags;
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile("move %0,$ccs" : : "rm" (flags) : "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & (1 << I_CCS_BITNR));
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* __ASM_CRIS_ARCH_IRQFLAGS_H */
diff --git a/arch/cris/include/arch-v32/arch/system.h b/arch/cris/include/arch-v32/arch/system.h
index 6ca90f1..76cea99 100644
--- a/arch/cris/include/arch-v32/arch/system.h
+++ b/arch/cris/include/arch-v32/arch/system.h
@@ -44,26 +44,4 @@ static inline unsigned long rdsp(void)
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
-/* Used for interrupt control. */
-#define local_save_flags(x) \
-	__asm__ __volatile__ ("move $ccs, %0" : "=rm" (x) : : "memory");
-
-#define local_irq_restore(x) \
-	__asm__ __volatile__ ("move %0, $ccs" : : "rm" (x) : "memory");
-
-#define local_irq_disable()  __asm__ __volatile__ ("di" : : : "memory");
-#define local_irq_enable()   __asm__ __volatile__ ("ei" : : : "memory");
-
-#define irqs_disabled()		\
-({				\
-	unsigned long flags;	\
-				\
-	local_save_flags(flags);\
-	!(flags & (1 << I_CCS_BITNR));	\
-})
-
-/* Used for spinlocks, etc. */
-#define local_irq_save(x) \
-	__asm__ __volatile__ ("move $ccs, %0\n\tdi" : "=rm" (x) : : "memory");
-
 #endif /* _ASM_CRIS_ARCH_SYSTEM_H */
diff --git a/arch/cris/include/asm/irqflags.h b/arch/cris/include/asm/irqflags.h
new file mode 100644
index 0000000..943ba5c
--- /dev/null
+++ b/arch/cris/include/asm/irqflags.h
@@ -0,0 +1 @@
+#include <arch/irqflags.h>
diff --git a/arch/cris/include/asm/system.h b/arch/cris/include/asm/system.h
index 8657b08..ea10592 100644
--- a/arch/cris/include/asm/system.h
+++ b/arch/cris/include/asm/system.h
@@ -1,6 +1,7 @@
 #ifndef __ASM_CRIS_SYSTEM_H
 #define __ASM_CRIS_SYSTEM_H
 
+#include <linux/irqflags.h>
 #include <arch/system.h>
 
 /* the switch_to macro calls resume, an asm function in entry.S which does the actual

