Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2ALC1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:27:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53617 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2ALC1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:27:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120109082405.GA3167@legolas.emea.dhcp.ti.com>
References: <1324872283-12813-1-git-send-email-tomoya.rohm@gmail.com>
	<20120109082405.GA3167@legolas.emea.dhcp.ti.com>
Date: Thu, 12 Jan 2012 11:27:34 +0900
Message-ID: <CANKRQnjvNOvtVo+PNH=HQmxXtHAqRgP2h1wB1P58dmazEet_Ew@mail.gmail.com>
Subject: Re: [PATCH] usb/gadget/pch_udc: Fix ether gadget connect/disconnect issue
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Balbi

Please see my comment inline.
BTW, I've divided previous patch into six patches.
After this mail, I'll post the patch series soon.

2012/1/9 Felipe Balbi <balbi@ti.com>:
> > @@ -1126,7 +1166,23 @@ static int pch_udc_pcd_pullup(struct usb_
gadget *gadget, int is_on)
> >       if (!gadget)
> >               return -EINVAL;
> >       dev = container_of(gadget, struct pch_udc_dev, gadget);
> > -     pch_udc_vbus_session(dev, is_on);
> > +     if (is_on) {
> > +             if (dev->pullup == 1) {
> > +                     pch_udc_clear_disconnect(dev);
> > +             } else {
> > +                     pch_udc_reconnect(dev);
> > +                     dev->pullup = 1;
> > +             }
> > +     } else {
> > +             if (dev->driver && dev->driver->disconnect) {
> > +                     spin_unlock(&dev->lock);
> > +                     dev->driver->disconnect(&dev->gadget);
> > +                     spin_lock(&dev->lock);
>
> this looks very wrong. ->pullup() should not call into the gadget
> driver. Looking over your driver, it seems that one of the issues is
> that you have a race between ->vbus_session() and ->pullup() because
> they both call your pch_udc_vbus_session() without taking care of
> locking those two.

I was not careful about those two conflict. I make the condition simple.
Please see my new patch, and please give me your advice.
Please refer to new 4th patch.

> > @@ -2335,8 +2391,11 @@ static void pch_udc_svc_ur_interrupt(struct pch_udc_dev *dev)
> >               /* Complete request queue */
> >               empty_req_queue(ep);
> >       }
> > -     if (dev->driver && dev->driver->disconnect)
> > +     if (dev->driver && dev->driver->disconnect) {
> > +             spin_unlock(&dev->lock);
> >               dev->driver->disconnect(&dev->gadget);
> > +             spin_lock(&dev->lock);
>
> this needs to be fixed, indeed. And maybe it's the only thing which fits
> under $SUBJECT. Can you describe better the problem you're seeing ?
> Maybe showing any WARN()/BUG() output which showed up ?
>

After a USB cable is connect/disconnected, the system rarely freezes.
I do not have conclusive evidence that this is a root cause.
It was pointed out that this should call spin_unlock() and spin_lock()
by one user.
Please refer to new 1st patch.

> > @@ -2371,6 +2430,11 @@ static void pch_udc_svc_enum_interrupt(struct pch_udc_dev *dev)
> >       pch_udc_set_dma(dev, DMA_DIR_TX);
> >       pch_udc_set_dma(dev, DMA_DIR_RX);
> >       pch_udc_ep_set_rrdy(&(dev->ep[UDC_EP0OUT_IDX]));
> > +
> > +     /* enable device interrupts */
> > +     pch_udc_enable_interrupts(dev, UDC_DEVINT_UR | UDC_DEVINT_US |
> > +                                     UDC_DEVINT_ES | UDC_DEVINT_ENUM |
> > +                                     UDC_DEVINT_SI | UDC_DEVINT_SC);
>
> doesn't fit under $SUBJECT.

This is separated from this $SUBJECT.
Please refer to new 5th patch.

>
> > @@ -2460,11 +2524,15 @@ static void pch_udc_svc_cfg_interrupt(struct pch_udc_dev *dev)
> >  static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
> >  {
> >       /* USB Reset Interrupt */
> > -     if (dev_intr & UDC_DEVINT_UR)
> > +     if (dev_intr & UDC_DEVINT_UR) {
> >               pch_udc_svc_ur_interrupt(dev);
> > +             dev_dbg(&dev->pdev->dev, "USB_RESET\n");
>
> all these debugging message are _not_ part of $SUBJECT.
>

This is separated from this $SUBJECT.
Please refer to new 6th patch.

> > @@ -2472,8 +2540,25 @@ static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
> >       if (dev_intr & UDC_DEVINT_SC)
> >               pch_udc_svc_cfg_interrupt(dev);
> >       /* USB Suspend interrupt */
> > -     if (dev_intr & UDC_DEVINT_US)
> > +     if (dev_intr & UDC_DEVINT_US) {
> > +             if (dev->gadget.speed != USB_SPEED_UNKNOWN
>
> In fact, I would WARN() if your speed isn't known at this spot. This
> would mean you have a big fat bug on your controller driver.
>

It was not necessary to check speed in this spot.
gadget.speed = USB_SPEED_UNKNOWN is removed.
Please refer to new 3rd patch.


> > +                     && dev->driver
> > +                     && dev->driver->suspend) {
> > +                     spin_unlock(&dev->lock);
> > +                     dev->driver->suspend(&dev->gadget);
> > +                     spin_lock(&dev->lock);
>
> Indeed, this is the right way, but not part of $SUBJECT.

This is separated from this $SUBJECT.
Please refer to new 3rd patch.

> > +             }
> > +
> > +             if ((dev->vbus_session == 0) && (dev->pullup == 1)) {
> > +                     if (dev->driver && dev->driver->disconnect) {
> > +                             spin_unlock(&dev->lock);
> > +                             dev->driver->disconnect(&dev->gadget);
> > +                             spin_lock(&dev->lock);
>
> also correct, and looks part of $SUBJECT.

Please refer to new 4th patch.

> > @@ -2499,6 +2584,14 @@ static irqreturn_t pch_udc_isr(int irq, void *pdev)
> >       dev_intr = pch_udc_read_device_interrupts(dev);
> >       ep_intr = pch_udc_read_ep_interrupts(dev);
> >
> > +     /* For a hot plug, this find that the controller is hung up. */
> > +     if (dev_intr == ep_intr)
> > +             if (dev_intr == pch_udc_readl(dev, UDC_DEVCFG_ADDR)) {
> > +                     dev_dbg(&dev->pdev->dev, "UDC: Hung up\n");
> > +                     /* The controller is reset */
> > +                     pch_udc_writel(dev, UDC_SRST, UDC_SRST_ADDR);
> > +                     return IRQ_HANDLED;
> > +             }
> >       if (dev_intr)
> >               /* Clear device interrupts */
> >               pch_udc_write_device_interrupts(dev, dev_intr);
> > @@ -2725,7 +2818,7 @@ static int pch_udc_start(struct usb_gadget_driver *driver,
> >       pch_udc_setup_ep0(dev);
> >
> >       /* clear SD */
> > -     pch_udc_clear_disconnect(dev);
> > +     pch_udc_pcd_pullup(&dev->gadget, 1);
>
> this rings a bell, why do you need to change this ?

I wanted to set as 1 to dev->pullup.
However, this is not needed anymore.


> > @@ -2912,8 +3005,10 @@ static int pch_udc_probe(struct pci_dev *pdev,
> >       }
> >       pch_udc = dev;
> >       /* initialize the hardware */
> > -     if (pch_udc_pcd_init(dev))
> > +     if (pch_udc_pcd_init(dev)) {
> > +             retval = -ENODEV;
>
> not part of $SUBJECT but how about passing the return value from
> pch_udc_pcd_init() to upper layer instead of changing it here ?
>
> ret = pch_udc_pcd_init(dev);
> if (ret) {
>        ....
>

This is separated from this $ SUBJECT.
Your description is better.
However, I followed a similar description in this function.
Please refer to new 2nd patch.

thanks,
tomoya
