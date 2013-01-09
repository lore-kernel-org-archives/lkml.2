Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3AILZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab3AILZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:25:29 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH v2 2/4] uretprobes: trampoline implementation
Date: Wed,  9 Jan 2013 12:24:50 +0100
Message-Id: <1357730692-3928-3-git-send-email-anton@redhat.com>
In-Reply-To: <1357730692-3928-1-git-send-email-anton@redhat.com>
References: <1357730692-3928-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first time a uprobe with return consumer is hit for a process, a
trampoline slot is obtained in the xol_area and initialized with a
breakpoint instruction. This slot is subsequently used by all
uretprobes.

todo:
  unify with xol_take_insn_slot()

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 95d0002..bddfad6 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -91,6 +91,7 @@ struct xol_area {
 	 * the vma go away, and we must handle that reasonably gracefully.
 	 */
 	unsigned long 		vaddr;		/* Page(s) of instruction slots */
+	unsigned long		rp_trampoline_vaddr; /* address of trampolines */
 };
 
 struct uprobes_state {
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 473db3f..0ad2ac3 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1208,6 +1208,39 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 	return xol_vaddr;
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
+	uprobe_opcode_t bp_insn = UPROBE_SWBP_INSN;
+	void *vaddr;
+
+	area = get_xol_area();
+	if (!area)
+		return 0;
+
+	if (!area->rp_trampoline_vaddr)
+		area->rp_trampoline_vaddr = xol_take_insn_slot(area);
+
+	if (unlikely(!area->rp_trampoline_vaddr))
+		return 0;
+
+	offset = area->rp_trampoline_vaddr & ~PAGE_MASK;
+	vaddr = kmap_atomic(area->page);
+	memcpy(vaddr + offset, &bp_insn, UPROBE_SWBP_INSN_SIZE);
+	kunmap_atomic(vaddr);
+
+	flush_dcache_page(area->page);
+
+	return area->rp_trampoline_vaddr;
+}
+
 /*
  * xol_free_insn_slot - If slot was earlier allocated by
  * @xol_get_insn_slot(), make the slot available for
-- 
1.8.0.2

