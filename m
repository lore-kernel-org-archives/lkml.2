Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab1D1UIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:08:48 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:63569 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1D1UIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:08:47 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 16:08:47 EDT
Subject: [PATCH 5/6] powerpc: move irq_alloc_descs_at() call into
 irq_alloc_virt()
To: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 28 Apr 2011 14:02:09 -0600
Message-ID: <20110428200209.8979.85021.stgit@ponder>
In-Reply-To: <20110428192227.8979.49181.stgit@ponder>
References: <20110428192227.8979.49181.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a stepping stone to using core code for allocating virqs
instead of the powerpc architecture specific code.  A subsequent patch
will drop the algorithm that searches for a free irq and replaces it
with irq_alloc_desc()

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/kernel/irq.c |   49 ++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 9300e1c..0fb90ab 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -665,16 +665,6 @@ static void irq_free_virt(unsigned int virq);
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
@@ -688,8 +678,6 @@ static int irq_setup_virq(struct irq_host *host, unsigned int virq,
 	return 0;
 
 errdesc:
-	irq_free_descs(virq, 1);
-error:
 	irq_free_virt(virq);
 	return -1;
 }
@@ -754,14 +742,14 @@ unsigned int irq_create_mapping(struct irq_host *host,
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
@@ -867,7 +855,6 @@ void irq_dispose_mapping(unsigned int virq)
 
 	irq_set_status_flags(virq, IRQ_NOREQUEST);
 
-	irq_free_descs(virq, 1);
 	/* Free it */
 	irq_free_virt(virq);
 }
@@ -998,6 +985,7 @@ static unsigned int irq_alloc_virt(struct irq_host *host, unsigned int hint)
 {
 	unsigned long flags;
 	unsigned int i, j, found = NO_IRQ;
+	int res;
 
 	raw_spin_lock_irqsave(&irq_big_lock, flags);
 
@@ -1024,7 +1012,25 @@ static unsigned int irq_alloc_virt(struct irq_host *host, unsigned int hint)
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
@@ -1045,6 +1051,7 @@ static void irq_free_virt(unsigned int virq)
 		return;
 	}
 
+	irq_free_descs(virq, 1);
 	raw_spin_lock_irqsave(&irq_big_lock, flags);
 	host = irq_map[virq].host;
 	irq_map[virq].hwirq = host->inval_irq;

