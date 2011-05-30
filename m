Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1E3LV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:21:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:39331 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab1E3LV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:21:56 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH v2] 8250_pci: add -ENODEV code for Intel EG20T PCH
Date: Mon, 30 May 2011 20:26:16 +0900
Message-Id: <1306754776-8077-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel EG20T PCH has UART device which is compatible with 8250.
Currently, with general configuration, the PCH UART driver is not loaded but
8250 standard driver is loaded.
Therefore, in case of using PCH UART driver, need to disable 8250 pci function.
However, this procedure is not best solution.

This patch, in 8250_pci, if the device is the PCH or the family IOH,
'-ENODEV' is returned.
As a result, disabling 8250-pci processing becomes unnecessary.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
V2: Delete #ifdef CONFIG_SERIAL_PCH_UART ~ #endif
    Use quirk table structure
---
 drivers/tty/serial/8250_pci.c |   54 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 738cec9..39c0d62 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -2541,6 +2541,53 @@ void pciserial_resume_ports(struct serial_private *priv)
 }
 EXPORT_SYMBOL_GPL(pciserial_resume_ports);
 
+static struct pci_serial_quirk eg20t_pch_uart[] __refdata = {
+	{
+		.vendor         = PCI_VENDOR_ID_INTEL,
+		.device         = 0x8811,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_INTEL,
+		.device         = 0x8812,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_INTEL,
+		.device         = 0x8813,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_INTEL,
+		.device         = 0x8814,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x8027,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x8028,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x8029,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x800C,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x800D,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x800D,
+	},
+	{
+		.vendor         = PCI_ANY_ID,
+		.device         = PCI_ANY_ID,
+	},
+};
+
 /*
  * Probe one serial board.  Unfortunately, there is no rhyme nor reason
  * to the arrangement of serial ports on a PCI card.
@@ -2552,6 +2599,7 @@ pciserial_init_one(struct pci_dev *dev, const struct pci_device_id *ent)
 	const struct pciserial_board *board;
 	struct pciserial_board tmp;
 	int rc;
+	int i;
 
 	if (ent->driver_data >= ARRAY_SIZE(pci_boards)) {
 		printk(KERN_ERR "pci_init_one: invalid driver_data: %ld\n",
@@ -2559,6 +2607,12 @@ pciserial_init_one(struct pci_dev *dev, const struct pci_device_id *ent)
 		return -EINVAL;
 	}
 
+	for (i = 0; eg20t_pch_uart[i].vendor != PCI_ANY_ID; i++) {
+		if (dev->vendor == eg20t_pch_uart[i].vendor &&
+		    dev->device == eg20t_pch_uart[i].device)
+			return -ENODEV;
+	}
+
 	board = &pci_boards[ent->driver_data];
 
 	rc = pci_enable_device(dev);
-- 
1.7.4

