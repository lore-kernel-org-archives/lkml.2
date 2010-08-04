Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab0HDSVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:21:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56277 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab0HDSUj (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/20] xen: identity map gsi->irqs
Date: Wed,  4 Aug 2010 14:19:00 -0400
Message-Id: <1280945955-14229-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C59AF69.0276:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: preserve compat with native

Reserve the lower irq range for use for hardware interrupts so we
can identity-map them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 288077f..b6de004 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -32,6 +32,7 @@
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/io_apic.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -41,9 +42,6 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
-/* Leave low irqs free for identity mapping */
-#define LEGACY_IRQS	16
-
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -345,12 +343,24 @@ static void unmask_evtchn(int port)
 	put_cpu();
 }
 
+static int get_nr_hw_irqs(void)
+{
+	int ret = 1;
+
+#ifdef CONFIG_X86_IO_APIC
+	ret = get_nr_irqs_gsi();
+#endif
+
+	return ret;
+}
+
 static int find_unbound_irq(void)
 {
 	int irq;
 	struct irq_desc *desc;
+	int start = get_nr_hw_irqs();
 
-	for (irq = LEGACY_IRQS; irq < nr_irqs; irq++)
+	for (irq = start; irq < nr_irqs; irq++)
 		if (irq_info[irq].type == IRQT_UNBOUND)
 			break;
 
@@ -368,8 +378,8 @@ static int find_unbound_irq(void)
 
 static bool identity_mapped_irq(unsigned irq)
 {
-	/* only identity map legacy irqs */
-	return irq < LEGACY_IRQS;
+	/* identity map all the hardware irqs */
+	return irq < get_nr_hw_irqs();
 }
 
 static void pirq_unmask_notify(int irq)
@@ -538,6 +548,7 @@ int xen_allocate_pirq(unsigned gsi)
 
 	if (identity_mapped_irq(gsi)) {
 		irq = gsi;
+		irq_to_desc_alloc_node(irq, 0);
 		dynamic_irq_init(irq);
 	} else
 		irq = find_unbound_irq();
-- 
1.7.0.1

