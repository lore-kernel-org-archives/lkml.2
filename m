Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab0FZAeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 20:34:24 -0400
Received: from fallback-out1.mxes.net ([216.86.168.180]:14017 "EHLO
	fallback-in1.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752123Ab0FZAeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 20:34:23 -0400
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2010 20:34:22 EDT
From: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Bri=C3=A8re?= <fbriere@fbriere.net>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, linux-parport@lists.infradead.org
Subject: [PATCH] parport/serial: add support for Timedia/SUNIX cards to parport_serial
Date: Fri, 25 Jun 2010 20:23:43 -0400
Message-Id: <1277511823-6973-1-git-send-email-fbriere@fbriere.net>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timedia/SUNIX PCI cards with both serial and parallel ports are
currently supported by 8250_pci and parport_pc individually.  Moving
that support into parport_serial allows using both types of ports at the
same time.

Note that we assume all such cards belong to the serial PCI class.

This was successfully tested with a SUNIX 4079T.

Signed-off-by: Frédéric Brière <fbriere@fbriere.net>
---
(I elected to avoid duplicating the same serial info 18 times, and
cheated a little bit instead.  Let me know if this was a bad idea.)

 drivers/parport/parport_pc.c     |   54 -----------------------------
 drivers/parport/parport_serial.c |   69 +++++++++++++++++++++++++++++++++++++-
 drivers/pci/quirks.c             |   23 ++++++++++++
 drivers/serial/8250_pci.c        |   10 ++++-
 4 files changed, 99 insertions(+), 57 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 0950fa4..e5d1d2f 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2866,24 +2866,6 @@ enum parport_pc_pci_cards {
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
@@ -2942,24 +2924,6 @@ static struct parport_pc_pci {
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
@@ -3021,24 +2985,6 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
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
index 40e208d..83510d3 100644
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -41,6 +41,25 @@ enum parport_pc_pci_cards {
 	siig_2p1s_20x,
 	siig_1s1p_20x,
 	siig_2s1p_20x,
+	/* These entries must come last */
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
@@ -105,6 +124,24 @@ static struct parport_pc_pci cards[] __devinitdata = {
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
@@ -176,6 +213,25 @@ static struct pci_device_id parport_serial_pci_tbl[] = {
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
@@ -267,6 +323,13 @@ static struct pciserial_board pci_parport_serial_boards[] __devinitdata = {
 		.base_baud	= 921600,
 		.uart_offset	= 8,
 	},
+	/* All Timedia/SUNIX cards share this entry */
+	[timedia_4078a] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 8,
+	},
 };
 
 struct parport_serial_private {
@@ -283,8 +346,12 @@ static int __devinit serial_register (struct pci_dev *dev,
 	struct parport_serial_private *priv = pci_get_drvdata (dev);
 	struct pciserial_board *board;
 	struct serial_private *serial;
+	int idx = id->driver_data;
+
+	if (idx > timedia_4078a)
+		idx = timedia_4078a;
 
-	board = &pci_parport_serial_boards[id->driver_data];
+	board = &pci_parport_serial_boards[idx];
 	serial = pciserial_init_ports(dev, board);
 
 	if (IS_ERR(serial))
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 477345d..2d62b83 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1800,6 +1800,29 @@ static void __devinit quirk_netmos(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NETMOS, PCI_ANY_ID, quirk_netmos);
 
+/*
+ * There are nearly 70 different Timedia/SUNIX PCI serial devices, some of
+ * which also feature a parallel port.  Instead of listing them individually,
+ * 8250_pci merely grabs them all.
+ *
+ * Devices with a parallel port can be identified by their subdevice ID
+ * matching xx[7-9]x.  We thus mark them as class OTHER, so that they will be
+ * ignored by 8250_pci, and claimed by parport_serial instead.
+ */
+static void __devinit quirk_timedia(struct pci_dev *dev)
+{
+	/* 0,2,3,5,6: serial only -- 7,8,9: serial + parallel */
+	if ((dev->subsystem_device & 0x00f0) >= 0x70) {
+		dev_info(&dev->dev, "Timedia %04x; "
+			"changing class SERIAL to OTHER (use parport_serial)\n",
+			dev->subsystem_device);
+		dev->class = (PCI_CLASS_COMMUNICATION_OTHER << 8) |
+		    (dev->class & 0xff);
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TIMEDIA, PCI_DEVICE_ID_TIMEDIA_1889,
+		quirk_timedia);
+
 static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
 {
 	u16 command, pmcsr;
diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 746a446..c294532 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -1347,7 +1347,7 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.setup		= titan_400l_800l_setup,
 	},
 	/*
-	 * Timedia cards
+	 * Timedia cards - these may be called via parport_serial
 	 */
 	{
 		.vendor		= PCI_VENDOR_ID_TIMEDIA,
@@ -3195,8 +3195,14 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI95N,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_oxsemi },
+
+	/*
+	 * Timedia serial cards - class will be forced to OTHER if a
+	 * parallel port is present, to leave them for parport_serial.
+	 */
 	{	PCI_VENDOR_ID_TIMEDIA, PCI_DEVICE_ID_TIMEDIA_1889,
-		PCI_VENDOR_ID_TIMEDIA, PCI_ANY_ID, 0, 0,
+		PCI_VENDOR_ID_TIMEDIA, PCI_ANY_ID,
+		PCI_CLASS_COMMUNICATION_SERIAL << 8, 0xffff00,
 		pbn_b0_bt_1_921600 },
 
 	/*
-- 
1.7.1

