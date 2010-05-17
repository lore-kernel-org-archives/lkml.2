Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab0EQWfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:35:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab0EQWfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:35:01 -0400
Date: Tue, 18 May 2010 00:34:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v2.6.35
Message-ID: <20100517223435.GA24315@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (2):
      x86, asm: Introduce and use percpu_inc()
      x86-64: Reduce SMP locks table size

Roland McGrath (1):
      x86: Use .cfi_sections for assembly code


 arch/x86/Makefile                      |    5 ++-
 arch/x86/include/asm/alternative-asm.h |    4 +-
 arch/x86/include/asm/alternative.h     |    4 +-
 arch/x86/include/asm/dwarf2.h          |   12 ++++++++
 arch/x86/include/asm/hardirq.h         |    2 +-
 arch/x86/include/asm/percpu.h          |   24 +++++++++++++++++
 arch/x86/kernel/alternative.c          |   45 +++++++++++++++++--------------
 arch/x86/kernel/cpu/mcheck/mce.c       |    4 +-
 8 files changed, 71 insertions(+), 29 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 0a43dc5..8aa1b59 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -95,8 +95,9 @@ sp-$(CONFIG_X86_64) := rsp
 cfi := $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(sp-y)$(comma)0\n.cfi_endproc,-DCONFIG_AS_CFI=1)
 # is .cfi_signal_frame supported too?
 cfi-sigframe := $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1)
-KBUILD_AFLAGS += $(cfi) $(cfi-sigframe)
-KBUILD_CFLAGS += $(cfi) $(cfi-sigframe)
+cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTIONS=1)
+KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections)
+KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index b97f786..a63a68b 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -6,8 +6,8 @@
 	.macro LOCK_PREFIX
 1:	lock
 	.section .smp_locks,"a"
-	_ASM_ALIGN
-	_ASM_PTR 1b
+	.balign 4
+	.long 1b - .
 	.previous
 	.endm
 #else
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index b09ec55..714bf24 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -30,8 +30,8 @@
 #ifdef CONFIG_SMP
 #define LOCK_PREFIX \
 		".section .smp_locks,\"a\"\n"	\
-		_ASM_ALIGN "\n"			\
-		_ASM_PTR "661f\n" /* address */	\
+		".balign 4\n"			\
+		".long 661f - .\n" /* offset */	\
 		".previous\n"			\
 		"661:\n\tlock; "
 
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index ae6253a..733f7e9 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -34,6 +34,18 @@
 #define CFI_SIGNAL_FRAME
 #endif
 
+#if defined(CONFIG_AS_CFI_SECTIONS) && defined(__ASSEMBLY__)
+	/*
+	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
+	 * The latter we currently just discard since we don't do DWARF
+	 * unwinding at runtime.  So only the offline DWARF information is
+	 * useful to anyone.  Note we should not use this directive if this
+	 * file is used in the vDSO assembly, or if vmlinux.lds.S gets
+	 * changed so it doesn't discard .eh_frame.
+	 */
+	.cfi_sections .debug_frame
+#endif
+
 #else
 
 /*
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 0f85764..aeab29a 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -35,7 +35,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
 #define __ARCH_IRQ_STAT
 
-#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
+#define inc_irq_stat(member)	percpu_inc(irq_stat.member)
 
 #define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 66a272d..0ec6d12 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -190,6 +190,29 @@ do {									\
 	pfo_ret__;					\
 })
 
+#define percpu_unary_op(op, var)			\
+({							\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+})
+
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
  * accessed while percpu_read_stable() allows the value to be cached.
@@ -207,6 +230,7 @@ do {									\
 #define percpu_and(var, val)		percpu_to_op("and", var, val)
 #define percpu_or(var, val)		percpu_to_op("or", var, val)
 #define percpu_xor(var, val)		percpu_to_op("xor", var, val)
+#define percpu_inc(var)		percpu_unary_op("inc", var)
 
 #define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1a160d5..9367384 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -194,7 +194,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 }
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
-extern u8 *__smp_locks[], *__smp_locks_end[];
+extern s32 __smp_locks[], __smp_locks_end[];
 static void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
@@ -235,37 +235,39 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 
 #ifdef CONFIG_SMP
 
-static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
+static void alternatives_smp_lock(const s32 *start, const s32 *end,
+				  u8 *text, u8 *text_end)
 {
-	u8 **ptr;
+	const s32 *poff;
 
 	mutex_lock(&text_mutex);
-	for (ptr = start; ptr < end; ptr++) {
-		if (*ptr < text)
-			continue;
-		if (*ptr > text_end)
+	for (poff = start; poff < end; poff++) {
+		u8 *ptr = (u8 *)poff + *poff;
+
+		if (!*poff || ptr < text || ptr >= text_end)
 			continue;
 		/* turn DS segment override prefix into lock prefix */
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1);
+		text_poke(ptr, ((unsigned char []){0xf0}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
 
-static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end)
+static void alternatives_smp_unlock(const s32 *start, const s32 *end,
+				    u8 *text, u8 *text_end)
 {
-	u8 **ptr;
+	const s32 *poff;
 
 	if (noreplace_smp)
 		return;
 
 	mutex_lock(&text_mutex);
-	for (ptr = start; ptr < end; ptr++) {
-		if (*ptr < text)
-			continue;
-		if (*ptr > text_end)
+	for (poff = start; poff < end; poff++) {
+		u8 *ptr = (u8 *)poff + *poff;
+
+		if (!*poff || ptr < text || ptr >= text_end)
 			continue;
 		/* turn lock prefix into DS segment override prefix */
-		text_poke(*ptr, ((unsigned char []){0x3E}), 1);
+		text_poke(ptr, ((unsigned char []){0x3E}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
@@ -276,8 +278,8 @@ struct smp_alt_module {
 	char		*name;
 
 	/* ptrs to lock prefixes */
-	u8		**locks;
-	u8		**locks_end;
+	const s32	*locks;
+	const s32	*locks_end;
 
 	/* .text segment, needed to avoid patching init code ;) */
 	u8		*text;
@@ -398,16 +400,19 @@ void alternatives_smp_switch(int smp)
 int alternatives_text_reserved(void *start, void *end)
 {
 	struct smp_alt_module *mod;
-	u8 **ptr;
+	const s32 *poff;
 	u8 *text_start = start;
 	u8 *text_end = end;
 
 	list_for_each_entry(mod, &smp_alt_modules, next) {
 		if (mod->text > text_end || mod->text_end < text_start)
 			continue;
-		for (ptr = mod->locks; ptr < mod->locks_end; ptr++)
-			if (text_start <= *ptr && text_end >= *ptr)
+		for (poff = mod->locks; poff < mod->locks_end; poff++) {
+			const u8 *ptr = (const u8 *)poff + *poff;
+
+			if (text_start <= ptr && text_end > ptr)
 				return 1;
+		}
 	}
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8a6f0af..7a355dd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -539,7 +539,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 	struct mce m;
 	int i;
 
-	__get_cpu_var(mce_poll_count)++;
+	percpu_inc(mce_poll_count);
 
 	mce_setup(&m);
 
@@ -934,7 +934,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	atomic_inc(&mce_entry);
 
-	__get_cpu_var(mce_exception_count)++;
+	percpu_inc(mce_exception_count);
 
 	if (notify_die(DIE_NMI, "machine check", regs, error_code,
 			   18, SIGKILL) == NOTIFY_STOP)
