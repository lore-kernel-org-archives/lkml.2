Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab2INRN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:13:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669Ab2INRNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:13:53 -0400
Date: Fri, 14 Sep 2012 19:15:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] uprobes: Do not leak UTASK_BP_HIT if
	find_active_uprobe() fails
Message-ID: <20120914171551.GA29632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914171513.GA29599@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If handle_swbp()->find_active_uprobe() fails we return with
utask->state = UTASK_BP_HIT.

Change handle_swbp() to reset utask->state at the start. Note
that we do this unconditionally, see the next patch(es).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 26f06a6..760acc1 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1468,6 +1468,10 @@ static void handle_swbp(struct pt_regs *regs)
 	bp_vaddr = uprobe_get_swbp_addr(regs);
 	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 
+	utask = current->utask;
+	if (utask)
+		utask->state = UTASK_RUNNING;
+
 	if (!uprobe) {
 		if (is_swbp > 0) {
 			/* No matching uprobe; signal SIGTRAP. */
@@ -1486,7 +1490,6 @@ static void handle_swbp(struct pt_regs *regs)
 		return;
 	}
 
-	utask = current->utask;
 	if (!utask) {
 		utask = add_utask();
 		/* Cannot allocate; re-execute the instruction. */
-- 
1.5.5.1

