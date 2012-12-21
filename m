Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2LULRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:17:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab2LULQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:16:49 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Anton Arapov <anton@redhat.com>,
        Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/6] uretprobes: trampoline implementation
Date: Fri, 21 Dec 2012 12:16:32 +0100
Message-Id: <1356088596-17858-3-git-send-email-anton@redhat.com>
In-Reply-To: <1356088596-17858-1-git-send-email-anton@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first time a uprobe with return consumer is hit for a process, a
trampoline slot is obtained in the xol_area and initialized with a
breakpoint instruction. This slot is subsequently used by all uretprobes.

Signed-off-by: Anton Arapov <anton@redhat.com>
Signed-off-by: Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index a5db480..68780b6 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -88,6 +88,7 @@ struct xol_area {
 	 * the vma go away, and we must handle that reasonably gracefully.
 	 */
 	unsigned long 		vaddr;		/* Page(s) of instruction slots */
+	unsigned long		rp_trampoline_vaddr; /* address of trampolines */
 };
 
 struct uprobes_state {
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 30f2ebc..f0dbbd0 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1246,6 +1246,44 @@ static void xol_free_insn_slot(struct task_struct *tsk)
 	}
 }
 
+/*
+ * xol_get_trampoline_slot - A trampoline slot is obtained the first
+ * time a uprobe with return consumer is hit for a process. Use one
+ * trampoline slot for all probes pertaining to a process, i.e.
+ * one per xol_area.
+ */
+static unsigned long xol_get_trampoline_slot(void)
+{
+	struct xol_area *area;
+	unsigned long offset;
+	void *vaddr;
+	uprobe_opcode_t bp_insn = UPROBE_SWBP_INSN;
+
+	area = get_xol_area(current->mm);
+	if (!area) {
+		area = xol_alloc_area();
+		if (!area)
+			return 0;
+	}
+
+	if (!area->rp_trampoline_vaddr)
+		area->rp_trampoline_vaddr = xol_take_insn_slot(area);
+
+	/*
+	 * Initialize the slot if rp_trampoline_vaddr points to valid
+	 * instruction slot.
+	 */
+	if (unlikely(!area->rp_trampoline_vaddr))
+		return 0;
+
+	offset = area->rp_trampoline_vaddr & ~PAGE_MASK;
+	vaddr = kmap_atomic(area->page);
+	memcpy(vaddr + offset, &bp_insn, UPROBE_SWBP_INSN_SIZE);
+	kunmap_atomic(vaddr);
+
+	return area->rp_trampoline_vaddr;
+}
+
 /**
  * uprobe_get_swbp_addr - compute address of swbp given post-swbp regs
  * @regs: Reflects the saved state of the task after it has hit a breakpoint
-- 
1.8.0.2

