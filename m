Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2GTRcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:32:51 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:58193 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2GTRcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:32:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1342805559!9248191!10
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] staging: comedi: daqboard2000: ioremap'ed addresses are resource_size_t
Date: Fri, 20 Jul 2012 10:32:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207201032.29352.hartleys@visionengravers.com>
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
 drivers/staging/comedi/drivers/daqboard2000.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 7236cbe..cad559a 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -740,6 +740,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 {
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
+	resource_size_t pci_base;
 	void *aux_data;
 	unsigned int aux_len;
 	int result;
@@ -759,11 +760,12 @@ static int daqboard2000_attach(struct comedi_device *dev,
 			"failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
-	dev->iobase = pci_resource_start(pcidev, 2);
+	dev->iobase = 1;	/* the "detach" needs this */
 
-	devpriv->plx =
-	    ioremap(pci_resource_start(pcidev, 0), DAQBOARD2000_PLX_SIZE);
-	devpriv->daq = ioremap(dev->iobase, DAQBOARD2000_DAQ_SIZE);
+	pci_base = pci_resource_start(pcidev, 0);
+	devpriv->plx = ioremap(pci_base, DAQBOARD2000_PLX_SIZE);
+	pci_base = pci_resource_start(pcidev, 2);
+	devpriv->daq = ioremap(pci_base, DAQBOARD2000_DAQ_SIZE);
 	if (!devpriv->plx || !devpriv->daq)
 		return -ENOMEM;
 
@@ -800,8 +802,6 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	   printk("Interrupt after is: %x\n", interrupt);
 	 */
 
-	dev->iobase = (unsigned long)devpriv->daq;
-
 	dev->board_name = this_board->name;
 
 	s = dev->subdevices + 0;
@@ -825,7 +825,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 
 	s = dev->subdevices + 2;
 	result = subdev_8255_init(dev, s, daqboard2000_8255_cb,
-				  (unsigned long)(dev->iobase + 0x40));
+				  (unsigned long)(devpriv->daq + 0x40));
 
 out:
 	return result;
-- 
1.7.11

