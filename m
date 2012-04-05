Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2DEWV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab2DEWVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:21:25 -0400
Date: Fri, 6 Apr 2012 00:20:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: [PATCH 1/6] uprobes: introduce find_active_uprobe()
Message-ID: <20120405222046.GA19166@redhat.com>
References: <20120405222024.GA19154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405222024.GA19154@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. Move the "find uprobe" code from
handle_swbp() to the new helper, find_active_uprobe().

Note: with or without this change, the find-active-uprobe logic
is not exactly right. We can race with another thread which unmaps
the memory with the valid uprobe before we take mm->mmap_sem. We
can't find this uprobe simply because find_vma() fails. In this
case we wrongly assume that this trap was not caused by uprobe
and send the erroneous SIGTRAP.
---
 kernel/events/uprobes.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 29e881b..3d0a4d6 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1474,21 +1474,12 @@ static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
 	return false;
 }
 
-/*
- * Run handler and ask thread to singlestep.
- * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
- */
-static void handle_swbp(struct pt_regs *regs)
+static struct uprobe *find_active_uprobe(unsigned long bp_vaddr)
 {
+	struct mm_struct *mm = current->mm;
+	struct uprobe *uprobe = NULL;
 	struct vm_area_struct *vma;
-	struct uprobe_task *utask;
-	struct uprobe *uprobe;
-	struct mm_struct *mm;
-	unsigned long bp_vaddr;
 
-	uprobe = NULL;
-	bp_vaddr = uprobe_get_swbp_addr(regs);
-	mm = current->mm;
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, bp_vaddr);
 
@@ -1506,6 +1497,22 @@ static void handle_swbp(struct pt_regs *regs)
 	current->uprobe_srcu_id = -1;
 	up_read(&mm->mmap_sem);
 
+	return uprobe;
+}
+
+/*
+ * Run handler and ask thread to singlestep.
+ * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
+ */
+static void handle_swbp(struct pt_regs *regs)
+{
+	struct uprobe_task *utask;
+	struct uprobe *uprobe;
+	unsigned long bp_vaddr;
+
+	bp_vaddr = uprobe_get_swbp_addr(regs);
+	uprobe = find_active_uprobe(bp_vaddr);
+
 	if (!uprobe) {
 		/* No matching uprobe; signal SIGTRAP. */
 		send_sig(SIGTRAP, current, 0);
-- 
1.5.5.1


