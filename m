Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab0H0CAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:00:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab0H0CA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:00:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/22] Fix H8300 arch
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 03:00:22 +0100
Message-ID: <20100827020022.27277.48255.stgit@warthog.procyon.org.uk>
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

 arch/h8300/include/asm/irqflags.h |   43 +++++++++++++++++++++++++++++++++++++
 arch/h8300/include/asm/system.h   |   24 +--------------------
 2 files changed, 44 insertions(+), 23 deletions(-)
 create mode 100644 arch/h8300/include/asm/irqflags.h

diff --git a/arch/h8300/include/asm/irqflags.h b/arch/h8300/include/asm/irqflags.h
new file mode 100644
index 0000000..9617cd5
--- /dev/null
+++ b/arch/h8300/include/asm/irqflags.h
@@ -0,0 +1,43 @@
+#ifndef _H8300_IRQFLAGS_H
+#define _H8300_IRQFLAGS_H
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile ("stc ccr,%w0" : "=r" (flags));
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile ("orc  #0x80,ccr" : : : "memory");
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	asm volatile ("andc #0x7f,ccr" : : : "memory");
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
+	asm volatile ("ldc %w0,ccr" : : "r" (flags) : "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & 0x80) == 0x80;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* _H8300_IRQFLAGS_H */
diff --git a/arch/h8300/include/asm/system.h b/arch/h8300/include/asm/system.h
index 16bf156..2c2382e 100644
--- a/arch/h8300/include/asm/system.h
+++ b/arch/h8300/include/asm/system.h
@@ -2,6 +2,7 @@
 #define _H8300_SYSTEM_H
 
 #include <linux/linkage.h>
+#include <linux/irqflags.h>
 
 struct pt_regs;
 
@@ -51,31 +52,8 @@ asmlinkage void resume(void);
   (last) = _last; 					    \
 }
 
-#define __sti() asm volatile ("andc #0x7f,ccr")
-#define __cli() asm volatile ("orc  #0x80,ccr")
-
-#define __save_flags(x) \
-       asm volatile ("stc ccr,%w0":"=r" (x))
-
-#define __restore_flags(x) \
-       asm volatile ("ldc %w0,ccr": :"r" (x))
-
-#define	irqs_disabled()			\
-({					\
-	unsigned char flags;		\
-	__save_flags(flags);	        \
-	((flags & 0x80) == 0x80);	\
-})
-
 #define iret() __asm__ __volatile__ ("rte": : :"memory", "sp", "cc")
 
-/* For spinlocks etc */
-#define local_irq_disable()	__cli()
-#define local_irq_enable()      __sti()
-#define local_irq_save(x)	({ __save_flags(x); local_irq_disable(); })
-#define local_irq_restore(x)	__restore_flags(x)
-#define local_save_flags(x)     __save_flags(x)
-
 /*
  * Force strict CPU ordering.
  * Not really required on H8...

