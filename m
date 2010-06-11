Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710Ab0FKSY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 14:24:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35707 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab0FKSY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 14:24:58 -0400
Date: Fri, 11 Jun 2010 18:24:39 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
References: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers for cpufeature index
Message-ID: <tip-884c4f15783495e42a628b7f31d2dff60ec9cd17@git.kernel.org>
Git-Commit-ID: 884c4f15783495e42a628b7f31d2dff60ec9cd17
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Jun 2010 18:24:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  884c4f15783495e42a628b7f31d2dff60ec9cd17
Gitweb:     http://git.kernel.org/tip/884c4f15783495e42a628b7f31d2dff60ec9cd17
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 9 Jun 2010 16:03:09 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 11 Jun 2010 11:22:39 -0700

x86, alternatives: Use 16-bit numbers for cpufeature index

We already have cpufeature indicies above 255, so use a 16-bit number
for the alternatives index.  This consumes a padding field and so
doesn't add any size, but it means that abusing the padding field to
create assembly errors on overflow no longer works.  We can retain the
test simply by redirecting it to the .discard section, however.

[ v2: fix open-coded alternatives sites ]

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
---
 arch/x86/include/asm/alternative.h |    7 ++++---
 arch/x86/include/asm/cpufeature.h  |   10 ++++++----
 arch/x86/kernel/entry_32.S         |    2 +-
 arch/x86/lib/clear_page_64.S       |    2 +-
 arch/x86/lib/copy_page_64.S        |    2 +-
 arch/x86/lib/copy_user_64.S        |    2 +-
 arch/x86/lib/memcpy_64.S           |    2 +-
 arch/x86/lib/memset_64.S           |    2 +-
 8 files changed, 16 insertions(+), 13 deletions(-)

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
index 4681459..66878c5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
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
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 71100c9..a460158 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -29,7 +29,7 @@
 	.align 8
 	.quad  0b
 	.quad  2b
-	.byte  \feature			/* when feature is set */
+	.word  \feature			/* when feature is set */
 	.byte  5
 	.byte  5
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
