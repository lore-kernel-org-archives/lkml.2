Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab1EPVr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:47:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:46815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416Ab1EPVrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:47:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,221,1304319600"; 
   d="scan'208";a="643471705"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Avi Kivity" <avi@redhat.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
Date: Mon, 16 May 2011 14:34:44 -0700
Message-Id: <1305581685-5144-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Enable newly documented SMEP (Supervisor Mode Execution Protection) CPU
feature in kernel.

SMEP prevents the CPU in kernel-mode to jump to an executable page that does
not have the kernel/system flag set in the pte. This prevents the kernel
from executing user-space code accidentally or maliciously, so it for example
prevents kernel exploits from jumping to specially prepared user-mode shell
code. The violation will cause page fault #PF and will have error code
identical to XD violation.

CR4.SMEP (bit 20) is 0 at power-on. If the feature is supported by CPU
(X86_FEATURE_SMEP), enable SMEP by setting CR4.SMEP. New kernel
option nosmep disables the feature even if the feature is supported by CPU.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/head_32.S |   17 +++++++++++++----
 arch/x86/kernel/head_64.S |   13 +++++++++++--
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ce0be7c..5325c02 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -308,11 +308,20 @@ default_entry:
 	movl cr4_bits,%edx
 	andl %edx,%edx
 	jz 6f
-	movl %cr4,%eax		# Turn on paging options (PSE,PAE,..)
-	orl %edx,%eax
-	movl %eax,%cr4
+	movl %cr4,%edi		# Turn on paging options (PSE,PAE,..)
+	orl %edx,%edi
 
-	testb $X86_CR4_PAE, %al		# check if PAE is enabled
+	/* Check if SMEP is supported by the processor */
+	movl $0x7, %eax
+	movl $0, %ecx
+	cpuid
+	btl  $7, %ebx
+	jnc  1f
+	/* Enable SMEP */
+	orl  $(X86_CR4_SMEP), %edi
+1:	movl %edi, %cr4
+
+	test $X86_CR4_PAE, %di		# check if PAE is enabled
 	jz 6f
 
 	/* Check if extended functions are implemented */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index e11e394..220ec5f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -161,8 +161,17 @@ ENTRY(secondary_startup_64)
 	 */
 
 	/* Enable PAE mode and PGE */
-	movl	$(X86_CR4_PAE | X86_CR4_PGE), %eax
-	movq	%rax, %cr4
+	movl	$(X86_CR4_PAE | X86_CR4_PGE), %edi
+
+	/* Check if SMEP is supported by the processor */
+	movl	$0x7, %eax
+	movl	$0, %ecx
+	cpuid
+	btl	$7, %ebx
+	jnc	1f
+	/* Enable PAE mode, PGE, and SMEP */
+	movl	$(X86_CR4_PAE | X86_CR4_PGE | X86_CR4_SMEP), %edi
+1:	movq	%rdi, %cr4
 
 	/* Setup early boot stage 4 level pagetables. */
 	movq	$(init_level4_pgt - __START_KERNEL_map), %rax
-- 
1.7.2

