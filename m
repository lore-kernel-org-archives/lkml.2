Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2INROI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab2INROA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:14:00 -0400
Date: Fri, 14 Sep 2012 19:15:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] uprobes: Fix UPROBE_SKIP_SSTEP checks in handle_swbp()
Message-ID: <20120914171557.GA29642@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914171513.GA29599@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If handle_swbp()->add_utask() fails but UPROBE_SKIP_SSTEP is set,
cleanup_ret: path do not restart the insn, this is wrong. Remove
this check and add the additional label for can_skip_sstep() = T
case.

Note also that UPROBE_SKIP_SSTEP can be false positive, we simply
can not trust it unless arch_uprobe_skip_sstep() was already called.

Also, move another UPROBE_SKIP_SSTEP check before can_skip_sstep()
into this helper, this looks more clean and understandable.

Note: probably we should rename "skip" to "emulate" and I think
that "clear UPROBE_SKIP_SSTEP" should be moved to arch_can_skip.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 9893cba..403d2e0 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1389,10 +1389,11 @@ bool uprobe_deny_signal(void)
  */
 static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
 {
-	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
-		return true;
-
-	uprobe->flags &= ~UPROBE_SKIP_SSTEP;
+	if (uprobe->flags & UPROBE_SKIP_SSTEP) {
+		if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
+			return true;
+		uprobe->flags &= ~UPROBE_SKIP_SSTEP;
+	}
 	return false;
 }
 
@@ -1494,12 +1495,12 @@ static void handle_swbp(struct pt_regs *regs)
 		utask = add_utask();
 		/* Cannot allocate; re-execute the instruction. */
 		if (!utask)
-			goto cleanup_ret;
+			goto restart;
 	}
 
 	handler_chain(uprobe, regs);
-	if (uprobe->flags & UPROBE_SKIP_SSTEP && can_skip_sstep(uprobe, regs))
-		goto cleanup_ret;
+	if (can_skip_sstep(uprobe, regs))
+		goto out;
 
 	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
 		arch_uprobe_enable_step(&uprobe->arch);
@@ -1508,15 +1509,13 @@ static void handle_swbp(struct pt_regs *regs)
 		return;
 	}
 
-cleanup_ret:
-	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
-
-		/*
-		 * cannot singlestep; cannot skip instruction;
-		 * re-execute the instruction.
-		 */
-		instruction_pointer_set(regs, bp_vaddr);
-
+restart:
+	/*
+	 * cannot singlestep; cannot skip instruction;
+	 * re-execute the instruction.
+	 */
+	instruction_pointer_set(regs, bp_vaddr);
+out:
 	put_uprobe(uprobe);
 }
 
-- 
1.5.5.1

