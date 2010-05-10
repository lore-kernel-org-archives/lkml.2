Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab0EJWz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:55:29 -0400
Received: from kroah.org ([198.145.64.141]:33395 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab0EJWw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:57 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:26 2010
Message-Id: <20100510223326.501674300@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [101/117] sparc64: Fix memory leak in pci_register_iommu_region().
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit e182c77cc291456eed127b1472952ddb59a81a9d ]

Found by kmemleak.

If request_resource() fails, we leak the struct resource we
allocated to represent the IOMMU mapping area.

This actually happens on sun4v machines because the IOMEM area is only
reported sans the IOMMU region, unlike all previous systems.  I'll
need to fix that at some point, but for now fix the leak.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/pci_common.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/sparc/kernel/pci_common.c
+++ b/arch/sparc/kernel/pci_common.c
@@ -371,14 +371,19 @@ static void pci_register_iommu_region(st
 		struct resource *rp = kzalloc(sizeof(*rp), GFP_KERNEL);
 
 		if (!rp) {
-			prom_printf("Cannot allocate IOMMU resource.\n");
-			prom_halt();
+			pr_info("%s: Cannot allocate IOMMU resource.\n",
+				pbm->name);
+			return;
 		}
 		rp->name = "IOMMU";
 		rp->start = pbm->mem_space.start + (unsigned long) vdma[0];
 		rp->end = rp->start + (unsigned long) vdma[1] - 1UL;
 		rp->flags = IORESOURCE_BUSY;
-		request_resource(&pbm->mem_space, rp);
+		if (request_resource(&pbm->mem_space, rp)) {
+			pr_info("%s: Unable to request IOMMU resource.\n",
+				pbm->name);
+			kfree(rp);
+		}
 	}
 }
 


