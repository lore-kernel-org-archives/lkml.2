Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1BZGei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 01:34:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:47602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab1BZGeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 01:34:36 -0500
Date: Sat, 26 Feb 2011 06:34:08 GMT
From: tip-bot for Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Cc: linux-kernel@vger.kernel.org, psomas@cslab.ece.ntua.gr, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, psomas@cslab.ece.ntua.gr,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1298666774-17646-2-git-send-email-psomas@cslab.ece.ntua.gr>
References: <1298666774-17646-2-git-send-email-psomas@cslab.ece.ntua.gr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm: Cleanup unnecssary macros in asm-offsets.c
Message-ID: <tip-7bf04be8f48ceeeffa5b5a79734d6d6e0d59e5f8@git.kernel.org>
Git-Commit-ID: 7bf04be8f48ceeeffa5b5a79734d6d6e0d59e5f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Feb 2011 06:34:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bf04be8f48ceeeffa5b5a79734d6d6e0d59e5f8
Gitweb:     http://git.kernel.org/tip/7bf04be8f48ceeeffa5b5a79734d6d6e0d59e5f8
Author:     Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
AuthorDate: Fri, 25 Feb 2011 22:46:13 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 25 Feb 2011 16:37:32 -0800

x86, asm: Cleanup unnecssary macros in asm-offsets.c

PAGE_SIZE_asm, PAGE_SHIFT_asm, THREAD_SIZE_asm can be safely removed from 
asm-offsets.c, and be replaced by their non-'_asm' counterparts in the code 
that uses them, since the _AC macro defined in include/linux/const.h makes
PAGE_SIZE/PAGE_SHIFT/THREAD_SIZE work with as.

Signed-off-by: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
LKML-Reference: <1298666774-17646-2-git-send-email-psomas@cslab.ece.ntua.gr>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/asm-offsets.c |    5 -----
 arch/x86/kernel/entry_32.S    |    2 +-
 arch/x86/kernel/head_32.S     |    8 ++++----
 arch/x86/xen/xen-head.S       |    4 ++--
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 2b141c1..4f13faf 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -29,11 +29,6 @@
 
 void common(void) {
 	BLANK();
-	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
-	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
-	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
-
-	BLANK();
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_status, thread_info, status);
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
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
