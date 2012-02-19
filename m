Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2BSWuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 17:50:37 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45148 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2BSWuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 17:50:35 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Fix device class print out
Date: Sun, 19 Feb 2012 14:50:12 -0800
Message-Id: <1329691812-23665-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020202.4F417CB9.002D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found debug print out about class is shifted.

| pci 0000:f8:15.2: [8086:2b56] type 0 class 0x000600

code is trying to print class with 6 digits, but use shifted class with 4 digits
valid value as variable.

Change to original dev->class directly.

also remove not needed calculating of local variable class, because it will be
updated after pci_fixup_device(pci_fixup_early...)

Also unify type print out when class and header is not matched.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/probe.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1125,12 +1125,10 @@ int pci_setup_device(struct pci_dev *dev
 
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
 	dev->revision = class & 0xff;
-	class >>= 8;				    /* upper 3 bytes */
-	dev->class = class;
-	class >>= 8;
+	dev->class = class >> 8;		    /* upper 3 bytes */
 
-	dev_printk(KERN_DEBUG, &dev->dev, "[%04x:%04x] type %d class %#08x\n",
-		   dev->vendor, dev->device, dev->hdr_type, class);
+	dev_printk(KERN_DEBUG, &dev->dev, "[%04x:%04x] type %02x class %#08x\n",
+		   dev->vendor, dev->device, dev->hdr_type, dev->class);
 
 	/* need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
@@ -1212,8 +1210,8 @@ int pci_setup_device(struct pci_dev *dev
 		return -EIO;
 
 	bad:
-		dev_err(&dev->dev, "ignoring class %02x (doesn't match header "
-			"type %02x)\n", class, dev->hdr_type);
+		dev_err(&dev->dev, "ignoring class %#08x (doesn't match header "
+			"type %02x)\n", dev->class, dev->hdr_type);
 		dev->class = PCI_CLASS_NOT_DEFINED;
 	}
 
