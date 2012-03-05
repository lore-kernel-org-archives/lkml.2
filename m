Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2CENcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:32:22 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51246 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab2CENcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:32:20 -0500
X-AuditID: b753bd60-9aec5ba00000029c-40-4f54c0611e7c
X-AuditID: b753bd60-9aec5ba00000029c-40-4f54c0611e7c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v4 -tip 2/3] [BUGFIX] x86/kprobes: Fix a bug which can modify
 kernel code
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com, systemtap@sourceware.org,
        anderson@redhat.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 05 Mar 2012 22:32:16 +0900
Message-ID: <20120305133215.5982.31991.stgit@localhost.localdomain>
In-Reply-To: <20120305133200.5982.45827.stgit@localhost.localdomain>
References: <20120305133200.5982.45827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in kprobes which can modify kernel code
permanently at run-time. In the result, kernel can
crash when it executes the modified code.
This bug can happen when we put two probes enough near
and the first probe is optimized. When the second probe
is set up, it copies a byte which is already modified
by the first probe, and executes it when the probe is hit.
Even worse, the first probe and the second probe are removed
respectively, the second probe writes back the copied
(modified) instruction.

To fix this bug, kprobes always recovers the original
code and copies the first byte from recovered instruction.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 arch/x86/kernel/kprobes.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 6bec22f..ca6d450 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -361,19 +361,15 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
  * If not, return null.
  * Only applicable to 64-bit x86.
  */
-static int __kprobes __copy_instruction(u8 *dest, u8 *src, int recover)
+static int __kprobes __copy_instruction(u8 *dest, u8 *src)
 {
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
-	u8 *orig_src = src;	/* Back up original src for RIP calculation */
 
-	if (recover)
-		src = (u8 *)recover_probed_instruction(buf, (unsigned long)src);
-
-	kernel_insn_init(&insn, src);
+	kernel_insn_init(&insn, (void *)recover_probed_instruction(buf, (unsigned long)src));
 	insn_get_length(&insn);
 	/* Another subsystem puts a breakpoint, failed to recover */
-	if (recover && insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
+	if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
 		return 0;
 	memcpy(dest, insn.kaddr, insn.length);
 
@@ -395,7 +391,7 @@ static int __kprobes __copy_instruction(u8 *dest, u8 *src, int recover)
 		 * extension of the original signed 32-bit displacement would
 		 * have given.
 		 */
-		newdisp = (u8 *) orig_src + (s64) insn.displacement.value - (u8 *) dest;
+		newdisp = (u8 *) src + (s64) insn.displacement.value - (u8 *) dest;
 		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
 		disp = (u8 *) dest + insn_offset_displacement(&insn);
 		*(s32 *) disp = (s32) newdisp;
@@ -406,18 +402,20 @@ static int __kprobes __copy_instruction(u8 *dest, u8 *src, int recover)
 
 static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
+	/* Copy an instruction with recovering if other optprobe modifies it.*/
+	__copy_instruction(p->ainsn.insn, p->addr);
+
 	/*
-	 * Copy an instruction without recovering int3, because it will be
-	 * put by another subsystem.
+	 * __copy_instruction can modify the displacement of the instruction,
+	 * but it doesn't affect boostable check.
 	 */
-	__copy_instruction(p->ainsn.insn, p->addr, 0);
-
-	if (can_boost(p->addr))
+	if (can_boost(p->ainsn.insn))
 		p->ainsn.boostable = 0;
 	else
 		p->ainsn.boostable = -1;
 
-	p->opcode = *p->addr;
+	/* Also, displacement change doesn't affect the first byte */
+	p->opcode = p->ainsn.insn[0];
 }
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
@@ -1276,7 +1274,7 @@ static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
 	int len = 0, ret;
 
 	while (len < RELATIVEJUMP_SIZE) {
-		ret = __copy_instruction(dest + len, src + len, 1);
+		ret = __copy_instruction(dest + len, src + len);
 		if (!ret || !can_boost(dest + len))
 			return -EINVAL;
 		len += ret;
@@ -1328,7 +1326,7 @@ static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
 /* Decode whole function to ensure any instructions don't jump into target */
 static int __kprobes can_optimize(unsigned long paddr)
 {
-	unsigned long addr, __addr, size = 0, offset = 0;
+	unsigned long addr, size = 0, offset = 0;
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
 
@@ -1357,8 +1355,7 @@ static int __kprobes can_optimize(unsigned long paddr)
 			 * we can't optimize kprobe in this function.
 			 */
 			return 0;
-		__addr = recover_probed_instruction(buf, addr);
-		kernel_insn_init(&insn, (void *)__addr);
+		kernel_insn_init(&insn, (void *)recover_probed_instruction(buf, addr));
 		insn_get_length(&insn);
 		/* Another subsystem puts a breakpoint */
 		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)

