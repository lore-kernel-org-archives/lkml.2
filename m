Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1AUW1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:27:48 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:51393 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab1AUW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:26:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: sparclinux <sparclinux@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5/5] sparc64: use up-to-data genirq functions
Date: Fri, 21 Jan 2011 23:26:56 +0100
Message-Id: <1295648816-29516-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20110121222451.GA29468@merkur.ravnborg.org>
References: <20110121222451.GA29468@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop all uses of deprecated genirq features

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc/Kconfig         |    2 +
 arch/sparc/kernel/irq_64.c |  119 ++++++++++++++++++++++----------------------
 2 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 45d9c87..7990a3c 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -50,6 +50,8 @@ config SPARC64
 	select RTC_DRV_STARFIRE
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index b07fc79..f356e4c 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -275,16 +275,15 @@ static int irq_choose_cpu(unsigned int virt_irq, const struct cpumask *affinity)
 	real_hard_smp_processor_id()
 #endif
 
-static void sun4u_irq_enable(unsigned int virt_irq)
+static void sun4u_irq_enable(struct irq_data *data)
 {
-	struct irq_handler_data *handler_data = get_irq_data(virt_irq);
+	struct irq_handler_data *handler_data = data->handler_data;
 
 	if (likely(handler_data)) {
 		unsigned long cpuid, imap, val;
 		unsigned int tid;
 
-		cpuid = irq_choose_cpu(virt_irq,
-				       irq_desc[virt_irq].irq_data.affinity);
+		cpuid = irq_choose_cpu(data->irq, data->affinity);
 		imap = handler_data->imap;
 
 		tid = sun4u_compute_tid(imap, cpuid);
@@ -298,16 +297,16 @@ static void sun4u_irq_enable(unsigned int virt_irq)
 	}
 }
 
-static int sun4u_set_affinity(unsigned int virt_irq,
-			       const struct cpumask *mask)
+static int sun4u_set_affinity(struct irq_data *data,
+			       const struct cpumask *mask, bool force)
 {
-	struct irq_handler_data *handler_data = get_irq_data(virt_irq);
+	struct irq_handler_data *handler_data = data->handler_data;
 
 	if (likely(handler_data)) {
 		unsigned long cpuid, imap, val;
 		unsigned int tid;
 
-		cpuid = irq_choose_cpu(virt_irq, mask);
+		cpuid = irq_choose_cpu(data->irq, mask);
 		imap = handler_data->imap;
 
 		tid = sun4u_compute_tid(imap, cpuid);
@@ -340,14 +339,14 @@ static int sun4u_set_affinity(unsigned int virt_irq,
  * sees that, it also hooks up a default ->shutdown method which
  * invokes ->mask() which we do not want.  See irq_chip_set_defaults().
  */
-static void sun4u_irq_disable(unsigned int virt_irq)
+static void sun4u_irq_disable(struct irq_data *data)
 {
 }
 
-static void sun4u_irq_eoi(unsigned int virt_irq)
+static void sun4u_irq_eoi(struct irq_data *data)
 {
-	struct irq_handler_data *handler_data = get_irq_data(virt_irq);
-	struct irq_desc *desc = irq_desc + virt_irq;
+	struct irq_handler_data *handler_data = data->handler_data;
+	struct irq_desc *desc = irq_desc + data->irq;
 
 	if (unlikely(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		return;
@@ -356,11 +355,10 @@ static void sun4u_irq_eoi(unsigned int virt_irq)
 		upa_writeq(ICLR_IDLE, handler_data->iclr);
 }
 
-static void sun4v_irq_enable(unsigned int virt_irq)
+static void sun4v_irq_enable(struct irq_data *data)
 {
-	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
-	unsigned long cpuid = irq_choose_cpu(virt_irq,
-					     irq_desc[virt_irq].irq_data.affinity);
+	unsigned int ino = virt_irq_table[data->irq].dev_ino;
+	unsigned long cpuid = irq_choose_cpu(data->irq, data->affinity);
 	int err;
 
 	err = sun4v_intr_settarget(ino, cpuid);
@@ -377,11 +375,11 @@ static void sun4v_irq_enable(unsigned int virt_irq)
 		       ino, err);
 }
 
-static int sun4v_set_affinity(unsigned int virt_irq,
-			       const struct cpumask *mask)
+static int sun4v_set_affinity(struct irq_data *data,
+			       const struct cpumask *mask, bool force)
 {
-	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
-	unsigned long cpuid = irq_choose_cpu(virt_irq, mask);
+	unsigned int ino = virt_irq_table[data->irq].dev_ino;
+	unsigned long cpuid = irq_choose_cpu(data->irq, mask);
 	int err;
 
 	err = sun4v_intr_settarget(ino, cpuid);
@@ -392,9 +390,9 @@ static int sun4v_set_affinity(unsigned int virt_irq,
 	return 0;
 }
 
-static void sun4v_irq_disable(unsigned int virt_irq)
+static void sun4v_irq_disable(struct irq_data *data)
 {
-	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
+	unsigned int ino = virt_irq_table[data->irq].dev_ino;
 	int err;
 
 	err = sun4v_intr_setenabled(ino, HV_INTR_DISABLED);
@@ -403,10 +401,10 @@ static void sun4v_irq_disable(unsigned int virt_irq)
 		       "err(%d)\n", ino, err);
 }
 
-static void sun4v_irq_eoi(unsigned int virt_irq)
+static void sun4v_irq_eoi(struct irq_data *data)
 {
-	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
-	struct irq_desc *desc = irq_desc + virt_irq;
+	unsigned int ino = virt_irq_table[data->irq].dev_ino;
+	struct irq_desc *desc = irq_desc + data->irq;
 	int err;
 
 	if (unlikely(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
@@ -418,15 +416,15 @@ static void sun4v_irq_eoi(unsigned int virt_irq)
 		       "err(%d)\n", ino, err);
 }
 
-static void sun4v_virq_enable(unsigned int virt_irq)
+static void sun4v_virq_enable(struct irq_data *data)
 {
 	unsigned long cpuid, dev_handle, dev_ino;
 	int err;
 
-	cpuid = irq_choose_cpu(virt_irq, irq_desc[virt_irq].irq_data.affinity);
+	cpuid = irq_choose_cpu(data->irq, data->affinity);
 
-	dev_handle = virt_irq_table[virt_irq].dev_handle;
-	dev_ino = virt_irq_table[virt_irq].dev_ino;
+	dev_handle = virt_irq_table[data->irq].dev_handle;
+	dev_ino = virt_irq_table[data->irq].dev_ino;
 
 	err = sun4v_vintr_set_target(dev_handle, dev_ino, cpuid);
 	if (err != HV_EOK)
@@ -447,16 +445,16 @@ static void sun4v_virq_enable(unsigned int virt_irq)
 		       dev_handle, dev_ino, err);
 }
 
-static int sun4v_virt_set_affinity(unsigned int virt_irq,
-				    const struct cpumask *mask)
+static int sun4v_virt_set_affinity(struct irq_data *data,
+				    const struct cpumask *mask, bool force)
 {
 	unsigned long cpuid, dev_handle, dev_ino;
 	int err;
 
-	cpuid = irq_choose_cpu(virt_irq, mask);
+	cpuid = irq_choose_cpu(data->irq, mask);
 
-	dev_handle = virt_irq_table[virt_irq].dev_handle;
-	dev_ino = virt_irq_table[virt_irq].dev_ino;
+	dev_handle = virt_irq_table[data->irq].dev_handle;
+	dev_ino = virt_irq_table[data->irq].dev_ino;
 
 	err = sun4v_vintr_set_target(dev_handle, dev_ino, cpuid);
 	if (err != HV_EOK)
@@ -467,13 +465,13 @@ static int sun4v_virt_set_affinity(unsigned int virt_irq,
 	return 0;
 }
 
-static void sun4v_virq_disable(unsigned int virt_irq)
+static void sun4v_virq_disable(struct irq_data *data)
 {
 	unsigned long dev_handle, dev_ino;
 	int err;
 
-	dev_handle = virt_irq_table[virt_irq].dev_handle;
-	dev_ino = virt_irq_table[virt_irq].dev_ino;
+	dev_handle = virt_irq_table[data->irq].dev_handle;
+	dev_ino = virt_irq_table[data->irq].dev_ino;
 
 	err = sun4v_vintr_set_valid(dev_handle, dev_ino,
 				    HV_INTR_DISABLED);
@@ -483,17 +481,17 @@ static void sun4v_virq_disable(unsigned int virt_irq)
 		       dev_handle, dev_ino, err);
 }
 
-static void sun4v_virq_eoi(unsigned int virt_irq)
+static void sun4v_virq_eoi(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_desc + virt_irq;
+	struct irq_desc *desc = irq_desc + data->irq;
 	unsigned long dev_handle, dev_ino;
 	int err;
 
 	if (unlikely(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		return;
 
-	dev_handle = virt_irq_table[virt_irq].dev_handle;
-	dev_ino = virt_irq_table[virt_irq].dev_ino;
+	dev_handle = virt_irq_table[data->irq].dev_handle;
+	dev_ino = virt_irq_table[data->irq].dev_ino;
 
 	err = sun4v_vintr_set_state(dev_handle, dev_ino,
 				    HV_INTR_STATE_IDLE);
@@ -504,27 +502,27 @@ static void sun4v_virq_eoi(unsigned int virt_irq)
 }
 
 static struct irq_chip sun4u_irq = {
-	.name		= "sun4u",
-	.enable		= sun4u_irq_enable,
-	.disable	= sun4u_irq_disable,
-	.eoi		= sun4u_irq_eoi,
-	.set_affinity	= sun4u_set_affinity,
+	.name			= "sun4u",
+	.irq_enable		= sun4u_irq_enable,
+	.irq_disable		= sun4u_irq_disable,
+	.irq_eoi		= sun4u_irq_eoi,
+	.irq_set_affinity	= sun4u_set_affinity,
 };
 
 static struct irq_chip sun4v_irq = {
-	.name		= "sun4v",
-	.enable		= sun4v_irq_enable,
-	.disable	= sun4v_irq_disable,
-	.eoi		= sun4v_irq_eoi,
-	.set_affinity	= sun4v_set_affinity,
+	.name			= "sun4v",
+	.irq_enable		= sun4v_irq_enable,
+	.irq_disable		= sun4v_irq_disable,
+	.irq_eoi		= sun4v_irq_eoi,
+	.irq_set_affinity	= sun4v_set_affinity,
 };
 
 static struct irq_chip sun4v_virq = {
-	.name		= "vsun4v",
-	.enable		= sun4v_virq_enable,
-	.disable	= sun4v_virq_disable,
-	.eoi		= sun4v_virq_eoi,
-	.set_affinity	= sun4v_virt_set_affinity,
+	.name			= "vsun4v",
+	.irq_enable		= sun4v_virq_enable,
+	.irq_disable		= sun4v_virq_disable,
+	.irq_eoi		= sun4v_virq_eoi,
+	.irq_set_affinity	= sun4v_virt_set_affinity,
 };
 
 static void pre_flow_handler(unsigned int virt_irq,
@@ -798,9 +796,12 @@ void fixup_irqs(void)
 		raw_spin_lock_irqsave(&irq_desc[irq].lock, flags);
 		if (irq_desc[irq].action &&
 		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
-			if (irq_desc[irq].irq_data.chip->set_affinity)
-				irq_desc[irq].irq_data.chip->set_affinity(irq,
-					irq_desc[irq].irq_data.affinity);
+			struct irq_data *data = irq_get_irq_data(irq);
+
+			if (data->chip->irq_set_affinity)
+				data->chip->irq_set_affinity(data,
+				                             data->affinity,
+				                             false);
 		}
 		raw_spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	}
-- 
1.6.0.6

