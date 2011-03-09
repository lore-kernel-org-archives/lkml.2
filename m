Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1CIRmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:42:01 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36468 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950Ab1CIRl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:56 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432651"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 14/14] xen: events: propagate irq allocation failure instead of panicking
Date: Wed,  9 Mar 2011 17:41:26 +0000
Message-Id: <1299692486-28634-14-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:55.0586 (UTC) FILETIME=[4854DE20:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running out of IRQs need not be fatal to the machine as a whole.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/xen/events.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 51c6a5b..c6f2a2e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -406,7 +406,7 @@ static void xen_irq_init(unsigned irq)
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
 
-static int xen_allocate_irq_dynamic(void)
+static int __must_check xen_allocate_irq_dynamic(void)
 {
 	int first = 0;
 	int irq;
@@ -425,15 +425,12 @@ static int xen_allocate_irq_dynamic(void)
 
 	irq = irq_alloc_desc_from(first, -1);
 
-	if (irq < 0)
-		panic("No available IRQ to bind to: increase nr_irqs!\n");
-
 	xen_irq_init(irq);
 
 	return irq;
 }
 
-static int xen_allocate_irq_gsi(unsigned gsi)
+static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 {
 	int irq;
 
@@ -452,9 +449,6 @@ static int xen_allocate_irq_gsi(unsigned gsi)
 	else
 		irq = irq_alloc_desc_at(gsi, -1);
 
-	if (irq < 0)
-		panic("Unable to allocate to IRQ%d (%d)\n", gsi, irq);
-
 	xen_irq_init(irq);
 
 	return irq;
@@ -640,6 +634,8 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 	}
 
 	irq = xen_allocate_irq_gsi(gsi);
+	if (irq < 0)
+		goto out;
 
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
 				      handle_level_irq, name);
@@ -771,6 +767,8 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 
 	if (irq == -1) {
 		irq = xen_allocate_irq_dynamic();
+		if (irq == -1)
+			goto out;
 
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
 					      handle_fasteoi_irq, "event");
@@ -778,6 +776,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
 
+out:
 	spin_unlock(&irq_mapping_update_lock);
 
 	return irq;
@@ -829,6 +828,8 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 
 	if (irq == -1) {
 		irq = xen_allocate_irq_dynamic();
+		if (irq == -1)
+			goto out;
 
 		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
 					      handle_percpu_irq, "virq");
@@ -845,6 +846,7 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
 
+out:
 	spin_unlock(&irq_mapping_update_lock);
 
 	return irq;
@@ -897,6 +899,8 @@ int bind_evtchn_to_irqhandler(unsigned int evtchn,
 	int retval;
 
 	irq = bind_evtchn_to_irq(evtchn);
+	if (irq < 0)
+		return irq;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
@@ -915,6 +919,8 @@ int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 	int retval;
 
 	irq = bind_virq_to_irq(virq, cpu);
+	if (irq < 0)
+		return irq;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
-- 
1.5.6.5

