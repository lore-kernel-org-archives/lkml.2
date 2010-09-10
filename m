Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0IJQ0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab0IJQ0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:26:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/17] Fix Score irqflags
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Date: Fri, 10 Sep 2010 17:25:35 +0100
Message-ID: <20100910162535.20817.53171.stgit@warthog.procyon.org.uk>
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

Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---

 arch/score/include/asm/irqflags.h |  187 ++++++++++++++++++++-----------------
 1 files changed, 99 insertions(+), 88 deletions(-)

diff --git a/arch/score/include/asm/irqflags.h b/arch/score/include/asm/irqflags.h
index 690a6ca..5c75638 100644
--- a/arch/score/include/asm/irqflags.h
+++ b/arch/score/include/asm/irqflags.h
@@ -3,107 +3,118 @@
 
 #ifndef __ASSEMBLY__
 
-#define raw_local_irq_save(x)			\
-{						\
-	__asm__ __volatile__(			\
-		"mfcr	r8, cr0;"		\
-		"li	r9, 0xfffffffe;"	\
-		"nop;"				\
-		"mv	%0, r8;"		\
-		"and	r8, r8, r9;"		\
-		"mtcr	r8, cr0;"		\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		: "=r" (x)			\
-		:				\
-		: "r8", "r9"			\
-		);				\
+#include <linux/types.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+
+	asm volatile(
+		"	mfcr	r8, cr0		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	mv	%0, r8		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	ldi	r9, 0x1		\n"
+		"	and	%0, %0, r9	\n"
+		: "=r" (flags)
+		:
+		: "r8", "r9");
+	return flags;
 }
 
-#define raw_local_irq_restore(x)		\
-{						\
-	__asm__ __volatile__(			\
-		"mfcr	r8, cr0;"		\
-		"ldi	r9, 0x1;"		\
-		"and	%0, %0, r9;"		\
-		"or	r8, r8, %0;"		\
-		"mtcr	r8, cr0;"		\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		:				\
-		: "r"(x)			\
-		: "r8", "r9"			\
-		);				\
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags
+
+	asm volatile(
+		"	mfcr	r8, cr0		\n"
+		"	li	r9, 0xfffffffe	\n"
+		"	nop			\n"
+		"	mv	%0, r8		\n"
+		"	and	r8, r8, r9	\n"
+		"	mtcr	r8, cr0		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		: "=r" (flags)
+		:
+		: "r8", "r9", "memory");
+
+	return flags;
 }
 
-#define raw_local_irq_enable(void)		\
-{						\
-	__asm__ __volatile__(			\
-		"mfcr\tr8,cr0;"			\
-		"nop;"				\
-		"nop;"				\
-		"ori\tr8,0x1;"			\
-		"mtcr\tr8,cr0;"			\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		:				\
-		:				\
-		: "r8");			\
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile(
+		"	mfcr	r8, cr0		\n"
+		"	ldi	r9, 0x1		\n"
+		"	and	%0, %0, r9	\n"
+		"	or	r8, r8, %0	\n"
+		"	mtcr	r8, cr0		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		:
+		: "r"(flags)
+		: "r8", "r9", "memory");
 }
 
-#define raw_local_irq_disable(void)		\
-{						\
-	__asm__ __volatile__(			\
-		"mfcr\tr8,cr0;"			\
-		"nop;"				\
-		"nop;"				\
-		"srli\tr8,r8,1;"		\
-		"slli\tr8,r8,1;"		\
-		"mtcr\tr8,cr0;"			\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		:				\
-		:				\
-		: "r8");			\
+static inline void arch_local_irq_enable(void)
+{
+	asm volatile(
+		"	mfcr	r8,cr0		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	ori	r8,0x1		\n"
+		"	mtcr	r8,cr0		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		:
+		:
+		: "r8", "memory");
 }
 
-#define raw_local_save_flags(x)			\
-{						\
-	__asm__ __volatile__(			\
-		"mfcr	r8, cr0;"		\
-		"nop;"				\
-		"nop;"				\
-		"mv	%0, r8;"		\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"nop;"				\
-		"ldi	r9, 0x1;"		\
-		"and	%0, %0, r9;"		\
-		: "=r" (x)			\
-		:				\
-		: "r8", "r9"			\
-		);				\
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile(
+		"	mfcr	r8,cr0		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	srli	r8,r8,1		\n"
+		"	slli	r8,r8,1		\n"
+		"	mtcr	r8,cr0		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		:
+		:
+		: "r8", "memory");
 }
 
-static inline int raw_irqs_disabled_flags(unsigned long flags)
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
 {
 	return !(flags & 1);
 }
 
-#endif
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_SCORE_IRQFLAGS_H */

