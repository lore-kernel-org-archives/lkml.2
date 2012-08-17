Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030575Ab2HQCu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:50:29 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:22736 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030462Ab2HQCu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:50:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1345171823!7671734!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/35] staging: comedi: cb_pcimdda: remove the DIO_METHODS
Date: Thu, 16 Aug 2012 19:50:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161950.19989.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The digital i/o on this card is handled by an 8255 compatible
device. There are not other options. Remove the DIO_METHODS
enum as well as the dio_method variable in the boardinfo and
the code dealing with it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index b4d1f8b..f658cff 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -102,7 +102,6 @@ struct cb_pcimdda_board {
 	int ao_chans;
 	int ao_bits;
 	int dio_chans;
-	int dio_method;
 	/* how many bytes into the BADR are the DIO ports */
 	int dio_offset;
 	int regs_badrindex;	/* IO Region for the control, analog output,
@@ -110,12 +109,6 @@ struct cb_pcimdda_board {
 	int reg_sz;		/* number of bytes of registers in io region */
 };
 
-enum DIO_METHODS {
-	DIO_NONE = 0,
-	DIO_8255,
-	DIO_INTERNAL		/* unimplemented */
-};
-
 static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
 	{
 	 .name = "cb_pcimdda06-16",
@@ -123,7 +116,6 @@ static const struct cb_pcimdda_board cb_pcimdda_boards[] = {
 	 .ao_chans = 6,
 	 .ao_bits = 16,
 	 .dio_chans = 24,
-	 .dio_method = DIO_8255,
 	 .dio_offset = 12,
 	 .regs_badrindex = 3,
 	 .reg_sz = 16,
@@ -283,20 +275,11 @@ static int cb_pcimdda_attach(struct comedi_device *dev,
 	s = dev->subdevices + 1;
 	/* digital i/o subdevice */
 	if (thisboard->dio_chans) {
-		switch (thisboard->dio_method) {
-		case DIO_8255:
-			ret = subdev_8255_init(dev, s, NULL,
-					dev->iobase + thisboard->dio_offset);
-			if (ret)
-				return ret;
-			devpriv->attached_to_8255 = 1;
-			break;
-		case DIO_INTERNAL:
-		default:
-			printk("DIO_INTERNAL not implemented yet!\n");
-			return -ENXIO;
-			break;
-		}
+		ret = subdev_8255_init(dev, s, NULL,
+				dev->iobase + thisboard->dio_offset);
+		if (ret)
+			return ret;
+		devpriv->attached_to_8255 = 1;
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
 	}
-- 
1.7.11

