Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965Ab1DNPab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:30:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64035 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab1DNPa1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 11:30:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/5] xen/irq: The Xen hypervisor cleans up the PIRQs if the other domain forgot.
Date: Thu, 14 Apr 2011 11:30:14 -0400
Message-Id: <1302795014-13289-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
References: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DA7130F.00AD:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And if the other domain forgot to clean up its PIRQs we don't need
to fail the operation. Just take a note of it and continue on.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index e4e8e9a..e51f3c5 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -728,7 +728,14 @@ int xen_destroy_irq(int irq)
 		unmap_irq.pirq = info->u.pirq.pirq;
 		unmap_irq.domid = info->u.pirq.domid;
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
-		if (rc) {
+		/* If another domain quits without making the pci_disable_msix
+		 * call, the Xen hypervisor takes care of freeing the PIRQs
+		 * (free_domain_pirqs).
+		 */
+		if ((rc == -ESRCH && info->u.pirq.domid != DOMID_SELF))
+			printk(KERN_INFO "domain %d does not have %d anymore\n",
+				info->u.pirq.domid, info->u.pirq.pirq);
+		else if (rc) {
 			printk(KERN_WARNING "unmap irq failed %d\n", rc);
 			goto out;
 		}
-- 
1.7.1

