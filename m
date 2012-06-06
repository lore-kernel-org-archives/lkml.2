Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab2FFJUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:20:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57931 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2FFJUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:20:01 -0400
Date: Wed, 6 Jun 2012 14:49:50 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, oleg@redhat.com
Subject: [PATCH 1/2] uprobes: Pass probed vaddr to
	arch_uprobe_analyze_insn()
Message-ID: <20120606091950.GB6745@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060609-7606-0000-0000-000000E5F85B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

On RISC architectures like powerpc, instructions are fixed size.
Instruction analysis on such platforms is just a matter of (insn % 4).
Pass the vaddr at which the uprobe is to be inserted so that
arch_uprobe_analyze_insn() can flag misaligned registration requests.

Signed-off-by: Ananth N Mavinakaynahalli <ananth@in.ibm.com>
---
 arch/x86/include/asm/uprobes.h |    2 +-
 arch/x86/kernel/uprobes.c      |    3 ++-
 kernel/events/uprobes.c        |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

Index: uprobes-24may/arch/x86/include/asm/uprobes.h
===================================================================
--- uprobes-24may.orig/arch/x86/include/asm/uprobes.h
+++ uprobes-24may/arch/x86/include/asm/uprobes.h
@@ -48,7 +48,7 @@ struct arch_uprobe_task {
 #endif
 };
 
-extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm);
+extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, loff_t vaddr);
 extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
Index: uprobes-24may/arch/x86/kernel/uprobes.c
===================================================================
--- uprobes-24may.orig/arch/x86/kernel/uprobes.c
+++ uprobes-24may/arch/x86/kernel/uprobes.c
@@ -409,9 +409,10 @@ static int validate_insn_bits(struct arc
  * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
  * @mm: the probed address space.
  * @arch_uprobe: the probepoint information.
+ * @vaddr: virtual address at which to install the probepoint
  * Return 0 on success or a -ve number on error.
  */
-int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm)
+int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, loff_t vaddr)
 {
 	int ret;
 	struct insn insn;
Index: uprobes-24may/kernel/events/uprobes.c
===================================================================
--- uprobes-24may.orig/kernel/events/uprobes.c
+++ uprobes-24may/kernel/events/uprobes.c
@@ -697,7 +697,7 @@ install_breakpoint(struct uprobe *uprobe
 		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
 			return -EEXIST;
 
-		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm);
+		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
 		if (ret)
 			return ret;
 

