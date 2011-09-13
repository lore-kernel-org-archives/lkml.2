Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1IMOyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:54:11 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:48730 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1IMOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:54:08 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1dbaL1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRGUQ1-01-1YT-02
X-M-MSG: 
Date: Tue, 13 Sep 2011 16:54:02 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Greg KH <gregkh@suse.de>
CC: Joerg Roedel <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110913145402.GM11701@amd.com>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de>
 <20110907191919.GA31674@8bytes.org>
 <20110907194445.GA2526@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110907194445.GA2526@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Sep 07, 2011 at 03:44:45PM -0400, Greg KH wrote:
> > 
> > The IOMMUs are usually devices on the bus itself, so they are
> > initialized after the bus is set up and the devices on it are
> > populated.  So the function can not be called on bus initialization
> > because the IOMMU is not ready at this point.
> 
> Ok, that makes more sense, please state as much in the documentation.

I added the kernel-doc documentation you requested. Here is the updated
patch. Please let me know what you think.

>From 23757825035f6d9309866dc142133aada0e2c1de Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 26 Aug 2011 16:48:26 +0200
Subject: [PATCH 02/10] Driver core: Add iommu_ops to bus_type

This is the starting point to make the iommu_ops used for
the iommu-api a per-bus-type structure. It is required to
easily implement bus-specific setup in the iommu-layer.
The first user will be the iommu-group attribute in sysfs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/base/bus.c     |   29 +++++++++++++++++++++++++++++
 drivers/iommu/iommu.c  |    4 ++++
 include/linux/device.h |    9 +++++++++
 include/linux/iommu.h  |    2 ++
 4 files changed, 44 insertions(+), 0 deletions(-)

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
index c20dfbf..8240b2a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+#include <linux/iommu.h>
 #include <linux/atomic.h>
 #include <asm/device.h>
 
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
 
@@ -148,6 +154,9 @@ extern int bus_unregister_notifier(struct bus_type *bus,
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

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

