Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2GTRd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:33:26 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:40942 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2GTRdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:33:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1342805573!9229819!21
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] staging: comedi: rtd520: ioremap'ed addresses are resource_size_t
Date: Fri, 20 Jul 2012 10:33:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207201033.09096.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by Ian Abbott, the pci address passed to ioremap
should be a resource_size_t not an unsigned long. Use a local
variable of that type to hold the pci_resource_start() that is
passed to ioremp().

Set the dev->iobase to a dummy non-zero value so that the "detach"
can use it as a flag to know that comedi_pci_disable() needs to
be called.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reported-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 112fdc3..5aa8be1 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1619,9 +1619,8 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct rtdPrivate *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
+	resource_size_t pci_base;
 	int ret;
-	resource_size_t physLas1;	/* data area */
-	resource_size_t physLcfg;	/* PLX9080 */
 #ifdef USE_DMA
 	int index;
 #endif
@@ -1655,20 +1654,15 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		printk(KERN_INFO "Failed to enable PCI device and request regions.\n");
 		return ret;
 	}
-
-	/*
-	 * Initialize base addresses
-	 */
-	/* Get the physical address from PCI config */
-	dev->iobase = pci_resource_start(pcidev, LAS0_PCIINDEX);
-	physLas1 = pci_resource_start(pcidev, LAS1_PCIINDEX);
-	physLcfg = pci_resource_start(pcidev, LCFG_PCIINDEX);
-	/* Now have the kernel map this into memory */
-	/* ASSUME page aligned */
-	devpriv->las0 = ioremap_nocache(dev->iobase, LAS0_PCISIZE);
-	devpriv->las1 = ioremap_nocache(physLas1, LAS1_PCISIZE);
-	devpriv->lcfg = ioremap_nocache(physLcfg, LCFG_PCISIZE);
-
+	dev->iobase = 1;	/* the "detach" needs this */
+
+	/* Initialize the base addresses */
+	pci_base = pci_resource_start(pcidev, LAS0_PCIINDEX);
+	devpriv->las0 = ioremap_nocache(pci_base, LAS0_PCISIZE);
+	pci_base = pci_resource_start(pcidev, LAS1_PCIINDEX);
+	devpriv->las1 = ioremap_nocache(pci_base, LAS1_PCISIZE);
+	pci_base = pci_resource_start(pcidev, LCFG_PCIINDEX);
+	devpriv->lcfg = ioremap_nocache(pci_base, LCFG_PCISIZE);
 	if (!devpriv->las0 || !devpriv->las1 || !devpriv->lcfg)
 		return -ENOMEM;
 
-- 
1.7.11

