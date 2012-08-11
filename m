Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544Ab2HKB3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 21:29:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57430 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759527Ab2HKBZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 21:25:47 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v2 18/22] ARM: add virt_to_idmap for interconnect aliasing
Date: Fri, 10 Aug 2012 21:25:01 -0400
Message-ID: <1344648306-15619-19-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344648306-15619-1-git-send-email-cyril@ti.com>
References: <1344648306-15619-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Andrianov <vitalya@ti.com>

On some PAE systems (e.g. TI Keystone), memory is above the 32-bit addressible
limit, and the interconnect provides an aliased view of parts of physical
memory in the 32-bit addressible space.  This alias is strictly for boot time
usage, and is not otherwise usable because of coherency limitations.

On such systems, the idmap mechanism needs to take this aliased mapping into
account.  This patch introduces a virt_to_idmap() macro, which can be used on
such sub-architectures to represent the interconnect supported boot time
alias.  Most other systems would leave this macro untouched, i.e., do a simply
virt_to_phys() and nothing more.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/include/asm/memory.h |    9 +++++++++
 arch/arm/kernel/smp.c         |    2 +-
 arch/arm/mm/idmap.c           |    4 ++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index e5d0cc8..59f101c 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -257,6 +257,15 @@ static inline void *phys_to_virt(phys_addr_t x)
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
 /*
+ * These are for systems that have a hardware interconnect supported alias of
+ * physical memory for idmap purposes.  Most cases should leave these
+ * untouched.
+ */
+#ifndef virt_to_idmap
+#define virt_to_idmap(x) virt_to_phys(x)
+#endif
+
+/*
  * Virtual <-> DMA view memory address translations
  * Again, these are *only* valid on the kernel direct mapped RAM
  * memory.  Use of these is *deprecated* (and that doesn't mean
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 9831716..628f895 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -62,7 +62,7 @@ static DECLARE_COMPLETION(cpu_running);
 
 static unsigned long get_arch_pgd(pgd_t *pgd)
 {
-	phys_addr_t pgdir = virt_to_phys(pgd);
+	phys_addr_t pgdir = virt_to_idmap(pgd);
 	BUG_ON(pgdir & ARCH_PGD_MASK);
 	return pgdir >> ARCH_PGD_SHIFT;
 }
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index ab88ed4..919cb6e 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -85,8 +85,8 @@ static int __init init_static_idmap(void)
 		return -ENOMEM;
 
 	/* Add an identity mapping for the physical address of the section. */
-	idmap_start = virt_to_phys((void *)__idmap_text_start);
-	idmap_end = virt_to_phys((void *)__idmap_text_end);
+	idmap_start = virt_to_idmap((void *)__idmap_text_start);
+	idmap_end = virt_to_idmap((void *)__idmap_text_end);
 
 	pr_info("Setting up static identity map for 0x%llx - 0x%llx\n",
 		(long long)idmap_start, (long long)idmap_end);
-- 
1.7.9.5

