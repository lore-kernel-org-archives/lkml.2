Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2JKEck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:32:40 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:7941 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JKEci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:32:38 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 10 Oct 2012 20:59:42 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: RE: [RFC PATCH 05/06] input/rmi4: F01 - device control
Thread-Topic: [RFC PATCH 05/06] input/rmi4: F01 - device control
Thread-Index: AQHNo3jMWEVcNZCkZke2n4nX14kQ+JexMBiAgAJcCC0=
Date: Thu, 11 Oct 2012 04:34:36 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922C22C7D@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-6-git-send-email-cheiny@synaptics.com>,<CACRpkdZht7RfL48FjxnCKD9R7tHaKdQjM=hO47coMkoctPH_tw@mail.gmail.com>
In-Reply-To: <CACRpkdZht7RfL48FjxnCKD9R7tHaKdQjM=hO47coMkoctPH_tw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.10.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> On Sat, Oct 6, 2012 at 6:10 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
> > RMI Function 01 implements basic device control and power management
> > behaviors for the RMI4 sensor.  Since the last patch, we've decoupled
> > rmi_f01.c implementation from rmi_driver.c, so rmi_f01.c acts as a
> > standard driver module to handle F01 devices on the RMI bus.
> > 
> > Like other modules, a number of attributes have been moved from sysfs to
> > debugfs, depending on their expected use.
> > 
> > 
> > rmi_f01.h exports definitions that we expect to be used by other
> > functionality in the future (such as firmware reflash).
> > 
> > 
> > Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
> > 
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: Linus Walleij <linus.walleij@stericsson.com>
> > Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> > Cc: Joeri de Gram <j.de.gram@gmail.com>
> > 
> > ---
> 
> There is liberal whitespacing above. (No big deal, but anyway.)
> 
> (...)
> 
> > +/**
> > + * @reset - set this bit to force a firmware reset of the sensor.
> > + */
> > +union f01_device_commands {
> > +       struct {
> > +               bool reset:1;
> > +               u8 reserved:7;
> > +       } __attribute__((__packed__));
> > +       u8 reg;
> > +};
> 
> I'm still scared by these unions. I see what you're doing but my
> preferred style of driver writing is to use a simple u8 if you just treat
> it the right way with some |= and &= ...
> 
> #include <linux/bitops.h>
> 
> #define F01_RESET BIT(0)
> 
> u8 my_command = F01_RESET;
> 
> send(&my_command);
> 
> I will not insist on this because it's a bit about programming style.
> For memory-mapped devices we usually do it my way, but this
> is more like some protocol and I know protocols like to do things
> with structs and stuff so no big deal.

That's a good summary of what we're trying to do.  Our original version did more of the traditional mask+shift approach to manipulating the fields in the various registers, but in the case of complicated functions such as F11 this rapidly became unreadable.  We found the unions worked a lot better - the code was more readable and less error prone.  For consistency we decided to apply them throughout the code.

> 
> > +#ifdef CONFIG_RMI4_DEBUG
> > +struct f01_debugfs_data {
> > +       bool done;
> > +       struct rmi_function_container *fc;
> > +};
> > +
> > +static int f01_debug_open(struct inode *inodep, struct file *filp)
> > +{
> > +       struct f01_debugfs_data *data;
> > +       struct rmi_function_container *fc = inodep->i_private;
> > +
> > +       data = devm_kzalloc(&fc->dev, sizeof(struct f01_debugfs_data),
> > +               GFP_KERNEL);
> 
> Wait, you probably did this because I requested it, but I was maybe
> wrong?
> 
> Will this not re-allocate a chunk every time you look at a debugfs
> file? So it leaks memory?
> 
> In that case common kzalloc() and kfree() is the way to go, as it
> is for dynamic buffers. Sorry for screwing things up for you.

No problem - we'll fix it.  Or unfix it.  Or something like that. :-)


> 
> > +       for (i = 0; i < f01->irq_count && *local_buf != 0;
> > +            i++, local_buf += 2) {
> > +               int irq_shift;
> > +               int interrupt_enable;
> > +               int result;
> > +
> > +               irq_reg = i / 8;
> > +               irq_shift = i % 8;
> 
> Please stop doing these arithmetics-turned-maths things.
> 
> irq_reg = i >> 8;
> irq_shift = i & 0xFF;

See note on this in a previous email.

> 
> (...)
> 
> > +static ssize_t rmi_fn_01_interrupt_enable_show(struct device *dev,
> > +                               struct device_attribute *attr, char *buf)
> > +{
> > +       struct rmi_function_container *fc;
> > +       struct f01_data *data;
> > +       int i, len, total_len = 0;
> > +       char *current_buf = buf;
> > +
> > +       fc = to_rmi_function_container(dev);
> > +       data = fc->data;
> > +       /* loop through each irq value and copy its
> > +        * string representation into buf */
> > +       for (i = 0; i < data->irq_count; i++) {
> > +               int irq_reg;
> > +               int irq_shift;
> > +               int interrupt_enable;
> > +
> > +               irq_reg = i / 8;
> > +               irq_shift = i % 8;
> 
> Dito.
> 
> (...)
> 
> > +static int f01_probe(struct device *dev);
> 
> Do you really need to forward-declare this?

It's a leftover from the process of eliminating roll-your-own bus implementation, and move the other code around as well.  (same applies for similar code in rmi_f11.c).

> 
> (...)
> 
> > +static struct rmi_function_handler function_handler = {
> > +       .driver = {
> > +               .owner = THIS_MODULE,
> > +               .name = "rmi_f01",
> > +               .bus = &rmi_bus_type,
> > +               .probe = f01_probe,
> > +               .remove = f01_remove_device,
> > +       },
> > +       .func = 0x01,
> > +       .config = rmi_f01_config,
> > +       .attention = rmi_f01_attention,
> > +
> > +#ifdef CONFIG_PM
> > +       .suspend = rmi_f01_suspend,
> > +       .resume = rmi_f01_resume,
> > +#endif  /* CONFIG_PM */
> > +};
> 
> Just move this block of struct below the probe function...
> 
> > +static __devinit int f01_probe(struct device *dev)
> 
> Header file looks OK (if these unions is the way to go...)
> 
> Yours,
> Linus Walleij