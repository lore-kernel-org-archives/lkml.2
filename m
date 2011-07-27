Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1G0V4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:56:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:57385 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1G0VtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274741"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: tglx@linutronix.de, konrad.wilk@oracle.com, stefan.bader@canonical.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [62/99] xen: Use IRQF_FORCE_RESUME
Message-Id: <20110727214901.6D0012403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 676dc3cf5bc36a9e129a3ad8fe3bd7b2ebf20f5d upstream.

Mark the IRQF_NO_SUSPEND interrupts IRQF_FORCE_RESUME and remove the extra
walk through the interrupt descriptors.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/xen/events.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

Index: linux-2.6.35.y/drivers/xen/events.c
===================================================================
--- linux-2.6.35.y.orig/drivers/xen/events.c
+++ linux-2.6.35.y/drivers/xen/events.c
@@ -537,7 +537,7 @@ int bind_ipi_to_irqhandler(enum ipi_vect
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
@@ -896,7 +896,6 @@ void xen_poll_irq(int irq)
 void xen_irq_resume(void)
 {
 	unsigned int cpu, irq, evtchn;
-	struct irq_desc *desc;
 
 	init_evtchn_cpu_bindings();
 
@@ -915,23 +914,6 @@ void xen_irq_resume(void)
 		restore_cpu_virqs(cpu);
 		restore_cpu_ipis(cpu);
 	}
-
-	/*
-	 * Unmask any IRQF_NO_SUSPEND IRQs which are enabled. These
-	 * are not handled by the IRQ core.
-	 */
-	for_each_irq_desc(irq, desc) {
-		if (!desc->action || !(desc->action->flags & IRQF_NO_SUSPEND))
-			continue;
-		if (desc->status & IRQ_DISABLED)
-			continue;
-
-		evtchn = evtchn_from_irq(irq);
-		if (evtchn == -1)
-			continue;
-
-		unmask_evtchn(evtchn);
-	}
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
