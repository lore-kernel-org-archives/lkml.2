Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1E3HiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:38:02 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:7641 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731Ab1E3HiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:38:00 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] 8250_pci: add -ENODEV code for Intel EG20T PCH
Date: Mon, 30 May 2011 16:42:04 +0900
Message-Id: <1306741324-4562-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel EG20T PCH has UART device which is compatible with 8250.
Currently, with general configuration, the PCH UART driver is not loaded but 8250 standard driver is loaded.
Therefore, in case of using PCH UART driver, need to disable 8250 pci function.
However, this procedure is not best solution.

This patch, in 8250_pci, if the device is the PCH or the family IOH,
'-ENODEV' is returned.
As a result, disabling 8250-pci processing becomes unnecessary.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/8250_pci.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 738cec9..2678d9d 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -2559,6 +2559,19 @@ pciserial_init_one(struct pci_dev *dev, const struct pci_device_id *ent)
 		return -EINVAL;
 	}
 
+#if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
+	if ((dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8811) ||
+	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8812) ||
+	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8813) ||
+	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8814) ||
+	   (dev->vendor == 0x10DB && dev->device == 0x8027) ||
+	   (dev->vendor == 0x10DB && dev->device == 0x8028) ||
+	   (dev->vendor == 0x10DB && dev->device == 0x8029) ||
+	   (dev->vendor == 0x10DB && dev->device == 0x800C) ||
+	   (dev->vendor == 0x10DB && dev->device == 0x800D))
+		return -ENODEV;
+#endif
+
 	board = &pci_boards[ent->driver_data];
 
 	rc = pci_enable_device(dev);
-- 
1.7.4

