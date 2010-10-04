Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0JDSN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:13:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31413 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab0JDSN5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:13:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/22] xen: Provide a variant of xen_poll_irq with timeout.
Date: Mon,  4 Oct 2010 14:13:23 -0400
Message-Id: <1286216015-9710-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'xen_poll_irq_timeout' provides a method to pass in
the poll timeout for IRQs if requested. We also export
those two poll functions as Xen PCI fronted uses them.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   17 ++++++++++++-----
 include/xen/events.h |    4 ++++
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 385734f..791932d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1133,7 +1133,7 @@ void xen_clear_irq_pending(int irq)
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
 }
-
+EXPORT_SYMBOL(xen_clear_irq_pending);
 void xen_set_irq_pending(int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
@@ -1153,9 +1153,9 @@ bool xen_test_irq_pending(int irq)
 	return ret;
 }
 
-/* Poll waiting for an irq to become pending.  In the usual case, the
-   irq will be disabled so it won't deliver an interrupt. */
-void xen_poll_irq(int irq)
+/* Poll waiting for an irq to become pending with timeout.  In the usual case,
+ * the irq will be disabled so it won't deliver an interrupt. */
+void xen_poll_irq_timeout(int irq, u64 timeout)
 {
 	evtchn_port_t evtchn = evtchn_from_irq(irq);
 
@@ -1163,13 +1163,20 @@ void xen_poll_irq(int irq)
 		struct sched_poll poll;
 
 		poll.nr_ports = 1;
-		poll.timeout = 0;
+		poll.timeout = timeout;
 		set_xen_guest_handle(poll.ports, &evtchn);
 
 		if (HYPERVISOR_sched_op(SCHEDOP_poll, &poll) != 0)
 			BUG();
 	}
 }
+EXPORT_SYMBOL(xen_poll_irq_timeout);
+/* Poll waiting for an irq to become pending.  In the usual case, the
+ * irq will be disabled so it won't deliver an interrupt. */
+void xen_poll_irq(int irq)
+{
+	xen_poll_irq_timeout(irq, 0 /* no timeout */);
+}
 
 void xen_irq_resume(void)
 {
diff --git a/include/xen/events.h b/include/xen/events.h
index 8227da8..2532f8b 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -53,6 +53,10 @@ bool xen_test_irq_pending(int irq);
    irq will be disabled so it won't deliver an interrupt. */
 void xen_poll_irq(int irq);
 
+/* Poll waiting for an irq to become pending with a timeout.  In the usual case,
+ * the irq will be disabled so it won't deliver an interrupt. */
+void xen_poll_irq_timeout(int irq, u64 timeout);
+
 /* Determine the IRQ which is bound to an event channel */
 unsigned irq_from_evtchn(unsigned int evtchn);
 
-- 
1.7.0.4

