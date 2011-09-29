Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab1I2UUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:20:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45046 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab1I2USa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:18:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, len.brown@intel.com,
        joseph.cihula@intel.com, shane.wang@intel.com,
        xen-devel@lists.xensource.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com, ke.yu@intel.com, kevin.tian@intel.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/8] xen/pci:use hypercall PHYSDEVOP_restore_msi_ext to restore MSI/MSI-X vectors
Date: Thu, 29 Sep 2011 16:16:54 -0400
Message-Id: <1317327414-24072-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
References: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E84D246.00D1:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liang Tang <liang.tang@oracle.com>

.. to use the new hypercall to restore the vectors for MSI/MSI-X devices.
If the new hypercall fail, we will call the old one (PHYSDEVOP_restore_msi).

[v1: Attempt only once to make the new hypercall, not everytime]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Liang Tang <liang.tang@oracle.com>
---
 arch/x86/pci/xen.c              |   27 ++++++++++++++++++++++-----
 include/xen/interface/physdev.h |    8 ++++++++
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 9eea4ed..4521b05 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -248,6 +248,8 @@ error:
 }
 
 #ifdef CONFIG_XEN_DOM0
+static bool __read_mostly pci_seg_supported = true;
+
 static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	int ret = 0;
@@ -308,12 +310,27 @@ out:
 static void xen_initdom_restore_msi_irqs(struct pci_dev *dev, int irq)
 {
 	int ret = 0;
-	struct physdev_restore_msi restore;
 
-	restore.bus = dev->bus->number;
-	restore.devfn = dev->devfn;
-	ret = HYPERVISOR_physdev_op(PHYSDEVOP_restore_msi, &restore);
-	WARN(ret && ret != -ENOSYS, "restore_msi -> %d\n", ret);
+	if (pci_seg_supported) {
+		struct physdev_pci_device restore_ext;
+
+		restore_ext.seg = pci_domain_nr(dev->bus);
+		restore_ext.bus = dev->bus->number;
+		restore_ext.devfn = dev->devfn;
+		ret = HYPERVISOR_physdev_op(PHYSDEVOP_restore_msi_ext,
+					    &restore_ext);
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
 }
 #endif
 
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 44aefa9..9818456 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -205,6 +205,14 @@ struct physdev_get_free_pirq {
     uint32_t pirq;
 };
 
+#define PHYSDEVOP_restore_msi_ext       27
+struct physdev_pci_device {
+	/* IN */
+	uint16_t seg;
+	uint8_t bus;
+	uint8_t devfn;
+};
+
 /*
  * Notify that some PIRQ-bound event channels have been unmasked.
  * ** This command is obsolete since interface version 0x00030202 and is **
-- 
1.7.4.1

