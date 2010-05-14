Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0ENAXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:23:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52557 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0ENAXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:23:32 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 21/35] x86, lmb: Use lmb_memory_size()/lmb_free_memory_size() to get correct dma_reserve
Date: Thu, 13 May 2010 17:19:42 -0700
Message-Id: <1273796396-29649-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BEC97AE.0086,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb_memory_size() will return memory size in lmb.memory.region.
lmb_free_memory_size() will return free memory size in lmb.memory.region.

So We can get exact reseved size in specified range.

Set the size right after initmem_init(), because later bootmem API will
get area above 16M. (except some fallback).

Later after we remove the bootmem, We could call that just before paging_init().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h |    2 ++
 arch/x86/kernel/e820.c      |   17 +++++++++++++++++
 arch/x86/kernel/setup.c     |    1 +
 arch/x86/mm/init_64.c       |    7 -------
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 6fbd8cd..f59db16 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -118,6 +118,8 @@ extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
 void init_lmb_memory(void);
 void fill_lmb_memory(void);
+void find_lmb_dma_reserve(void);
+
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 12e827b..92c6021 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1103,3 +1103,20 @@ void __init fill_lmb_memory(void)
 	lmb_analyze();
 	lmb_dump_all();
 }
+
+void __init find_lmb_dma_reserve(void)
+{
+#ifdef CONFIG_X86_64
+	u64 free_size_pfn;
+	u64 mem_size_pfn;
+	/*
+	 * need to find out used area below MAX_DMA_PFN
+	 * need to use lmb to get free size in [0, MAX_DMA_PFN]
+	 * at first, and assume boot_mem will not take below MAX_DMA_PFN
+	 */
+	mem_size_pfn = lmb_memory_size(0, MAX_DMA_PFN << PAGE_SHIFT) >> PAGE_SHIFT;
+	free_size_pfn = lmb_free_memory_size(0, MAX_DMA_PFN << PAGE_SHIFT) >> PAGE_SHIFT;
+	set_dma_reserve(mem_size_pfn - free_size_pfn);
+#endif
+}
+
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e4fe910..c5ec1b8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1001,6 +1001,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	initmem_init(0, max_pfn, acpi, k8);
+	find_lmb_dma_reserve();
 #ifndef CONFIG_NO_BOOTMEM
 	lmb_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0d2252c..37c7a82 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -53,8 +53,6 @@
 #include <asm/init.h>
 #include <linux/bootmem.h>
 
-static unsigned long dma_reserve __initdata;
-
 static int __init parse_direct_gbpages_off(char *arg)
 {
 	direct_gbpages = 0;
@@ -821,11 +819,6 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 
 	reserve_bootmem(phys, len, flags);
 
-	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
-		dma_reserve += len / PAGE_SIZE;
-		set_dma_reserve(dma_reserve);
-	}
-
 	return 0;
 }
 #endif
-- 
1.6.4.2

