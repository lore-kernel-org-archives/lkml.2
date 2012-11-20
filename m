Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2KTGdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:33:43 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:29277 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2KTGdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:33:39 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] AER-GHES: Add support for error notification in
 firmware first approach of AER
Thread-Topic: [PATCH 2/4] AER-GHES: Add support for error notification in
 firmware first approach of AER
Thread-Index: AQHNxujFpQ+48gO/yEWDAkIhfHojIQ==
Date: Tue, 20 Nov 2012 06:32:11 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90146FCEE@G4W3208.americas.hpqcorp.net>
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

    - When an uncorrected recoverable error is reported via an NMI in the
    firmware first model of AER, invoke the callbacks registered for
    notifications as well as mark the device as tainted.

    - Add a new function ghes_mark_dev_err() leveraged from ghes_do_proc()
    to identify the device from the error record and mark it as tainted.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/acpi/apei/ghes.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 1599566..7b077a7 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -502,6 +502,45 @@ static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
 	}
 }
 
+/*
+ * If an uncorrected recoverable PCIe error is reported, the corresponding
+ * PCI device is marked as tainted. The device remains tainted until the
+ * claiming driver does a recovery. The PCI device is identified from the
+ * error record.
+ */
+static void ghes_mark_dev_err(const struct acpi_hest_generic_status *estatus)
+{
+	int sev, sec_sev;
+	struct acpi_hest_generic_data *gdata;
+
+	sev = ghes_severity(estatus->error_severity);
+	apei_estatus_for_each_section(estatus, gdata) {
+		sec_sev = ghes_severity(gdata->error_severity);
+		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
+				      CPER_SEC_PCIE)) {
+			struct cper_sec_pcie *pcie_err;
+			pcie_err = (struct cper_sec_pcie *)(gdata+1);
+			if (sev == GHES_SEV_RECOVERABLE &&
+					sec_sev == GHES_SEV_RECOVERABLE &&
+					pcie_err->validation_bits &
+						CPER_PCIE_VALID_DEVICE_ID &&
+					pcie_err->validation_bits &
+						CPER_PCIE_VALID_AER_INFO) {
+				unsigned int devfn;
+				struct pci_dev *pdev;
+				devfn = PCI_DEVFN(pcie_err->device_id.device,
+						  pcie_err->device_id.function);
+				pdev = pci_get_domain_bus_and_slot(
+						pcie_err->device_id.segment,
+						pcie_err->device_id.bus,
+						devfn);
+				if (!pdev)
+					continue;
+				pdev->dev_flags |= PCI_DEV_FLAGS_ERR_DETECTED;
+			}
+		}
+	}
+}
 static void __ghes_print_estatus(const char *pfx,
 				 const struct acpi_hest_generic *generic,
 				 const struct acpi_hest_generic_status *estatus)
@@ -868,6 +907,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 			estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 			memcpy(estatus, ghes->estatus, len);
 			llist_add(&estatus_node->llnode, &ghes_estatus_llist);
+			ghes_mark_dev_err(estatus);
+			aer_notify(0, NULL);
 		}
 next:
 #endif
-- 
1.7.11.3

