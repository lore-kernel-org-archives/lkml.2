Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0FUQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:25:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab0FUQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:24:09 -0400
X-IronPort-AV: E=Sophos;i="4.53,453,1272859200"; 
   d="scan'208";a="102450199"
From: stefano@stabellini.net
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Stefano.Stabellini@eu.citrix.com,
       sheng@linux.intel.com, ddutile@redhat.com, jeremy@goop.org,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 07/13] Fix find_unbound_irq in presence of ioapic irqs.
Date: Mon, 21 Jun 2010 17:14:01 +0100
Message-Id: <1277136847-13266-7-git-send-email-stefano@stabellini.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
X-OriginalArrivalTime: 21 Jun 2010 16:14:40.0145 (UTC) FILETIME=[D9F33810:01CB115C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Don't break the assumption that the first 16 irqs are ISA irqs;
make sure that the irq is actually free before using it.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 0f7546e..b029a32 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -340,9 +340,18 @@ static int find_unbound_irq(void)
 	int irq;
 	struct irq_desc *desc;
 
-	for (irq = 0; irq < nr_irqs; irq++)
+	for (irq = 0; irq < nr_irqs; irq++) {
+		desc = irq_to_desc(irq);
+		/* only 0->15 have init'd desc; handle irq > 16 */
+		if (desc == NULL)
+			break;
+		if (desc->chip == &no_irq_chip)
+			break;
+		if (desc->chip != &xen_dynamic_chip)
+			continue;
 		if (irq_info[irq].type == IRQT_UNBOUND)
 			break;
+	}
 
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
-- 
1.7.0.4

