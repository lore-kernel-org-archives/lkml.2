Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2EEAJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 20:09:17 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:2713 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2EEAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 20:09:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1336176546!5579962!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor dt2814 driver and use module_comedi_driver
Date: Fri, 4 May 2012 17:09:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041709.03003.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the struct comedi_driver to the end of the source and refactor
the code to remove the forward declarations.

Convert the driver to use the module_comedi_driver() macro which
makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

diff --git a/drivers/staging/comedi/drivers/dt2814.c b/drivers/staging/comedi/drivers/dt2814.c
index 1c6248c..a935e9c 100644
--- a/drivers/staging/comedi/drivers/dt2814.c
+++ b/drivers/staging/comedi/drivers/dt2814.c
@@ -60,31 +60,6 @@ addition, the clock does not seem to be very accurate.
 #define DT2814_ENB 0x10
 #define DT2814_CHANMASK 0x0f
 
-static int dt2814_attach(struct comedi_device *dev,
-			 struct comedi_devconfig *it);
-static int dt2814_detach(struct comedi_device *dev);
-static struct comedi_driver driver_dt2814 = {
-	.driver_name = "dt2814",
-	.module = THIS_MODULE,
-	.attach = dt2814_attach,
-	.detach = dt2814_detach,
-};
-
-static int __init driver_dt2814_init_module(void)
-{
-	return comedi_driver_register(&driver_dt2814);
-}
-
-static void __exit driver_dt2814_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_dt2814);
-}
-
-module_init(driver_dt2814_init_module);
-module_exit(driver_dt2814_cleanup_module);
-
-static irqreturn_t dt2814_interrupt(int irq, void *dev);
-
 struct dt2814_private {
 
 	int ntrig;
@@ -260,6 +235,45 @@ static int dt2814_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 }
 
+static irqreturn_t dt2814_interrupt(int irq, void *d)
+{
+	int lo, hi;
+	struct comedi_device *dev = d;
+	struct comedi_subdevice *s;
+	int data;
+
+	if (!dev->attached) {
+		comedi_error(dev, "spurious interrupt");
+		return IRQ_HANDLED;
+	}
+
+	s = dev->subdevices + 0;
+
+	hi = inb(dev->iobase + DT2814_DATA);
+	lo = inb(dev->iobase + DT2814_DATA);
+
+	data = (hi << 4) | (lo >> 4);
+
+	if (!(--devpriv->ntrig)) {
+		int i;
+
+		outb(0, dev->iobase + DT2814_CSR);
+		/* note: turning off timed mode triggers another
+		   sample. */
+
+		for (i = 0; i < DT2814_TIMEOUT; i++) {
+			if (inb(dev->iobase + DT2814_CSR) & DT2814_FINISH)
+				break;
+		}
+		inb(dev->iobase + DT2814_DATA);
+		inb(dev->iobase + DT2814_DATA);
+
+		s->async->events |= COMEDI_CB_EOA;
+	}
+	comedi_event(dev, s);
+	return IRQ_HANDLED;
+}
+
 static int dt2814_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	int i, irq;
@@ -360,44 +374,13 @@ static int dt2814_detach(struct comedi_device *dev)
 	return 0;
 }
 
-static irqreturn_t dt2814_interrupt(int irq, void *d)
-{
-	int lo, hi;
-	struct comedi_device *dev = d;
-	struct comedi_subdevice *s;
-	int data;
-
-	if (!dev->attached) {
-		comedi_error(dev, "spurious interrupt");
-		return IRQ_HANDLED;
-	}
-
-	s = dev->subdevices + 0;
-
-	hi = inb(dev->iobase + DT2814_DATA);
-	lo = inb(dev->iobase + DT2814_DATA);
-
-	data = (hi << 4) | (lo >> 4);
-
-	if (!(--devpriv->ntrig)) {
-		int i;
-
-		outb(0, dev->iobase + DT2814_CSR);
-		/* note: turning off timed mode triggers another
-		   sample. */
-
-		for (i = 0; i < DT2814_TIMEOUT; i++) {
-			if (inb(dev->iobase + DT2814_CSR) & DT2814_FINISH)
-				break;
-		}
-		inb(dev->iobase + DT2814_DATA);
-		inb(dev->iobase + DT2814_DATA);
-
-		s->async->events |= COMEDI_CB_EOA;
-	}
-	comedi_event(dev, s);
-	return IRQ_HANDLED;
-}
+static struct comedi_driver dt2814_driver = {
+	.driver_name	= "dt2814",
+	.module		= THIS_MODULE,
+	.attach		= dt2814_attach,
+	.detach		= dt2814_detach,
+};
+module_comedi_driver(dt2814_driver);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
