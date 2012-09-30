Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab2I3TlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 15:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab2I3Tkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 15:40:52 -0400
Date: Sun, 30 Sep 2012 21:42:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] uprobes: Fix the racy uprobe->flags manipulation
Message-ID: <20120930194227.GA11350@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120930194119.GA11278@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple threads can manipulate uprobe->flags, this is obviously
unsafe. For example mmap can set UPROBE_COPY_INSN while register
tries to set UPROBE_RUN_HANDLER, the latter can also race with
can_skip_sstep() which clears UPROBE_SKIP_SSTEP.

Change this code to use bitops.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 8410388..3d8c815 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -79,11 +79,11 @@ static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
 static atomic_t uprobe_events = ATOMIC_INIT(0);
 
 /* Have a copy of original instruction */
-#define UPROBE_COPY_INSN	0x1
+#define UPROBE_COPY_INSN	0
 /* Dont run handlers when first register/ last unregister in progress*/
-#define UPROBE_RUN_HANDLER	0x2
+#define UPROBE_RUN_HANDLER	1
 /* Can skip singlestep */
-#define UPROBE_SKIP_SSTEP	0x4
+#define UPROBE_SKIP_SSTEP	2
 
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
@@ -94,7 +94,7 @@ struct uprobe {
 	struct uprobe_consumer	*consumers;
 	struct inode		*inode;		/* Also hold a ref to inode */
 	loff_t			offset;
-	int			flags;
+	unsigned long		flags;
 	struct arch_uprobe	arch;
 };
 
@@ -423,7 +423,7 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
 	spin_unlock(&uprobes_treelock);
 
 	/* For now assume that the instruction need not be single-stepped */
-	uprobe->flags |= UPROBE_SKIP_SSTEP;
+	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
 
 	return u;
 }
@@ -466,7 +466,7 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
 
-	if (!(uprobe->flags & UPROBE_RUN_HANDLER))
+	if (!test_bit(UPROBE_RUN_HANDLER, &uprobe->flags))
 		return;
 
 	down_read(&uprobe->consumer_rwsem);
@@ -577,11 +577,11 @@ static int uprobe_copy_insn(struct uprobe *uprobe, struct file *file,
 {
 	int ret = 0;
 
-	if (uprobe->flags & UPROBE_COPY_INSN)
+	if (test_bit(UPROBE_COPY_INSN, &uprobe->flags))
 		return ret;
 
 	mutex_lock(&uprobe->copy_mutex);
-	if (uprobe->flags & UPROBE_COPY_INSN)
+	if (test_bit(UPROBE_COPY_INSN, &uprobe->flags))
 		goto out;
 
 	ret = copy_insn(uprobe, file);
@@ -601,7 +601,7 @@ static int uprobe_copy_insn(struct uprobe *uprobe, struct file *file,
 			UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
 
 	smp_wmb(); /* pairs with rmb() in find_active_uprobe() */
-	uprobe->flags |= UPROBE_COPY_INSN;
+	set_bit(UPROBE_COPY_INSN, &uprobe->flags);
 	ret = 0;
  out:
 	mutex_unlock(&uprobe->copy_mutex);
@@ -852,7 +852,7 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 			uprobe->consumers = NULL;
 			__uprobe_unregister(uprobe);
 		} else {
-			uprobe->flags |= UPROBE_RUN_HANDLER;
+			set_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
 		}
 	}
 
@@ -885,7 +885,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	if (consumer_del(uprobe, uc)) {
 		if (!uprobe->consumers) {
 			__uprobe_unregister(uprobe);
-			uprobe->flags &= ~UPROBE_RUN_HANDLER;
+			clear_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
 		}
 	}
 
@@ -1346,10 +1346,10 @@ bool uprobe_deny_signal(void)
  */
 static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
 {
-	if (uprobe->flags & UPROBE_SKIP_SSTEP) {
+	if (test_bit(UPROBE_SKIP_SSTEP, &uprobe->flags)) {
 		if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
 			return true;
-		uprobe->flags &= ~UPROBE_SKIP_SSTEP;
+		clear_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
 	}
 	return false;
 }
@@ -1428,7 +1428,7 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	 * new and not-yet-analyzed uprobe at the same address, restart.
 	 */
 	smp_rmb(); /* pairs with wmb() in install_breakpoint() */
-	if (uprobe && unlikely(!(uprobe->flags & UPROBE_COPY_INSN))) {
+	if (uprobe && unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags))) {
 		uprobe = NULL;
 		*is_swbp = 0;
 	}
-- 
1.5.5.1

