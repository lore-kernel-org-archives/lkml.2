Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0IRTCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:25 -0400
Received: from kroah.org ([198.145.64.141]:51075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab0IRTBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:10 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.063075802@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [003/123] xen: use percpu interrupts for IPIs and VIRQs
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=xen-use-percpu-interrupts-for-ipis-and-virqs.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit aaca49642b92c8a57d3ca5029a5a94019c7af69f upstream.

IPIs and VIRQs are inherently per-cpu event types, so treat them as such:
 - use a specific percpu irq_chip implementation, and
 - handle them with handle_percpu_irq

This makes the path for delivering these interrupts more efficient
(no masking/unmasking, no locks), and it avoid problems with attempts
to migrate them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/events.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -106,6 +106,7 @@ static inline unsigned long *cpu_evtchn_
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
 static struct irq_chip xen_dynamic_chip;
+static struct irq_chip xen_percpu_chip;
 
 /* Constructor for packed IRQ information. */
 static struct irq_info mk_unbound_info(void)
@@ -388,8 +389,8 @@ static int bind_ipi_to_irq(unsigned int
 		if (irq < 0)
 			goto out;
 
-		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "ipi");
+		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
+					      handle_percpu_irq, "ipi");
 
 		bind_ipi.vcpu = cpu;
 		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_ipi,
@@ -429,8 +430,8 @@ static int bind_virq_to_irq(unsigned int
 
 		irq = find_unbound_irq();
 
-		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "virq");
+		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
+					      handle_percpu_irq, "virq");
 
 		evtchn_to_irq[evtchn] = irq;
 		irq_info[irq] = mk_virq_info(evtchn, virq);
@@ -929,6 +930,16 @@ static struct irq_chip xen_dynamic_chip
 	.retrigger	= retrigger_dynirq,
 };
 
+static struct irq_chip en_percpu_chip __read_mostly = {
+	.name		= "xen-percpu",
+
+	.disable	= disable_dynirq,
+	.mask		= disable_dynirq,
+	.unmask		= enable_dynirq,
+
+	.ack		= ack_dynirq,
+};
+
 void __init xen_init_IRQ(void)
 {
 	int i;


