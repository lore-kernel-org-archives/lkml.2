Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab2HQCu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:50:56 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:28942 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137Ab2HQCux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:50:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1345171852!24237425!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 23/35] staging: comedi: cb_pcimdda: remove dio_chans from the private data
Date: Thu, 16 Aug 2012 19:50:42 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161950.42349.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cards supported by this driver always have 8255 compatible
device. Remove the dio_chans variable from the private data and
always initialize the 8255 subdevice.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index f658cff..bf98af4 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -101,7 +101,6 @@ struct cb_pcimdda_board {
 	unsigned short device_id;
 	int ao_chans;
 	int ao_bits;
-	int dio_chans;
 	/* how many bytes into the BADR are the DIO ports */
 	int dio_offset;
 	int regs_badrindex;	/* IO Region for the control, analog output,
@@ -115,7 +114,6 @@ static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
 	 .device_id = PCI_ID_PCIM_DDA06_16,
 	 .ao_chans = 6,
 	 .ao_bits = 16,
-	 .dio_chans = 24,
 	 .dio_offset = 12,
 	 .regs_badrindex = 3,
 	 .reg_sz = 16,
@@ -274,15 +272,11 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 
 	s = dev->subdevices + 1;
 	/* digital i/o subdevice */
-	if (thisboard->dio_chans) {
-		ret = subdev_8255_init(dev, s, NULL,
-				dev->iobase + thisboard->dio_offset);
-		if (ret)
-			return ret;
-		devpriv->attached_to_8255 = 1;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
+	ret = subdev_8255_init(dev, s, NULL,
+			dev->iobase + thisboard->dio_offset);
+	if (ret)
+		return ret;
+	devpriv->attached_to_8255 = 1;
 
 	dev_info(dev->class_dev, "%s attached\n", dev->board_name);
 
-- 
1.7.11

