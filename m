Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1BYBjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 20:39:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19670 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab1BYBjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 20:39:54 -0500
Message-ID: <4D67080B.9090501@kernel.org>
Date: Thu, 24 Feb 2011 17:38:19 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86,mm: Introduce init_memory_mapping_ext()
References: <20110223171945.GI26065@htj.dyndns.org> <4D656D1A.7030006@kernel.org> <20110223204656.GA27738@atj.dyndns.org> <4D657359.5060901@kernel.org> <20110223210326.GB27738@atj.dyndns.org> <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com> <20110224091557.GD7840@htj.dyndns.org>
In-Reply-To: <20110224091557.GD7840@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D670859.0012,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add extra input tbl_end. it could be smaller than end.

Prepare for init_memory_mapping_high() to align boundary to 1G.
aka end could round up to 1g bound, and will be bigger then original
node end.

init_memory_mapping will call init_memory_mapping_ext with tbl=end.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/page_types.h |    7 +++++--
 arch/x86/mm/init.c                |   22 +++++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/page_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page_types.h
+++ linux-2.6/arch/x86/include/asm/page_types.h
@@ -51,8 +51,11 @@ static inline phys_addr_t get_max_mapped
 	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
 }
 
-extern unsigned long init_memory_mapping(unsigned long start,
-					 unsigned long end);
+unsigned long init_memory_mapping_ext(unsigned long start,
+				      unsigned long end,
+				      unsigned long tbl_end);
+
+unsigned long init_memory_mapping(unsigned long start, unsigned long end);
 
 void init_memory_mapping_high(void);
 
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -30,10 +30,12 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
+static void __init find_early_table_space(unsigned long end,
+					  unsigned long tbl_end,
+					  int use_pse,
 					  int use_gbpages)
 {
-	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
+	unsigned long puds, pmds, ptes, tables, start = 0;
 	phys_addr_t base;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
@@ -66,10 +68,10 @@ static void __init find_early_table_spac
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
 
-	good_end = max_pfn_mapped << PAGE_SHIFT;
+	tbl_end = max_pfn_mapped << PAGE_SHIFT;
 #endif
 
-	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
+	base = memblock_find_in_range(start, tbl_end, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
@@ -114,8 +116,9 @@ static int __meminit save_mr(struct map_
  * This runs before bootmem is initialized and gets pages directly from
  * the physical memory. To access them they are temporarily mapped.
  */
-unsigned long __init_refok init_memory_mapping(unsigned long start,
-					       unsigned long end)
+unsigned long __init_refok init_memory_mapping_ext(unsigned long start,
+					       unsigned long end,
+					       unsigned long tbl_end)
 {
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
@@ -258,7 +261,7 @@ unsigned long __init_refok init_memory_m
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(end, tbl_end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
@@ -282,6 +285,11 @@ unsigned long __init_refok init_memory_m
 	return ret >> PAGE_SHIFT;
 }
 
+unsigned long __init_refok init_memory_mapping(unsigned long start,
+					       unsigned long end)
+{
+	return init_memory_mapping_ext(start, end, end);
+}
 
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
