Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967074Ab2EOXf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:35:57 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:36436 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966132Ab2EOXfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:35:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1337124918!5625458!25
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor dt2811 driver and use module_comedi_driver
Date: Tue, 15 May 2012 16:35:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151635.38869.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive to the end of the source. This is more
typical of how other drivers are written and removes the need
for the forward declarations.

Refactor some of the other functions to remove the remaining
forward declarations.

Convert the driver to use the module_comedi_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/dt2811.c |  303 ++++++++++++++-----------------
 1 files changed, 137 insertions(+), 166 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 0131d52..2292426 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -211,61 +211,8 @@ struct dt2811_board {
 	const struct comedi_lrange *unip_5;
 };
 
-static const struct dt2811_board boardtypes[] = {
-	{"dt2811-pgh",
-	 &range_dt2811_pgh_ai_5_bipolar,
-	 &range_dt2811_pgh_ai_2_5_bipolar,
-	 &range_dt2811_pgh_ai_5_unipolar,
-	 },
-	{"dt2811-pgl",
-	 &range_dt2811_pgl_ai_5_bipolar,
-	 &range_dt2811_pgl_ai_2_5_bipolar,
-	 &range_dt2811_pgl_ai_5_unipolar,
-	 },
-};
-
 #define this_board ((const struct dt2811_board *)dev->board_ptr)
 
-static int dt2811_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int dt2811_detach(struct comedi_device *dev);
-static struct comedi_driver driver_dt2811 = {
-	.driver_name = "dt2811",
-	.module = THIS_MODULE,
-	.attach = dt2811_attach,
-	.detach = dt2811_detach,
-	.board_name = &boardtypes[0].name,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.offset = sizeof(struct dt2811_board),
-};
-
-static int __init driver_dt2811_init_module(void)
-{
-	return comedi_driver_register(&driver_dt2811);
-}
-
-static void __exit driver_dt2811_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dt2811);
-}
-
-module_init(driver_dt2811_init_module);
-module_exit(driver_dt2811_cleanup_module);
-
-static int dt2811_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
-static int dt2811_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data);
-static int dt2811_ao_insn_read(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int dt2811_di_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int dt2811_do_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-
 enum { card_2811_pgh, card_2811_pgl };
 
 struct dt2811_private {
@@ -317,6 +264,120 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
 }
 #endif
 
+static int dt2811_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
+			  struct comedi_insn *insn, unsigned int *data)
+{
+	int chan = CR_CHAN(insn->chanspec);
+	int timeout = DT2811_TIMEOUT;
+	int i;
+
+	for (i = 0; i < insn->n; i++) {
+		outb(chan, dev->iobase + DT2811_ADGCR);
+
+		while (timeout
+		       && inb(dev->iobase + DT2811_ADCSR) & DT2811_ADBUSY)
+			timeout--;
+		if (!timeout)
+			return -ETIME;
+
+		data[i] = inb(dev->iobase + DT2811_ADDATLO);
+		data[i] |= inb(dev->iobase + DT2811_ADDATHI) << 8;
+		data[i] &= 0xfff;
+	}
+
+	return i;
+}
+
+#if 0
+/* Wow.  This is code from the Comedi stone age.  But it hasn't been
+ * replaced, so I'll let it stay. */
+int dt2811_adtrig(kdev_t minor, comedi_adtrig *adtrig)
+{
+	struct comedi_device *dev = comedi_devices + minor;
+
+	if (adtrig->n < 1)
+		return 0;
+	dev->curadchan = adtrig->chan;
+	switch (dev->i_admode) {
+	case COMEDI_MDEMAND:
+		dev->ntrig = adtrig->n - 1;
+		/* not necessary */
+		/*printk("dt2811: AD soft trigger\n"); */
+		/*outb(DT2811_CLRERROR|DT2811_INTENB,
+			dev->iobase+DT2811_ADCSR); */
+		outb(dev->curadchan, dev->iobase + DT2811_ADGCR);
+		do_gettimeofday(&trigtime);
+		break;
+	case COMEDI_MCONTS:
+		dev->ntrig = adtrig->n;
+		break;
+	}
+
+	return 0;
+}
+#endif
+
+static int dt2811_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
+			  struct comedi_insn *insn, unsigned int *data)
+{
+	int i;
+	int chan;
+
+	chan = CR_CHAN(insn->chanspec);
+
+	for (i = 0; i < insn->n; i++) {
+		outb(data[i] & 0xff, dev->iobase + DT2811_DADAT0LO + 2 * chan);
+		outb((data[i] >> 8) & 0xff,
+		     dev->iobase + DT2811_DADAT0HI + 2 * chan);
+		devpriv->ao_readback[chan] = data[i];
+	}
+
+	return i;
+}
+
+static int dt2811_ao_insn_read(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	int i;
+	int chan;
+
+	chan = CR_CHAN(insn->chanspec);
+
+	for (i = 0; i < insn->n; i++)
+		data[i] = devpriv->ao_readback[chan];
+
+	return i;
+}
+
+static int dt2811_di_insn_bits(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	if (insn->n != 2)
+		return -EINVAL;
+
+	data[1] = inb(dev->iobase + DT2811_DIO);
+
+	return 2;
+}
+
+static int dt2811_do_insn_bits(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	if (insn->n != 2)
+		return -EINVAL;
+
+	s->state &= ~data[0];
+	s->state |= data[0] & data[1];
+	outb(s->state, dev->iobase + DT2811_DIO);
+
+	data[1] = s->state;
+
+	return 2;
+}
+
 /*
   options[0]   Board base address
   options[1]   IRQ
@@ -337,7 +398,6 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
 		 1 == bipolar 2.5V  (-2.5V -- +2.5V)
 		 2 == unipolar 5V  (0V -- +5V)
 */
-
 static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	/* int i, irq; */
@@ -523,119 +583,30 @@ static int dt2811_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int dt2811_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data)
-{
-	int chan = CR_CHAN(insn->chanspec);
-	int timeout = DT2811_TIMEOUT;
-	int i;
-
-	for (i = 0; i < insn->n; i++) {
-		outb(chan, dev->iobase + DT2811_ADGCR);
-
-		while (timeout
-		       && inb(dev->iobase + DT2811_ADCSR) & DT2811_ADBUSY)
-			timeout--;
-		if (!timeout)
-			return -ETIME;
-
-		data[i] = inb(dev->iobase + DT2811_ADDATLO);
-		data[i] |= inb(dev->iobase + DT2811_ADDATHI) << 8;
-		data[i] &= 0xfff;
-	}
-
-	return i;
-}
-
-#if 0
-/* Wow.  This is code from the Comedi stone age.  But it hasn't been
- * replaced, so I'll let it stay. */
-int dt2811_adtrig(kdev_t minor, comedi_adtrig *adtrig)
-{
-	struct comedi_device *dev = comedi_devices + minor;
-
-	if (adtrig->n < 1)
-		return 0;
-	dev->curadchan = adtrig->chan;
-	switch (dev->i_admode) {
-	case COMEDI_MDEMAND:
-		dev->ntrig = adtrig->n - 1;
-		/* not necessary */
-		/*printk("dt2811: AD soft trigger\n"); */
-		/*outb(DT2811_CLRERROR|DT2811_INTENB,
-			dev->iobase+DT2811_ADCSR); */
-		outb(dev->curadchan, dev->iobase + DT2811_ADGCR);
-		do_gettimeofday(&trigtime);
-		break;
-	case COMEDI_MCONTS:
-		dev->ntrig = adtrig->n;
-		break;
-	}
-
-	return 0;
-}
-#endif
-
-static int dt2811_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
-			  struct comedi_insn *insn, unsigned int *data)
-{
-	int i;
-	int chan;
-
-	chan = CR_CHAN(insn->chanspec);
-
-	for (i = 0; i < insn->n; i++) {
-		outb(data[i] & 0xff, dev->iobase + DT2811_DADAT0LO + 2 * chan);
-		outb((data[i] >> 8) & 0xff,
-		     dev->iobase + DT2811_DADAT0HI + 2 * chan);
-		devpriv->ao_readback[chan] = data[i];
-	}
-
-	return i;
-}
-
-static int dt2811_ao_insn_read(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	int i;
-	int chan;
-
-	chan = CR_CHAN(insn->chanspec);
-
-	for (i = 0; i < insn->n; i++)
-		data[i] = devpriv->ao_readback[chan];
-
-	return i;
-}
-
-static int dt2811_di_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	if (insn->n != 2)
-		return -EINVAL;
-
-	data[1] = inb(dev->iobase + DT2811_DIO);
-
-	return 2;
-}
-
-static int dt2811_do_insn_bits(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	if (insn->n != 2)
-		return -EINVAL;
-
-	s->state &= ~data[0];
-	s->state |= data[0] & data[1];
-	outb(s->state, dev->iobase + DT2811_DIO);
-
-	data[1] = s->state;
+static const struct dt2811_board boardtypes[] = {
+	{
+		.name		= "dt2811-pgh",
+		.bip_5		= &range_dt2811_pgh_ai_5_bipolar,
+		.bip_2_5	= &range_dt2811_pgh_ai_2_5_bipolar,
+		.unip_5		= &range_dt2811_pgh_ai_5_unipolar,
+	}, {
+		.name		= "dt2811-pgl",
+		.bip_5		= &range_dt2811_pgl_ai_5_bipolar,
+		.bip_2_5	= &range_dt2811_pgl_ai_2_5_bipolar,
+		.unip_5		= &range_dt2811_pgl_ai_5_unipolar,
+	},
+};
 
-	return 2;
-}
+static struct comedi_driver dt2811_driver = {
+	.driver_name	= "dt2811",
+	.module		= THIS_MODULE,
+	.attach		= dt2811_attach,
+	.detach		= dt2811_detach,
+	.board_name	= &boardtypes[0].name,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.offset		= sizeof(struct dt2811_board),
+};
+module_comedi_driver(dt2811_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
