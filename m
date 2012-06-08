Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137Ab2FHJdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:33:17 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36681 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2FHJdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:33:15 -0400
Date: Fri, 8 Jun 2012 15:02:57 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Cc: michael@ellerman.id.au, antonb@thinktux.localdomain,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jim Keniston <jkenisto@us.ibm.com>, oleg@redhat.com
Subject: [PATCH v2 1/2] uprobes: Pass probed vaddr to
	arch_uprobe_analyze_insn()
Message-ID: <20120608093257.GG13409@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060809-5518-0000-0000-00000504624C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

On RISC architectures like powerpc, instructions are fixed size.
Instruction analysis on such platforms is just a matter of (insn % 4).
Pass the vaddr at which the uprobe is to be inserted so that
arch_uprobe_analyze_insn() can flag misaligned registration requests.

Changes in V2:
Pass (unsigned long)addr instead of (loff_t)vaddr to
arch_uprobe_analyze_insn(). We need the loff_t vaddr to take care of
the offset of inode:offset pair for large file sizes on 32bit.

Signed-off-by: Ananth N Mavinakaynahalli <ananth@in.ibm.com>
---
 arch/x86/include/asm/uprobes.h |    2 +-
 arch/x86/kernel/uprobes.c      |    3 ++-
 kernel/events/uprobes.c        |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-3.5-rc1/arch/x86/include/asm/uprobes.h
===================================================================
--- linux-3.5-rc1.orig/arch/x86/include/asm/uprobes.h
+++ linux-3.5-rc1/arch/x86/include/asm/uprobes.h
@@ -48,7 +48,7 @@ struct arch_uprobe_task {
 #endif
 };
 
-extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm);
+extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
 extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
Index: linux-3.5-rc1/arch/x86/kernel/uprobes.c
===================================================================
--- linux-3.5-rc1.orig/arch/x86/kernel/uprobes.c
+++ linux-3.5-rc1/arch/x86/kernel/uprobes.c
@@ -409,9 +409,10 @@ static int validate_insn_bits(struct arc
  * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
  * @mm: the probed address space.
  * @arch_uprobe: the probepoint information.
+ * @addr: virtual address at which to install the probepoint
  * Return 0 on success or a -ve number on error.
  */
-int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm)
+int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
 {
 	int ret;
 	struct insn insn;
Index: linux-3.5-rc1/kernel/events/uprobes.c
===================================================================
--- linux-3.5-rc1.orig/kernel/events/uprobes.c
+++ linux-3.5-rc1/kernel/events/uprobes.c
@@ -697,7 +697,7 @@ install_breakpoint(struct uprobe *uprobe
 		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
 			return -EEXIST;
 
-		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm);
+		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, addr);
 		if (ret)
 			return ret;
 

