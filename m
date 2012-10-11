Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab2JKEOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:14:03 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:56355 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2JKEN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:13:59 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 10 Oct 2012 20:41:03 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: RE: [RFC PATCH 02/06] input/rmi4: Core files
Thread-Topic: [RFC PATCH 02/06] input/rmi4: Core files
Thread-Index: AQHNo3hsaE1c+pCGsk+IENeTeYD9uJexIeeAgAJk6ms=
Date: Thu, 11 Oct 2012 04:15:56 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922C22C06@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-3-git-send-email-cheiny@synaptics.com>,<CACRpkdZ0cQPQHDCYiyQb+Qb_8nGh=4rw2CixKgAFvb-3c1LpSg@mail.gmail.com>
In-Reply-To: <CACRpkdZ0cQPQHDCYiyQb+Qb_8nGh=4rw2CixKgAFvb-3c1LpSg@mail.gmail.com>
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

On Thursday, October 11, 2012 02:21:53 AM you wrote:
> On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
> > rmi_bus.c implements the basic functionality of the RMI bus.  This file is
> > greatly simplified compared to the previous patch - we've switched from
> > "do it yourself" device/driver binding to using device_type to distinguish
> > between the two kinds of devices on the bus (sensor devices and function
> > specific devices) and using the standard bus implementation to manage
> > devices and drivers.
> 
> So I think you really want Greg KH to look at this bus implementation
> now. Please include Greg on future mailings...
> 
> It looks much improved from previous versions, and sorry if I am now
> adding even more comments, but it's because you cleared out some
> noise that was disturbing my perception so I can cleanly review
> the architecture of this thing now. (I'm impressed by your work and
> new high-speed turnaround time!)

Thanks for the praise - it means a lot to me and my team.

We'll cc Greg on the next patch drop.

[snip some items covered in a previous email]

> 
> (...)
> 
> > diff --git a/drivers/input/rmi4/rmi_driver.c
> > b/drivers/input/rmi4/rmi_driver.c

[snip some items covered in a previous email]

> 
> > +#define DELAY_NAME "delay"
> 
> This is only used in one place, why not just use the string
> "delay" there?
> 
> (...)
> 
> > +       if (IS_ENABLED(CONFIG_RMI4_SPI) && !strncmp("spi", info->proto,
> > 3)) { +               data->debugfs_delay =
> > debugfs_create_file(DELAY_NAME,
> > +                               RMI_RW_ATTR, rmi_dev->debugfs_root,
> > rmi_dev, +                               &delay_fops);
> 
> i.e. there.

That's a left-over.  We'll consolidate it.

> 
> (...)
> 
> > +/* Useful helper functions for u8* */
> > +
> > +static bool u8_is_any_set(u8 *target, int size)
> > +{
> > +       int i;
> > +       /* We'd like to use find_first_bit, but it ALWAYS returns 1,
> > +       *  no matter what we pass it.  So we have to do this the hard way.
> > +       *  return find_first_bit((long unsigned int *)  target, size) !=
> > 0;
> > +       */
> > +       for (i = 0; i < size; i++) {
> > +               if (target[i])
> > +                       return true;
> > +       }
> > +       return false;
> > +}
> 
> Instead of:
> 
> if (u8_is_any_set(foo, 128) {}
> 
> Why can't you use:
> 
> if (!bitmap_empty(foo, 128*8) {}
> 
> ?
> 
> If you look at the implementation in the <linux/bitmap.h> header
> and __bitmap_empty() in lib/bitmap.c you will realize that this
> function is already optimized like this (and I actually don't think
> the RMI4 code is performance-critical for these functions anyway,
> but prove me wrong!)

We'll give !bitmap_empty a try.

> 
> > +
> > +/** This is here because all those casts made for some ugly code.
> > + */
> > +static void u8_and(u8 *dest, u8 *target1, u8 *target2, int nbits)
> > +{
> > +       bitmap_and((long unsigned int *) dest,
> > +                  (long unsigned int *) target1,
> > +                  (long unsigned int *) target2,
> > +                  nbits);
> > +}
> 
> Hm, getting rid of unreadable casts is a valid case.
> 
> I'll be OK with this but maybe the real solution is to introduce such
> helpers into <linux/bitmap.h>?

Hmmm.  We'll give that some thought.  Thought I'd like to get the RMI4 driver nailed down, just to keep the area of change small.  Once we've got all the kinks worked out here, we'll look at bitmap.h helpers.

> 
> (...)
> 
> > +static int process_interrupt_requests(struct rmi_device *rmi_dev)
> > +{
> > +       struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
> > +       struct device *dev = &rmi_dev->dev;
> > +       struct rmi_function_container *entry;
> > +       u8 irq_status[data->num_of_irq_regs];
> 
> Looking at this...
> 
> What does the data->num_of_irq_regs actually contain?
> 
> I just fear that it is something constant like always 2 or always 4,
> so there is actually, in reality, a 16 or 32 bit register hiding in there.
> 
> In that case what you should do is to represent it as a u16 or u32 here,
> just or the bits into a status word, and then walk over that status
> word with something like ffs(bitword); ...

Nope, it's not constant.  In theory, and RMI4 based sensor can have up to 128 functions (in practice, it's far fewer), and each function can have as many as 7 interrupts.  So the number of IRQ registers can vary from RMI4 sensor to RMI4 sensor, and needs to be computed during the scan of the product descriptor table.

> 
> (...)
> 
> > +static int standard_resume(struct rmi_device *rmi_dev)
> 
> Standard eh?
> 
> Atleast prefix with rmi4_*...

Ooops - we excised the Android based stuff, but forgot to change that function name.


> 
> > +static int rmi_driver_suspend(struct device *dev)
> > +{
> > +       struct rmi_device *rmi_dev = to_rmi_device(dev);
> > +       return standard_suspend(rmi_dev);
> > +}
> > +
> > +static int rmi_driver_resume(struct device *dev)
> > +{
> > +       struct rmi_device *rmi_dev = to_rmi_device(dev);
> > +       return standard_resume(rmi_dev);
> > +}
> 
> If all these two are doing are to call another function with almost
> the same name, what is the point? Just sink the code from
> "standard_suspend()" and "standard_resume()" into these
> functions and remove a pointless layer of abstraction.

Good point.


> 
> Apart from this the core driver looks good to me.
> 
> (...)
> 
> > diff --git a/drivers/input/rmi4/rmi_driver.h
> > b/drivers/input/rmi4/rmi_driver.h
> (...)
> 
> > +#define simple_show_union_struct(regtype, propname, fmt)\
> > +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(struct device
> > *dev,\ +                               struct device_attribute *attr,
> > char *buf) {\ +       struct rmi_function_container *fc;\
> > +       struct FUNCTION_DATA *data;\
> > +\
> > +       fc = to_rmi_function_container(dev);\
> > +       data = fc->data;\
> > +\
> > +       return snprintf(buf, PAGE_SIZE, fmt,\
> > +                       data->regtype.propname);\
> > +}
> 
> OK I see the point, but is there really no other way to do this than
> to #define huge static inlines like these? Is it really not possible to
> create just generic functions instead of going this far?
> 
> (same comment for all)

We tried generic functions previously, and it wound up really really ugly.  We'd be willing to look at it again, though, since this isn't real beautiful either.  If you've got an example implementation in mind. a pointer would help a great deal.

> 
> > +union pdt_properties {
> > +       struct {
> > +               u8 reserved_1:6;
> > +               u8 has_bsr:1;
> > +               u8 reserved_2:1;
> > +       } __attribute__((__packed__));
> > +       u8 regs[1];
> 
> I don't understand what this union is trying to achieve.
> 
> regs[1] does not look right considering what you're trying to
> achieve. Since the above fields require a regs[2] (9 bits!)
> to be stored. Maybe write out what you're trying to do here
> so I can understand it? (If everyone else in the world gets
> it immediately, it's maybe me that need fixing instead...)
> 
> Apart from these remarks it's looking real nice now!

I only count 8 bits there, unless there's something about packing I'm not aware of.  Is there something else you found confusing about the union?




