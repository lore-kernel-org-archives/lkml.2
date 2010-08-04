Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab0HDSYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:24:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54645 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0HDSUV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/20] xen: dynamically allocate irq & event structures
Date: Wed,  4 Aug 2010 14:19:01 -0400
Message-Id: <1280945955-14229-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C59AF58.0083:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically allocate the irq_info and evtchn_to_irq arrays, so that
1) the irq_info array scales to the actual number of possible irqs,
and 2) we don't needlessly increase the static size of the kernel
when we aren't running under Xen.

Derived on patch from Mike Travis <travis@sgi.com>.

[Impact: reduce memory usage ]
[v2: Conflict in drivers/xen/events.c: Replaced alloc_bootmen with kcalloc ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index b6de004..ac04ded 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -28,6 +28,7 @@
 #include <linux/string.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
+#include <linux/irqnr.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq.h>
@@ -92,11 +93,9 @@ struct irq_info
 };
 #define PIRQ_NEEDS_EOI	(1 << 0)
 
-static struct irq_info irq_info[NR_IRQS];
+static struct irq_info *irq_info;
 
-static int evtchn_to_irq[NR_EVENT_CHANNELS] = {
-	[0 ... NR_EVENT_CHANNELS-1] = -1
-};
+static int *evtchn_to_irq;
 struct cpu_evtchn_s {
 	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
 };
@@ -514,7 +513,7 @@ static int find_irq_by_gsi(unsigned gsi)
 {
 	int irq;
 
-	for (irq = 0; irq < NR_IRQS; irq++) {
+	for (irq = 0; irq < nr_irqs; irq++) {
 		struct irq_info *info = info_for_irq(irq);
 
 		if (info == NULL || info->type != IRQT_PIRQ)
@@ -1189,7 +1188,12 @@ void __init xen_init_IRQ(void)
 
 	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
 				    GFP_KERNEL);
-	BUG_ON(cpu_evtchn_mask_p == NULL);
+	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
+
+	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
+				    GFP_KERNEL);
+	for (i = 0; i < NR_EVENT_CHANNELS; i++)
+		evtchn_to_irq[i] = -1;
 
 	init_evtchn_cpu_bindings();
 
-- 
1.7.0.1

