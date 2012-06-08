Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045Ab2FHPAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:00:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2FHPAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:00:04 -0400
Date: Fri, 8 Jun 2012 07:58:02 -0700
From: tip-bot for Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Message-ID: <tip-7eb9ba5ed312ec6ed9d22259c5da1acb7cf4bd29@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jkenisto@us.ibm.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: ananth@in.ibm.com, mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jkenisto@us.ibm.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120608093257.GG13409@in.ibm.com>
References: <20120608093257.GG13409@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes:
  Pass probed vaddr to arch_uprobe_analyze_insn()
Git-Commit-ID: 7eb9ba5ed312ec6ed9d22259c5da1acb7cf4bd29
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:58:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7eb9ba5ed312ec6ed9d22259c5da1acb7cf4bd29
Gitweb:     http://git.kernel.org/tip/7eb9ba5ed312ec6ed9d22259c5da1acb7cf4bd29
Author:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
AuthorDate: Fri, 8 Jun 2012 15:02:57 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 12:22:27 +0200

uprobes: Pass probed vaddr to arch_uprobe_analyze_insn()

On RISC architectures like powerpc, instructions are fixed size.
Instruction analysis on such platforms is just a matter of
(insn % 4). Pass the vaddr at which the uprobe is to be inserted so
that arch_uprobe_analyze_insn() can flag misaligned registration
requests.

Signed-off-by: Ananth N Mavinakaynahalli <ananth@in.ibm.com>
Cc: michael@ellerman.id.au
Cc: antonb@thinktux.localdomain
Cc: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org
Cc: peterz@infradead.org
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: oleg@redhat.com
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/20120608093257.GG13409@in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/uprobes.h |    2 +-
 arch/x86/kernel/uprobes.c      |    3 ++-
 kernel/events/uprobes.c        |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 1e9bed1..f3971bb 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -48,7 +48,7 @@ struct arch_uprobe_task {
 #endif
 };
 
-extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm);
+extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
 extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index dc4e910..36fd420 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -409,9 +409,10 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
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
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 8c5e043..b52376d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -706,7 +706,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
 			return -EEXIST;
 
-		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm);
+		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, addr);
 		if (ret)
 			return ret;
 
