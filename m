Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2GaXGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:06:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41487 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab2GaXGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:06:05 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH 04/22] ARM: LPAE: support 64-bit virt/phys patching
Date: Tue, 31 Jul 2012 19:04:40 -0400
Message-ID: <1343775898-28345-5-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343775898-28345-1-git-send-email-cyril@ti.com>
References: <1343775898-28345-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for 64-bit physical addresses in virt_to_phys
patching.  This does not do real 64-bit add/sub, but instead patches in the
upper 32-bits of the phys_offset directly into the output of virt_to_phys.

In addition to adding 64-bit support, this patch also adds a set_phys_offset()
helper that is needed on architectures that need to modify PHYS_OFFSET during
initialization.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/include/asm/memory.h |   22 +++++++++++++++-------
 arch/arm/kernel/head.S        |    6 ++++++
 arch/arm/kernel/setup.c       |   14 ++++++++++++++
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 4a0108f..110495c 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -153,23 +153,31 @@
 #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
 
 extern unsigned long __pv_phys_offset;
-#define PHYS_OFFSET __pv_phys_offset
-
+extern unsigned long __pv_phys_offset_high;
 extern unsigned long __pv_offset;
 
+extern void set_phys_offset(phys_addr_t po);
+
+#define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
+
 static inline phys_addr_t __virt_to_phys(unsigned long x)
 {
-	unsigned long t;
-	early_patch_imm8(x, t, "add", __pv_offset);
-	return t;
+	unsigned long tlo, thi = 0;
+
+	early_patch_imm8(x, tlo, "add", __pv_offset);
+	if (sizeof(phys_addr_t) > 4)
+		early_patch_imm8(0, thi, "add", __pv_phys_offset_high);
+
+	return (u64)tlo | (u64)thi << 32;
 }
 
 static inline unsigned long __phys_to_virt(phys_addr_t x)
 {
-	unsigned long t;
-	early_patch_imm8(x, t, "sub", __pv_offset);
+	unsigned long t, xlo = x;
+	early_patch_imm8(xlo, t, "sub", __pv_offset);
 	return t;
 }
+
 #else
 
 #define __virt_to_phys(x)		\
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index d165896..fa820b3 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -532,6 +532,12 @@ __pv_phys_offset:
 	.long	0
 	.size	__pv_phys_offset, . - __pv_phys_offset
 
+	.globl	__pv_phys_offset_high
+	.type	__pv_phys_offset_high, %object
+__pv_phys_offset_high:
+	.long	0
+	.size	__pv_phys_offset_high, . - __pv_phys_offset_high
+
 	.globl	__pv_offset
 	.type	__pv_offset, %object
 __pv_offset:
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 15a7699..bba3fdc 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -67,6 +67,20 @@
 #define MEM_SIZE	(16*1024*1024)
 #endif
 
+#ifdef CONFIG_ARM_PATCH_PHYS_VIRT
+/*
+ * set_phys_offset() sets PHYS_OFFSET and pv_offset.
+ * Note: this is unsafe to use beyond setup_arch().
+ */
+void __init set_phys_offset(phys_addr_t po)
+{
+	__pv_phys_offset	= po;
+	__pv_phys_offset_high	= (u64)po >> 32;
+	__pv_offset		= po - PAGE_OFFSET;
+}
+
+#endif
+
 #if defined(CONFIG_FPE_NWFPE) || defined(CONFIG_FPE_FASTFPE)
 char fpe_type[8];
 
-- 
1.7.9.5

