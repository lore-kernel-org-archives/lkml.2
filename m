Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab0LMSCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:02:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47616 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab0LMSCO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 13:02:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/9] xen: Add support to check if IRQ line is shared with other domains.
Date: Mon, 13 Dec 2010 13:01:38 -0500
Message-Id: <1292263303-31680-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do this via the PHYSDEVOP_irq_status_query support hypervisor call.
We will get a positive value if another domain has binded its
PIRQ to the specified IRQ line.

[v2: Deal with v2.6.37-rc1 rebase fallout]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   13 +++++++++++++
 include/xen/events.h |    3 +++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 96c93e7..690dfad 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1398,6 +1398,19 @@ void xen_poll_irq(int irq)
 	xen_poll_irq_timeout(irq, 0 /* no timeout */);
 }
 
+/* Check whether the IRQ line is shared with other guests. */
+int xen_ignore_irq(int irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+	struct physdev_irq_status_query irq_status = { .irq =
+							info->u.pirq.gsi };
+
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
+		return 0;
+	return !(irq_status.flags & XENIRQSTAT_shared);
+}
+EXPORT_SYMBOL_GPL(xen_ignore_irq);
+
 void xen_irq_resume(void)
 {
 	unsigned int cpu, irq, evtchn;
diff --git a/include/xen/events.h b/include/xen/events.h
index 646dd17..553c664 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -89,4 +89,7 @@ int xen_vector_from_irq(unsigned pirq);
 /* Return gsi allocated to pirq */
 int xen_gsi_from_irq(unsigned pirq);
 
+/* Determine whether to ignore this IRQ if passed to a guest. */
+int xen_ignore_irq(int irq);
+
 #endif	/* _XEN_EVENTS_H */
-- 
1.7.1

