Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111Ab2DKXw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:52:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:39418 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934063Ab2DKXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:51:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/5] ARM: remove C users of IS_ENABLED on THUMB2_KERNEL
Date: Wed, 11 Apr 2012 19:50:54 -0400
Message-Id: <1334188257-3449-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to limit our use of IS_ENABLED to CPP #if directives if
we want to have a small autoconf.h file.  The use of it in C
code also has the negative aspect of implicitly making it look
like THUMB2_KERNEL is some kind of dynamic entity that is evaluated
at runtime, when it really is a Kconfig bool and hence an
either/or thing selected at config time.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/include/asm/opcodes.h |    6 ++++++
 arch/arm/kernel/ftrace.c       |    9 ++-------
 arch/arm/kernel/insn.c         |    9 +++++----
 arch/arm/kernel/kprobes.c      |   34 +++++++++++++++++-----------------
 arch/arm/kernel/patch.c        |   28 +++++++++++++++-------------
 5 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/arch/arm/include/asm/opcodes.h b/arch/arm/include/asm/opcodes.h
index 19c48de..7e372d7 100644
--- a/arch/arm/include/asm/opcodes.h
+++ b/arch/arm/include/asm/opcodes.h
@@ -58,6 +58,12 @@ extern asmlinkage unsigned int arm_check_condition(u32 opcode, u32 psr);
 #define __opcode_to_mem_thumb32(x) swahw32(x)
 #endif
 
+#ifdef CONFIG_THUMB2_KERNEL
+#define __opcode_to_mem	__opcode_to_mem_thumb32
+#else
+#define __opcode_to_mem	__opcode_to_mem_arm
+#endif
+
 #define __mem_to_opcode_arm(x) __opcode_to_mem_arm(x)
 #define __mem_to_opcode_thumb16(x) __opcode_to_mem_thumb16(x)
 #define __mem_to_opcode_thumb32(x) __opcode_to_mem_thumb32(x)
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index df0bf0c..0e41ff8 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -73,13 +73,8 @@ static int ftrace_modify_code(unsigned long pc, unsigned long old,
 {
 	unsigned long replaced;
 
-	if (IS_ENABLED(CONFIG_THUMB2_KERNEL)) {
-		old = __opcode_to_mem_thumb32(old);
-		new = __opcode_to_mem_thumb32(new);
-	} else {
-		old = __opcode_to_mem_arm(old);
-		new = __opcode_to_mem_arm(new);
-	}
+	old = __opcode_to_mem(old);
+	new = __opcode_to_mem(new);
 
 	if (validate) {
 		if (probe_kernel_read(&replaced, (void *)pc, MCOUNT_INSN_SIZE))
diff --git a/arch/arm/kernel/insn.c b/arch/arm/kernel/insn.c
index b760340..12f9fbd 100644
--- a/arch/arm/kernel/insn.c
+++ b/arch/arm/kernel/insn.c
@@ -55,8 +55,9 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
 unsigned long
 __arm_gen_branch(unsigned long pc, unsigned long addr, bool link)
 {
-	if (IS_ENABLED(CONFIG_THUMB2_KERNEL))
-		return __arm_gen_branch_thumb2(pc, addr, link);
-	else
-		return __arm_gen_branch_arm(pc, addr, link);
+#ifdef CONFIG_THUMB2_KERNEL
+	return __arm_gen_branch_thumb2(pc, addr, link);
+#else
+	return __arm_gen_branch_arm(pc, addr, link);
+#endif
 }
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 4dd41fc..859c7d2 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -109,25 +109,25 @@ void __kprobes arch_arm_kprobe(struct kprobe *p)
 	unsigned int brkp;
 	void *addr;
 
-	if (IS_ENABLED(CONFIG_THUMB2_KERNEL)) {
-		/* Remove any Thumb flag */
-		addr = (void *)((uintptr_t)p->addr & ~1);
-
-		if (is_wide_instruction(p->opcode))
-			brkp = KPROBE_THUMB32_BREAKPOINT_INSTRUCTION;
-		else
-			brkp = KPROBE_THUMB16_BREAKPOINT_INSTRUCTION;
-	} else {
-		kprobe_opcode_t insn = p->opcode;
+#ifdef CONFIG_THUMB2_KERNEL
+	/* Remove any Thumb flag */
+	addr = (void *)((uintptr_t)p->addr & ~1);
 
-		addr = p->addr;
-		brkp = KPROBE_ARM_BREAKPOINT_INSTRUCTION;
+	if (is_wide_instruction(p->opcode))
+		brkp = KPROBE_THUMB32_BREAKPOINT_INSTRUCTION;
+	else
+		brkp = KPROBE_THUMB16_BREAKPOINT_INSTRUCTION;
+#else
+	kprobe_opcode_t insn = p->opcode;
 
-		if (insn >= 0xe0000000)
-			brkp |= 0xe0000000;  /* Unconditional instruction */
-		else
-			brkp |= insn & 0xf0000000;  /* Copy condition from insn */
-	}
+	addr = p->addr;
+	brkp = KPROBE_ARM_BREAKPOINT_INSTRUCTION;
+
+	if (insn >= 0xe0000000)
+		brkp |= 0xe0000000;  /* Unconditional instruction */
+	else
+		brkp |= insn & 0xf0000000;  /* Copy condition from insn */
+#endif
 
 	patch_text(addr, brkp);
 }
diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
index 07314af..2d1995c 100644
--- a/arch/arm/kernel/patch.c
+++ b/arch/arm/kernel/patch.c
@@ -15,13 +15,13 @@ struct patch {
 
 void __kprobes __patch_text(void *addr, unsigned int insn)
 {
-	bool thumb2 = IS_ENABLED(CONFIG_THUMB2_KERNEL);
-	int size;
+	int size = 0;
 
-	if (thumb2 && __opcode_is_thumb16(insn)) {
+#ifdef CONFIG_THUMB2_KERNEL
+	if (__opcode_is_thumb16(insn)) {
 		*(u16 *)addr = __opcode_to_mem_thumb16(insn);
 		size = sizeof(u16);
-	} else if (thumb2 && ((uintptr_t)addr & 2)) {
+	} else if (((uintptr_t)addr & 2)) {
 		u16 first = __opcode_thumb32_first(insn);
 		u16 second = __opcode_thumb32_second(insn);
 		u16 *addrh = addr;
@@ -30,12 +30,10 @@ void __kprobes __patch_text(void *addr, unsigned int insn)
 		addrh[1] = __opcode_to_mem_thumb16(second);
 
 		size = sizeof(u32);
-	} else {
-		if (thumb2)
-			insn = __opcode_to_mem_thumb32(insn);
-		else
-			insn = __opcode_to_mem_arm(insn);
-
+	}
+#endif
+	if (!size) {
+		insn = __opcode_to_mem(insn);
 		*(u32 *)addr = insn;
 		size = sizeof(u32);
 	}
@@ -63,10 +61,14 @@ void __kprobes patch_text(void *addr, unsigned int insn)
 	if (cache_ops_need_broadcast()) {
 		stop_machine(patch_text_stop_machine, &patch, cpu_online_mask);
 	} else {
-		bool straddles_word = IS_ENABLED(CONFIG_THUMB2_KERNEL)
-				      && __opcode_is_thumb32(insn)
-				      && ((uintptr_t)addr & 2);
+		bool straddles_word;
 
+#ifdef CONFIG_THUMB2_KERNEL
+		straddles_word = __opcode_is_thumb32(insn)
+				      && ((uintptr_t)addr & 2);
+#else
+		straddles_word = 0;
+#endif
 		if (straddles_word)
 			stop_machine(patch_text_stop_machine, &patch, NULL);
 		else
-- 
1.7.9.1

