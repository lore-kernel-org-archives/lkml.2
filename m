Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0JKVbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:31:24 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:34029 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291Ab0JKVbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:31:22 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net, peterz@infradead.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/1] um: Get rid of __do_IRQ()
Date: Mon, 11 Oct 2010 23:29:35 +0200
Message-Id: <1286832575-21474-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes __do_IRQ() from user mode linux.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.um   |    3 +++
 arch/um/kernel/irq.c |   15 ++++-----------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index ec2b8da..7ad0916 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -147,3 +147,6 @@ config KERNEL_STACK_ORDER
 	  This option determines the size of UML kernel stacks.  They will
 	  be 1 << order pages.  The default is OK unless you're running Valgrind
 	  on UML, in which case, set this to 3.
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index a3f0b04..ea21a87 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -334,7 +334,7 @@ unsigned int do_IRQ(int irq, struct uml_pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs((struct pt_regs *)regs);
 	irq_enter();
-	__do_IRQ(irq);
+	generic_handle_irq(irq);
 	irq_exit();
 	set_irq_regs(old_regs);
 	return 1;
@@ -391,17 +391,10 @@ void __init init_IRQ(void)
 {
 	int i;
 
-	irq_desc[TIMER_IRQ].status = IRQ_DISABLED;
-	irq_desc[TIMER_IRQ].action = NULL;
-	irq_desc[TIMER_IRQ].depth = 1;
-	irq_desc[TIMER_IRQ].chip = &SIGVTALRM_irq_type;
-	enable_irq(TIMER_IRQ);
+	set_irq_chip_and_handler(TIMER_IRQ, &SIGVTALRM_irq_type, handle_edge_irq);
+
 	for (i = 1; i < NR_IRQS; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
-		irq_desc[i].chip = &normal_irq_type;
-		enable_irq(i);
+		set_irq_chip_and_handler(i, &normal_irq_type, handle_edge_irq);
 	}
 }
 
-- 
1.6.6.1

