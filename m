Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab1EIXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:16:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:60069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab1EIXQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:16:54 -0400
Date: Mon, 9 May 2011 23:16:47 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-9cd2b07c197e3ff594fc04f5fb3d86efbeab6ad8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1304623186-18261-2-git-send-email-mjg@redhat.com>
References: <1304623186-18261-2-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Consolidate EFI nx control
Git-Commit-ID: 9cd2b07c197e3ff594fc04f5fb3d86efbeab6ad8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 09 May 2011 23:16:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9cd2b07c197e3ff594fc04f5fb3d86efbeab6ad8
Gitweb:     http://git.kernel.org/tip/9cd2b07c197e3ff594fc04f5fb3d86efbeab6ad8
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Thu, 5 May 2011 15:19:43 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 9 May 2011 12:14:29 -0700

x86, efi: Consolidate EFI nx control

The core EFI code and 64-bit EFI code currently have independent
implementations of code for setting memory regions as executable or not.
Let's consolidate them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1304623186-18261-2-git-send-email-mjg@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
