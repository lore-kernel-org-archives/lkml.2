Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2KJHoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 02:44:46 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:2507 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2KJHoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 02:44:44 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: "bhelgaas@google.com" <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        Myron Stowe <myron.stowe@gmail.com>
Subject: [ PATCH RESEND ] PCI-AER: Do not report successful error recovery
 for devices with AER-unaware drivers
Thread-Topic: [ PATCH RESEND ] PCI-AER: Do not report successful error
 recovery for devices with AER-unaware drivers
Thread-Index: AQHNvxa8hUTykftZIUuYHm9OnADUUw==
Date: Sat, 10 Nov 2012 07:41:04 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90146794E@G9W0717.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.22]
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

The changes proposed here leaves the device in an unrecovered state
if the driver for the device or for any function in a multi-function
card does not have error handler structure registered. This reflects
the true state of the device and prevents any partial recovery (or no
recovery at all) reported as successful.

Please also see comments from Linas Vepstas at the following link
http://www.spinics.net/lists/linux-pci/msg18572.html

Reviewed-by: Linas Vepstas <linasvepstas <at> gmail.com>
Reviewed-by: Myron Stowe <mstowe <at> redhat.com>
Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil <at> hp.com>

---

drivers/pci/pcie/aer/aerdrv_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 06bad96..030b229 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -215,6 +215,12 @@ static int report_error_detected(struct pci_dev *dev, void *data)
 
 	dev->error_state = result_data->state;
 
+	if ((!dev->driver || !dev->driver->err_handler) &&
+		!(dev->hdr_type & PCI_HEADER_TYPE_BRIDGE)) {
+		dev_info(&dev->dev, "AER: Error detected but no driver has claimed this device or the driver is AER-unaware\n");
+		result_data->result = PCI_ERS_RESULT_NONE;
+		return 1;
+	}
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->error_detected) {
