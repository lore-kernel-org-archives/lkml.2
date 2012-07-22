Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2GVNkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 09:40:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48381 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2GVNkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 09:40:07 -0400
Date: Sun, 22 Jul 2012 15:40:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.6
Message-ID: <20120722134002.GA6999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   HEAD: a7101d152665817bf7cafc47e7f5dcb1f54664fe x86/mm/mtrr: Slightly simplify print_mtrr_state()

Assorted single-commit improvements, as usual.

 Thanks,

	Ingo

------------------>
Fenghua Yu (1):
      x86/copy_user_generic: Optimize copy_user_generic with CPU erms feature

Jan Beulich (2):
      x86/mm/mtrr: Fix alignment determination in range_to_mtrr()
      x86/mm/mtrr: Slightly simplify print_mtrr_state()

OGAWA Hirofumi (1):
      x86/alternatives: Use atomic_xchg() instead atomic_dec_and_test() for stop_machine_text_poke()


 arch/x86/include/asm/alternative.h |   74 ++++++++++++++++++++++++++++--------
 arch/x86/include/asm/uaccess_64.h  |   11 +++++-
 arch/x86/kernel/alternative.c      |    2 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c |    6 +--
 arch/x86/kernel/cpu/mtrr/generic.c |    6 +--
 arch/x86/kernel/x8664_ksyms_64.c   |    1 +
 6 files changed, 75 insertions(+), 25 deletions(-)

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
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1f84794..53231a0 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -664,7 +664,7 @@ static int __kprobes stop_machine_text_poke(void *data)
 	struct text_poke_param *p;
 	int i;
 
-	if (atomic_dec_and_test(&stop_machine_first)) {
+	if (atomic_xchg(&stop_machine_first, 0)) {
 		for (i = 0; i < tpp->nparams; i++) {
 			p = &tpp->params[i];
 			text_poke(p->addr, p->opcode, p->len);
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index bdda2e6..35ffda5 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -258,11 +258,11 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 
 		/* Compute the maximum size with which we can make a range: */
 		if (range_startk)
-			max_align = ffs(range_startk) - 1;
+			max_align = __ffs(range_startk);
 		else
-			max_align = 32;
+			max_align = BITS_PER_LONG - 1;
 
-		align = fls(range_sizek) - 1;
+		align = __fls(range_sizek);
 		if (align > max_align)
 			align = max_align;
 
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 75772ae..e9fe907 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -361,11 +361,7 @@ static void __init print_mtrr_state(void)
 	}
 	pr_debug("MTRR variable ranges %sabled:\n",
 		 mtrr_state.enabled & 2 ? "en" : "dis");
-	if (size_or_mask & 0xffffffffUL)
-		high_width = ffs(size_or_mask & 0xffffffffUL) - 1;
-	else
-		high_width = ffs(size_or_mask>>32) + 32 - 1;
-	high_width = (high_width - (32 - PAGE_SHIFT) + 3) / 4;
+	high_width = (__ffs64(size_or_mask) - (32 - PAGE_SHIFT) + 3) / 4;
 
 	for (i = 0; i < num_var_ranges; ++i) {
 		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
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
