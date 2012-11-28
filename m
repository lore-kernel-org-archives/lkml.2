Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2K1HwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:52:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40413 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2K1Hv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:51:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 12/13] x86, 64bit: Print init kernel lowmap correctly
Date: Tue, 27 Nov 2012 23:50:41 -0800
Message-Id: <1354089042-10023-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we get x86_64_start_kernel from arch/x86/kernel/head_64.S,

We have
1. kernel highmap 512M (KERNEL_IMAGE_SIZE) from kernel loaded address.
2. kernel lowmap: [0, 1024M), and size (_end - _text) from kernel
   loaded address.

for example, if the kernel bzImage is loaded high from 8G, will get:
1. kernel highmap:  [8G, 8G+512M)
2. kernel lowmap: [0, 1024M), and  [8G, 8G +_end - _text)

So max_pfn_mapped that is for low map pfn recording is not that
simple to 512M for 64 bit.

Try to print out two ranges, when kernel is loaded high.

Also need to use KERNEL_IMAGE_SIZE directly for highmap cleanup.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/head64.c |    2 --
 arch/x86/kernel/setup.c  |   23 +++++++++++++++++++++--
 arch/x86/mm/init_64.c    |    6 +++++-
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 8ea1bc9..8d426b4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -97,8 +97,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
-	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
-
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2dbe2ce..87473fc 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -681,6 +681,26 @@ static int __init parse_reservelow(char *p)
 
 early_param("reservelow", parse_reservelow);
 
+static __init void print_init_mem_mapped(void)
+{
+#ifdef CONFIG_X86_32
+	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
+			(max_pfn_mapped<<PAGE_SHIFT) - 1);
+#else
+	unsigned long text = __pa_symbol(&_text);
+	unsigned long end = round_up(__pa_symbol(_end) - 1, PMD_SIZE);
+
+	if (end <= PUD_SIZE)
+		printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
+			PUD_SIZE - 1);
+	else if (text <= PUD_SIZE)
+		printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
+			end - 1);
+	else
+		printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx] [mem %#010lx-%#010lx]\n",
+			PUD_SIZE - 1, text, end - 1);
+#endif
+}
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -949,8 +969,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
-	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
-			(max_pfn_mapped<<PAGE_SHIFT) - 1);
+	print_init_mem_mapped();
 
 	setup_real_mode();
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4178530..30f6190 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -304,10 +304,14 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
 void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+	unsigned long vaddr_end = __START_KERNEL_map + KERNEL_IMAGE_SIZE;
 	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
 
+	/* Xen has its own end somehow with abused max_pfn_mapped */
+	if (max_pfn_mapped)
+		vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+
 	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
 			continue;
-- 
1.7.7

