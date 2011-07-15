Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1GOEW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:22:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:59307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1GOEW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:22:56 -0400
Date: Fri, 15 Jul 2011 04:22:50 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <ff64a6b9a1a3860ca4a7b8b6dc7b4754f9491cd7.1310563276.git.luto@mit.edu>
References: <ff64a6b9a1a3860ca4a7b8b6dc7b4754f9491cd7.1310563276.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86: Make alternative instruction pointers relative
Git-Commit-ID: 59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 04:22:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
Gitweb:     http://git.kernel.org/tip/59e97e4d6fbcd5b74a94cb48bcbfc6f8478a5e93
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 13 Jul 2011 09:24:10 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Jul 2011 11:22:56 -0700

x86: Make alternative instruction pointers relative

This save a few bytes on x86-64 and means that future patches can
apply alternatives to unrelocated code.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/ff64a6b9a1a3860ca4a7b8b6dc7b4754f9491cd7.1310563276.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 71cc380..9929b35 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -331,8 +331,8 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 _ASM_ALIGN "\n"
-			 _ASM_PTR "1b\n"
-			 _ASM_PTR "0\n" 	/* no replacement */
+			 " .long 1b - .\n"
+			 " .long 0\n"		/* no replacement */
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
