Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2GOLFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 07:05:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39281 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2GOLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 07:04:58 -0400
From: Pekka Enberg <penberg@kernel.org>
To: mingo@kernel.org
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Pekka Enberg <penberg@kernel.org>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 3/3] x86/mm: Separate paging setup from memory mapping
Date: Sun, 15 Jul 2012 14:04:46 +0300
Message-Id: <1342350286-6670-3-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342350286-6670-1-git-send-email-penberg@kernel.org>
References: <1342350286-6670-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move PSE and PGE bit twiddling from init_memory_mapping() to a new
setup_paging() function to simplify the former function. The
init_memory_mapping() function is called later in the boot process by
gart_iommu_init(), efi_ioremap(), and arch_add_memory() which have no
business whatsover updating the CR4 register.

Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/include/asm/page_types.h |    2 ++
 arch/x86/kernel/setup.c           |    2 ++
 arch/x86/mm/init.c                |   23 +++++++++++++----------
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index e21fdd1..529905e 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -51,6 +51,8 @@ static inline phys_addr_t get_max_mapped(void)
 	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
 }
 
+extern void setup_paging(void);
+
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 16be6dc..a883978 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,6 +913,8 @@ void __init setup_arch(char **cmdline_p)
 
 	init_gbpages();
 
+	setup_paging();
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 4f863cc..a972325 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -127,6 +127,19 @@ static unsigned long addr_to_pud_pfn(unsigned long addr)
 	return (addr >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
 }
 
+void setup_paging(void)
+{
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -159,16 +172,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
-
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
 	if (use_pse)
-- 
1.7.7.6

