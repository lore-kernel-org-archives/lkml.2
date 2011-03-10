Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1CJVCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:02:46 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:50452 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab1CJVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:44 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 09/22] staging: xgifb: delete incorrect I/O mapping
Date: Thu, 10 Mar 2011 23:02:34 +0200
Message-Id: <1299790967-7135-10-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the PCI device was disabled when the probe() routine started, the
driver will create 256 MB video memory mapping which is never used or
properly released. It's also unsafe as the size is incorrect for many
video cards. Deleting it also allows eliminating XGIvga_enable global
variable.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    1 -
 drivers/staging/xgifb/XGI_main_26.c |    7 -------
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index a014405..46b5958 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -303,7 +303,6 @@ static u32 pseudo_palette[17];
 static int XGIfb_off = 0;
 static int XGIfb_crt1off = 0;
 static int XGIfb_forcecrt1 = -1;
-static int XGIvga_enabled = 0;
 static int XGIfb_userom = 0;
 //static int XGIfb_useoem = -1;
 
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 17f2aef..3aec3f1 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2163,7 +2163,6 @@ done:
 static int __devinit xgifb_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
-	u16 reg16;
 	u8 reg, reg1;
 	u8 CR48, CR38;
 	int ret;
@@ -2180,9 +2179,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	xgi_video_info.chip_id = pdev->device;
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &xgi_video_info.revision_id);
-	pci_read_config_word(pdev, PCI_COMMAND, &reg16);
 	XGIhw_ext.jChipRevision = xgi_video_info.revision_id;
-	XGIvga_enabled = reg16 & 0x01;
 
 	xgi_video_info.pcibus = pdev->bus->number;
 	xgi_video_info.pcislot = PCI_SLOT(pdev->devfn);
@@ -2261,10 +2258,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	}
 	XGIhw_ext.pQueryVGAConfigSpace = &XGIfb_query_VGA_config_space;
 
-	if (!XGIvga_enabled) {
-		/* Mapping Max FB Size for 315 Init */
-		XGIhw_ext.pjVideoMemoryAddress = ioremap(xgi_video_info.video_base, 0x10000000);
-	}
 	if (XGIfb_get_dram_size()) {
 		printk(KERN_INFO "XGIfb: Fatal error: Unable to determine RAM size.\n");
 		ret = -ENODEV;
-- 
1.5.6.5

