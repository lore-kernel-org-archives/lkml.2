Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2FRI44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:56:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2FRI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:56:55 -0400
Date: Mon, 18 Jun 2012 01:56:12 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-d436615e60c386095dac4a9bf72b08868d2a7564@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154342.GA9598@redhat.com>
References: <20120615154342.GA9598@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Copy_insn() shouldn't depend on mm/vma/
 vaddr
Git-Commit-ID: d436615e60c386095dac4a9bf72b08868d2a7564
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:56:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d436615e60c386095dac4a9bf72b08868d2a7564
Gitweb:     http://git.kernel.org/tip/d436615e60c386095dac4a9bf72b08868d2a7564
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:45 +0200

uprobes: Copy_insn() shouldn't depend on mm/vma/vaddr

1. copy_insn() doesn't need "addr", it can use uprobe->offset.
   Remove this argument.

2. Change copy_insn/__copy_insn to accept "struct file*" instead
   of vma.

copy_insn() is called only once and mm/vma/vaddr are random, it
shouldn't depend on them.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154342.GA9598@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
