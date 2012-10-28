Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2J1IK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:10:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35831 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756047Ab2J1IKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:10:50 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 16/16] sound: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:54 -0700
Message-Id: <b3001ed99fc8f583ad8a5c6b53900489e43dfa69.1351411048.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Coalesce multiline formats for easier grep.
Coalesce segmented single line formats too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/pci/asihpi/hpidspcd.c |   22 +++++++++-------------
 sound/pci/asihpi/hpioctl.c  |   17 ++++++++---------
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/sound/pci/asihpi/hpidspcd.c b/sound/pci/asihpi/hpidspcd.c
index 456a758..ac91637 100644
--- a/sound/pci/asihpi/hpidspcd.c
+++ b/sound/pci/asihpi/hpidspcd.c
@@ -49,14 +49,12 @@ short hpi_dsp_code_open(u32 adapter, void *os_data, struct dsp_code *dsp_code,
 	err = request_firmware(&firmware, fw_name, &dev->dev);
 
 	if (err || !firmware) {
-		dev_printk(KERN_ERR, &dev->dev,
-			"%d, request_firmware failed for  %s\n", err,
-			fw_name);
+		dev_err(&dev->dev, "%d, request_firmware failed for %s\n",
+			err, fw_name);
 		goto error1;
 	}
 	if (firmware->size < sizeof(header)) {
-		dev_printk(KERN_ERR, &dev->dev, "Header size too small %s\n",
-			fw_name);
+		dev_err(&dev->dev, "Header size too small %s\n", fw_name);
 		goto error2;
 	}
 	memcpy(&header, firmware->data, sizeof(header));
@@ -64,7 +62,7 @@ short hpi_dsp_code_open(u32 adapter, void *os_data, struct dsp_code *dsp_code,
 	if ((header.type != 0x45444F43) ||	/* "CODE" */
 		(header.adapter != adapter)
 		|| (header.size != firmware->size)) {
-		dev_printk(KERN_ERR, &dev->dev,
+		dev_err(&dev->dev,
 			"Invalid firmware header size %d != file %zd\n",
 			header.size, firmware->size);
 		goto error2;
@@ -72,17 +70,15 @@ short hpi_dsp_code_open(u32 adapter, void *os_data, struct dsp_code *dsp_code,
 
 	if ((header.version >> 9) != (HPI_VER >> 9)) {
 		/* Consider even and subsequent odd minor versions to be compatible */
-		dev_printk(KERN_ERR, &dev->dev,
-			"Incompatible firmware version "
-			"DSP image %X != Driver %X\n", header.version,
-			HPI_VER);
+		dev_err(&dev->dev, "Incompatible firmware version DSP image %X != Driver %X\n",
+			header.version, HPI_VER);
 		goto error2;
 	}
 
 	if (header.version != HPI_VER) {
-		dev_printk(KERN_INFO, &dev->dev,
-			"Firmware: release version mismatch  DSP image %X != Driver %X\n",
-			header.version, HPI_VER);
+		dev_info(&dev->dev,
+			 "Firmware: release version mismatch  DSP image %X != Driver %X\n",
+			 header.version, HPI_VER);
 	}
 
 	HPI_DEBUG_LOG(DEBUG, "dsp code %s opened\n", fw_name);
diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index 6091562..8f96749 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -326,7 +326,7 @@ int __devinit asihpi_adapter_probe(struct pci_dev *pci_dev,
 		pci_dev->subsystem_device, pci_dev->devfn);
 
 	if (pci_enable_device(pci_dev) < 0) {
-		dev_printk(KERN_ERR, &pci_dev->dev,
+		dev_err(&pci_dev->dev,
 			"pci_enable_device failed, disabling device\n");
 		return -EIO;
 	}
@@ -398,9 +398,8 @@ int __devinit asihpi_adapter_probe(struct pci_dev *pci_dev,
 	mutex_init(&adapters[adapter_index].mutex);
 	pci_set_drvdata(pci_dev, &adapters[adapter_index]);
 
-	dev_printk(KERN_INFO, &pci_dev->dev,
-		"probe succeeded for ASI%04X HPI index %d\n",
-		adapter.adapter->type, adapter_index);
+	dev_info(&pci_dev->dev, "probe succeeded for ASI%04X HPI index %d\n",
+		 adapter.adapter->type, adapter_index);
 
 	return 0;
 
@@ -448,11 +447,11 @@ void __devexit asihpi_adapter_remove(struct pci_dev *pci_dev)
 
 	pci_set_drvdata(pci_dev, NULL);
 	if (1)
-		dev_printk(KERN_INFO, &pci_dev->dev,
-			"remove %04x:%04x,%04x:%04x,%04x," " HPI index %d.\n",
-			pci_dev->vendor, pci_dev->device,
-			pci_dev->subsystem_vendor, pci_dev->subsystem_device,
-			pci_dev->devfn, pa->adapter->index);
+		dev_info(&pci_dev->dev,
+			 "remove %04x:%04x,%04x:%04x,%04x, HPI index %d\n",
+			 pci_dev->vendor, pci_dev->device,
+			 pci_dev->subsystem_vendor, pci_dev->subsystem_device,
+			 pci_dev->devfn, pa->adapter->index);
 
 	memset(pa, 0, sizeof(*pa));
 }
-- 
1.7.8.112.g3fd21

