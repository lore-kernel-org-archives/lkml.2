Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2DCCUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:20:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21807 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2DCCUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:20:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 14/14] IOMMU: Add intel iommu irq-remapping and dmar hotplug support
Date: Mon,  2 Apr 2012 19:19:41 -0700
Message-Id: <1333419581-7836-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090205.4F7A5E52.0083,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will use acpi_pci_driver to parse and init them between pci root bus scanning
and start.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/iommu/dmar.c |  218 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 218 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index f96b8ce..918a063 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -36,6 +36,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <acpi/acpi.h>
 #include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
@@ -1480,3 +1481,220 @@ int __init dmar_ir_support(void)
 	return dmar->flags & 0x1;
 }
 IOMMU_INIT_POST(detect_intel_iommu);
+
+#ifdef CONFIG_HOTPLUG
+static u8 dmar_uuid_str[] = "D8C1A3A6-BE9B-4C9B-91BF-C3CB81FC5DAF";
+
+static int acpi_dmar_dsm_support(acpi_handle handle)
+{
+	int support = 0;
+	struct acpi_dsm_context context = {
+		.uuid_str = dmar_uuid_str,
+		.rev = 1,
+		.func_idx = 0,
+	};
+
+	if (ACPI_SUCCESS(acpi_run_dsm(handle, &context))) {
+		u32 *ret = context.ret.pointer;
+		support = ret[0];
+		kfree(context.ret.pointer);
+	}
+
+	if (support & 1)
+		return support & 0x0e;
+
+	return 0;
+}
+
+static void *acpi_dmar_dsm_run(acpi_handle handle, int idx)
+{
+	struct acpi_dsm_context context = {
+		.uuid_str = dmar_uuid_str,
+		.rev = 1,
+		.func_idx = idx,
+	};
+
+	if (ACPI_SUCCESS(acpi_run_dsm(handle, &context)))
+		return context.ret.pointer;
+
+	return NULL;
+}
+
+static void handle_iommu_add(acpi_handle handle, void **d, void **a)
+{
+	int support;
+	struct acpi_dmar_header *header;
+	struct dmar_drhd_unit *dmaru = NULL;
+	struct dmar_atsr_unit *atsru = NULL;
+
+	*d = NULL;
+	*a = NULL;
+
+	support = acpi_dmar_dsm_support(handle);
+
+	if (!support)
+		return;
+
+	/* DRHD */
+	if (support & (1<<1)) {
+		header = acpi_dmar_dsm_run(handle, 1);
+		dmar_table_print_dmar_entry(header);
+		__dmar_parse_one_drhd(header, &dmaru);
+	}
+
+	if (!dmaru)
+		return;
+
+	/* ATSR */
+	if (support & (1<<2)) {
+		header = acpi_dmar_dsm_run(handle, 2);
+		dmar_table_print_dmar_entry(header);
+		__dmar_parse_one_atsr(header, &atsru);
+	}
+
+	/* RHSA */
+	if (support & (1<<3)) {
+		header = acpi_dmar_dsm_run(handle, 3);
+		dmar_table_print_dmar_entry(header);
+		dmar_parse_one_rhsa(header);
+		kfree(header);
+	}
+
+	/*
+	 *  only need to init intr_remap and dmar for hot-add ones
+	 *  after enable_IR() or pci_iommu_init
+	 */
+	/*
+	 * TODO: handle parsing failure for pre-installed hotplug one
+	 *	Could make every parse_one duplicate the entry table?
+	 */
+	if (irq_remapping_enabled == 1)
+		intel_enable_irq_remapping_one(dmaru);
+	if (irq_remapping_enabled == 1 || intel_iommu_enabled == 1)
+		dmar_parse_dev(dmaru);
+	if (intel_iommu_enabled == 1) {
+		init_dmar_one(dmaru);
+		if (atsru) {
+			header = atsru->hdr;
+			if (atsr_parse_dev(atsru)) {
+				kfree(header);
+				atsru = NULL;
+			}
+			*a = atsru;
+		}
+	}
+	*d = dmaru;
+}
+
+static void handle_iommu_remove(void *drhd, void *atsr)
+{
+	struct dmar_drhd_unit *dmaru = drhd;
+	struct dmar_atsr_unit *atsru = atsr;
+
+	if (!dmaru)
+		return;
+
+	if (irq_remapping_enabled == 1)
+		disable_irq_remapping_one(dmaru);
+	if (intel_iommu_enabled == 1) {
+		free_dmar_iommu(dmaru->iommu);
+		if (atsru) {
+			kfree(atsru->devices);
+			remove_atsru_from_saved_dev_atsru_list(atsru);
+		}
+	}
+	if (irq_remapping_enabled == 1 || intel_iommu_enabled == 1) {
+		kfree(dmaru->devices);
+		remove_dmaru_from_saved_dev_drhd_list(dmaru);
+	}
+	if (atsru) {
+		kfree(atsru->hdr);
+		list_del(&atsru->list);
+		kfree(atsru);
+	}
+	free_iommu(dmaru->iommu);
+	kfree(dmaru->hdr);
+	list_del(&dmaru->list);
+	kfree(dmaru);
+}
+
+struct acpi_pci_iommu {
+	acpi_handle root_handle;
+	void *dmaru;
+	void *atsru;
+	struct list_head list;
+};
+
+static LIST_HEAD(iommu_list);
+static DEFINE_MUTEX(iommu_list_lock);
+
+static acpi_status register_iommu(acpi_handle handle, u32 lvl,
+				  void *context, void **rv)
+{
+	acpi_handle root_handle = context;
+	void *dmaru, *atsru;
+	struct acpi_pci_iommu *iommu;
+
+	handle_iommu_add(handle, &dmaru, &atsru);
+	if (!dmaru)
+		return AE_OK;
+
+	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
+	if (!iommu) {
+		printk(KERN_ERR "%s: cannot allocate memory\n", __func__);
+		handle_iommu_remove(dmaru, atsru);
+		return AE_OK;
+	}
+	iommu->root_handle = root_handle;
+	iommu->dmaru = dmaru;
+	iommu->atsru = atsru;
+
+	mutex_lock(&iommu_list_lock);
+	list_add(&iommu->list, &iommu_list);
+	mutex_unlock(&iommu_list_lock);
+
+	return AE_OK;
+}
+
+static int acpi_pci_iommu_add(acpi_handle handle)
+{
+	acpi_status status;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				     register_iommu, NULL, handle, NULL);
+	if (ACPI_FAILURE(status))
+		printk(KERN_ERR "%s: register_iommu failure - %d", __func__,
+			status);
+
+	return status;
+}
+
+static void acpi_pci_iommu_remove(acpi_handle handle)
+{
+	struct acpi_pci_iommu *iommu, *tmp;
+
+	mutex_lock(&iommu_list_lock);
+	list_for_each_entry_safe(iommu, tmp, &iommu_list, list) {
+		if (handle != iommu->root_handle)
+			continue;
+		list_del(&iommu->list);
+		handle_iommu_remove(iommu->dmaru, iommu->atsru);
+		kfree(iommu);
+	}
+	mutex_unlock(&iommu_list_lock);
+}
+
+static struct acpi_pci_driver acpi_pci_iommu_driver = {
+	.add = acpi_pci_iommu_add,
+	.remove = acpi_pci_iommu_remove,
+};
+
+static int __init acpi_pci_iommu_init(void)
+{
+	acpi_pci_register_driver(&acpi_pci_iommu_driver);
+
+	return 0;
+}
+
+subsys_initcall(acpi_pci_iommu_init);
+#endif
-- 
1.7.7

