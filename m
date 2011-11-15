Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1KOVc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:32:57 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37772 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab1KOVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:32:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        x86@kernel.org, hpa@zytor.com, len.brown@intel.com,
        joseph.cihula@intel.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/7] xen/pci: Utilize the restore_msi_irqs hook.
Date: Tue, 15 Nov 2011 16:31:09 -0500
Message-Id: <1321392671-9128-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
References: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EC2DA45.002F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Liang <liang.tang@oracle.com>

to make a hypercall to restore the vectors in the MSI/MSI-X
configuration space.

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
1.7.7.1

