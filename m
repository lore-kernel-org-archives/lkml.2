Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2GSCEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:04:46 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:33928 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2GSCEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:04:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1342663482!25527668!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 86/90] staging: comedi: rtd520: remove 'got_regions' from private data
Date: Wed, 18 Jul 2012 19:04:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181904.37725.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'got_regions' variable in the private data is used as a flag
for the detach to know if the pci device has been enabled.

Typically the dev->iobase variable is used to indicate this in
all the other comedi drivers. Do the same here for consistancy.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 02be4dd..aeccae9 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -312,7 +312,6 @@ struct rtdPrivate {
 
 	/* PCI device info */
 	struct pci_dev *pci_dev;
-	int got_regions;	/* non-zero if PCI regions owned */
 
 	/* channel list info */
 	/* chanBipolar tracks whether a channel is bipolar (and needs +2048) */
@@ -1623,7 +1622,6 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct rtdPrivate *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
-	resource_size_t physLas0;	/* configuration */
 	resource_size_t physLas1;	/* data area */
 	resource_size_t physLcfg;	/* PLX9080 */
 #ifdef USE_DMA
@@ -1658,18 +1656,17 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		printk(KERN_INFO "Failed to enable PCI device and request regions.\n");
 		return ret;
 	}
-	devpriv->got_regions = 1;
 
 	/*
 	 * Initialize base addresses
 	 */
 	/* Get the physical address from PCI config */
-	physLas0 = pci_resource_start(devpriv->pci_dev, LAS0_PCIINDEX);
+	dev->iobase = pci_resource_start(devpriv->pci_dev, LAS0_PCIINDEX);
 	physLas1 = pci_resource_start(devpriv->pci_dev, LAS1_PCIINDEX);
 	physLcfg = pci_resource_start(devpriv->pci_dev, LCFG_PCIINDEX);
 	/* Now have the kernel map this into memory */
 	/* ASSUME page aligned */
-	devpriv->las0 = ioremap_nocache(physLas0, LAS0_PCISIZE);
+	devpriv->las0 = ioremap_nocache(dev->iobase, LAS0_PCISIZE);
 	devpriv->las1 = ioremap_nocache(physLas1, LAS1_PCISIZE);
 	devpriv->lcfg = ioremap_nocache(physLcfg, LCFG_PCISIZE);
 
@@ -2000,7 +1997,7 @@ static void rtd_detach(struct comedi_device *dev)
 		if (devpriv->lcfg)
 			iounmap(devpriv->lcfg);
 		if (devpriv->pci_dev) {
-			if (devpriv->got_regions)
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pci_dev);
 			pci_dev_put(devpriv->pci_dev);
 		}
-- 
1.7.11

