Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0KITzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:55:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59798 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab0KITyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:54:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mbzMaI/knbxAl/F6hVFeQ6nmjweUZufPOsDZQ3KfTgWRh/nBRVJZ8MaEZoVYEOchGt
         eFg03/M1VFyHMhDskViX1raY+8QCfeoDyrUbGX/W00ER6FbRLADA5i9nFMhW9uQ2dyvS
         hgVQdljoHIYlm+wx6usSRdmZJg5EehOfeDtak=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, x86@kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH 3/6] serial/ce4100: Add PCI UART support for the ce4100
Date: Tue,  9 Nov 2010 12:08:06 -0800
Message-Id: <654d0e8f80dd959fd9c871ad1644126d58b2445b.1289331834.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289331834.git.dirk.brandewie@gmail.com>
References: <cover.1289331834.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch adds support for the PCI UART on the ce4100.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linux-serial@vger.kernel.org
---
 drivers/serial/8250_pci.c |   35 +++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h   |    1 +
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 53be4d3..f98da48 100644
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
@@ -1072,6 +1088,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
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
@@ -1592,6 +1615,7 @@ enum pci_board_num_t {
 	pbn_ADDIDATA_PCIe_2_3906250,
 	pbn_ADDIDATA_PCIe_4_3906250,
 	pbn_ADDIDATA_PCIe_8_3906250,
+	pbn_ce4100_1_115200,
 };
 
 /*
@@ -2281,6 +2305,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
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
@@ -3760,6 +3790,11 @@ static struct pci_device_id serial_pci_tbl[] = {
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
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c6bcfe9..8fc40b6 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2629,6 +2629,7 @@
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_ADDR_REV2  0x2db1
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2  0x2db2
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2    0x2db3
+#define PCI_DEVICE_ID_INTEL_CE4100_UART	0x2e66
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG4	0x3429
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG5	0x342a
-- 
1.7.2.3

