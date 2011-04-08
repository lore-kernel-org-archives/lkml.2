Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab1DHQLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:11:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51979 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab1DHQLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:11:17 -0400
Date: Fri, 8 Apr 2011 17:11:13 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, grant.likely@secretlab.ca,
        arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv2 6/7] basic_mmio_gpio: support different input/output
 registers
Message-ID: <20110408161113.GG2933@pulham.picochip.com>
References: <1302272211-30242-1-git-send-email-jamie@jamieiles.com>
 <1302272211-30242-7-git-send-email-jamie@jamieiles.com>
 <20110408144628.GC25237@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408144628.GC25237@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 06:46:28PM +0400, Anton Vorontsov wrote:
> On Fri, Apr 08, 2011 at 03:16:50PM +0100, Jamie Iles wrote:
> > Some controllers have separate input and output registers.  For these
> > controllers, allow a register named "in" to be used for reading the
> > value of a GPIO pin.
> > 
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > ---
> >  drivers/gpio/basic_mmio_gpio.c |   31 +++++++++++++++++++++++++++++--
> >  1 files changed, 29 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> > index 9be1867..ed4b0c6 100644
> > --- a/drivers/gpio/basic_mmio_gpio.c
> > +++ b/drivers/gpio/basic_mmio_gpio.c
> > @@ -70,6 +70,7 @@ struct bgpio_chip {
> >  	void __iomem *reg_dat;
> >  	void __iomem *reg_set;
> >  	void __iomem *reg_clr;
> > +	void __iomem *reg_in;
> 
> Btw, I wonder if it makes sense (and more logical) for separate output/
> input registers case to use "reg_dat" for 'input' and 'reg_set' for
> output?

Sounds like a good idea.  Something like this?

Jamie

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 054fbee..fc3826a 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -185,6 +185,24 @@ static void bgpio_set_with_clear(struct gpio_chip *gc, unsigned int gpio,
 		bgc->write_reg(bgc->reg_clr, mask);
 }
 
+static void bgpio_set_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	unsigned long mask = bgc->pin2mask(bgc, gpio);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	if (val)
+		bgc->data |= mask;
+	else
+		bgc->data &= ~mask;
+
+	bgc->write_reg(bgc->reg_set, bgc->data);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
 static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
 	return 0;
@@ -245,10 +263,12 @@ static int bgpio_setup_accessors(struct platform_device *pdev,
 
 /*
  * Create the device and allocate the resources.  For setting GPIO's there are
- * two supported configurations:
+ * three supported configurations:
  *
- *	- single output register resource (named "dat").
+ *	- single input/output register resource (named "dat").
  *	- set/clear pair (named "set" and "clr").
+ *	- single output register resource and single input resource ("set" and
+ *	dat").
  *
  * For the single output register, this drives a 1 by setting a bit and a zero
  * by clearing a bit.  For the set clr pair, this drives a 1 by setting a bit
@@ -260,6 +280,15 @@ static int bgpio_setup_io(struct platform_device *pdev,
 {
 	struct resource *res_set;
 	struct resource *res_clr;
+	struct resource *res_dat;
+
+	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
+	if (!res_dat)
+		return -EINVAL;
+
+	bgc->reg_dat = bgpio_request_and_map(&pdev->dev, res_dat);
+	if (!bgc->reg_dat)
+		return -ENOMEM;
 
 	res_set = platform_get_resource_byname(pdev, IORESOURCE_MEM, "set");
 	res_clr = platform_get_resource_byname(pdev, IORESOURCE_MEM, "clr");
@@ -274,12 +303,22 @@ static int bgpio_setup_io(struct platform_device *pdev,
 			return -ENOMEM;
 
 		bgc->gc.set = bgpio_set_with_clear;
-	} else if (res_set || res_clr) {
-		return -EINVAL;
+	} else if (res_set && !res_clr) {
+		if (resource_size(res_set) != resource_size(res_dat) ||
+		    resource_size(res_set) != bgc->bits / 8)
+			return -EINVAL;
+
+		bgc->reg_set = bgpio_request_and_map(&pdev->dev, res_set);
+		if (!bgc->reg_set)
+			return -ENOMEM;
+
+		bgc->gc.set = bgpio_set_set;
 	} else {
 		bgc->gc.set = bgpio_set;
 	}
 
+	bgc->gc.get = bgpio_get;
+
 	return 0;
 }
 
@@ -311,10 +350,6 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	if (!bgc)
 		return -ENOMEM;
 
-	bgc->reg_dat = bgpio_request_and_map(dev, res_dat);
-	if (!bgc->reg_dat)
-		return -ENOMEM;
-
 	if (pdata) {
 		bgc->gc.base = pdata->base;
 		if (pdata->ngpio > 0)
@@ -338,7 +373,6 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	bgc->gc.ngpio = ngpio;
 	bgc->gc.direction_input = bgpio_dir_in;
 	bgc->gc.direction_output = bgpio_dir_out;
-	bgc->gc.get = bgpio_get;
 	bgc->gc.dev = dev;
 	bgc->gc.label = dev_name(dev);
 
-- 
1.7.4.2

