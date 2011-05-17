Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1EQWnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:43:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:2478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab1EQWmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="3050278"
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
Subject: [PATCH 8/9] x86/lib/memmove_64.S: Optimize memmove by enhanced REP MOVSB/STOSB
Date: Tue, 17 May 2011 15:29:17 -0700
Message-Id: <1305671358-14478-9-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Support memmove() by enhanced rep movsb. On processors supporting enhanced
REP MOVSB/STOSB, the alternative memmove() function using enhanced rep movsb
overrides the original function.

The patch doesn't change backward memmove case with enhanced rep movsb.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/lib/memmove_64.S |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 0ecb843..d0ec9c2 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -8,6 +8,7 @@
 #define _STRING_C
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/cpufeature.h>
 
 #undef memmove
 
@@ -24,6 +25,7 @@
  */
 ENTRY(memmove)
 	CFI_STARTPROC
+
 	/* Handle more 32bytes in loop */
 	mov %rdi, %rax
 	cmp $0x20, %rdx
@@ -31,8 +33,13 @@ ENTRY(memmove)
 
 	/* Decide forward/backward copy mode */
 	cmp %rdi, %rsi
-	jb	2f
+	jge .Lmemmove_begin_forward
+	mov %rsi, %r8
+	add %rdx, %r8
+	cmp %rdi, %r8
+	jg 2f
 
+.Lmemmove_begin_forward:
 	/*
 	 * movsq instruction have many startup latency
 	 * so we handle small size by general register.
@@ -78,6 +85,8 @@ ENTRY(memmove)
 	rep movsq
 	movq %r11, (%r10)
 	jmp 13f
+.Lmemmove_end_forward:
+
 	/*
 	 * Handle data backward by movsq.
 	 */
@@ -194,4 +203,22 @@ ENTRY(memmove)
 13:
 	retq
 	CFI_ENDPROC
+
+	.section .altinstr_replacement,"ax"
+.Lmemmove_begin_forward_efs:
+	/* Forward moving data. */
+	movq %rdx, %rcx
+	rep movsb
+	retq
+.Lmemmove_end_forward_efs:
+	.previous
+
+	.section .altinstructions,"a"
+	.align 8
+	.quad .Lmemmove_begin_forward
+	.quad .Lmemmove_begin_forward_efs
+	.word X86_FEATURE_ERMS
+	.byte .Lmemmove_end_forward-.Lmemmove_begin_forward
+	.byte .Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
+	.previous
 ENDPROC(memmove)
-- 
1.7.2

