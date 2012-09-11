Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab2IKRlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:41:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50728 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab2IKRjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:39:54 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v3 15/17] ARM: mm: use physical addresses in highmem sanity checks
Date: Tue, 11 Sep 2012 13:39:13 -0400
Message-ID: <1347385155-11643-16-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347385155-11643-1-git-send-email-cyril@ti.com>
References: <1347385155-11643-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the highmem sanity checking code to use physical addresses
instead.  This change eliminates the wrap-around problems associated with the
original virtual address based checks, and this simplifies the code a bit.

The one constraint imposed here is that low physical memory must be mapped in
a monotonically increasing fashion if there are multiple banks of memory,
i.e., x < y must => pa(x) < pa(y).

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/mm/mmu.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 95daa67..ac4e7ae 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -913,6 +913,7 @@ phys_addr_t arm_lowmem_limit __initdata = 0;
 void __init sanity_check_meminfo(void)
 {
 	int i, j, highmem = 0;
+	phys_addr_t vmalloc_limit = __pa(vmalloc_min - 1) + 1;
 
 	for (i = 0, j = 0; i < meminfo.nr_banks; i++) {
 		struct membank *bank = &meminfo.bank[j];
@@ -922,8 +923,7 @@ void __init sanity_check_meminfo(void)
 			highmem = 1;
 
 #ifdef CONFIG_HIGHMEM
-		if (__va(bank->start) >= vmalloc_min ||
-		    __va(bank->start) < (void *)PAGE_OFFSET)
+		if (bank->start >= vmalloc_limit)
 			highmem = 1;
 
 		bank->highmem = highmem;
@@ -932,8 +932,8 @@ void __init sanity_check_meminfo(void)
 		 * Split those memory banks which are partially overlapping
 		 * the vmalloc area greatly simplifying things later.
 		 */
-		if (!highmem && __va(bank->start) < vmalloc_min &&
-		    bank->size > vmalloc_min - __va(bank->start)) {
+		if (!highmem && bank->start < vmalloc_limit &&
+		    bank->size > vmalloc_limit - bank->start) {
 			if (meminfo.nr_banks >= NR_BANKS) {
 				printk(KERN_CRIT "NR_BANKS too low, "
 						 "ignoring high memory\n");
@@ -942,12 +942,12 @@ void __init sanity_check_meminfo(void)
 					(meminfo.nr_banks - i) * sizeof(*bank));
 				meminfo.nr_banks++;
 				i++;
-				bank[1].size -= vmalloc_min - __va(bank->start);
-				bank[1].start = __pa(vmalloc_min - 1) + 1;
+				bank[1].size -= vmalloc_limit - bank->start;
+				bank[1].start = vmalloc_limit;
 				bank[1].highmem = highmem = 1;
 				j++;
 			}
-			bank->size = vmalloc_min - __va(bank->start);
+			bank->size = vmalloc_limit - bank->start;
 		}
 #else
 		bank->highmem = highmem;
@@ -967,8 +967,7 @@ void __init sanity_check_meminfo(void)
 		 * Check whether this memory bank would entirely overlap
 		 * the vmalloc area.
 		 */
-		if (__va(bank->start) >= vmalloc_min ||
-		    __va(bank->start) < (void *)PAGE_OFFSET) {
+		if (bank->start >= vmalloc_limit) {
 			printk(KERN_NOTICE "Ignoring RAM at %.8llx-%.8llx "
 			       "(vmalloc region overlap).\n",
 			       (unsigned long long)bank->start,
@@ -980,9 +979,8 @@ void __init sanity_check_meminfo(void)
 		 * Check whether this memory bank would partially overlap
 		 * the vmalloc area.
 		 */
-		if (__va(bank->start + bank->size - 1) >= vmalloc_min ||
-		    __va(bank->start + bank->size - 1) <= __va(bank->start)) {
-			unsigned long newsize = vmalloc_min - __va(bank->start);
+		if (bank->start + bank->size > vmalloc_limit)
+			unsigned long newsize = vmalloc_limit - bank->start;
 			printk(KERN_NOTICE "Truncating RAM at %.8llx-%.8llx "
 			       "to -%.8llx (vmalloc region overlap).\n",
 			       (unsigned long long)bank->start,
-- 
1.7.9.5

