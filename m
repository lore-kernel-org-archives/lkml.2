Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1CKPsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:48:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37363 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755762Ab1CKPst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:48:49 -0500
Subject: memmap_valid_within problem with sparsely populated sections
From: Will Deacon <will.deacon@arm.com>
To: linux@arm.linux.org.uk, mel@csn.ul.ie
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 15:48:12 +0000
Message-ID: <1299858492.11981.6.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In commit eb33575c ("[ARM] Double check memmap is actually valid with a memmap
has unexpected holes V2"), a new function, memmap_valid_within, was introduced
to mmzone.h so that holes in the memmap which pass pfn_valid in SPARSEMEM
configurations can be detected and avoided.

The fix to this problem checks that the pfn <-> page linkages are correct by
calculating the page for the pfn and then checking that page_to_pfn on that
page returns the original pfn. Unfortunately, in SPARSEMEM configurations, this
results in reading from the page flags to determine the correct section. Since
the memmap here has been freed, junk is read from memory and the check is no
longer robust.

In the best case, reading from /proc/pagetypeinfo will give you the wrong
answer. In the worst case, you get SEGVs, Kernel OOPses and hung CPUs.

It seems that the only code which can really tell you if the pfn has a valid
corresponding page is architecture-specific. Indeed, the ARM implementation of
pfn_valid will give you the correct answer. I think that memmap_valid_within
needs to check whether the pfn has a struct page associated with it before
blindly reading the page flags:


diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index cddd684..ce406e5 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -273,6 +273,13 @@ static void arm_memory_present(void)
 }
 #endif
 
+#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
+int arch_has_mapping(phys_addr_t paddr)
+{
+       return memblock_is_memory(paddr);
+}
+#endif
+
 static int __init meminfo_cmp(const void *_a, const void *_b)
 {
        const struct membank *a = _a, *b = _b;
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 02ecb01..0a17c9b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1130,6 +1130,7 @@ unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
  * the zone and PFN linkages are still valid. This is expensive, but walkers
  * of the full memmap are extremely rare.
  */
+int arch_has_mapping(phys_addr_t paddr);
 int memmap_valid_within(unsigned long pfn,
                                        struct page *page, struct zone *zone);
 #else
diff --git a/mm/mmzone.c b/mm/mmzone.c
index f5b7d17..9f14b8e 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -78,6 +78,9 @@ struct zoneref *next_zones_zonelist(struct zoneref *z,
 int memmap_valid_within(unsigned long pfn,
                                        struct page *page, struct zone *zone)
 {
+       if (!arch_has_mapping(pfn << PAGE_SHIFT))
+               return 0;
+
        if (page_to_pfn(page) != pfn)
                return 0;
 

It may be that we can leave the architecture code to define memmap_valid_within
in its entirety, but maybe the page_to_pfn stuff is useful in some scenarios.

Any thoughts on the above?

Cheers,

Will


