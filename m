Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab2JKDjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:39:46 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:28011 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab2JKDjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:39:43 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 10 Oct 2012 20:06:48 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
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
Subject: RE: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Thread-Topic: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Thread-Index: AQHNo3hc5XW/z7cpP0CALRtkIzq7N5exEeCAgAJrT+M=
Date: Thu, 11 Oct 2012 03:41:41 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922C22BC4@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-2-git-send-email-cheiny@synaptics.com>,<CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
In-Reply-To: <CACRpkdZb+LOk8v0aNZuPhATjS5jv-h1JJCejoh_9eFZ_fdiZQA@mail.gmail.com>
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
> On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
> > As requested in the feedback from the previous patch, we've documented the
> > debugfs and sysfs attributes in files in
> > Documentation/ABI/testing.  There's two files, one for debugfs and one
> > for sysfs.
> 
> This is a massive improvement! Atleast as far as I've read... If you fix the
> below remarks I think I'm ready to accept this file, but that's just me and
> doesn't say anything about what Dmitry et al will comment on...

Thanks!  See my comments below.

> 
> (...)
> 
> > +  The RMI4 driver implementation exposes a set of informational and
> > control +  parameters via debugs.  These parameters are those that
> > typically are only
> s/debugs/debugfs
> 
> (...)
> 
> > +          comms_debug - (rw) Write 1 to this dump information about
> > register +                  reads and writes to the console.  Write 0 to
> > this to turn +                  this feature off.  WARNING: Imposes a
> > major performance +                  penalty when turned on.
> > +          irq_debug - (rw) Write 1 to this dump information about
> > interrupts +                  to the console.  Write 0 to this to turn
> > this feature off. +                  WARNIG: Imposes a major performance
> > penalty when turned on.
> Hm. Usually we control dynamic debug prints by standard kernel
> frameworks, can you tell what is wrong with this and why you need
> a custom mechanism? See the following:
> Documentation/dynamic-debug-howto.txt
> http://lwn.net/Articles/434833/

The current arrangement was arrived at after some discussion with customers.  Originally we went with the Kconfig based approach you suggested in August.  However, the response from our guinea pigs, um, very helpful test customers, was "AAAAAAAggh! Too complicated and too static!!"  As a result we explored alternatives.  The dynamic debug interface was considered, but it is usually disabled in our customer's kernel configurations, even during development.  In the end, we arrived at some simple debugfs on/off switches for the more verbose features (like comms_debug and irq_debug, above).

If this is a deal-breaker, I can go back to the customers and see if they are willing to consider enabling dynamic debug during prototyping and development.

> 
> (...)
> 
> > +++ b/Documentation/ABI/testing/sysfs-rmi4
> 
> (...)
> 
> > +          chargerinput ... (rw) User space programs can use this to tell
> > the +                  sensor that the system is plugged into an external
> > power +                  source (as opposed to running on
> > batteries).  This allows +                  the sensor firmware to make
> > necessary adjustments for the +                  current capacitence
> > regime.  Write 1 to this when the +                  system is using
> > external power, write 0 to this when the +                  system is
> > running on batteries.  See spec for full details.
> I remember discussing in-kernel notifiers for this. I don't
> really see the point in tunnelling a notification from the drivers/power
> subsystem to the drivers/input subsystem through userspace for
> no good.
> 
> It's no blocker though, I don't expect you to fix this as part of
> this driver submission.
> 
> Maybe Anton can comment?

Hmmm.  I agree that it'd be good to avoid looping through userspace.  But....

I found ways to notfiy the kernel that the charger is plugged/unplugged, but that's only useful if you're a battery charger device driver.  I also found ways for userspace to get notification of charger events.  I didn't spot any way for in-kernel drivers to get notification of such events.  Perhaps I'm not looking the right places, though - can you provide a pointer?

> 
> (...)
> 
> > +          interrupt_enable ... (ro) This represents the current RMI4
> > interrupt +                  mask (F01_RMI_Ctrl1 registers).  See spec
> > for full details.
> What does the userspace have to do with this stuff? Seems way
> too low-level, but whatever.

It's primarily used in hardware prototyping and bring up.  Perhaps it belongs in debugfs in that case.

> 
> (...)
> 
> > +          sleepmode ... (rw) Controls power management on the
> > device.  Writing +                  0 to this parameter puts the device
> > into its normal operating +                  mode.  Writing 1 to this
> > parameter fully disables touch +                  sensors and similar
> > inputs - no touch data will be reported +                  from the
> > device in this mode.  Writing 2 or 3 to this device
> > +                  may or may not have an effect, depending on the
> > particular +                  device - see the product specification for
> > your sensor for +                  details.
> 
> Usually power management is controlled from kernelspace, but no
> big deal, maybe userspace knows even more details in some
> cases.

Well, in some cases userspace does think it knows more :-).  This one should definitely stay in sysfs.

> 
> > +          unconfigured ... (ro) This is the opposite of the configured
> > bit, +                  described above.
> 
> So why is it needed? Isn't it implicit from the "configured" property
> if this is 0 then  it's unconfigured? Seems superfluous.

You're right - we can omit one of them from sysfs as currently implemented.

> 
> (...)
> 
> > +++ b/include/linux/rmi.h
> 
> (...)
> 
> > +#ifdef CONFIG_RMI4_DEBUG
> > +#include <linux/debugfs.h>
> > +#endif
> 
> Don't include it conditionally, always just include it whether
> you use it or not.
> It doesn't hurt, and doesn't cause compile problems.
> 
> (...)

Will fix.  I won't re-comment on the other places where you call out this sort of #ifdef.

> 
> > +/**
> > + * struct rmi_device_platform_data_spi - provides paramters used in SPI
> 
> s/paramters/parameters/
> 
> > + * communitcations.  All Synaptics SPI products support a standard SPI
> 
> s/communitcations/communications
> 
> > + * @cs_assert - For systems where the SPI subsystem does not control the
> > CS/SSB + * line, or where such control is broken, you can provide a
> > custom routine to + * handle a GPIO as CS/SSB.  This routine will be
> > called at the beginning and + * end of each SPI transaction.  The RMI SPI
> > implementation will wait + * pre_delay_us after this routine returns
> > before starting the SPI transfer; + * and post_delay_us after completion
> > of the SPI transfer(s) before calling it + * with assert==FALSE.
> 
> Hm hm, can you describe the case where this happens?
> 
> Usually we don't avoid fixes for broken drivers by duct-taping
> solutions into other drivers, instead we fix the SPI driver.
> 
> I can think of systems where CS is asserted not by using
> GPIO but by poking some special register for example, which
> is a valid reason for including this, but working around broken
> SPI drivers is not a valid reason to include this.
> 
> (Paging Mark about it.)

I see Mark has replied - I'll address this there.

> 
> (...)
> 
> > +/**
> > + * struct rmi_device_platform_data - system specific configuration info.
> > + *
> > + * @driver_name
> 
> (...)
> 
> > +struct rmi_device_platform_data {
> > +       char *driver_name;
> 
> I don't understand what the driver name is doing in the platform
> data. The driver name should be part of the device driver struct,
> and match on dev_name(struct device *), not be passed in here.
> 
> Please explain...

This is a vestige of the old roll-your-own bus matching code.  We'll get rid of it.

> 
> (...)
> 
> > +#ifdef CONFIG_RMI4_DEBUG
> > +       struct dentry *debugfs_root;
> > +#endif
> 
> Maybe just use CONFIG_DEBUG_FS instead, it's more to the
> point?
> 
> (occurs twice)

CONFIG_DEBUG_FS might be enabled, but the customer might not desire RMI4 debugging features for some reason.

> 
> (...)
> 
> > +/**
> > + * rmi_register_phys_device - register a physical device connection on
> > the RMI + * bus.  Physical drivers provide communication from the devices
> > on the bus to + * the RMI4 sensor on a bus such as SPI, I2C, and so on.
> > + *
> > + * @phys: the physical device to register
> > + */
> 
> Don't put the kerneldoc here in the header, put it in the code.
> 
> Only documentation for structs, enums and inline functions
> go into the header files.
> 
> (Same comment for all functions.)

OK - thanks for clarification.

> 
> > +int rmi_register_phys_device(struct rmi_phys_device *phys);
> 
> (...)
> 
> > +/**
> > + * Helper function to convert a 16 bit value (in host processor
> > endianess) to + * a byte array in the RMI endianess for u16s.  See above
> > comment for + * why we dont us htons or something like that.
> > + */
> 
> So in this case it's correct to document it here, because this is an
> inline function.
> 
> > +static inline void hstoba(u8 *dest, u16 src)
> > +{
> > +       dest[0] = src % 0x100;
> > +       dest[1] = src / 0x100;
> 
> But please use arithmetic operators (I think I said this on the last
> review):
> 
> dest[0] = src & 0xFF;
> dest[1] = src >> 8;
> 
> Doing it the above way makes artithmetic look like maths, and it isn't.
> Besides it's done this way in most parts of the kernel and we're
> familiar with it.

Yes, you mentioned it previously.  I'm somewhat paranoid, though, and don't trust the shift/mask method to work correctly on big-endian machines.  If the shifts can be relied on to behave (I'm guessing the answer is "yes", since you say this idiom is used widely in the kernel), then I'll change it.

> 
> (...)
> 
> > +#ifdef CONFIG_RMI4_DEBUG
> > +/**
> > + * Utility routine to handle writes to read-only attributes.  Hopefully
> > + * this will never happen, but if the user does something stupid, we
> > don't
> > + * want to accept it quietly (which is what can happen if you just put
> > NULL + * for the attribute's store function).
> > + */
> > +static inline ssize_t rmi_store_error(struct device *dev,
> > +                       struct device_attribute *attr,
> > +                       const char *buf, size_t count)
> > +{
> > +       dev_warn(dev,
> > +                "WARNING: Attempt to write %d characters to read-only
> > attribute %s.", +               count, attr->attr.name);
> > +       return -EPERM;
> > +}
> 
> Here it looks like you're hiding a lot of stuff that should be dev_warn()?
> Consider my earlier point about dynamic debug.

In previous patch submissions, we always used these warning functions.  But in the feedback on those patches, we were asked to just make sysfs show/store NULL if the attribute is write/read only.  However, during their development process, our customers want to see the warnings if the attributes are accessed incorrectly.  So we made these warnings a debug option.
