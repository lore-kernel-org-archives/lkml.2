Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab1DUEEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:04:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61547 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1DUEEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:04:06 -0400
Subject: [RFC PATCH v2 3/4] powerpc: move irq_alloc_descs_at() call into
 irq_alloc_virt()
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: tglx@linutronix.de
Date: Wed, 20 Apr 2011 22:04:03 -0600
Message-ID: <20110421040403.30579.53879.stgit@ponder>
In-Reply-To: <20110421040036.30579.53752.stgit@ponder>
References: <20110421040036.30579.53752.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a stepping stone to using core code for allocating virqs
instead of the powerpc architecture specific code.  The next patch
will drop the algorithm that searches for a free irq and replaces it
with irq_alloc_desc()

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/kernel/irq.c |   49 ++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index f7811ca..545e02f66 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -653,16 +653,6 @@ static void irq_free_virt(unsigned int virq);
 static int irq_setup_virq(struct irq_host *host, unsigned int virq,
 			    irq_hw_number_t hwirq)
 {
-	int res;
-
-	res = irq_alloc_desc_at(virq, 0);
-	if (res != virq) {
-		pr_debug("irq: -> allocating desc failed\n");
-		goto error;
-	}
-
-	irq_clear_status_flags(virq, IRQ_NOREQUEST);
-
 	/* map it */
 	smp_wmb();
 	irq_map[virq].hwirq = hwirq;
@@ -676,8 +666,6 @@ static int irq_setup_virq(struct irq_host *host, unsigned int virq,
 	return 0;
 
 errdesc:
-	irq_free_descs(virq, 1);
-error:
 	irq_free_virt(virq);
 	return -1;
 }
@@ -742,14 +730,14 @@ unsigned int irq_create_mapping(struct irq_host *host,
 		if (virq == 0 || virq >= NUM_ISA_INTERRUPTS)
 			return NO_IRQ;
 		return virq;
-	} else {
-		/* Allocate a virtual interrupt number */
-		hint = hwirq % irq_virq_count;
-		virq = irq_alloc_virt(host, hint);
-		if (virq == NO_IRQ) {
-			pr_debug("irq: -> virq allocation failed\n");
-			return NO_IRQ;
-		}
+	}
+
+	/* Allocate a virtual interrupt number */
+	hint = hwirq % irq_virq_count;
+	virq = irq_alloc_virt(host, hint);
+	if (virq == NO_IRQ) {
+		pr_debug("irq: -> virq allocation failed\n");
+		return NO_IRQ;
 	}
 
 	if (irq_setup_virq(host, virq, hwirq))
@@ -857,7 +845,6 @@ void irq_dispose_mapping(unsigned int virq)
 
 	irq_set_status_flags(virq, IRQ_NOREQUEST);
 
-	irq_free_descs(virq, 1);
 	/* Free it */
 	irq_free_virt(virq);
 }
@@ -988,6 +975,7 @@ static unsigned int irq_alloc_virt(struct irq_host *host, unsigned int hint)
 {
 	unsigned long flags;
 	unsigned int i, j, found = NO_IRQ;
+	int res;
 
 	raw_spin_lock_irqsave(&irq_big_lock, flags);
 
@@ -1014,7 +1002,25 @@ static unsigned int irq_alloc_virt(struct irq_host *host, unsigned int hint)
 	smp_wmb();
 	irq_map[found].host = host;
 	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+
+	res = irq_alloc_desc_at(found, 0);
+	if (res != found) {
+		pr_debug("irq: -> allocating desc failed\n");
+		goto error_desc;
+	}
+
+	irq_clear_status_flags(found, IRQ_NOREQUEST);
+
 	return found;
+
+ error_desc:
+	raw_spin_lock_irqsave(&irq_big_lock, flags);
+	host = irq_map[found].host;
+	irq_map[found].hwirq = host->inval_irq;
+	smp_wmb();
+	irq_map[found].host = NULL;
+	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+	return NO_IRQ;
 }
 
 /**
@@ -1035,6 +1041,7 @@ static void irq_free_virt(unsigned int virq)
 		return;
 	}
 
+	irq_free_descs(virq, 1);
 	raw_spin_lock_irqsave(&irq_big_lock, flags);
 	host = irq_map[virq].host;
 	irq_map[virq].hwirq = host->inval_irq;

