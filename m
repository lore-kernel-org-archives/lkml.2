Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030967Ab2HQIoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:44:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40634 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab2HQIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:44:08 -0400
From: Huacai Chen <chenhc@lemote.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Subject: [PATCH V6 03/15] MIPS: Loongson: Introduce and use cpu_has_coherent_cache feature
Date: Fri, 17 Aug 2012 16:43:23 +0800
Message-Id: <1345193015-3024-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1345193015-3024-1-git-send-email-chenhc@lemote.com>
References: <1345193015-3024-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loongson-3 maintains cache coherency by hardware. So we introduce a cpu
feature named cpu_has_coherent_cache and use it to modify MIPS's cache
flushing functions.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
---
 arch/mips/include/asm/cacheflush.h   |    6 ++++++
 arch/mips/include/asm/cpu-features.h |    6 ++++++
 arch/mips/mm/c-r4k.c                 |   21 +++++++++++++++++++--
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
index 69468de..8c4fa0d 100644
--- a/arch/mips/include/asm/cacheflush.h
+++ b/arch/mips/include/asm/cacheflush.h
@@ -70,6 +70,9 @@ extern void (*__flush_cache_vmap)(void);
 
 static inline void flush_cache_vmap(unsigned long start, unsigned long end)
 {
+	if (cpu_has_coherent_cache)
+		return;
+
 	if (cpu_has_dc_aliases)
 		__flush_cache_vmap();
 }
@@ -78,6 +81,9 @@ extern void (*__flush_cache_vunmap)(void);
 
 static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
 {
+	if (cpu_has_coherent_cache)
+		return;
+
 	if (cpu_has_dc_aliases)
 		__flush_cache_vunmap();
 }
diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index ca400f7..8523477 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -238,6 +238,12 @@
 #define cpu_has_inclusive_pcaches	(cpu_data[0].options & MIPS_CPU_INCLUSIVE_CACHES)
 #endif
 
+#ifdef CONFIG_CPU_SUPPORTS_COHERENT_CACHE
+#define cpu_has_coherent_cache	1
+#else
+#define cpu_has_coherent_cache	0
+#endif
+
 #ifndef cpu_dcache_line_size
 #define cpu_dcache_line_size()	cpu_data[0].dcache.linesz
 #endif
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 5352387..e8ae44f 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -345,6 +345,10 @@ static inline void local_r4k___flush_cache_all(void * args)
 	r4k_blast_scache();
 	return;
 #endif
+
+	if (cpu_has_coherent_cache)
+		return;
+
 	r4k_blast_dcache();
 	r4k_blast_icache();
 
@@ -406,8 +410,12 @@ static inline void local_r4k_flush_cache_range(void * args)
 static void r4k_flush_cache_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end)
 {
-	int exec = vma->vm_flags & VM_EXEC;
+	int exec __maybe_unused;
+
+	if (cpu_has_coherent_cache)
+		return;
 
+	exec = vma->vm_flags & VM_EXEC;
 	if (cpu_has_dc_aliases || (exec && !cpu_has_ic_fills_f_dc))
 		r4k_on_each_cpu(local_r4k_flush_cache_range, vma);
 }
@@ -527,7 +535,10 @@ static inline void local_r4k_flush_cache_page(void *args)
 static void r4k_flush_cache_page(struct vm_area_struct *vma,
 	unsigned long addr, unsigned long pfn)
 {
-	struct flush_cache_page_args args;
+	struct flush_cache_page_args args __maybe_unused;
+
+	if (cpu_has_coherent_cache)
+		return;
 
 	args.vma = vma;
 	args.addr = addr;
@@ -543,6 +554,9 @@ static inline void local_r4k_flush_data_cache_page(void * addr)
 
 static void r4k_flush_data_cache_page(unsigned long addr)
 {
+	if (cpu_has_coherent_cache)
+		return;
+
 	if (in_atomic())
 		local_r4k_flush_data_cache_page((void *)addr);
 	else
@@ -701,6 +715,9 @@ static void local_r4k_flush_cache_sigtramp(void * arg)
 
 static void r4k_flush_cache_sigtramp(unsigned long addr)
 {
+	if (cpu_has_coherent_cache)
+		return;
+
 	r4k_on_each_cpu(local_r4k_flush_cache_sigtramp, (void *) addr);
 }
 
-- 
1.7.7.3

