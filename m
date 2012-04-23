Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2DWW55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:57:57 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:60691 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2DWW54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:57:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1335221874!6596638!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor adq12b driver to remove forward declarations
Date: Mon, 23 Apr 2012 15:57:48 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204231557.49076.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and struct boardtype variables to the end
of the source as is more typically done with other drivers. Then
rearrange the attach/detach functions, this removes the need
for all the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 5361f31..275cb77 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -125,24 +125,6 @@ struct adq12b_board {
 	int do_chans;
 };
 
-static const struct adq12b_board adq12b_boards[] = {
-	{
-	 .name = "adq12b",
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 12,
-	 .di_chans = 5,
-	 .do_chans = 8}
-/* potentially, more adq-based deviced will be added */
-/*,
-	.name = "adq12b",
-	.ai_chans = 16,  // this is just for reference, hardcoded again later
-	.ai_bits = 12,
-	.di_chans = 8,
-	.do_chans = 5
-	}*/
-};
-
 #define thisboard ((const struct adq12b_board *)dev->board_ptr)
 
 struct adq12b_private {
@@ -156,41 +138,88 @@ struct adq12b_private {
 #define devpriv ((struct adq12b_private *)dev->private)
 
 /*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
+ * "instructions" read/write data in "one-shot" or "software-triggered"
+ * mode.
  */
-static int adq12b_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int adq12b_detach(struct comedi_device *dev);
-
-static struct comedi_driver driver_adq12b = {
-	.driver_name = "adq12b",
-	.module = THIS_MODULE,
-	.attach = adq12b_attach,
-	.detach = adq12b_detach,
-	.board_name = &adq12b_boards[0].name,
-	.offset = sizeof(struct adq12b_board),
-	.num_names = ARRAY_SIZE(adq12b_boards),
-};
 
 static int adq12b_ai_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
-			   unsigned int *data);
+			   unsigned int *data)
+{
+	int n, i;
+	int range, channel;
+	unsigned char hi, lo, status;
+
+	/* change channel and range only if it is different from the previous */
+	range = CR_RANGE(insn->chanspec);
+	channel = CR_CHAN(insn->chanspec);
+	if (channel != devpriv->last_channel || range != devpriv->last_range) {
+		outb((range << 4) | channel, dev->iobase + ADQ12B_CTREG);
+		udelay(50);	/* wait for the mux to settle */
+	}
+
+	/* trigger conversion */
+	status = inb(dev->iobase + ADQ12B_ADLOW);
+
+	/* convert n samples */
+	for (n = 0; n < insn->n; n++) {
+
+		/* wait for end of conversion */
+		i = 0;
+		do {
+			/* udelay(1); */
+			status = inb(dev->iobase + ADQ12B_STINR);
+			status = status & ADQ12B_EOC;
+		} while (status == 0 && ++i < TIMEOUT);
+		/* } while (++i < 10); */
+
+		/* read data */
+		hi = inb(dev->iobase + ADQ12B_ADHIG);
+		lo = inb(dev->iobase + ADQ12B_ADLOW);
+
+		/* printk("debug: chan=%d range=%d status=%d hi=%d lo=%d\n",
+		       channel, range, status,  hi, lo); */
+		data[n] = (hi << 8) | lo;
+
+	}
+
+	/* return the number of samples read/written */
+	return n;
+}
+
 static int adq12b_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
+			       struct comedi_insn *insn, unsigned int *data)
+{
+
+	/* only bits 0-4 have information about digital inputs */
+	data[1] = (inb(dev->iobase + ADQ12B_STINR) & (0x1f));
+
+	return 2;
+}
+
 static int adq12b_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	int channel;
+
+	for (channel = 0; channel < 8; channel++)
+		if (((data[0] >> channel) & 0x01) != 0)
+			outb((((data[1] >> channel) & 0x01) << 3) | channel,
+			     dev->iobase + ADQ12B_OUTBR);
+
+	/* store information to retrieve when asked for reading */
+	if (data[0]) {
+		devpriv->digital_state &= ~data[0];
+		devpriv->digital_state |= (data[0] & data[1]);
+	}
+
+	data[1] = devpriv->digital_state;
+
+	return 2;
+}
 
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
 static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
@@ -295,14 +324,6 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return 0;
 }
 
-/*
- * _detach is called to deconfigure a device.  It should deallocate
- * resources.
- * This function is also called when _attach() fails, so it should be
- * careful not to release resources that were not necessarily
- * allocated by _attach().  dev->private and dev->subdevices are
- * deallocated automatically by the core.
- */
 static int adq12b_detach(struct comedi_device *dev)
 {
 	if (dev->iobase)
@@ -315,104 +336,37 @@ static int adq12b_detach(struct comedi_device *dev)
 	return 0;
 }
 
-/*
- * "instructions" read/write data in "one-shot" or "software-triggered"
- * mode.
- */
-
-static int adq12b_ai_rinsn(struct comedi_device *dev,
-			   struct comedi_subdevice *s, struct comedi_insn *insn,
-			   unsigned int *data)
-{
-	int n, i;
-	int range, channel;
-	unsigned char hi, lo, status;
-
-	/* change channel and range only if it is different from the previous */
-	range = CR_RANGE(insn->chanspec);
-	channel = CR_CHAN(insn->chanspec);
-	if (channel != devpriv->last_channel || range != devpriv->last_range) {
-		outb((range << 4) | channel, dev->iobase + ADQ12B_CTREG);
-		udelay(50);	/* wait for the mux to settle */
-	}
-
-	/* trigger conversion */
-	status = inb(dev->iobase + ADQ12B_ADLOW);
-
-	/* convert n samples */
-	for (n = 0; n < insn->n; n++) {
-
-		/* wait for end of conversion */
-		i = 0;
-		do {
-			/* udelay(1); */
-			status = inb(dev->iobase + ADQ12B_STINR);
-			status = status & ADQ12B_EOC;
-		} while (status == 0 && ++i < TIMEOUT);
-		/* } while (++i < 10); */
-
-		/* read data */
-		hi = inb(dev->iobase + ADQ12B_ADHIG);
-		lo = inb(dev->iobase + ADQ12B_ADLOW);
-
-		/* printk("debug: chan=%d range=%d status=%d hi=%d lo=%d\n",
-		       channel, range, status,  hi, lo); */
-		data[n] = (hi << 8) | lo;
-
-	}
-
-	/* return the number of samples read/written */
-	return n;
-}
-
-static int adq12b_di_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-
-	/* only bits 0-4 have information about digital inputs */
-	data[1] = (inb(dev->iobase + ADQ12B_STINR) & (0x1f));
-
-	return 2;
-}
-
-static int adq12b_do_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	int channel;
-
-	for (channel = 0; channel < 8; channel++)
-		if (((data[0] >> channel) & 0x01) != 0)
-			outb((((data[1] >> channel) & 0x01) << 3) | channel,
-			     dev->iobase + ADQ12B_OUTBR);
-
-	/* store information to retrieve when asked for reading */
-	if (data[0]) {
-		devpriv->digital_state &= ~data[0];
-		devpriv->digital_state |= (data[0] & data[1]);
-	}
-
-	data[1] = devpriv->digital_state;
+static const struct adq12b_board adq12b_boards[] = {
+	{
+		.name		= "adq12b",
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 12,
+		.di_chans	= 5,
+		.do_chans	= 8,
+	},
+};
 
-	return 2;
-}
+static struct comedi_driver driver_adq12b = {
+	.driver_name	= "adq12b",
+	.module		= THIS_MODULE,
+	.attach		= adq12b_attach,
+	.detach		= adq12b_detach,
+	.board_name	= &adq12b_boards[0].name,
+	.offset		= sizeof(struct adq12b_board),
+	.num_names	= ARRAY_SIZE(adq12b_boards),
+};
 
-/*
- * A convenient macro that defines init_module() and cleanup_module(),
- * as necessary.
- */
 static int __init driver_adq12b_init_module(void)
 {
 	return comedi_driver_register(&driver_adq12b);
 }
+module_init(driver_adq12b_init_module);
 
 static void __exit driver_adq12b_cleanup_module(void)
 {
 	comedi_driver_unregister(&driver_adq12b);
 }
-
-module_init(driver_adq12b_init_module);
 module_exit(driver_adq12b_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
