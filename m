Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2GSB6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:58:14 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:57765 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2GSB6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:58:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1342663091!13181268!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 66/90] staging: comedi: dt3000: move the setup_pci() code into the attach
Date: Wed, 18 Jul 2012 18:58:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181858.08254.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The setup_pci() function simply calls comedi_pci_enable() to enable
the device then ioremaps the pci address. Move the code directly
into the attach function as is more typical for the comedi pci
drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dt3000.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 10b43a2..92558e7 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -774,28 +774,6 @@ static int dt3k_mem_insn_read(struct comedi_device *dev,
 	return i;
 }
 
-static int setup_pci(struct comedi_device *dev)
-{
-	resource_size_t addr;
-	int ret;
-
-	ret = comedi_pci_enable(devpriv->pci_dev, "dt3000");
-	if (ret < 0)
-		return ret;
-
-	addr = pci_resource_start(devpriv->pci_dev, 0);
-	devpriv->phys_addr = addr;
-	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
-	if (!devpriv->io_addr)
-		return -ENOMEM;
-#if DEBUG
-	printk("0x%08llx mapped to %p, ",
-	       (unsigned long long)devpriv->phys_addr, devpriv->io_addr);
-#endif
-
-	return 0;
-}
-
 static struct pci_dev *dt3000_find_pci_dev(struct comedi_device *dev,
 					   struct comedi_devconfig *it)
 {
@@ -842,10 +820,15 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	devpriv->pci_dev = pcidev;
 
-	ret = setup_pci(dev);
+	ret = comedi_pci_enable(pcidev, "dt3000");
 	if (ret < 0)
 		return ret;
 
+	devpriv->phys_addr = pci_resource_start(pcidev, 0);
+	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
+	if (!devpriv->io_addr)
+		return -ENOMEM;
+
 	dev->board_name = this_board->name;
 
 	if (request_irq(pcidev->irq, dt3k_interrupt, IRQF_SHARED,
-- 
1.7.11

