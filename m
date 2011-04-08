Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1DHISf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:18:35 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:5148
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab1DHIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:17:19 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJBR0R-01-AHL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/5] PCI: Move ATS declarations in seperate header file
Date: Fri, 8 Apr 2011 10:17:06 +0200
Message-ID: <1302250630-8183-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
References: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the relevant declarations from the local
header file in drivers/pci to a more accessible locations so
that it can be used by the AMD IOMMU driver too.
The file is named pci-ats-pri.h because support for the PCI
PRI capability will also be added there in a later
patch-set.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |    1 +
 drivers/pci/iov.c         |    1 +
 drivers/pci/pci.h         |   37 --------------------------------
 include/linux/pci-ats.h   |   52 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 37 deletions(-)
 create mode 100644 include/linux/pci-ats.h

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 7da3bef..fdb2cef 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -39,6 +39,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/tboot.h>
 #include <linux/dmi.h>
+#include <linux/pci-ats.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 #include "pci.h"
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 553d8ee..42fae47 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/delay.h>
+#include <linux/pci-ats.h>
 #include "pci.h"
 
 #define VIRTFN_ID_LEN	16
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index a6ec200..4020025 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -250,15 +250,6 @@ struct pci_sriov {
 	u8 __iomem *mstate;	/* VF Migration State Array */
 };
 
-/* Address Translation Service */
-struct pci_ats {
-	int pos;	/* capability position */
-	int stu;	/* Smallest Translation Unit */
-	int qdep;	/* Invalidate Queue Depth */
-	int ref_cnt;	/* Physical Function reference count */
-	unsigned int is_enabled:1;	/* Enable bit is set */
-};
-
 #ifdef CONFIG_PCI_IOV
 extern int pci_iov_init(struct pci_dev *dev);
 extern void pci_iov_release(struct pci_dev *dev);
@@ -269,19 +260,6 @@ extern resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev,
 extern void pci_restore_iov_state(struct pci_dev *dev);
 extern int pci_iov_bus_range(struct pci_bus *bus);
 
-extern int pci_enable_ats(struct pci_dev *dev, int ps);
-extern void pci_disable_ats(struct pci_dev *dev);
-extern int pci_ats_queue_depth(struct pci_dev *dev);
-/**
- * pci_ats_enabled - query the ATS status
- * @dev: the PCI device
- *
- * Returns 1 if ATS capability is enabled, or 0 if not.
- */
-static inline int pci_ats_enabled(struct pci_dev *dev)
-{
-	return dev->ats && dev->ats->is_enabled;
-}
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
@@ -304,21 +282,6 @@ static inline int pci_iov_bus_range(struct pci_bus *bus)
 	return 0;
 }
 
-static inline int pci_enable_ats(struct pci_dev *dev, int ps)
-{
-	return -ENODEV;
-}
-static inline void pci_disable_ats(struct pci_dev *dev)
-{
-}
-static inline int pci_ats_queue_depth(struct pci_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pci_ats_enabled(struct pci_dev *dev)
-{
-	return 0;
-}
 #endif /* CONFIG_PCI_IOV */
 
 static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
new file mode 100644
index 0000000..655824f
--- /dev/null
+++ b/include/linux/pci-ats.h
@@ -0,0 +1,52 @@
+#ifndef LINUX_PCI_ATS_H
+#define LINUX_PCI_ATS_H
+
+/* Address Translation Service */
+struct pci_ats {
+	int pos;        /* capability position */
+	int stu;        /* Smallest Translation Unit */
+	int qdep;       /* Invalidate Queue Depth */
+	int ref_cnt;    /* Physical Function reference count */
+	unsigned int is_enabled:1;      /* Enable bit is set */
+};
+
+#ifdef CONFIG_PCI_IOV
+
+extern int pci_enable_ats(struct pci_dev *dev, int ps);
+extern void pci_disable_ats(struct pci_dev *dev);
+extern int pci_ats_queue_depth(struct pci_dev *dev);
+/**
+ * pci_ats_enabled - query the ATS status
+ * @dev: the PCI device
+ *
+ * Returns 1 if ATS capability is enabled, or 0 if not.
+ */
+static inline int pci_ats_enabled(struct pci_dev *dev)
+{
+	return dev->ats && dev->ats->is_enabled;
+}
+
+#else /* CONFIG_PCI_IOV */
+
+static inline int pci_enable_ats(struct pci_dev *dev, int ps)
+{
+	return -ENODEV;
+}
+
+static inline void pci_disable_ats(struct pci_dev *dev)
+{
+}
+
+static inline int pci_ats_queue_depth(struct pci_dev *dev)
+{
+	return -ENODEV;
+}
+
+static inline int pci_ats_enabled(struct pci_dev *dev)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PCI_IOV */
+
+#endif /* LINUX_PCI_ATS_H*/
-- 
1.7.1


