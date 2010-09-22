Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab0IVVSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:18:20 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:47193 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab0IVVSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:18:16 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.57,219,1283731200"; 
   d="scan'208";a="190619591"
Date: Wed, 22 Sep 2010 14:18:19 -0700
From: Tom Lyon <pugs@cisco.com>
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        alex.williamson@redhat.com, mst@redhat.com
Subject: [PATCH 2/3] VFIO V4: uiommu driver - allow user progs to
 manipulate iommu domains
Message-ID: <4c9a729b.7vR5FISD2rBVIdQo%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tom Lyon <pugs@cisco.com>
---
 drivers/Kconfig        |    2 +
 drivers/Makefile       |    1 +
 drivers/vfio/Kconfig   |    8 +++
 drivers/vfio/Makefile  |    1 +
 drivers/vfio/uiommu.c  |  126 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/uiommu.h |   76 +++++++++++++++++++++++++++++
 6 files changed, 214 insertions(+), 0 deletions(-)
 create mode 100644 drivers/vfio/Kconfig
 create mode 100644 drivers/vfio/Makefile
 create mode 100644 drivers/vfio/uiommu.c
 create mode 100644 include/linux/uiommu.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index a2b902f..711c1cb 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -111,4 +111,6 @@ source "drivers/xen/Kconfig"
 source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
+
+source "drivers/vfio/Kconfig"
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 91874e0..e496fc3 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_FUSION)		+= message/
 obj-$(CONFIG_FIREWIRE)		+= firewire/
 obj-y				+= ieee1394/
 obj-$(CONFIG_UIO)		+= uio/
+obj-$(CONFIG_UIOMMU)		+= vfio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
new file mode 100644
index 0000000..3ab9af3
--- /dev/null
+++ b/drivers/vfio/Kconfig
@@ -0,0 +1,8 @@
+menuconfig UIOMMU
+	tristate "User level manipulation of IOMMU"
+	help
+	  Device driver to allow user level programs to
+	  manipulate IOMMU domains.
+
+	  If you don't know what to do here, say N.
+
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
new file mode 100644
index 0000000..556f3c1
--- /dev/null
+++ b/drivers/vfio/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_UIOMMU) += uiommu.o
diff --git a/drivers/vfio/uiommu.c b/drivers/vfio/uiommu.c
new file mode 100644
index 0000000..eec1759
--- /dev/null
+++ b/drivers/vfio/uiommu.c
@@ -0,0 +1,126 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+*/
+
+/*
+ * uiommu driver - issue fd handles for IOMMU domains
+ * so they may be passed to vfio (and others?)
+ */
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/iommu.h>
+#include <linux/uiommu.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tom Lyon <pugs@cisco.com>");
+MODULE_DESCRIPTION("User IOMMU driver");
+
+static struct uiommu_domain *uiommu_domain_alloc(void)
+{
+	struct iommu_domain *domain;
+	struct uiommu_domain *udomain;
+
+	domain = iommu_domain_alloc();
+	if (domain == NULL)
+		return NULL;
+	udomain = kzalloc(sizeof *udomain, GFP_KERNEL);
+	if (udomain == NULL) {
+		iommu_domain_free(domain);
+		return NULL;
+	}
+	udomain->domain = domain;
+	atomic_inc(&udomain->refcnt);
+	return udomain;
+}
+
+static int uiommu_open(struct inode *inode, struct file *file)
+{
+	struct uiommu_domain *udomain;
+
+	udomain = uiommu_domain_alloc();
+	if (udomain == NULL)
+		return -ENOMEM;
+	file->private_data = udomain;
+	return 0;
+}
+
+static int uiommu_release(struct inode *inode, struct file *file)
+{
+	struct uiommu_domain *udomain;
+
+	udomain = file->private_data;
+	uiommu_put(udomain);
+	return 0;
+}
+
+static const struct file_operations uiommu_fops = {
+	.owner		= THIS_MODULE,
+	.open		= uiommu_open,
+	.release	= uiommu_release,
+};
+
+static struct miscdevice uiommu_dev = {
+	.name	= "uiommu",
+	.minor	= MISC_DYNAMIC_MINOR,
+	.fops	= &uiommu_fops,
+};
+
+struct uiommu_domain *uiommu_fdget(int fd)
+{
+	struct file *file;
+	struct uiommu_domain *udomain;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+	if (file->f_op != &uiommu_fops) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+	udomain = file->private_data;
+	atomic_inc(&udomain->refcnt);
+	return udomain;
+}
+EXPORT_SYMBOL_GPL(uiommu_fdget);
+
+void uiommu_put(struct uiommu_domain *udomain)
+{
+	if (atomic_dec_and_test(&udomain->refcnt)) {
+		iommu_domain_free(udomain->domain);
+		kfree(udomain);
+	}
+}
+EXPORT_SYMBOL_GPL(uiommu_put);
+
+static int __init uiommu_init(void)
+{
+	return misc_register(&uiommu_dev);
+}
+
+static void __exit uiommu_exit(void)
+{
+	misc_deregister(&uiommu_dev);
+}
+
+module_init(uiommu_init);
+module_exit(uiommu_exit);
diff --git a/include/linux/uiommu.h b/include/linux/uiommu.h
new file mode 100644
index 0000000..d307b71
--- /dev/null
+++ b/include/linux/uiommu.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
+ * Author: Tom Lyon, pugs@cisco.com
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+/*
+ * uiommu driver - manipulation of iommu domains from user progs
+ */
+struct uiommu_domain {
+	struct iommu_domain	*domain;
+	atomic_t		refcnt;
+};
+
+/*
+ * Kernel routines invoked by fellow driver (vfio)
+ * after uiommu domain fd is passed in.
+ */
+struct uiommu_domain *uiommu_fdget(int fd);
+void uiommu_put(struct uiommu_domain *);
+
+/*
+ * These inlines are placeholders for future routines
+ * which may keep statistics, show info in sysfs, etc.
+ */
+static inline int uiommu_attach_device(struct uiommu_domain *udomain,
+			       struct device *dev)
+{
+	return iommu_attach_device(udomain->domain, dev);
+}
+
+static inline void uiommu_detach_device(struct uiommu_domain *udomain,
+				struct device *dev)
+{
+	iommu_detach_device(udomain->domain, dev);
+}
+
+static inline int uiommu_map(struct uiommu_domain *udomain,
+				unsigned long iova,
+				phys_addr_t paddr,
+				int gfp_order,
+				int prot)
+{
+	return iommu_map(udomain->domain, iova, paddr, gfp_order, prot);
+}
+
+static inline void uiommu_unmap(struct uiommu_domain *udomain,
+					unsigned long iova,
+					int gfp_order)
+{
+	iommu_unmap(udomain->domain, iova, gfp_order);
+}
+
+static inline phys_addr_t uiommu_iova_to_phys(struct uiommu_domain *udomain,
+						unsigned long iova)
+{
+	return iommu_iova_to_phys(udomain->domain, iova);
+}
+
+static inline int uiommu_domain_has_cap(struct uiommu_domain *udomain,
+						unsigned long cap)
+{
+	return iommu_domain_has_cap(udomain->domain, cap);
+}
-- 
1.6.0.2

