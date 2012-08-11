Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2HKB0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 21:26:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57448 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759526Ab2HKB0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 21:26:04 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v2 05/22] ARM: LPAE: support 64-bit virt_to_phys patching
Date: Fri, 10 Aug 2012 21:24:48 -0400
Message-ID: <1344648306-15619-6-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344648306-15619-1-git-send-email-cyril@ti.com>
References: <1344648306-15619-1-git-send-email-cyril@ti.com>
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
 arch/arm/include/asm/memory.h |   22 ++++++++++++++++++----
 arch/arm/kernel/head.S        |    4 ++++
 arch/arm/kernel/setup.c       |    2 +-
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 81e1714..dc5fbf3 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -154,14 +154,28 @@
 #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
 
 extern unsigned long	__pv_offset;
-extern unsigned long	__pv_phys_offset;
+extern phys_addr_t	__pv_phys_offset;
 #define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
 
 static inline phys_addr_t __virt_to_phys(unsigned long x)
 {
-	unsigned long t;
-	early_patch_imm8("add", t, x, __pv_offset, 0);
-	return t;
+	unsigned long tlo, thi;
+
+	early_patch_imm8("add", tlo, x, __pv_offset, 0);
+
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * On LPAE, we do not _need_ to do 64-bit arithmetic because the high
+	 * order 32 bits are never changed by the phys-virt offset.  We simply
+	 * patch in the high order physical address bits instead.
+	 */
+#ifdef __ARMEB__
+	early_patch_imm8_mov("mov", thi, __pv_phys_offset, 0);
+#else
+	early_patch_imm8_mov("mov", thi, __pv_phys_offset, 4);
+#endif
+#endif
+	return (u64)tlo | (u64)thi << 32;
 }
 
 static inline unsigned long __phys_to_virt(phys_addr_t x)
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
index 59e0f57..edb4f42 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -159,7 +159,7 @@ DEFINE_PER_CPU(struct cpuinfo_arm, cpu_data);
  * The initializers here prevent these from landing in the BSS section.
  */
 unsigned long __pv_offset = 0xdeadbeef;
-unsigned long __pv_phys_offset = 0xdeadbeef;
+phys_addr_t   __pv_phys_offset = 0xdeadbeef;
 EXPORT_SYMBOL(__pv_phys_offset);
 
 #endif
-- 
1.7.9.5

