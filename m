Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab2JIElU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:41:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37002 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2JIElM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:41:12 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/10] x86, mm: Add early_pgt_buf_*
Date: Mon,  8 Oct 2012 21:39:18 -0700
Message-Id: <1349757558-10856-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we could use the left early pgt buf in BRK at first, then use new one.

We avoid wasting in _BRK.

Also we don't need to memblock_reserve that buf in brk again, because all
BRK is reserved before.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/init.h |    3 +++
 arch/x86/mm/init.c          |   24 +++++++++++-------------
 arch/x86/mm/init_32.c       |    8 ++++++--
 arch/x86/mm/init_64.c       |    8 ++++++--
 4 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index b69e537..6ce8718 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -15,6 +15,9 @@ kernel_physical_mapping_init(unsigned long start,
 extern unsigned long __initdata pgt_buf_start;
 extern unsigned long __meminitdata pgt_buf_end;
 extern unsigned long __meminitdata pgt_buf_top;
+extern unsigned long __initdata early_pgt_buf_start;
+extern unsigned long __meminitdata early_pgt_buf_end;
+extern unsigned long __meminitdata early_pgt_buf_top;
 
 bool is_pfn_in_early_pgt_buf(unsigned long pfn);
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 1becfbd..34d47c3 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -20,10 +20,14 @@
 unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
 unsigned long __meminitdata pgt_buf_top;
+unsigned long __initdata early_pgt_buf_start;
+unsigned long __meminitdata early_pgt_buf_end;
+unsigned long __meminitdata early_pgt_buf_top;
 
 bool __init is_pfn_in_early_pgt_buf(unsigned long pfn)
 {
-	return pfn >= pgt_buf_start && pfn < pgt_buf_top;
+	return (pfn >= early_pgt_buf_start && pfn < early_pgt_buf_top) ||
+	       (pfn >= pgt_buf_start && pfn < pgt_buf_top);
 }
 
 int after_bootmem;
@@ -325,16 +329,10 @@ static void __init find_early_table_space(unsigned long start,
 		panic("Cannot find space for the kernel page tables");
 
 	init_memory_mapping(base, base + tables);
-	if (pgt_buf_end > pgt_buf_start) {
+	if (early_pgt_buf_end > early_pgt_buf_start)
 		printk(KERN_DEBUG "kernel direct mapping tables from %#lx to %#lx @ [mem %#010lx-%#010lx]\n",
-			base, base + tables - 1, pgt_buf_start << PAGE_SHIFT,
-			(pgt_buf_end << PAGE_SHIFT) - 1);
-
-		memblock_reserve(PFN_PHYS(pgt_buf_start),
-				 PFN_PHYS(pgt_buf_end) - PFN_PHYS(pgt_buf_start));
-	}
-	x86_init.mapping.make_range_readwrite(PFN_PHYS(pgt_buf_end),
-					PFN_PHYS(pgt_buf_top));
+			base, base + tables - 1, early_pgt_buf_start << PAGE_SHIFT,
+			(early_pgt_buf_end << PAGE_SHIFT) - 1);
 
 	pgt_buf_start = base >> PAGE_SHIFT;
 	pgt_buf_end = pgt_buf_start;
@@ -493,9 +491,9 @@ void  __init early_alloc_pgt_buf(void)
 
 	base = __pa(extend_brk(tables, PAGE_SIZE));
 
-	pgt_buf_start = base >> PAGE_SHIFT;
-	pgt_buf_end = pgt_buf_start;
-	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
+	early_pgt_buf_start = base >> PAGE_SHIFT;
+	early_pgt_buf_end = early_pgt_buf_start;
+	early_pgt_buf_top = early_pgt_buf_start + (tables >> PAGE_SHIFT);
 }
 
 /*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 27f7fc6..70fa732 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -61,10 +61,14 @@ bool __read_mostly __vmalloc_start_set = false;
 
 static __init void *alloc_low_page(void)
 {
-	unsigned long pfn = pgt_buf_end++;
+	unsigned long pfn;
 	void *adr;
 
-	if (pfn >= pgt_buf_top)
+	if (early_pgt_buf_end < early_pgt_buf_top)
+		pfn = early_pgt_buf_end++;
+	else if (pgt_buf_end < pgt_buf_top)
+		pfn = pgt_buf_end++;
+	else
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index aab1fc1..110c1e4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -316,7 +316,7 @@ void __init cleanup_highmap(void)
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = pgt_buf_end++;
+	unsigned long pfn;
 	void *adr;
 
 	if (after_bootmem) {
@@ -326,7 +326,11 @@ static __ref void *alloc_low_page(unsigned long *phys)
 		return adr;
 	}
 
-	if (pfn >= pgt_buf_top)
+	if (early_pgt_buf_end < early_pgt_buf_top)
+		pfn = early_pgt_buf_end++;
+	else if (pgt_buf_end < pgt_buf_top)
+		pfn = pgt_buf_end++;
+	else
 		panic("alloc_low_page: ran out of memory");
 
 	adr = __va(pfn * PAGE_SIZE);
-- 
1.7.7

