Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab0HDSUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:20:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55373 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab0HDSUa (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Weidong Han <weidong.han@intel.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 11/20] xen: fix shared irq device passthrough
Date: Wed,  4 Aug 2010 14:19:06 -0400
Message-Id: <1280945955-14229-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C59AF5F.0080:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weidong Han <weidong.han@intel.com>

In driver/xen/events.c, whether bind_pirq is shareable or not is
determined by desc->action is NULL or not. But in __setup_irq,
startup(irq) is invoked before desc->action is assigned with
new action. So desc->action in startup_irq is always NULL, and
bind_pirq is always not shareable. This results in pt_irq_create_bind
failure when passthrough a device which shares irq to other devices.

This patch doesn't use probing_irq to determine if pirq is shareable
or not, instead set shareable flag in irq_info according to trigger
mode in xen_allocate_pirq. Set level triggered interrupts shareable.
Thus use this flag to set bind_pirq flag accordingly.

[v2: arch/x86/xen/pci.c no more, so file skipped]

Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   11 ++++++++---
 include/xen/events.h |    2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 9d85707..78c1525 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -92,6 +92,7 @@ struct irq_info
 	} u;
 };
 #define PIRQ_NEEDS_EOI	(1 << 0)
+#define PIRQ_SHAREABLE	(1 << 1)
 
 static struct irq_info *irq_info;
 
@@ -431,6 +432,7 @@ static unsigned int startup_pirq(unsigned int irq)
 	struct evtchn_bind_pirq bind_pirq;
 	struct irq_info *info = info_for_irq(irq);
 	int evtchn = evtchn_from_irq(irq);
+	int rc;
 
 	BUG_ON(info->type != IRQT_PIRQ);
 
@@ -439,8 +441,10 @@ static unsigned int startup_pirq(unsigned int irq)
 
 	bind_pirq.pirq = irq;
 	/* NB. We are happy to share unless we are probing. */
-	bind_pirq.flags = probing_irq(irq) ? 0 : BIND_PIRQ__WILL_SHARE;
-	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq) != 0) {
+	bind_pirq.flags = info->u.pirq.flags & PIRQ_SHAREABLE ?
+					BIND_PIRQ__WILL_SHARE : 0;
+	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
+	if (rc != 0) {
 		if (!probing_irq(irq))
 			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
 			       irq);
@@ -543,7 +547,7 @@ static int find_irq_by_gsi(unsigned gsi)
  * event channel until the irq actually started up.  Return an
  * existing irq if we've already got one for the gsi.
  */
-int xen_allocate_pirq(unsigned gsi, char *name)
+int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 {
 	int irq;
 	struct physdev_irq irq_op;
@@ -575,6 +579,7 @@ int xen_allocate_pirq(unsigned gsi, char *name)
 	}
 
 	irq_info[irq] = mk_pirq_info(0, gsi, irq_op.vector);
+	irq_info[irq].u.pirq.flags |= shareable ? PIRQ_SHAREABLE : 0;
 
 out:
 	spin_unlock(&irq_mapping_update_lock);
diff --git a/include/xen/events.h b/include/xen/events.h
index 91143b4..20e27c3 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -63,7 +63,7 @@ unsigned irq_from_evtchn(unsigned int evtchn);
 /* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
    GSIs are identity mapped; others are dynamically allocated as
    usual. */
-int xen_allocate_pirq(unsigned gsi, char *name);
+int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
 
 /* Return vector allocated to pirq */
 int xen_vector_from_irq(unsigned pirq);
-- 
1.7.0.1

