Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2FMSxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:53:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab2FMSxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:53:09 -0400
Date: Wed, 13 Jun 2012 20:51:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] uprobes: don't use loff_t for the valid virtual address
Message-ID: <20120613185106.GE13878@redhat.com>
References: <20120613184933.GA13870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613184933.GA13870@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loff_t looks confusing when it is used for the virtual address.
Change map_info and install_breakpoint/remove_breakpoint paths
to use "unsigned long".

The patch doesn't change vma_address(), it can't return "long"
because it is used to verify the mapping. But probably this
needs some cleanups too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a4dc9fa..773bb37 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -663,9 +663,8 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
  */
 static int
 install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
-			struct vm_area_struct *vma, loff_t vaddr)
+			struct vm_area_struct *vma, unsigned long vaddr)
 {
-	unsigned long addr;
 	int ret;
 
 	/*
@@ -678,8 +677,6 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	if (!uprobe->consumers)
 		return -EEXIST;
 
-	addr = (unsigned long)vaddr;
-
 	if (!(uprobe->flags & UPROBE_COPY_INSN)) {
 		ret = copy_insn(uprobe, vma->vm_file);
 		if (ret)
@@ -708,7 +705,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	 * Hence increment before and decrement on failure.
 	 */
 	atomic_inc(&mm->uprobes_state.count);
-	ret = set_swbp(&uprobe->arch, mm, addr);
+	ret = set_swbp(&uprobe->arch, mm, vaddr);
 	if (ret)
 		atomic_dec(&mm->uprobes_state.count);
 
@@ -716,9 +713,9 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 }
 
 static void
-remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, loff_t vaddr)
+remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	if (!set_orig_insn(&uprobe->arch, mm, (unsigned long)vaddr, true))
+	if (!set_orig_insn(&uprobe->arch, mm, vaddr, true))
 		atomic_dec(&mm->uprobes_state.count);
 }
 
@@ -742,7 +739,7 @@ static void delete_uprobe(struct uprobe *uprobe)
 struct map_info {
 	struct map_info *next;
 	struct mm_struct *mm;
-	loff_t vaddr;
+	unsigned long vaddr;
 };
 
 static inline struct map_info *free_map_info(struct map_info *info)
@@ -836,7 +833,6 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 	while (info) {
 		struct mm_struct *mm = info->mm;
 		struct vm_area_struct *vma;
-		loff_t vaddr;
 
 		if (err)
 			goto free;
@@ -846,9 +842,8 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		if (!vma || !valid_vma(vma, is_register))
 			goto unlock;
 
-		vaddr = vma_address(vma, uprobe->offset);
 		if (vma->vm_file->f_mapping->host != uprobe->inode ||
-						vaddr != info->vaddr)
+		    vma_address(vma, uprobe->offset) != info->vaddr)
 			goto unlock;
 
 		if (is_register) {
@@ -1054,10 +1049,8 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	count = 0;
 
 	list_for_each_entry(uprobe, &tmp_list, pending_list) {
-		loff_t vaddr;
-
 		if (!ret) {
-			vaddr = vma_address(vma, uprobe->offset);
+			loff_t vaddr = vma_address(vma, uprobe->offset);
 
 			if (vaddr < vma->vm_start || vaddr >= vma->vm_end) {
 				put_uprobe(uprobe);
@@ -1121,9 +1114,8 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	build_probe_list(inode, &tmp_list);
 
 	list_for_each_entry(uprobe, &tmp_list, pending_list) {
-		loff_t vaddr;
+		loff_t vaddr = vma_address(vma, uprobe->offset);
 
-		vaddr = vma_address(vma, uprobe->offset);
 		if (vaddr >= start && vaddr < end) {
 			/*
 			 * An unregister could have removed the probe before
-- 
1.5.5.1


