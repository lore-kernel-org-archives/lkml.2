Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2FRJA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:00:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2FRJA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:00:56 -0400
Date: Mon, 18 Jun 2012 02:00:34 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-816c03fbabe64fa09f66fbb64e932081af381415@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, anton@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, anton@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154355.GA9622@redhat.com>
References: <20120615154355.GA9622@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Don'
 t use loff_t for the valid virtual address
Git-Commit-ID: 816c03fbabe64fa09f66fbb64e932081af381415
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 02:00:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  816c03fbabe64fa09f66fbb64e932081af381415
Gitweb:     http://git.kernel.org/tip/816c03fbabe64fa09f66fbb64e932081af381415
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:55 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:48 +0200

uprobes: Don't use loff_t for the valid virtual address

loff_t looks confusing when it is used for the virtual address.
Change map_info and install_breakpoint/remove_breakpoint paths
to use "unsigned long".

The patch doesn't change vma_address(), it can't return "long"
because it is used to verify the mapping. But probably this
needs some cleanups too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Arapov <anton@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154355.GA9622@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7d5c78f..4df84b7 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -664,9 +664,8 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
  */
 static int
 install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
-			struct vm_area_struct *vma, loff_t vaddr)
+			struct vm_area_struct *vma, unsigned long vaddr)
 {
-	unsigned long addr;
 	int ret;
 
 	/*
@@ -679,8 +678,6 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	if (!uprobe->consumers)
 		return -EEXIST;
 
-	addr = (unsigned long)vaddr;
-
 	if (!(uprobe->flags & UPROBE_COPY_INSN)) {
 		ret = copy_insn(uprobe, vma->vm_file);
 		if (ret)
@@ -689,7 +686,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 		if (is_swbp_insn((uprobe_opcode_t *)uprobe->arch.insn))
 			return -ENOTSUPP;
 
-		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, addr);
+		ret = arch_uprobe_analyze_insn(&uprobe->arch, mm, vaddr);
 		if (ret)
 			return ret;
 
@@ -709,7 +706,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	 * Hence increment before and decrement on failure.
 	 */
 	atomic_inc(&mm->uprobes_state.count);
-	ret = set_swbp(&uprobe->arch, mm, addr);
+	ret = set_swbp(&uprobe->arch, mm, vaddr);
 	if (ret)
 		atomic_dec(&mm->uprobes_state.count);
 
@@ -717,9 +714,9 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 }
 
 static void
-remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, loff_t vaddr)
+remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	if (!set_orig_insn(&uprobe->arch, mm, (unsigned long)vaddr, true))
+	if (!set_orig_insn(&uprobe->arch, mm, vaddr, true))
 		atomic_dec(&mm->uprobes_state.count);
 }
 
@@ -743,7 +740,7 @@ static void delete_uprobe(struct uprobe *uprobe)
 struct map_info {
 	struct map_info *next;
 	struct mm_struct *mm;
-	loff_t vaddr;
+	unsigned long vaddr;
 };
 
 static inline struct map_info *free_map_info(struct map_info *info)
@@ -837,7 +834,6 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 	while (info) {
 		struct mm_struct *mm = info->mm;
 		struct vm_area_struct *vma;
-		loff_t vaddr;
 
 		if (err)
 			goto free;
@@ -847,9 +843,8 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		if (!vma || !valid_vma(vma, is_register))
 			goto unlock;
 
-		vaddr = vma_address(vma, uprobe->offset);
 		if (vma->vm_file->f_mapping->host != uprobe->inode ||
-						vaddr != info->vaddr)
+		    vma_address(vma, uprobe->offset) != info->vaddr)
 			goto unlock;
 
 		if (is_register) {
@@ -1055,10 +1050,8 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	count = 0;
 
 	list_for_each_entry(uprobe, &tmp_list, pending_list) {
-		loff_t vaddr;
-
 		if (!ret) {
-			vaddr = vma_address(vma, uprobe->offset);
+			loff_t vaddr = vma_address(vma, uprobe->offset);
 
 			if (vaddr < vma->vm_start || vaddr >= vma->vm_end) {
 				put_uprobe(uprobe);
@@ -1122,9 +1115,8 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	build_probe_list(inode, &tmp_list);
 
 	list_for_each_entry(uprobe, &tmp_list, pending_list) {
-		loff_t vaddr;
+		loff_t vaddr = vma_address(vma, uprobe->offset);
 
-		vaddr = vma_address(vma, uprobe->offset);
 		if (vaddr >= start && vaddr < end) {
 			/*
 			 * An unregister could have removed the probe before
