Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762793Ab2FVX3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:29:04 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:32463 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab2FVX3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:29:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1340407740!6576004!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/31] staging: comedi: ni_daq_700: remove the CALLBACK_* code
Date: Fri, 22 Jun 2012 16:28:33 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221628.33515.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was originally copied from the 8255 driver. The 8255
uses a callback function to handle the io operations to the device.
In this driver, the callback adds unneeded complexity.

The CALLBACK_ARG for this driver is always 'dev->iobase' and the
CALLBACK_FUNC is always 'subdev_700_cb'.

The callback function is also overly complex for this driver.
It takes a 'dir' parameter to determine if the io is a write or
read, a 'port' parameter that is not used, a 'data' parameter
that is only used for writes, and an 'arg' which is the iobase
of the device.

Unwind all of it and just put the outb()/inb() call in the code
where needed.

This allows getting rid of the private data completely. Refactor
the code based on it's removal.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 46 ++---------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 525f076..59f7632 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -66,28 +66,6 @@ struct dio700_board {
 #define DIO_W		0x04
 #define DIO_R		0x05
 
-struct subdev_700_struct {
-	unsigned long cb_arg;
-	int (*cb_func) (int, int, int, unsigned long);
-};
-
-#define CALLBACK_ARG	(((struct subdev_700_struct *)s->private)->cb_arg)
-#define CALLBACK_FUNC	(((struct subdev_700_struct *)s->private)->cb_func)
-#define subdevpriv	((struct subdev_700_struct *)s->private)
-
-static int subdev_700_cb(int dir, int port, int data, unsigned long arg)
-{
-	/* port is always A for output and B for input (8255 emu) */
-	unsigned long iobase = arg;
-
-	if (dir) {
-		outb(data, iobase + DIO_W);
-		return 0;
-	} else {
-		return inb(iobase + DIO_R);
-	}
-}
-
 static int subdev_700_insn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
@@ -97,12 +75,11 @@ static int subdev_700_insn(struct comedi_device *dev,
 		s->state |= (data[0] & data[1]);
 
 		if (data[0] & 0xff)
-			CALLBACK_FUNC(1, _700_DATA, s->state & 0xff,
-				      CALLBACK_ARG);
+			outb(s->state & 0xff, dev->iobase + DIO_W);
 	}
 
 	data[1] = s->state & 0xff;
-	data[1] |= CALLBACK_FUNC(0, _700_DATA, 0, CALLBACK_ARG) << 8;
+	data[1] |= inb(dev->iobase + DIO_R);
 
 	return insn->n;
 }
@@ -142,16 +119,6 @@ static int subdev_700_init(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->maxdata = 1;
 
-	s->private = kmalloc(sizeof(struct subdev_700_struct), GFP_KERNEL);
-	if (!s->private)
-		return -ENOMEM;
-
-	CALLBACK_ARG = arg;
-	if (cb == NULL)
-		CALLBACK_FUNC = subdev_700_cb;
-	 else
-		CALLBACK_FUNC = cb;
-
 	s->insn_bits = subdev_700_insn;
 	s->insn_config = subdev_700_insn_config;
 
@@ -161,13 +128,6 @@ static int subdev_700_init(struct comedi_device *dev,
 	return 0;
 }
 
-static void subdev_700_cleanup(struct comedi_device *dev,
-			       struct comedi_subdevice *s)
-{
-	if (s->private)
-		kfree(s->private);
-}
-
 static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct dio700_board *thisboard = comedi_board(dev);
@@ -224,8 +184,6 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void dio700_detach(struct comedi_device *dev)
 {
-	if (dev->subdevices)
-		subdev_700_cleanup(dev, dev->subdevices + 0);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 };
-- 
1.7.11

