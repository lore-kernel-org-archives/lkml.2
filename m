Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2HRBVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:21:20 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:15061 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab2HRBVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:21:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1345252851!13562339!29
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/20] staging: comedi: adv_pci_dio: simplify the 'detach'
Date: Fri, 17 Aug 2012 18:20:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171820.51532.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the 'detach' function in this driver walks thru the
boardinfo in order to find the subdevice index for any sdio
subdevices in order to call the subdev_8255_cleanup(). Then
it goes thru all the subdevices to clean the s->private pointer.

All the sdio subdevices are unique in that the s->type is
COMEDI_SUBD_DIO. Use that to know when to call the cleanup
for the 8255 subdevice.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 2c3dbf0..4da0e7b 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1176,39 +1176,18 @@ static int pci_dio_attach_pci(struct comedi_device *dev,
 
 static void pci_dio_detach(struct comedi_device *dev)
 {
-	const struct dio_boardtype *this_board = comedi_board(dev);
 	struct pci_dio_private *devpriv = dev->private;
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-	int i, j;
 	struct comedi_subdevice *s;
-	int subdev;
+	int i;
 
 	if (devpriv) {
 		if (devpriv->valid)
 			pci_dio_reset(dev);
-		subdev = 0;
-		for (i = 0; i < MAX_DI_SUBDEVS; i++) {
-			if (this_board->sdi[i].chans)
-				subdev++;
-		}
-		for (i = 0; i < MAX_DO_SUBDEVS; i++) {
-			if (this_board->sdo[i].chans)
-				subdev++;
-		}
-		for (i = 0; i < MAX_DIO_SUBDEVG; i++) {
-			for (j = 0; j < this_board->sdio[i].regs; j++) {
-				s = dev->subdevices + subdev;
-				subdev_8255_cleanup(dev, s);
-				subdev++;
-			}
-		}
-		if (this_board->boardid.chans)
-			subdev++;
-		for (i = 0; i < MAX_8254_SUBDEVS; i++)
-			if (this_board->s8254[i].chans)
-				subdev++;
 		for (i = 0; i < dev->n_subdevices; i++) {
 			s = dev->subdevices + i;
+			if (s->type == COMEDI_SUBD_DIO)
+				subdev_8255_cleanup(dev, s);
 			s->private = NULL;
 		}
 	}
-- 
1.7.11

