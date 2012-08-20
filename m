Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2HTS3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:29:07 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:14721 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2HTS3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:29:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-131.messagelabs.com!1345487302!21581519!88
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] staging: comedi: aio_aio12_8: add ai and ao only card versions
Date: Mon, 20 Aug 2012 11:28:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201128.29095.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the analog input and analog output only versions of the card
to the boardinfo. These cards all share the same i/o map.

Cleanup the attach so that the unsupported subdevices are not
initialized.

All of these boards also have an 8254 counter/timer. The 8254
device is not currently supported but stub in the subdevice
information so it can easily be added.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/aio_aio12_8.c | 90 +++++++++++++++++++---------
 1 file changed, 61 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index 71364c6..c06f5cb 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -25,8 +25,9 @@
 Driver: aio_aio12_8
 Description: Access I/O Products PC-104 AIO12-8 Analog I/O Board
 Author: Pablo Mejia <pablo.mejia@cctechnol.com>
-Devices:
- [Access I/O] PC-104 AIO12-8
+Devices: [Access I/O] PC-104 AIO12-8 (aio_aio12_8)
+	 [Access I/O] PC-104 AI12-8 (aio_ai12_8)
+	 [Access I/O] PC-104 AO12-8 (aio_ao12_8)
 Status: experimental
 
 Configuration Options:
@@ -73,11 +74,22 @@ Notes:
 
 struct aio12_8_boardtype {
 	const char *name;
+	int ai_nchan;
+	int ao_nchan;
 };
 
 static const struct aio12_8_boardtype board_types[] = {
 	{
-	 .name = "aio_aio12_8"},
+		.name		= "aio_aio12_8",
+		.ai_nchan	= 8,
+		.ao_nchan	= 4,
+	}, {
+		.name		= "aio_ai12_8",
+		.ai_nchan	= 8,
+	}, {
+		.name		= "aio_ao12_8",
+		.ao_nchan	= 4,
+	},
 };
 
 struct aio12_8_private {
@@ -167,18 +179,17 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 {
 	const struct aio12_8_boardtype *board = comedi_board(dev);
 	struct aio12_8_private *devpriv;
-	int iobase;
 	struct comedi_subdevice *s;
+	int iobase;
 	int ret;
 
+	dev->board_name = board->name;
+
 	iobase = it->options[0];
-	if (!request_region(iobase, 24, "aio_aio12_8")) {
+	if (!request_region(iobase, 24, dev->board_name)) {
 		printk(KERN_ERR "I/O port conflict");
 		return -EIO;
 	}
-
-	dev->board_name = board->name;
-
 	dev->iobase = iobase;
 
 	ret = alloc_private(dev, sizeof(*devpriv));
@@ -186,36 +197,57 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 		return ret;
 	devpriv = dev->private;
 
-	ret = comedi_alloc_subdevices(dev, 3);
+	ret = comedi_alloc_subdevices(dev, 4);
 	if (ret)
 		return ret;
 
-	s = &dev->subdevices[0];
-	s->type = COMEDI_SUBD_AI;
-	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF;
-	s->n_chan = 8;
-	s->maxdata = (1 << 12) - 1;
-	s->range_table = &range_aio_aio12_8;
-	s->insn_read = aio_aio12_8_ai_read;
-
-	s = &dev->subdevices[1];
-	s->type = COMEDI_SUBD_AO;
-	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_DIFF;
-	s->n_chan = 4;
-	s->maxdata = (1 << 12) - 1;
-	s->range_table = &range_aio_aio12_8;
-	s->insn_read = aio_aio12_8_ao_read;
-	s->insn_write = aio_aio12_8_ao_write;
-
-	s = &dev->subdevices[2];
-	subdev_8255_init(dev, s, NULL, dev->iobase + AIO12_8_DIO_0);
+	s = dev->subdevices + 0;
+	if (board->ai_nchan) {
+		/* Analog input subdevice */
+		s->type		= COMEDI_SUBD_AI;
+		s->subdev_flags	= SDF_READABLE | SDF_GROUND | SDF_DIFF;
+		s->n_chan	= board->ai_nchan;
+		s->maxdata	= 0x0fff;
+		s->range_table	= &range_aio_aio12_8;
+		s->insn_read	= aio_aio12_8_ai_read;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	s = dev->subdevices + 1;
+	if (board->ao_nchan) {
+		/* Analog output subdevice */
+		s->type		= COMEDI_SUBD_AO;
+		s->subdev_flags	= SDF_WRITABLE | SDF_GROUND | SDF_DIFF;
+		s->n_chan	= 4;
+		s->maxdata	= 0x0fff;
+		s->range_table	= &range_aio_aio12_8;
+		s->insn_read	= aio_aio12_8_ao_read;
+		s->insn_write	= aio_aio12_8_ao_write;
+	} else {
+		s->type = COMEDI_SUBD_UNUSED;
+	}
+
+	s = dev->subdevices + 2;
+	/* 8255 Digital i/o subdevice */
+	ret = subdev_8255_init(dev, s, NULL, dev->iobase + AIO12_8_DIO_0);
+	if (ret)
+		return ret;
+
+	s = dev->subdevices + 3;
+	/* 8254 counter/timer subdevice */
+	s->type		= COMEDI_SUBD_UNUSED;
+
+	dev_info(dev->class_dev, "%s: %s attached\n",
+		dev->driver->driver_name, dev->board_name);
 
 	return 0;
 }
 
 static void aio_aio12_8_detach(struct comedi_device *dev)
 {
-	subdev_8255_cleanup(dev, &dev->subdevices[2]);
+	if (dev->subdevices)
+		subdev_8255_cleanup(dev, dev->subdevices + 2);
 	if (dev->iobase)
 		release_region(dev->iobase, 24);
 }
-- 
1.7.11

