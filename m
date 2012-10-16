Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2JPVQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:16:56 -0400
Received: from smarthost1.sentex.ca ([64.7.153.18]:24584 "EHLO
	smarthost1.sentex.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2JPVQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:16:55 -0400
X-Greylist: delayed 798 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 17:16:55 EDT
X-Qmail-Scanner-Mail-From: mghias@connecttech.com via vmail1.sentex.ca
X-Qmail-Scanner: 1.25 (Clear:RC:1(127.0.0.1):. Processed in 0.039648 secs)
From: "Muhammad Ghias" <mghias@connecttech.com>
To: "'Wolfgang Grandegger'" <wg@grandegger.com>,
        "'Marc Kleine-Budde'" <mkl@pengutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] CAN: sja1000: Add support for Connect Tech Inc's Canpro/104-Plus Opto CAN board
Date: Tue, 16 Oct 2012 17:03:35 -0400
Organization: Connect Tech Inc.
Message-ID: <02ac01cdabe1$b5403e10$1fc0ba30$@connecttech.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac2r4bPPpYdTFoH4QtqoT9nfc5JjQA==
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds support for CANpro/104-Plus Opto CAN board. Board uses PLX9030
bridge and two NXP SJA1000 CAN controllers. Patch is generated and tested
with kernel 3.6.1.

If you have any questions or any feedback please let me know.

Thanks,

Signed-off-by: Muhammad Ghias <mghias@connecttech.com>
---
diff -uprN -X linux-3.6.1-vanilla/Documentation/dontdiff
linux-3.6.1-vanilla/drivers/net/can/sja1000/Kconfig
linux-3.6.1/drivers/net/can/sja1000/Kconfig
--- linux-3.6.1-vanilla/drivers/net/can/sja1000/Kconfig	2012-10-07
11:41:28.000000000 -0400
+++ linux-3.6.1/drivers/net/can/sja1000/Kconfig	2012-10-16
10:04:46.000000000 -0400
@@ -93,6 +93,7 @@ config CAN_PLX_PCI
 	   - Marathon CAN-bus-PCI card (http://www.marathon.ru/)
 	   - TEWS TECHNOLOGIES TPMC810 card (http://www.tews.com/)
 	   - IXXAT Automation PC-I 04/PCI card (http://www.ixxat.com/)
+	   - Connect Tech Inc. CANpro/104-Plus Opto (CRG001) card
(http://www.connecttech.com)
 
 config CAN_TSCAN1
 	tristate "TS-CAN1 PC104 boards"
diff -uprN -X linux-3.6.1-vanilla/Documentation/dontdiff
linux-3.6.1-vanilla/drivers/net/can/sja1000/plx_pci.c
linux-3.6.1/drivers/net/can/sja1000/plx_pci.c
--- linux-3.6.1-vanilla/drivers/net/can/sja1000/plx_pci.c	2012-10-07
11:41:28.000000000 -0400
+++ linux-3.6.1/drivers/net/can/sja1000/plx_pci.c	2012-10-16
10:11:05.000000000 -0400
@@ -44,6 +44,7 @@ MODULE_SUPPORTED_DEVICE("Adlink PCI-7841
 			"esd CAN-PCI/CPCI/PCI104/200, "
 			"esd CAN-PCI/PMC/266, "
 			"esd CAN-PCIe/2000, "
+			"Connect Tech Inc. CANpro/104-Plus Opto (CRG001), "
 			"IXXAT PC-I 04/PCI")
 MODULE_LICENSE("GPL v2");
 
@@ -131,6 +132,9 @@ struct plx_pci_card {
 #define TEWS_PCI_VENDOR_ID		0x1498
 #define TEWS_PCI_DEVICE_ID_TMPC810	0x032A
 
+#define CTI_PCI_VENDOR_ID		0x12c4
+#define CTI_PCI_DEVICE_ID_CRG001	0x0900
+
 static void plx_pci_reset_common(struct pci_dev *pdev);
 static void plx_pci_reset_marathon(struct pci_dev *pdev);
 static void plx9056_pci_reset_common(struct pci_dev *pdev);
@@ -222,6 +226,14 @@ static struct plx_pci_card_info plx_pci_
 	/* based on PLX9030 */
 };
 
+static struct plx_pci_card_info plx_pci_card_info_cti __devinitdata = {
+	"Connect Tech Inc. CANpro/104-Plus Opto (CRG001)", 2,
+	PLX_PCI_CAN_CLOCK, PLX_PCI_OCR, PLX_PCI_CDR,
+	{0, 0x00, 0x00}, { {2, 0x000, 0x80}, {2, 0x100, 0x80} },
+	&plx_pci_reset_common
+	/* based on PLX9030 */
+};
+
 static DEFINE_PCI_DEVICE_TABLE(plx_pci_tbl) = {
 	{
 		/* Adlink PCI-7841/cPCI-7841 */
@@ -300,6 +312,13 @@ static DEFINE_PCI_DEVICE_TABLE(plx_pci_t
 		0, 0,
 		(kernel_ulong_t)&plx_pci_card_info_tews
 	},
+	{
+		/* Connect Tech Inc. CANpro/104-Plus Opto (CRG001) card */
+		PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
+		CTI_PCI_VENDOR_ID, CTI_PCI_DEVICE_ID_CRG001,
+		0, 0,
+		(kernel_ulong_t)&plx_pci_card_info_cti
+	},
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, plx_pci_tbl);

