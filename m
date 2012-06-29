Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2F2XoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 19:44:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2F2XoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 19:44:07 -0400
Date: Fri, 29 Jun 2012 16:43:54 -0700
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-954e482bde20b0e208fd4d34ef26e10afd194600@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1337908785-14015-1-git-send-email-fenghua.yu@intel.com>
References: <1337908785-14015-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/copy_user_generic:
  Optimize copy_user_generic with CPU erms feature
Git-Commit-ID: 954e482bde20b0e208fd4d34ef26e10afd194600
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 29 Jun 2012 16:44:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  954e482bde20b0e208fd4d34ef26e10afd194600
Gitweb:     http://git.kernel.org/tip/954e482bde20b0e208fd4d34ef26e10afd194600
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 24 May 2012 18:19:45 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 29 Jun 2012 15:33:34 -0700

x86/copy_user_generic: Optimize copy_user_generic with CPU erms feature

According to Intel 64 and IA-32 SDM and Optimization Reference Manual, beginning
with Ivybridge, REG string operation using MOVSB and STOSB can provide both
flexible and high-performance REG string operations in cases like memory copy.
Enhancement availability is indicated by CPUID.7.0.EBX[9] (Enhanced REP MOVSB/
STOSB).

If CPU erms feature is detected, patch copy_user_generic with enhanced fast
string version of copy_user_generic.

A few new macros are defined to reduce duplicate code in ALTERNATIVE and
ALTERNATIVE_2.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1337908785-14015-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/alternative.h |   74 ++++++++++++++++++++++++++++-------
 arch/x86/include/asm/uaccess_64.h  |   11 +++++-
 arch/x86/kernel/x8664_ksyms_64.c   |    1 +
 3 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 49331be..7078068 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -75,23 +75,54 @@ static inline int alternatives_text_reserved(void *start, void *end)
 }
 #endif	/* CONFIG_SMP */
 
+#define OLDINSTR(oldinstr)	"661:\n\t" oldinstr "\n662:\n"
+
+#define b_replacement(number)	"663"#number
+#define e_replacement(number)	"664"#number
+
+#define alt_slen "662b-661b"
+#define alt_rlen(number) e_replacement(number)"f-"b_replacement(number)"f"
+
+#define ALTINSTR_ENTRY(feature, number)					      \
+	" .long 661b - .\n"				/* label           */ \
+	" .long " b_replacement(number)"f - .\n"	/* new instruction */ \
+	" .word " __stringify(feature) "\n"		/* feature bit     */ \
+	" .byte " alt_slen "\n"				/* source len      */ \
+	" .byte " alt_rlen(number) "\n"			/* replacement len */
+
+#define DISCARD_ENTRY(number)				/* rlen <= slen */    \
+	" .byte 0xff + (" alt_rlen(number) ") - (" alt_slen ")\n"
+
+#define ALTINSTR_REPLACEMENT(newinstr, feature, number)	/* replacement */     \
+	b_replacement(number)":\n\t" newinstr "\n" e_replacement(number) ":\n\t"
+
 /* alternative assembly primitive: */
 #define ALTERNATIVE(oldinstr, newinstr, feature)			\
-									\
-      "661:\n\t" oldinstr "\n662:\n"					\
-      ".section .altinstructions,\"a\"\n"				\
-      "	 .long 661b - .\n"			/* label           */	\
-      "	 .long 663f - .\n"			/* new instruction */	\
-      "	 .word " __stringify(feature) "\n"	/* feature bit     */	\
-      "	 .byte 662b-661b\n"			/* sourcelen       */	\
-      "	 .byte 664f-663f\n"			/* replacementlen  */	\
-      ".previous\n"							\
-      ".section .discard,\"aw\",@progbits\n"				\
-      "	 .byte 0xff + (664f-663f) - (662b-661b)\n" /* rlen <= slen */	\
-      ".previous\n"							\
-      ".section .altinstr_replacement, \"ax\"\n"			\
-      "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\
-      ".previous"
+	OLDINSTR(oldinstr)						\
+	".section .altinstructions,\"a\"\n"				\
+	ALTINSTR_ENTRY(feature, 1)					\
+	".previous\n"							\
+	".section .discard,\"aw\",@progbits\n"				\
+	DISCARD_ENTRY(1)						\
+	".previous\n"							\
+	".section .altinstr_replacement, \"ax\"\n"			\
+	ALTINSTR_REPLACEMENT(newinstr, feature, 1)			\
+	".previous"
+
+#define ALTERNATIVE_2(oldinstr, newinstr1, feature1, newinstr2, feature2)\
+	OLDINSTR(oldinstr)						\
+	".section .altinstructions,\"a\"\n"				\
+	ALTINSTR_ENTRY(feature1, 1)					\
+	ALTINSTR_ENTRY(feature2, 2)					\
+	".previous\n"							\
+	".section .discard,\"aw\",@progbits\n"				\
+	DISCARD_ENTRY(1)						\
+	DISCARD_ENTRY(2)						\
+	".previous\n"							\
+	".section .altinstr_replacement, \"ax\"\n"			\
+	ALTINSTR_REPLACEMENT(newinstr1, feature1, 1)			\
+	ALTINSTR_REPLACEMENT(newinstr2, feature2, 2)			\
+	".previous"
 
 /*
  * This must be included *after* the definition of ALTERNATIVE due to
@@ -140,6 +171,19 @@ static inline int alternatives_text_reserved(void *start, void *end)
 		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
 
 /*
+ * Like alternative_call, but there are two features and respective functions.
+ * If CPU has feature2, function2 is used.
+ * Otherwise, if CPU has feature1, function1 is used.
+ * Otherwise, old function is used.
+ */
+#define alternative_call_2(oldfunc, newfunc1, feature1, newfunc2, feature2,   \
+			   output, input...)				      \
+	asm volatile (ALTERNATIVE_2("call %P[old]", "call %P[new1]", feature1,\
+		"call %P[new2]", feature2)				      \
+		: output : [old] "i" (oldfunc), [new1] "i" (newfunc1),	      \
+		[new2] "i" (newfunc2), ## input)
+
+/*
  * use this macro(s) if you need more than one output parameter
  * in alternative_io
  */
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 8e796fb..d8def8b 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -17,6 +17,8 @@
 
 /* Handles exceptions in both to and from, but doesn't do access_ok */
 __must_check unsigned long
+copy_user_enhanced_fast_string(void *to, const void *from, unsigned len);
+__must_check unsigned long
 copy_user_generic_string(void *to, const void *from, unsigned len);
 __must_check unsigned long
 copy_user_generic_unrolled(void *to, const void *from, unsigned len);
@@ -26,9 +28,16 @@ copy_user_generic(void *to, const void *from, unsigned len)
 {
 	unsigned ret;
 
-	alternative_call(copy_user_generic_unrolled,
+	/*
+	 * If CPU has ERMS feature, use copy_user_enhanced_fast_string.
+	 * Otherwise, if CPU has rep_good feature, use copy_user_generic_string.
+	 * Otherwise, use copy_user_generic_unrolled.
+	 */
+	alternative_call_2(copy_user_generic_unrolled,
 			 copy_user_generic_string,
 			 X86_FEATURE_REP_GOOD,
+			 copy_user_enhanced_fast_string,
+			 X86_FEATURE_ERMS,
 			 ASM_OUTPUT2("=a" (ret), "=D" (to), "=S" (from),
 				     "=d" (len)),
 			 "1" (to), "2" (from), "3" (len)
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 9796c2f..6020f6f 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -28,6 +28,7 @@ EXPORT_SYMBOL(__put_user_8);
 
 EXPORT_SYMBOL(copy_user_generic_string);
 EXPORT_SYMBOL(copy_user_generic_unrolled);
+EXPORT_SYMBOL(copy_user_enhanced_fast_string);
 EXPORT_SYMBOL(__copy_user_nocache);
 EXPORT_SYMBOL(_copy_from_user);
 EXPORT_SYMBOL(_copy_to_user);
