Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968168Ab2ERWfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:35:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967348Ab2ERWfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:35:34 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: add a driver for GPIO pins found on AMD-8111 south bridge chips
To: Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
In-Reply-To: <CACRpkdZbr9CvCWx_a2Cf1MiJE_FDLQM4qipqRbnTRw+jM8U7gA@mail.gmail.com>
References: <1335521331-16199-1-git-send-email-dbaryshkov@gmail.com> <CACRpkdZbr9CvCWx_a2Cf1MiJE_FDLQM4qipqRbnTRw+jM8U7gA@mail.gmail.com>
Date: Fri, 18 May 2012 16:35:32 -0600
Message-Id: <20120518223532.7029B3E07C8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 12:52:19 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Apr 27, 2012 at 12:08 PM, Dmitry Eremin-Solenikov
> <dbaryshkov@gmail.com> wrote:
> 
> > Add a driver to use GPIO pins available on several AMD south bridges
> > (currently only AMD 8111 is supported).
> >
> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> 
> Mainly nitpicks, it's looking good overall...

Hi Dimtry,

Do you have an updated version of this patch to address Linus' comments?

g.

> 
> > +       spin_lock_irqsave(&agp->lock, flags);
> > +       temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
> > +       temp = (temp & 0x1c) | (!!value);
> 
> This is a bit idomatic but I think I understand what's going on. However this
> 0x1C magic could be better of with some #define AMD_8111_GPIO_FOO don't
> you think?
> 
> > +static int amd_gpio_get(struct gpio_chip *chip, unsigned offset)
> > +{
> > +       struct amd_gpio *agp = to_agp(chip);
> > +       u8 temp;
> > +
> > +       temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
> > +
> > +       dev_dbg(&agp->pdev->dev, "Getting gpio %d, reg=%02x\n", offset, temp);
> > +
> > +       return !!(temp & 0x20);
> 
> And this could be #define AMD_8111_GPIO_INVAL or so (I bet this bit has a
> name in the datasheet, right?)
> 
> > +static int amd_gpio_dirout(struct gpio_chip *chip, unsigned offset, int value)
> > +{
> > +       struct amd_gpio *agp = to_agp(chip);
> > +       u8 temp;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&agp->lock, flags);
> > +       temp = ioread8(agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
> > +       temp = (temp & 0x10) | 0x4 | (!!value);
> 
> And so on...
> 
> > +       iowrite8(temp, agp->pm - PMBASE_OFFSET + PMBASE_GPIO(offset));
> > +       spin_unlock_irqrestore(&agp->lock, flags);
> > +
> > +       dev_dbg(&agp->pdev->dev, "Dirout gpio %d, value %d, reg=%02x\n", offset, !!value, temp);
> > +
> > +       return 0;
> > +}
> 
> > +static int __init mod_init(void)
> 
> amd_gpio_init() maybe? These names are nice for e.g. ftrace.
> 
> > +       printk(KERN_INFO "AMD-8111 GPIO detected\n");
> 
> pr_info() & friends are nice shorthands for this.
> 
> > +static void __exit mod_exit(void)
> 
> amd_gpio_mod_exit()?
> 
> > +MODULE_AUTHOR("The Linux Kernel team");
> 
> Don't be shy, put in your own name :-)
> 
> Yours,
> Linus Walleij

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
