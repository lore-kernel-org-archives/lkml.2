Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab2KWU2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab2KWU2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:28:20 -0500
Date: Fri, 23 Nov 2012 21:28:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] uprobes: Introduce filter_chain()
Message-ID: <20121123202812.GA18897@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123202741.GA18858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new helper filter_chain(). Currently it is only placeholder,
the comment explains what is should do. We will change it later to
consult every consumer to decide whether we need to install the swbp.
Until then it works as if any consumer returns true, this matches the
current behavior.

Change install_breakpoint() to call filter_chain() instead of checking
uprobe->consumers != NULL. We obviously need this, and this equally
closes the race with _unregister().

Change remove_breakpoint() to call this helper too. Currently this is
pointless because remove_breakpoint() is only called when the last
consumer goes away, but we will change this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index e761974..edc47ae 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -614,6 +614,18 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
 	return ret;
 }
 
+static bool filter_chain(struct uprobe *uprobe)
+{
+	/*
+	 * TODO:
+	 *	for_each_consumer(uc)
+	 *		if (uc->filter(...))
+	 *			return true;
+	 *	return false;
+	 */
+	return uprobe->consumers != NULL;
+}
+
 static int
 install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long vaddr)
@@ -624,11 +636,10 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	/*
 	 * If probe is being deleted, unregister thread could be done with
 	 * the vma-rmap-walk through. Adding a probe now can be fatal since
-	 * nobody will be able to cleanup. Also we could be from fork or
-	 * mremap path, where the probe might have already been inserted.
-	 * Hence behave as if probe already existed.
+	 * nobody will be able to cleanup. But in this case filter_chain()
+	 * must return false, all consumers have gone away.
 	 */
-	if (!uprobe->consumers)
+	if (!filter_chain(uprobe))
 		return 0;
 
 	ret = prepare_uprobe(uprobe, vma->vm_file, mm, vaddr);
@@ -655,10 +666,12 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 static int
 remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	/* can happen if uprobe_register() fails */
 	if (!test_bit(MMF_HAS_UPROBES, &mm->flags))
 		return 0;
 
+	if (filter_chain(uprobe))
+		return 0;
+
 	set_bit(MMF_RECALC_UPROBES, &mm->flags);
 	return set_orig_insn(&uprobe->arch, mm, vaddr);
 }
@@ -1382,6 +1395,7 @@ static void mmf_recalc_uprobes(struct mm_struct *mm)
 		 * This is not strictly accurate, we can race with
 		 * uprobe_unregister() and see the already removed
 		 * uprobe if delete_uprobe() was not yet called.
+		 * Or this uprobe can be filtered out.
 		 */
 		if (vma_has_uprobes(vma, vma->vm_start, vma->vm_end))
 			return;
-- 
1.5.5.1

