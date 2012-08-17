Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab2HQCxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:53:30 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:57391 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab2HQCx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:53:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1345172006!7769788!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/35] staging: comedi: cb_pcimdda: remove attached_to_8255 from private data
Date: Thu, 16 Aug 2012 19:53:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161953.21174.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached_to_8255 variable in the private data is used as a flag
to indicate that the 8255 subdevice has been initialized. The call
to subdev_8255_cleanup only requires that the dev->subdevices pointer
is valid. Change the test in the detach function and remove the
attached_to_8255 variable.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index e9f0a68..b10831d 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -105,8 +105,6 @@ Configuration Options:
  * struct.
  */
 struct cb_pcimdda_private {
-	char attached_to_8255;	/* boolean */
-
 #define MAX_AO_READBACK_CHANNELS 6
 	/* Used for AO readback */
 	unsigned int ao_readback[MAX_AO_READBACK_CHANNELS];
@@ -248,7 +246,6 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 			dev->iobase + PCIMDDA_8255_BASE_REG);
 	if (ret)
 		return ret;
-	devpriv->attached_to_8255 = 1;
 
 	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
 
@@ -258,14 +255,9 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 static void cb_pcimdda_detach(struct comedi_device *dev)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-	struct cb_pcimdda_private *devpriv = dev->private;
 
-	if (devpriv) {
-		if (dev->subdevices && devpriv->attached_to_8255) {
-			subdev_8255_cleanup(dev, dev->subdevices + 2);
-			devpriv->attached_to_8255 = 0;
-		}
-	}
+	if (dev->subdevices)
+		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	if (pcidev) {
 		if (dev->iobase)
 			comedi_pci_disable(pcidev);
-- 
1.7.11

