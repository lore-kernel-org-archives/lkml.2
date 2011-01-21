Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1AUW07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:26:59 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:51374 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab1AUW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:26:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: sparclinux <sparclinux@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/5] sparc64: fix direct access to irq_desc
Date: Fri, 21 Jan 2011 23:26:52 +0100
Message-Id: <1295648816-29516-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20110121222451.GA29468@merkur.ravnborg.org>
References: <20110121222451.GA29468@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GENERIC_HARDIRQS_NO_DEPRECATED require us to access data via irq_data
No functional changes as data has same layout due to use of union

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc/kernel/irq_64.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 830d70a..ee67dae 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -190,7 +190,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %9s", irq_desc[i].chip->name);
+		seq_printf(p, " %9s", irq_desc[i].irq_data.chip->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -284,7 +284,7 @@ static void sun4u_irq_enable(unsigned int virt_irq)
 		unsigned int tid;
 
 		cpuid = irq_choose_cpu(virt_irq,
-				       irq_desc[virt_irq].affinity);
+				       irq_desc[virt_irq].irq_data.affinity);
 		imap = data->imap;
 
 		tid = sun4u_compute_tid(imap, cpuid);
@@ -360,7 +360,7 @@ static void sun4v_irq_enable(unsigned int virt_irq)
 {
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 	unsigned long cpuid = irq_choose_cpu(virt_irq,
-					     irq_desc[virt_irq].affinity);
+					     irq_desc[virt_irq].irq_data.affinity);
 	int err;
 
 	err = sun4v_intr_settarget(ino, cpuid);
@@ -423,7 +423,7 @@ static void sun4v_virq_enable(unsigned int virt_irq)
 	unsigned long cpuid, dev_handle, dev_ino;
 	int err;
 
-	cpuid = irq_choose_cpu(virt_irq, irq_desc[virt_irq].affinity);
+	cpuid = irq_choose_cpu(virt_irq, irq_desc[virt_irq].irq_data.affinity);
 
 	dev_handle = virt_irq_table[virt_irq].dev_handle;
 	dev_ino = virt_irq_table[virt_irq].dev_ino;
@@ -798,9 +798,9 @@ void fixup_irqs(void)
 		raw_spin_lock_irqsave(&irq_desc[irq].lock, flags);
 		if (irq_desc[irq].action &&
 		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
-			if (irq_desc[irq].chip->set_affinity)
-				irq_desc[irq].chip->set_affinity(irq,
-					irq_desc[irq].affinity);
+			if (irq_desc[irq].irq_data.chip->set_affinity)
+				irq_desc[irq].irq_data.chip->set_affinity(irq,
+					irq_desc[irq].irq_data.affinity);
 		}
 		raw_spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	}
-- 
1.6.0.6

