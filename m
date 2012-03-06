Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab2CFHQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:16:52 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:32102 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466Ab2CFHQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:16:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 18/23] PCI, ACPI: add acpi_pci_root_rescan()
Date: Mon,  5 Mar 2012 23:13:55 -0800
Message-Id: <1331018040-30725-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F55B9E0.000F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it will rescan all acpi pci root if related pci root bus get removed before.

Signed-off-by: Yinghai <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index b38e347..e1814e0 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -679,3 +679,55 @@ static int __init acpi_pci_root_init(void)
 }
 
 subsys_initcall(acpi_pci_root_init);
+
+static acpi_status
+rescan_root_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	struct acpi_device *device, *pdevice;
+	struct acpi_pci_root *root;
+	acpi_handle phandle;
+	int ret_val;
+
+	if (!acpi_is_root_bridge(handle))
+		return AE_OK;
+
+	acpi_get_parent(handle, &phandle);
+	if (acpi_bus_get_device(phandle, &pdevice)) {
+		printk(KERN_DEBUG "no parent device, assuming NULL\n");
+		pdevice = NULL;
+	}
+
+	if (!acpi_bus_get_device(handle, &device)) {
+		/* check if  pci root_bus is removed */
+		root = acpi_driver_data(device);
+		if (pci_find_bus(root->segment, root->secondary.start))
+			return AE_OK;
+
+		printk(KERN_DEBUG "bus exists... trim\n");
+		/* this shouldn't be in here, so remove
+		 * the bus then re-add it...
+		 */
+		ret_val = acpi_bus_trim(device, 1);
+		printk(KERN_DEBUG "acpi_bus_trim return %x\n", ret_val);
+	}
+
+	ret_val = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
+	if (ret_val) {
+		printk(KERN_ERR "error adding bus, %x\n", -ret_val);
+		goto out;
+	}
+
+	root = acpi_driver_data(device);
+	pci_assign_unassigned_bus_resources(root->bus);
+
+	ret_val = acpi_bus_start(device);
+
+out:
+	return ret_val;
+}
+
+void acpi_pci_root_rescan(void)
+{
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+		ACPI_UINT32_MAX, rescan_root_bridge, NULL, NULL, NULL);
+}
-- 
1.7.7

