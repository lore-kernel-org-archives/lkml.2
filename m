Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab2DYXD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 19:03:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:41989 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab2DYXDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 19:03:23 -0400
Date: Thu, 26 Apr 2012 01:03:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        open list <linux-kernel@vger.kernel.org>,
        alexander.stein@systec-electronic.com, qi.wang@intel.com,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: gpio-pch: BUG - driver does not honour IRQF_ONESHOTn
In-Reply-To: <CA46BB56-61AD-45E9-8D03-906B71C21C71@gmail.com>
Message-ID: <alpine.LFD.2.02.1204252332070.2542@ionos>
References: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1311207599-2553-6-git-send-email-tomoya-linux@dsn.okisemi.com> <3D60A4A2-3538-4B24-B65B-219D6ED7B219@gmail.com> <CA46BB56-61AD-45E9-8D03-906B71C21C71@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012, Jean-Francois Dagenais wrote:

> Isn't anyone concerned with this? I am replying to myself to provoke a response.

Here you go.
 
> Configuring a gpio pin with the gpio-pch driver with
> "IRQF_TRIGGER_LOW | IRQF_ONESHOT" generates an interrupt
> storm for threaded ISR until the ISR thread actually gets to physically clear
> the interrupt on the triggering chip!! The immediate observable symptom
> is the high CPU usage for my ISR thread task and the interrupt count in
> /proc/interrupts incrementing radically.
> See below for more details.
> 

> > Unfortunately, since all of the handling of the adp5588 is done in
> > a thread function, the interrupt stays low between the moment the
> > hard handler is run and the 5588 function is run. Since
> > pch_gpio_handler clears the interrupt status right away, I get an
> > interrupt storm for the pch_gpio_handler function.

> > the line that does "iowrite32(BIT(i), &chip->reg->iclr);" right
> > before calling generic_handle_irq should be executed only after
> > the corresponding nested ISR has run it's thread function.

Sigh, that driver is broken in several ways.

Does the following untested patch solve your problem?

It's not complete and I neither have access to that hardware nor did I
bother to look for docs.

Fact is, that using handle_simple_irq is preventing the usage of
oneshot threaded handlers for the demultiplexed interrupts, because
the simple handler does not deal with masking/unmasking. So yes you
run into an irq storm.

The "ack" of the sub interrupt before calling the handler is crap as
well. Though it kinda works as long as you are not using threaded
interrupts... 

The other nonsense is that the set_type function unconditionally
enables the interrupt. It's supposed to set the type and nothing
else. The unmasking is done by the core code. If that hardware
requires to do the type changes in masked state, then it should
indicate it to the core by adding the IRQCHIP_SET_TYPE_MASKED flag to
the irq chip. But I can't see it masking it. I just see the
unconditional unmask and enable. Looks like one of those, it works but
we don't know why thingies....

That said, the patch is just done from my core code POV and the
limited information I was able to pull out of the driver code.

Thanks,

	tglx

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index e8729cc..8b92fec 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -230,16 +230,12 @@ static void pch_gpio_setup(struct pch_gpio *chip)
 
 static int pch_irq_type(struct irq_data *d, unsigned int type)
 {
-	u32 im;
-	u32 __iomem *im_reg;
-	u32 ien;
-	u32 im_pos;
-	int ch;
-	unsigned long flags;
-	u32 val;
-	int irq = d->irq;
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct pch_gpio *chip = gc->private;
+	u32 im, im_pos, val;
+	u32 __iomem *im_reg;
+	unsigned long flags;
+	int ch, irq = d->irq;
 
 	ch = irq - chip->irq_base;
 	if (irq <= chip->irq_base + 7) {
@@ -270,30 +266,22 @@ static int pch_irq_type(struct irq_data *d, unsigned int type)
 	case IRQ_TYPE_LEVEL_LOW:
 		val = PCH_LEVEL_L;
 		break;
-	case IRQ_TYPE_PROBE:
-		goto end;
 	default:
-		dev_warn(chip->dev, "%s: unknown type(%dd)",
-			__func__, type);
-		goto end;
+		goto unlock;
 	}
 
 	/* Set interrupt mode */
 	im = ioread32(im_reg) & ~(PCH_IM_MASK << (im_pos * 4));
 	iowrite32(im | (val << (im_pos * 4)), im_reg);
 
-	/* iclr */
-	iowrite32(BIT(ch), &chip->reg->iclr);
+	/* And the handler */
+	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+		__irq_set_handler_locked(d->irq, handle_level_irq);
+	else if (type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
 
-	/* IMASKCLR */
-	iowrite32(BIT(ch), &chip->reg->imaskclr);
-
-	/* Enable interrupt */
-	ien = ioread32(&chip->reg->ien);
-	iowrite32(ien | BIT(ch), &chip->reg->ien);
-end:
+unlock:
 	spin_unlock_irqrestore(&chip->spinlock, flags);
-
 	return 0;
 }
 
@@ -313,18 +301,24 @@ static void pch_irq_mask(struct irq_data *d)
 	iowrite32(1 << (d->irq - chip->irq_base), &chip->reg->imask);
 }
 
+static void pch_irq_ack(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct pch_gpio *chip = gc->private;
+
+	iowrite32(1 << (d->irq - chip->irq_base), &chip->reg->iclr);
+}
+
 static irqreturn_t pch_gpio_handler(int irq, void *dev_id)
 {
 	struct pch_gpio *chip = dev_id;
 	u32 reg_val = ioread32(&chip->reg->istatus);
-	int i;
-	int ret = IRQ_NONE;
+	int i, ret = IRQ_NONE;
 
 	for (i = 0; i < gpio_pins[chip->ioh]; i++) {
 		if (reg_val & BIT(i)) {
 			dev_dbg(chip->dev, "%s:[%d]:irq=%d  status=0x%x\n",
 				__func__, i, irq, reg_val);
-			iowrite32(BIT(i), &chip->reg->iclr);
 			generic_handle_irq(chip->irq_base + i);
 			ret = IRQ_HANDLED;
 		}
@@ -343,6 +337,7 @@ static __devinit void pch_gpio_alloc_generic_chip(struct pch_gpio *chip,
 	gc->private = chip;
 	ct = gc->chip_types;
 
+	ct->chip.irq_ack = pch_irq_ack;
 	ct->chip.irq_mask = pch_irq_mask;
 	ct->chip.irq_unmask = pch_irq_unmask;
 	ct->chip.irq_set_type = pch_irq_type;
@@ -357,6 +352,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 	s32 ret;
 	struct pch_gpio *chip;
 	int irq_base;
+	u32 msk;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -418,8 +414,10 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 
 	pch_gpio_alloc_generic_chip(chip, irq_base, gpio_pins[chip->ioh]);
 
-	/* Initialize interrupt ien register */
-	iowrite32(0, &chip->reg->ien);
+	/* Mask all interrupts, but enable them */
+	msk = (1 << gpio_pins[chip->ioh]) - 1;
+	iowrite32(msk, &chip->reg->imask);
+	iowrite32(msk, &chip->reg->ien);
 end:
 	return 0;
 
