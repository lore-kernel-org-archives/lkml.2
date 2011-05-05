Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1EETUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:20:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab1EETUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:20:08 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/5] efi: Consolidate EFI nx control
Date: Thu,  5 May 2011 15:19:43 -0400
Message-Id: <1304623186-18261-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1304623186-18261-1-git-send-email-mjg@redhat.com>
References: <1304623186-18261-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core EFI code and 64-bit EFI code currently have independent
implementations of code for setting memory regions as executable or not.
Let's consolidate them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/include/asm/efi.h     |    1 +
 arch/x86/platform/efi/efi.c    |   21 ++++++++++++++++-----
 arch/x86/platform/efi/efi_64.c |   28 +++++-----------------------
 3 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 8e4a165..7093e4a 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -90,6 +90,7 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
+extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern void efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f2e4fe9..7daae27 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -457,11 +457,25 @@ void __init efi_init(void)
 #endif
 }
 
+void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
+{
+	u64 addr, npages;
+
+	addr = md->virt_addr;
+	npages = md->num_pages;
+
+	memrange_efi_to_native(&addr, &npages);
+
+	if (executable)
+		set_memory_x(addr, npages);
+	else
+		set_memory_nx(addr, npages);
+}
+
 static void __init runtime_code_page_mkexec(void)
 {
 	efi_memory_desc_t *md;
 	void *p;
-	u64 addr, npages;
 
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -470,10 +484,7 @@ static void __init runtime_code_page_mkexec(void)
 		if (md->type != EFI_RUNTIME_SERVICES_CODE)
 			continue;
 
-		addr = md->virt_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&addr, &npages);
-		set_memory_x(addr, npages);
+		efi_set_executable(md, true);
 	}
 }
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac0621a..94d6b39 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -41,22 +41,7 @@
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
 
-static void __init early_mapping_set_exec(unsigned long start,
-					  unsigned long end,
-					  int executable)
-{
-	unsigned long num_pages;
-
-	start &= PMD_MASK;
-	end = (end + PMD_SIZE - 1) & PMD_MASK;
-	num_pages = (end - start) >> PAGE_SHIFT;
-	if (executable)
-		set_memory_x((unsigned long)__va(start), num_pages);
-	else
-		set_memory_nx((unsigned long)__va(start), num_pages);
-}
-
-static void __init early_runtime_code_mapping_set_exec(int executable)
+static void __init early_code_mapping_set_exec(int executable)
 {
 	efi_memory_desc_t *md;
 	void *p;
@@ -67,11 +52,8 @@ static void __init early_runtime_code_mapping_set_exec(int executable)
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
-			unsigned long end;
-			end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
-			early_mapping_set_exec(md->phys_addr, end, executable);
-		}
+		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+			efi_set_executable(md, executable);
 	}
 }
 
@@ -79,7 +61,7 @@ void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
 
-	early_runtime_code_mapping_set_exec(1);
+	early_code_mapping_set_exec(1);
 	local_irq_save(efi_flags);
 	vaddress = (unsigned long)__va(0x0UL);
 	save_pgd = *pgd_offset_k(0x0UL);
@@ -95,7 +77,7 @@ void __init efi_call_phys_epilog(void)
 	set_pgd(pgd_offset_k(0x0UL), save_pgd);
 	__flush_tlb_all();
 	local_irq_restore(efi_flags);
-	early_runtime_code_mapping_set_exec(0);
+	early_code_mapping_set_exec(0);
 }
 
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
-- 
1.7.5

