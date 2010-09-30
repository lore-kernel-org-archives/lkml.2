Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab0I3XSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:18:50 -0400
Received: from www.tglx.de ([62.245.132.106]:43610 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974Ab0I3XSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:46 -0400
Message-Id: <20100930221743.014571381@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:18:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 46/47] powerpc: Use new irq allocator
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=powerpc-use-new-allocator.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new functions and free the descriptor when the virq is
destroyed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/kernel/irq.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6-tip/arch/powerpc/kernel/irq.c
@@ -676,16 +676,15 @@ void irq_set_virq_count(unsigned int cou
 static int irq_setup_virq(struct irq_host *host, unsigned int virq,
 			    irq_hw_number_t hwirq)
 {
-	struct irq_desc *desc;
+	int res;
 
-	desc = irq_to_desc_alloc_node(virq, 0);
-	if (!desc) {
+	res = irq_alloc_desc_at(virq, 0);
+	if (res != virq) {
 		pr_debug("irq: -> allocating desc failed\n");
 		goto error;
 	}
 
-	/* Clear IRQ_NOREQUEST flag */
-	desc->status &= ~IRQ_NOREQUEST;
+	irq_clear_status_flags(virq, IRQ_NOREQUEST);
 
 	/* map it */
 	smp_wmb();
@@ -694,11 +693,13 @@ static int irq_setup_virq(struct irq_hos
 
 	if (host->ops->map(host, virq, hwirq)) {
 		pr_debug("irq: -> mapping failed, freeing\n");
-		goto error;
+		goto errdesc;
 	}
 
 	return 0;
 
+errdesc:
+	irq_free_descs(virq, 1);
 error:
 	irq_free_virt(virq, 1);
 	return -1;
@@ -877,9 +878,9 @@ void irq_dispose_mapping(unsigned int vi
 	smp_mb();
 	irq_map[virq].hwirq = host->inval_irq;
 
-	/* Set some flags */
-	irq_to_desc(virq)->status |= IRQ_NOREQUEST;
+	irq_set_status_flags(virq, IRQ_NOREQUEST);
 
+	irq_free_descs(virq, 1);
 	/* Free it */
 	irq_free_virt(virq, 1);
 }


