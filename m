Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab0JUNWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:22:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802Ab0JUNWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:09 -0400
Date: Thu, 21 Oct 2010 15:21:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v2.6.37
Message-ID: <20101021132159.GA3284@elte.hu>
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

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86-64, asm: If the assembler supports fxsave64, use it

Jan Beulich (1):
      i386: Make kernel_execve() suitable for stack unwinding


 arch/x86/Makefile             |    8 ++++++--
 arch/x86/include/asm/i387.h   |    2 +-
 arch/x86/kernel/sys_i386_32.c |    4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8aa1b59..40668a9 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -96,8 +96,12 @@ cfi := $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(sp-y)$(comma)0\n.cfi_en
 # is .cfi_signal_frame supported too?
 cfi-sigframe := $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1)
 cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTIONS=1)
-KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections)
-KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections)
+
+# does binutils support specific instructions?
+asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
+
+KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr)
+KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index a73a8d5..70f105b 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -175,7 +175,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 	   uses any extended registers for addressing, a second REX prefix
 	   will be generated (to the assembler, rex64 followed by semicolon
 	   is a separate instruction), and hence the 64-bitness is lost. */
-#if 0
+#ifdef CONFIG_AS_FXSAVEQ
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
 	__asm__ __volatile__("fxsaveq %0"
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index d5e0662..0b0cb5f 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -33,8 +33,8 @@ int kernel_execve(const char *filename,
 		  const char *const envp[])
 {
 	long __res;
-	asm volatile ("push %%ebx ; movl %2,%%ebx ; int $0x80 ; pop %%ebx"
+	asm volatile ("int $0x80"
 	: "=a" (__res)
-	: "0" (__NR_execve), "ri" (filename), "c" (argv), "d" (envp) : "memory");
+	: "0" (__NR_execve), "b" (filename), "c" (argv), "d" (envp) : "memory");
 	return __res;
 }
