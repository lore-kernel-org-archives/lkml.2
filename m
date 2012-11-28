Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2K1V72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:59:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44925 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2K1Vso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:44 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v9 42/46] x86, mm: kill numa_free_all_bootmem()
Date: Wed, 28 Nov 2012 13:47:53 -0800
Message-Id: <1354139277-17376-43-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
References: <1354139277-17376-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now NO_BOOTMEM version free_all_bootmem_node() does not really
do free_bootmem at all, and it only call register_page_bootmem_info_node
instead.

That is confusing, try to kill that free_all_bootmem_node().

Before that, this patch will remove numa_free_all_bootmem().

That function could be replaced with register_page_bootmem_info() and
free_all_bootmem();

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/numa_64.h |    2 --
 arch/x86/mm/init_64.c          |   15 +++++++++++----
 arch/x86/mm/numa_64.c          |   13 -------------
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 0c05f7a..fe4d2d4 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -1,6 +1,4 @@
 #ifndef _ASM_X86_NUMA_64_H
 #define _ASM_X86_NUMA_64_H
 
-extern unsigned long numa_free_all_bootmem(void);
-
 #endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1d53def..4178530 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -629,6 +629,16 @@ EXPORT_SYMBOL_GPL(arch_add_memory);
 
 static struct kcore_list kcore_vsyscall;
 
+static void __init register_page_bootmem_info(void)
+{
+#ifdef CONFIG_NUMA
+	int i;
+
+	for_each_online_node(i)
+		register_page_bootmem_info_node(NODE_DATA(i));
+#endif
+}
+
 void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
@@ -641,11 +651,8 @@ void __init mem_init(void)
 	reservedpages = 0;
 
 	/* this will put all low memory onto the freelists */
-#ifdef CONFIG_NUMA
-	totalram_pages = numa_free_all_bootmem();
-#else
+	register_page_bootmem_info();
 	totalram_pages = free_all_bootmem();
-#endif
 
 	absent_pages = absent_pages_in_range(0, max_pfn);
 	reservedpages = max_pfn - totalram_pages - absent_pages;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 92e2711..9405ffc 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -10,16 +10,3 @@ void __init initmem_init(void)
 {
 	x86_numa_init();
 }
-
-unsigned long __init numa_free_all_bootmem(void)
-{
-	unsigned long pages = 0;
-	int i;
-
-	for_each_online_node(i)
-		pages += free_all_bootmem_node(NODE_DATA(i));
-
-	pages += free_low_memory_core_early(MAX_NUMNODES);
-
-	return pages;
-}
-- 
1.7.7

