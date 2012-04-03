Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2DCCWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:22:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21801 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab2DCCVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:21:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 12/14] IOMMU: Add intel_enable_irq_remapping_one()
Date: Mon,  2 Apr 2012 19:19:39 -0700
Message-Id: <1333419581-7836-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020208.4F7A5E50.002B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need that for hot-added iommu interrupt remapping suppor.

Signed-off-by: Yinghai <yinghai@kernel.org>
---
 drivers/iommu/intel_irq_remapping.c |  136 +++++++++++++++++++++++++++++++++--
 1 files changed, 129 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 05ffe20..e20503d 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -214,7 +214,7 @@ static struct intel_iommu *map_ioapic_to_ir(int apic)
 {
 	int i;
 
-	for (i = 0; i < MAX_IO_APICS; i++)
+	for (i = 0; i < ir_ioapic_num; i++)
 		if (ir_ioapic[i].id == apic)
 			return ir_ioapic[i].iommu;
 	return NULL;
@@ -320,7 +320,7 @@ static int set_ioapic_sid(struct irte *irte, int apic)
 	if (!irte)
 		return -1;
 
-	for (i = 0; i < MAX_IO_APICS; i++) {
+	for (i = 0; i < ir_ioapic_num; i++) {
 		if (ir_ioapic[i].id == apic) {
 			sid = (ir_ioapic[i].bus << 8) | ir_ioapic[i].devfn;
 			break;
@@ -662,6 +662,7 @@ static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 	struct acpi_dmar_pci_path *path;
 	u8 bus;
 	int count;
+	int i;
 
 	bus = scope->bus;
 	path = (struct acpi_dmar_pci_path *)(scope + 1);
@@ -678,11 +679,16 @@ static void ir_parse_one_ioapic_scope(struct acpi_dmar_device_scope *scope,
 		path++;
 	}
 
-	ir_ioapic[ir_ioapic_num].bus   = bus;
-	ir_ioapic[ir_ioapic_num].devfn = PCI_DEVFN(path->dev, path->fn);
-	ir_ioapic[ir_ioapic_num].iommu = iommu;
-	ir_ioapic[ir_ioapic_num].id    = scope->enumeration_id;
-	ir_ioapic_num++;
+	for (i = 0; i < ir_ioapic_num; i++)
+		if (!ir_ioapic[i].iommu)
+			break;
+
+	ir_ioapic[i].bus   = bus;
+	ir_ioapic[i].devfn = PCI_DEVFN(path->dev, path->fn);
+	ir_ioapic[i].iommu = iommu;
+	ir_ioapic[i].id    = scope->enumeration_id;
+	if (i == ir_ioapic_num)
+		ir_ioapic_num++;
 }
 
 static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
@@ -1082,6 +1088,122 @@ static int intel_setup_hpet_msi(unsigned int irq, unsigned int id)
 	return 0;
 }
 
+void disable_irq_remapping_one(struct dmar_drhd_unit *drhd)
+{
+	struct intel_iommu *iommu = drhd->iommu;
+	int i;
+
+	/*
+	 * Disable Interrupt-remapping for the DRHD's now.
+	 */
+	if (!ecap_ir_support(iommu->ecap))
+		return;
+
+	iommu_disable_irq_remapping(iommu);
+
+	/* remove it from ir_ioapic */
+	for (i = 0; i < ir_ioapic_num; i++)
+		if (ir_ioapic[i].iommu == iommu) {
+			ir_ioapic[i].iommu = NULL;
+			ir_ioapic[i].id	= 0xff;
+		}
+}
+
+static int parse_ioapics_under_ir_one(struct dmar_drhd_unit *drhd)
+{
+	int ir_supported = 0;
+
+	struct intel_iommu *iommu = drhd->iommu;
+
+	if (ecap_ir_support(iommu->ecap)) {
+		if (ir_parse_ioapic_hpet_scope(drhd->hdr, iommu))
+			return -1;
+
+		ir_supported = 1;
+	}
+
+	return ir_supported;
+}
+
+int intel_enable_irq_remapping_one(struct dmar_drhd_unit *drhd)
+{
+	int setup = 0;
+	int eim = 1;
+	int ret;
+	struct intel_iommu *iommu = drhd->iommu;
+
+	if (parse_ioapics_under_ir_one(drhd) != 1) {
+		printk(KERN_INFO "Not enable interrupt remapping\n");
+		return -1;
+	}
+
+	/*
+	 * If the queued invalidation is already initialized,
+	 * shouldn't disable it.
+	 */
+	if (!iommu->qi) {
+		/*
+		 * Clear previous faults.
+		 */
+		dmar_fault(-1, iommu);
+
+		/*
+		 * Disable intr remapping and queued invalidation, if already
+		 * enabled prior to OS handover.
+		 */
+		iommu_disable_irq_remapping(iommu);
+
+		dmar_disable_qi(iommu);
+	}
+
+	/*
+	 * check for the Interrupt-remapping support
+	 */
+
+	if (ecap_ir_support(iommu->ecap))
+		if (eim && !ecap_eim_support(iommu->ecap)) {
+			printk(KERN_INFO
+			"DRHD %Lx: EIM not supported by DRHD, ecap %Lx\n",
+				drhd->reg_base_addr, iommu->ecap);
+			return -1;
+		}
+
+	/*
+	 * Enable queued invalidation for the DRHD's.
+	 */
+	ret = dmar_enable_qi(iommu);
+
+	if (ret) {
+		printk(KERN_ERR
+			"DRHD %Lx: failed to enable queued, invalidation, ecap %Lx, ret %d\n",
+		       drhd->reg_base_addr, iommu->ecap, ret);
+		return -1;
+	}
+
+	/*
+	 * Setup Interrupt-remapping for the DRHD's now.
+	 */
+	if (ecap_ir_support(iommu->ecap)) {
+		if (intel_setup_irq_remapping(iommu, eim))
+			goto error;
+
+		setup = 1;
+	}
+
+	if (!setup)
+		goto error;
+
+	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
+
+	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
+
+error:
+	/*
+	 * handle error condition gracefully here!
+	 */
+	return -1;
+}
+
 struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_irq_remapping_supported,
 	.prepare		= dmar_table_init,
-- 
1.7.7

