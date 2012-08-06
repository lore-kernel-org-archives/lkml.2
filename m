Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2HFMYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:24:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:40704 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab2HFMYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="182172459"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.6] mei: add mei_quirk_probe function
Date: Mon,  6 Aug 2012 15:23:55 +0300
Message-Id: <1344255835-11139-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main purpose of this function is to exclude ME devices
without support for MEI/HECI interface from binding

Currently affected systems are C600/X79 based servers
that expose PCI device even though it doesn't supported ME Interface.
MEI driver accessing such nonfunctional device can corrupt
the system.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 0923302..7422c76 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -925,6 +925,27 @@ static struct miscdevice  mei_misc_device = {
 };
 
 /**
+ * mei_quirk_probe - probe for devices that doesn't valid ME interface
+ * @pdev: PCI device structure
+ * @ent: entry into pci_device_table
+ *
+ * returns true if ME Interface is valid, false otherwise
+ */
+static bool __devinit mei_quirk_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	u32 reg;
+	if (ent->device == MEI_DEV_ID_PBG_1) {
+		pci_read_config_dword(pdev, 0x48, &reg);
+		/* make sure that bit 9 is up and bit 10 is down */
+		if ((reg & 0x600) == 0x200) {
+			dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
+			return false;
+		}
+	}
+	return true;
+}
+/**
  * mei_probe - Device Initialization Routine
  *
  * @pdev: PCI device structure
@@ -939,6 +960,12 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 	int err;
 
 	mutex_lock(&mei_mutex);
+
+	if (!mei_quirk_probe(pdev, ent)) {
+		err = -ENODEV;
+		goto end;
+	}
+
 	if (mei_device) {
 		err = -EEXIST;
 		goto end;
-- 
1.7.4.4

