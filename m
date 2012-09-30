Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2I3H6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:58:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20399 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2I3H5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:57:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/13] x86: Fixup code testing if a pfn is direct mapped
Date: Sun, 30 Sep 2012 00:57:21 -0700
Message-Id: <1348991844-12285-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.shin@amd.com>

Update code that previously assumed pfns [ 0 - max_low_pfn_mapped ) and
[ 4GB - max_pfn_mapped ) were always direct mapped, to now look up
pfn_mapped ranges instead.


-v2: change applying sequence to keep git bisecting working.
     so add dummy pfn_range_is_mapped(). - Yinghai Lu

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/page_types.h |    8 ++++++++
 arch/x86/kernel/cpu/amd.c         |    8 +++-----
 arch/x86/platform/efi/efi.c       |    8 ++++----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index e21fdd1..45aae6e 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -51,6 +51,14 @@ static inline phys_addr_t get_max_mapped(void)
 	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
 }
 
+static inline bool pfn_range_is_mapped(unsigned long start_pfn,
+					unsigned long end_pfn)
+{
+	return end_pfn <= max_low_pfn_mapped ||
+	       (end_pfn > (1UL << (32 - PAGE_SHIFT)) &&
+		end_pfn <= max_pfn_mapped);
+}
+
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f7e98a2..9619ba6 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -676,12 +676,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * benefit in doing so.
 		 */
 		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+			unsigned long pfn = tseg >> PAGE_SHIFT;
+
 			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
-			if ((tseg>>PMD_SHIFT) <
-				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
-				((tseg>>PMD_SHIFT) <
-				(max_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) &&
-				(tseg>>PMD_SHIFT) >= (1ULL<<(32 - PMD_SHIFT))))
+			if (pfn_range_is_mapped(pfn, pfn + 1))
 				set_memory_4k((unsigned long)__va(tseg), 1);
 		}
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f8a30da..4e5320c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -823,7 +823,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages, end_pfn;
+	u64 end, systab, addr, npages, start_pfn, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
 
@@ -876,10 +876,10 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
+		start_pfn = PFN_DOWN(md->phys_addr);
 		end_pfn = PFN_UP(end);
-		if (end_pfn <= max_low_pfn_mapped
-		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
-			&& end_pfn <= max_pfn_mapped))
+
+		if (pfn_range_is_mapped(start_pfn, end_pfn))
 			va = __va(md->phys_addr);
 		else
 			va = efi_ioremap(md->phys_addr, size, md->type);
-- 
1.7.7

