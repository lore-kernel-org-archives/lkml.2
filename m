Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949Ab1LPWnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:43:25 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:54905 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab1LPWnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:43:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, x86@kernel.org,
        len.brown@intel.com, joseph.cihula@intel.com,
        linux-pm@lists.linux-foundation.org, tboot-devel@lists.sourceforge.net,
        linux-acpi@vger.kernel.org, liang.tang@oracle.com
Cc: hpa@zytor.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/7] xen: Utilize the restore_msi_irqs hook.
Date: Fri, 16 Dec 2011 17:38:19 -0500
Message-Id: <1324075099-11397-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1324075099-11397-1-git-send-email-konrad.wilk@oracle.com>
References: <1324075099-11397-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4EEBC96E.0015,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Liang <liang.tang@oracle.com>

to make a hypercall to restore the vectors in the MSI/MSI-X
configuration space.

Signed-off-by: Tang Liang <liang.tang@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c              |   27 +++++++++++++++++++++++++++
 include/xen/interface/physdev.h |    7 +++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 492ade8..249a5ae 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -324,6 +324,32 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 out:
 	return ret;
 }
+
+static void xen_initdom_restore_msi_irqs(struct pci_dev *dev, int irq)
+{
+	int ret = 0;
+
+	if (pci_seg_supported) {
+		struct physdev_pci_device restore_ext;
+
+		restore_ext.seg = pci_domain_nr(dev->bus);
+		restore_ext.bus = dev->bus->number;
+		restore_ext.devfn = dev->devfn;
+		ret = HYPERVISOR_physdev_op(PHYSDEVOP_restore_msi_ext,
+					&restore_ext);
+		if (ret == -ENOSYS)
+			pci_seg_supported = false;
+		WARN(ret && ret != -ENOSYS, "restore_msi_ext -> %d\n", ret);
+	}
+	if (!pci_seg_supported) {
+		struct physdev_restore_msi restore;
+
+		restore.bus = dev->bus->number;
+		restore.devfn = dev->devfn;
+		ret = HYPERVISOR_physdev_op(PHYSDEVOP_restore_msi, &restore);
+		WARN(ret && ret != -ENOSYS, "restore_msi -> %d\n", ret);
+	}
+}
 #endif
 
 static void xen_teardown_msi_irqs(struct pci_dev *dev)
@@ -446,6 +472,7 @@ int __init pci_xen_initial_domain(void)
 #ifdef CONFIG_PCI_MSI
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+	x86_msi.restore_msi_irqs = xen_initdom_restore_msi_irqs;
 #endif
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index c1080d9..0c28989 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -145,6 +145,13 @@ struct physdev_manage_pci {
 	uint8_t devfn;
 };
 
+#define PHYSDEVOP_restore_msi            19
+struct physdev_restore_msi {
+	/* IN */
+	uint8_t bus;
+	uint8_t devfn;
+};
+
 #define PHYSDEVOP_manage_pci_add_ext	20
 struct physdev_manage_pci_ext {
 	/* IN */
-- 
1.7.7.4

