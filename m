Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab2EWRyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:54:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35172 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760654Ab2EWRxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:53:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH 4/4] xen/events: Add WARN_ON when quick lookup found invalid type.
Date: Wed, 23 May 2012 13:47:02 -0400
Message-Id: <1337795222-29946-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the bind_XYZ_to_irq do a quick lookup to see if the
event exists. And if they that value is returned instead of
initialized. This patch adds an extra logic to check that the
type returned is the proper one and we can use it to find
drivers that are doing something naught.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index faae2f9..093851b 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -827,6 +827,9 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 					      handle_edge_irq, "event");
 
 		xen_irq_info_evtchn_init(irq, evtchn);
+	} else {
+		struct irq_info *info = info_for_irq(irq);
+		WARN_ON(info && info->type != IRQT_EVTCHN);
 	}
 
 out:
@@ -862,8 +865,10 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 		xen_irq_info_ipi_init(cpu, irq, evtchn, ipi);
 
 		bind_evtchn_to_cpu(evtchn, cpu);
+	} else {
+		struct irq_info *info = info_for_irq(irq);
+		WARN_ON(info && info->type != IRQT_IPI);
 	}
-
  out:
 	mutex_unlock(&irq_mapping_update_lock);
 	return irq;
@@ -939,8 +944,10 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
 
 		bind_evtchn_to_cpu(evtchn, cpu);
+	} else {
+		struct irq_info *info = info_for_irq(irq);
+		WARN_ON(info && info->type != IRQT_VIRQ);
 	}
-
 out:
 	mutex_unlock(&irq_mapping_update_lock);
 
-- 
1.7.7.5

