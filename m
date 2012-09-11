Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2IKRjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:39:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50721 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab2IKRjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:39:45 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v3 04/17] ARM: LPAE: use phys_addr_t on virt <--> phys conversion
Date: Tue, 11 Sep 2012 13:39:02 -0400
Message-ID: <1347385155-11643-5-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347385155-11643-1-git-send-email-cyril@ti.com>
References: <1347385155-11643-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up the types used when converting back and forth between
physical and virtual addresses.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/include/asm/memory.h |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 512d234..a4fc01e 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -157,22 +157,32 @@ extern unsigned long	__pv_offset;
 extern unsigned long	__pv_phys_offset;
 #define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
 
-static inline unsigned long __virt_to_phys(unsigned long x)
+static inline phys_addr_t __virt_to_phys(unsigned long x)
 {
 	unsigned long t;
 	early_patch_imm8("add", t, x, __pv_offset, 0);
 	return t;
 }
 
-static inline unsigned long __phys_to_virt(unsigned long x)
+static inline unsigned long __phys_to_virt(phys_addr_t x)
 {
-	unsigned long t;
-	early_patch_imm8("sub", t, x, __pv_offset, 0);
+	unsigned long t, xlo = x;
+	early_patch_imm8("sub", t, xlo, __pv_offset, 0);
 	return t;
 }
+
 #else
-#define __virt_to_phys(x)	((x) - PAGE_OFFSET + PHYS_OFFSET)
-#define __phys_to_virt(x)	((x) - PHYS_OFFSET + PAGE_OFFSET)
+
+static inline phys_addr_t __virt_to_phys(unsigned long x)
+{
+	return (phys_addr_t)x - PAGE_OFFSET + PHYS_OFFSET;
+}
+
+static inline unsigned long __phys_to_virt(phys_addr_t x)
+{
+	return x - PHYS_OFFSET + PAGE_OFFSET;
+}
+
 #endif
 #endif
 #endif /* __ASSEMBLY__ */
@@ -210,14 +220,14 @@ static inline phys_addr_t virt_to_phys(const volatile void *x)
 
 static inline void *phys_to_virt(phys_addr_t x)
 {
-	return (void *)(__phys_to_virt((unsigned long)(x)));
+	return (void *)__phys_to_virt(x);
 }
 
 /*
  * Drivers should NOT use these either.
  */
 #define __pa(x)			__virt_to_phys((unsigned long)(x))
-#define __va(x)			((void *)__phys_to_virt((unsigned long)(x)))
+#define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
 /*
-- 
1.7.9.5

