Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2GSB6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:58:33 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:58173 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2GSB6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:58:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1342663109!14794608!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 67/90] staging: comedi: dt3000: remove 'phys_addr' from the private data
Date: Wed, 18 Jul 2012 18:58:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181858.25078.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'phys_addr' variable in the private data is simply used as
a flag for the detach function to know that the pci device has
been enabled. Use the 'dev->iobase' variable instead as is more
typical for other comedi pci drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dt3000.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 92558e7..3937e87 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -250,7 +250,6 @@ static const struct dt3k_boardtype dt3k_boardtypes[] = {
 struct dt3k_private {
 
 	struct pci_dev *pci_dev;
-	resource_size_t phys_addr;
 	void __iomem *io_addr;
 	unsigned int lock;
 	unsigned int ao_readback[2];
@@ -824,8 +823,8 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	devpriv->phys_addr = pci_resource_start(pcidev, 0);
-	devpriv->io_addr = ioremap(devpriv->phys_addr, DT3000_SIZE);
+	dev->iobase = pci_resource_start(pcidev, 0);
+	devpriv->io_addr = ioremap(dev->iobase, DT3000_SIZE);
 	if (!devpriv->io_addr)
 		return -ENOMEM;
 
@@ -905,7 +904,7 @@ static void dt3000_detach(struct comedi_device *dev)
 		free_irq(dev->irq, dev);
 	if (devpriv) {
 		if (devpriv->pci_dev) {
-			if (devpriv->phys_addr)
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pci_dev);
 			pci_dev_put(devpriv->pci_dev);
 		}
-- 
1.7.11

