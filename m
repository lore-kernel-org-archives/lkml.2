Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1EYLbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:31:02 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:8001 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1EYLa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:30:59 -0400
X-IronPort-AV: E=Sophos;i="4.65,266,1304294400"; 
   d="scan'208";a="5938711"
Date: Wed, 25 May 2011 12:33:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Goetz <tcgoetz@gmail.com>
Subject: [PATCH] xen: use the trigger info we already have to choose the irq
 handler
Message-ID: <alpine.DEB.2.00.1105251232020.12963@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use pirq_needs_eoi to decide which irq handler to use because Xen
always returns true if the guest does not support pirq_eoi_map.
Use the trigger information we already have from MP-tables and ACPI.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reported-by: Thomas Goetz <tcgoetz@gmail.com>
Tested-by: Thomas Goetz <tcgoetz@gmail.com>

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7f676f8..8418398 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -627,6 +627,9 @@ int xen_allocate_pirq_gsi(unsigned gsi)
  *
  * Note: We don't assign an event channel until the irq actually started
  * up.  Return an existing irq if we've already got one for the gsi.
+ *
+ * Shareable implies level triggered, not shareable implies edge
+ * triggered here.
  */
 int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 			     unsigned pirq, int shareable, char *name)
@@ -665,16 +668,13 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 
 	pirq_query_unmask(irq);
 	/* We try to use the handler with the appropriate semantic for the
-	 * type of interrupt: if the interrupt doesn't need an eoi
-	 * (pirq_needs_eoi returns false), we treat it like an edge
-	 * triggered interrupt so we use handle_edge_irq.
-	 * As a matter of fact this only happens when the corresponding
-	 * physical interrupt is edge triggered or an msi.
+	 * type of interrupt: if the interrupt is an edge triggered
+	 * interrupt we use handle_edge_irq.
 	 *
-	 * On the other hand if the interrupt needs an eoi (pirq_needs_eoi
-	 * returns true) we treat it like a level triggered interrupt so we
-	 * use handle_fasteoi_irq like the native code does for this kind of
+	 * On the other hand if the interrupt is level triggered we use
+	 * handle_fasteoi_irq like the native code does for this kind of
 	 * interrupts.
+	 *
 	 * Depending on the Xen version, pirq_needs_eoi might return true
 	 * not only for level triggered interrupts but for edge triggered
 	 * interrupts too. In any case Xen always honors the eoi mechanism,
@@ -682,7 +682,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 	 * hasn't received an eoi yet. Therefore using the fasteoi handler
 	 * is the right choice either way.
 	 */
-	if (pirq_needs_eoi(irq))
+	if (shareable)
 		irq_set_chip_and_handler_name(irq, &xen_pirq_chip,
 				handle_fasteoi_irq, name);
 	else
