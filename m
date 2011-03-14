Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1CNNmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:42:09 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59810 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab1CNNmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:42:06 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 19:06:20 +0530
Message-Id: <20110314133620.27435.24071.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 2.6.38-rc8-tip 12/20] 12: uprobes: get the breakpoint address.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On a breakpoint hit, return the address where the breakpoint was hit.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---
 include/linux/uprobes.h |    5 +++++
 kernel/uprobes.c        |   11 +++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index c42975b..aef55de 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -146,6 +146,7 @@ extern void uprobe_free_utask(struct task_struct *tsk);
 
 struct vm_area_struct;
 extern void uprobe_mmap(struct vm_area_struct *vma);
+extern unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs);
 extern void uprobe_dup_mmap(struct mm_struct *old_mm, struct mm_struct *mm);
 extern void uprobes_free_xol_area(struct mm_struct *mm);
 #else /* CONFIG_UPROBES is not defined */
@@ -165,5 +166,9 @@ static inline void uprobe_dup_mmap(struct mm_struct *old_mm,
 static inline void uprobe_free_utask(struct task_struct *tsk) {}
 static inline void uprobe_mmap(struct vm_area_struct *vma) { }
 static inline void uprobes_free_xol_area(struct mm_struct *mm) {}
+static inline unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs)
+{
+	return 0;
+}
 #endif /* CONFIG_UPROBES */
 #endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 9d3d402..307f0cd 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1044,6 +1044,17 @@ static void xol_free_insn_slot(struct task_struct *tsk, unsigned long slot_addr)
 						__func__, slot_addr);
 }
 
+/**
+ * uprobes_get_bkpt_addr - compute address of bkpt given post-bkpt regs
+ * @regs: Reflects the saved state of the task after it has hit a breakpoint
+ * instruction.
+ * Return the address of the breakpoint instruction.
+ */
+unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs)
+{
+	return instruction_pointer(regs) - UPROBES_BKPT_INSN_SIZE;
+}
+
 /*
  * Called with no locks held.
  * Called in context of a exiting or a exec-ing thread.
