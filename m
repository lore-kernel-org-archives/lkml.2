Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab0LMSCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:02:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24458 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab0LMSCj (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 13:02:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/9] xen: implement bind_interdomain_evtchn_to_irqhandler for backend drivers
Date: Mon, 13 Dec 2010 13:01:39 -0500
Message-Id: <1292263303-31680-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: new Xen-internal API

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   38 ++++++++++++++++++++++++++++++++++++++
 include/xen/events.h |    6 ++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 690dfad..95eea13 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -849,6 +849,21 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 	return irq;
 }
 
+static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
+                                          unsigned int remote_port)
+{
+        struct evtchn_bind_interdomain bind_interdomain;
+        int err;
+
+        bind_interdomain.remote_dom  = remote_domain;
+        bind_interdomain.remote_port = remote_port;
+
+        err = HYPERVISOR_event_channel_op(EVTCHNOP_bind_interdomain,
+                                          &bind_interdomain);
+
+        return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
+}
+
 
 int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 {
@@ -944,6 +959,29 @@ int bind_evtchn_to_irqhandler(unsigned int evtchn,
 }
 EXPORT_SYMBOL_GPL(bind_evtchn_to_irqhandler);
 
+int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
+					  unsigned int remote_port,
+					  irq_handler_t handler,
+					  unsigned long irqflags,
+					  const char *devname,
+					  void *dev_id)
+{
+        int irq, retval;
+
+        irq = bind_interdomain_evtchn_to_irq(remote_domain, remote_port);
+        if (irq < 0)
+                return irq;
+
+        retval = request_irq(irq, handler, irqflags, devname, dev_id);
+        if (retval != 0) {
+                unbind_from_irq(irq);
+                return retval;
+        }
+
+        return irq;
+}
+EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irqhandler);
+
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 			    irq_handler_t handler,
 			    unsigned long irqflags, const char *devname, void *dev_id)
diff --git a/include/xen/events.h b/include/xen/events.h
index 553c664..2fe1644 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -23,6 +23,12 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 			   unsigned long irqflags,
 			   const char *devname,
 			   void *dev_id);
+int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
+					  unsigned int remote_port,
+					  irq_handler_t handler,
+					  unsigned long irqflags,
+					  const char *devname,
+					  void *dev_id);
 
 /*
  * Common unbind function for all event sources. Takes IRQ to unbind from.
-- 
1.7.1

