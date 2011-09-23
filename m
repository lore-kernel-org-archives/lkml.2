Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1IWPqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:46:54 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:50418
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab1IWPqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:46:49 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRZFTU-01-1DX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/10] iommu/core: Remove global iommu_ops and register_iommu
Date: Fri, 23 Sep 2011 17:45:56 +0200
Message-ID: <1316792756-3395-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all IOMMU drivers being converted to bus_set_iommu the
global iommu_ops are no longer required. The same is true
for the deprecated register_iommu function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/iommu.c |   27 ++++-----------------------
 include/linux/iommu.h |    1 -
 2 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1575aaa..64419c8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -25,16 +25,6 @@
 #include <linux/errno.h>
 #include <linux/iommu.h>
 
-static struct iommu_ops *iommu_ops;
-
-void register_iommu(struct iommu_ops *ops)
-{
-	if (iommu_ops)
-		BUG();
-
-	iommu_ops = ops;
-}
-
 static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
 {
 }
@@ -68,34 +58,25 @@ EXPORT_SYMBOL_GPL(bus_set_iommu);
 
 bool iommu_present(struct bus_type *bus)
 {
-	if (bus->iommu_ops != NULL)
-		return true;
-	else
-		return iommu_ops != NULL;
+	return bus->iommu_ops != NULL;
 }
 EXPORT_SYMBOL_GPL(iommu_present);
 
 struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 {
 	struct iommu_domain *domain;
-	struct iommu_ops *ops;
 	int ret;
 
-	if (bus->iommu_ops)
-		ops = bus->iommu_ops;
-	else
-		ops = iommu_ops;
-
-	if (ops == NULL)
+	if (bus == NULL || bus->iommu_ops == NULL)
 		return NULL;
 
 	domain = kmalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
 		return NULL;
 
-	domain->ops = ops;
+	domain->ops = bus->iommu_ops;
 
-	ret = iommu_ops->domain_init(domain);
+	ret = domain->ops->domain_init(domain);
 	if (ret)
 		goto out_free;
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f56e559..609ebf6 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -54,7 +54,6 @@ struct iommu_ops {
 			      unsigned long cap);
 };
 
-extern void register_iommu(struct iommu_ops *ops);
 extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
-- 
1.7.4.1


