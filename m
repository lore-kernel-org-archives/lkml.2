Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab0JLPvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:51:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31521 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab0JLPv3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:51:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/23] xen: Find an unbound irq number in reverse order (high to low).
Date: Tue, 12 Oct 2010 11:44:17 -0400
Message-Id: <1286898271-32018-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In earlier Xen Linux kernels, the IRQ mapping was a straight 1:1 and the
find_unbound_irq started looking around 256 for open IRQs and up. IRQs
from 0 to 255 were reserved for PCI devices.  Previous to this patch,
the 'find_unbound_irq'  started looking at get_nr_hw_irqs() number.
For privileged  domain where the ACPI information is available that
returns the upper-bound of what the GSIs. For non-privileged PV domains,
where ACPI is no-existent the get_nr_hw_irqs() reports the IRQ_LEGACY (16).
With PCI passthrough enabled, and with PCI cards that have IRQs pinned
to a higher number than 16 we collide with previously allocated IRQs.
Specifically the PCI IRQs collide with the IPI's for Xen functions
(as they are allocated earlier).
For example:

00:00.11 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	...
	Interrupt: pin A routed to IRQ 18

[root@localhost ~]# cat /proc/interrupts | head
           CPU0       CPU1       CPU2
 16:      38186          0          0   xen-dyn-virq      timer0
 17:        149          0          0   xen-dyn-ipi       spinlock0
 18:        962          0          0   xen-dyn-ipi       resched0

and when the USB controller is loaded, the kernel reports:
IRQ handler type mismatch for IRQ 18
current handler: resched0

One way to fix this is to reverse the logic when looking for un-used
IRQ numbers and start with the highest available number. With that,
we would get:

           CPU0       CPU1       CPU2
... snip ..
292:         35          0          0   xen-dyn-ipi       callfunc0
293:       3992          0          0   xen-dyn-ipi       resched0
294:        224          0          0   xen-dyn-ipi       spinlock0
295:      57183          0          0   xen-dyn-virq      timer0
NMI:          0          0          0   Non-maskable interrupts
.. snip ..

And interrupts for PCI cards are now accessible.

This patch also includes the fix, found by Ian Campbell, titled
"xen: fix off-by-one error in find_unbound_irq."

[v2: Added an explanation in the code]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index e1bd0be..8ae696f 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -370,7 +370,11 @@ static int find_unbound_irq(void)
 	struct irq_desc *desc;
 	int start = get_nr_hw_irqs();
 
-	for (irq = start; irq < nr_irqs; irq++) {
+	if (start == nr_irqs)
+		goto no_irqs;
+
+	/* nr_irqs is a magic value. Must not use it.*/
+	for (irq = nr_irqs-1; irq > start; irq--) {
 		desc = irq_to_desc(irq);
 		/* only 0->15 have init'd desc; handle irq > 16 */
 		if (desc == NULL)
@@ -383,8 +387,8 @@ static int find_unbound_irq(void)
 			break;
 	}
 
-	if (irq == nr_irqs)
-		panic("No available IRQ to bind to: increase nr_irqs!\n");
+	if (irq == start)
+		goto no_irqs;
 
 	desc = irq_to_desc_alloc_node(irq, 0);
 	if (WARN_ON(desc == NULL))
@@ -393,6 +397,9 @@ static int find_unbound_irq(void)
 	dynamic_irq_init_keep_chip_data(irq);
 
 	return irq;
+
+no_irqs:
+	panic("No available IRQ to bind to: increase nr_irqs!\n");
 }
 
 static bool identity_mapped_irq(unsigned irq)
@@ -546,8 +553,15 @@ static int find_irq_by_gsi(unsigned gsi)
 	return -1;
 }
 
-/*
- * Allocate a physical irq, along with a vector.  We don't assign an
+/* xen_allocate_irq might allocate irqs from the top down, as a
+ * consequence don't assume that the irq number returned has a low value
+ * or can be used as a pirq number unless you know otherwise.
+ *
+ * One notable exception is when xen_allocate_irq is called passing an
+ * hardware gsi as argument, in that case the irq number returned
+ * matches the gsi number passed as first argument.
+
+ * Note: We don't assign an
  * event channel until the irq actually started up.  Return an
  * existing irq if we've already got one for the gsi.
  */
-- 
1.7.0.4

