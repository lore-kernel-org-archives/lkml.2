Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0FCNLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:11:30 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30773 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0FCNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:28 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908952"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 07/12] Fix find_unbound_irq in presence of ioapic irqs.
Date: Thu,  3 Jun 2010 14:10:40 +0100
Message-Id: <1275570645-27189-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:27.0131 (UTC) FILETIME=[462AE6B0:01CB031E]
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
index 4bd0ea3..b233564 100644
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

