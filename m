Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0FJALH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:11:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:47860 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0FJALE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:11:04 -0400
Date: Thu, 10 Jun 2010 00:10:43 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers for cpufeature index
Message-ID: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
Git-Commit-ID: f88731e3068f9d1392ba71cc9f50f035d26a0d4f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 00:10:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f88731e3068f9d1392ba71cc9f50f035d26a0d4f
Gitweb:     http://git.kernel.org/tip/f88731e3068f9d1392ba71cc9f50f035d26a0d4f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 9 Jun 2010 16:03:09 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 9 Jun 2010 16:03:09 -0700

x86, alternatives: Use 16-bit numbers for cpufeature index

We already have cpufeature indicies above 255, so use a 16-bit number
for the alternatives index.  This consumes a padding field and so
doesn't add any size, but it means that abusing the padding field to
create assembly errors on overflow no longer works.  We can retain the
test simply by redirecting it to the .discard section, however.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/include/asm/alternative.h |    7 ++++---
 arch/x86/include/asm/cpufeature.h  |   10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

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
