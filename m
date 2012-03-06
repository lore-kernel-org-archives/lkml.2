Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2CFQSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:18:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2CFQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:17:59 -0500
Date: Tue, 6 Mar 2012 08:16:59 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-86b4ce3156c0dc140907ad03639564000cde694f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120305133209.5982.36568.stgit@localhost.localdomain>
References: <20120305133209.5982.36568.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/kprobes:
  Fix instruction recovery on optimized path
Git-Commit-ID: 86b4ce3156c0dc140907ad03639564000cde694f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:17:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86b4ce3156c0dc140907ad03639564000cde694f
Gitweb:     http://git.kernel.org/tip/86b4ce3156c0dc140907ad03639564000cde694f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 5 Mar 2012 22:32:09 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:49:48 +0100

x86/kprobes: Fix instruction recovery on optimized path

Current probed-instruction recovery expects that only breakpoint
instruction modifies instruction. However, since kprobes jump
optimization can replace original instructions with a jump,
that expectation is not enough. And it may cause instruction
decoding failure on the function where an optimized probe
already exists.

This bug can reproduce easily as below:

1) find a target function address (any kprobe-able function is OK)

 $ grep __secure_computing /proc/kallsyms
   ffffffff810c19d0 T __secure_computing

2) decode the function
   $ objdump -d vmlinux --start-address=0xffffffff810c19d0 --stop-address=0xffffffff810c19eb

  vmlinux:     file format elf64-x86-64

Disassembly of section .text:

ffffffff810c19d0 <__secure_computing>:
ffffffff810c19d0:       55                      push   %rbp
ffffffff810c19d1:       48 89 e5                mov    %rsp,%rbp
ffffffff810c19d4:       e8 67 8f 72 00          callq
ffffffff817ea940 <mcount>
ffffffff810c19d9:       65 48 8b 04 25 40 b8    mov    %gs:0xb840,%rax
ffffffff810c19e0:       00 00
ffffffff810c19e2:       83 b8 88 05 00 00 01    cmpl $0x1,0x588(%rax)
ffffffff810c19e9:       74 05                   je     ffffffff810c19f0 <__secure_computing+0x20>

3) put a kprobe-event at an optimize-able place, where no
 call/jump places within the 5 bytes.
 $ su -
 # cd /sys/kernel/debug/tracing
 # echo p __secure_computing+0x9 > kprobe_events

4) enable it and check it is optimized.
 # echo 1 > events/kprobes/p___secure_computing_9/enable
 # cat ../kprobes/list
 ffffffff810c19d9  k  __secure_computing+0x9    [OPTIMIZED]

5) put another kprobe on an instruction after previous probe in
  the same function.
 # echo p __secure_computing+0x12 >> kprobe_events
 bash: echo: write error: Invalid argument
 # dmesg | tail -n 1
 [ 1666.500016] Probing address(0xffffffff810c19e2) is not an instruction boundary.

6) however, if the kprobes optimization is disabled, it works.
 # echo 0 > /proc/sys/debug/kprobes-optimization
 # cat ../kprobes/list
 ffffffff810c19d9  k  __secure_computing+0x9
 # echo p __secure_computing+0x12 >> kprobe_events
 (no error)

This is because kprobes doesn't recover the instruction
which is overwritten with a relative jump by another kprobe
when finding instruction boundary.
It only recovers the breakpoint instruction.

This patch fixes kprobes to recover such instructions.

With this fix:

 # echo p __secure_computing+0x9 > kprobe_events
 # echo 1 > events/kprobes/p___secure_computing_9/enable
 # cat ../kprobes/list
 ffffffff810c1aa9  k  __secure_computing+0x9    [OPTIMIZED]
 # echo p __secure_computing+0x12 >> kprobe_events
 # cat ../kprobes/list
 ffffffff810c1aa9  k  __secure_computing+0x9    [OPTIMIZED]
 ffffffff810c1ab2  k  __secure_computing+0x12    [DISABLED]

Changes in v4:
 - Fix a bug to ensure optimized probe is really optimized
   by jump.
 - Remove kprobe_optready() dependency.
 - Cleanup code for preparing optprobe separation.

Changes in v3:
 - Fix a build error when CONFIG_OPTPROBE=n. (Thanks, Ingo!)
   To fix the error, split optprobe instruction recovering
   path from kprobes path.
 - Cleanup comments/styles.

Changes in v2:
 - Fix a bug to recover original instruction address in
   RIP-relative instruction fixup.
 - Moved on tip/master.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: systemtap@sourceware.org
Cc: anderson@redhat.com
Link: http://lkml.kernel.org/r/20120305133209.5982.36568.stgit@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |  140 +++++++++++++++++++++++++++++++--------------
 1 files changed, 97 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7da647d..6bec22f 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -207,13 +207,15 @@ retry:
 	}
 }
 
-/* Recover the probed instruction at addr for further analysis. */
-static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
+static unsigned long __recover_probed_insn(kprobe_opcode_t *buf,
+					   unsigned long addr)
 {
 	struct kprobe *kp;
+
 	kp = get_kprobe((void *)addr);
+	/* There is no probe, return original address */
 	if (!kp)
-		return -EINVAL;
+		return addr;
 
 	/*
 	 *  Basically, kp->ainsn.insn has an original instruction.
@@ -230,14 +232,76 @@ static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
 	 */
 	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
 	buf[0] = kp->opcode;
-	return 0;
+	return (unsigned long)buf;
+}
+
+#ifdef CONFIG_OPTPROBES
+static unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf,
+					      unsigned long addr)
+{
+	struct optimized_kprobe *op;
+	struct kprobe *kp;
+	long offs;
+	int i;
+
+	for (i = 0; i < RELATIVEJUMP_SIZE; i++) {
+		kp = get_kprobe((void *)addr - i);
+		/* This function only handles jump-optimized kprobe */
+		if (kp && kprobe_optimized(kp)) {
+			op = container_of(kp, struct optimized_kprobe, kp);
+			/* If op->list is not empty, op is under optimizing */
+			if (list_empty(&op->list))
+				goto found;
+		}
+	}
+
+	return addr;
+found:
+	/*
+	 * If the kprobe can be optimized, original bytes which can be
+	 * overwritten by jump destination address. In this case, original
+	 * bytes must be recovered from op->optinsn.copied_insn buffer.
+	 */
+	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	if (addr == (unsigned long)kp->addr) {
+		buf[0] = kp->opcode;
+		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+	} else {
+		offs = addr - (unsigned long)kp->addr - 1;
+		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
+	}
+
+	return (unsigned long)buf;
+}
+#else
+static inline unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf,
+						     unsigned long addr)
+{
+	return addr;
+}
+#endif
+
+/*
+ * Recover the probed instruction at addr for further analysis.
+ * Caller must lock kprobes by kprobe_mutex, or disable preemption
+ * for preventing to release referencing kprobes.
+ */
+static unsigned long recover_probed_instruction(kprobe_opcode_t *buf,
+						unsigned long addr)
+{
+	unsigned long __addr;
+
+	__addr = __recover_optprobed_insn(buf, addr);
+	if (__addr != addr)
+		return __addr;
+
+	return __recover_probed_insn(buf, addr);
 }
 
 /* Check if paddr is at an instruction boundary */
 static int __kprobes can_probe(unsigned long paddr)
 {
-	int ret;
-	unsigned long addr, offset = 0;
+	unsigned long addr, __addr, offset = 0;
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
 
@@ -247,26 +311,24 @@ static int __kprobes can_probe(unsigned long paddr)
 	/* Decode instructions */
 	addr = paddr - offset;
 	while (addr < paddr) {
-		kernel_insn_init(&insn, (void *)addr);
-		insn_get_opcode(&insn);
-
 		/*
 		 * Check if the instruction has been modified by another
 		 * kprobe, in which case we replace the breakpoint by the
 		 * original instruction in our buffer.
+		 * Also, jump optimization will change the breakpoint to
+		 * relative-jump. Since the relative-jump itself is
+		 * normally used, we just go through if there is no kprobe.
 		 */
-		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
-			ret = recover_probed_instruction(buf, addr);
-			if (ret)
-				/*
-				 * Another debugging subsystem might insert
-				 * this breakpoint. In that case, we can't
-				 * recover it.
-				 */
-				return 0;
-			kernel_insn_init(&insn, buf);
-		}
+		__addr = recover_probed_instruction(buf, addr);
+		kernel_insn_init(&insn, (void *)__addr);
 		insn_get_length(&insn);
+
+		/*
+		 * Another debugging subsystem might insert this breakpoint.
+		 * In that case, we can't recover it.
+		 */
+		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
+			return 0;
 		addr += insn.length;
 	}
 
@@ -302,21 +364,17 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 static int __kprobes __copy_instruction(u8 *dest, u8 *src, int recover)
 {
 	struct insn insn;
-	int ret;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
+	u8 *orig_src = src;	/* Back up original src for RIP calculation */
+
+	if (recover)
+		src = (u8 *)recover_probed_instruction(buf, (unsigned long)src);
 
 	kernel_insn_init(&insn, src);
-	if (recover) {
-		insn_get_opcode(&insn);
-		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
-			ret = recover_probed_instruction(buf,
-							 (unsigned long)src);
-			if (ret)
-				return 0;
-			kernel_insn_init(&insn, buf);
-		}
-	}
 	insn_get_length(&insn);
+	/* Another subsystem puts a breakpoint, failed to recover */
+	if (recover && insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
+		return 0;
 	memcpy(dest, insn.kaddr, insn.length);
 
 #ifdef CONFIG_X86_64
@@ -337,8 +395,7 @@ static int __kprobes __copy_instruction(u8 *dest, u8 *src, int recover)
 		 * extension of the original signed 32-bit displacement would
 		 * have given.
 		 */
-		newdisp = (u8 *) src + (s64) insn.displacement.value -
-			  (u8 *) dest;
+		newdisp = (u8 *) orig_src + (s64) insn.displacement.value - (u8 *) dest;
 		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
 		disp = (u8 *) dest + insn_offset_displacement(&insn);
 		*(s32 *) disp = (s32) newdisp;
@@ -1271,8 +1328,7 @@ static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
 /* Decode whole function to ensure any instructions don't jump into target */
 static int __kprobes can_optimize(unsigned long paddr)
 {
-	int ret;
-	unsigned long addr, size = 0, offset = 0;
+	unsigned long addr, __addr, size = 0, offset = 0;
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
 
@@ -1301,15 +1357,12 @@ static int __kprobes can_optimize(unsigned long paddr)
 			 * we can't optimize kprobe in this function.
 			 */
 			return 0;
-		kernel_insn_init(&insn, (void *)addr);
-		insn_get_opcode(&insn);
-		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
-			ret = recover_probed_instruction(buf, addr);
-			if (ret)
-				return 0;
-			kernel_insn_init(&insn, buf);
-		}
+		__addr = recover_probed_instruction(buf, addr);
+		kernel_insn_init(&insn, (void *)__addr);
 		insn_get_length(&insn);
+		/* Another subsystem puts a breakpoint */
+		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
+			return 0;
 		/* Recover address */
 		insn.kaddr = (void *)addr;
 		insn.next_byte = (void *)(addr + insn.length);
@@ -1366,6 +1419,7 @@ void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
 /*
  * Copy replacing target instructions
  * Target instructions MUST be relocatable (checked inside)
+ * This is called when new aggr(opt)probe is allocated or reused.
  */
 int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 {
