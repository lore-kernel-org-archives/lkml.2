Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2HNWj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:39:28 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:37821
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab2HNWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:39:26 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8RO9M-01-LYU-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 3/4] x86: Only direct map addresses that are marked as E820_RAM
Date: Tue, 14 Aug 2012 17:39:16 -0500
Message-ID: <1344983957-4996-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
backed by actual DRAM. This is fine for holes under 4GB which are covered
by fixed and variable range MTRRs to be UC. However, we run into trouble
on higher memory addresses which cannot be covered by MTRRs.

Our system with 1TB of RAM has an e820 that looks like this:

 BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
 BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
 BIOS-e820: [mem 0x00000000000d0000-0x00000000000fffff] reserved
 BIOS-e820: [mem 0x0000000000100000-0x00000000c7ebffff] usable
 BIOS-e820: [mem 0x00000000c7ec0000-0x00000000c7ed7fff] ACPI data
 BIOS-e820: [mem 0x00000000c7ed8000-0x00000000c7ed9fff] ACPI NVS
 BIOS-e820: [mem 0x00000000c7eda000-0x00000000c7ffffff] reserved
 BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
 BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
 BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
 BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
 BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
 BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable

and so direct mappings are created for huge memory hole between
0x000000e038000000 to 0x0000010000000000. Even though the kernel never
generates memory accesses in that region, since the page tables mark
them incorrectly as being WB, our (AMD) processor ends up causing a MCE
while doing some memory bookkeeping/optimizations around that area.

This patch iterates through e820 and only direct maps ranges that are
marked as E820_RAM, and keeps track of those pfn ranges. Depending on
the alignment of E820 ranges, this may possibly result in using smaller
size (i.e. 4K instead of 2M or 1G) page tables.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/page_types.h |    9 +++
 arch/x86/kernel/setup.c           |  131 +++++++++++++++++++++++++++++--------
 arch/x86/mm/init.c                |    2 +
 arch/x86/mm/init_64.c             |    6 +-
 4 files changed, 115 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index e21fdd1..409047a 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -3,6 +3,7 @@
 
 #include <linux/const.h>
 #include <linux/types.h>
+#include <asm/e820.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
@@ -40,12 +41,20 @@
 #endif	/* CONFIG_X86_64 */
 
 #ifndef __ASSEMBLY__
+#include <linux/range.h>
 
 extern int devmem_is_allowed(unsigned long pagenr);
 
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+extern struct range pfn_mapped[E820_X_MAX];
+extern int nr_pfn_mapped;
+
+extern void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn);
+extern bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
+extern bool pfn_is_mapped(unsigned long pfn);
+
 static inline phys_addr_t get_max_mapped(void)
 {
 	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 751e020..cba080e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -115,13 +115,46 @@
 #include <asm/prom.h>
 
 /*
- * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
- * The direct mapping extends to max_pfn_mapped, so that we can directly access
- * apertures, ACPI and other tables without having to play with fixmaps.
+ * max_low_pfn_mapped: highest direct mapped pfn under 4GB
+ * max_pfn_mapped:     highest direct mapped pfn over 4GB
+ *
+ * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
+ * represented by pfn_mapped
  */
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
+struct range pfn_mapped[E820_X_MAX];
+int nr_pfn_mapped;
+
+void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
+{
+	nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
+					     nr_pfn_mapped, start_pfn, end_pfn);
+
+	max_pfn_mapped = max(max_pfn_mapped, end_pfn);
+
+	if (end_pfn <= (1UL << (32 - PAGE_SHIFT)))
+		max_low_pfn_mapped = max(max_low_pfn_mapped, end_pfn);
+}
+
+bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
+{
+	int i;
+
+	for (i = 0; i < nr_pfn_mapped; i++)
+		if ((start_pfn >= pfn_mapped[i].start) &&
+		    (end_pfn <= pfn_mapped[i].end))
+			return true;
+
+	return false;
+}
+
+bool pfn_is_mapped(unsigned long pfn)
+{
+	return pfn_range_is_mapped(pfn, pfn + 1);
+}
+
 #ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
@@ -296,6 +329,71 @@ static void __init cleanup_highmap(void)
 }
 #endif
 
+/*
+ * Iterate through E820 memory map and create direct mappings for only E820_RAM
+ * regions. We cannot simply create direct mappings for all pfns from
+ * [0 to max_low_pfn) and [4GB to max_pfn) because of possible memory holes in
+ * high addresses that cannot be marked as UC by fixed/variable range MTRRs.
+ * Depending on the alignment of E820 ranges, this may possibly result in using
+ * smaller size (i.e. 4K instead of 2M or 1G) page tables.
+ */
+static void __init init_memory(void)
+{
+	int i;
+	unsigned long init_pfn = max_pfn_mapped;
+
+	/* add initial memory already mapped by early boot process */
+	add_pfn_range_mapped(0, init_pfn);
+
+	pr_info("initial memory mapped: [mem 0x00000000-%#010lx]\n",
+			(init_pfn<<PAGE_SHIFT) - 1);
+
+	init_gbpages();
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 start = ei->addr;
+		u64 end = ei->addr + ei->size;
+
+		/* we only map E820_RAM */
+		if (ei->type != E820_RAM)
+			continue;
+
+		/* skip over initial memory mapped */
+		if ((end >> PAGE_SHIFT) <= init_pfn)
+			continue;
+
+		if ((start >> PAGE_SHIFT) < init_pfn)
+			start = init_pfn << PAGE_SHIFT;
+#ifdef CONFIG_X86_32
+		/* on 32 bit, we only map up to max_low_pfn */
+		if ((start >> PAGE_SHIFT) >= max_low_pfn)
+			continue;
+
+		if ((end >> PAGE_SHIFT) > max_low_pfn)
+			end = max_low_pfn << PAGE_SHIFT;
+#endif
+		init_memory_mapping(start, end);
+	}
+
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
+}
+
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
@@ -906,35 +1004,10 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
-	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
-			(max_pfn_mapped<<PAGE_SHIFT) - 1);
-
 	setup_real_mode();
 
-	init_gbpages();
+	init_memory();
 
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
-	/* max_pfn_mapped is updated here */
-	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
-	max_pfn_mapped = max_low_pfn_mapped;
-
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
-	}
-#endif
 	memblock.current_limit = get_max_mapped();
 	dma_contiguous_reserve(0);
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e2b21e0..d7b24da 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -301,6 +301,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		early_memtest(start, end);
 
+	add_pfn_range_mapped(start >> PAGE_SHIFT, ret >> PAGE_SHIFT);
+
 	return ret >> PAGE_SHIFT;
 }
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..ab558eb 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -657,13 +657,11 @@ int arch_add_memory(int nid, u64 start, u64 size)
 {
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
-	unsigned long last_mapped_pfn, start_pfn = start >> PAGE_SHIFT;
+	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	last_mapped_pfn = init_memory_mapping(start, start + size);
-	if (last_mapped_pfn > max_pfn_mapped)
-		max_pfn_mapped = last_mapped_pfn;
+	init_memory_mapping(start, start + size);
 
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
-- 
1.7.9.5


