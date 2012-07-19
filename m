Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2GSBa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:30:57 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:22483 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2GSBaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:30:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1342661454!22563018!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/90] staging: comedi: adv_pci1723: move comedi_pci_enable() into the attach
Date: Wed, 18 Jul 2012 18:30:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181830.48668.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pci_is_enabled() in the "find pci device" function to determine if
the found pci device is not in use and move the comedi_pci_enable() call
into the attach.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index f561a2a..e971fa6 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -302,11 +302,7 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
 		}
 		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
 			continue;
-		/*
-		 * Look for device that isn't in use.
-		 * Enable PCI device and request regions.
-		 */
-		if (comedi_pci_enable(pcidev, "adv_pci1723"))
+		if (pci_is_enabled(pcidev))
 			continue;
 		return pcidev;
 	}
@@ -335,6 +331,10 @@ static int pci1723_attach(struct comedi_device *dev,
 	if (!devpriv->pcidev)
 		return -EIO;
 
+	ret = comedi_pci_enable(devpriv->pcidev, "adv_pci1723");
+	if (ret)
+		return ret;
+
 	dev->iobase = pci_resource_start(devpriv->pcidev, 2);
 
 	dev->board_name = this_board->name;
-- 
1.7.11

