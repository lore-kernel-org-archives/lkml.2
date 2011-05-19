Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab1ESVJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:09:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab1ESVJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:09:41 -0400
Date: Thu, 19 May 2011 23:09:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mem changes for v2.6.40
Message-ID: <20110519210925.GA15291@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mem-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mem-for-linus

 Thanks,

	Ingo

------------------>
Fenghua Yu (10):
      x86, cpufeature: Fix cpuid leaf 7 feature detection
      x86, cpufeature: Add CPU feature bit for enhanced REP MOVSB/STOSB
      x86, mem, intel: Initialize Enhanced REP MOVSB/STOSB
      x86, alternative, doc: Add comment for applying alternatives order
      x86, alternative: Add altinstruction_entry macro
      x86, mem: clear_page_64.S: Support clear_page() with enhanced REP MOVSB/STOSB
      x86, mem: copy_user_64.S: Support copy_to/from_user by enhanced REP MOVSB/STOSB
      x86, mem: memcpy_64.S: Optimize memcpy by enhanced REP MOVSB/STOSB
      x86, mem: memmove_64.S: Optimize memmove by enhanced REP MOVSB/STOSB
      x86, mem: memset_64.S: Optimize memset by enhanced REP MOVSB/STOSB

Jiri Olsa (1):
      x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit


 arch/x86/include/asm/alternative-asm.h |    9 ++++
 arch/x86/include/asm/cpufeature.h      |    1 +
 arch/x86/include/asm/uaccess.h         |    2 +-
 arch/x86/kernel/alternative.c          |    9 ++++
 arch/x86/kernel/cpu/common.c           |    3 +-
 arch/x86/kernel/cpu/intel.c            |   19 +++++++--
 arch/x86/lib/clear_page_64.S           |   33 +++++++++++----
 arch/x86/lib/copy_user_64.S            |   69 ++++++++++++++++++++++++++------
 arch/x86/lib/memcpy_64.S               |   45 +++++++++++++++------
 arch/x86/lib/memmove_64.S              |   29 +++++++++++++-
 arch/x86/lib/memset_64.S               |   54 +++++++++++++++++++------
 11 files changed, 219 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index a63a68b..94d420b 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -15,4 +15,13 @@
 	.endm
 #endif
 
+.macro altinstruction_entry orig alt feature orig_len alt_len
+	.align 8
+	.quad \orig
+	.quad \alt
+	.word \feature
+	.byte \orig_len
+	.byte \alt_len
+.endm
+
 #endif  /*  __ASSEMBLY__  */
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 91f3e087..7f2f7b1 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -195,6 +195,7 @@
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
 #define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
+#define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index abd3e0e..99f0ad7 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -42,7 +42,7 @@
  * Returns 0 if the range is valid, nonzero otherwise.
  *
  * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg (u65 for x86_64)
+ * (u33)addr + (u33)size > (u33)current->addr_limit.seg (u65 for x86_64)
  *
  * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4a23467..f4fe15d 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -210,6 +210,15 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	u8 insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
+	/*
+	 * The scan order should be from start to end. A later scanned
+	 * alternative code can overwrite a previous scanned alternative code.
+	 * Some kernel functions (e.g. memcpy, memset, etc) use this order to
+	 * patch code.
+	 *
+	 * So be careful if you want to change the scan order to any other
+	 * order.
+	 */
 	for (a = start; a < end; a++) {
 		u8 *instr = a->instr;
 		BUG_ON(a->replacementlen > a->instrlen);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2ced007..173f3a3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -565,8 +565,7 @@ void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 
 		cpuid_count(0x00000007, 0, &eax, &ebx, &ecx, &edx);
 
-		if (eax > 0)
-			c->x86_capability[9] = ebx;
+		c->x86_capability[9] = ebx;
 	}
 
 	/* AMD-defined flags: level 0x80000001 */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index df86bc8..fc73a34 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -29,10 +29,10 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		u64 misc_enable;
-
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
@@ -118,8 +118,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * (model 2) with the same problem.
 	 */
 	if (c->x86 == 15) {
-		u64 misc_enable;
-
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
@@ -130,6 +128,19 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/*
+	 * If fast string is not enabled in IA32_MISC_ENABLE for any reason,
+	 * clear the fast string and enhanced fast string CPU capabilities.
+	 */
+	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
+			printk(KERN_INFO "Disabled fast string operations\n");
+			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
+			setup_clear_cpu_cap(X86_FEATURE_ERMS);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index aa4326b..f2145cf 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -1,5 +1,6 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 
 /*
  * Zero a page. 	
@@ -14,6 +15,15 @@ ENTRY(clear_page_c)
 	CFI_ENDPROC
 ENDPROC(clear_page_c)
 
+ENTRY(clear_page_c_e)
+	CFI_STARTPROC
+	movl $4096,%ecx
+	xorl %eax,%eax
+	rep stosb
+	ret
+	CFI_ENDPROC
+ENDPROC(clear_page_c_e)
+
 ENTRY(clear_page)
 	CFI_STARTPROC
 	xorl   %eax,%eax
@@ -38,21 +48,26 @@ ENTRY(clear_page)
 .Lclear_page_end:
 ENDPROC(clear_page)
 
-	/* Some CPUs run faster using the string instructions.
-	   It is also a lot simpler. Use this when possible */
+	/*
+	 * Some CPUs support enhanced REP MOVSB/STOSB instructions.
+	 * It is recommended to use this when possible.
+	 * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
+	 * Otherwise, use original function.
+	 *
+	 */
 
 #include <asm/cpufeature.h>
 
 	.section .altinstr_replacement,"ax"
 1:	.byte 0xeb					/* jmp <disp8> */
 	.byte (clear_page_c - clear_page) - (2f - 1b)	/* offset */
-2:
+2:	.byte 0xeb					/* jmp <disp8> */
+	.byte (clear_page_c_e - clear_page) - (3f - 2b)	/* offset */
+3:
 	.previous
 	.section .altinstructions,"a"
-	.align 8
-	.quad clear_page
-	.quad 1b
-	.word X86_FEATURE_REP_GOOD
-	.byte .Lclear_page_end - clear_page
-	.byte 2b - 1b
+	altinstruction_entry clear_page,1b,X86_FEATURE_REP_GOOD,\
+			     .Lclear_page_end-clear_page, 2b-1b
+	altinstruction_entry clear_page,2b,X86_FEATURE_ERMS,   \
+			     .Lclear_page_end-clear_page,3b-2b
 	.previous
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 99e4826..0248402 100644
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
 
@@ -72,8 +79,10 @@ ENTRY(_copy_to_user)
 	addq %rdx,%rcx
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_to_user
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
+	ja bad_to_user
+	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
+		copy_user_generic_unrolled,copy_user_generic_string,	\
+		copy_user_enhanced_fast_string
 	CFI_ENDPROC
 ENDPROC(_copy_to_user)
 
@@ -85,8 +94,10 @@ ENTRY(_copy_from_user)
 	addq %rdx,%rcx
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_from_user
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
+	ja bad_from_user
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
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..daab21d 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -4,6 +4,7 @@
 
 #include <asm/cpufeature.h>
 #include <asm/dwarf2.h>
+#include <asm/alternative-asm.h>
 
 /*
  * memcpy - Copy a memory block.
@@ -37,6 +38,23 @@
 .Lmemcpy_e:
 	.previous
 
+/*
+ * memcpy_c_e() - enhanced fast string memcpy. This is faster and simpler than
+ * memcpy_c. Use memcpy_c_e when possible.
+ *
+ * This gets patched over the unrolled variant (below) via the
+ * alternative instructions framework:
+ */
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemcpy_c_e:
+	movq %rdi, %rax
+
+	movl %edx, %ecx
+	rep movsb
+	ret
+.Lmemcpy_e_e:
+	.previous
+
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
@@ -171,21 +189,22 @@ ENDPROC(memcpy)
 ENDPROC(__memcpy)
 
 	/*
-	 * Some CPUs run faster using the string copy instructions.
-	 * It is also a lot simpler. Use this when possible:
-	 */
-
-	.section .altinstructions, "a"
-	.align 8
-	.quad memcpy
-	.quad .Lmemcpy_c
-	.word X86_FEATURE_REP_GOOD
-
-	/*
+	 * Some CPUs are adding enhanced REP MOVSB/STOSB feature
+	 * If the feature is supported, memcpy_c_e() is the first choice.
+	 * If enhanced rep movsb copy is not available, use fast string copy
+	 * memcpy_c() when possible. This is faster and code is simpler than
+	 * original memcpy().
+	 * Otherwise, original memcpy() is used.
+	 * In .altinstructions section, ERMS feature is placed after REG_GOOD
+         * feature to implement the right patch order.
+	 *
 	 * Replace only beginning, memcpy is used to apply alternatives,
 	 * so it is silly to overwrite itself with nops - reboot is the
 	 * only outcome...
 	 */
-	.byte .Lmemcpy_e - .Lmemcpy_c
-	.byte .Lmemcpy_e - .Lmemcpy_c
+	.section .altinstructions, "a"
+	altinstruction_entry memcpy,.Lmemcpy_c,X86_FEATURE_REP_GOOD,\
+			     .Lmemcpy_e-.Lmemcpy_c,.Lmemcpy_e-.Lmemcpy_c
+	altinstruction_entry memcpy,.Lmemcpy_c_e,X86_FEATURE_ERMS, \
+			     .Lmemcpy_e_e-.Lmemcpy_c_e,.Lmemcpy_e_e-.Lmemcpy_c_e
 	.previous
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
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 09d3442..79bd454 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -2,9 +2,13 @@
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
 /*
- * ISO C memset - set a memory block to a byte value.
+ * ISO C memset - set a memory block to a byte value. This function uses fast
+ * string to get better performance than the original function. The code is
+ * simpler and shorter than the orignal function as well.
  *	
  * rdi   destination
  * rsi   value (char) 
@@ -31,6 +35,28 @@
 .Lmemset_e:
 	.previous
 
+/*
+ * ISO C memset - set a memory block to a byte value. This function uses
+ * enhanced rep stosb to override the fast string function.
+ * The code is simpler and shorter than the fast string function as well.
+ *
+ * rdi   destination
+ * rsi   value (char)
+ * rdx   count (bytes)
+ *
+ * rax   original destination
+ */
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemset_c_e:
+	movq %rdi,%r9
+	movb %sil,%al
+	movl %edx,%ecx
+	rep stosb
+	movq %r9,%rax
+	ret
+.Lmemset_e_e:
+	.previous
+
 ENTRY(memset)
 ENTRY(__memset)
 	CFI_STARTPROC
@@ -112,16 +138,20 @@ ENTRY(__memset)
 ENDPROC(memset)
 ENDPROC(__memset)
 
-	/* Some CPUs run faster using the string instructions.
-	   It is also a lot simpler. Use this when possible */
-
-#include <asm/cpufeature.h>
-
+	/* Some CPUs support enhanced REP MOVSB/STOSB feature.
+	 * It is recommended to use this when possible.
+	 *
+	 * If enhanced REP MOVSB/STOSB feature is not available, use fast string
+	 * instructions.
+	 *
+	 * Otherwise, use original memset function.
+	 *
+	 * In .altinstructions section, ERMS feature is placed after REG_GOOD
+         * feature to implement the right patch order.
+	 */
 	.section .altinstructions,"a"
-	.align 8
-	.quad memset
-	.quad .Lmemset_c
-	.word X86_FEATURE_REP_GOOD
-	.byte .Lfinal - memset
-	.byte .Lmemset_e - .Lmemset_c
+	altinstruction_entry memset,.Lmemset_c,X86_FEATURE_REP_GOOD,\
+			     .Lfinal-memset,.Lmemset_e-.Lmemset_c
+	altinstruction_entry memset,.Lmemset_c_e,X86_FEATURE_ERMS, \
+			     .Lfinal-memset,.Lmemset_e_e-.Lmemset_c_e
 	.previous
