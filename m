Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2GaXKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:10:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42719 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2GaXFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:05:35 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH 18/22] ARM: add virt_to_idmap for interconnect aliasing
Date: Tue, 31 Jul 2012 19:04:54 -0400
Message-ID: <1343775898-28345-19-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343775898-28345-1-git-send-email-cyril@ti.com>
References: <1343775898-28345-1-git-send-email-cyril@ti.com>
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
 arch/arm/kernel/smp.c         |    4 ++--
 arch/arm/mm/idmap.c           |    4 ++--
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 0c1b396..4bf47ed 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -231,6 +231,15 @@ static inline void *phys_to_virt(phys_addr_t x)
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
index e41e1be..cce630c 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -72,10 +72,10 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 	 */
 	secondary_data.stack = task_stack_page(idle) + THREAD_START_SP;
 
-	pgdir = virt_to_phys(idmap_pgd);
+	pgdir = virt_to_idmap(idmap_pgd);
 	secondary_data.pgdir = pgdir >> ARCH_PGD_SHIFT;
 
-	pgdir = virt_to_phys(swapper_pg_dir);
+	pgdir = virt_to_idmap(swapper_pg_dir);
 	secondary_data.swapper_pg_dir = pgdir >> ARCH_PGD_SHIFT;
 
 	__cpuc_flush_dcache_area(&secondary_data, sizeof(secondary_data));
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

