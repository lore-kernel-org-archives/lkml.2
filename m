Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab2FOPps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:45:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab2FOPpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:45:45 -0400
Date: Fri, 15 Jun 2012 17:43:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] uprobes: copy_insn() shouldn't depend on mm/vma/vaddr
Message-ID: <20120615154342.GA9598@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615154241.GA9524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. copy_insn() doesn't need "addr", it can use uprobe->offset.
   Remove this argument.

2. Change copy_insn/__copy_insn to accept "struct file*" instead
   of vma.

copy_insn() is called only once and mm/vma/vaddr are random, it
shouldn't depend on them.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/events/uprobes.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2671d9a..08ef566 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -591,10 +591,9 @@ static bool consumer_del(struct uprobe *uprobe, struct uprobe_consumer *uc)
 }
 
 static int
-__copy_insn(struct address_space *mapping, struct vm_area_struct *vma, char *insn,
+__copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 			unsigned long nbytes, unsigned long offset)
 {
-	struct file *filp = vma->vm_file;
 	struct page *page;
 	void *vaddr;
 	unsigned long off1;
@@ -625,15 +624,13 @@ __copy_insn(struct address_space *mapping, struct vm_area_struct *vma, char *ins
 	return 0;
 }
 
-static int
-copy_insn(struct uprobe *uprobe, struct vm_area_struct *vma, unsigned long addr)
+static int copy_insn(struct uprobe *uprobe, struct file *filp)
 {
 	struct address_space *mapping;
 	unsigned long nbytes;
 	int bytes;
 
-	addr &= ~PAGE_MASK;
-	nbytes = PAGE_SIZE - addr;
+	nbytes = PAGE_SIZE - (uprobe->offset & ~PAGE_MASK);
 	mapping = uprobe->inode->i_mapping;
 
 	/* Instruction at end of binary; copy only available bytes */
@@ -644,13 +641,13 @@ copy_insn(struct uprobe *uprobe, struct vm_area_struct *vma, unsigned long addr)
 
 	/* Instruction at the page-boundary; copy bytes in second page */
 	if (nbytes < bytes) {
-		if (__copy_insn(mapping, vma, uprobe->arch.insn + nbytes,
+		if (__copy_insn(mapping, filp, uprobe->arch.insn + nbytes,
 				bytes - nbytes, uprobe->offset + nbytes))
 			return -ENOMEM;
 
 		bytes = nbytes;
 	}
-	return __copy_insn(mapping, vma, uprobe->arch.insn, bytes, uprobe->offset);
+	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
 }
 
 /*
@@ -696,7 +693,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	addr = (unsigned long)vaddr;
 
 	if (!(uprobe->flags & UPROBE_COPY_INSN)) {
-		ret = copy_insn(uprobe, vma, addr);
+		ret = copy_insn(uprobe, vma->vm_file);
 		if (ret)
 			return ret;
 
-- 
1.5.5.1

