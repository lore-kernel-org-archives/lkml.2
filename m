Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab1FPHNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:13:08 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54946 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757095Ab1FPHLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:38 -0400
X-Sasl-enc: whlBtVCL/Y4zPR8xBDHGRT2KGBrLJAnsoebCVRx5Fvja 1308208297
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:12 2011
Message-Id: <20110616002911.986105461@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [81/85] pata_cm64x: fix boot crash on parisc
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit 9281b16caac1276817b77033c5b8a1f5ca30102c upstream.

The old IDE cmd64x checks the status of the CNTRL register to see if
the ports are enabled before probing them.  pata_cmd64x doesn't do
this, which causes a HPMC on parisc when it tries to poke at the
secondary port because apparently the BAR isn't wired up (and a
non-responding piece of memory causes a HPMC).

Fix this by porting the CNTRL register port detection logic from IDE
cmd64x.  In addition, following converns from Alan Cox, add a check to
see if a mobility electronics bridge is the immediate parent and forgo
the check if it is (prevents problems on hotplug controllers).

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_cmd64x.c |   42 ++++++++++++++++++++++++++++++++++++++----
 include/linux/pci_ids.h   |    2 ++
 2 files changed, 40 insertions(+), 4 deletions(-)

--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -41,6 +41,9 @@
 enum {
 	CFR 		= 0x50,
 		CFR_INTR_CH0  = 0x04,
+	CNTRL		= 0x51,
+		CNTRL_CH0     = 0x04,
+		CNTRL_CH1     = 0x08,
 	CMDTIM 		= 0x52,
 	ARTTIM0 	= 0x53,
 	DRWTIM0 	= 0x54,
@@ -328,9 +331,19 @@ static int cmd64x_init_one(struct pci_de
 			.port_ops = &cmd648_port_ops
 		}
 	};
-	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
-	u8 mrdmode;
+	const struct ata_port_info *ppi[] = {
+		&cmd_info[id->driver_data],
+		&cmd_info[id->driver_data],
+		NULL
+	};
+	u8 mrdmode, reg;
 	int rc;
+	struct pci_dev *bridge = pdev->bus->self;
+	/* mobility split bridges don't report enabled ports correctly */
+	int port_ok = !(bridge && bridge->vendor ==
+			PCI_VENDOR_ID_MOBILITY_ELECTRONICS);
+	/* all (with exceptions below) apart from 643 have CNTRL_CH0 bit */
+	int cntrl_ch0_ok = (id->driver_data != 0);
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -341,11 +354,18 @@ static int cmd64x_init_one(struct pci_de
 
 	if (pdev->device == PCI_DEVICE_ID_CMD_646) {
 		/* Does UDMA work ? */
-		if (pdev->revision > 4)
+		if (pdev->revision > 4) {
 			ppi[0] = &cmd_info[2];
+			ppi[1] = &cmd_info[2];
+		}
 		/* Early rev with other problems ? */
-		else if (pdev->revision == 1)
+		else if (pdev->revision == 1) {
 			ppi[0] = &cmd_info[3];
+			ppi[1] = &cmd_info[3];
+		}
+		/* revs 1,2 have no CNTRL_CH0 */
+		if (pdev->revision < 3)
+			cntrl_ch0_ok = 0;
 	}
 
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
@@ -354,6 +374,20 @@ static int cmd64x_init_one(struct pci_de
 	mrdmode |= 0x02;	/* Memory read line enable */
 	pci_write_config_byte(pdev, MRDMODE, mrdmode);
 
+	/* check for enabled ports */
+	pci_read_config_byte(pdev, CNTRL, &reg);
+	if (!port_ok)
+		dev_printk(KERN_NOTICE, &pdev->dev, "Mobility Bridge detected, ignoring CNTRL port enable/disable\n");
+	if (port_ok && cntrl_ch0_ok && !(reg & CNTRL_CH0)) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Primary port is disabled\n");
+		ppi[0] = &ata_dummy_port_info;
+
+	}
+	if (port_ok && !(reg & CNTRL_CH1)) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Secondary port is disabled\n");
+		ppi[1] = &ata_dummy_port_info;
+	}
+
 	/* Force PIO 0 here.. */
 
 	/* PPC specific fixup copied from old driver */
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -605,6 +605,8 @@
 #define PCI_DEVICE_ID_MATROX_G550	0x2527
 #define PCI_DEVICE_ID_MATROX_VIA	0x4536
 
+#define PCI_VENDOR_ID_MOBILITY_ELECTRONICS	0x14f2
+
 #define PCI_VENDOR_ID_CT		0x102c
 #define PCI_DEVICE_ID_CT_69000		0x00c0
 #define PCI_DEVICE_ID_CT_65545		0x00d8


