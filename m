Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab2LaRxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 12:53:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2LaRwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 12:52:43 -0500
Date: Mon, 31 Dec 2012 18:52:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] uprobes: Do not allocate current->utask unnecessary
Message-ID: <20121231175229.GA32115@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231175150.GA32066@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_swbp() does get_utask() before can_skip_sstep() for no reason,
we do not need ->utask if can_skip_sstep() succeeds.

Move get_utask() to pre_ssout() who actually starts to use it. Move
the initialization of utask->active_uprobe/state as well. This way
the whole initialization is consolidated in pre_ssout().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index bd94d2c..ad1245d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1308,7 +1308,9 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
 	unsigned long xol_vaddr;
 	int err;
 
-	utask = current->utask;
+	utask = get_utask();
+	if (!utask)
+		return -ENOMEM;
 
 	xol_vaddr = xol_get_insn_slot(uprobe);
 	if (!xol_vaddr)
@@ -1323,6 +1325,8 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
 		return err;
 	}
 
+	utask->active_uprobe = uprobe;
+	utask->state = UTASK_SSTEP;
 	return 0;
 }
 
@@ -1474,7 +1478,6 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
  */
 static void handle_swbp(struct pt_regs *regs)
 {
-	struct uprobe_task *utask;
 	struct uprobe *uprobe;
 	unsigned long bp_vaddr;
 	int uninitialized_var(is_swbp);
@@ -1512,19 +1515,12 @@ static void handle_swbp(struct pt_regs *regs)
 	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
 		goto out;
 
-	utask = get_utask();
-	if (!utask)
-		goto out;	/* re-execute the instruction. */
-
 	handler_chain(uprobe, regs);
 	if (can_skip_sstep(uprobe, regs))
 		goto out;
 
-	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
-		utask->active_uprobe = uprobe;
-		utask->state = UTASK_SSTEP;
+	if (!pre_ssout(uprobe, regs, bp_vaddr))
 		return;
-	}
 
 	/* can_skip_sstep() succeeded, or restart if can't singlestep */
 out:
-- 
1.5.5.1

