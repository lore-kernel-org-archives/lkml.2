Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab1DUEEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:04:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33685 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1DUEEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:04:10 -0400
Subject: [RFC PATCH v2 4/4] powerpc: use irq_alloc_desc() to manage irq
 allocations
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: tglx@linutronix.de
Date: Wed, 20 Apr 2011 22:04:09 -0600
Message-ID: <20110421040408.30579.6215.stgit@ponder>
In-Reply-To: <20110421040036.30579.53752.stgit@ponder>
References: <20110421040036.30579.53752.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch drops the architecture specific code for managing irq
assignments and uses core code instead.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/kernel/irq.c |   49 ++++++++++++---------------------------------
 1 files changed, 13 insertions(+), 36 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 545e02f66..a36c2f0 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -974,53 +974,29 @@ unsigned int irq_linear_revmap(struct irq_host *host,
 static unsigned int irq_alloc_virt(struct irq_host *host, unsigned int hint)
 {
 	unsigned long flags;
-	unsigned int i, j, found = NO_IRQ;
-	int res;
+	unsigned int found;
 
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
-
-	/* Use hint for 1 interrupt if any */
-	if (hint >= NUM_ISA_INTERRUPTS &&
-	    hint < irq_virq_count && irq_map[hint].host == NULL) {
-		found = hint;
-		goto hint_found;
-	}
-
-	/* Look for a free virq in the allocatable (non-legacy) space */
-	for (i = NUM_ISA_INTERRUPTS, j = 0; i < irq_virq_count; i++) {
-		if (irq_map[i].host == NULL) {
-			found = i;
-			break;
-		}
-	}
+	/*
+	 * Find an unused interrupt.  First, attempt to allocate
+	 * 'hint'.  If that fails, then just allocate any free one.
+	 */
+	found = irq_alloc_desc_at(hint, 0);
+	if (found == NO_IRQ)
+		found = irq_alloc_desc(0);
 	if (found == NO_IRQ) {
-		raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+		pr_debug("irq: -> allocating desc failed\n");
 		return NO_IRQ;
 	}
- hint_found:
+
+	raw_spin_lock_irqsave(&irq_big_lock, flags);
 	irq_map[found].hwirq = host->inval_irq;
 	smp_wmb();
 	irq_map[found].host = host;
 	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
 
-	res = irq_alloc_desc_at(found, 0);
-	if (res != found) {
-		pr_debug("irq: -> allocating desc failed\n");
-		goto error_desc;
-	}
-
 	irq_clear_status_flags(found, IRQ_NOREQUEST);
 
 	return found;
-
- error_desc:
-	raw_spin_lock_irqsave(&irq_big_lock, flags);
-	host = irq_map[found].host;
-	irq_map[found].hwirq = host->inval_irq;
-	smp_wmb();
-	irq_map[found].host = NULL;
-	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
-	return NO_IRQ;
 }
 
 /**
@@ -1041,13 +1017,14 @@ static void irq_free_virt(unsigned int virq)
 		return;
 	}
 
-	irq_free_descs(virq, 1);
 	raw_spin_lock_irqsave(&irq_big_lock, flags);
 	host = irq_map[virq].host;
 	irq_map[virq].hwirq = host->inval_irq;
 	smp_wmb();
 	irq_map[virq].host = NULL;
 	raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+
+	irq_free_descs(virq, 1);
 }
 
 int arch_early_irq_init(void)

