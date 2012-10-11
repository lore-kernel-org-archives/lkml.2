Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2JKIN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:13:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35840 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab2JKINz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:13:55 -0400
Date: Thu, 11 Oct 2012 01:13:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <Cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
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
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
Message-ID: <20121011081351.GA32175@core.coreip.homeip.net>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-3-git-send-email-cheiny@synaptics.com>
 <CACRpkdZ0cQPQHDCYiyQb+Qb_8nGh=4rw2CixKgAFvb-3c1LpSg@mail.gmail.com>
 <BFABBC009FBA1C43B207B15FD485ABD922C22C06@USW-MAIL1.synaptics-inc.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BFABBC009FBA1C43B207B15FD485ABD922C22C06@USW-MAIL1.synaptics-inc.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 04:15:56AM +0000, Christopher Heiny wrote:
> On Thursday, October 11, 2012 02:21:53 AM you wrote:
> > On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
> 
> > 
> > > +
> > > +/** This is here because all those casts made for some ugly code.
> > > + */
> > > +static void u8_and(u8 *dest, u8 *target1, u8 *target2, int nbits)
> > > +{
> > > +       bitmap_and((long unsigned int *) dest,
> > > +                  (long unsigned int *) target1,
> > > +                  (long unsigned int *) target2,
> > > +                  nbits);
> > > +}
> > 
> > Hm, getting rid of unreadable casts is a valid case.
> > 
> > I'll be OK with this but maybe the real solution is to introduce such
> > helpers into <linux/bitmap.h>?
> 
> Hmmm.  We'll give that some thought.  Thought I'd like to get the RMI4
> driver nailed down, just to keep the area of change small.  Once we've
> got all the kinks worked out here, we'll look at bitmap.h helpers.

The question is why you are using u8 for bitmaps instead of doing
DECALRE_BITMAP() and using it instead? Then you would not need silly
wrappers around existing APIs.

> 
> > 
> > (...)
> > 
> > > +static int process_interrupt_requests(struct rmi_device *rmi_dev)
> > > +{
> > > +       struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
> > > +       struct device *dev = &rmi_dev->dev;
> > > +       struct rmi_function_container *entry;
> > > +       u8 irq_status[data->num_of_irq_regs];
> > 
> > Looking at this...
> > 
> > What does the data->num_of_irq_regs actually contain?
> > 
> > I just fear that it is something constant like always 2 or always 4,
> > so there is actually, in reality, a 16 or 32 bit register hiding in there.
> > 
> > In that case what you should do is to represent it as a u16 or u32 here,
> > just or the bits into a status word, and then walk over that status
> > word with something like ffs(bitword); ...
> 
> Nope, it's not constant.  In theory, and RMI4 based sensor can have up
> to 128 functions (in practice, it's far fewer), and each function can
> have as many as 7 interrupts.  So the number of IRQ registers can vary
> from RMI4 sensor to RMI4 sensor, and needs to be computed during the
> scan of the product descriptor table.

Is it a good idea to have it on stack then? Should it be part of
rmi_device instead?

> > 
> > > +#define simple_show_union_struct(regtype, propname, fmt)\
> > > +static ssize_t tricat(rmi_fn_, FNUM, _##propname##_show)(struct device
> > > *dev,\ +                               struct device_attribute *attr,
> > > char *buf) {\ +       struct rmi_function_container *fc;\
> > > +       struct FUNCTION_DATA *data;\
> > > +\
> > > +       fc = to_rmi_function_container(dev);\
> > > +       data = fc->data;\
> > > +\
> > > +       return snprintf(buf, PAGE_SIZE, fmt,\
> > > +                       data->regtype.propname);\
> > > +}
> > 
> > OK I see the point, but is there really no other way to do this than
> > to #define huge static inlines like these? Is it really not possible to
> > create just generic functions instead of going this far?
> > 
> > (same comment for all)
> 

> We tried generic functions previously, and it wound up really really ugly.  We'd be willing to look at it again, though, since this isn't real beautiful either.  If you've got an example implementation in mind. a pointer would help a great deal.

You just need to wrap around a custome structure around struct
device_attribute and then you shoudl be able to use generics. If you
look into trackpoint.c you should gett the idea.

Thanks.

-- 
Dmitry
