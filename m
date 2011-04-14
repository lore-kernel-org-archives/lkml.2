Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab1DNPb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:31:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65528 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab1DNPbZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 11:31:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/5] xen/irq: Add support to check if IRQ line is shared with other domains.
Date: Thu, 14 Apr 2011 11:30:12 -0400
Message-Id: <1302795014-13289-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
References: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DA71349.0139:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do this via the PHYSDEVOP_irq_status_query support hypervisor call.
We will get a positive value if another domain has binded its
PIRQ to the specified GSI (IRQ line).

[v2: Deal with v2.6.37-rc1 rebase fallout]
[v3: Deal with stable/irq.cleanup fallout]
[v4: xen_ignore_irq->xen_test_irq_shared]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   12 ++++++++++++
 include/xen/events.h |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index ac0e228..0ac7a14 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1508,6 +1508,18 @@ void xen_poll_irq(int irq)
 	xen_poll_irq_timeout(irq, 0 /* no timeout */);
 }
 
+/* Check whether the IRQ line is shared with other guests. */
+int xen_test_irq_shared(int irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+	struct physdev_irq_status_query irq_status = { .irq = info->u.pirq.pirq };
+
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
+		return 0;
+	return !(irq_status.flags & XENIRQSTAT_shared);
+}
+EXPORT_SYMBOL_GPL(xen_test_irq_shared);
+
 void xen_irq_resume(void)
 {
 	unsigned int cpu, evtchn;
diff --git a/include/xen/events.h b/include/xen/events.h
index 9aecc0b..932e540 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -95,4 +95,7 @@ int xen_destroy_irq(int irq);
 /* Return irq from pirq */
 int xen_irq_from_pirq(unsigned pirq);
 
+/* Determine whether to ignore this IRQ if it is passed to a guest. */
+int xen_test_irq_shared(int irq);
+
 #endif	/* _XEN_EVENTS_H */
-- 
1.7.1

