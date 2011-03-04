Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab1CDKIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:08:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48168 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1CDKIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=k1DLnmczA8g3b3NWHxMFHf7VH5Zvyc0XZME68c+WfClD5iKF4ZnC1YFlRvJ7sAkAN1
         8WrdyEyw+lq89J0E3xoaU/1XwNpj4aArG45MB+D/u8U5LKDe2yS37TXODauvu1Vk5Een
         vBht/YfnxUh7oGomk6QRo8m8aSN9URVbiJqnU=
Date: Fri, 4 Mar 2011 11:08:10 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH tip:x86/mm] x86-64, NUMA: Revert NUMA affine page table
 allocation
Message-ID: <20110304100810.GF20499@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f89112502805c1f6a6955f90ad158e538edb319d Mon Sep 17 00:00:00 2001
Date: Fri, 4 Mar 2011 10:26:36 +0100

This patch reverts NUMA affine page table allocation added by commit
1411e0ec31 (x86-64, numa: Put pgtable to local node memory).

The commit made an undocumented change where the kernel linear mapping
strictly follows intersection of e820 memory map and NUMA
configuration.  If the physical memory configuration has holes or NUMA
nodes are not properly aligned, this leads to using unnecessarily
smaller mapping size which leads to increased TLB pressure.  For
details,

  http://thread.gmane.org/gmane.linux.kernel/1104672

Patches to fix the problem have been proposed but the underlying code
needs more cleanup and the approach itself seems a bit heavy handed
and it has been determined to revert the feature for now and come back
to it in the next developement cycle.

  http://thread.gmane.org/gmane.linux.kernel/1105959

As init_memory_mapping_high() callsites have been consolidated since
the commit, reverting is done manually.  Also, the RED-PEN comment in
arch/x86/mm/init.c is not restored as the problem no longer exists
with memblock based top-down early memory allocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/page_types.h |    2 -
 arch/x86/kernel/setup.c           |    8 +++++
 arch/x86/mm/init_64.c             |   54 -------------------------------------
 arch/x86/mm/numa_64.c             |    2 -
 4 files changed, 8 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 97e6007..bce688d 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -54,8 +54,6 @@ static inline phys_addr_t get_max_mapped(void)
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
-void init_memory_mapping_high(void);
-
 extern void initmem_init(void);
 extern void free_initmem(void);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 46e684f..c3a606c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -963,6 +963,14 @@ void __init setup_arch(char **cmdline_p)
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
 
+#ifdef CONFIG_X86_64
+	if (max_pfn > max_low_pfn) {
+		max_pfn_mapped = init_memory_mapping(1UL<<32,
+						     max_pfn<<PAGE_SHIFT);
+		/* can we preseve max_low_pfn ?*/
+		max_low_pfn = max_pfn;
+	}
+#endif
 	memblock.current_limit = get_max_mapped();
 
 	/*
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 470cc47..c8813aa 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -606,63 +606,9 @@ kernel_physical_mapping_init(unsigned long start,
 void __init initmem_init(void)
 {
 	memblock_x86_register_active_regions(0, 0, max_pfn);
-	init_memory_mapping_high();
 }
 #endif
 
-struct mapping_work_data {
-	unsigned long start;
-	unsigned long end;
-	unsigned long pfn_mapped;
-};
-
-static int __init_refok
-mapping_work_fn(unsigned long start_pfn, unsigned long end_pfn, void *datax)
-{
-	struct mapping_work_data *data = datax;
-	unsigned long pfn_mapped;
-	unsigned long final_start, final_end;
-
-	final_start = max_t(unsigned long, start_pfn<<PAGE_SHIFT, data->start);
-	final_end = min_t(unsigned long, end_pfn<<PAGE_SHIFT, data->end);
-
-	if (final_end <= final_start)
-		return 0;
-
-	pfn_mapped = init_memory_mapping(final_start, final_end);
-
-	if (pfn_mapped > data->pfn_mapped)
-		data->pfn_mapped = pfn_mapped;
-
-	return 0;
-}
-
-static unsigned long __init_refok
-init_memory_mapping_active_regions(unsigned long start, unsigned long end)
-{
-	struct mapping_work_data data;
-
-	data.start = start;
-	data.end = end;
-	data.pfn_mapped = 0;
-
-	work_with_active_regions(MAX_NUMNODES, mapping_work_fn, &data);
-
-	return data.pfn_mapped;
-}
-
-void __init_refok init_memory_mapping_high(void)
-{
-	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping_active_regions(1UL<<32,
-							 max_pfn<<PAGE_SHIFT);
-		/* can we preserve max_low_pfn ? */
-		max_low_pfn = max_pfn;
-
-		memblock.current_limit = get_max_mapped();
-	}
-}
-
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 74064e8..86491ba 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -543,8 +543,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
-	init_memory_mapping_high();
-
 	/* Finally register nodes. */
 	for_each_node_mask(nid, node_possible_map) {
 		u64 start = (u64)max_pfn << PAGE_SHIFT;
-- 
1.7.1

