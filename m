Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1AUW1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:27:00 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:51381 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1AUW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:26:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: sparclinux <sparclinux@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/5] sparc: in handler_irq() rename irq parameter to pil
Date: Fri, 21 Jan 2011 23:26:53 +0100
Message-Id: <1295648816-29516-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20110121222451.GA29468@merkur.ravnborg.org>
References: <20110121222451.GA29468@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic irq support uses "irq" to identify the
virtual irq number. To avoid confusion rename the
argument to handler_irq() to pil to match the
name of the parameter in the PCR register.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc/kernel/irq_32.c    |   20 ++++++++++----------
 arch/sparc/kernel/irq_64.c    |    4 ++--
 arch/sparc/kernel/sun4d_irq.c |   18 +++++++++---------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/kernel/irq_32.c b/arch/sparc/kernel/irq_32.c
index 5ad6e5c..07c3e39 100644
--- a/arch/sparc/kernel/irq_32.c
+++ b/arch/sparc/kernel/irq_32.c
@@ -320,7 +320,7 @@ void unexpected_irq(int irq, void *dev_id, struct pt_regs * regs)
 	panic("bogus interrupt received");
 }
 
-void handler_irq(int irq, struct pt_regs * regs)
+void handler_irq(int pil, struct pt_regs * regs)
 {
 	struct pt_regs *old_regs;
 	struct irqaction * action;
@@ -331,23 +331,23 @@ void handler_irq(int irq, struct pt_regs * regs)
 
 	old_regs = set_irq_regs(regs);
 	irq_enter();
-	disable_pil_irq(irq);
+	disable_pil_irq(pil);
 #ifdef CONFIG_SMP
 	/* Only rotate on lower priority IRQs (scsi, ethernet, etc.). */
-	if((sparc_cpu_model==sun4m) && (irq < 10))
+	if((sparc_cpu_model==sun4m) && (pil < 10))
 		smp4m_irq_rotate(cpu);
 #endif
-	action = sparc_irq[irq].action;
-	sparc_irq[irq].flags |= SPARC_IRQ_INPROGRESS;
-	kstat_cpu(cpu).irqs[irq]++;
+	action = sparc_irq[pil].action;
+	sparc_irq[pil].flags |= SPARC_IRQ_INPROGRESS;
+	kstat_cpu(cpu).irqs[pil]++;
 	do {
 		if (!action || !action->handler)
-			unexpected_irq(irq, NULL, regs);
-		action->handler(irq, action->dev_id);
+			unexpected_irq(pil, NULL, regs);
+		action->handler(pil, action->dev_id);
 		action = action->next;
 	} while (action);
-	sparc_irq[irq].flags &= ~SPARC_IRQ_INPROGRESS;
-	enable_pil_irq(irq);
+	sparc_irq[pil].flags &= ~SPARC_IRQ_INPROGRESS;
+	enable_pil_irq(pil);
 	irq_exit();
 	set_irq_regs(old_regs);
 }
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index ee67dae..d4d1233 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -714,13 +714,13 @@ void ack_bad_irq(unsigned int virt_irq)
 void *hardirq_stack[NR_CPUS];
 void *softirq_stack[NR_CPUS];
 
-void __irq_entry handler_irq(int irq, struct pt_regs *regs)
+void __irq_entry handler_irq(int pil, struct pt_regs *regs)
 {
 	unsigned long pstate, bucket_pa;
 	struct pt_regs *old_regs;
 	void *orig_sp;
 
-	clear_softint(1 << irq);
+	clear_softint(1 << pil);
 
 	old_regs = set_irq_regs(regs);
 	irq_enter();
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index e11b461..3af649e 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -205,28 +205,28 @@ out_unlock:
 
 extern void unexpected_irq(int, void *, struct pt_regs *);
 
-void sun4d_handler_irq(int irq, struct pt_regs * regs)
+void sun4d_handler_irq(int pil, struct pt_regs * regs)
 {
 	struct pt_regs *old_regs;
 	struct irqaction * action;
 	int cpu = smp_processor_id();
 	/* SBUS IRQ level (1 - 7) */
-	int sbusl = pil_to_sbus[irq];
+	int sbusl = pil_to_sbus[pil];
 	
 	/* FIXME: Is this necessary?? */
 	cc_get_ipen();
 	
-	cc_set_iclr(1 << irq);
+	cc_set_iclr(1 << pil);
 	
 	old_regs = set_irq_regs(regs);
 	irq_enter();
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_cpu(cpu).irqs[pil]++;
 	if (!sbusl) {
-		action = *(irq + irq_action);
+		action = *(pil + irq_action);
 		if (!action)
-			unexpected_irq(irq, NULL, regs);
+			unexpected_irq(pil, NULL, regs);
 		do {
-			action->handler(irq, action->dev_id);
+			action->handler(pil, action->dev_id);
 			action = action->next;
 		} while (action);
 	} else {
@@ -251,9 +251,9 @@ void sun4d_handler_irq(int irq, struct pt_regs * regs)
 						action = actionp->action;
 						
 						if (!action)
-							unexpected_irq(irq, NULL, regs);
+							unexpected_irq(pil, NULL, regs);
 						do {
-							action->handler(irq, action->dev_id);
+							action->handler(pil, action->dev_id);
 							action = action->next;
 						} while (action);
 						release_sbi(SBI2DEVID(sbino), slot);
-- 
1.6.0.6

