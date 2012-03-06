Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab2CFQSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:18:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab2CFQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:18:41 -0500
Date: Tue, 6 Mar 2012 08:17:48 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-464846888d9aad186cab3acdae6b654f9eb19772@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120305133215.5982.31991.stgit@localhost.localdomain>
References: <20120305133215.5982.31991.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/kprobes:
  Fix a bug which can modify kernel code permanently
Git-Commit-ID: 464846888d9aad186cab3acdae6b654f9eb19772
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:18:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  464846888d9aad186cab3acdae6b654f9eb19772
Gitweb:     http://git.kernel.org/tip/464846888d9aad186cab3acdae6b654f9eb19772
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 5 Mar 2012 22:32:16 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:49:49 +0100

x86/kprobes: Fix a bug which can modify kernel code permanently

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
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: systemtap@sourceware.org
Cc: anderson@redhat.com
Link: http://lkml.kernel.org/r/20120305133215.5982.31991.stgit@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
