Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2DBVOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:14:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab2DBVOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:14:51 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 1/3] iommu: Introduce iommu_group
To: david@gibson.dropbear.id.au, dwmw2@infradead.org
Cc: alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Apr 2012 15:14:40 -0600
Message-ID: <20120402211440.28977.74440.stgit@bling.home>
In-Reply-To: <20120402203721.28977.95285.stgit@bling.home>
References: <20120402203721.28977.95285.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMUs often do not have visibility of individual devices in the
system.  Due to IOMMU design, bus topology, or device quirks, we
can often only identify groups of devices.  Examples include
Intel VT-d & AMD-Vi which often have function level visibility
compared to POWER partitionable endpoints which have bridge level
granularity.  PCIe-to-PCI bridges also often cloud the IOMMU
visibility as it cannot distiguish devices behind the bridge.
Devices can also sometimes hurt themselves by initiating DMA using
the wrong source ID on a multifunction PCI device.

IOMMU groups are meant to help solve these problems and hopefully
become the working unit of the IOMMI API.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/device.h |    2 ++
 include/linux/iommu.h  |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index b63fb39..6acab1c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -35,6 +35,7 @@ struct subsys_private;
 struct bus_type;
 struct device_node;
 struct iommu_ops;
+struct iommu_group;
 
 struct bus_attribute {
 	struct attribute	attr;
@@ -683,6 +684,7 @@ struct device {
 	const struct attribute_group **groups;	/* optional groups */
 
 	void	(*release)(struct device *dev);
+	struct iommu_group	*iommu_group;
 };
 
 /* Get the wakeup routines, which depend on struct device */
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d937580..2ee375c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -26,6 +26,7 @@
 #define IOMMU_CACHE	(4) /* DMA cache coherency */
 
 struct iommu_ops;
+struct iommu_group;
 struct bus_type;
 struct device;
 struct iommu_domain;
@@ -78,6 +79,9 @@ struct iommu_ops {
 	unsigned long pgsize_bitmap;
 };
 
+struct iommu_group {
+};
+
 extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
@@ -140,6 +144,7 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
+struct iommu_group {};
 
 static inline bool iommu_present(struct bus_type *bus)
 {

