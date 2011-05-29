Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1E2TQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:16:14 -0400
Received: from fallback-out2.mxes.net ([216.86.168.191]:57261 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756075Ab1E2TQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:16:12 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 May 2011 15:16:12 EDT
From: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Bri=C3=A8re?= <fbriere@fbriere.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-parport@lists.infradead.org
Subject: [PATCH 2/2] parport/serial: add support for Timedia/SUNIX cards to parport_serial
Date: Sun, 29 May 2011 15:08:04 -0400
Message-Id: <1306696084-17977-2-git-send-email-fbriere@fbriere.net>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1306696084-17977-1-git-send-email-fbriere@fbriere.net>
References: <1306696084-17977-1-git-send-email-fbriere@fbriere.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timedia/SUNIX PCI cards with both serial and parallel ports are
currently supported by 8250_pci and parport_pc individually.  Moving
that support into parport_serial allows using both types of ports at the
same time.

This was successfully tested with a SUNIX 4079T.

Signed-off-by: Frédéric Brière <fbriere@fbriere.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org
Cc: linux-parport@lists.infradead.org
---
 drivers/parport/parport_pc.c     |   54 -------------
 drivers/parport/parport_serial.c |  163 ++++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250_pci.c    |   23 ++++++
 3 files changed, 186 insertions(+), 54 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index f330338..d1cdb94 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2864,24 +2864,6 @@ enum parport_pc_pci_cards {
 	lava_parallel_dual_b,
 	boca_ioppar,
 	plx_9050,
-	timedia_4078a,
-	timedia_4079h,
-	timedia_4085h,
-	timedia_4088a,
-	timedia_4089a,
-	timedia_4095a,
-	timedia_4096a,
-	timedia_4078u,
-	timedia_4079a,
-	timedia_4085u,
-	timedia_4079r,
-	timedia_4079s,
-	timedia_4079d,
-	timedia_4079e,
-	timedia_4079f,
-	timedia_9079a,
-	timedia_9079b,
-	timedia_9079c,
 	timedia_4006a,
 	timedia_4014,
 	timedia_4008a,
@@ -2940,24 +2922,6 @@ static struct parport_pc_pci {
 	/* lava_parallel_dual_b */	{ 1, { { 0, -1 }, } },
 	/* boca_ioppar */		{ 1, { { 0, -1 }, } },
 	/* plx_9050 */			{ 2, { { 4, -1 }, { 5, -1 }, } },
-	/* timedia_4078a */		{ 1, { { 2, -1 }, } },
-	/* timedia_4079h */             { 1, { { 2, 3 }, } },
-	/* timedia_4085h */             { 2, { { 2, -1 }, { 4, -1 }, } },
-	/* timedia_4088a */             { 2, { { 2, 3 }, { 4, 5 }, } },
-	/* timedia_4089a */             { 2, { { 2, 3 }, { 4, 5 }, } },
-	/* timedia_4095a */             { 2, { { 2, 3 }, { 4, 5 }, } },
-	/* timedia_4096a */             { 2, { { 2, 3 }, { 4, 5 }, } },
-	/* timedia_4078u */             { 1, { { 2, -1 }, } },
-	/* timedia_4079a */             { 1, { { 2, 3 }, } },
-	/* timedia_4085u */             { 2, { { 2, -1 }, { 4, -1 }, } },
-	/* timedia_4079r */             { 1, { { 2, 3 }, } },
-	/* timedia_4079s */             { 1, { { 2, 3 }, } },
-	/* timedia_4079d */             { 1, { { 2, 3 }, } },
-	/* timedia_4079e */             { 1, { { 2, 3 }, } },
-	/* timedia_4079f */             { 1, { { 2, 3 }, } },
-	/* timedia_9079a */             { 1, { { 2, 3 }, } },
-	/* timedia_9079b */             { 1, { { 2, 3 }, } },
-	/* timedia_9079c */             { 1, { { 2, 3 }, } },
 	/* timedia_4006a */             { 1, { { 0, -1 }, } },
 	/* timedia_4014  */             { 2, { { 0, -1 }, { 2, -1 }, } },
 	/* timedia_4008a */             { 1, { { 0, 1 }, } },
@@ -3019,24 +2983,6 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 	  PCI_SUBVENDOR_ID_EXSYS, PCI_SUBDEVICE_ID_EXSYS_4014, 0, 0, plx_9050 },
 	/* PCI_VENDOR_ID_TIMEDIA/SUNIX has many differing cards ...*/
-	{ 0x1409, 0x7168, 0x1409, 0x4078, 0, 0, timedia_4078a },
-	{ 0x1409, 0x7168, 0x1409, 0x4079, 0, 0, timedia_4079h },
-	{ 0x1409, 0x7168, 0x1409, 0x4085, 0, 0, timedia_4085h },
-	{ 0x1409, 0x7168, 0x1409, 0x4088, 0, 0, timedia_4088a },
-	{ 0x1409, 0x7168, 0x1409, 0x4089, 0, 0, timedia_4089a },
-	{ 0x1409, 0x7168, 0x1409, 0x4095, 0, 0, timedia_4095a },
-	{ 0x1409, 0x7168, 0x1409, 0x4096, 0, 0, timedia_4096a },
-	{ 0x1409, 0x7168, 0x1409, 0x5078, 0, 0, timedia_4078u },
-	{ 0x1409, 0x7168, 0x1409, 0x5079, 0, 0, timedia_4079a },
-	{ 0x1409, 0x7168, 0x1409, 0x5085, 0, 0, timedia_4085u },
-	{ 0x1409, 0x7168, 0x1409, 0x6079, 0, 0, timedia_4079r },
-	{ 0x1409, 0x7168, 0x1409, 0x7079, 0, 0, timedia_4079s },
-	{ 0x1409, 0x7168, 0x1409, 0x8079, 0, 0, timedia_4079d },
-	{ 0x1409, 0x7168, 0x1409, 0x9079, 0, 0, timedia_4079e },
-	{ 0x1409, 0x7168, 0x1409, 0xa079, 0, 0, timedia_4079f },
-	{ 0x1409, 0x7168, 0x1409, 0xb079, 0, 0, timedia_9079a },
-	{ 0x1409, 0x7168, 0x1409, 0xc079, 0, 0, timedia_9079b },
-	{ 0x1409, 0x7168, 0x1409, 0xd079, 0, 0, timedia_9079c },
 	{ 0x1409, 0x7268, 0x1409, 0x0101, 0, 0, timedia_4006a },
 	{ 0x1409, 0x7268, 0x1409, 0x0102, 0, 0, timedia_4014 },
 	{ 0x1409, 0x7268, 0x1409, 0x0103, 0, 0, timedia_4008a },
diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
index f01e264..60c191d 100644
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -41,6 +41,24 @@ enum parport_pc_pci_cards {
 	siig_2p1s_20x,
 	siig_1s1p_20x,
 	siig_2s1p_20x,
+	timedia_4078a,
+	timedia_4079h,
+	timedia_4085h,
+	timedia_4088a,
+	timedia_4089a,
+	timedia_4095a,
+	timedia_4096a,
+	timedia_4078u,
+	timedia_4079a,
+	timedia_4085u,
+	timedia_4079r,
+	timedia_4079s,
+	timedia_4079d,
+	timedia_4079e,
+	timedia_4079f,
+	timedia_9079a,
+	timedia_9079b,
+	timedia_9079c,
 };
 
 /* each element directly indexed from enum list, above */
@@ -105,6 +123,24 @@ static struct parport_pc_pci cards[] __devinitdata = {
 	/* siig_2p1s_20x */		{ 2, { { 1, 2 }, { 3, 4 }, } },
 	/* siig_1s1p_20x */		{ 1, { { 1, 2 }, } },
 	/* siig_2s1p_20x */		{ 1, { { 2, 3 }, } },
+	/* timedia_4078a */		{ 1, { { 2, -1 }, } },
+	/* timedia_4079h */             { 1, { { 2, 3 }, } },
+	/* timedia_4085h */             { 2, { { 2, -1 }, { 4, -1 }, } },
+	/* timedia_4088a */             { 2, { { 2, 3 }, { 4, 5 }, } },
+	/* timedia_4089a */             { 2, { { 2, 3 }, { 4, 5 }, } },
+	/* timedia_4095a */             { 2, { { 2, 3 }, { 4, 5 }, } },
+	/* timedia_4096a */             { 2, { { 2, 3 }, { 4, 5 }, } },
+	/* timedia_4078u */             { 1, { { 2, -1 }, } },
+	/* timedia_4079a */             { 1, { { 2, 3 }, } },
+	/* timedia_4085u */             { 2, { { 2, -1 }, { 4, -1 }, } },
+	/* timedia_4079r */             { 1, { { 2, 3 }, } },
+	/* timedia_4079s */             { 1, { { 2, 3 }, } },
+	/* timedia_4079d */             { 1, { { 2, 3 }, } },
+	/* timedia_4079e */             { 1, { { 2, 3 }, } },
+	/* timedia_4079f */             { 1, { { 2, 3 }, } },
+	/* timedia_9079a */             { 1, { { 2, 3 }, } },
+	/* timedia_9079b */             { 1, { { 2, 3 }, } },
+	/* timedia_9079c */             { 1, { { 2, 3 }, } },
 };
 
 static struct pci_device_id parport_serial_pci_tbl[] = {
@@ -176,6 +212,25 @@ static struct pci_device_id parport_serial_pci_tbl[] = {
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_20x },
 	{ PCI_VENDOR_ID_SIIG, PCI_DEVICE_ID_SIIG_2S1P_20x_850,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, siig_2s1p_20x },
+	/* PCI_VENDOR_ID_TIMEDIA/SUNIX has many differing cards ...*/
+	{ 0x1409, 0x7168, 0x1409, 0x4078, 0, 0, timedia_4078a },
+	{ 0x1409, 0x7168, 0x1409, 0x4079, 0, 0, timedia_4079h },
+	{ 0x1409, 0x7168, 0x1409, 0x4085, 0, 0, timedia_4085h },
+	{ 0x1409, 0x7168, 0x1409, 0x4088, 0, 0, timedia_4088a },
+	{ 0x1409, 0x7168, 0x1409, 0x4089, 0, 0, timedia_4089a },
+	{ 0x1409, 0x7168, 0x1409, 0x4095, 0, 0, timedia_4095a },
+	{ 0x1409, 0x7168, 0x1409, 0x4096, 0, 0, timedia_4096a },
+	{ 0x1409, 0x7168, 0x1409, 0x5078, 0, 0, timedia_4078u },
+	{ 0x1409, 0x7168, 0x1409, 0x5079, 0, 0, timedia_4079a },
+	{ 0x1409, 0x7168, 0x1409, 0x5085, 0, 0, timedia_4085u },
+	{ 0x1409, 0x7168, 0x1409, 0x6079, 0, 0, timedia_4079r },
+	{ 0x1409, 0x7168, 0x1409, 0x7079, 0, 0, timedia_4079s },
+	{ 0x1409, 0x7168, 0x1409, 0x8079, 0, 0, timedia_4079d },
+	{ 0x1409, 0x7168, 0x1409, 0x9079, 0, 0, timedia_4079e },
+	{ 0x1409, 0x7168, 0x1409, 0xa079, 0, 0, timedia_4079f },
+	{ 0x1409, 0x7168, 0x1409, 0xb079, 0, 0, timedia_9079a },
+	{ 0x1409, 0x7168, 0x1409, 0xc079, 0, 0, timedia_9079b },
+	{ 0x1409, 0x7168, 0x1409, 0xd079, 0, 0, timedia_9079c },
 
 	{ 0, } /* terminate list */
 };
@@ -267,6 +322,114 @@ static struct pciserial_board pci_parport_serial_boards[] __devinitdata = {
 		.base_baud	= 921600,
 		.uart_offset	= 8,
 	},
+	[timedia_4078a] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4079h] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4085h] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4088a] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4089a] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4095a] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4096a] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4078u] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4079a] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4085u] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4079r] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4079s] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4079d] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4079e] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_4079f] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_9079a] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_9079b] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
+	[timedia_9079c] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
 };
 
 struct parport_serial_private {
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index e6fb67b..8e7e6072 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -572,6 +572,28 @@ static const struct timedia_struct {
 	{ 8, timedia_eight_port }
 };
 
+/*
+ * There are nearly 70 different Timedia/SUNIX PCI serial devices.  Instead of
+ * listing them individually, this driver merely grabs them all with
+ * PCI_ANY_ID.  Some of these devices, however, also feature a parallel port,
+ * and should be left free to be claimed by parport_serial instead.
+ */
+static int pci_timedia_probe(struct pci_dev *dev)
+{
+	/*
+	 * Check the third digit of the subdevice ID
+	 * (0,2,3,5,6: serial only -- 7,8,9: serial + parallel)
+	 */
+	if ((dev->subsystem_device & 0x00f0) >= 0x70) {
+		dev_info(&dev->dev,
+			"ignoring Timedia subdevice %04x for parport_serial\n",
+			dev->subsystem_device);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int pci_timedia_init(struct pci_dev *dev)
 {
 	const unsigned short *ids;
@@ -1388,6 +1410,7 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.device		= PCI_DEVICE_ID_TIMEDIA_1889,
 		.subvendor	= PCI_VENDOR_ID_TIMEDIA,
 		.subdevice	= PCI_ANY_ID,
+		.probe		= pci_timedia_probe,
 		.init		= pci_timedia_init,
 		.setup		= pci_timedia_setup,
 	},
-- 
1.7.5.1

