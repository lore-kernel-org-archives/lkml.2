Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0IJQ00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab0IJQ0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:26:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/17] Fix XTENSA irqflags
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
        Chris Zankel <chris@zankel.net>
Date: Fri, 10 Sep 2010 17:25:29 +0100
Message-ID: <20100910162529.20817.32128.stgit@warthog.procyon.org.uk>
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

Cc: Chris Zankel <chris@zankel.net>
---

 arch/xtensa/include/asm/irqflags.h |   58 ++++++++++++++++++++++++++++++++++++
 arch/xtensa/include/asm/system.h   |   33 +-------------------
 2 files changed, 59 insertions(+), 32 deletions(-)
 create mode 100644 arch/xtensa/include/asm/irqflags.h

diff --git a/arch/xtensa/include/asm/irqflags.h b/arch/xtensa/include/asm/irqflags.h
new file mode 100644
index 0000000..612b370
--- /dev/null
+++ b/arch/xtensa/include/asm/irqflags.h
@@ -0,0 +1,58 @@
+/*
+ * Xtensa IRQ flags handling functions
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 - 2005 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_IRQFLAGS_H
+#define _XTENSA_IRQFLAGS_H
+
+#include <linux/types.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile("rsr %0,"__stringify(PS) : "=a" (flags));
+	return flags;
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+	asm volatile("rsil %0, "__stringify(LOCKLEVEL)
+		     : "=a" (flags) :: "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	arch_local_irq_save();
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	unsigned long flags;
+	asm volatile("rsil %0, 0" : "=a" (flags) :: "memory");
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile("wsr %0, "__stringify(PS)" ; rsync"
+		     :: "a" (x) : "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & 0xf) != 0;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* _XTENSA_IRQFLAGS_H */
diff --git a/arch/xtensa/include/asm/system.h b/arch/xtensa/include/asm/system.h
index 62b1e8f..1e7e09a 100644
--- a/arch/xtensa/include/asm/system.h
+++ b/arch/xtensa/include/asm/system.h
@@ -12,41 +12,10 @@
 #define _XTENSA_SYSTEM_H
 
 #include <linux/stringify.h>
+#include <linux/irqflags.h>
 
 #include <asm/processor.h>
 
-/* interrupt control */
-
-#define local_save_flags(x)						\
-	__asm__ __volatile__ ("rsr %0,"__stringify(PS) : "=a" (x));
-#define local_irq_restore(x)	do {					\
-	__asm__ __volatile__ ("wsr %0, "__stringify(PS)" ; rsync" 	\
-	    		      :: "a" (x) : "memory"); } while(0);
-#define local_irq_save(x)	do {					\
-	__asm__ __volatile__ ("rsil %0, "__stringify(LOCKLEVEL) 	\
-	    		      : "=a" (x) :: "memory");} while(0);
-
-static inline void local_irq_disable(void)
-{
-	unsigned long flags;
-	__asm__ __volatile__ ("rsil %0, "__stringify(LOCKLEVEL)
-	    		      : "=a" (flags) :: "memory");
-}
-static inline void local_irq_enable(void)
-{
-	unsigned long flags;
-	__asm__ __volatile__ ("rsil %0, 0" : "=a" (flags) :: "memory");
-
-}
-
-static inline int irqs_disabled(void)
-{
-	unsigned long flags;
-	local_save_flags(flags);
-	return flags & 0xf;
-}
-
-
 #define smp_read_barrier_depends() do { } while(0)
 #define read_barrier_depends() do { } while(0)
 

