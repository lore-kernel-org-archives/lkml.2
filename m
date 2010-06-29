Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0F2Fx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 01:53:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56261 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0F2Fx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 01:53:56 -0400
X-AuditID: b753bd60-a60ccba000005dcc-8b-4c298a71ad02
Message-ID: <4C298A6E.8070609@hitachi.com>
Date: Tue, 29 Jun 2010 14:53:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ingo Molnar <mingo@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [PATCH -tip] [BUGFIX] kprobes/x86: Fix kprobes to skip prefixes correctly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix resume_execution() and is_IF_modifier() to skip x86 instruction
prefixes correctly by using x86 instruction attribute.

Without this fix, resume_execution() can't handle instructions which
have non-REX prefixes (REX prefixes are skipped). This will cause
unexpected kernel panic by hitting bad address when a kprobe hits
on two-byte ret (e.g. "repz ret" generated for Athlon/K8 optimization),
because it just checks "repz" and can't recognize the "ret" instruction.

These prefixes can be found easily with x86 instruction attribute.
This patch introduces skip_prefixes() and uses it in resume_execution()
and is_IF_modifier() to skip prefixes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 arch/x86/kernel/kprobes.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 345a4b1..175f85c 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -126,16 +126,22 @@ static void __kprobes synthesize_reljump(void *from, void *to)
 }

 /*
- * Check for the REX prefix which can only exist on X86_64
- * X86_32 always returns 0
+ * Skip the prefixes of the instruction.
  */
-static int __kprobes is_REX_prefix(kprobe_opcode_t *insn)
+static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
 {
+	insn_attr_t attr;
+
+	attr = inat_get_opcode_attribute((insn_byte_t)*insn);
+	while (inat_is_legacy_prefix(attr)) {
+		insn++;
+		attr = inat_get_opcode_attribute((insn_byte_t)*insn);
+	}
 #ifdef CONFIG_X86_64
-	if ((*insn & 0xf0) == 0x40)
-		return 1;
+	if (inat_is_rex_prefix(attr))
+		insn++;
 #endif
-	return 0;
+	return insn;
 }

 /*
@@ -272,6 +278,9 @@ static int __kprobes can_probe(unsigned long paddr)
  */
 static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 {
+	/* Skip prefixes */
+	insn = skip_prefixes(insn);
+
 	switch (*insn) {
 	case 0xfa:		/* cli */
 	case 0xfb:		/* sti */
@@ -280,13 +289,6 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 		return 1;
 	}

-	/*
-	 * on X86_64, 0x40-0x4f are REX prefixes so we need to look
-	 * at the next byte instead.. but of course not recurse infinitely
-	 */
-	if (is_REX_prefix(insn))
-		return is_IF_modifier(++insn);
-
 	return 0;
 }

@@ -803,9 +805,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 	unsigned long orig_ip = (unsigned long)p->addr;
 	kprobe_opcode_t *insn = p->ainsn.insn;

-	/*skip the REX prefix*/
-	if (is_REX_prefix(insn))
-		insn++;
+	/* Skip prefixes */
+	insn = skip_prefixes(insn);

 	regs->flags &= ~X86_EFLAGS_TF;
 	switch (*insn) {



