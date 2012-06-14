Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2FNLHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab2FNLHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:07:06 -0400
Date: Thu, 14 Jun 2012 13:05:50 +0200
From: Anton Arapov <anton@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] uprobes: don't use loff_t for the valid virtual
 address
Message-ID: <20120614110550.GA2738@bandura.brq.redhat.com>
References: <20120613184933.GA13870@redhat.com>
 <20120613185106.GE13878@redhat.com>
 <20120614052430.GA9089@in.ibm.com>
 <20120614083826.GA2964@gmail.com>
 <20120614084300.GC9089@in.ibm.com>
 <20120614105807.GB1881@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614105807.GB1881@bandura.brq.redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

loff_t looks confusing when it is used for the virtual address.
Change map_info and install_breakpoint/remove_breakpoint paths
to use "unsigned long".

The patch doesn't change vma_address(), it can't return "long"
because it is used to verify the mapping. But probably this
needs some cleanups too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Arapov <anton@redhat.com>
---
 arch/x86/include/asm/uprobes.h |    2 +-
 arch/x86/kernel/uprobes.c      |    4 ++--
 kernel/events/uprobes.c        |   26 +++++++++-----------------
 3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index f3971bb..14f0d44 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -48,7 +48,7 @@ struct arch_uprobe_task {
 #endif
 };
 
-extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
+extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
 extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 36fd420..e17b749 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -409,10 +409,10 @@ static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,
  * arch_uprobe_analyze_insn - instruction analysis including validity and fixups.
  * @mm: the probed address space.
  * @arch_uprobe: the probepoint information.
- * @addr: virtual address at which to install the probepoint
+ * @vaddr: virtual address at which to install the probepoint
  * Return 0 on success or a -ve number on error.
  */
-int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
+int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
 	int ret;
 	struct insn insn;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 0e8d28e..a57bb1b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -677,9 +677,8 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
  */
 static int
 install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
-			struct vm_area_struct *vma, loff_t vaddr)
+			struct vm_area_struct *vma, unsigned long vaddr)
 {
-	unsigned long addr;
 	int ret;
 
 	/*
@@ -692,8 +691,6 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	if (!uprobe->consumers)
 		return -EEXIST;
 
-	addr = (unsigned long)vaddr;
-
 	if (!(uprobe->flags & UPROBE_COPY_INSN)) {
 		ret = copy_insn(uprobe, vma->vm_file);
 		if (ret)
@@ -702,7 +699,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
 			return -ENOTSUPP;
 
-		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, addr);
+		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
 		if (ret)
 			return ret;
 
@@ -722,7 +719,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	 * Hence increment before and decrement on failure.
 	 */
 	atomic_inc(&mm->uprobes_state.count);
-	ret = set_swbp(&uprobe->arch, mm, addr);
+	ret = set_swbp(&uprobe->arch, mm, vaddr);
 	if (ret)
 		atomic_dec(&mm->uprobes_state.count);
 
@@ -730,9 +727,9 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 }
 
 static void
-remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, loff_t vaddr)
+remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	if (!set_orig_insn(&uprobe->arch, mm, (unsigned long)vaddr, true))
+	if (!set_orig_insn(&uprobe->arch, mm, vaddr, true))
 		atomic_dec(&mm->uprobes_state.count);
 }
 
@@ -756,7 +753,7 @@ static void delete_uprobe(struct uprobe *uprobe)
 struct map_info {
 	struct map_info *next;
 	struct mm_struct *mm;
-	loff_t vaddr;
+	unsigned long vaddr;
 };
 
 static inline struct map_info *free_map_info(struct map_info *info)
@@ -850,7 +847,6 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 	while (info) {
 		struct mm_struct *mm = info->mm;
 		struct vm_area_struct *vma;
-		loff_t vaddr;
 
 		if (err)
 			goto free;
@@ -860,9 +856,8 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		if (!vma || !valid_vma(vma, is_register))
 			goto unlock;
 
-		vaddr = vma_address(vma, uprobe->offset);
 		if (vma->vm_file->f_mapping->host != uprobe->inode ||
-						vaddr != info->vaddr)
+		    vma_address(vma, uprobe->offset) != info->vaddr)
 			goto unlock;
 
 		if (is_register) {
@@ -1068,10 +1063,8 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	count = 0;
 
 	list_for_each_entry(uprobe, &tmp_list, pending_list) {
-		loff_t vaddr;
-
 		if (!ret) {
-			vaddr = vma_address(vma, uprobe->offset);
+			loff_t vaddr = vma_address(vma, uprobe->offset);
 
 			if (vaddr < vma->vm_start || vaddr >= vma->vm_end) {
 				put_uprobe(uprobe);
@@ -1135,9 +1128,8 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	build_probe_list(inode, &tmp_list);
 
 	list_for_each_entry(uprobe, &tmp_list, pending_list) {
-		loff_t vaddr;
+		loff_t vaddr = vma_address(vma, uprobe->offset);
 
-		vaddr = vma_address(vma, uprobe->offset);
 		if (vaddr >= start && vaddr < end) {
 			/*
 			 * An unregister could have removed the probe before
