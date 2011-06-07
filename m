Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab1FGTdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:33:02 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:57616 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886Ab1FGTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:32:59 -0400
X-AuditID: 12074423-b7ce8ae000000a29-9f-4dee7ce6925f
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/5] x86: Make alternative instruction pointers relative
Date: Tue,  7 Jun 2011 15:32:38 -0400
Message-Id: <3935375a7f91bcec6942322658c1e766a6907ded.1307474707.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
In-Reply-To: <cover.1307474707.git.luto@mit.edu>
References: <cover.1307474707.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsUixCmqrPus5p2vwaleFYu+K0fZLS7vmsNm
	seVSM6vFjw2PWR1YPG61/WH22DnrLrvHplWdbB6fN8kFsERx2aSk5mSWpRbp2yVwZfxe/o21
	4Itxxax/61kbGP9odDFyckgImEisf9/JDmGLSVy4t56ti5GLQ0hgH6PEsjlfWSGc9YwSb+e0
	soBUCQkcYpKYd0UCxGYTUJHoWPqAqYuRg0NEQEhi6d06kDCzQJrE3Ou/wMqFBTwknqxfzwhi
	swioSkz6vhsszisQJLF8XiMbSKuEgILE+VX5ICangIHEv9u1IKaQgL7Ehi+C2EUnMAosYGRY
	xSibklulm5uYmVOcmqxbnJyYl5dapGuml5tZopeaUrqJERR67C7KOxj/HFQ6xCjAwajEw5sQ
	8s5XiDWxrLgy9xCjJAeTkiivYTVQiC8pP6UyI7E4I76oNCe1+BCjBAezkgjvjOtvfYV4UxIr
	q1KL8mFS0hwsSuK8cyXVfYUE0hNLUrNTUwtSi2CyMhwcShK8GsAYExIsSk1PrUjLzClBSDNx
	cIIM5wEa/hpkMW9xQWJucWY6RP4Uoy7H1hNvDzIKseTl56VKifPygQwSACnKKM2DmwNLGa8Y
	xYHeEoZYxwNMN3CTXgEtYQJacvosyAfFJYkIKakGxojpS+6bBjxRLP6o+rHao/Yhr0HLpPTk
	1I6OA3rXsj36MncWH9L9pRjTP91r59H1twVK3dWOT3lR0XreTt1Wenmz5f1Gv5w/RrrrH/34
	uOtn1UqTf95Cy44nqz5T/1Hyb6mH/LdJfhM9cj7X820K00xxOf3IenvD+wX7jrXb7T8ZkGy+
	9gn3IyWW4oxEQy3mouJEAO4mRyL0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This save a few bytes on x86-64 and means that future patches can
apply alternatives to unrelocated code.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/alternative-asm.h |    4 ++--
 arch/x86/include/asm/alternative.h     |    8 ++++----
 arch/x86/include/asm/cpufeature.h      |    8 ++++----
 arch/x86/kernel/alternative.c          |   21 +++++++++++++--------
 arch/x86/lib/copy_page_64.S            |    9 +++------
 arch/x86/lib/memmove_64.S              |   11 +++++------
 6 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 94d420b..4554cc6 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -17,8 +17,8 @@
 
 .macro altinstruction_entry orig alt feature orig_len alt_len
 	.align 8
-	.quad \orig
-	.quad \alt
+	.long \orig - .
+	.long \alt - .
 	.word \feature
 	.byte \orig_len
 	.byte \alt_len
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index bf535f9..23fb6d7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -43,8 +43,8 @@
 #endif
 
 struct alt_instr {
-	u8 *instr;		/* original instruction */
-	u8 *replacement;
+	s32 instr_offset;	/* original instruction */
+	s32 repl_offset;	/* offset to replacement instruction */
 	u16 cpuid;		/* cpuid bit set for replacement */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen;	/* length of new instruction, <= instrlen */
@@ -84,8 +84,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
       "661:\n\t" oldinstr "\n662:\n"					\
       ".section .altinstructions,\"a\"\n"				\
       _ASM_ALIGN "\n"							\
-      _ASM_PTR "661b\n"				/* label           */	\
-      _ASM_PTR "663f\n"				/* new instruction */	\
+      "	 .long 661b - .\n"			/* label           */	\
+      "	 .long 663f - .\n"			/* new instruction */	\
       "	 .word " __stringify(feature) "\n"	/* feature bit     */	\
       "	 .byte 662b-661b\n"			/* sourcelen       */	\
       "	 .byte 664f-663f\n"			/* replacementlen  */	\
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 71cc380..8a1920e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -331,8 +331,8 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 _ASM_ALIGN "\n"
-			 _ASM_PTR "1b\n"
-			 _ASM_PTR "0\n" 	/* no replacement */
+			 " .long 1b - .\n"
+			 " .long 0\n"	 	/* no replacement */
 			 " .word %P0\n"		/* feature bit */
 			 " .byte 2b - 1b\n"	/* source len */
 			 " .byte 0\n"		/* replacement len */
@@ -349,8 +349,8 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 			     "2:\n"
 			     ".section .altinstructions,\"a\"\n"
 			     _ASM_ALIGN "\n"
-			     _ASM_PTR "1b\n"
-			     _ASM_PTR "3f\n"
+			     " .long 1b - .\n"
+			     " .long 3f - .\n"
 			     " .word %P1\n"		/* feature bit */
 			     " .byte 2b - 1b\n"		/* source len */
 			     " .byte 4f - 3f\n"		/* replacement len */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a81f2d5..ddb207b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -263,6 +263,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 					 struct alt_instr *end)
 {
 	struct alt_instr *a;
+	u8 *instr, *replacement;
 	u8 insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
@@ -276,25 +277,29 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	 * order.
 	 */
 	for (a = start; a < end; a++) {
-		u8 *instr = a->instr;
+		instr = (u8 *)&a->instr_offset + a->instr_offset;
+		replacement = (u8 *)&a->repl_offset + a->repl_offset;
 		BUG_ON(a->replacementlen > a->instrlen);
 		BUG_ON(a->instrlen > sizeof(insnbuf));
 		BUG_ON(a->cpuid >= NCAPINTS*32);
 		if (!boot_cpu_has(a->cpuid))
 			continue;
+
+		memcpy(insnbuf, replacement, a->replacementlen);
+
+		/* 0xe8 is a relative jump; fix the offset. */
+		if (*insnbuf == 0xe8 && a->replacementlen == 5)
+		    *(s32 *)(insnbuf + 1) += replacement - instr;
+
+		add_nops(insnbuf + a->replacementlen,
+			 a->instrlen - a->replacementlen);
+
 #ifdef CONFIG_X86_64
 		/* vsyscall code is not mapped yet. resolve it manually. */
 		if (instr >= (u8 *)VSYSCALL_START && instr < (u8*)VSYSCALL_END) {
 			instr = __va(instr - (u8*)VSYSCALL_START + (u8*)__pa_symbol(&__vsyscall_0));
-			DPRINTK("%s: vsyscall fixup: %p => %p\n",
-				__func__, a->instr, instr);
 		}
 #endif
-		memcpy(insnbuf, a->replacement, a->replacementlen);
-		if (*insnbuf == 0xe8 && a->replacementlen == 5)
-		    *(s32 *)(insnbuf + 1) += a->replacement - a->instr;
-		add_nops(insnbuf + a->replacementlen,
-			 a->instrlen - a->replacementlen);
 		text_poke_early(instr, insnbuf, a->instrlen);
 	}
 }
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 6fec2d1..01c805b 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -2,6 +2,7 @@
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 
 	ALIGN
 copy_page_c:
@@ -110,10 +111,6 @@ ENDPROC(copy_page)
 2:
 	.previous
 	.section .altinstructions,"a"
-	.align 8
-	.quad copy_page
-	.quad 1b
-	.word X86_FEATURE_REP_GOOD
-	.byte .Lcopy_page_end - copy_page
-	.byte 2b - 1b
+	altinstruction_entry copy_page, 1b, X86_FEATURE_REP_GOOD,	\
+		.Lcopy_page_end-copy_page, 2b-1b
 	.previous
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index d0ec9c2..ee16461 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
 #undef memmove
 
@@ -214,11 +215,9 @@ ENTRY(memmove)
 	.previous
 
 	.section .altinstructions,"a"
-	.align 8
-	.quad .Lmemmove_begin_forward
-	.quad .Lmemmove_begin_forward_efs
-	.word X86_FEATURE_ERMS
-	.byte .Lmemmove_end_forward-.Lmemmove_begin_forward
-	.byte .Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
+	altinstruction_entry .Lmemmove_begin_forward,		\
+		.Lmemmove_begin_forward_efs,X86_FEATURE_ERMS,	\
+		.Lmemmove_end_forward-.Lmemmove_begin_forward,	\
+		.Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
 	.previous
 ENDPROC(memmove)
-- 
1.7.5.2

