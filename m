Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281Ab1D1UCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:02:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44596 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474Ab1D1UCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:02:16 -0400
Subject: [PATCH 6/6] powerpc: use irq_alloc_desc() to manage irq allocations
To: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 28 Apr 2011 14:02:14 -0600
Message-ID: <20110428200214.8979.84221.stgit@ponder>
In-Reply-To: <20110428192227.8979.49181.stgit@ponder>
References: <20110428192227.8979.49181.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch drops the architecture specific code for managing irq
assignments and uses core code instead.

*RFC*

This patch is *not* ready for merging.  The locking is messed up where
the irq_map is still used to find out if a mapping is already established,
but irq_alloc_desc() is now called before the irq_map is updated which
creates a race condition.  I've not completely sorted out how to solve
this yet.  The solution may very well be to convert the irq_big_lock
to a mutex (but I'm not sure if anything that sleeps calls the affected
code), and hold the mutex over the entire operation.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/kernel/irq.c |   51 ++++++++++++---------------------------------
 1 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 0fb90ab..e4a6646 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -984,53 +984,29 @@ unsigned int irq_linear_revmap(struct irq_host *host,
 static unsigned int irq_alloc_virt(struct irq_host *host, unsigned int hint)
 {
 	unsigned long flags;
-	unsigned int i, j, found = NO_IRQ;
-	int res;
+	int found;
 
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
-	if (found == NO_IRQ) {
-		raw_spin_unlock_irqrestore(&irq_big_lock, flags);
+	/*
+	 * Find an unused interrupt.  First, attempt to allocate
+	 * 'hint'.  If that fails, then just allocate any free one.
+	 */
+	found = irq_alloc_desc_at(hint, 0);
+	if (found <= NO_IRQ)
+		found = irq_alloc_desc(0);
+	if (found <= NO_IRQ) {
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
@@ -1051,13 +1027,14 @@ static void irq_free_virt(unsigned int virq)
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

