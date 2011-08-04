Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1HDQWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:22:07 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:18153 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab1HDQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:22:04 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll2c7pEOUO
X-RZG-CLASS-ID: mo00
Message-Id: <20110804162054.510901329@aepfle.de>
User-Agent: quilt/0.48-16.4
Date: Thu, 04 Aug 2011 18:20:55 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 2/3] xen/pv-on-hvm kexec: rebind virqs to existing eventchannel ports
References: <20110804162053.723541930@aepfle.de>
Content-Disposition: inline; filename=xen.kexec.find_virq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a kexec boot some virqs such as timer and debugirq were already
registered by the old kernel.  The hypervisor will return -EEXISTS from
the new EVTCHNOP_bind_virq request and the BUG in bind_virq_to_irq()
triggers.  Catch the -EEXISTS error and loop through all possible ports to find
what port belongs to the virq/cpu combo.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/xen/events.c |   40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

Index: linux-3.0/drivers/xen/events.c
===================================================================
--- linux-3.0.orig/drivers/xen/events.c
+++ linux-3.0/drivers/xen/events.c
@@ -877,11 +877,35 @@ static int bind_interdomain_evtchn_to_ir
 	return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
 }
 
+/* BITS_PER_LONG is used in Xen */
+#define MAX_EVTCHNS (64 * 64)
+
+static int find_virq(unsigned int virq, unsigned int cpu)
+{
+	struct evtchn_status status;
+	int port, rc = -ENOENT;
+
+	memset(&status, 0, sizeof(status));
+	for (port = 0; port <= MAX_EVTCHNS; port++) {
+		status.dom = DOMID_SELF;
+		status.port = port;
+		rc = HYPERVISOR_event_channel_op(EVTCHNOP_status, &status);
+		if (rc < 0)
+			continue;
+		if (status.status != EVTCHNSTAT_virq)
+			continue;
+		if (status.u.virq == virq && status.vcpu == cpu) {
+			rc = port;
+			break;
+		}
+	}
+	return rc;
+}
 
 int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 {
 	struct evtchn_bind_virq bind_virq;
-	int evtchn, irq;
+	int evtchn, irq, ret;
 
 	spin_lock(&irq_mapping_update_lock);
 
@@ -897,10 +921,16 @@ int bind_virq_to_irq(unsigned int virq,
 
 		bind_virq.virq = virq;
 		bind_virq.vcpu = cpu;
-		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
-						&bind_virq) != 0)
-			BUG();
-		evtchn = bind_virq.port;
+		ret = HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
+						&bind_virq);
+		if (ret == 0)
+			evtchn = bind_virq.port;
+		else {
+			if (ret == -EEXIST)
+				ret = find_virq(virq, cpu);
+			BUG_ON(ret < 0);
+			evtchn = ret;
+		}
 
 		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
 

