Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2HRBTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:19:18 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:8662 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2HRBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:19:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1345252741!21923431!14
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/20] staging: comedi: adv_pci1723: cleanup card reset
Date: Fri, 17 Aug 2012 18:18:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171818.41300.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one 'reset' of the card is required in the attach. Remove the
one before setting up the subdevices and leave the one before
exiting the attach function.

The 'valid' variable in the private data is not needed. This variable
is used in the detach to determine if it's ok to call the 'reset'
function. Checking if dev->iobase is valid works just as well.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 63f0985..cbce06a 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -107,12 +107,8 @@ TODO:
 
 #define PCI1723_SELECT_CALIBRATION 0x28	/* Select the calibration Ref_V */
 
-/* This structure is for data unique to this hardware driver. */
 struct pci1723_private {
-	int valid;		/* card is usable; */
-
 	unsigned char da_range[8];	/* D/A output range for each channel */
-
 	short ao_data[8];	/* data output buffer */
 };
 
@@ -262,8 +258,6 @@ static int pci1723_attach_pci(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	pci1723_reset(dev);
-
 	s = dev->subdevices + 0;
 	dev->write_subdev = s;
 	s->type		= COMEDI_SUBD_AO;
@@ -303,8 +297,6 @@ static int pci1723_attach_pci(struct comedi_device *dev,
 	/* read DIO port state */
 	s->state = inw(dev->iobase + PCI1723_READ_DIGITAL_INPUT_DATA);
 
-	devpriv->valid = 1;
-
 	pci1723_reset(dev);
 
 	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
@@ -315,15 +307,12 @@ static int pci1723_attach_pci(struct comedi_device *dev,
 static void pci1723_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-	struct pci1723_private *devpriv = dev->private;
 
-	if (devpriv) {
-		if (devpriv->valid)
-			pci1723_reset(dev);
-	}
 	if (pcidev) {
-		if (dev->iobase)
+		if (dev->iobase) {
+			pci1723_reset(dev);
 			comedi_pci_disable(pcidev);
+		}
 	}
 }
 
-- 
1.7.11

