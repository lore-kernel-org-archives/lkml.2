Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab0LIVA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:00:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63530 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0LIVAZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 9 Dec 2010 16:00:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/irq: Cleanup the find_unbound_irq
Date: Thu,  9 Dec 2010 16:01:36 -0500
Message-Id: <1291928497-5599-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com>
References: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "find_unbound_irq" is a bit unusual - it allocates
virtual IRQ (event channels) in reverse order. This means
starting at the "top" of the available IRQs (nr_irqs) down
to the GSI/MSI IRQs (nr_irqs_gsi).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 31af0ac..4d4a23d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -405,15 +405,21 @@ static int find_unbound_irq(void)
 {
 	struct irq_data *data;
 	int irq, res;
-	int start = get_nr_hw_irqs();
+	int bottom = get_nr_hw_irqs();
+	int top = nr_irqs-1;
 
-	if (start == nr_irqs)
+	if (bottom == nr_irqs)
 		goto no_irqs;
 
-	/* nr_irqs is a magic value. Must not use it.*/
-	for (irq = nr_irqs-1; irq > start; irq--) {
+	/* This loop starts from the top of IRQ space and goes down.
+	 * We need this b/c if we have a PCI device in a Xen PV guest
+	 * we do not have an IO-APIC (though the backend might have them)
+	 * mapped in. To not have a collision of physical IRQs with the Xen
+	 * event channels start at the top of the IRQ space for virtual IRQs.
+	 */
+	for (irq = top; irq > bottom; irq--) {
 		data = irq_get_irq_data(irq);
-		/* only 0->15 have init'd desc; handle irq > 16 */
+		/* only 15->0 have init'd desc; handle irq > 16 */
 		if (!data)
 			break;
 		if (data->chip == &no_irq_chip)
@@ -424,7 +430,7 @@ static int find_unbound_irq(void)
 			return irq;
 	}
 
-	if (irq == start)
+	if (irq == bottom)
 		goto no_irqs;
 
 	res = irq_alloc_desc_at(irq, -1);
-- 
1.7.1

