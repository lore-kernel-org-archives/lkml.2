Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967052Ab2EOX2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:28:34 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:55370 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965947Ab2EOX2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:28:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1337124512!5272237!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor dt2801 driver and use module_comedi_driver
Date: Tue, 15 May 2012 16:28:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151628.28110.hartleys@visionengravers.com>
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

 drivers/staging/comedi/drivers/dt2801.c |  279 ++++++++++++++-----------------
 1 files changed, 124 insertions(+), 155 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index b85c836..7aafd85 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -88,29 +88,6 @@ Configuration options:
 #define DT2801_STATUS		1
 #define DT2801_CMD		1
 
-static int dt2801_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int dt2801_detach(struct comedi_device *dev);
-static struct comedi_driver driver_dt2801 = {
-	.driver_name = "dt2801",
-	.module = THIS_MODULE,
-	.attach = dt2801_attach,
-	.detach = dt2801_detach,
-};
-
-static int __init driver_dt2801_init_module(void)
-{
-	return comedi_driver_register(&driver_dt2801);
-}
-
-static void __exit driver_dt2801_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dt2801);
-}
-
-module_init(driver_dt2801_init_module);
-module_exit(driver_dt2801_cleanup_module);
-
 #if 0
 /* ignore 'defined but not used' warning */
 static const struct comedi_lrange range_dt2801_ai_pgh_bipolar = { 4, {
@@ -258,22 +235,6 @@ struct dt2801_private {
 
 #define devpriv ((struct dt2801_private *)dev->private)
 
-static int dt2801_ai_insn_read(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int dt2801_ao_insn_read(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int dt2801_ao_insn_write(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-static int dt2801_dio_insn_bits(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data);
-static int dt2801_dio_insn_config(struct comedi_device *dev,
-				  struct comedi_subdevice *s,
-				  struct comedi_insn *insn, unsigned int *data);
-
 /* These are the low-level routines:
    writecommand: write a command to the board
    writedata: write data byte
@@ -503,6 +464,123 @@ static const struct comedi_lrange *ai_range_lkup(int type, int opt)
 	return &range_unknown;
 }
 
+static int dt2801_error(struct comedi_device *dev, int stat)
+{
+	if (stat < 0) {
+		if (stat == -ETIME)
+			printk("dt2801: timeout\n");
+		else
+			printk("dt2801: error %d\n", stat);
+		return stat;
+	}
+	printk("dt2801: error status 0x%02x, resetting...\n", stat);
+
+	dt2801_reset(dev);
+	dt2801_reset(dev);
+
+	return -EIO;
+}
+
+static int dt2801_ai_insn_read(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	int d;
+	int stat;
+	int i;
+
+	for (i = 0; i < insn->n; i++) {
+		stat = dt2801_writecmd(dev, DT_C_READ_ADIM);
+		dt2801_writedata(dev, CR_RANGE(insn->chanspec));
+		dt2801_writedata(dev, CR_CHAN(insn->chanspec));
+		stat = dt2801_readdata2(dev, &d);
+
+		if (stat != 0)
+			return dt2801_error(dev, stat);
+
+		data[i] = d;
+	}
+
+	return i;
+}
+
+static int dt2801_ao_insn_read(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
+{
+	data[0] = devpriv->ao_readback[CR_CHAN(insn->chanspec)];
+
+	return 1;
+}
+
+static int dt2801_ao_insn_write(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn, unsigned int *data)
+{
+	dt2801_writecmd(dev, DT_C_WRITE_DAIM);
+	dt2801_writedata(dev, CR_CHAN(insn->chanspec));
+	dt2801_writedata2(dev, data[0]);
+
+	devpriv->ao_readback[CR_CHAN(insn->chanspec)] = data[0];
+
+	return 1;
+}
+
+static int dt2801_dio_insn_bits(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn, unsigned int *data)
+{
+	int which = 0;
+
+	if (s == dev->subdevices + 4)
+		which = 1;
+
+	if (insn->n != 2)
+		return -EINVAL;
+	if (data[0]) {
+		s->state &= ~data[0];
+		s->state |= (data[0] & data[1]);
+		dt2801_writecmd(dev, DT_C_WRITE_DIG);
+		dt2801_writedata(dev, which);
+		dt2801_writedata(dev, s->state);
+	}
+	dt2801_writecmd(dev, DT_C_READ_DIG);
+	dt2801_writedata(dev, which);
+	dt2801_readdata(dev, data + 1);
+
+	return 2;
+}
+
+static int dt2801_dio_insn_config(struct comedi_device *dev,
+				  struct comedi_subdevice *s,
+				  struct comedi_insn *insn, unsigned int *data)
+{
+	int which = 0;
+
+	if (s == dev->subdevices + 4)
+		which = 1;
+
+	/* configure */
+	switch (data[0]) {
+	case INSN_CONFIG_DIO_OUTPUT:
+		s->io_bits = 0xff;
+		dt2801_writecmd(dev, DT_C_SET_DIGOUT);
+		break;
+	case INSN_CONFIG_DIO_INPUT:
+		s->io_bits = 0;
+		dt2801_writecmd(dev, DT_C_SET_DIGIN);
+		break;
+	case INSN_CONFIG_DIO_QUERY:
+		data[1] = s->io_bits ? COMEDI_OUTPUT : COMEDI_INPUT;
+		return insn->n;
+	default:
+		return -EINVAL;
+	}
+	dt2801_writedata(dev, which);
+
+	return 1;
+}
+
 /*
    options:
 	[0] - i/o base
@@ -623,122 +701,13 @@ static int dt2801_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static int dt2801_error(struct comedi_device *dev, int stat)
-{
-	if (stat < 0) {
-		if (stat == -ETIME)
-			printk("dt2801: timeout\n");
-		else
-			printk("dt2801: error %d\n", stat);
-		return stat;
-	}
-	printk("dt2801: error status 0x%02x, resetting...\n", stat);
-
-	dt2801_reset(dev);
-	dt2801_reset(dev);
-
-	return -EIO;
-}
-
-static int dt2801_ai_insn_read(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	int d;
-	int stat;
-	int i;
-
-	for (i = 0; i < insn->n; i++) {
-		stat = dt2801_writecmd(dev, DT_C_READ_ADIM);
-		dt2801_writedata(dev, CR_RANGE(insn->chanspec));
-		dt2801_writedata(dev, CR_CHAN(insn->chanspec));
-		stat = dt2801_readdata2(dev, &d);
-
-		if (stat != 0)
-			return dt2801_error(dev, stat);
-
-		data[i] = d;
-	}
-
-	return i;
-}
-
-static int dt2801_ao_insn_read(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data)
-{
-	data[0] = devpriv->ao_readback[CR_CHAN(insn->chanspec)];
-
-	return 1;
-}
-
-static int dt2801_ao_insn_write(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data)
-{
-	dt2801_writecmd(dev, DT_C_WRITE_DAIM);
-	dt2801_writedata(dev, CR_CHAN(insn->chanspec));
-	dt2801_writedata2(dev, data[0]);
-
-	devpriv->ao_readback[CR_CHAN(insn->chanspec)] = data[0];
-
-	return 1;
-}
-
-static int dt2801_dio_insn_bits(struct comedi_device *dev,
-				struct comedi_subdevice *s,
-				struct comedi_insn *insn, unsigned int *data)
-{
-	int which = 0;
-
-	if (s == dev->subdevices + 4)
-		which = 1;
-
-	if (insn->n != 2)
-		return -EINVAL;
-	if (data[0]) {
-		s->state &= ~data[0];
-		s->state |= (data[0] & data[1]);
-		dt2801_writecmd(dev, DT_C_WRITE_DIG);
-		dt2801_writedata(dev, which);
-		dt2801_writedata(dev, s->state);
-	}
-	dt2801_writecmd(dev, DT_C_READ_DIG);
-	dt2801_writedata(dev, which);
-	dt2801_readdata(dev, data + 1);
-
-	return 2;
-}
-
-static int dt2801_dio_insn_config(struct comedi_device *dev,
-				  struct comedi_subdevice *s,
-				  struct comedi_insn *insn, unsigned int *data)
-{
-	int which = 0;
-
-	if (s == dev->subdevices + 4)
-		which = 1;
-
-	/* configure */
-	switch (data[0]) {
-	case INSN_CONFIG_DIO_OUTPUT:
-		s->io_bits = 0xff;
-		dt2801_writecmd(dev, DT_C_SET_DIGOUT);
-		break;
-	case INSN_CONFIG_DIO_INPUT:
-		s->io_bits = 0;
-		dt2801_writecmd(dev, DT_C_SET_DIGIN);
-		break;
-	case INSN_CONFIG_DIO_QUERY:
-		data[1] = s->io_bits ? COMEDI_OUTPUT : COMEDI_INPUT;
-		return insn->n;
-	default:
-		return -EINVAL;
-	}
-	dt2801_writedata(dev, which);
-
-	return 1;
-}
+static struct comedi_driver dt2801_driver = {
+	.driver_name	= "dt2801",
+	.module		= THIS_MODULE,
+	.attach		= dt2801_attach,
+	.detach		= dt2801_detach,
+};
+module_comedi_driver(dt2801_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
