Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2IODOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:14:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2IODNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:13:55 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tony Luck <tony.luck@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>
Subject: [PATCH v2 9/9] PCI/AER: update AER configuration when PCI hotplug event happens
Date: Sat, 15 Sep 2012 11:05:12 +0800
Message-Id: <1347678312-11124-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com>
References: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

The AER driver only configures downstream PCIe devices at driver
binding time and all hot-added PCIe devices won't be managed by
the AER driver.  So hook PCIe device hotplug events to setup AER
configuration for hot-added PCIe devices.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/pcie/aer/aerdrv.c |   63 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index 030cf12..b70ec84 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -408,6 +408,55 @@ static void aer_error_resume(struct pci_dev *dev)
 	pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_STATUS, status);
 }
 
+static void acpi_pcie_aer_notify_dev(struct pcie_device *dev, bool enable)
+{
+	int rc, pos;
+	u32 val = 0;
+	struct pci_dev *pdev = dev->port;
+
+	if (dev->service != PCIE_PORT_SERVICE_AER)
+		return;
+	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT)
+		return;
+	while (pci_pcie_type(pdev) != PCI_EXP_TYPE_ROOT_PORT) {
+		pdev = pdev->bus->self;
+		if (!pdev)
+			return;
+	}
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return;
+	rc = pci_read_config_dword(pdev, pos + PCI_ERR_ROOT_COMMAND, &val);
+	if (rc || val == 0xFFFFFFFF || !(val & ROOT_PORT_INTR_ON_MESG_MASK))
+		return;
+
+	set_device_error_reporting(dev->port, &enable);
+}
+
+static int acpi_pcie_aer_notify(struct notifier_block *nb,
+		unsigned long event, void *data)
+{
+	struct device *dev = data;
+
+	switch (event) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		acpi_pcie_aer_notify_dev(to_pcie_device(dev), true);
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		acpi_pcie_aer_notify_dev(to_pcie_device(dev), false);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block acpi_pcie_aer_notifier = {
+	.notifier_call = &acpi_pcie_aer_notify,
+};
+
 /**
  * aer_service_init - register AER root service driver
  *
@@ -415,9 +464,20 @@ static void aer_error_resume(struct pci_dev *dev)
  */
 static int __init aer_service_init(void)
 {
+	int ret;
+
 	if (!pci_aer_available() || aer_acpi_firmware_first())
 		return -ENXIO;
-	return pcie_port_service_register(&aerdriver);
+
+	ret = pcie_port_service_register(&aerdriver);
+	if (!ret) {
+		ret = bus_register_notifier(&pcie_port_bus_type,
+					    &acpi_pcie_aer_notifier);
+		if (ret)
+			pcie_port_service_unregister(&aerdriver);
+	}
+
+	return ret;
 }
 
 /**
@@ -427,6 +487,7 @@ static int __init aer_service_init(void)
  */
 static void __exit aer_service_exit(void)
 {
+	bus_unregister_notifier(&pcie_port_bus_type, &acpi_pcie_aer_notifier);
 	pcie_port_service_unregister(&aerdriver);
 }
 
-- 
1.7.9.5

