Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0KSQuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:50:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:61765 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0KSQue (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 19 Nov 2010 11:50:34 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com
Cc: Jeremy.Fitzhardinge@citrix.com, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/events: Use PIRQ instead of GSI value when unmapping MSI/MSI-X irqs.
Date: Fri, 19 Nov 2010 11:48:54 -0500
Message-Id: <1290185334-29814-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we allocate a vector for MSI/MSI-X we save away the PIRQ, and the
vector value. When we unmap (de-allocate) the MSI/MSI-X vector(s) we
need to provide the PIRQ and the vector value. What we did instead
was to provide the GSI (which was zero) and the vector value, and we
got these unhappy error messages:

(XEN) irq.c:1575: dom0: pirq 0 not mapped
[    7.733415] unmap irq failed -22

This patches fixes this and we use the PIRQ value instead of the GSI
value.

CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

P.S.
Stefano, I've tested this on domain zero. The path on PVonHVM looks correct,
but I would appreciate you taking a look at this.
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 321a0c8..7eb720b 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -752,7 +752,7 @@ int xen_destroy_irq(int irq)
 		goto out;
 
 	if (xen_initial_domain()) {
-		unmap_irq.pirq = info->u.pirq.gsi;
+		unmap_irq.pirq = info->u.pirq.pirq;
 		unmap_irq.domid = DOMID_SELF;
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
 		if (rc) {
-- 
1.7.1

