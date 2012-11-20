Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2KTGdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:33:35 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:29203 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KTGdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:33:33 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] AER-PCI: Add infrastructure for notification of errors
 to other subsystems
Thread-Topic: [PATCH 1/4] AER-PCI: Add infrastructure for notification of
 errors to other subsystems
Thread-Index: AQHNxujB/Xyzo5mhSk2u1XfRKKc16Q==
Date: Tue, 20 Nov 2012 06:32:04 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90146FCE3@G4W3208.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Adds infrastructure support for error notifications from AER subsystem
to other subsystems. The generic notifier_chain functionality is used.

- When the AER rootport driver detects an uncorrected error, invoke the
callbacks registered for notifications as well as mark the device as
tainted.

- After the recovery is successful, clear the tainted flag on the device.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>

---
 drivers/pci/pcie/aer/aerdrv.c      | 20 ++++++++++++++++++++
 drivers/pci/pcie/aer/aerdrv_core.c |  9 ++++++++-
 include/linux/aer.h                |  4 ++++
 include/linux/pci.h                |  2 ++
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index 030cf12..92dc54c 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -68,6 +68,26 @@ static struct pcie_port_service_driver aerdriver = {
 
 static int pcie_aer_disable;
 
+ATOMIC_NOTIFIER_HEAD(aer_notifier_list);
+
+void aer_notifier_register(struct notifier_block *nb)
+{
+	atomic_notifier_chain_register(&aer_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(aer_notifier_register);
+
+void aer_notifier_unregister(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&aer_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(aer_notifier_unregister);
+
+void aer_notify(unsigned long val, void *v)
+{
+	atomic_notifier_call_chain(&aer_notifier_list, val, v);
+}
+EXPORT_SYMBOL_GPL(aer_notify);
+
 void pci_no_aer(void)
 {
 	pcie_aer_disable = 1;	/* has priority over 'forceload' */
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index af4e31c..be6c3ee 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -215,6 +215,8 @@ static int report_error_detected(struct pci_dev *dev, void *data)
 
 	device_lock(&dev->dev);
 	dev->error_state = result_data->state;
+	dev->dev_flags |= PCI_DEV_FLAGS_ERR_DETECTED;
+	aer_notify(0, NULL);
 
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
@@ -291,6 +293,7 @@ static int report_resume(struct pci_dev *dev, void *data)
 
 	device_lock(&dev->dev);
 	dev->error_state = pci_channel_io_normal;
+	dev->dev_flags &= ~PCI_DEV_FLAGS_ERR_DETECTED;
 
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
@@ -521,6 +524,7 @@ static void do_recovery(struct pci_dev *dev, int severity)
 				"resume",
 				report_resume);
 
+	dev->dev_flags &= ~PCI_DEV_FLAGS_ERR_DETECTED;
 	dev_info(&dev->dev, "AER: Device recovery successful\n");
 	return;
 
@@ -552,8 +556,11 @@ static void handle_error_source(struct pcie_device *aerdev,
 		if (pos)
 			pci_write_config_dword(dev, pos + PCI_ERR_COR_STATUS,
 					info->status);
-	} else
+	} else {
+		dev->dev_flags |= PCI_DEV_FLAGS_ERR_DETECTED;
+		aer_notify(0, NULL);
 		do_recovery(dev, info->severity);
+	}
 }
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
diff --git a/include/linux/aer.h b/include/linux/aer.h
index 544abdb..f8df468 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -54,5 +54,9 @@ extern void cper_print_aer(const char *prefix, int cper_severity,
 extern int cper_severity_to_aer(int cper_severity);
 extern void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
 			      int severity);
+extern void aer_notifier_register(struct notifier_block *nb);
+extern void aer_notifier_unregister(struct notifier_block *nb);
+extern void aer_notify(unsigned long val, void *v);
+
 #endif //_AER_H_
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ee21795..ab17a08 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -155,6 +155,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_D3 = (__force pci_dev_flags_t) 2,
 	/* Provide indication device is assigned by a Virtual Machine Manager */
 	PCI_DEV_FLAGS_ASSIGNED = (__force pci_dev_flags_t) 4,
+	/* Indicates that hw has reported an uncorrected error for the device */
+	PCI_DEV_FLAGS_ERR_DETECTED = (__force pci_dev_flags_t) 8,
 };
 
 enum pci_irq_reroute_variant {
-- 
1.7.11.3

