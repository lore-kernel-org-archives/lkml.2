Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1JVDfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 23:35:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53805 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1JVDfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 23:35:39 -0400
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Paul Schilling <Paul.S.Schilling@gmail.com>,
        Paul Schilling <paul.s.schilling@gmail.com>
Subject: [PATCH 01/14] ATA : vortex86 : fix vortex86dx/sx hardware CRC bug.
Date: Fri, 21 Oct 2011 22:34:18 -0500
Message-Id: <1319254458-4692-1-git-send-email-paul.s.schilling@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <Vortex86_PATA>
References: <Vortex86_PATA>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a DMA issue related to a CRC bug on
the RDC pata peripherial found on the vortex86sx and vortex86dx.

Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
---
 drivers/ata/pata_it821x.c |  264 +++++++++++++++++++++++---------------------
 drivers/ata/pata_rdc.c    |   35 +++++--
 drivers/ide/it821x.c      |    9 ++-
 include/linux/pci_ids.h   |    2 +
 4 files changed, 174 insertions(+), 136 deletions(-)

diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 62c5d00..eaf9c1e 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -1,5 +1,5 @@
 /*
- * pata_it821x.c 	- IT821x PATA for new ATA layer
+ * pata_it821x.c	- IT821x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
  *			  (C) 2007 Bartlomiej Zolnierkiewicz
@@ -16,7 +16,7 @@
  *  Based in part on the ITE vendor provided SCSI driver.
  *
  *  Documentation available from IT8212F_V04.pdf
- * 	http://www.ite.com.tw/EN/products_more.aspx?CategoryID=3&ID=5,91
+ *	http://www.ite.com.tw/EN/products_more.aspx?CategoryID=3&ID=5,91
  *  Some other documents are NDA.
  *
  *  The ITE8212 isn't exactly a standard IDE controller. It has two
@@ -79,22 +79,20 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 
-
 #define DRV_NAME "pata_it821x"
 #define DRV_VERSION "0.4.2"
 
-struct it821x_dev
-{
-	unsigned int smart:1,		/* Are we in smart raid mode */
-		timing10:1;		/* Rev 0x10 */
-	u8	clock_mode;		/* 0, ATA_50 or ATA_66 */
-	u8	want[2][2];		/* Mode/Pri log for master slave */
+struct it821x_dev {
+	unsigned int smart:1,	/* Are we in smart raid mode */
+	 timing10:1;		/* Rev 0x10 */
+	u8 clock_mode;		/* 0, ATA_50 or ATA_66 */
+	u8 want[2][2];		/* Mode/Pri log for master slave */
 	/* We need these for switching the clock when DMA goes on/off
 	   The high byte is the 66Mhz timing */
-	u16	pio[2];			/* Cached PIO values */
-	u16	mwdma[2];		/* Cached MWDMA values */
-	u16	udma[2];		/* Cached UDMA values (per drive) */
-	u16	last_device;		/* Master or slave loaded ? */
+	u16 pio[2];		/* Cached PIO values */
+	u16 mwdma[2];		/* Cached MWDMA values */
+	u16 udma[2];		/* Cached UDMA values (per drive) */
+	u16 last_device;	/* Master or slave loaded ? */
 };
 
 #define ATA_66		0
@@ -124,7 +122,8 @@ static int it8212_noraid;
  *	the DMA start/stop sequence as with the old driver.
  */
 
-static void it821x_program(struct ata_port *ap, struct ata_device *adev, u16 timing)
+static void it821x_program(struct ata_port *ap, struct ata_device *adev,
+			   u16 timing)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct it821x_dev *itdev = ap->private_data;
@@ -139,7 +138,6 @@ static void it821x_program(struct ata_port *ap, struct ata_device *adev, u16 tim
 	pci_write_config_byte(pdev, 0x54 + 4 * channel, conf);
 }
 
-
 /**
  *	it821x_program_udma	-	program the UDMA registers
  *	@ap: ATA port
@@ -152,7 +150,8 @@ static void it821x_program(struct ata_port *ap, struct ata_device *adev, u16 tim
  *	here and partly in start_dma.
  */
 
-static void it821x_program_udma(struct ata_port *ap, struct ata_device *adev, u16 timing)
+static void it821x_program_udma(struct ata_port *ap, struct ata_device *adev,
+				u16 timing)
 {
 	struct it821x_dev *itdev = ap->private_data;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -227,16 +226,16 @@ static void it821x_clock_strategy(struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_byte(pdev, 0x50, v);
 
 	/*
-	 *	Reprogram the UDMA/PIO of the pair drive for the switch
-	 *	MWDMA will be dealt with by the dma switcher
+	 *      Reprogram the UDMA/PIO of the pair drive for the switch
+	 *      MWDMA will be dealt with by the dma switcher
 	 */
-	if (pair && itdev->udma[1-unit] != UDMA_OFF) {
-		it821x_program_udma(ap, pair, itdev->udma[1-unit]);
-		it821x_program(ap, pair, itdev->pio[1-unit]);
+	if (pair && itdev->udma[1 - unit] != UDMA_OFF) {
+		it821x_program_udma(ap, pair, itdev->udma[1 - unit]);
+		it821x_program(ap, pair, itdev->pio[1 - unit]);
 	}
 	/*
-	 *	Reprogram the UDMA/PIO of our drive for the switch.
-	 *	MWDMA will be dealt with by the dma switcher
+	 *      Reprogram the UDMA/PIO of our drive for the switch.
+	 *      MWDMA will be dealt with by the dma switcher
 	 */
 	if (itdev->udma[unit] != UDMA_OFF) {
 		it821x_program_udma(ap, adev, itdev->udma[unit]);
@@ -253,11 +252,13 @@ static void it821x_clock_strategy(struct ata_port *ap, struct ata_device *adev)
  *	shared by PIO and MWDMA and for both channels.
  */
 
-static void it821x_passthru_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void it821x_passthru_set_piomode(struct ata_port *ap,
+					struct ata_device *adev)
 {
 	/* Spec says 89 ref driver uses 88 */
-	static const u16 pio[]	= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
-	static const u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
+	static const u16 pio[] = { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
+	static const u8 pio_want[] = {
+			ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
 
 	struct it821x_dev *itdev = ap->private_data;
 	int unit = adev->devno;
@@ -283,12 +284,17 @@ static void it821x_passthru_set_piomode(struct ata_port *ap, struct ata_device *
  *	we switch devices and mode.
  */
 
-static void it821x_passthru_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+static void it821x_passthru_set_dmamode(struct ata_port *ap,
+					struct ata_device *adev)
 {
-	static const u16 dma[]	= 	{ 0x8866, 0x3222, 0x3121 };
-	static const u8 mwdma_want[] =  { ATA_ANY, ATA_66, ATA_ANY };
-	static const u16 udma[]	= 	{ 0x4433, 0x4231, 0x3121, 0x2121, 0x1111, 0x2211, 0x1111 };
-	static const u8 udma_want[] =   { ATA_ANY, ATA_50, ATA_ANY, ATA_66, ATA_66, ATA_50, ATA_66 };
+	static const u16 dma[] = { 0x8866, 0x3222, 0x3121 };
+	static const u8 mwdma_want[] = { ATA_ANY, ATA_66, ATA_ANY };
+	static const u16 udma[] = {
+			0x4433, 0x4231, 0x3121,
+			0x2121, 0x1111, 0x2211, 0x1111 };
+	static const u8 udma_want[] = {
+			ATA_ANY, ATA_50, ATA_ANY,
+			ATA_66, ATA_66, ATA_50, ATA_66 };
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct it821x_dev *itdev = ap->private_data;
@@ -309,9 +315,9 @@ static void it821x_passthru_set_dmamode(struct ata_port *ap, struct ata_device *
 		/* UDMA on. Again revision 0x10 must do the pair */
 		pci_read_config_byte(pdev, 0x50, &conf);
 		if (itdev->timing10)
-			conf &= channel ? 0x9F: 0xE7;
+			conf &= channel ? 0x9F : 0xE7;
 		else
-			conf &= ~ (1 << (3 + 2 * channel + unit));
+			conf &= ~(1 << (3 + 2 * channel + unit));
 		pci_write_config_byte(pdev, 0x50, conf);
 		it821x_clock_strategy(ap, adev);
 		it821x_program_udma(ap, adev, itdev->udma[unit]);
@@ -326,7 +332,7 @@ static void it821x_passthru_set_dmamode(struct ata_port *ap, struct ata_device *
 		/* UDMA bits off - Revision 0x10 do them in pairs */
 		pci_read_config_byte(pdev, 0x50, &conf);
 		if (itdev->timing10)
-			conf |= channel ? 0x60: 0x18;
+			conf |= channel ? 0x60 : 0x18;
 		else
 			conf |= 1 << (3 + 2 * channel + unit);
 		pci_write_config_byte(pdev, 0x50, conf);
@@ -378,7 +384,6 @@ static void it821x_passthru_bmdma_stop(struct ata_queued_cmd *qc)
 		it821x_program(ap, adev, itdev->pio[unit]);
 }
 
-
 /**
  *	it821x_passthru_dev_select	-	Select master/slave
  *	@ap: ATA port
@@ -387,8 +392,7 @@ static void it821x_passthru_bmdma_stop(struct ata_queued_cmd *qc)
  *	Device selection hook. If necessary perform clock switching
  */
 
-static void it821x_passthru_dev_select(struct ata_port *ap,
-				       unsigned int device)
+static void it821x_passthru_dev_select(struct ata_port *ap, unsigned int device)
 {
 	struct it821x_dev *itdev = ap->private_data;
 	if (itdev && device != itdev->last_device) {
@@ -410,29 +414,29 @@ static void it821x_passthru_dev_select(struct ata_port *ap,
 
 static unsigned int it821x_smart_qc_issue(struct ata_queued_cmd *qc)
 {
-	switch(qc->tf.command)
-	{
+	switch (qc->tf.command) {
 		/* Commands the firmware supports */
-		case ATA_CMD_READ:
-		case ATA_CMD_READ_EXT:
-		case ATA_CMD_WRITE:
-		case ATA_CMD_WRITE_EXT:
-		case ATA_CMD_PIO_READ:
-		case ATA_CMD_PIO_READ_EXT:
-		case ATA_CMD_PIO_WRITE:
-		case ATA_CMD_PIO_WRITE_EXT:
-		case ATA_CMD_READ_MULTI:
-		case ATA_CMD_READ_MULTI_EXT:
-		case ATA_CMD_WRITE_MULTI:
-		case ATA_CMD_WRITE_MULTI_EXT:
-		case ATA_CMD_ID_ATA:
-		case ATA_CMD_INIT_DEV_PARAMS:
-		case 0xFC:	/* Internal 'report rebuild state' */
+	case ATA_CMD_READ:
+	case ATA_CMD_READ_EXT:
+	case ATA_CMD_WRITE:
+	case ATA_CMD_WRITE_EXT:
+	case ATA_CMD_PIO_READ:
+	case ATA_CMD_PIO_READ_EXT:
+	case ATA_CMD_PIO_WRITE:
+	case ATA_CMD_PIO_WRITE_EXT:
+	case ATA_CMD_READ_MULTI:
+	case ATA_CMD_READ_MULTI_EXT:
+	case ATA_CMD_WRITE_MULTI:
+	case ATA_CMD_WRITE_MULTI_EXT:
+	case ATA_CMD_ID_ATA:
+	case ATA_CMD_INIT_DEV_PARAMS:
+	case 0xFC:		/* Internal 'report rebuild state' */
 		/* Arguably should just no-op this one */
-		case ATA_CMD_SET_FEATURES:
-			return ata_bmdma_qc_issue(qc);
+	case ATA_CMD_SET_FEATURES:
+		return ata_bmdma_qc_issue(qc);
 	}
-	printk(KERN_DEBUG "it821x: can't process command 0x%02X\n", qc->tf.command);
+	printk(KERN_DEBUG "it821x: can't process command 0x%02X\n",
+	       qc->tf.command);
 	return AC_ERR_DEV;
 }
 
@@ -462,7 +466,8 @@ static unsigned int it821x_passthru_qc_issue(struct ata_queued_cmd *qc)
  *	and respect them.
  */
 
-static int it821x_smart_set_mode(struct ata_link *link, struct ata_device **unused)
+static int it821x_smart_set_mode(struct ata_link *link,
+				 struct ata_device **unused)
 {
 	struct ata_device *dev;
 
@@ -509,8 +514,7 @@ static void it821x_dev_config(struct ata_device *adev)
 	if (strstr(model_num, "Integrated Technology Express")) {
 		/* RAID mode */
 		ata_dev_info(adev, "%sRAID%d volume",
-			     adev->id[147] ? "Bootable " : "",
-			     adev->id[129]);
+			     adev->id[147] ? "Bootable " : "", adev->id[129]);
 		if (adev->id[129] != 1)
 			pr_cont("(%dK stripe)", adev->id[146]);
 		pr_cont("\n");
@@ -535,7 +539,7 @@ static void it821x_dev_config(struct ata_device *adev)
  */
 
 static unsigned int it821x_read_id(struct ata_device *adev,
-					struct ata_taskfile *tf, u16 *id)
+				   struct ata_taskfile *tf, u16 * id)
 {
 	unsigned int err_mask;
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
@@ -616,7 +620,7 @@ static void it821x_display_disk(int n, u8 *buf)
 	if (buf[52] > 4)	/* No Disk */
 		return;
 
-	ata_id_c_string((u16 *)buf, id, 0, 41);
+	ata_id_c_string((u16 *) buf, id, 0, 41);
 
 	if (buf[51]) {
 		mode = ffs(buf[51]);
@@ -635,10 +639,10 @@ static void it821x_display_disk(int n, u8 *buf)
 		strcpy(mbuf, "PIO");
 	if (buf[52] == 4)
 		printk(KERN_INFO "%d: %-6s %-8s          %s %s\n",
-				n, mbuf, types[buf[52]], id, cbl);
+		       n, mbuf, types[buf[52]], id, cbl);
 	else
 		printk(KERN_INFO "%d: %-6s %-8s Volume: %1d %s %s\n",
-				n, mbuf, types[buf[52]], buf[53], id, cbl);
+		       n, mbuf, types[buf[52]], buf[53], id, cbl);
 	if (buf[125] < 100)
 		printk(KERN_INFO "%d: Rebuilding: %d%%\n", n, buf[125]);
 }
@@ -673,7 +677,7 @@ static u8 *it821x_firmware_command(struct ata_port *ap, u8 cmd, int len)
 	udelay(1);
 	/* This should be almost immediate but a little paranoia goes a long
 	   way. */
-	while(n++ < 10) {
+	while (n++ < 10) {
 		status = ioread8(ap->ioaddr.status_addr);
 		if (status & ATA_ERR) {
 			kfree(buf);
@@ -681,8 +685,8 @@ static u8 *it821x_firmware_command(struct ata_port *ap, u8 cmd, int len)
 			return NULL;
 		}
 		if (status & ATA_DRQ) {
-			ioread16_rep(ap->ioaddr.data_addr, buf, len/2);
-			return (u8 *)buf;
+			ioread16_rep(ap->ioaddr.data_addr, buf, len / 2);
+			return (u8 *) buf;
 		}
 		mdelay(1);
 	}
@@ -711,18 +715,13 @@ static void it821x_probe_firmware(struct ata_port *ap)
 
 	if (buf != NULL) {
 		printk(KERN_INFO "pata_it821x: Firmware %02X/%02X/%02X%02X\n",
-				buf[505],
-				buf[506],
-				buf[507],
-				buf[508]);
+		       buf[505], buf[506], buf[507], buf[508]);
 		for (i = 0; i < 4; i++)
- 			it821x_display_disk(i, buf + 128 * i);
+			it821x_display_disk(i, buf + 128 * i);
 		kfree(buf);
 	}
 }
 
-
-
 /**
  *	it821x_port_start	-	port setup
  *	@ap: ATA port being set up
@@ -772,7 +771,8 @@ static int it821x_port_start(struct ata_port *ap)
 		itdev->timing10 = 1;
 		/* Need to disable ATAPI DMA for this case */
 		if (!itdev->smart)
-			printk(KERN_WARNING DRV_NAME": Revision 0x10, workarounds activated.\n");
+			printk(KERN_WARNING DRV_NAME
+			       ": Revision 0x10, workarounds activated.\n");
 	}
 
 	return 0;
@@ -802,57 +802,57 @@ static struct scsi_host_template it821x_sht = {
 };
 
 static struct ata_port_operations it821x_smart_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits = &ata_bmdma_port_ops,
 
-	.check_atapi_dma= it821x_check_atapi_dma,
-	.qc_issue	= it821x_smart_qc_issue,
+	.check_atapi_dma = it821x_check_atapi_dma,
+	.qc_issue = it821x_smart_qc_issue,
 
-	.cable_detect	= ata_cable_80wire,
-	.set_mode	= it821x_smart_set_mode,
-	.dev_config	= it821x_dev_config,
-	.read_id	= it821x_read_id,
+	.cable_detect = ata_cable_80wire,
+	.set_mode = it821x_smart_set_mode,
+	.dev_config = it821x_dev_config,
+	.read_id = it821x_read_id,
 
-	.port_start	= it821x_port_start,
+	.port_start = it821x_port_start,
 };
 
 static struct ata_port_operations it821x_passthru_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits = &ata_bmdma_port_ops,
 
-	.check_atapi_dma= it821x_check_atapi_dma,
-	.sff_dev_select	= it821x_passthru_dev_select,
-	.bmdma_start 	= it821x_passthru_bmdma_start,
-	.bmdma_stop	= it821x_passthru_bmdma_stop,
-	.qc_issue	= it821x_passthru_qc_issue,
+	.check_atapi_dma = it821x_check_atapi_dma,
+	.sff_dev_select = it821x_passthru_dev_select,
+	.bmdma_start = it821x_passthru_bmdma_start,
+	.bmdma_stop = it821x_passthru_bmdma_stop,
+	.qc_issue = it821x_passthru_qc_issue,
 
-	.cable_detect	= ata_cable_unknown,
-	.set_piomode	= it821x_passthru_set_piomode,
-	.set_dmamode	= it821x_passthru_set_dmamode,
+	.cable_detect = ata_cable_unknown,
+	.set_piomode = it821x_passthru_set_piomode,
+	.set_dmamode = it821x_passthru_set_dmamode,
 
-	.port_start	= it821x_port_start,
+	.port_start = it821x_port_start,
 };
 
 static struct ata_port_operations it821x_rdc_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits = &ata_bmdma_port_ops,
 
-	.check_atapi_dma= it821x_check_atapi_dma,
-	.sff_dev_select	= it821x_passthru_dev_select,
-	.bmdma_start 	= it821x_passthru_bmdma_start,
-	.bmdma_stop	= it821x_passthru_bmdma_stop,
-	.qc_issue	= it821x_passthru_qc_issue,
+	.check_atapi_dma = it821x_check_atapi_dma,
+	.sff_dev_select = it821x_passthru_dev_select,
+	.bmdma_start = it821x_passthru_bmdma_start,
+	.bmdma_stop = it821x_passthru_bmdma_stop,
+	.qc_issue = it821x_passthru_qc_issue,
 
-	.cable_detect	= it821x_rdc_cable,
-	.set_piomode	= it821x_passthru_set_piomode,
-	.set_dmamode	= it821x_passthru_set_dmamode,
+	.cable_detect = it821x_rdc_cable,
+	.set_piomode = it821x_passthru_set_piomode,
+	.set_dmamode = it821x_passthru_set_dmamode,
 
-	.port_start	= it821x_port_start,
+	.port_start = it821x_port_start,
 };
 
 static void it821x_disable_raid(struct pci_dev *pdev)
 {
 	/* Neither the RDC nor the IT8211 */
 	if (pdev->vendor != PCI_VENDOR_ID_ITE ||
-			pdev->device != PCI_DEVICE_ID_ITE_8212)
-			return;
+	    pdev->device != PCI_DEVICE_ID_ITE_8212)
+		return;
 
 	/* Reset local CPU, and set BIOS not ready */
 	pci_write_config_byte(pdev, 0x5E, 0x01);
@@ -864,12 +864,11 @@ static void it821x_disable_raid(struct pci_dev *pdev)
 			      PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
 	pci_write_config_word(pdev, 0x40, 0xA0F3);
 
-	pci_write_config_dword(pdev,0x4C, 0x02040204);
+	pci_write_config_dword(pdev, 0x4C, 0x02040204);
 	pci_write_config_byte(pdev, 0x42, 0x36);
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x20);
 }
 
-
 static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	u8 conf;
@@ -898,7 +897,16 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	static const struct ata_port_info info_rdc_11 = {
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = ATA_PIO4,
-		.mwdma_mask = ATA_MWDMA2,
+		.mwdma_mask = 0,
+		.udma_mask = 0,
+		/* No UDMA */
+		.port_ops = &it821x_rdc_port_ops
+	};
+	static const struct ata_port_info info_rdc_01 = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = ATA_PIO4,
+		.mwdma_mask = 0,
+		.udma_mask = 0,
 		/* No UDMA */
 		.port_ops = &it821x_rdc_port_ops
 	};
@@ -912,11 +920,16 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		return rc;
 
 	if (pdev->vendor == PCI_VENDOR_ID_RDC) {
-		/* Deal with Vortex86SX */
-		if (pdev->revision == 0x11)
+		if (((pdev->revision == 0x11) || (pdev->revision == 0x13)) &&
+		    (pdev->device == PCI_DEVICE_ID_RDC_D1010)) {
+			/* Deal with Vortex86SX */
 			ppi[0] = &info_rdc_11;
-		else
+			printk(KERN_INFO DRV_NAME
+			       ": Detected Vortex86SX/DX Bug.\n");
+			printk(KERN_INFO DRV_NAME ": Disabling UDMA.\n");
+		} else {
 			ppi[0] = &info_rdc;
+		}
 	} else {
 		/* Force the card into bypass mode if so requested */
 		if (it8212_noraid) {
@@ -926,8 +939,8 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		pci_read_config_byte(pdev, 0x50, &conf);
 		conf &= 1;
 
-		printk(KERN_INFO DRV_NAME": controller in %s mode.\n",
-								mode[conf]);
+		printk(KERN_INFO DRV_NAME ": controller in %s mode.\n",
+		       mode[conf]);
 		if (conf == 0)
 			ppi[0] = &info_passthru;
 		else
@@ -954,21 +967,20 @@ static int it821x_reinit_one(struct pci_dev *pdev)
 #endif
 
 static const struct pci_device_id it821x[] = {
-	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), },
-	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), },
-	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1010), },
-
-	{ },
+	{PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211),},
+	{PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212),},
+	{PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1010),},
+	{},
 };
 
 static struct pci_driver it821x_pci_driver = {
-	.name 		= DRV_NAME,
-	.id_table	= it821x,
-	.probe 		= it821x_init_one,
-	.remove		= ata_pci_remove_one,
+	.name = DRV_NAME,
+	.id_table = it821x,
+	.probe = it821x_init_one,
+	.remove = ata_pci_remove_one,
 #ifdef CONFIG_PM
-	.suspend	= ata_pci_device_suspend,
-	.resume		= it821x_reinit_one,
+	.suspend = ata_pci_device_suspend,
+	.resume = it821x_reinit_one,
 #endif
 };
 
@@ -983,12 +995,12 @@ static void __exit it821x_exit(void)
 }
 
 MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("low-level driver for the IT8211/IT8212 IDE RAID controller");
+MODULE_DESCRIPTION
+("low-level driver for the IT8211/IT8212 IDE RAID controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, it821x);
 MODULE_VERSION(DRV_VERSION);
 
-
 module_param_named(noraid, it8212_noraid, int, S_IRUGO);
 MODULE_PARM_DESC(noraid, "Force card into bypass mode");
 
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index 4d318f8..85b1e11 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -258,7 +258,7 @@ static void rdc_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 			/* Load the matching timing */
 			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
 			pci_write_config_byte(dev, 0x44, slave_data);
-		} else { 	/* Master */
+		} else {	/* Master */
 			master_data &= 0xCCF4;	/* Mask out IORDY|TIME1|DMAONLY
 						   and master timing bits */
 			master_data |= control;
@@ -290,6 +290,16 @@ static struct ata_port_info rdc_port_info = {
 	.port_ops	= &rdc_pata_ops,
 };
 
+static struct ata_port_info vortex_port_info = {
+	.flags = ATA_FLAG_SLAVE_POSS,
+	.pio_mask = ATA_PIO4,
+	.mwdma_mask = 0,
+	.udma_mask = 0,
+	/* No UDMA */
+	.port_ops	= &rdc_pata_ops,
+};
+
+
 static struct scsi_host_template rdc_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -322,16 +332,25 @@ static int __devinit rdc_init_one(struct pci_dev *pdev,
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
-	port_info[0] = rdc_port_info;
-	port_info[1] = rdc_port_info;
-
-	port_flags = port_info[0].flags;
-
 	/* enable device and prepare host */
 	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
 
+	if ((pdev->revision == 0x01) &&
+			(pdev->device ==  PCI_DEVICE_ID_RDC_D1011)) {
+		/* Deal with Vortex86DX */
+		port_info[0] = vortex_port_info;
+		port_info[1] = vortex_port_info;
+		printk(KERN_INFO DRV_NAME ": Detected Vortex86DX Bug.\n");
+		printk(KERN_INFO DRV_NAME ": Disabling UDMA.\n");
+	} else {
+		port_info[0] = rdc_port_info;
+		port_info[1] = rdc_port_info;
+	}
+
+	port_flags = port_info[0].flags;
+
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
@@ -365,8 +384,8 @@ static void rdc_remove_one(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id rdc_pci_tbl[] = {
-	{ PCI_DEVICE(0x17F3, 0x1011), },
-	{ PCI_DEVICE(0x17F3, 0x1012), },
+	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1011), },
+	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1012), },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/ide/it821x.c b/drivers/ide/it821x.c
index 2e3169f..82c6bc7 100644
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -581,10 +581,14 @@ static void __devinit init_hwif_it821x(ide_hwif_t *hwif)
 	hwif->ultra_mask = ATA_UDMA6;
 	hwif->mwdma_mask = ATA_MWDMA2;
 
-	/* Vortex86SX quirk: prevent Ultra-DMA mode to fix BadCRC issue */
+	/* Vortex86SX and Vortex86DX quirk: prevent
+	 * Ultra-DMA mode to fix BadCRC issue when
+	 * using DMA mode */
 	if (idev->quirks & QUIRK_VORTEX86) {
-		if (dev->revision == 0x11)
+		if (((dev->revision == 0x11) || (dev->revision == 0x13))
+				|| (dev->revision == 0x01)) {
 			hwif->ultra_mask = 0;
+		}
 	}
 }
 
@@ -680,6 +684,7 @@ static const struct pci_device_id it821x_pci_tbl[] = {
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), 0 },
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), 0 },
 	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1010), QUIRK_VORTEX86 },
+	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1011), QUIRK_VORTEX86 },
 	{ 0, },
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ae96bbe..237da92 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2259,6 +2259,8 @@
 #define PCI_DEVICE_ID_RDC_R6060		0x6060
 #define PCI_DEVICE_ID_RDC_R6061		0x6061
 #define PCI_DEVICE_ID_RDC_D1010		0x1010
+#define PCI_DEVICE_ID_RDC_D1011		0x1011
+#define PCI_DEVICE_ID_RDC_D1012		0x1012
 
 #define PCI_VENDOR_ID_LENOVO		0x17aa
 
-- 
1.7.6.4

