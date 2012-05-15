Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965969Ab2EODBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:01:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:49446 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964940Ab2EOCQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 067/179] pata_cm64x: fix boot crash on parisc
Date: Mon, 14 May 2012 22:12:43 -0400
Message-ID: <1337048075-6132-68-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/pata_cmd64x.c |   42 ++++++++++++++++++++++++++++++++++++++----
 include/linux/pci_ids.h   |    2 ++
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 4c81a71..9b2d88f 100644
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
@@ -334,9 +337,19 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -347,11 +360,18 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
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
@@ -360,6 +380,20 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
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
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 32aa93d..fcb5225 100644
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
-- 
1.7.9.6

