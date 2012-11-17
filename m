Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab2KQLtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 06:49:40 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:21267 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2KQLti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 06:49:38 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        Myron Stowe <myron.stowe@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Patterson, Andrew D (LeftHand Networks)" <andrew.patterson@hp.com>,
        "Zhang Yanmin" <yanmin.zhang@intel.com>
Subject: [PATCH v3] PCI-AER: Do not report successful error recovery for
 devices with AER-unaware drivers
Thread-Topic: [PATCH v3] PCI-AER: Do not report successful error recovery
 for devices with AER-unaware drivers
Thread-Index: AQHNxLlMB2gqX9CkQEKNBgETX4uTyA==
Date: Sat, 17 Nov 2012 11:47:18 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90146A2F8@G9W0717.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an error is detected on a PCIe device which does not have an
AER-aware driver, prevent AER infrastructure from reporting
successful error recovery.

This is because the report_error_detected() function that gets
called in the first phase of recovery process allows forward
progress even when the driver for the device does not have AER
capabilities. It seems that all callbacks (in pci_error_handlers
structure) registered by drivers that gets called during error
recovery are not mandatory. So the intention of the infrastructure
design seems to be to allow forward progress even when a specific
callback has not been registered by a driver. However, if error
handler structure itself has not been registered, it doesn't make
sense to allow forward progress.

As a result of the current design, in the case of a single device
having an AER-unaware driver or in the case of any function in a
multi-function card having an AER-unaware driver, a successful
recovery is reported.

Typical scenario this happens is when a PCI device is detached
from a KVM host and the pci-stub driver on the host claims the
device. The pci-stub driver does not have error handling capabilities
but the AER infrastructure still reports that the device recovered
successfully.

The changes proposed here leaves the device(s)in an unrecovered state
if the driver for the device or for any device in the subtree
does not have error handler structure registered. This reflects
the true state of the device and prevents any partial recovery (or no
recovery at all) reported as successful.


v3:
  - Fixed a checkpatch/build issue

v2:
  - Made changes so that all devices in the subtree have the error
    state set correctly.


Reviewed-by: Linas Vepstas <linasvepstas <at> gmail.com>
Reviewed-by: Myron Stowe <mstowe <at> redhat.com>
Reviewed-by: Bjorn Helgaas <bhelgaas <at> google.com>
Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/pci/pcie/aer/aerdrv.h      |  5 ++++-
 drivers/pci/pcie/aer/aerdrv_core.c | 21 ++++++++++++++++++---
 include/linux/pci.h                |  3 +++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv.h b/drivers/pci/pcie/aer/aerdrv.h
index 94a7598..22f840f 100644
--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -87,6 +87,9 @@ struct aer_broadcast_data {
 static inline pci_ers_result_t merge_result(enum pci_ers_result orig,
 		enum pci_ers_result new)
 {
+	if (new == PCI_ERS_RESULT_NO_AER_DRIVER)
+		return PCI_ERS_RESULT_NO_AER_DRIVER;
+
 	if (new == PCI_ERS_RESULT_NONE)
 		return orig;
 
@@ -97,7 +100,7 @@ static inline pci_ers_result_t merge_result(enum pci_ers_result orig,
 		break;
 	case PCI_ERS_RESULT_DISCONNECT:
 		if (new == PCI_ERS_RESULT_NEED_RESET)
-			orig = new;
+			orig = PCI_ERS_RESULT_NEED_RESET;
 		break;
 	default:
 		break;
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 9f80cb0..b67f91a 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -232,11 +232,26 @@ static int report_error_detected(struct pci_dev *dev, void *data)
 				   dev->driver ?
 				   "no AER-aware driver" : "no driver");
 		}
-		return 0;
+
+		/*
+		 * If there's any device in the subtree that does not
+		 * have an error_detected callback, returning
+		 * PCI_ERS_RESULT_NO_AER_DRIVER prevents calling of
+		 * the subsequent mmio_enabled/slot_reset/resume
+		 * callbacks of "any" device in the subtree. All the
+		 * devices in the subtree are left in the error state
+		 * without recovery.
+		 */
+
+		if (!(dev->hdr_type & PCI_HEADER_TYPE_BRIDGE))
+			vote = PCI_ERS_RESULT_NO_AER_DRIVER;
+		else
+			vote = PCI_ERS_RESULT_NONE;
+	} else {
+		err_handler = dev->driver->err_handler;
+		vote = err_handler->error_detected(dev, result_data->state);
 	}
 
-	err_handler = dev->driver->err_handler;
-	vote = err_handler->error_detected(dev, result_data->state);
 	result_data->result = merge_result(result_data->result, vote);
 	return 0;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ab17a08..c458602 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -540,6 +540,9 @@ enum pci_ers_result {
 
 	/* Device driver is fully recovered and operational */
 	PCI_ERS_RESULT_RECOVERED = (__force pci_ers_result_t) 5,
+
+	/* No AER capabilities registered for the driver */
+	PCI_ERS_RESULT_NO_AER_DRIVER = (__force pci_ers_result_t) 6,
 };
 
 /* PCI bus error event callbacks */
-- 
1.7.11.3

