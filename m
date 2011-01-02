Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1ABHVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:34214 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1ABHVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 031/260] xen: use percpu interrupts for IPIs and VIRQs
Date: Sun,  2 Jan 2011 02:15:27 -0500
Message-Id: <1293952756-15010-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:40.0132 (UTC) FILETIME=[8F2A7840:01CBAA4D]
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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/xen/events.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index cc72dad..6830a4d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -107,6 +107,7 @@ static inline unsigned long *cpu_evtchn_mask(int cpu)
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
 static struct irq_chip xen_dynamic_chip;
+static struct irq_chip xen_percpu_chip;
 
 /* Constructor for packed IRQ information. */
 static struct irq_info mk_unbound_info(void)
@@ -389,8 +390,8 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 		if (irq < 0)
 			goto out;
 
-		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "ipi");
+		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
+					      handle_percpu_irq, "ipi");
 
 		bind_ipi.vcpu = cpu;
 		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_ipi,
@@ -430,8 +431,8 @@ static int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 
 		irq = find_unbound_irq();
 
-		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_level_irq, "virq");
+		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
+					      handle_percpu_irq, "virq");
 
 		evtchn_to_irq[evtchn] = irq;
 		irq_info[irq] = mk_virq_info(evtchn, virq);
@@ -934,6 +935,16 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.retrigger	= retrigger_dynirq,
 };
 
+static struct irq_chip xen_percpu_chip __read_mostly = {
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
-- 
1.7.3.3

