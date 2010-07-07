Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0GGRp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:45:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:47156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab0GGRp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:45:57 -0400
Date: Wed, 7 Jul 2010 17:45:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
References: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers for cpufeature index
Message-ID: <tip-83a7a2ad2a9173dcabc05df0f01d1d85b7ba1c2c@git.kernel.org>
Git-Commit-ID: 83a7a2ad2a9173dcabc05df0f01d1d85b7ba1c2c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 07 Jul 2010 17:45:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83a7a2ad2a9173dcabc05df0f01d1d85b7ba1c2c
Gitweb:     http://git.kernel.org/tip/83a7a2ad2a9173dcabc05df0f01d1d85b7ba1c2c
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 10 Jun 2010 00:10:43 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 7 Jul 2010 10:36:28 -0700

x86, alternatives: Use 16-bit numbers for cpufeature index

We already have cpufeature indicies above 255, so use a 16-bit number
for the alternatives index.  This consumes a padding field and so
doesn't add any size, but it means that abusing the padding field to
create assembly errors on overflow no longer works.  We can retain the
test simply by redirecting it to the .discard section, however.

[ v3: updated to include open-coded locations ]

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/alternative.h |    7 ++++---
 arch/x86/include/asm/cpufeature.h  |   14 ++++++++------
 arch/x86/kernel/entry_32.S         |    2 +-
 arch/x86/lib/clear_page_64.S       |    2 +-
 arch/x86/lib/copy_page_64.S        |    2 +-
 arch/x86/lib/memcpy_64.S           |    2 +-
 arch/x86/lib/memset_64.S           |    2 +-
 7 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 03b6bb5..bc6abb7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -45,10 +45,9 @@
 struct alt_instr {
 	u8 *instr;		/* original instruction */
 	u8 *replacement;
-	u8  cpuid;		/* cpuid bit set for replacement */
+	u16 cpuid;		/* cpuid bit set for replacement */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen;	/* length of new instruction, <= instrlen */
-	u8  pad1;
 #ifdef CONFIG_X86_64
 	u32 pad2;
 #endif
@@ -86,9 +85,11 @@ static inline int alternatives_text_reserved(void *start, void *end)
       _ASM_ALIGN "\n"							\
       _ASM_PTR "661b\n"				/* label           */	\
       _ASM_PTR "663f\n"				/* new instruction */	\
-      "	 .byte " __stringify(feature) "\n"	/* feature bit     */	\
+      "	 .word " __stringify(feature) "\n"	/* feature bit     */	\
       "	 .byte 662b-661b\n"			/* sourcelen       */	\
       "	 .byte 664f-663f\n"			/* replacementlen  */	\
+      ".previous\n"							\
+      ".section .discard,\"aw\",@progbits\n"				\
       "	 .byte 0xff + (664f-663f) - (662b-661b)\n" /* rlen <= slen */	\
       ".previous\n"							\
       ".section .altinstr_replacement, \"ax\"\n"			\
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..e8b8896 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -291,7 +291,7 @@ extern const char * const x86_power_flags[32];
  * patch the target code for additional performance.
  *
  */
-static __always_inline __pure bool __static_cpu_has(u8 bit)
+static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
 #if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
 		asm goto("1: jmp %l[t_no]\n"
@@ -300,11 +300,11 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 			 _ASM_ALIGN "\n"
 			 _ASM_PTR "1b\n"
 			 _ASM_PTR "0\n" 	/* no replacement */
-			 " .byte %P0\n"		/* feature bit */
+			 " .word %P0\n"		/* feature bit */
 			 " .byte 2b - 1b\n"	/* source len */
 			 " .byte 0\n"		/* replacement len */
-			 " .byte 0xff + 0 - (2b-1b)\n"	/* padding */
 			 ".previous\n"
+			 /* skipping size check since replacement size = 0 */
 			 : : "i" (bit) : : t_no);
 		return true;
 	t_no:
@@ -318,10 +318,12 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 			     _ASM_ALIGN "\n"
 			     _ASM_PTR "1b\n"
 			     _ASM_PTR "3f\n"
-			     " .byte %P1\n"		/* feature bit */
+			     " .word %P1\n"		/* feature bit */
 			     " .byte 2b - 1b\n"		/* source len */
 			     " .byte 4f - 3f\n"		/* replacement len */
-			     " .byte 0xff + (4f-3f) - (2b-1b)\n" /* padding */
+			     ".previous\n"
+			     ".section .discard,\"aw\",@progbits\n"
+			     " .byte 0xff + (4f-3f) - (2b-1b)\n" /* size check */
 			     ".previous\n"
 			     ".section .altinstr_replacement,\"ax\"\n"
 			     "3: movb $1,%0\n"
@@ -337,7 +339,7 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
 		boot_cpu_has(bit) :				\
-	(__builtin_constant_p(bit) && !((bit) & ~0xff)) ?	\
+	__builtin_constant_p(bit) ?				\
 		__static_cpu_has(bit) :				\
 		boot_cpu_has(bit)				\
 )
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index cd49141..7862cf5 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -914,7 +914,7 @@ ENTRY(simd_coprocessor_error)
 	.balign 4
 	.long 661b
 	.long 663f
-	.byte X86_FEATURE_XMM
+	.word X86_FEATURE_XMM
 	.byte 662b-661b
 	.byte 664f-663f
 .previous
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index ebeafcc..aa4326b 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -52,7 +52,7 @@ ENDPROC(clear_page)
 	.align 8
 	.quad clear_page
 	.quad 1b
-	.byte X86_FEATURE_REP_GOOD
+	.word X86_FEATURE_REP_GOOD
 	.byte .Lclear_page_end - clear_page
 	.byte 2b - 1b
 	.previous
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 727a5d4..6fec2d1 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -113,7 +113,7 @@ ENDPROC(copy_page)
 	.align 8
 	.quad copy_page
 	.quad 1b
-	.byte X86_FEATURE_REP_GOOD
+	.word X86_FEATURE_REP_GOOD
 	.byte .Lcopy_page_end - copy_page
 	.byte 2b - 1b
 	.previous
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index f82e884..bcbcd1e 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -131,7 +131,7 @@ ENDPROC(__memcpy)
 	.align 8
 	.quad memcpy
 	.quad .Lmemcpy_c
-	.byte X86_FEATURE_REP_GOOD
+	.word X86_FEATURE_REP_GOOD
 
 	/*
 	 * Replace only beginning, memcpy is used to apply alternatives,
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index e88d3b8..09d3442 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -121,7 +121,7 @@ ENDPROC(__memset)
 	.align 8
 	.quad memset
 	.quad .Lmemset_c
-	.byte X86_FEATURE_REP_GOOD
+	.word X86_FEATURE_REP_GOOD
 	.byte .Lfinal - memset
 	.byte .Lmemset_e - .Lmemset_c
 	.previous
