Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab0HDSUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:20:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55386 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab0HDSUb (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/20] xen: Find an unbound irq number in reverse order (high to low).
Date: Wed,  4 Aug 2010 14:19:04 -0400
Message-Id: <1280945955-14229-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C59AF62.00F3:SCFMA4539814,ss=1,fgs=0
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

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 35718db..cd633fa 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -364,12 +364,16 @@ static int find_unbound_irq(void)
 	struct irq_desc *desc;
 	int start = get_nr_hw_irqs();
 
-	for (irq = start; irq < nr_irqs; irq++)
+	if (start == nr_irqs)
+		goto no_irqs;
+
+	/* nr_irqs is a magic value. Must not use it.*/
+	for (irq = nr_irqs-1; irq > start; irq--)
 		if (irq_info[irq].type == IRQT_UNBOUND)
 			break;
 
-	if (irq == nr_irqs)
-		panic("No available IRQ to bind to: increase nr_irqs!\n");
+	if (irq == start)
+		goto no_irqs;
 
 	desc = irq_to_desc_alloc_node(irq, 0);
 	if (WARN_ON(desc == NULL))
@@ -378,6 +382,9 @@ static int find_unbound_irq(void)
 	dynamic_irq_init(irq);
 
 	return irq;
+
+no_irqs:
+	panic("No available IRQ to bind to: increase nr_irqs!\n");
 }
 
 static bool identity_mapped_irq(unsigned irq)
-- 
1.7.0.1

