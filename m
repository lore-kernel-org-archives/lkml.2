Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0F2JZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:25:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:39299 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0F2JZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:25:24 -0400
Date: Tue, 29 Jun 2010 09:24:41 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C298A6E.8070609@hitachi.com>
References: <4C298A6E.8070609@hitachi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes/x86: Fix kprobes to skip prefixes correctly
Message-ID: <tip-567a9fd86735ccdc897768ed2dacdd5e83a13509@git.kernel.org>
Git-Commit-ID: 567a9fd86735ccdc897768ed2dacdd5e83a13509
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:24:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  567a9fd86735ccdc897768ed2dacdd5e83a13509
Gitweb:     http://git.kernel.org/tip/567a9fd86735ccdc897768ed2dacdd5e83a13509
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Tue, 29 Jun 2010 14:53:50 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 29 Jun 2010 10:43:41 +0200

kprobes/x86: Fix kprobes to skip prefixes correctly

Fix resume_execution() and is_IF_modifier() to skip x86
instruction prefixes correctly by using x86 instruction
attribute.

Without this fix, resume_execution() can't handle instructions
which have non-REX prefixes (REX prefixes are skipped). This
will cause unexpected kernel panic by hitting bad address when a
kprobe hits on two-byte ret (e.g. "repz ret" generated for
Athlon/K8 optimization), because it just checks "repz" and can't
recognize the "ret" instruction.

These prefixes can be found easily with x86 instruction
attribute. This patch introduces skip_prefixes() and uses it in
resume_execution() and is_IF_modifier() to skip prefixes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <4C298A6E.8070609@hitachi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
