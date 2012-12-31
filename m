Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2LaRwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 12:52:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab2LaRwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 12:52:38 -0500
Date: Mon, 31 Dec 2012 18:52:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] uprobes: Do not play with utask in xol_get_insn_slot()
Message-ID: <20121231175223.GA32101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231175150.GA32066@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pre_ssout()->xol_get_insn_slot() path is confusing and buggy. This patch
cleanups the code, the next one fixes the bug.

Change xol_get_insn_slot() to only allocate the slot and do nothing more,
move the initialization of utask->xol_vaddr/vaddr into pre_ssout().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index b09b3ba..2ed6239 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1176,30 +1176,26 @@ static unsigned long xol_take_insn_slot(struct xol_area *area)
 }
 
 /*
- * xol_get_insn_slot - If was not allocated a slot, then
- * allocate a slot.
+ * xol_get_insn_slot - allocate a slot for xol.
  * Returns the allocated slot address or 0.
  */
-static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot_addr)
+static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 {
 	struct xol_area *area;
 	unsigned long offset;
+	unsigned long xol_vaddr;
 	void *vaddr;
 
 	area = get_xol_area();
 	if (!area)
 		return 0;
 
-	current->utask->xol_vaddr = xol_take_insn_slot(area);
-	/*
-	 * Initialize the slot if xol_vaddr points to valid
-	 * instruction slot.
-	 */
-	if (unlikely(!current->utask->xol_vaddr))
+	xol_vaddr = xol_take_insn_slot(area);
+	if (unlikely(!xol_vaddr))
 		return 0;
 
-	current->utask->vaddr = slot_addr;
-	offset = current->utask->xol_vaddr & ~PAGE_MASK;
+	/* Initialize the slot */
+	offset = xol_vaddr & ~PAGE_MASK;
 	vaddr = kmap_atomic(area->page);
 	memcpy(vaddr + offset, uprobe->arch.insn, MAX_UINSN_BYTES);
 	kunmap_atomic(vaddr);
@@ -1209,7 +1205,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot
 	 */
 	flush_dcache_page(area->page);
 
-	return current->utask->xol_vaddr;
+	return xol_vaddr;
 }
 
 /*
@@ -1306,12 +1302,21 @@ static struct uprobe_task *get_utask(void)
 
 /* Prepare to single-step probed instruction out of line. */
 static int
-pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long vaddr)
+pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
 {
-	if (xol_get_insn_slot(uprobe, vaddr) && !arch_uprobe_pre_xol(&uprobe->arch, regs))
-		return 0;
+	struct uprobe_task *utask;
+	unsigned long xol_vaddr;
+
+	utask = current->utask;
+
+	xol_vaddr = xol_get_insn_slot(uprobe);
+	if (!xol_vaddr)
+		return -ENOMEM;
+
+	utask->xol_vaddr = xol_vaddr;
+	utask->vaddr = bp_vaddr;
 
-	return -EFAULT;
+	return arch_uprobe_pre_xol(&uprobe->arch, regs);
 }
 
 /*
-- 
1.5.5.1

