Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab2IUP5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:57:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54109 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2IUP5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:57:05 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <davidb@codeaurora.org>,
        <frank.rowand@am.sony.com>, <hsweeten@visionengravers.com>,
        <linus.walleij@linaro.org>, <marc.zyngier@arm.com>, <nico@linaro.org>,
        <paul.gortmaker@windriver.com>, <plagnioj@jcrosoft.com>,
        <rabin@rab.in>, <rmallon@gmail.com>, <rob.herring@calxeda.com>,
        <sboyd@codeaurora.org>, <sjg@chromium.org>, <tglx@linutronix.de>,
        <tj@kernel.org>, <vincent.guittot@linaro.org>, <vitalya@ti.com>,
        <will.deacon@arm.com>, <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 RESEND 04/17] ARM: LPAE: use phys_addr_t on virt <--> phys conversion
Date: Fri, 21 Sep 2012 11:56:02 -0400
Message-ID: <1348242975-19184-5-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348242975-19184-1-git-send-email-cyril@ti.com>
References: <1348242975-19184-1-git-send-email-cyril@ti.com>
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
index c88d98c..88ca206 100644
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

