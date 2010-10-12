Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab0JLPwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:52:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31898 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab0JLPv7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:51:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/23] xen: Provide a variant of xen_poll_irq with timeout.
Date: Tue, 12 Oct 2010 11:44:18 -0400
Message-Id: <1286898271-32018-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
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
index 8ae696f..427f2d8 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1140,7 +1140,7 @@ void xen_clear_irq_pending(int irq)
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
 }
-
+EXPORT_SYMBOL(xen_clear_irq_pending);
 void xen_set_irq_pending(int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
@@ -1160,9 +1160,9 @@ bool xen_test_irq_pending(int irq)
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
 
@@ -1170,13 +1170,20 @@ void xen_poll_irq(int irq)
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

