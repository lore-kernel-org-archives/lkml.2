Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0H0CAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:00:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab0H0CAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:00:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/22] Fix m32r irqflags
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 03:00:33 +0100
Message-ID: <20100827020033.27277.78509.stgit@warthog.procyon.org.uk>
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

 arch/m32r/include/asm/irqflags.h |  105 ++++++++++++++++++++++++++++++++++++++
 arch/m32r/include/asm/system.h   |   66 ------------------------
 2 files changed, 106 insertions(+), 65 deletions(-)
 create mode 100644 arch/m32r/include/asm/irqflags.h

diff --git a/arch/m32r/include/asm/irqflags.h b/arch/m32r/include/asm/irqflags.h
new file mode 100644
index 0000000..e465339
--- /dev/null
+++ b/arch/m32r/include/asm/irqflags.h
@@ -0,0 +1,105 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001  Hiroyuki Kondo, Hirokazu Takata, and Hitoshi Yamamoto
+ * Copyright (C) 2004, 2006  Hirokazu Takata <takata at linux-m32r.org>
+ */
+
+#ifndef _ASM_M32R_IRQFLAGS_H
+#define _ASM_M32R_IRQFLAGS_H
+
+#include <linux/types.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile("mvfc %0,psw" : "=r"(flags));
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+#if !defined(CONFIG_CHIP_M32102) && !defined(CONFIG_CHIP_M32104)
+	asm volatile (
+		"clrpsw #0x40 -> nop"
+		: : :"memory");
+#else
+	unsigned long tmpreg0, tmpreg1;
+	asm volatile (
+		"ld24	%0, #0	; Use 32-bit insn.			\n\t"
+		"mvfc	%1, psw	; No interrupt can be accepted here.	\n\t"
+		"mvtc	%0, psw						\n\t"
+		"and3	%0, %1, #0xffbf					\n\t"
+		"mvtc	%0, psw						\n\t"
+		: "=&r" (tmpreg0), "=&r" (tmpreg1)
+		:
+		: "cbit", "memory");
+#endif
+}
+
+static inline void arch_local_irq_enable(void)
+{
+#if !defined(CONFIG_CHIP_M32102) && !defined(CONFIG_CHIP_M32104)
+	asm volatile (
+		"setpsw #0x40 -> nop"
+		: : :"memory");
+#else
+	unsigned long tmpreg;
+	asm volatile (
+		"mvfc	%0, psw;		\n\t"
+		"or3	%0, %0, #0x0040;	\n\t"
+		"mvtc	%0, psw;		\n\t"
+		: "=&r" (tmpreg)
+		:
+		: "cbit", "memory");
+#endif
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+
+#if !(defined(CONFIG_CHIP_M32102) || defined(CONFIG_CHIP_M32104))
+	asm volatile (
+  		"mvfc	%0, psw;	\n\t"
+	  	"clrpsw	#0x40 -> nop;	\n\t"
+  		: "=r" (flags)
+		:
+		: "memory");
+#else
+	unsigned long tmpreg;
+	asm volatile (
+		"ld24	%1, #0		\n\t"
+		"mvfc	%0, psw		\n\t"
+		"mvtc	%1, psw		\n\t"
+		"and3	%1, %0, #0xffbf	\n\t"
+		"mvtc	%1, psw		\n\t"
+		: "=r" (flags), "=&r" (tmpreg)
+		:
+		: "cbit", "memory");
+#endif
+	return flags;
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile("mvtc %0,psw"
+		     :
+		     : "r" (flags)
+		     : "cbit", "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return !(flags & 0x40);
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* _ASM_M32R_IRQFLAGS_H */
+
diff --git a/arch/m32r/include/asm/system.h b/arch/m32r/include/asm/system.h
index c980f5b..13c4679 100644
--- a/arch/m32r/include/asm/system.h
+++ b/arch/m32r/include/asm/system.h
@@ -11,6 +11,7 @@
  */
 
 #include <linux/compiler.h>
+#include <linux/irqflags.h>
 #include <asm/assembler.h>
 
 #ifdef __KERNEL__
@@ -54,71 +55,6 @@
 	); \
 } while(0)
 
-/* Interrupt Control */
-#if !defined(CONFIG_CHIP_M32102) && !defined(CONFIG_CHIP_M32104)
-#define local_irq_enable() \
-	__asm__ __volatile__ ("setpsw #0x40 -> nop": : :"memory")
-#define local_irq_disable() \
-	__asm__ __volatile__ ("clrpsw #0x40 -> nop": : :"memory")
-#else	/* CONFIG_CHIP_M32102 || CONFIG_CHIP_M32104 */
-static inline void local_irq_enable(void)
-{
-	unsigned long tmpreg;
-	__asm__ __volatile__(
-		"mvfc	%0, psw;		\n\t"
-		"or3	%0, %0, #0x0040;	\n\t"
-		"mvtc	%0, psw;		\n\t"
-	: "=&r" (tmpreg) : : "cbit", "memory");
-}
-
-static inline void local_irq_disable(void)
-{
-	unsigned long tmpreg0, tmpreg1;
-	__asm__ __volatile__(
-		"ld24	%0, #0	; Use 32-bit insn. \n\t"
-		"mvfc	%1, psw	; No interrupt can be accepted here. \n\t"
-		"mvtc	%0, psw	\n\t"
-		"and3	%0, %1, #0xffbf	\n\t"
-		"mvtc	%0, psw	\n\t"
-	: "=&r" (tmpreg0), "=&r" (tmpreg1) : : "cbit", "memory");
-}
-#endif	/* CONFIG_CHIP_M32102 || CONFIG_CHIP_M32104 */
-
-#define local_save_flags(x) \
-	__asm__ __volatile__("mvfc %0,psw" : "=r"(x) : /* no input */)
-
-#define local_irq_restore(x) \
-	__asm__ __volatile__("mvtc %0,psw" : /* no outputs */ \
-		: "r" (x) : "cbit", "memory")
-
-#if !(defined(CONFIG_CHIP_M32102) || defined(CONFIG_CHIP_M32104))
-#define local_irq_save(x)				\
-	__asm__ __volatile__(				\
-  		"mvfc	%0, psw;		\n\t"	\
-	  	"clrpsw	#0x40 -> nop;		\n\t"	\
-  		: "=r" (x) : /* no input */ : "memory")
-#else	/* CONFIG_CHIP_M32102 || CONFIG_CHIP_M32104 */
-#define local_irq_save(x) 				\
-	({						\
-		unsigned long tmpreg;			\
-		__asm__ __volatile__( 			\
-			"ld24	%1, #0 \n\t" 		\
-			"mvfc	%0, psw \n\t"		\
-			"mvtc	%1, psw \n\t"		\
-			"and3	%1, %0, #0xffbf \n\t"	\
-			"mvtc	%1, psw \n\t" 		\
-			: "=r" (x), "=&r" (tmpreg)	\
-			: : "cbit", "memory");		\
-	})
-#endif	/* CONFIG_CHIP_M32102 || CONFIG_CHIP_M32104 */
-
-#define irqs_disabled()					\
-	({						\
-		unsigned long flags;			\
-		local_save_flags(flags);		\
-		!(flags & 0x40);			\
-	})
-
 #define nop()	__asm__ __volatile__ ("nop" : : )
 
 #define xchg(ptr, x)							\

