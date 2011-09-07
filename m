Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab1IGQ3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:29:34 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25536
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749Ab1IGQ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:29:27 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR5SY4-02-DWI-02
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
Subject: [PATCH 03/10] iommu/core: Add bus_type parameter to iommu_domain_alloc
Date: Wed, 7 Sep 2011 17:41:46 +0200
Message-ID: <1315410113-26608-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary to store a pointer to the bus-specific
iommu_ops in the iommu-domain structure. It will be used
later to call into bus-specific iommu-ops.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/iommu.c              |   14 +++++++++++++-
 drivers/media/video/omap3isp/isp.c |    2 +-
 include/linux/iommu.h              |    6 ++++--
 virt/kvm/iommu.c                   |    2 +-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 3b24a5b..adaee9b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -16,6 +16,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/types.h>
@@ -44,15 +45,26 @@ bool iommu_found(void)
 }
 EXPORT_SYMBOL_GPL(iommu_found);
 
-struct iommu_domain *iommu_domain_alloc(void)
+struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 {
 	struct iommu_domain *domain;
+	struct iommu_ops *ops;
 	int ret;
 
+	if (bus->iommu_ops)
+		ops = bus->iommu_ops;
+	else
+		ops = iommu_ops;
+
+	if (ops == NULL)
+		return NULL;
+
 	domain = kmalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
 		return NULL;
 
+	domain->ops = ops;
+
 	ret = iommu_ops->domain_init(domain);
 	if (ret)
 		goto out_free;
diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index a4baa61..a7ed985 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -2141,7 +2141,7 @@ static int isp_probe(struct platform_device *pdev)
 	/* to be removed once iommu migration is complete */
 	isp->iommu = to_iommu(isp->iommu_dev);
 
-	isp->domain = iommu_domain_alloc();
+	isp->domain = iommu_domain_alloc(pdev->dev.bus);
 	if (!isp->domain) {
 		dev_err(isp->dev, "can't alloc iommu domain\n");
 		ret = -ENOMEM;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 4739e36..3bd6892 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -25,10 +25,12 @@
 #define IOMMU_WRITE	(2)
 #define IOMMU_CACHE	(4) /* DMA cache coherency */
 
+struct iommu_ops;
 struct bus_type;
 struct device;
 
 struct iommu_domain {
+	struct iommu_ops *ops;
 	void *priv;
 };
 
@@ -55,7 +57,7 @@ struct iommu_ops {
 extern void register_iommu(struct iommu_ops *ops);
 extern void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_found(void);
-extern struct iommu_domain *iommu_domain_alloc(void);
+extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
 extern void iommu_domain_free(struct iommu_domain *domain);
 extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
@@ -79,7 +81,7 @@ static inline bool iommu_found(void)
 	return false;
 }
 
-static inline struct iommu_domain *iommu_domain_alloc(void)
+static inline struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 {
 	return NULL;
 }
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 78c80f6..20115b1 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -233,7 +233,7 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 		return -ENODEV;
 	}
 
-	kvm->arch.iommu_domain = iommu_domain_alloc();
+	kvm->arch.iommu_domain = iommu_domain_alloc(&pci_bus_type);
 	if (!kvm->arch.iommu_domain)
 		return -ENOMEM;
 
-- 
1.7.4.1


