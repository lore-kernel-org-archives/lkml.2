Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab0ERKb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:31:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:64753 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0ERK3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:29:40 -0400
X-IronPort-AV: E=Sophos;i="4.53,254,1272859200"; 
   d="scan'208";a="97477183"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 04/12] Fix find_unbound_irq in presence of ioapic irqs.
Date: Tue, 18 May 2010 11:22:59 +0100
Message-Id: <1274178187-20602-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop>
X-OriginalArrivalTime: 18 May 2010 10:20:00.0310 (UTC) FILETIME=[AC229560:01CAF673]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 3523dbb..a137a2f 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -337,9 +337,18 @@ static int find_unbound_irq(void)
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
1.5.4.3

