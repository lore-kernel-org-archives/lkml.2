Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab0H0CAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab0H0CAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:00:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/22] Fix PA-RISC irqflags
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 03:00:43 +0100
Message-ID: <20100827020043.27277.2926.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
References: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 arch/parisc/include/asm/irqflags.h |   46 ++++++++++++++++++++++++++++++++++++
 arch/parisc/include/asm/system.h   |   19 +--------------
 2 files changed, 47 insertions(+), 18 deletions(-)
 create mode 100644 arch/parisc/include/asm/irqflags.h

diff --git a/arch/parisc/include/asm/irqflags.h b/arch/parisc/include/asm/irqflags.h
new file mode 100644
index 0000000..40442a1
--- /dev/null
+++ b/arch/parisc/include/asm/irqflags.h
@@ -0,0 +1,46 @@
+#ifndef __PARISC_IRQFLAGS_H
+#define __PARISC_IRQFLAGS_H
+
+#include <linux/types.h>
+#include <asm/psw.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile("ssm 0, %0" : "=r" (flags) : : "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile("rsm %0,%%r0\n" : : "i" (PSW_I) : "memory");
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	asm volatile("ssm %0,%%r0\n" : : "i" (PSW_I) : "memory");
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+	asm volatile ("rsm %1,%0" : "=r" (flags) :"i" (PSW_I) : "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile ("mtsm %0" : : "r" (flags) : "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & PSW_I) == 0;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* __PARISC_IRQFLAGS_H */
diff --git a/arch/parisc/include/asm/system.h b/arch/parisc/include/asm/system.h
index 2ab4af5..b19e63a 100644
--- a/arch/parisc/include/asm/system.h
+++ b/arch/parisc/include/asm/system.h
@@ -1,7 +1,7 @@
 #ifndef __PARISC_SYSTEM_H
 #define __PARISC_SYSTEM_H
 
-#include <asm/psw.h>
+#include <linux/irqflags.h>
 
 /* The program status word as bitfields.  */
 struct pa_psw {
@@ -48,23 +48,6 @@ extern struct task_struct *_switch_to(struct task_struct *, struct task_struct *
 	(last) = _switch_to(prev, next);			\
 } while(0)
 
-/* interrupt control */
-#define local_save_flags(x)	__asm__ __volatile__("ssm 0, %0" : "=r" (x) : : "memory")
-#define local_irq_disable()	__asm__ __volatile__("rsm %0,%%r0\n" : : "i" (PSW_I) : "memory" )
-#define local_irq_enable()	__asm__ __volatile__("ssm %0,%%r0\n" : : "i" (PSW_I) : "memory" )
-
-#define local_irq_save(x) \
-	__asm__ __volatile__("rsm %1,%0" : "=r" (x) :"i" (PSW_I) : "memory" )
-#define local_irq_restore(x) \
-	__asm__ __volatile__("mtsm %0" : : "r" (x) : "memory" )
-
-#define irqs_disabled()			\
-({					\
-	unsigned long flags;		\
-	local_save_flags(flags);	\
-	(flags & PSW_I) == 0;		\
-})
-
 #define mfctl(reg)	({		\
 	unsigned long cr;		\
 	__asm__ __volatile__(		\

