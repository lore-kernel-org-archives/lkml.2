Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0HCPmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:42:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46575 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab0HCPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ecw03tSnfMcO3J0ayMIP0/UuAcKVWrrZOQZNvu2G2O7PF4Bo1Bg+kn4gSSeBXL5ccM
         3xohTwaoR87obBvhXPRk26kB25VkBRqU2IqasU1JRNj9gNLvTJrpCL/m3Z4soag6qzqv
         lhtOF1Il8K6c8o7mvQmlyWNp2eo+lbtR5SNHs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] agp: intel-agp: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:42:34 +0400
Message-Id: <1280850154-5010-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ and resource[] may not have correct values until
after PCI hotplug setup occurs at pci_enable_device() time.

The semantic match that finds this problem is as follows:

// <smpl>
@@
identifier x;
identifier request ~= "pci_request.*|pci_resource.*";
@@

(
* x->irq
|
* x->resource
|
* request(x, ...)
)
 ...
*pci_enable_device(x)
// </smpl>

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/agp/intel-agp.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index d836a71..237dd23 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -908,6 +908,17 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 	dev_info(&pdev->dev, "Intel %s Chipset\n", intel_agp_chipsets[i].name);
 
 	/*
+	* If the device has not been properly setup, the following will catch
+	* the problem and should stop the system from crashing.
+	* 20030610 - hamish@zot.org
+	*/
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "can't enable PCI device\n");
+		agp_put_bridge(bridge);
+		return -ENODEV;
+	}
+
+	/*
 	* The following fixes the case where the BIOS has "forgotten" to
 	* provide an address range for the GART.
 	* 20030610 - hamish@zot.org
@@ -921,17 +932,6 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 		}
 	}
 
-	/*
-	* If the device has not been properly setup, the following will catch
-	* the problem and should stop the system from crashing.
-	* 20030610 - hamish@zot.org
-	*/
-	if (pci_enable_device(pdev)) {
-		dev_err(&pdev->dev, "can't enable PCI device\n");
-		agp_put_bridge(bridge);
-		return -ENODEV;
-	}
-
 	/* Fill in the mode register */
 	if (cap_ptr) {
 		pci_read_config_dword(pdev,
-- 
1.7.0.4

