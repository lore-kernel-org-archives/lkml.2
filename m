Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab1BYUqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:46:30 -0500
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:54624 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab1BYUq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:46:28 -0500
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH 1/2] Cleanup x86 asm-offsets.c(PAGE_SIZE_asm, PAGE_SHIFT_asm, THREAD_SIZE_asm)
Date: Fri, 25 Feb 2011 22:46:13 +0200
Message-Id: <1298666774-17646-2-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298666774-17646-1-git-send-email-psomas@cslab.ece.ntua.gr>
References: <1298472122-4967-1-git-send-email-psomas@cslab.ece.ntua.gr>
 <1298666774-17646-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Fri, 25 Feb 2011 22:46:27 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
---
 arch/x86/kernel/asm-offsets_32.c |    4 ----
 arch/x86/kernel/asm-offsets_64.c |    1 -
 arch/x86/kernel/entry_32.S       |    2 +-
 arch/x86/kernel/head_32.S        |    8 ++++----
 arch/x86/xen/xen-head.S          |    4 ++--
 5 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 1a4088d..e1e5009 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -97,10 +97,6 @@ void foo(void)
 	DEFINE(TSS_sysenter_sp0, offsetof(struct tss_struct, x86_tss.sp0) -
 		 sizeof(struct tss_struct));
 
-	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
-	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
-	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
-
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
 
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 4a6aeed..aab9bdb 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -129,7 +129,6 @@ int main(void)
 	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
 
 	BLANK();
-	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
 #ifdef CONFIG_XEN
 	BLANK();
 	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c8b4efa..49bdedd 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -395,7 +395,7 @@ sysenter_past_esp:
 	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
 	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
 	 */
-	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE_asm+8+4*4)(%esp)
+	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE+8+4*4)(%esp)
 	CFI_REL_OFFSET eip, 0
 
 	pushl_cfi %eax
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 767d6c4..187aa63 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -73,7 +73,7 @@ MAPPING_BEYOND_END = PAGE_TABLE_SIZE(LOWMEM_PAGES) << PAGE_SHIFT
  */
 KERNEL_PAGES = LOWMEM_PAGES
 
-INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE_asm
+INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE
 RESERVE_BRK(pagetables, INIT_MAP_SIZE)
 
 /*
@@ -623,7 +623,7 @@ ENTRY(initial_code)
  * BSS section
  */
 __PAGE_ALIGNED_BSS
-	.align PAGE_SIZE_asm
+	.align PAGE_SIZE
 #ifdef CONFIG_X86_PAE
 initial_pg_pmd:
 	.fill 1024*KPMDS,4,0
@@ -644,7 +644,7 @@ ENTRY(swapper_pg_dir)
 #ifdef CONFIG_X86_PAE
 __PAGE_ALIGNED_DATA
 	/* Page-aligned for the benefit of paravirt? */
-	.align PAGE_SIZE_asm
+	.align PAGE_SIZE
 ENTRY(initial_page_table)
 	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR),0	/* low identity map */
 # if KPMDS == 3
@@ -662,7 +662,7 @@ ENTRY(initial_page_table)
 # else
 #  error "Kernel PMDs should be 1, 2 or 3"
 # endif
-	.align PAGE_SIZE_asm		/* needs to be page-sized too */
+	.align PAGE_SIZE		/* needs to be page-sized too */
 #endif
 
 .data
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 1a5ff24..aaa7291 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -28,9 +28,9 @@ ENTRY(startup_xen)
 	__FINIT
 
 .pushsection .text
-	.align PAGE_SIZE_asm
+	.align PAGE_SIZE
 ENTRY(hypercall_page)
-	.skip PAGE_SIZE_asm
+	.skip PAGE_SIZE
 .popsection
 
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
-- 
1.7.4.1

