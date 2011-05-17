Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab1EQWnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:43:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:7744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793Ab1EQWmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,227,1304319600"; 
   d="scan'208";a="3050272"
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
Subject: [PATCH 6/9] x86/lib/copy_user_64.S: Support copy_to_user/copy_from_user by enhanced REP MOVSB/STOSB
Date: Tue, 17 May 2011 15:29:15 -0700
Message-Id: <1305671358-14478-7-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Support copy_to_user/copy_from_user() by enhanced REP MOVSB/STOSB.
On processors supporting enhanced REP MOVSB/STOSB, the alternative
copy_user_enhanced_fast_string function using enhanced rep movsb overrides the
original function and the fast string function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/lib/copy_user_64.S |   65 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 99e4826..d17a117 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -15,23 +15,30 @@
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
-	.macro ALTERNATIVE_JUMP feature,orig,alt
+/*
+ * By placing feature2 after feature1 in altinstructions section, we logically
+ * implement:
+ * If CPU has feature2, jmp to alt2 is used
+ * else if CPU has feature1, jmp to alt1 is used
+ * else jmp to orig is used.
+ */
+	.macro ALTERNATIVE_JUMP feature1,feature2,orig,alt1,alt2
 0:
 	.byte 0xe9	/* 32bit jump */
 	.long \orig-1f	/* by default jump to orig */
 1:
 	.section .altinstr_replacement,"ax"
 2:	.byte 0xe9			/* near jump with 32bit immediate */
-	.long \alt-1b /* offset */   /* or alternatively to alt */
+	.long \alt1-1b /* offset */   /* or alternatively to alt1 */
+3:	.byte 0xe9			/* near jump with 32bit immediate */
+	.long \alt2-1b /* offset */   /* or alternatively to alt2 */
 	.previous
+
 	.section .altinstructions,"a"
-	.align 8
-	.quad  0b
-	.quad  2b
-	.word  \feature			/* when feature is set */
-	.byte  5
-	.byte  5
+	altinstruction_entry 0b,2b,\feature1,5,5
+	altinstruction_entry 0b,3b,\feature2,5,5
 	.previous
 	.endm
 
@@ -73,7 +80,9 @@ ENTRY(_copy_to_user)
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
 	jae bad_to_user
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
+	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
+		copy_user_generic_unrolled,copy_user_generic_string,	\
+		copy_user_enhanced_fast_string
 	CFI_ENDPROC
 ENDPROC(_copy_to_user)
 
@@ -86,7 +95,9 @@ ENTRY(_copy_from_user)
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
 	jae bad_from_user
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
+	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
+		copy_user_generic_unrolled,copy_user_generic_string,	\
+		copy_user_enhanced_fast_string
 	CFI_ENDPROC
 ENDPROC(_copy_from_user)
 
@@ -255,3 +266,37 @@ ENTRY(copy_user_generic_string)
 	.previous
 	CFI_ENDPROC
 ENDPROC(copy_user_generic_string)
+
+/*
+ * Some CPUs are adding enhanced REP MOVSB/STOSB instructions.
+ * It's recommended to use enhanced REP MOVSB/STOSB if it's enabled.
+ *
+ * Input:
+ * rdi destination
+ * rsi source
+ * rdx count
+ *
+ * Output:
+ * eax uncopied bytes or 0 if successful.
+ */
+ENTRY(copy_user_enhanced_fast_string)
+	CFI_STARTPROC
+	andl %edx,%edx
+	jz 2f
+	movl %edx,%ecx
+1:	rep
+	movsb
+2:	xorl %eax,%eax
+	ret
+
+	.section .fixup,"ax"
+12:	movl %ecx,%edx		/* ecx is zerorest also */
+	jmp copy_user_handle_tail
+	.previous
+
+	.section __ex_table,"a"
+	.align 8
+	.quad 1b,12b
+	.previous
+	CFI_ENDPROC
+ENDPROC(copy_user_enhanced_fast_string)
-- 
1.7.2

