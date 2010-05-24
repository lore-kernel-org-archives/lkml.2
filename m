Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab0EXS0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:26:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21720 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0EXSYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:24:06 -0400
X-IronPort-AV: E=Sophos;i="4.53,292,1272859200"; 
   d="scan'208";a="98432021"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Don Dutile <ddutile@redhat.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 04/11] Fix find_unbound_irq in presence of ioapic irqs.
Date: Mon, 24 May 2010 19:27:30 +0100
Message-Id: <1274725657-1149-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
X-OriginalArrivalTime: 24 May 2010 18:24:06.0175 (UTC) FILETIME=[4B4C5AF0:01CAFB6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 8b68fc4..1356fa2 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -339,9 +339,18 @@ static int find_unbound_irq(void)
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

