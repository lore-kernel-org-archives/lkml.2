Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1IGQJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:09:01 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:33032
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756578Ab1IGQIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:08:50 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR5SY2-01-4FP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/10] iommu/core: Remove global iommu_ops and register_iommu
Date: Wed, 7 Sep 2011 17:41:53 +0200
Message-ID: <1315410113-26608-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
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
index f2ced4c..82178cb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -25,50 +25,31 @@
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
 void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
 {
 }
 
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
+	if (bus->iommu_ops == NULL)
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
index de73219..7014f40 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -54,7 +54,6 @@ struct iommu_ops {
 			      unsigned long cap);
 };
 
-extern void register_iommu(struct iommu_ops *ops);
 extern void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
-- 
1.7.4.1


