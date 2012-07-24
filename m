Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2GXBK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:10:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46981 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab2GXBKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:18 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [RFC 03/23] ARM: LPAE: use phys_addr_t on virt <--> phys conversion
Date: Mon, 23 Jul 2012 21:09:05 -0400
Message-ID: <1343092165-9470-4-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up the types used when converting back and forth between
physical and virtual addresses.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/include/asm/memory.h |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index fcb5757..7629dfe 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -169,22 +169,27 @@ extern unsigned long __pv_phys_offset;
 	: "=r" (to)					\
 	: "r" (from), "I" (type))
 
-static inline unsigned long __virt_to_phys(unsigned long x)
+static inline phys_addr_t __virt_to_phys(unsigned long x)
 {
 	unsigned long t;
 	__pv_stub(x, t, "add", __PV_BITS_31_24);
 	return t;
 }
 
-static inline unsigned long __phys_to_virt(unsigned long x)
+static inline unsigned long __phys_to_virt(phys_addr_t x)
 {
 	unsigned long t;
 	__pv_stub(x, t, "sub", __PV_BITS_31_24);
 	return t;
 }
 #else
-#define __virt_to_phys(x)	((x) - PAGE_OFFSET + PHYS_OFFSET)
-#define __phys_to_virt(x)	((x) - PHYS_OFFSET + PAGE_OFFSET)
+
+#define __virt_to_phys(x)		\
+	((phys_addr_t)(x) - PAGE_OFFSET + PHYS_OFFSET)
+
+#define __phys_to_virt(x)		\
+	((unsigned long)((phys_addr_t)(x) - PHYS_OFFSET + PAGE_OFFSET))
+
 #endif
 #endif
 
@@ -219,14 +224,14 @@ static inline phys_addr_t virt_to_phys(const volatile void *x)
 
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

