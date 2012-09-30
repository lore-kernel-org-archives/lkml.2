Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2I3TlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 15:41:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2I3Tkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 15:40:39 -0400
Date: Sun, 30 Sep 2012 21:42:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] uprobes: Do not delete uprobe if uprobe_unregister()
	fails
Message-ID: <20120930194204.GA11326@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120930194119.GA11278@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

delete_uprobe() must not be called if register_for_each_vma(false)
fails to remove all breakpoints, __uprobe_unregister() is correct.
The problem is that register_for_each_vma(false) always returns 0
and thus this logic does not work.

1. Change verify_opcode() to return 0 rather than -EINVAL when
   unregister detects the !is_swbp insn, we can treat this case
   as success and currently unregister paths ignore the error
   code anyway.

2. Change remove_breakpoint() to propagate the error code from
   write_opcode().

3. Change register_for_each_vma(is_register => false) to remove
   as much breakpoints as possible but return non-zero if
   remove_breakpoint() fails at least once.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 3ec114c..6058231 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -203,7 +203,7 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
 			return 0;
 	} else {
 		if (!is_swbp)		/* unregister: was it changed by us? */
-			return -EINVAL;
+			return 0;
 	}
 
 	return 1;
@@ -616,15 +616,15 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	return ret;
 }
 
-static void
+static int
 remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
 {
 	/* can happen if uprobe_register() fails */
 	if (!test_bit(MMF_HAS_UPROBES, &mm->flags))
-		return;
+		return 0;
 
 	set_bit(MMF_RECALC_UPROBES, &mm->flags);
-	set_orig_insn(&uprobe->arch, mm, vaddr);
+	return set_orig_insn(&uprobe->arch, mm, vaddr);
 }
 
 /*
@@ -740,7 +740,7 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		struct mm_struct *mm = info->mm;
 		struct vm_area_struct *vma;
 
-		if (err)
+		if (err && is_register)
 			goto free;
 
 		down_write(&mm->mmap_sem);
@@ -756,7 +756,7 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		if (is_register)
 			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
 		else
-			remove_breakpoint(uprobe, mm, info->vaddr);
+			err |= remove_breakpoint(uprobe, mm, info->vaddr);
 
  unlock:
 		up_write(&mm->mmap_sem);
-- 
1.5.5.1

