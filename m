Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1DAOov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:44:51 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36641 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab1DAOot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:44:49 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 01 Apr 2011 20:05:07 +0530
Message-Id: <20110401143507.15455.87968.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 2.6.39-rc1-tip 13/26] 13: uprobes: get the breakpoint address.
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
index 10647be..91b808a 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -157,6 +157,7 @@ extern void uprobe_free_utask(struct task_struct *tsk);
 
 struct vm_area_struct;
 extern int uprobe_mmap(struct vm_area_struct *vma);
+extern unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs);
 extern void uprobe_dup_mmap(struct mm_struct *old_mm, struct mm_struct *mm);
 extern void uprobes_free_xol_area(struct mm_struct *mm);
 #else /* CONFIG_UPROBES is not defined */
@@ -179,5 +180,9 @@ static inline int uprobe_mmap(struct vm_area_struct *vma)
 }
 static inline void uprobe_free_utask(struct task_struct *tsk) {}
 static inline void uprobes_free_xol_area(struct mm_struct *mm) {}
+static inline unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs)
+{
+	return 0;
+}
 #endif /* CONFIG_UPROBES */
 #endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 7663d18..dcae6dd 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -1190,6 +1190,17 @@ static void xol_free_insn_slot(struct task_struct *tsk, unsigned long slot_addr)
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
