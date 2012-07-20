Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2GTHJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:09:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10994 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2GTHJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:09:19 -0400
X-IronPort-AV: E=Sophos;i="4.77,621,1336320000"; 
   d="scan'208";a="5444912"
Message-ID: <50090539.7020607@cn.fujitsu.com>
Date: Fri, 20 Jul 2012 15:14:01 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
CC: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [RFC PATCH 8/8] memory-hotplug: implement arch_remove_memory()
References: <5009038A.4090001@cn.fujitsu.com>
In-Reply-To: <5009038A.4090001@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/20 15:09:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/20 15:09:58,
	Serialize complete at 2012/07/20 15:09:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the entry for the removed memory to 0. If the entry related meory
is not whole removed, split it to smaller page, and clear it.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/mm/init_64.c |  159 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 156 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 78b94bc..d78f352 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -675,11 +675,164 @@ int arch_add_memory(int nid, u64 start, u64 size)
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
+static void __meminit
+phys_pte_remove(pte_t *pte_page, unsigned long addr, unsigned long end)
+{
+	unsigned pages = 0;
+	int i = pte_index(addr);
+
+	pte_t *pte = pte_page + pte_index(addr);
+
+	for (; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE, pte++) {
+
+		if (addr >= end)
+			break;
+
+		if (!pte_present(*pte))
+			continue;
+
+		pages++;
+		set_pte(pte, __pte(0));
+	}
+
+	update_page_count(PG_LEVEL_4K, -pages);
+}
+
+static void __meminit
+phys_pmd_remove(pmd_t *pmd_page, unsigned long addr, unsigned long end)
+{
+	unsigned long pages = 0, next;
+	int i = pmd_index(addr);
+
+	for (; i < PTRS_PER_PMD; i++, addr = next) {
+		unsigned long pte_phys;
+		pmd_t *pmd = pmd_page + pmd_index(addr);
+		pte_t *pte;
+
+		if (addr >= end)
+			break;
+
+		next = (addr & PMD_MASK) + PMD_SIZE;
+
+		if (!pmd_present(*pmd))
+			continue;
+
+		if (pmd_large(*pmd)) {
+			if ((addr & ~PMD_MASK) == 0 && next <= end) {
+				set_pmd(pmd, __pmd(0));
+				pages++;
+				continue;
+			}
+
+			/*
+			 * We use 2M page, but we need to remove part of them,
+			 * so split 2M page to 4K page.
+			 */
+			pte = alloc_low_page(&pte_phys);
+			__split_large_page((pte_t *)pmd, addr, pte);
+
+			spin_lock(&init_mm.page_table_lock);
+			pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
+			spin_unlock(&init_mm.page_table_lock);
+		}
+
+		spin_lock(&init_mm.page_table_lock);
+		pte = map_low_page((pte_t *)pmd_page_vaddr(*pmd));
+		phys_pte_remove(pte, addr, end);
+		unmap_low_page(pte);
+		spin_unlock(&init_mm.page_table_lock);
+	}
+	update_page_count(PG_LEVEL_2M, -pages);
+}
+
+static void __meminit
+phys_pud_remove(pud_t *pud_page, unsigned long addr, unsigned long end)
+{
+	unsigned long pages = 0, next;
+	int i = pud_index(addr);
+
+	for (; i < PTRS_PER_PUD; i++, addr = next) {
+		unsigned long pmd_phys;
+		pud_t *pud = pud_page + pud_index(addr);
+		pmd_t *pmd;
+
+		if (addr >= end)
+			break;
+
+		next = (addr & PUD_MASK) + PUD_SIZE;
+
+		if (!pud_present(*pud))
+			continue;
+
+		if (pud_large(*pud)) {
+			if ((addr & ~PUD_MASK) == 0 && next <= end) {
+				set_pud(pud, __pud(0));
+				pages++;
+				continue;
+			}
+
+			/*
+			 * We use 1G page, but we need to remove part of them,
+			 * so split 1G page to 2M page.
+			 */
+			pmd = alloc_low_page(&pmd_phys);
+			__split_large_page((pte_t *)pud, addr, (pte_t *)pmd);
+
+			spin_lock(&init_mm.page_table_lock);
+			pud_populate(&init_mm, pud, __va(pmd_phys));
+			spin_unlock(&init_mm.page_table_lock);
+		}
+
+		pmd = map_low_page(pmd_offset(pud, 0));
+		phys_pmd_remove(pmd, addr, end);
+		unmap_low_page(pmd);
+		__flush_tlb_all();
+	}
+	__flush_tlb_all();
+
+	update_page_count(PG_LEVEL_1G, -pages);
+}
+
+void __meminit
+kernel_physical_mapping_remove(unsigned long start, unsigned long end)
+{
+	unsigned long next;
+
+	start = (unsigned long)__va(start);
+	end = (unsigned long)__va(end);
+
+	for (; start < end; start = next) {
+		pgd_t *pgd = pgd_offset_k(start);
+		pud_t *pud;
+
+		next = (start + PGDIR_SIZE) & PGDIR_MASK;
+		if (next > end)
+			next = end;
+
+		if (!pgd_present(*pgd))
+			continue;
+
+		pud = map_low_page((pud_t *)pgd_page_vaddr(*pgd));
+		phys_pud_remove(pud, __pa(start), __pa(end));
+		unmap_low_page(pud);
+	}
+
+	__flush_tlb_all();
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(unsigned long start, unsigned long size)
+int __ref arch_remove_memory(unsigned long start, unsigned long size)
 {
-	/* TODO */
-	return -EBUSY;
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+	int ret;
+
+	ret = __remove_pages(start_pfn, nr_pages);
+	WARN_ON_ONCE(ret);
+
+	kernel_physical_mapping_remove(start, start + size);
+
+	return ret;
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
-- 
1.7.1

