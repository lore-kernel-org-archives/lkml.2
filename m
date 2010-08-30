Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0H3LUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:20:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:55789 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0H3LUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:20:46 -0400
X-IronPort-AV: E=Sophos;i="4.56,292,1280721600"; 
   d="scan'208";a="111744723"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3/7] xen: implement xen_hvm_register_pirq
Date: Mon, 30 Aug 2010 12:21:12 +0100
Message-Id: <1283167276-7364-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
References: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
X-OriginalArrivalTime: 30 Aug 2010 11:20:41.0923 (UTC) FILETIME=[61AAA130:01CB4835]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

xen_hvm_register_pirq allows the kernel to map a GSI into a Xen pirq and
receive the interrupt as an event channel from that point on.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/pci.h  |    5 +++++
 arch/x86/pci/xen.c              |   36 ++++++++++++++++++++++++++++++++++++
 drivers/xen/events.c            |    4 +++-
 include/xen/interface/physdev.h |   30 ++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
index 449c82f..b4d908b 100644
--- a/arch/x86/include/asm/xen/pci.h
+++ b/arch/x86/include/asm/xen/pci.h
@@ -3,10 +3,15 @@
 
 #if defined(CONFIG_PCI_XEN)
 extern int __init pci_xen_init(void);
+int xen_hvm_register_pirq(u32 gsi, int triggering);
 #define pci_xen 1
 #else
 #define pci_xen 0
 #define pci_xen_init (0)
+static inline int xen_hvm_register_pirq(u32 gsi, int triggering)
+{
+	return -1;
+}
 #endif
 
 #if defined(CONFIG_PCI_MSI)
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index b19c873..d6fd58f 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -17,6 +17,42 @@
 #include <xen/events.h>
 #include <asm/xen/pci.h>
 
+int xen_hvm_register_pirq(u32 gsi, int triggering)
+{
+	int rc, irq;
+	struct physdev_map_pirq map_irq;
+	int shareable = 0;
+	char *name;
+
+	if (!xen_hvm_domain())
+		return -1;
+
+	map_irq.domid = DOMID_SELF;
+	map_irq.type = MAP_PIRQ_TYPE_GSI;
+	map_irq.index = gsi;
+	map_irq.pirq = -1;
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
+	if (rc) {
+		printk(KERN_WARNING "xen map irq failed %d\n", rc);
+		return -1;
+	}
+
+	if (triggering == ACPI_EDGE_SENSITIVE) {
+		shareable = 0;
+		name = "ioapic-edge";
+	} else {
+		shareable = 1;
+		name = "ioapic-level";
+	}
+
+	irq = xen_map_pirq_gsi(map_irq.pirq, gsi, shareable, name);
+
+	printk(KERN_DEBUG "xen: --> irq=%d, pirq=%d\n", irq, map_irq.pirq);
+
+	return irq;
+}
+
 #if defined(CONFIG_PCI_MSI)
 #include <linux/msi.h>
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index aca7230..302dad1 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -36,6 +36,7 @@
 #include <asm/idle.h>
 #include <asm/io_apic.h>
 #include <asm/sync_bitops.h>
+#include <asm/xen/pci.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 
@@ -75,7 +76,8 @@ enum xen_irq_type {
  * event channel - irq->event channel mapping
  * cpu - cpu this event channel is bound to
  * index - type-specific information:
- *    PIRQ - vector, with MSB being "needs EIO"
+ *    PIRQ - vector, with MSB being "needs EIO", or physical IRQ of the HVM
+ *           guest, or GSI (real passthrough IRQ) of the device.
  *    VIRQ - virq number
  *    IPI - IPI vector
  *    EVTCHN -
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index fbb5883..69a72b9 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -106,6 +106,36 @@ struct physdev_irq {
 	uint32_t vector;
 };
 
+#define MAP_PIRQ_TYPE_MSI		0x0
+#define MAP_PIRQ_TYPE_GSI		0x1
+#define MAP_PIRQ_TYPE_UNKNOWN		0x2
+
+#define PHYSDEVOP_map_pirq		13
+struct physdev_map_pirq {
+    domid_t domid;
+    /* IN */
+    int type;
+    /* IN */
+    int index;
+    /* IN or OUT */
+    int pirq;
+    /* IN */
+    int bus;
+    /* IN */
+    int devfn;
+    /* IN */
+    int entry_nr;
+    /* IN */
+    uint64_t table_base;
+};
+
+#define PHYSDEVOP_unmap_pirq		14
+struct physdev_unmap_pirq {
+    domid_t domid;
+    /* IN */
+    int pirq;
+};
+
 /*
  * Argument to physdev_op_compat() hypercall. Superceded by new physdev_op()
  * hypercall since 0x00030202.
-- 
1.5.6.5

