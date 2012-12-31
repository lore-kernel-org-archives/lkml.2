Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab2LaRwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 12:52:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab2LaRwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 12:52:35 -0500
Date: Mon, 31 Dec 2012 18:52:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] uprobes: Turn add_utask() into get_utask()
Message-ID: <20121231175220.GA32098@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231175150.GA32066@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename add_utask() into get_utask() and change it to allocate on
demand to simplify the caller. Like get_xol_area() it will have
more users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ef81162..b09b3ba 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1290,23 +1290,18 @@ void uprobe_copy_process(struct task_struct *t)
 }
 
 /*
- * Allocate a uprobe_task object for the task.
- * Called when the thread hits a breakpoint for the first time.
+ * Allocate a uprobe_task object for the task if if necessary.
+ * Called when the thread hits a breakpoint.
  *
  * Returns:
  * - pointer to new uprobe_task on success
  * - NULL otherwise
  */
-static struct uprobe_task *add_utask(void)
+static struct uprobe_task *get_utask(void)
 {
-	struct uprobe_task *utask;
-
-	utask = kzalloc(sizeof *utask, GFP_KERNEL);
-	if (unlikely(!utask))
-		return NULL;
-
-	current->utask = utask;
-	return utask;
+	if (!current->utask)
+		current->utask = kzalloc(sizeof(struct uprobe_task), GFP_KERNEL);
+	return current->utask;
 }
 
 /* Prepare to single-step probed instruction out of line. */
@@ -1505,13 +1500,9 @@ static void handle_swbp(struct pt_regs *regs)
 	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
 		goto out;
 
-	utask = current->utask;
-	if (!utask) {
-		utask = add_utask();
-		/* Cannot allocate; re-execute the instruction. */
-		if (!utask)
-			goto out;
-	}
+	utask = get_utask();
+	if (!utask)
+		goto out;	/* re-execute the instruction. */
 
 	handler_chain(uprobe, regs);
 	if (can_skip_sstep(uprobe, regs))
-- 
1.5.5.1

