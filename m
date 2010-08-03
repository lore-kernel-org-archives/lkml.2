Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0HCPmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:42:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36387 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab0HCPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GeMHF4oTS1eMrvjwBaVMjOJxZiZLUrHec7BmR04AwOrW1l57Xc6hd1YkWuqzKjPeqQ
         b1AH6wdjMpYkePqkz5TdzEKtlwXWp2SjgIsrv6kLvK+uhsJZzTHmeNG/BZ1cy+hRLMx0
         PxshO93d9OlMnRDQjmfHEtzA9zr21Ig3F0VJs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] agp: efficeon-agp: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:42:30 +0400
Message-Id: <1280850150-4967-1-git-send-email-segooon@gmail.com>
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
 drivers/char/agp/efficeon-agp.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index aa109cb..d607f53 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -372,6 +372,17 @@ static int __devinit agp_efficeon_probe(struct pci_dev *pdev,
 	bridge->capndx = cap_ptr;
 
 	/*
+	* If the device has not been properly setup, the following will catch
+	* the problem and should stop the system from crashing.
+	* 20030610 - hamish@zot.org
+	*/
+	if (pci_enable_device(pdev)) {
+		printk(KERN_ERR PFX "Unable to Enable PCI device\n");
+		agp_put_bridge(bridge);
+		return -ENODEV;
+	}
+
+	/*
 	* The following fixes the case where the BIOS has "forgotten" to
 	* provide an address range for the GART.
 	* 20030610 - hamish@zot.org
@@ -385,17 +396,6 @@ static int __devinit agp_efficeon_probe(struct pci_dev *pdev,
 		}
 	}
 
-	/*
-	* If the device has not been properly setup, the following will catch
-	* the problem and should stop the system from crashing.
-	* 20030610 - hamish@zot.org
-	*/
-	if (pci_enable_device(pdev)) {
-		printk(KERN_ERR PFX "Unable to Enable PCI device\n");
-		agp_put_bridge(bridge);
-		return -ENODEV;
-	}
-
 	/* Fill in the mode register */
 	if (cap_ptr) {
 		pci_read_config_dword(pdev,
-- 
1.7.0.4

