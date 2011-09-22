Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab1IVQP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:15:28 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:57295
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab1IVQPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:15:21 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRXMHG-01-468-02
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
Date: Thu, 22 Sep 2011 18:14:54 +0200
Message-ID: <1316708102-16250-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
References: <1316708102-16250-1-git-send-email-joerg.roedel@amd.com>
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
 drivers/base/bus.c     |   29 +++++++++++++++++++++++++++++
 drivers/iommu/iommu.c  |    4 ++++
 include/linux/device.h |   10 ++++++++++
 include/linux/iommu.h  |    2 ++
 4 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 000e7b2..b3014fe 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -1028,6 +1028,35 @@ void bus_sort_breadthfirst(struct bus_type *bus,
 }
 EXPORT_SYMBOL_GPL(bus_sort_breadthfirst);
 
+#ifdef CONFIG_IOMMU_API
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
+#endif
+
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 30b0644..3b24a5b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -34,6 +34,10 @@ void register_iommu(struct iommu_ops *ops)
 	iommu_ops = ops;
 }
 
+void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
+{
+}
+
 bool iommu_found(void)
 {
 	return iommu_ops != NULL;
diff --git a/include/linux/device.h b/include/linux/device.h
index c20dfbf..490382b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -33,6 +33,7 @@ struct class;
 struct subsys_private;
 struct bus_type;
 struct device_node;
+struct iommu_ops;
 
 struct bus_attribute {
 	struct attribute	attr;
@@ -46,6 +47,7 @@ struct bus_attribute bus_attr_##_name = __ATTR(_name, _mode, _show, _store)
 extern int __must_check bus_create_file(struct bus_type *,
 					struct bus_attribute *);
 extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
+extern void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops);
 
 /**
  * struct bus_type - The bus type of the device
@@ -67,6 +69,9 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  * @resume:	Called to bring a device on this bus out of sleep mode.
  * @pm:		Power management operations of this bus, callback the specific
  *		device driver's pm-ops.
+ * @iommu_ops   IOMMU specific operations for this bus, used to attach IOMMU
+ *              driver implementations to a bus and allow the driver to do
+ *              bus-specific setup
  * @p:		The private data of the driver core, only the driver core can
  *		touch this.
  *
@@ -96,6 +101,8 @@ struct bus_type {
 
 	const struct dev_pm_ops *pm;
 
+	struct iommu_ops *iommu_ops;
+
 	struct subsys_private *p;
 };
 
@@ -148,6 +155,9 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 #define BUS_NOTIFY_UNBOUND_DRIVER	0x00000006 /* driver is unbound
 						      from the device */
 
+/* IOMMU related bus functions */
+int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
+
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6470cd8..4739e36 100644
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
+extern void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_found(void);
 extern struct iommu_domain *iommu_domain_alloc(void);
 extern void iommu_domain_free(struct iommu_domain *domain);
-- 
1.7.4.1


