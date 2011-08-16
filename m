Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1HPNR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:17:59 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:59406 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1HPNR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:17:58 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjjUQEnt0KA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 2/3] xen/pv-on-hvm kexec: rebind virqs to existing eventchannel ports
Date: Tue, 16 Aug 2011 15:16:52 +0200
Message-Id: <1313500613-21394-3-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1313500613-21394-1-git-send-email-olaf@aepfle.de>
References: <1313500613-21394-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a kexec boot some virqs such as timer and debugirq were already
registered by the old kernel.  The hypervisor will return -EEXISTS from
the new EVTCHNOP_bind_virq request and the BUG in bind_virq_to_irq()
triggers.  Catch the -EEXISTS error and loop through all possible ports to find
what port belongs to the virq/cpu combo.

v2:
  - use NR_EVENT_CHANNELS instead of private MAX_EVTCHNS

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/xen/events.c |   37 ++++++++++++++++++++++++++++++++-----
 1 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 30df85d..31493e9 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -877,11 +877,32 @@ static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
 	return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
 }
 
+static int find_virq(unsigned int virq, unsigned int cpu)
+{
+	struct evtchn_status status;
+	int port, rc = -ENOENT;
+
+	memset(&status, 0, sizeof(status));
+	for (port = 0; port <= NR_EVENT_CHANNELS; port++) {
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
 
@@ -897,10 +918,16 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 
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
 
-- 
1.7.3.4

