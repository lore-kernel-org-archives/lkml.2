Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1CNNlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:41:11 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38626 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1CNNlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:41:08 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 19:05:22 +0530
Message-Id: <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 2.6.38-rc8-tip 7/20]  7: uprobes: store/restore original instruction.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On the first probe insertion, copy the original instruction and opcode.
If multiple vmas map the same text area corresponding to an inode, we
only need to copy the instruction just once.
The copied instruction is further copied to a designated slot on probe
hit.  Its also used at the time of probe removal to restore the original
instruction.
opcode is used to analyze the instruction and determine the fixups.
Determining fixups at probe hit time would result in doing the same
operation on every probe hit. Hence Instruction analysis using the
opcode is done at probe insertion time.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/uprobes.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 4dbb90f..8730633 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -52,11 +52,12 @@ static int write_opcode(struct task_struct *tsk, struct uprobe * uprobe,
 			unsigned long vaddr, uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
+	struct address_space *mapping;
 	void *vaddr_old, *vaddr_new;
 	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 	pte_t *orig_pte;
-	unsigned long addr;
+	loff_t addr;
 	int ret = -EINVAL;
 
 	/* Read the page with vaddr into memory */
@@ -73,6 +74,18 @@ static int write_opcode(struct task_struct *tsk, struct uprobe * uprobe,
 	if (!valid_vma(vma))
 		goto put_out;
 
+	mapping = uprobe->inode->i_mapping;
+	if (mapping != vma->vm_file->f_mapping)
+		goto put_out;
+
+	addr = vma->vm_start + uprobe->offset;
+	addr -= vma->vm_pgoff << PAGE_SHIFT;
+	if (addr > ULONG_MAX)
+		goto put_out;
+
+	if (vaddr != (unsigned long) addr)
+		goto put_out;
+
 	/* Allocate a page */
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page) {
@@ -91,7 +104,6 @@ static int write_opcode(struct task_struct *tsk, struct uprobe * uprobe,
 
 	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
 	/* poke the new insn in, ASSUMES we don't cross page boundary */
-	addr = vaddr;
 	vaddr &= ~PAGE_MASK;
 	memcpy(vaddr_new + vaddr, &opcode, uprobe_opcode_sz);
 
@@ -435,24 +447,109 @@ static int del_consumer(struct uprobe *uprobe,
 	return ret;
 }
 
+static int __copy_insn(struct address_space *mapping, char *insn,
+			unsigned long nbytes, unsigned long offset)
+{
+	struct page *page;
+	void *vaddr;
+	unsigned long off1;
+	loff_t idx;
+
+	idx = offset >> PAGE_CACHE_SHIFT;
+	off1 = offset &= ~PAGE_MASK;
+	page = grab_cache_page(mapping, (unsigned long)idx);
+	if (!page)
+		return -ENOMEM;
+
+	vaddr = kmap_atomic(page, KM_USER0);
+	memcpy(insn, vaddr + off1, nbytes);
+	kunmap_atomic(vaddr, KM_USER0);
+	unlock_page(page);
+	page_cache_release(page);
+	return 0;
+}
+
+static int copy_insn(struct uprobe *uprobe, unsigned long addr)
+{
+	struct address_space *mapping;
+	int bytes;
+	unsigned long nbytes;
+
+	addr &= ~PAGE_MASK;
+	nbytes = PAGE_SIZE - addr;
+	mapping = uprobe->inode->i_mapping;
+
+	/* Instruction at end of binary; copy only available bytes */
+	if (uprobe->offset + MAX_UINSN_BYTES > uprobe->inode->i_size)
+		bytes = uprobe->inode->i_size - uprobe->offset;
+	else
+		bytes = MAX_UINSN_BYTES;
+
+	/* Instruction at the page-boundary; copy bytes in second page */
+	if (nbytes < bytes) {
+		if (__copy_insn(mapping, uprobe->insn + nbytes,
+				bytes - nbytes, uprobe->offset + nbytes))
+			return -ENOMEM;
+		bytes = nbytes;
+	}
+	return __copy_insn(mapping, uprobe->insn, bytes, uprobe->offset);
+}
+
 static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
 {
-	int ret = 0;
+	struct task_struct *tsk;
+	int ret = -EINVAL;
 
-	/*TODO: install breakpoint */
-	if (!ret)
+	get_task_struct(mm->owner);
+	tsk = mm->owner;
+	if (!tsk)
+		return ret;
+
+	if (!uprobe->copy) {
+		ret = copy_insn(uprobe, mm->uprobes_vaddr);
+		if (ret)
+			goto put_return;
+		if (is_bkpt_insn(uprobe->insn)) {
+			print_insert_fail(tsk, mm->uprobes_vaddr,
+				"breakpoint instruction already exists");
+			ret = -EEXIST;
+			goto put_return;
+		}
+		ret = analyze_insn(tsk, uprobe);
+		if (ret) {
+			print_insert_fail(tsk, mm->uprobes_vaddr,
+					"instruction type cannot be probed");
+			goto put_return;
+		}
+		uprobe->copy = 1;
+	}
+
+	ret = set_bkpt(tsk, uprobe, mm->uprobes_vaddr);
+	if (ret < 0)
+		print_insert_fail(tsk, mm->uprobes_vaddr,
+					"failed to insert bkpt instruction");
+	else
 		atomic_inc(&mm->uprobes_count);
+
+put_return:
+	put_task_struct(tsk);
 	return ret;
 }
 
 static int remove_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
 {
-	int ret = 0;
+	struct task_struct *tsk;
+	int ret;
+
+	get_task_struct(mm->owner);
+	tsk = mm->owner;
+	if (!tsk)
+		return -EINVAL;
 
-	/*TODO: remove breakpoint */
+	ret = set_orig_insn(tsk, uprobe, mm->uprobes_vaddr, true);
 	if (!ret)
 		atomic_dec(&mm->uprobes_count);
-
+	put_task_struct(tsk);
 	return ret;
 }
 
