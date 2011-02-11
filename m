Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1BKOBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:01:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab1BKOBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:01:06 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] x86_64: disable identity mappings statically
Date: Fri, 11 Feb 2011 15:00:30 +0100
Message-Id: <1297432830-3912-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

while browsing the page table setup code, I noticed the x86_64 head
code might not need the identity mappings at all.
It seems it's ok to switch it off completely from the begining,
unless I'm missing something.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/head64.c  |   10 ----------
 arch/x86/kernel/head_64.S |    9 ++++-----
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 2d2673c..620a9c3 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -27,13 +27,6 @@
 #include <asm/trampoline.h>
 #include <asm/bios_ebda.h>
 
-static void __init zap_identity_mappings(void)
-{
-	pgd_t *pgd = pgd_offset_k(0UL);
-	pgd_clear(pgd);
-	__flush_tlb_all();
-}
-
 /* Don't add a printk in there. printk relies on the PDA which is not initialized 
    yet. */
 static void __init clear_bss(void)
@@ -74,9 +67,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
-	/* Make NULL pointers segfault */
-	zap_identity_mappings();
-
 	/* Cleanup the over mapped high alias */
 	cleanup_highmap();
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 239046b..c55e6fa 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -341,13 +341,12 @@ ENTRY(name)
 
 	.data
 	/*
-	 * This default setting generates an ident mapping at address 0x100000
-	 * and a mapping for the kernel that precisely maps virtual address
-	 * 0xffffffff80000000 to physical address 0x000000. (always using
-	 * 2Mbyte large pages provided by PAE mode)
+	 * This default setting generates a mapping for the kernel that
+	 * precisely maps virtual address 0xffffffff80000000 to physical
+	 * address 0x000000. (always using * 2Mbyte large pages provided
+	 * by PAE mode)
 	 */
 NEXT_PAGE(init_level4_pgt)
-	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
 	.org	init_level4_pgt + L4_PAGE_OFFSET*8, 0
 	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
 	.org	init_level4_pgt + L4_START_KERNEL*8, 0
-- 
1.7.1
