Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1AFJsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:48:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40918 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab1AFJs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:48:29 -0500
Date: Thu, 6 Jan 2011 10:48:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v2.6.38
Message-ID: <20110106094821.GA18092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus

 Thanks,

	Ingo

------------------>
Kees Cook (5):
      x86, cpu: Rename verify_cpu_64.S to verify_cpu.S
      x86, cpu: Clear XD_DISABLED flag on Intel to regain NX
      x86, cpu: Call verify_cpu during 32bit CPU startup
      x86, cpu: Only CPU features determine NX capabilities
      x86: Fix included-by file reference comments


 arch/x86/boot/compressed/head_64.S                |    2 +-
 arch/x86/kernel/head_32.S                         |    6 +++
 arch/x86/kernel/trampoline_64.S                   |    2 +-
 arch/x86/kernel/{verify_cpu_64.S => verify_cpu.S} |   49 +++++++++++++++++---
 arch/x86/mm/setup_nx.c                            |    2 +-
 5 files changed, 50 insertions(+), 11 deletions(-)
 rename arch/x86/kernel/{verify_cpu_64.S => verify_cpu.S} (65%)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 52f85a1..35af09d 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -182,7 +182,7 @@ no_longmode:
 	hlt
 	jmp     1b
 
-#include "../../kernel/verify_cpu_64.S"
+#include "../../kernel/verify_cpu.S"
 
 	/*
 	 * Be careful here startup_64 needs to be at a predictable
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index bcece91..fdaea52 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -314,6 +314,10 @@ ENTRY(startup_32_smp)
 	subl $0x80000001, %eax
 	cmpl $(0x8000ffff-0x80000001), %eax
 	ja 6f
+
+	/* Clear bogus XD_DISABLE bits */
+	call verify_cpu
+
 	mov $0x80000001, %eax
 	cpuid
 	/* Execute Disable bit supported? */
@@ -609,6 +613,8 @@ ignore_int:
 #endif
 	iret
 
+#include "verify_cpu.S"
+
 	__REFDATA
 .align 4
 ENTRY(initial_code)
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index 3af2dff..075d130 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -127,7 +127,7 @@ startup_64:
 no_longmode:
 	hlt
 	jmp no_longmode
-#include "verify_cpu_64.S"
+#include "verify_cpu.S"
 
 	# Careful these need to be in the same 64K segment as the above;
 tidt:
diff --git a/arch/x86/kernel/verify_cpu_64.S b/arch/x86/kernel/verify_cpu.S
similarity index 65%
rename from arch/x86/kernel/verify_cpu_64.S
rename to arch/x86/kernel/verify_cpu.S
index 56a8c2a..0edefc1 100644
--- a/arch/x86/kernel/verify_cpu_64.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -7,6 +7,7 @@
  *	Copyright (c) 2007  Andi Kleen (ak@suse.de)
  *	Copyright (c) 2007  Eric Biederman (ebiederm@xmission.com)
  *	Copyright (c) 2007  Vivek Goyal (vgoyal@in.ibm.com)
+ *	Copyright (c) 2010  Kees Cook (kees.cook@canonical.com)
  *
  * 	This source code is licensed under the GNU General Public License,
  * 	Version 2.  See the file COPYING for more details.
@@ -14,18 +15,17 @@
  *	This is a common code for verification whether CPU supports
  * 	long mode and SSE or not. It is not called directly instead this
  *	file is included at various places and compiled in that context.
- * 	Following are the current usage.
+ *	This file is expected to run in 32bit code.  Currently:
  *
- * 	This file is included by both 16bit and 32bit code.
+ *	arch/x86/boot/compressed/head_64.S: Boot cpu verification
+ *	arch/x86/kernel/trampoline_64.S: secondary processor verfication
+ *	arch/x86/kernel/head_32.S: processor startup
  *
- *	arch/x86_64/boot/setup.S : Boot cpu verification (16bit)
- *	arch/x86_64/boot/compressed/head.S: Boot cpu verification (32bit)
- *	arch/x86_64/kernel/trampoline.S: secondary processor verfication (16bit)
- *	arch/x86_64/kernel/acpi/wakeup.S:Verfication at resume (16bit)
- *
- *	verify_cpu, returns the status of cpu check in register %eax.
+ *	verify_cpu, returns the status of longmode and SSE in register %eax.
  *		0: Success    1: Failure
  *
+ *	On Intel, the XD_DISABLE flag will be cleared as a side-effect.
+ *
  * 	The caller needs to check for the error code and take the action
  * 	appropriately. Either display a message or halt.
  */
@@ -62,8 +62,41 @@ verify_cpu:
 	cmpl	$0x444d4163,%ecx
 	jnz	verify_cpu_noamd
 	mov	$1,%di			# cpu is from AMD
+	jmp	verify_cpu_check
 
 verify_cpu_noamd:
+	cmpl	$0x756e6547,%ebx        # GenuineIntel?
+	jnz	verify_cpu_check
+	cmpl	$0x49656e69,%edx
+	jnz	verify_cpu_check
+	cmpl	$0x6c65746e,%ecx
+	jnz	verify_cpu_check
+
+	# only call IA32_MISC_ENABLE when:
+	# family > 6 || (family == 6 && model >= 0xd)
+	movl	$0x1, %eax		# check CPU family and model
+	cpuid
+	movl	%eax, %ecx
+
+	andl	$0x0ff00f00, %eax	# mask family and extended family
+	shrl	$8, %eax
+	cmpl	$6, %eax
+	ja	verify_cpu_clear_xd	# family > 6, ok
+	jb	verify_cpu_check	# family < 6, skip
+
+	andl	$0x000f00f0, %ecx	# mask model and extended model
+	shrl	$4, %ecx
+	cmpl	$0xd, %ecx
+	jb	verify_cpu_check	# family == 6, model < 0xd, skip
+
+verify_cpu_clear_xd:
+	movl	$MSR_IA32_MISC_ENABLE, %ecx
+	rdmsr
+	btrl	$2, %edx		# clear MSR_IA32_MISC_ENABLE_XD_DISABLE
+	jnc	verify_cpu_check	# only write MSR if bit was changed
+	wrmsr
+
+verify_cpu_check:
 	movl    $0x1,%eax		# Does the cpu have what it takes
 	cpuid
 	andl	$REQUIRED_MASK0,%edx
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index a3250aa..410531d 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -41,7 +41,7 @@ void __init x86_report_nx(void)
 {
 	if (!cpu_has_nx) {
 		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
-		       "missing in CPU or disabled in BIOS!\n");
+		       "missing in CPU!\n");
 	} else {
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 		if (disable_nx) {
