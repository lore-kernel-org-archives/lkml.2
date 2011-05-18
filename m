Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1ERUmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:42:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:56244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab1ERUmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:42:22 -0400
Date: Wed, 18 May 2011 20:42:16 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-4307bec9344aed83f8107c3eb4285bd9d218fc10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305671358-14478-7-git-send-email-fenghua.yu@intel.com>
References: <1305671358-14478-7-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, mem: copy_user_64.S: Support copy_to/from_user by enhanced REP MOVSB/STOSB
Git-Commit-ID: 4307bec9344aed83f8107c3eb4285bd9d218fc10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:42:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4307bec9344aed83f8107c3eb4285bd9d218fc10
Gitweb:     http://git.kernel.org/tip/4307bec9344aed83f8107c3eb4285bd9d218fc10
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 15:29:15 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 15:40:28 -0700

x86, mem: copy_user_64.S: Support copy_to/from_user by enhanced REP MOVSB/STOSB

Support copy_to_user/copy_from_user() by enhanced REP MOVSB/STOSB.
On processors supporting enhanced REP MOVSB/STOSB, the alternative
copy_user_enhanced_fast_string function using enhanced rep movsb overrides the
original function and the fast string function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1305671358-14478-7-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
