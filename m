Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab2FDFSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:18:49 -0400
Received: from szxga04-in.huawei.com ([58.251.152.67]:52176 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756252Ab2FDFSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:18:47 -0400
Date: Mon, 04 Jun 2012 13:17:02 +0800
From: Jiang Liu <jiang.liu@huawei.com>
Subject: [RFC PATCH v1 6/6] PCI: update AER configuration when PCI hotplug
 event happens
In-reply-to: <1338787022-400-1-git-send-email-jiang.liu@huawei.com>
X-Originating-IP: [10.107.208.49]
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-id: <1338787022-400-6-git-send-email-jiang.liu@huawei.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.msysgit.0
Content-type: text/plain
Content-transfer-encoding: 7BIT
X-CFilter-Loop: Reflected
References: <1338787022-400-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

The AER driver only configures downstream PCIe devices at driver
binding time and all hot-added PCIe devices won't be managed by
the AER driver.  So hook PCI device hotplug events to setup AER
configuration for hot-added PCIe devices.

So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
setup AER configuration for hot-added PCIe devices.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/pcie/aer/aerdrv.c |   72 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index 58ad791..7033410 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -410,6 +410,69 @@ static void aer_error_resume(struct pci_dev *dev)
 	pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_STATUS, status);
 }
 
+static int pci_root_port_aer_support(struct pci_dev *dev)
+{
+	int rc, pos;
+	u32 reg32 = 0;
+
+	if (!pci_is_pcie(dev))
+		return false;
+
+	if (!pci_aer_available() || aer_acpi_firmware_first())
+		return false;
+
+	/* Search for root port */
+	while (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT) {
+		dev = dev->bus->self;
+		if (!dev)
+			return false;
+	}
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	if (!pos)
+		return false;
+
+	rc = pci_read_config_dword(dev, pos + PCI_ERR_ROOT_COMMAND, &reg32);
+	if (rc || reg32 == 0xFFFFFFFF)
+		return false;
+
+	if (reg32 & (PCI_ERR_ROOT_CMD_COR_EN |
+		     PCI_ERR_ROOT_CMD_NONFATAL_EN |
+		     PCI_ERR_ROOT_CMD_FATAL_EN))
+		return true;
+
+	return false;
+}
+
+static void acpi_pcie_aer_notify_dev(struct pci_dev *dev, bool enable)
+{
+	if (pci_root_port_aer_support(dev))
+		set_device_error_reporting(dev, &enable);
+}
+
+static int acpi_pcie_aer_notify_fn(struct notifier_block *nb,
+		unsigned long event, void *data)
+{
+	struct device *dev = data;
+
+	switch (event) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		acpi_pcie_aer_notify_dev(to_pci_dev(dev), true);
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		acpi_pcie_aer_notify_dev(to_pci_dev(dev), false);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block acpi_pcie_aer_notifier = {
+	.notifier_call = &acpi_pcie_aer_notify_fn,
+};
+
 /**
  * aer_service_init - register AER root service driver
  *
@@ -417,9 +480,15 @@ static void aer_error_resume(struct pci_dev *dev)
  */
 static int __init aer_service_init(void)
 {
+	int ret;
+
 	if (!pci_aer_available() || aer_acpi_firmware_first())
 		return -ENXIO;
-	return pcie_port_service_register(&aerdriver);
+	ret = pcie_port_service_register(&aerdriver);
+	if (!ret)
+		bus_register_notifier(&pci_bus_type, &acpi_pcie_aer_notifier);
+
+	return ret;
 }
 
 /**
@@ -429,6 +498,7 @@ static int __init aer_service_init(void)
  */
 static void __exit aer_service_exit(void)
 {
+	bus_unregister_notifier(&pci_bus_type, &acpi_pcie_aer_notifier);
 	pcie_port_service_unregister(&aerdriver);
 }
 
-- 
1.7.1


