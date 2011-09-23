Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1IWPqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:46:14 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:35907
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709Ab1IWPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:46:12 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRZFSQ-02-2CF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Date: Fri, 23 Sep 2011 17:45:48 +0200
Message-ID: <1316792756-3395-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the starting point to make the iommu_ops used for
the iommu-api a per-bus-type structure. It is required to
easily implement bus-specific setup in the iommu-layer.
The first user will be the iommu-group attribute in sysfs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/iommu.c  |   31 +++++++++++++++++++++++++++++++
 include/linux/device.h |    6 ++++++
 include/linux/iommu.h  |    2 ++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 30b0644..3343264 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -34,6 +34,37 @@ void register_iommu(struct iommu_ops *ops)
 	iommu_ops = ops;
 }
 
+static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
+{
+}
+
+/**
+ * bus_set_iommu - set iommu-callbacks for the bus
+ * @bus: bus.
+ * @ops: the callbacks provided by the iommu-driver
+ *
+ * This function is called by an iommu driver to set the iommu methods
+ * used for a particular bus. Drivers for devices on that bus can use
+ * the iommu-api after these ops are registered.
+ * This special function is needed because IOMMUs are usually devices on
+ * the bus itself, so the iommu drivers are not initialized when the bus
+ * is set up. With this function the iommu-driver can set the iommu-ops
+ * afterwards.
+ */
+int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops)
+{
+	if (bus->iommu_ops != NULL)
+		return -EBUSY;
+
+	bus->iommu_ops = ops;
+
+	/* Do IOMMU specific setup for this bus-type */
+	iommu_bus_init(bus, ops);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bus_set_iommu);
+
 bool iommu_found(void)
 {
 	return iommu_ops != NULL;
diff --git a/include/linux/device.h b/include/linux/device.h
index c20dfbf..e838e14 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -33,6 +33,7 @@ struct class;
 struct subsys_private;
 struct bus_type;
 struct device_node;
+struct iommu_ops;
 
 struct bus_attribute {
 	struct attribute	attr;
@@ -67,6 +68,9 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  * @resume:	Called to bring a device on this bus out of sleep mode.
  * @pm:		Power management operations of this bus, callback the specific
  *		device driver's pm-ops.
+ * @iommu_ops   IOMMU specific operations for this bus, used to attach IOMMU
+ *              driver implementations to a bus and allow the driver to do
+ *              bus-specific setup
  * @p:		The private data of the driver core, only the driver core can
  *		touch this.
  *
@@ -96,6 +100,8 @@ struct bus_type {
 
 	const struct dev_pm_ops *pm;
 
+	struct iommu_ops *iommu_ops;
+
 	struct subsys_private *p;
 };
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6470cd8..dca83d3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -25,6 +25,7 @@
 #define IOMMU_WRITE	(2)
 #define IOMMU_CACHE	(4) /* DMA cache coherency */
 
+struct bus_type;
 struct device;
 
 struct iommu_domain {
@@ -52,6 +53,7 @@ struct iommu_ops {
 };
 
 extern void register_iommu(struct iommu_ops *ops);
+extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_found(void);
 extern struct iommu_domain *iommu_domain_alloc(void);
 extern void iommu_domain_free(struct iommu_domain *domain);
-- 
1.7.4.1


