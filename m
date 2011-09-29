Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab1I2USf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:18:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45038 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab1I2US3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:18:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, len.brown@intel.com,
        joseph.cihula@intel.com, shane.wang@intel.com,
        xen-devel@lists.xensource.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com, ke.yu@intel.com, kevin.tian@intel.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/8] xen: Utilize the restore_msi_irqs hook.
Date: Thu, 29 Sep 2011 16:16:50 -0400
Message-Id: <1317327414-24072-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
References: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4E84D244.0088,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to make a hypercall to restore the vectors in the MSI/MSI-X
configuration space.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c              |   12 ++++++++++++
 include/xen/interface/physdev.h |    7 +++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 1017c7b..9eea4ed 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -304,6 +304,17 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 out:
 	return ret;
 }
+
+static void xen_initdom_restore_msi_irqs(struct pci_dev *dev, int irq)
+{
+	int ret = 0;
+	struct physdev_restore_msi restore;
+
+	restore.bus = dev->bus->number;
+	restore.devfn = dev->devfn;
+	ret = HYPERVISOR_physdev_op(PHYSDEVOP_restore_msi, &restore);
+	WARN(ret && ret != -ENOSYS, "restore_msi -> %d\n", ret);
+}
 #endif
 
 static void xen_teardown_msi_irqs(struct pci_dev *dev)
@@ -426,6 +437,7 @@ int __init pci_xen_initial_domain(void)
 #ifdef CONFIG_PCI_MSI
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
 	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+	x86_msi.restore_msi_irqs = xen_initdom_restore_msi_irqs;
 #endif
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 534cac8..44aefa9 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -144,6 +144,13 @@ struct physdev_manage_pci {
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
1.7.4.1

