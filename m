Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2LRHVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:21:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2LRHQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:16:26 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7 05/27] x86, realmode: Separate real_mode reserve and setup
Date: Mon, 17 Dec 2012 23:15:37 -0800
Message-Id: <1355814959-10573-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we switch to use #PF handler help to set page table, init_level4_pgt
will have entries set after init_mem_mapping.
We need to move coping init_level4_pgt to trampoline_pgd after than.

So separate reserve_real_mode out

Move the setup after init_mem_mapping()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/realmode.h |    3 ++-
 arch/x86/kernel/setup.c         |    4 +++-
 arch/x86/realmode/init.c        |   30 +++++++++++++++++++-----------
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index fe1ec5b..9c6b890 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -58,6 +58,7 @@ extern unsigned char boot_gdt[];
 extern unsigned char secondary_startup_64[];
 #endif
 
-extern void __init setup_real_mode(void);
+void reserve_real_mode(void);
+void setup_real_mode(void);
 
 #endif /* _ARCH_X86_REALMODE_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 81ea5a5..01b22d0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,10 +913,12 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
 			(max_pfn_mapped<<PAGE_SHIFT) - 1);
 
-	setup_real_mode();
+	reserve_real_mode();
 
 	init_mem_mapping();
 
+	setup_real_mode();
+
 	memblock.current_limit = get_max_mapped();
 	dma_contiguous_reserve(0);
 
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 815eec1..8893bae 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -8,9 +8,26 @@
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
 
-void __init setup_real_mode(void)
+void __init reserve_real_mode(void)
 {
 	phys_addr_t mem;
+	unsigned char *base;
+	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
+
+	/* Has to be in very low memory so we can execute real-mode AP code. */
+	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	if (!mem)
+		panic("Cannot allocate trampoline\n");
+
+	base = __va(mem);
+	memblock_reserve(mem, size);
+	real_mode_header = (struct real_mode_header *) base;
+	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
+	       base, (unsigned long long)mem, size);
+}
+
+void __init setup_real_mode(void)
+{
 	u16 real_mode_seg;
 	u32 *rel;
 	u32 count;
@@ -25,16 +42,7 @@ void __init setup_real_mode(void)
 	u64 efer;
 #endif
 
-	/* Has to be in very low memory so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
-	if (!mem)
-		panic("Cannot allocate trampoline\n");
-
-	base = __va(mem);
-	memblock_reserve(mem, size);
-	real_mode_header = (struct real_mode_header *) base;
-	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
-	       base, (unsigned long long)mem, size);
+	base = (unsigned char *)real_mode_header;
 
 	memcpy(base, real_mode_blob, size);
 
-- 
1.7.10.4

