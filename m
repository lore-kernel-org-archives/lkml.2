Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2BXJyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:54:25 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43712 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2BXJyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:54:22 -0500
X-AuditID: b753bd60-a1286ba000000655-93-4f475e4b6c4b
X-AuditID: b753bd60-a1286ba000000655-93-4f475e4b6c4b
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v3 -tip] [BUGFIX] x86/kprobes: Fix to recover instructions on
 optimized path
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com, systemtap@sourceware.org,
        anderson@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Fri, 24 Feb 2012 18:54:13 +0900
Message-ID: <20120224095412.8462.55698.stgit@localhost.localdomain>
In-Reply-To: <20120223083703.GA26781@elte.hu>
References: <20120223083703.GA26781@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current probed-instruction recovery expects that only breakpoint
instruction modifies instruction. However, since kprobes jump
optimization can replace original instructions with a jump,
that expectation is not enough. And it may cause instruction
decoding failure on the function where an optimized probe
already exists.

This bug can reproduce easily as below.

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
ffffffff810c19d4:       e8 67 8f 72 00          callq  ffffffff817ea940 <mcount>
ffffffff810c19d9:       65 48 8b 04 25 40 b8    mov    %gs:0xb840,%rax
ffffffff810c19e0:       00 00
ffffffff810c19e2:       83 b8 88 05 00 00 01    cmpl   $0x1,0x588(%rax)
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 arch/x86/kernel/kprobes.c |  128 ++++++++++++++++++++++++++++-----------------
 include/linux/kprobes.h   |    6 ++
 kernel/kprobes.c          |    2 -
 3 files changed, 88 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7da647d..77ea425 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -207,14 +207,9 @@ retry:
 	}
 }
 
-/* Recover the probed instruction at addr for further analysis. */
-static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
+static unsigned long __recover_probed_insn(struct kprobe *kp,
+					   kprobe_opcode_t *buf)
 {
-	struct kprobe *kp;
-	kp = get_kprobe((void *)addr);
-	if (!kp)
-		return -EINVAL;
-
 	/*
 	 *  Basically, kp->ainsn.insn has an original instruction.
 	 *  However, RIP-relative instruction can not do single-stepping
@@ -230,14 +225,63 @@ static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
 	 */
 	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
 	buf[0] = kp->opcode;
-	return 0;
+	return (unsigned long)buf;
+}
+
+#ifdef CONFIG_OPTPROBES
+static unsigned long __recover_optprobed_insn(struct kprobe *kp,
+					      kprobe_opcode_t *buf,
+					      unsigned long addr)
+{
+	long offs = addr - (unsigned long)kp->addr - 1;
+	struct optimized_kprobe *op = container_of(kp, struct optimized_kprobe, kp);
+
+	/*
+	 * If the kprobe can be optimized, original bytes which can be
+	 * overwritten by jump destination address. In this case, original
+	 * bytes must be recovered from op->optinsn.copied_insn buffer.
+	 */
+	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	if (addr == (unsigned long)kp->addr) {
+		buf[0] = kp->opcode;
+		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+	} else
+		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
+
+	return (unsigned long)buf;
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
+	struct kprobe *kp;
+#ifdef CONFIG_OPTPROBES
+	int i;
+
+	for (i = 0; i < RELATIVEJUMP_SIZE; i++) {
+		kp = get_kprobe((void *)addr - i);
+		if (kp && kprobe_optready(kp))
+			return __recover_optprobed_insn(kp, buf, addr);
+	}
+#endif
+	kp = get_kprobe((void *)addr);
+	/* There is no probe, return original address */
+	if (!kp)
+		return addr;
+
+	return __recover_probed_insn(kp, buf);
 }
 
 /* Check if paddr is at an instruction boundary */
 static int __kprobes can_probe(unsigned long paddr)
 {
-	int ret;
-	unsigned long addr, offset = 0;
+	unsigned long addr, __addr, offset = 0;
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
 
@@ -247,26 +291,24 @@ static int __kprobes can_probe(unsigned long paddr)
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
 
@@ -302,21 +344,17 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
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
@@ -337,8 +375,7 @@ static int __kprobes __copy_instruction(u8 *dest, u8 *src, int recover)
 		 * extension of the original signed 32-bit displacement would
 		 * have given.
 		 */
-		newdisp = (u8 *) src + (s64) insn.displacement.value -
-			  (u8 *) dest;
+		newdisp = (u8 *) orig_src + (s64) insn.displacement.value - (u8 *) dest;
 		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
 		disp = (u8 *) dest + insn_offset_displacement(&insn);
 		*(s32 *) disp = (s32) newdisp;
@@ -1271,8 +1308,7 @@ static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
 /* Decode whole function to ensure any instructions don't jump into target */
 static int __kprobes can_optimize(unsigned long paddr)
 {
-	int ret;
-	unsigned long addr, size = 0, offset = 0;
+	unsigned long addr, __addr, size = 0, offset = 0;
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
 
@@ -1301,15 +1337,12 @@ static int __kprobes can_optimize(unsigned long paddr)
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
@@ -1366,6 +1399,7 @@ void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
 /*
  * Copy replacing target instructions
  * Target instructions MUST be relocatable (checked inside)
+ * This is called when new aggr(opt)probe is allocated or reused.
  */
 int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 {
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index dce6e4d..6abec49 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -293,6 +293,12 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 					     size_t *length, loff_t *ppos);
 #endif
 
+extern int kprobe_optready(struct kprobe *p);
+#else /* CONFIG_OPTPROBES */
+static inline int kprobe_optready(struct kprobe *p)
+{
+	return 0;
+}
 #endif /* CONFIG_OPTPROBES */
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9788c0e..c52c68b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -403,7 +403,7 @@ static __kprobes void free_aggr_kprobe(struct kprobe *p)
 }
 
 /* Return true(!0) if the kprobe is ready for optimization. */
-static inline int kprobe_optready(struct kprobe *p)
+int kprobe_optready(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 

