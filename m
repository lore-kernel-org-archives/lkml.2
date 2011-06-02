Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab1FBC1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 22:27:16 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26988 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759221Ab1FBC1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 22:27:15 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH v5] 8250_pci: add -ENODEV code for Intel EG20T PCH
Date: Thu,  2 Jun 2011 11:31:29 +0900
Message-Id: <1306981890-3281-1-git-send-email-tomoya-linux@dsn.okisemi.com>
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
V5: Rename own_init again.
    return_ENODEV() to pci_eg20t_init()

V4: Rename own_init to return_ENODEV
    Add #if defined ~ #endif

V3: add own init() and set the init() to quirk table.

V2: Delete #ifdef CONFIG_SERIAL_PCH_UART ~ #endif
    Use quirk table structure
---
 drivers/tty/serial/8250_pci.c |   59 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 738cec9..2b40fbf 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -988,6 +988,15 @@ static int skip_tx_en_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
+static int pci_eg20t_init(struct pci_dev *dev)
+{
+#if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
+	return -ENODEV;
+#else
+	return 0;
+#endif
+}
+
 /* This should be in linux/pci_ids.h */
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
@@ -1430,6 +1439,56 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.init		= pci_oxsemi_tornado_init,
 		.setup		= pci_default_setup,
 	},
+	{
+		.vendor         = PCI_VENDOR_ID_INTEL,
+		.device         = 0x8811,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_INTEL,
+		.device         = 0x8812,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_INTEL,
+		.device         = 0x8813,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_INTEL,
+		.device         = 0x8814,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x8027,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x8028,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x8029,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x800C,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x800D,
+		.init		= pci_eg20t_init,
+	},
+	{
+		.vendor         = 0x10DB,
+		.device         = 0x800D,
+		.init		= pci_eg20t_init,
+	},
 	/*
 	 * Default "match everything" terminator entry
 	 */
-- 
1.7.4

