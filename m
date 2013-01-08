Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3AHQxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:53:10 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:36697 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab3AHQwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:52:54 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yijing Wang <wangyijing@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: [PATCH v3 6/6] PCI/AER: update AER configuration when PCI hotplug event happens
Date: Wed,  9 Jan 2013 00:52:25 +0800
Message-Id: <1357663945-16054-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
References: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
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
index 76ef634..d825c46 100644
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

