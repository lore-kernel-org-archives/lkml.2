Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab2EXSez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:34:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36838 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2EXSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:34:54 -0400
Date: Thu, 24 May 2012 14:28:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/events: Add WARN_ON when quick
 lookup found invalid type.
Message-ID: <20120524182817.GM24934@phenom.dumpdata.com>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
 <1337795222-29946-5-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205241154150.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205241154150.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:58:11AM +0100, Stefano Stabellini wrote:
> On Wed, 23 May 2012, Konrad Rzeszutek Wilk wrote:
> > All of the bind_XYZ_to_irq do a quick lookup to see if the
> > event exists. And if they that value is returned instead of
> 
>                            ^

... snip. How about this:

>From 5963cc2699db7b2893e7925bd2e68ada9d97e8ef Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 23 May 2012 13:28:44 -0400
Subject: [PATCH] xen/events: Add WARN_ON when quick lookup found invalid
 type.

All of the bind_XYZ_to_irq do a quick lookup to see if the
event exists. And if it does, then the initialized IRQ number
is returned instead of initializing a new IRQ number.

This patch adds an extra logic to check that the type returned
is proper one and that there is an IRQ handler setup for it.

This patch has the benefit of being able to find drivers that
are doing something naught.

[v1: Enhanced based on Stefano's review]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index faae2f9..81f338a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -827,6 +827,9 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 					      handle_edge_irq, "event");
 
 		xen_irq_info_evtchn_init(irq, evtchn);
+	} else {
+		struct irq_info *info = info_for_irq(irq);
+		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
 	}
 
 out:
@@ -862,8 +865,10 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 		xen_irq_info_ipi_init(cpu, irq, evtchn, ipi);
 
 		bind_evtchn_to_cpu(evtchn, cpu);
+	} else {
+		struct irq_info *info = info_for_irq(irq);
+		WARN_ON(info == NULL || info->type != IRQT_IPI);
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
+		WARN_ON(info == NULL || info->type != IRQT_VIRQ);
 	}
-
 out:
 	mutex_unlock(&irq_mapping_update_lock);
 
-- 
1.7.7.5

