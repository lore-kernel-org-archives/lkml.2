Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2IKRmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:42:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50723 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab2IKRjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:39:46 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 05/17] ARM: LPAE: support 64-bit virt_to_phys patching
Date: Tue, 11 Sep 2012 13:39:03 -0400
Message-ID: <1347385155-11643-6-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347385155-11643-1-git-send-email-cyril@ti.com>
References: <1347385155-11643-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for 64-bit physical addresses in virt_to_phys()
patching.  This does not do real 64-bit add/sub, but instead patches in the
upper 32-bits of the phys_offset directly into the output of virt_to_phys.

There is no corresponding change on the phys_to_virt() side, because
computations on the upper 32-bits would be discarded anyway.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/include/asm/memory.h |   38 ++++++++++++++++++++++++++++++++++++--
 arch/arm/kernel/head.S        |    4 ++++
 arch/arm/kernel/setup.c       |    2 +-
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index a4fc01e..0643454 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -154,13 +154,47 @@
 #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
 
 extern unsigned long	__pv_offset;
-extern unsigned long	__pv_phys_offset;
+extern phys_addr_t	__pv_phys_offset;
 #define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
 
 static inline phys_addr_t __virt_to_phys(unsigned long x)
 {
-	unsigned long t;
+	phys_addr_t t;
+
+#ifndef CONFIG_ARM_LPAE
 	early_patch_imm8("add", t, x, __pv_offset, 0);
+#else
+	unsigned long __tmp;
+
+#ifndef __ARMEB__
+#define PV_PHYS_HIGH	"(__pv_phys_offset + 4)"
+#else
+#define PV_PHYS_HIGH	"__pv_phys_offset"
+#endif
+
+	early_patch_stub(
+	/* type */		PATCH_IMM8,
+	/* code */
+		"ldr		%[tmp], =__pv_offset\n"
+		"ldr		%[tmp], [%[tmp]]\n"
+		"add		%Q[to], %[from], %[tmp]\n"
+		"ldr		%[tmp], =" PV_PHYS_HIGH "\n"
+		"ldr		%[tmp], [%[tmp]]\n"
+		"mov		%R[to], %[tmp]\n",
+	/* pad */		4,
+	/* patch_data */
+		".long		__pv_offset\n"
+		"add		%Q[to], %[from], %[imm]\n"
+		".long	"	PV_PHYS_HIGH "\n"
+		"mov		%R[to], %[imm]\n",
+	/* operands */
+		: [to]	 "=r"	(t),
+		  [tmp]	 "=&r"	(__tmp)
+		: [from] "r"	(x),
+		  [imm]	 "I"	(__IMM8),
+			 "i"	(&__pv_offset),
+			 "i"	(&__pv_phys_offset));
+#endif
 	return t;
 }
 
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 69a3c09..61fb8df 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -530,7 +530,11 @@ ENDPROC(__fixup_pv_offsets)
 
 	.align
 1:	.long	.
+#if defined(CONFIG_ARM_LPAE) && defined(__ARMEB__)
+	.long	__pv_phys_offset + 4
+#else
 	.long	__pv_phys_offset
+#endif
 	.long	__pv_offset
 	.long	PAGE_OFFSET
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index ba649ac..94d9853 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -150,7 +150,7 @@ DEFINE_PER_CPU(struct cpuinfo_arm, cpu_data);
  * The initializers here prevent these from landing in the BSS section.
  */
 unsigned long __pv_offset = 0xdeadbeef;
-unsigned long __pv_phys_offset = 0xdeadbeef;
+phys_addr_t   __pv_phys_offset = 0xdeadbeef;
 EXPORT_SYMBOL(__pv_phys_offset);
 
 #endif
-- 
1.7.9.5

