Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab0KQPfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:35:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58114 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab0KQPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:35:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZbVk90Rw7z0U3lXL3efLS/guhrl9PDYJGVcvfUzI3wOboLoO2W31peYpLLV+FusYaE
         o0PrbOrZriTc6WPemKKBa29wuiX+w7bidfhO/57L6Qxre5GrLN1SecXMRnFCZx3Z/3NZ
         hEKyegsvI1Np8sd92ZT5ilb1cAt1IlTGtLnKc=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, dirk.brandewie@gmail.com, linux-serial@vger.kernel.org
Subject: [PATCH] serial/ce4100: Add PCI UART support for the ce4100
Date: Wed, 17 Nov 2010 07:35:20 -0800
Message-Id: <1290008120-3158-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <654d0e8f80dd959fd9c871ad1644126d58b2445b.1289331834.git.dirk.brandewie@gmail.com>
References: <654d0e8f80dd959fd9c871ad1644126d58b2445b.1289331834.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch adds support for the PCI UART on the ce4100.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linux-serial@vger.kernel.org
---
 drivers/serial/8250_pci.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 53be4d3..e30356d 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -957,6 +957,22 @@ pci_default_setup(struct serial_private *priv,
 	return setup_port(priv, port, bar, offset, board->reg_shift);
 }
 
+static int
+ce4100_serial_setup(struct serial_private *priv,
+		  const struct pciserial_board *board,
+		  struct uart_port *port, int idx)
+{
+	int ret;
+
+	ret = setup_port(priv, port, 0, 0, board->reg_shift);
+	port->iotype = UPIO_MEM32;
+	port->type = PORT_XSCALE;
+	port->flags = (port->flags | UPF_FIXED_PORT | UPF_FIXED_TYPE);
+	port->regshift = 2;
+
+	return ret;
+}
+
 static int skip_tx_en_setup(struct serial_private *priv,
 			const struct pciserial_board *board,
 			struct uart_port *port, int idx)
@@ -981,6 +997,7 @@ static int skip_tx_en_setup(struct serial_private *priv,
 #define PCI_SUBDEVICE_ID_POCTAL232	0x0308
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe
+#define PCI_DEVICE_ID_INTEL_CE4100_UART 0x2e66
 #define PCI_DEVICE_ID_ADVANTECH_PCI3620	0x3620
 #define PCI_DEVICE_ID_TITAN_200I	0x8028
 #define PCI_DEVICE_ID_TITAN_400I	0x8048
@@ -1072,6 +1089,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice	= PCI_ANY_ID,
 		.setup		= skip_tx_en_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_CE4100_UART,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= ce4100_serial_setup,
+	},
 	/*
 	 * ITE
 	 */
@@ -1592,6 +1616,7 @@ enum pci_board_num_t {
 	pbn_ADDIDATA_PCIe_2_3906250,
 	pbn_ADDIDATA_PCIe_4_3906250,
 	pbn_ADDIDATA_PCIe_8_3906250,
+	pbn_ce4100_1_115200,
 };
 
 /*
@@ -2281,6 +2306,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.uart_offset	= 0x200,
 		.first_offset	= 0x1000,
 	},
+	[pbn_ce4100_1_115200] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.reg_shift      = 2,
+	},
 };
 
 static const struct pci_device_id softmodem_blacklist[] = {
@@ -3760,6 +3791,11 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
 		0xA000, 0x3004,
 		0, 0, pbn_b0_bt_4_115200 },
+	/* Intel CE4100 */
+	{	PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CE4100_UART,
+		PCI_ANY_ID,  PCI_ANY_ID, 0, 0,
+		pbn_ce4100_1_115200 },
+
 
 	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
-- 
1.7.2.3

